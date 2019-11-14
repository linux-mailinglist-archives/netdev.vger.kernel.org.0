Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F305FFD197
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKNXat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:30:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbfKNXat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:30:49 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAENTfBr005877;
        Thu, 14 Nov 2019 15:30:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=16tvPcp3/h066Uwt/T0v0g2mLDsE1leooyxfcQsT90U=;
 b=WfmrE3/XwGKgEePE0KLVFbBoizb4PPduXJKB+gPxCGgvFTu0qW8xj4AhRuZMmphEjr0A
 cHgypi1cjaHmHnwSCrF8gQ8pD9iEqU4B5aFVzWVnbM7cW3A2M7bFBwAz3lKPkopDuSY2
 vCWjYN2KVlir1RXRXRhZ3h96piRFTzeZwsg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2w9c1avf2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Nov 2019 15:30:31 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 15:30:31 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 14 Nov 2019 15:30:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mog6GAV5cYmU7DbDQUhRQmG92ixK1kzmjq0vUvAbS1+YJfH0j5DXq3Bm5bVZyQq+8J6QwAtJJ3Po6LfvfGmmKPCJI5luvurhP6E1zMX6RZV7751fsm4J6DdiQdpQWreV+pOrVAx4WFJib503jZdaCdIt2IN4HvTFux3Vd1PaMSSlYMu5bgEaQqitNQOzR9sPpTRwl2u1BMwFA2I/NVel02XIlwLElxmIXhUVlVX8G+ItBuHqvUTmQnNKaU4rtOHpAuJREmaKkciViimu3QTZUMludVoVmFXiPuYvzs007wZ76xq+rXImlLMaYavgEPZkx2rapSdigiyDF3UOG0tmrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16tvPcp3/h066Uwt/T0v0g2mLDsE1leooyxfcQsT90U=;
 b=bLtrtyvcTjcVoBPMQ5eH2vBbI923jpo6Q7QfWQ29BJXuZP5ebWjsJ123LnR1TRl4xyCcekNDZSxehBn8Il7O1q/YjZ830Uc9D/2wHKSablabbRzIlWQPnfrBF6pOSEukLJKRKPSRGoUQxCYWdRPf0BIeBkWTp9ozgZptvhCP4ObVM1Kw6D8QOhdmN3ii8xT3JbeQ+Gq+qcQrd/Lwa6UyghmHZRJC/miq0JJOBkfXtLicn77/mOkGA5i1RN70WHda6HYGVRWlBLhEn1+iPOq8KDEJor1wRquYt2cypM91OLVUo70PRxg041lW0DAuonpAaemz40MfxxobK/0HoEhLRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16tvPcp3/h066Uwt/T0v0g2mLDsE1leooyxfcQsT90U=;
 b=fawfkwF58LWOe67AhXnrwVuLPj4vEnp3qr9Nn3a3sNTKIiOC+mg7Qdug1gU+LBIzW1/VPVlaS4ImeLetqAl44BmbNCReAyPUGdN9FWWsLpm3duwDMFs1wb/wpwCK1/r+1vBuBZaH1X6DDB+L8eK4B8xCDyKu6tI+asPn5VAoHqQ=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1902.namprd15.prod.outlook.com (10.174.255.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 23:30:29 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9%4]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 23:30:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 17/20] bpf: Support attaching tracing BPF
 program to other BPF programs
Thread-Topic: [PATCH v4 bpf-next 17/20] bpf: Support attaching tracing BPF
 program to other BPF programs
Thread-Index: AQHVmx2ZZY1lM9hxUEu0c0DC3buF+qeLUMSA
Date:   Thu, 14 Nov 2019 23:30:29 +0000
Message-ID: <7F2E3D6E-C85C-44E1-9A99-4B28B0B60931@fb.com>
References: <20191114185720.1641606-1-ast@kernel.org>
 <20191114185720.1641606-18-ast@kernel.org>
In-Reply-To: <20191114185720.1641606-18-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::3:e9ac]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e882481-a0e3-45cc-5c98-08d7695aa307
x-ms-traffictypediagnostic: MWHPR15MB1902:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB19021D0323DD74DEEDE66CE5B3710@MWHPR15MB1902.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(346002)(39860400002)(366004)(199004)(189003)(66556008)(66446008)(64756008)(6486002)(186003)(5024004)(256004)(6436002)(50226002)(25786009)(316002)(478600001)(46003)(54906003)(14444005)(229853002)(99286004)(6246003)(5660300002)(86362001)(81156014)(4326008)(71200400001)(71190400001)(8676002)(81166006)(6512007)(66946007)(66476007)(6506007)(2616005)(8936002)(476003)(53546011)(33656002)(6116002)(486006)(2906002)(11346002)(102836004)(76116006)(36756003)(14454004)(6916009)(446003)(305945005)(76176011)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1902;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g1FxAzfxsdFL1z4hv0hCEs9Eh8hujol3nX9nB6+R9IoRhcZuXO/uN1gyOJ9b2G5Wv1oXuYDO7TJb2xH9cBo0AMwa29BXYx96abrClg6rMW0pAV4FD5G/ou8J4VqYtkHt2RDmONOej7fPhwaRTNCnO3NkabiECrjCMVMXMQ4tZYLyLNnd+sqs18YqhBylkKrpafD0U8I4IFrUHy0hKcIvODzQMlIbfDdFcEh8S0yCneUZCU+bviJ/uJKXiZ6YfsoipAYLUCy0XcwxqNY+XGYHL+/8vsajMWbfQcorqBGCu+0h6U4TFfkGO5CZRj368QBwD6wq/gRPZYBU62GMnALtk4GcExW46CGuvsQb/J41MmEBJq/WvxP8oo+WNBcV1RG3+wkM0iQIUANieElEF71efQwLTsosMpvw5siTey/1rhZzYwznhpUM6Mwbt7+wAg+0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E2A995E75BD554B977412E73230F148@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e882481-a0e3-45cc-5c98-08d7695aa307
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 23:30:29.7477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GdmINWdlvozzcvzBLzOxOqTlDpNL+8xoSvPK3LLFo84eecg+hlRAo0rMxvQVdDbxXYqRXog7RwnQV3tMI3zWow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1902
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=714 adultscore=0 impostorscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 14, 2019, at 10:57 AM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Allow FENTRY/FEXIT BPF programs to attach to other BPF programs of any ty=
pe
> including their subprograms. This feature allows snooping on input and ou=
tput
> packets in XDP, TC programs including their return values. In order to do=
 that
> the verifier needs to track types not only of vmlinux, but types of other=
 BPF
> programs as well. The verifier also needs to translate uapi/linux/bpf.h t=
ypes
> used by networking programs into kernel internal BTF types used by FENTRY=
/FEXIT
> BPF programs. In some cases LLVM optimizations can remove arguments from =
BPF
> subprograms without adjusting BTF info that LLVM backend knows. When BTF =
info
> disagrees with actual types that the verifiers sees the BPF trampoline ha=
s to
> fallback to conservative and treat all arguments as u64. The FENTRY/FEXIT
> program can still attach to such subprograms, but it won't be able to rec=
ognize
> pointer types like 'struct sk_buff *' and it won't be able to pass them t=
o
> bpf_skb_output() for dumping packets to user space. The FENTRY/FEXIT prog=
ram
> would need to use bpf_probe_read_kernel() instead.
>=20
> The BPF_PROG_LOAD command is extended with attach_prog_fd field. When it'=
s set
> to zero the attach_btf_id is one vmlinux BTF type ids. When attach_prog_f=
d
> points to previously loaded BPF program the attach_btf_id is BTF type id =
of
> main function or one of its subprograms.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

[...]


> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 4620267b186e..40efde5eedcb 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3530,6 +3530,20 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log=
, struct btf *btf,
> 	return ctx_type;
> }
>=20

nit: maybe add a comment here or where we call btf_translate_to_vmlinux().=
=20

> +static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
> +				     struct btf *btf,
> +				     const struct btf_type *t,
> +				     enum bpf_prog_type prog_type)
> +{


