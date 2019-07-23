Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A360721EF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392275AbfGWWD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:03:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389193AbfGWWD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:03:57 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6NM30ca026049;
        Tue, 23 Jul 2019 15:03:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gKGEDGV09R04ugSCizIBfhQ28Z5cdupkssLErPND01M=;
 b=KhJZxS5hwzUNC37j8pmDyW+eHXnU9+Kgp6/RlCh6JMJ+Wh9tiOqnfsbDbS7uFirH1Dd/
 C1Q04JpDWwtj7c57SZU9sMZhizNDGXmqyBcikUTFpP8Mw0H4r12jY9u/QGoTk/njRxgC
 6mL81rHEegN0SfL+mkH7yus24E+rQo9s+UY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tx60ts9fd-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jul 2019 15:03:38 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 15:03:37 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 15:03:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEVKbOVWiHp8Y31rLUSM3Pl0YX9sePGfve7on3I7H7VMqCkqVHQBcCAsZnmM/+0hZ2aoeRNSLTFbtMJd76HiXCV7HgNJf/9pITnXgrVZI6DLWJSHXwcKdC2NLJloLu35ycMSnSgJXiUMTRVfFG85kADV3dgH2KNdxd9RvLbyjA8zVhsFOdnaa6iyWwA8ChInyyPn74xizmsNhK4EDhgzPKHxD7vBAdHNxI3hZnuRzbkq1X1tNk8jwcTz5spM5p+pmT7EpacLSxxcbkn3G/Cz7Xt1CGfE596rGRp94ldkb/rqDAbfz0H7+DR+Dsxvr0v7ZeCf14EnpMa9evxUb2K6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKGEDGV09R04ugSCizIBfhQ28Z5cdupkssLErPND01M=;
 b=LfcmrBTXEKFYGaRvx8GQFnskQl1nCcWmNfomoZ0AbP/+vtrBhZmwpwXRKZjnB3KjeMQRDdtHFLvCULYFRo97wkowXT2LJOjJm+2xRxUcLmrDKmQ0t5/MEIw/4v9UqXJS6wh5UyEFoYBYmz5HfdOdyikKyl9JgJfCSZkgRWwCMXcNvOdDuK6HMrvSM7H+sM5LFNGIMdhf5zk4818wchJCYf4fWY5kX7xr5zHR1G8TG9VjFfc7WoeXBWfmpqQaFkGD7jNT8aQ3nWJkYnySazZUXv8RHGCaBZoWZxiTc+koud1X79x4IC7kNjBR1Gmyr9vQ1KyDiEgvnVjcsFwLxSdsOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKGEDGV09R04ugSCizIBfhQ28Z5cdupkssLErPND01M=;
 b=M5iEzzphbqpEbgXkWyWX1nXl4P4S4VA/9KFzm5rLd7tBNEYacq1dSyywbL+6cHEfdMdQs9IKnmtk6cYCwt7cGvf5KJiU1Qpx0teyTTBAVF+YRlIrZw67p9ozLxBd4rVTYM3+cnADUoArBOXe7Q/y47NS02Swsr41rm5dGh0JpZI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1150.namprd15.prod.outlook.com (10.175.8.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 22:03:35 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 22:03:35 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: provide more helpful message on
 uninitialized global var
Thread-Topic: [PATCH v2 bpf-next] libbpf: provide more helpful message on
 uninitialized global var
Thread-Index: AQHVQZtDv65lZdIEOkaJWoCh82tX66bYwboA
Date:   Tue, 23 Jul 2019 22:03:35 +0000
Message-ID: <08DD65ED-34B4-47C0-B5ED-9A354CF5BA35@fb.com>
References: <20190723211133.1666218-1-andriin@fb.com>
In-Reply-To: <20190723211133.1666218-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:bd93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 686a4e07-3930-4ca1-7e60-08d70fb99c0a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1150;
x-ms-traffictypediagnostic: MWHPR15MB1150:
x-microsoft-antispam-prvs: <MWHPR15MB1150E3BDF6E635ADF7E3F11FB3C70@MWHPR15MB1150.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:15;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(68736007)(6506007)(86362001)(54906003)(6486002)(6636002)(99286004)(37006003)(6116002)(2616005)(446003)(76176011)(11346002)(6862004)(2906002)(6246003)(476003)(33656002)(53546011)(25786009)(53936002)(186003)(66946007)(15650500001)(50226002)(66446008)(64756008)(66556008)(6436002)(6512007)(4326008)(46003)(76116006)(81166006)(102836004)(81156014)(8936002)(14444005)(14454004)(66476007)(7736002)(486006)(5660300002)(57306001)(478600001)(229853002)(71190400001)(36756003)(316002)(71200400001)(8676002)(256004)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1150;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UTKDB5+SYxEfqE6OuSk9k7Ftw9LrJq7B4y0LMaGUdIG1MfYPFUBQzQCifB2C+QTv04Ie696CLfxqjXmJg9sUgHNKcselqRsFWRn+lunSp1ObihRSLY2atvpvi/oCw3GL/SgaXzTkv5IwJOs5cmpWI0uH4J/AkebUbJUwryrbvyVUTjvf8bsCAJ5/ulYuV0w9xANX2SNGn3g0kQVHWFuWejZuiFxaURUvbdRPMfQCNDTtYfJEwCX83nYfBbToFHNB9MTfAym9CNRLINvkhlk1sxn3mc2xpL5P00DXhvYeAvm5X8oInpHz3549iscvmV6uGXFVLVGEYalngYXDsndAkb7PGV5buqhBwaoIh9lUN3G8MyFe68nEIjyh+lSubb2hR2/9wUPh9Z/QIO1Hm9zFJCzWjkjNXfXDokLR87dfgKM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F26B80E7C557FF41A8DC7405BAFA98F0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 686a4e07-3930-4ca1-7e60-08d70fb99c0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 22:03:35.6073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1150
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=911 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230223
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 23, 2019, at 2:11 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> When BPF program defines uninitialized global variable, it's put into
> a special COMMON section. Libbpf will reject such programs, but will
> provide very unhelpful message with garbage-looking section index.
>=20
> This patch detects special section cases and gives more explicit error
> message.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/lib/bpf/libbpf.c | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 794dd5064ae8..8741c39adb1c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1760,15 +1760,22 @@ bpf_program__collect_reloc(struct bpf_program *pr=
og, GElf_Shdr *shdr,
> 			 (long long) sym.st_value, sym.st_name, name);
>=20
> 		shdr_idx =3D sym.st_shndx;
> +		insn_idx =3D rel.r_offset / sizeof(struct bpf_insn);
> +		pr_debug("relocation: insn_idx=3D%u, shdr_idx=3D%u\n",
> +			 insn_idx, shdr_idx);
> +
> +		if (shdr_idx >=3D SHN_LORESERVE) {
> +			pr_warning("relocation: not yet supported relo for non-static global =
\'%s\' variable in special section (0x%x) found in insns[%d].code 0x%x\n",
> +				   name, shdr_idx, insn_idx,
> +				   insns[insn_idx].code);
> +			return -LIBBPF_ERRNO__RELOC;
> +		}
> 		if (!bpf_object__relo_in_known_section(obj, shdr_idx)) {
> 			pr_warning("Program '%s' contains unrecognized relo data pointing to s=
ection %u\n",
> 				   prog->section_name, shdr_idx);
> 			return -LIBBPF_ERRNO__RELOC;
> 		}
>=20
> -		insn_idx =3D rel.r_offset / sizeof(struct bpf_insn);
> -		pr_debug("relocation: insn_idx=3D%u\n", insn_idx);
> -
> 		if (insns[insn_idx].code =3D=3D (BPF_JMP | BPF_CALL)) {
> 			if (insns[insn_idx].src_reg !=3D BPF_PSEUDO_CALL) {
> 				pr_warning("incorrect bpf_call opcode\n");
> --=20
> 2.17.1
>=20

