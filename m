Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF8C42E98B
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 08:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbhJOHAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:00:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36938 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235787AbhJOHAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:00:39 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19F6wWY8024075;
        Thu, 14 Oct 2021 23:58:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xk3BZTrBDT3rK/UZWKJuKLgq3Wy3alV3sonsURLGi5c=;
 b=nFQiZOqcdvth4t5P45lSX+VAxog0yRZvLuMkZk2WxrIW0dSSL1OnaJ/Rzpkg9YoErN4d
 WXYOmlKm1yUAhA2bLfdUgRWJ+o4YWs8i3C5DgFdaOqqp2vQcr0TcOAgwOnqHSWkFqc0f
 14CO1/AegoKnOLDvTICHRd4Bxe3Yma1L7v0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bq4ky01a4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Oct 2021 23:58:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 14 Oct 2021 23:58:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZD6Eq8sBQRJ8zYUKMRCOJKrE75s9SF0XHwAGWMF8WrsHWTXJYh9k93VzjWuWYvi4PAYNW/5IwFccsKHnCifVwBMikkXMXwypIBVYyPQoi7aIWzF1YfTvYkUBHTNT6qTzaUICqah98DSrVPcKuja12mzDrnVK69qtrhAk3p6jflb6fJvsfe81rSINgjJawfZa1oGwaDJ9bBTvqENMxP/8BNJIqv+wRaQgPaYnw+rCL5Dtu/bNr/9pXe3ybhSJ1rQ25/qq5mPCBFaDIDFz1MPdYGtjvM7WEAL12/1DqDmSyHe9STTlyR0hsB1ktKU8Nzt6VYC/5xfxmaC1tgQ71Hk6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xk3BZTrBDT3rK/UZWKJuKLgq3Wy3alV3sonsURLGi5c=;
 b=aKu3yA/frmjQ2y4qmNMIJ0cbm1HyMQLF2gYGH2JSPOYrGO2Dmg5acME52Kr/FvJAqEeckgVA0GksO0nxy27LOPTCDv9BjZg54ygUa6+9xRx+6xPQEdXuaevGLWUiXrYfKnKVu1BJtEkYlAu12Y/jipyirY/SNTnzL0F6RXMBZ7DpxbHHm/JknubKca6psggvuAo6dMzEF4dGypvjvsWUyX/eIwq7ynxYfn3RP+34488gJ1/ttcDnAcEnSBDqjBqzbHrbW/VO0BH8ezkpJjhUNFFwACtC5Mu07isubAFJOm1D6UMBtNXUDd0Ty42IhRIop/YVPPBZcVBaO8nhrMwImw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5235.namprd15.prod.outlook.com (2603:10b6:806:22a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 06:58:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 06:58:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 6/8] selftests/bpf: Add weak/typeless ksym
 test for light skeleton
Thread-Topic: [PATCH bpf-next v3 6/8] selftests/bpf: Add weak/typeless ksym
 test for light skeleton
Thread-Index: AQHXwT4TVKNF9yVm4kiVloooFQ5DLqvToaGA
Date:   Fri, 15 Oct 2021 06:58:29 +0000
Message-ID: <D997C301-25F9-4378-82E3-A1B072C58A6D@fb.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
 <20211014205644.1837280-7-memxor@gmail.com>
In-Reply-To: <20211014205644.1837280-7-memxor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 685e0174-33c6-409c-22dc-08d98fa93203
x-ms-traffictypediagnostic: SA1PR15MB5235:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5235C50FC4B993485110B79FB3B99@SA1PR15MB5235.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ObapEvasn91Q3Kzalr8c2pQ91EZ1qwelbjGl5HPoEiXfVANDXQSNMtP6vxF/licwbjidPJ+lcPVL3vXWG4389JVzwByitT3RUChT/YqWTlUZLexqu71JfiHCHF604MIeQuIAbHQoEceqq/QwoDAs3OXvJjlBsWOxDU4JrQzGsklrB75IAhGbc7IKPTUEYz9VIjK7KjmuoRArVNhSue1s1Zothcyskv74Eqk5a8e71M/XrC/rBhCB1y2nEetuJjvby2+37apM2riOIMAg1ugWuIxJo6LgQ4rSG6/ei7X6ylKcvfG84ki8FOeJf9XFMLLQ4hg1y23uBxjl21fweV+0qC7TtqfHLviTV7c/aaIfylAYEwnQLNKhhfnY6chyckBLlH3wB9+vxSITABQOrvXkxGDklXhxMxYIUgDY2xa46CR6nNJGjZj3L4i18TbAbuxCj7iw7JPLZGEiH74y+3hnuoSp90uaXjnGIqBIp6ebT1XICyDHxq3COIdUcYs+ZmNx6pA2030Ye/z7toadOruWjqc99H4KvStJiTEe3PBs8mD9AiRocu4GBuJxoEY1byuZsEoNI7KuhJmNeXRVw9IPIcljmYV8UShyMHC6T6AxbTOE33NJL+gdndUrmrxQ2Zgppo6J4oU6liDLEST9ZsFG7F27zn5XHmUI5WsAk71VIn0IM4Q1IVZH2sWAW3P4b7fdA+Sg9a/Q8YLHe8AzjRJbMAyUA6lA1cBWj5skbet0jIQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(71200400001)(6916009)(8936002)(122000001)(316002)(4326008)(508600001)(5660300002)(6486002)(36756003)(38100700002)(33656002)(8676002)(66446008)(38070700005)(54906003)(66946007)(66556008)(86362001)(91956017)(76116006)(186003)(2906002)(6512007)(6506007)(2616005)(64756008)(53546011)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?w1kKfGB0xcUv51ZcAybnLreCKbOEOHYSA4X3en27pb4+oBB51UfXkjZht9?=
 =?iso-8859-1?Q?Ie0+woFJp2N0aoi5SF8h+KgUdd0bHDUtcCd2U+wZxjQSdtMGnEqaQKB8fS?=
 =?iso-8859-1?Q?zdZRcnKvALgD4RHhyPZk/TIjVGyBy10ZpKPvwsykz/luSsBFIOmr0d4tIS?=
 =?iso-8859-1?Q?l3knEwLs9J2maBWPrrD+KcLNh2DjSXj0dsB5kedJbK10w3x77zfrCpA2Ik?=
 =?iso-8859-1?Q?v9f8X4jv0XPnwfEagETItrz7wfsjrZSyhwThTHYBjESC5JYpelRnetW4/a?=
 =?iso-8859-1?Q?6xmQcDG1Gh0lftWg/TEjsx56pDeJqoj2FiN4k1JEu8uq4ArvAQOxYsRG5y?=
 =?iso-8859-1?Q?VF0YLwNNeCwGGpYk3pVe7QN2qEj06CXo+rl3JzpWiQfpf/jqVsHak7R2rn?=
 =?iso-8859-1?Q?p1WRJ/rZGyDk2YIxV+cycbOO8bSKQYDW2ycPEbpdmt1Hrj5T46GNVwCCYn?=
 =?iso-8859-1?Q?s1w5zXmoOiPEu5l7Mno3q9ZhLp8QHv+pszm4raL009/Ci9168ybFDgbMZE?=
 =?iso-8859-1?Q?/XgZZlVRVzbMb6Lbke1qdEpIVvxTOTZYIiOvWcZAPYgrCHxsuSegFDMK9c?=
 =?iso-8859-1?Q?78tJlSsDBs87v7XNWYDmQ9RblPGrab8HJX+1KMSWxR/V650nZMJbwth/RK?=
 =?iso-8859-1?Q?O7PbAeeCjCBljLR/Tt7HCoZGuNlqjFhG/rqhClM2v/QBPK7f1spQVomMmv?=
 =?iso-8859-1?Q?6akz8r3HpOonHGTjRKnlZFlXrPPe5fivWe/f704MNqacpCKBCUmRmfXg/C?=
 =?iso-8859-1?Q?2yQvgtXliLtkPj0lrFXGs205PUXBWbjq85xqEWmPyv4HsgKoRXZ48mMTFk?=
 =?iso-8859-1?Q?HsephiKnFNn1cE+cGTjFRqXzquj31ay5o4cjgTRVIrrlyOLsWBxwXrbs+p?=
 =?iso-8859-1?Q?Ewp0DT5eBMq0dvQPdSwyT+6AiwkPqfLEPrCLWetlawZpUPoI0JEJ1IWSGB?=
 =?iso-8859-1?Q?sRVOv2Ed3cT+NLw/yz92Mi89EQkKK2dVN7zzyEHjzRXd0pM4tk5IK2kWkP?=
 =?iso-8859-1?Q?biD5QhUDNdnr4GVZbV5TEtAUCtUd4seIwOS6Bru0V/GhmZ5FjLCOCjxD9M?=
 =?iso-8859-1?Q?ttL/A2whTfsLeB3GlBsnW2QHhtoiMM0i8hbyhwnZd1ahX6Zc+bkbr0x4Lh?=
 =?iso-8859-1?Q?i8LjM1krzNUsy3GMVAFNb3mtKJnv2t2VyWb0lJ7T1GMt0RcxhV9zGCh2fi?=
 =?iso-8859-1?Q?m7Tk4qjeByPf1qJIAEH9WLsmkU3nJwzo4QLey+Izy2i+DquDn4SI0cYpCD?=
 =?iso-8859-1?Q?nywp0zu5w7PEMgkg3xXmsJsSabdChxni9SeV70e+d8DNKCjrh78fY39eLO?=
 =?iso-8859-1?Q?OY5vL8IG2ZKiYiAzg/N2cKjy4FezBgsbh8zQLb6dj/rqvOhICZ+LUI5TyX?=
 =?iso-8859-1?Q?CCCRuEXthgme8OUrKIlFi7wXLVO5gG0YUcUemWSZxbYDNj2EhNLcI=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <418AD1D4CB42314A9CB33C966AD746D5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 685e0174-33c6-409c-22dc-08d98fa93203
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 06:58:29.9194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zf3c41wn9CikxECk2FbzwzBEvo/0zAO9W1CAC2CCVKAnEHabyZPwtpy4bsApOqdBbn0IbIjmcrdzJ3fnkn7wqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5235
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: ElCYHbIOz28FK4zZ2tuEX19iUplEWxnk
X-Proofpoint-GUID: ElCYHbIOz28FK4zZ2tuEX19iUplEWxnk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-15_02,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110150042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 14, 2021, at 1:56 PM, Kumar Kartikeya Dwivedi <memxor@gmail.com> w=
rote:
>=20
> Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
> Include both light and libbpf skeleton in same file to test both of them
> together.
>=20
> In c48e51c8b07a ("bpf: selftests: Add selftests for module kfunc support"=
),
> I added support for generating both lskel and libbpf skel for a BPF
> object, however the name parameter for bpftool caused collisions when
> included in same file together. This meant that every test needed a
> separate file for a libbpf/light skeleton separation instead of
> subtests.
>=20
> Change that by appending a "_light" suffix to the name for files listed
> in LSKELS_EXTRA, such that both light and libbpf skeleton can be used in
> the same file for subtests, leading to better code sharing.
>=20
> While at it, improve the build output by saying GEN-LSKEL instead of
> GEN-SKEL for light skeleton generation recipe.
>=20
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

