Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9675E71462
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbfGWIv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:51:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39832 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727994AbfGWIv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:51:27 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6N8o9Ne005477;
        Tue, 23 Jul 2019 01:51:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=S0Y6n7Vst6CEmvJoiXdH+YGsu9abOe0y5eYb9mPuJqY=;
 b=AlO3I7cHpy2RatQo0CRDIBJ2Wtg96vxNH10CSM5JYPmaZs2fX50YQXNsX1bAHKcIAlPH
 ena1+QWnBbHZdAqM6cGULkL7biZT2ndYZNZdAF3ps8hFOpf+OuCZl9UugmYHMzVY+7EC
 WLodMOTvR23m+VQ9eLMlteCplR3VbAObcqI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2twrxyh1br-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 01:51:05 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 23 Jul 2019 01:51:04 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 01:51:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4Iw+Lsy7r6Xq22zx11DNiqxqlb3XJ73ssM/8WrJlIl4DQVfpaxhtDEmgPeM3LDDshxBM5m4Cgps9tBQfvGvTNs1Zo99qer1YJm0WfrPmOcQVfq1P9CCjnYlSYMCvuBrgwx1r5MDTBdmtMNa/dCybAY5ooRXNQ9x2Tx5xL5oobntrahurAllM+oszpqCMrnDDN2WjLrdckKZRb0PsGEWtDAej50tZiANPd8lIZgqfO21/mhcaSGGJTG0TmWSe962IwVriARF6ZWT/jfRvr5q08/D3N0RSOJrhCtGqVOQrBqAWOd52hURXEEMuRRwQJfjoMG3SuM54eQosBMTDkVYeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0Y6n7Vst6CEmvJoiXdH+YGsu9abOe0y5eYb9mPuJqY=;
 b=Pt/x6qG+VAQMJ3L9wYh7pcFfPicimYLFPNdtJ+zoHAIFD0BjsEUFWhLDPsjd7iEeE6Hv7BeiaZOdlPvyyUkeCnKZNCB0YEkqXeUm23GGti+bfA0Z7ofqhJ6F83tSwJEJs7XxO2itkeC1S8BJmAQoXjbKK/9zgo2zh341NlZi/xs58oVmZoTAYhxPB2C3l8RfgOTB7vQxTm+FLiw4r+ZqW6NtKu5oEbUclGvRYtu0atqme8blKdpGh6vlOlmY0TC8RsVEbgslvhrFnDOlMOg0tItBemHznVZyw5s27CnUPJNw2W/rD5jQVZmKkaD35WiVStlPkPRzwLMOIQO8fFJ1Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0Y6n7Vst6CEmvJoiXdH+YGsu9abOe0y5eYb9mPuJqY=;
 b=MeXLgHslkhvcibWybysWsPySLQ/t2GwQH3YIjFmnOt6CCWUHH4/Mpc/A2chBPGTJjemLpJBKRBZ/wUG5JAWoR+PYRZxd9CYLcNMwRqOxk9AmMPCo0upOq5MQKid7zuNhTCyhd3omOAKZOf7dY4kp2V8/KmSIVQPoMRSolyNbeso=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1565.namprd15.prod.outlook.com (10.173.235.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Tue, 23 Jul 2019 08:51:02 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 08:51:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: provide more helpful message on
 uninitialized global var
Thread-Topic: [PATCH bpf-next] libbpf: provide more helpful message on
 uninitialized global var
Thread-Index: AQHVQQ5qTSqIXYF0QUWpGDKrzna/06bX5WSA
Date:   Tue, 23 Jul 2019 08:51:02 +0000
Message-ID: <ECB3771E-B6E8-45EC-B673-A0E0F79340BF@fb.com>
References: <20190723042329.3121956-1-andriin@fb.com>
In-Reply-To: <20190723042329.3121956-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:2cda]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5006dc9f-bf92-43d2-9a99-08d70f4ae411
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1565;
x-ms-traffictypediagnostic: MWHPR15MB1565:
x-microsoft-antispam-prvs: <MWHPR15MB1565A81668C84E3D47F36210B3C70@MWHPR15MB1565.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(366004)(396003)(376002)(189003)(199004)(81156014)(64756008)(66446008)(66476007)(6116002)(50226002)(81166006)(66946007)(5660300002)(36756003)(76116006)(6246003)(6636002)(66556008)(6862004)(53936002)(478600001)(2906002)(25786009)(6486002)(6512007)(229853002)(6436002)(86362001)(486006)(7736002)(14454004)(6506007)(14444005)(33656002)(57306001)(71190400001)(71200400001)(305945005)(15650500001)(256004)(316002)(2616005)(37006003)(476003)(8676002)(11346002)(4326008)(68736007)(76176011)(53546011)(446003)(8936002)(46003)(186003)(102836004)(54906003)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1565;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BT1n/lcuvBXJ+rqorS00bpH1/9z5ZjAKn4TFt4dABPcKaYdOgAbxJ9dEF262a+pcZ15+gcv4FYjr4YqYTkJEwGwRUcqn7Hklhv7xdeM3KWeXUbT/rL4HtTnxwnsJ5NfwiRMdTcou8MNx2Y+O1jtnsI52iSVdr/7ISYwZn2sV8/ewCvNHJQosOIM35LtalWo0S8PZbbxHLMxC7g0besXEPCwJLumjGXicsg1QrJhwet3G1zYXq/XehsMLL6YgbHVt6N2394mb3FRx3rDDTK059XvQ/TXDXabo8b36fPpUX9F3CZtZm0u/gnGr0BUfjbSCx6cKz2U/8Kr1GTxx2vjb6bhRx7lHdSVqOZonwkpKlLeBm8imynN6HgfWANnOuZEn8XjiSXxH+owaxc5DagY8ibg3Oom26yPGNBQ353dgRqs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4427BE7D0550AF409ECCBD62648B9627@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5006dc9f-bf92-43d2-9a99-08d70f4ae411
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 08:51:02.3098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=837 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230082
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 22, 2019, at 9:23 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> When BPF program defines uninitialized global variable, it's put into
> a special COMMON section. Libbpf will reject such programs, but will
> provide very unhelpful message with garbage-looking section index.
>=20
> This patch detects special section cases and gives more explicit error
> message.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/libbpf.c | 14 +++++++++++---
> 1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 794dd5064ae8..5f9e7eedb134 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1760,15 +1760,23 @@ bpf_program__collect_reloc(struct bpf_program *pr=
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
\'%s\' variable "
> +				   "in special section (0x%x) found in insns[%d].code 0x%x\n",

For easy grep, we should keep this one long long string.=20

Thanks,
Song=
