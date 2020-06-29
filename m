Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2F720D822
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732648AbgF2TgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:36:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47574 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730437AbgF2TgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:36:20 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TGt3re027481;
        Mon, 29 Jun 2020 09:56:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qXullG9VUSDOlcxffaa8Iax5xyCbXolNPH4syXdcWP4=;
 b=mELjv7rb6O5o/YqGQ/tuLnTXbTPiauTTLQLG+23Jr58xN1kH0ZWjDdGW3J/POXvWmd5s
 8uAEr3lzQo7Z0l1YH2ElFNrHyZpiGCkFJ9X0tlcfWJEEBOCKMAEa7Mb/lPMsna1J1yla
 9tBp8Yei2zixHqY9+6WzKyRCOUSNU7fib08= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3mmfypb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 09:56:53 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 09:56:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUVi73QL2hZ7lxK7lyUHXIVblOhhCVztYJHhDCco1jo5lNHYGrPhjapv4rdpAxsNeOGKFuJrw2PN6qFBbvxLgkvMrucMPRBWPXmYcliCYwX7Z8JqgGDQcHen4EGI9dB3T4/CF8Nb2wCl1/iKd5W7egagurRfkKzzbEL3XvBS6O9BnUAVRlp7D+bK7nGRqCMtBKzKVVkZfT7VpLo3xW99yfu8kCZuizz5SDeUrtJu6YcDN7NXqzdlOkxJE/pU3sFkKA8FL3o4xXKtMW7bDzVhV3e7r0Rpfh8uycAqq6qV1fZKjA7OTW0Ul0T6CTjj5TToRb/ar/Q3lXhMxVcKAUS+CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXullG9VUSDOlcxffaa8Iax5xyCbXolNPH4syXdcWP4=;
 b=f0BgwdsFOR7SVzgd5kroWpXzv35xMQQfM9IWA3v0HeKIwRztIqVhimTgHuptHENiBkGRLERCTGdpro2STQ0Fq9lsvxDt4dveGLUjEUrJIjqfM+UwgJgdCS1LnizCUQy0Iy0pQpD5Sa0gg7lNIH3ML7HnnEd5bAYowsHG7JvZVh6Z6nhEN1cTn4mdSc1HicjmYzmFXBw3G8wizt5IjpMLgKOCUyIwOBNCy87KJ4fNKMrX8xhmqwh8rKwbpkQeOjmcrf41xAzEG4DocSTjQdITxFKcxSXds+Zje7msyEEblQ8TDnXHh+mGLJnsctm5tf+d3M69LETli25yAeypUuoO6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXullG9VUSDOlcxffaa8Iax5xyCbXolNPH4syXdcWP4=;
 b=CcaOcIk4B6JDzf3U/7zMQNOsNglOjjcgeN6iH1/F4ySt4L0KWL8RuIKhS0Hy0kJAhAwzt1uLYhT4UE+w6Dp5ZsnyWXwirehdNJHBdpEeigdDyYq8h0G7KQaiTQLlAovsC+ri8rfo0/+i7MGcIM0HrzkSH9GlIyzpu9hCdPmaKqs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Mon, 29 Jun
 2020 16:56:52 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 16:56:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH v4 bpf-next 4/4] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack()
Thread-Topic: [PATCH v4 bpf-next 4/4] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack()
Thread-Index: AQHWTdoDfCOX11YGIkGMqBxDcia9fajvsh+AgAAevoA=
Date:   Mon, 29 Jun 2020 16:56:52 +0000
Message-ID: <D3BAF0B3-122D-409C-B0DD-600E1EE606C0@fb.com>
References: <20200629055530.3244342-1-songliubraving@fb.com>
 <20200629055530.3244342-5-songliubraving@fb.com>
 <bd62a752-df45-8e65-9f74-e340ef708764@fb.com>
In-Reply-To: <bd62a752-df45-8e65-9f74-e340ef708764@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c091:480::1:2b35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff34af05-3303-4aec-c487-08d81c4d6c04
x-ms-traffictypediagnostic: BYAPR15MB4088:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB40880E0CC89213D4858D6D21B36E0@BYAPR15MB4088.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: duz5jXhrS5DEGunREhPj1UPvEwPn0RLITMIJJJPipvKXtMfbjfokAZeuYtYlvv+BunpNCJd+xghE7/+K951pWepp1Q4cTLqkgoODruzjtVGh8oZCiE8kIIH2hAKRugBbU8oYEmH/nKpXrlvMwk24+rzkqfSEOm3awk4bRWMWXHVh08hSL6p93oljWcGwTdIIttRGmTPVoDHi6QTNYVXz2AALOK5KmGC6E0I/2dIPddC3ALm4slP3iiBQxyVEDhAb/TEJ4ND1k6lNXaAJRwkYVGlN45DZem9yle4r/Qj7451MOgKQVE/jImzrbIKRBH3JbF8GTFerLG/sPNYfxsWerA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(366004)(39860400002)(346002)(376002)(6486002)(37006003)(54906003)(36756003)(6862004)(6512007)(86362001)(2616005)(4326008)(478600001)(316002)(8936002)(2906002)(6506007)(33656002)(53546011)(66476007)(66556008)(64756008)(71200400001)(5660300002)(66946007)(8676002)(76116006)(186003)(6636002)(66446008)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7AWQG/ZHrFRVDkuvJBfp/mU4k+v8LTvzU6H1RNCJu7IkA/8kgR6+/36SnYRsujXs85BnpdlGAtKLvzzpKlVXZPByK8Nrr2EtlgaAqherJd+9ai0vEw4yVtnLC3o01zRqHOgZSvLVieYBaLpGDqCqt2i39YGOcwjQfk9o9wVz8BZnJpNN3UVD2H4rYjY+8Js0ehg5nBa/2ZmL9lbYjskMnCIlmpeAhIU76LQZhwzx/SSUb0EE3Pfl2bAtnc3srztbIUcZFBzQobB8K+x8ULI56vCps0tQM0ne2n43tbfQ99Km5Mkh605KOgpUvMMAtydH0UNoHjqYcyFzct4LftU/4BKM0yJ0QFxKAIwej+0dzPjWfTo5i8aSXnPiiVbfuwRwUkV0dRlEKdNADbbw/6x0gvbA4Hs6BRGX7jEEzIAYnLFKpotofaJ5In+FyYqe4gfzY2Z8/QVrciyiDf0ZwEYAXhVy8i1Mkc16DIOkp0wdi7DmkBT38EmdlRVhV62EGRkbeu7my08VxToysqQP03BLPg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D65D069ED4CCB34BB8A9545E6242AB29@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff34af05-3303-4aec-c487-08d81c4d6c04
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 16:56:52.2336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7DWS3t/1AqOiETwg+wBN7+VHT/9FMJQoU9cQ6u4mzq9iGxRPfYPq7WrwvXdXysk13nmG9fDdqM8vVIkA4b0aBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4088
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_18:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 cotscore=-2147483648 spamscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006290109
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 29, 2020, at 8:06 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 6/28/20 10:55 PM, Song Liu wrote:
>> The new test is similar to other bpf_iter tests. It dumps all
>> /proc/<pid>/stack to a seq_file. Here is some example output:
>> pid:     2873 num_entries:        3
>> [<0>] worker_thread+0xc6/0x380
>> [<0>] kthread+0x135/0x150
>> [<0>] ret_from_fork+0x22/0x30
>> pid:     2874 num_entries:        9
>> [<0>] __bpf_get_stack+0x15e/0x250
>> [<0>] bpf_prog_22a400774977bb30_dump_task_stack+0x4a/0xb3c
>> [<0>] bpf_iter_run_prog+0x81/0x170
>> [<0>] __task_seq_show+0x58/0x80
>> [<0>] bpf_seq_read+0x1c3/0x3b0
>> [<0>] vfs_read+0x9e/0x170
>> [<0>] ksys_read+0xa7/0xe0
>> [<0>] do_syscall_64+0x4c/0xa0
>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> Note: To print the output, it is necessary to modify the selftest.
>=20
> I do not know what this sentence means. It seems confusing
> and probably not needed.

It means current do_dummy_read() doesn't check/print the contents of the=20
seq_file:

        /* not check contents, but ensure read() ends without error */
        while ((len =3D read(iter_fd, buf, sizeof(buf))) > 0)
                ;

>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>=20
> Acked-by: Yonghong Song <yhs@fb.com>

Thanks!

[...]

