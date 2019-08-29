Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893E1A295C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfH2WEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 18:04:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26510 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbfH2WEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 18:04:39 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7TM3Qju027436;
        Thu, 29 Aug 2019 15:04:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6j9OHNdxrL6U69XNa2Jz8V42eC/LEFW8hLkEq9mofRo=;
 b=N7i3L456Y1qsdhmZdUrvar2BlfJPuF9CRjF1vasYh6IVXPIFa7amQO/YC7oWjPuaQo54
 gf03L5XfIRJNWJYxhGoj3gphYB0F8SO/sRsJSDyQAWXNSOM1f4o51O+vyx6wGVIRQArI
 R5QRKavFDqLFJ4az9tSVqdPceMhVz97A3Vc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2upfdvan8e-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Aug 2019 15:04:16 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 15:04:11 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Aug 2019 15:04:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gj6JdjUdCrNdbYTL9E2/5qIl5RO5REx4H05Mj4wYvQpKwQkQa4q+SG5u/NnVuD2bN6Tbr0Th2ChjXUx/OyosgfiYXwCuNquz+v6/QWQcF2/DKjAQjtRKH/cpfAT6QxU0lmFLH2ja5g6joPe7uP7b21dIcz9w5lVVkdKMTQWEee+gaInotr016OkD90wUAPfERbD9D5YpmQQQQFu0SjzWtFOrAAzHEZsTq5y3npmWp0qQEvr7ac6yPeZlaDgKMTrSvw/ZkpRGi+Ja+piQgDviFOvO4kyhB+jNpfWJvW8/7CImhABm7BG16z6/GCnK/6IzBHiBqU+Tkbgdbp1h8FaL2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j9OHNdxrL6U69XNa2Jz8V42eC/LEFW8hLkEq9mofRo=;
 b=kjCkxkjIfHI01LX5DOheRkGoRAevx/n3euP3CXgAQVN5J7aBT96PO6WQ67Hoim4iPW1WdtI5uvFp4GrE1jPF3Tukr06pE+FB2CyLwSR28WvSwZZp47aXNtgg1BNKGC4QsPbeIqz9y8ayK/zPcxWulxtA2P3i4f8gXBPpGG78EQZFPkAVoNKuKYYOWPugIxlkFooVb6bMpAJTYDGUmKXmwoLppHAd4os8cSgm1vGdhiMHJsLR47Ulc6ffeUXy/yNrntMvmyG8c3k4lV7MaZzni9S8QFEGJUqTHQXWAWp1dfS1LkDc8fNe0GfA92jsOZ1L0HWWljRW6Hq5cfud18ZK/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j9OHNdxrL6U69XNa2Jz8V42eC/LEFW8hLkEq9mofRo=;
 b=iUvmWUZ6CmTXW9dknjgamM4VSzUgXhPlHeK/xGpvN9Oyr9Mleck8CV706YnaHRuvE7qj8aVICR8A7nt97ag9q3TcdF/V3FjMwDVx8GarQMVjUPQWOD9whWE7fBL/70j8jvB4U1UGHmkRTh5hlJJbq5VWtBv1lfegZfXhOu4Ui6o=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1775.namprd15.prod.outlook.com (10.174.255.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 22:04:10 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 22:04:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 01/13] bpf: add bpf_map_value_size and
 bp_map_copy_value helper functions
Thread-Topic: [PATCH bpf-next 01/13] bpf: add bpf_map_value_size and
 bp_map_copy_value helper functions
Thread-Index: AQHVXjVRHUTlANX960mFdvHLqfQdRacSrvKA
Date:   Thu, 29 Aug 2019 22:04:10 +0000
Message-ID: <2DB6B840-9EF6-483D-8570-4BB9EB74F3DA@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829064502.2750359-1-yhs@fb.com>
In-Reply-To: <20190829064502.2750359-1-yhs@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:3161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b880ccb0-96ef-44bb-5ae3-08d72cccd1fe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1775;
x-ms-traffictypediagnostic: MWHPR15MB1775:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB17754EB267D12BA96971FD79B3A20@MWHPR15MB1775.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(366004)(376002)(346002)(189003)(199004)(229853002)(71190400001)(71200400001)(4326008)(36756003)(86362001)(66556008)(66476007)(66946007)(6486002)(66446008)(64756008)(6246003)(76116006)(53936002)(6636002)(37006003)(54906003)(6512007)(6436002)(33656002)(91956017)(4744005)(2906002)(6862004)(7736002)(305945005)(50226002)(8936002)(53546011)(8676002)(81166006)(186003)(478600001)(6116002)(6506007)(102836004)(316002)(25786009)(256004)(5660300002)(14454004)(57306001)(11346002)(446003)(2616005)(46003)(99286004)(476003)(76176011)(486006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1775;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FToYaRq3N2d5goXy7pVdQaUxAQ4DloUMVn+m6DaoFCXojTr0kX/v9Jb7I85jrXrj5nsOfnacvkMkdd0GdNQiLSbdLEOuHITVnHpADCc+mKA1vdVwpEUljh3mBeQnxXSvDMWVF6ZPIzebF4xk3bfVIrGKfQkH4FOC805DwwjRlBylN79eiiKxWYV2lfHjUhbE2Ea2VhIfdta/TyctMXR4HDsKfSwjWCnQCCLhV913ell+x90YXqpvwRUWxZhSrvmaQwDkUxQ26S/4LyzqZaR/jFmwp2j3QRdu6VMxj6GC/6g+4nH9F9FJgsSlcg0fsgvTya37WzrJr/UmRSMd0dd0XmGTkW7eR+vEp7DWhv9NIIphr39OL/aJpdLGF/0B5n0QCS4Usr4Ygjjf4XBEpb9k82TY3i76Lr5XElWJ0/7wddc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C94EF4AB7407B8479023385A09B97749@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b880ccb0-96ef-44bb-5ae3-08d72cccd1fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 22:04:10.3113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cL2mLlVKtMKpdeqhpmagOo6KKVw8ZIJsAFPhW7vovRTDgSXvIf4L+f4kFjcXSNhE5OdrmYNRqPtU6ZzpxGTK2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1775
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_08:2019-08-29,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=345
 adultscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290220
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 28, 2019, at 11:45 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
> From: Brian Vazquez <brianvv@google.com>
>=20
> Move reusable code from map_lookup_elem to helper functions to avoid code
> duplication in kernel/bpf/syscall.c
>=20
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>


Acked-by: Song Liu <songliubraving@fb.com>

Yonghong, we also need your SoB.=20


