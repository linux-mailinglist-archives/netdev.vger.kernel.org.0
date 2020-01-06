Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3EB131A94
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgAFVhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:37:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52100 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726713AbgAFVhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:37:08 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 006LXd90006866;
        Mon, 6 Jan 2020 13:36:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jZyy6IwV1OwrxBd5APsmiDd0NK9aXTi/Zmtc1ncGa04=;
 b=Ij0FN8be85WfCianHmTsbcfv+bcIJsuB5333z/j+dT7WQPBsahpUAJLpU5LfMMvYuT3M
 gM6WlqwLRsDT0e+Jby4P+08VDG1A6eGF10n07T3ve9b64BCrnSVDLL7Uthwbo/8/O/ch
 R6Pp0FYctVHxitEYuexLrm+PyOB7KXJJp3E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xasdpamcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 06 Jan 2020 13:36:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 6 Jan 2020 13:36:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3mbeNr67nvjTwlw2bqw+mWcl+bp+4nETmCikleEx8UZSJaI9VhisQTF5V3builcnsOQuGZlzJkCjiD28nFq3Yk6IO+k0/Sd7lFznUCWd5cXJdlePlZMwx7UHR5s0AuEX1gnKAZPRsNvAtf3f2ZKfvzPGPorhzpb8lhQbInXw5AvUIchBQNzF0AnopqLKYq+hfZBDNydCquAAo11zJWj1IcfgRzr5/uOcGkLhLUXBlp1J/eUIN16uLahCmJvwdAAqclyzhWVQiJO4KMwNw6wfBn/Ts+9NPGC+jpBMp9fNmv1ERMxqf3QmkFy4Qa1jl/hdP4iSIFI1GSehEhyJ4kuHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZyy6IwV1OwrxBd5APsmiDd0NK9aXTi/Zmtc1ncGa04=;
 b=oYid4vc6gDMmqO7EmGP/N3ZvYEN/aZY9yomGJR3+TglG1zp6vGT6V4yUhk8M6UPuMhj3KpGqqxL6ZnZZkDfEnCMsB1/h8EgvZcu2SJPWBLAmKrVsA74qQbo6dhYl2p0NxPxAcNmVxkO2slD4K+Y9Xoff82zSCUTR7I2mAuA7lePm2Yv6ebFNoskAOGtPb374B9G5KFUW2GC8SK2iRwMnWOB25FsfaG2pap2bZvPI5Qvz6NlbbGUPzjb+zE3glDK1bIHVyy5SZlEcaSURWShXmakST0hENlj5hw1EEiIHZe5UAoXdckLr7gQqdtQ3xIOWo4r3+bJTupRA3mm5tFBJdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZyy6IwV1OwrxBd5APsmiDd0NK9aXTi/Zmtc1ncGa04=;
 b=LMnSGrBqn2ncvi/5G6lHsqnaqJMTNYWQUxSjU7OEU55zZoXYJBx9c2es/mrAiR/jstI/ogzxIVfNV42MCW7oeYU2gVFrEMfhTQXUcAYU6OgUamTod4pyMHL6BmQjaankFPdrg6dbuzuJY5U0xk1rVpcHd/QyphcLDWq5ciXRPQg=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1257.namprd15.prod.outlook.com (10.173.212.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Mon, 6 Jan 2020 21:36:17 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b%11]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 21:36:17 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::2:eff) by MWHPR1401CA0014.namprd14.prod.outlook.com (2603:10b6:301:4b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Mon, 6 Jan 2020 21:36:16 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: [PATCH 1/5] bpf: Allow non struct type for btf ctx access
Thread-Topic: [PATCH 1/5] bpf: Allow non struct type for btf ctx access
Thread-Index: AQHVvlWQhA1GLUWWnESW6jgQCFjtZafeNfeA
Date:   Mon, 6 Jan 2020 21:36:17 +0000
Message-ID: <d7b8cecf-d28a-1f4d-eb2b-eb8a601b9914@fb.com>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-2-jolsa@kernel.org>
In-Reply-To: <20191229143740.29143-2-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0014.namprd14.prod.outlook.com
 (2603:10b6:301:4b::24) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:eff]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03934cd7-a785-4b47-08a1-08d792f0763c
x-ms-traffictypediagnostic: DM5PR15MB1257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1257CF6F60EF303324D9399CD33C0@DM5PR15MB1257.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(39860400002)(396003)(376002)(189003)(199004)(316002)(8676002)(36756003)(81156014)(71200400001)(66446008)(64756008)(66556008)(66476007)(186003)(81166006)(6486002)(16526019)(31686004)(110136005)(6512007)(8936002)(54906003)(53546011)(52116002)(2616005)(31696002)(478600001)(6506007)(86362001)(4326008)(66946007)(2906002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1257;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CI5ltQZIK4Xz1Cs1rSKInMBMghKM9JU8LrANbB0Ea7PmRTA6Pf8L2UHgSBJDhUcMcQWY2MO/70FsFMzMToekNf7334g3cBOSOnXW7jJeqntRycRCRD7C7q0umRS6LE5gJs0pRtFX2NIPId9NN3JV7u4gQRBjF22Hb+E+M9m+6bmHUj9rLiX+Bw3XSX3zfM4rI3hMIDQMyKXVP/jT2F7/gKJS/WFEYsY2tmEjrA1oZ7zc3DWNTxVT5+IAdXL6Iej+nYveHj4Mx2sXZ344wcrWuqUjvUIZObxPGPpEWIsGDyAoVLv1fzCokufFOTavghM1FDKtoGQqjRev55M1wGE0c42Z4hWPHD5AeCnpzD0BBAwqmrYPLMaOPiwQEXtR4yzO7K5+0fVFpCTR1vGyuK77NgpLz0Fyp0hntG13X+2qnmRBGl0jHwYAZauuQlNul10M
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <4F5701B066BBF04D87A2C02C5DB6E7B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 03934cd7-a785-4b47-08a1-08d792f0763c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 21:36:17.3714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cll2Mw33k1IKc8m1IzGFyHDt3Iy6piGOBVyGFxxhwgwuj3lAuwxjTm+boeJLSMzW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1257
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-06_07:2020-01-06,2020-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1011 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001060180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/29/19 6:37 AM, Jiri Olsa wrote:
> I'm not sure why the restriction was added,
> but I can't access pointers to POD types like
> const char * when probing vfs_read function.
>=20
> Removing the check and allow non struct type
> access in context.
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   kernel/bpf/btf.c | 6 ------
>   1 file changed, 6 deletions(-)
>=20
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index ed2075884724..ae90f60ac1b8 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3712,12 +3712,6 @@ bool btf_ctx_access(int off, int size, enum bpf_ac=
cess_type type,
>   	/* skip modifiers */
>   	while (btf_type_is_modifier(t))
>   		t =3D btf_type_by_id(btf, t->type);
> -	if (!btf_type_is_struct(t)) {
> -		bpf_log(log,
> -			"func '%s' arg%d type %s is not a struct\n",
> -			tname, arg, btf_kind_str[BTF_INFO_KIND(t->info)]);
> -		return false;
> -	}

Hi, Jiri, the RFC looks great! Especially, you also referenced this will
give great performance boost for bcc scripts.

Could you provide more context on why the above change is needed?
The function btf_ctx_access is used to check validity of accessing
function parameters which are wrapped inside a structure, I am wondering
what kinds of accesses you tried to address here.

>   	bpf_log(log, "func '%s' arg%d has btf_id %d type %s '%s'\n",
>   		tname, arg, info->btf_id, btf_kind_str[BTF_INFO_KIND(t->info)],
>   		__btf_name_by_offset(btf, t->name_off));
>=20
