Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4FF11C024
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLKWvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:51:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29754 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbfLKWvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:51:15 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBMm1Zj021407;
        Wed, 11 Dec 2019 14:51:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=T3TIIz93Tk9QjEtiAOKVC3YiuRjJr2rqRvJ1KxV9Rkg=;
 b=nvEu6/dstDC2HMyawNe/d+JbmQ3R/bn52ymNDcXFhXkFxEjF5iAreQclpxm7cGUHTDnS
 LeJD4oEr/2dMEhV1N3BMMOQ73ijpeJC38Q/NnrXLltuw69YYKc61mfGcX/45qkDp60Uh
 /EeRaX3uB/RXClxggIyajp7+UMEdmt7wHw8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu87qgbtg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 14:51:00 -0800
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 14:50:59 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 14:50:59 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Dec 2019 14:50:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhwKN6eXO8X4rM5IGH2yH9MKKkYxtY1zzWE5LWTb0z2HHSh/8dYm0B2323hSIGcsq9AHf2n2vtzoXsMYZTQl5BicLZB5rtzBDiuaGrf2NfTXWIdvDr+lXXc3uqQa7D6rlZfaN66FTudbqJx6/QgFDWYsaLZ+fkr+d6aXUIpns0g6dyaqYKOV+wHxNGiP5B7iwOUNG+WQh9FjAaaqAmSY7tfB0Qfd1OrEDik4yUkrYVh69TUsD5ZP4nsBva85PJBAJOdxQKaQRLjLjR8TTge4cEFEeRIWztDVE/vPdsTmKtiRlNQaO8CIFJWvKvrxWhJcpqdIg/SbTVgpPiGi7FR88g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3TIIz93Tk9QjEtiAOKVC3YiuRjJr2rqRvJ1KxV9Rkg=;
 b=jJYl3CaXiV6wAh19tcJFtCcBBhp4+cGwZ8INZvso70++4/zhX8lfAPvbI+gOL+PRsLIvzJURAM4yFkoLeCjjK06jmc5KvEEemkoBRt1SKqys8AwspsVCiGSYCVjkgTH9lfUC88BaUId7Ydl1vBIDQ4kq8jy/7Konu6QWTNQD5q4VYiVgy7DxF4A56M/3j08GA8oFEJYOhltnBWAqPMSU6OrvEIlBZNsPW6YoyOPv0zJ+GA+k9nr584rn1sZcW+9iCotlUy5KG0mWUv/KHrWpwhJaUfccCDI+2bd06aCnPyyFfChyHwHQnlvQi4xmh/X89dctu5lLKsQJVFbYQoWUaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3TIIz93Tk9QjEtiAOKVC3YiuRjJr2rqRvJ1KxV9Rkg=;
 b=eqqSJfjXNv8m0raLEg3CedYusghYMqD0SMs9eAQbG5UEDrihuyLsIH2PTKWxMZVq9BNT96erD8+1YMWPPtFf5yx593x8GVZp9irDhw+FCahZZb52yPcawyxKL8I7TC3+PeG8FBmJjnyql4MKsOhWJX268SB+XVDDcp2yDNRtbZU=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2543.namprd15.prod.outlook.com (20.179.145.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Wed, 11 Dec 2019 22:50:57 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 22:50:56 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 11/15] bpftool: add skeleton
 codegen command
Thread-Topic: [Potential Spoof] [PATCH bpf-next 11/15] bpftool: add skeleton
 codegen command
Thread-Index: AQHVrvdWTxFntEtem0yg2Bw2btWW56e1jPIA
Date:   Wed, 11 Dec 2019 22:50:56 +0000
Message-ID: <20191211225052.se2yyk4j5fpt2fdp@kafai-mbp>
References: <20191210011438.4182911-1-andriin@fb.com>
 <20191210011438.4182911-12-andriin@fb.com>
In-Reply-To: <20191210011438.4182911-12-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:300:ee::33) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ee78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6603b85-731d-4609-6b07-08d77e8c952c
x-ms-traffictypediagnostic: MN2PR15MB2543:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2543059CF216D5FA7D87E9EDD55A0@MN2PR15MB2543.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(189003)(199004)(52116002)(2906002)(6506007)(186003)(71200400001)(8676002)(1076003)(8936002)(81156014)(86362001)(66446008)(66476007)(9686003)(6636002)(6512007)(4326008)(66556008)(6486002)(5660300002)(6862004)(498600001)(81166006)(64756008)(66946007)(54906003)(33716001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2543;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6DiSfMZdOlsdSKXyTO23y9L+FBlq2X3bbRwI7vI8+hrRkn/udzXq65kpW+GtM40CLSb6a9WWfLaztia4B/AJSvcflBl/hONpAoUp99zOG8DPqtZhf1z3XiDQNG64WOZJUV5oxd9dsZ1RyuNbj0f1dyrGKfgRzPsQO8raWTSvOAyv0e8oG0Zsnye+EwVRwO//SB90F/g8nLYSXuqC0D++p4SMgk+vY67Cb0Oo6PjvF/azlxaTRT1Nx80zwAoZtKSQzz2KQdP7EZSAop+8cGRo/SpbxQQp4Xjsob0TCVcEI3E9yfvz1EDspPk2i5ehxgshHYGhxrw+aw3ILKwdlCaxk/g426LROwYuErxwrjP8HowBo4bRYJS1ux8O1iSQYldgSfZqj6lCjkiwPb+WlFodVDporOnAxuJpfV4QwO24tpgmyamCoYfalnumnkXRUUtC
Content-Type: text/plain; charset="us-ascii"
Content-ID: <91682D9EE4230A49B4EAE26E33436353@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a6603b85-731d-4609-6b07-08d77e8c952c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 22:50:56.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iKEcOupmQqVWCG4J9QUriBIHn9Bhk/NyF1ZvsdyIa9NQzPAmOBc/EtrLOQGeA3bB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2543
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 mlxscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912110179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 05:14:34PM -0800, Andrii Nakryiko wrote:
> Add `bpftool gen skeleton` command, which takes in compiled BPF .o object=
 file
> and dumps a BPF skeleton struct and related code to work with that skelet=
on.
> Skeleton itself is tailored to a specific structure of provided BPF objec=
t
> file, containing accessors (just plain struct fields) for every map and
> program, as well as dedicated space for bpf_links. If BPF program is usin=
g
> global variables, corresponding structure definitions of compatible memor=
y
> layout are emitted as well, making it possible to initialize and subseque=
ntly
> read/update global variables values using simple and clear C syntax for
> accessing fields. This skeleton majorly improves usability of
> opening/loading/attaching of BPF object, as well as interacting with it
> throughout the lifetime of loaded BPF object.
>=20
> Generated skeleton struct has the following structure:
>=20
> struct <object-name> {
> 	/* used by libbpf's skeleton API */
> 	struct bpf_object_skeleton *skeleton;
> 	/* bpf_object for libbpf APIs */
> 	struct bpf_object *obj;
> 	struct {
> 		/* for every defined map in BPF object: */
> 		struct bpf_map *<map-name>;
> 	} maps;
> 	struct {
> 		/* for every program in BPF object: */
> 		struct bpf_program *<program-name>;
> 	} progs;
> 	struct {
> 		/* for every program in BPF object: */
> 		struct bpf_link *<program-name>;
> 	} links;
> 	/* for every present global data section: */
> 	struct <object-name>__<one of bss, data, or rodata> {
> 		/* memory layout of corresponding data section,
> 		 * with every defined variable represented as a struct field
> 		 * with exactly the same type, but without const/volatile
> 		 * modifiers, e.g.:
> 		 */
> 		 int *my_var_1;
> 		 ...
> 	} *<one of bss, data, or rodata>;
> };
>=20
> This provides great usability improvements:
> - no need to look up maps and programs by name, instead just
>   my_obj->maps.my_map or my_obj->progs.my_prog would give necessary
>   bpf_map/bpf_program pointers, which user can pass to existing libbpf AP=
Is;
> - pre-defined places for bpf_links, which will be automatically populated=
 for
>   program types that libbpf knows how to attach automatically (currently
>   tracepoints, kprobe/kretprobe, raw tracepoint and tracing programs). On
>   tearing down skeleton, all active bpf_links will be destroyed (meaning =
BPF
>   programs will be detached, if they are attached). For cases in which li=
bbpf
>   doesn't know how to auto-attach BPF program, user can manually create l=
ink
>   after loading skeleton and they will be auto-detached on skeleton
>   destruction:
>=20
> 	my_obj->links.my_fancy_prog =3D bpf_program__attach_cgroup_whatever(
> 		my_obj->progs.my_fancy_prog, <whatever extra param);
>=20
> - it's extremely easy and convenient to work with global data from usersp=
ace
>   now. Both for read-only and read/write variables, it's possible to
>   pre-initialize them before skeleton is loaded:
>=20
> 	skel =3D my_obj__open(raw_embed_data);
> 	my_obj->rodata->my_var =3D 123;
This will be very useful.  I can think of one immediate use on this
for my current TCP work.

> 	my_obj__load(skel); /* 123 will be initialization value for my_var */
>=20
