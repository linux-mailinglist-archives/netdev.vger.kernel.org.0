Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D86FD173
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKNXTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:19:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbfKNXTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:19:30 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAENIrvt014838;
        Thu, 14 Nov 2019 15:19:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JXRfFn5Jk5qjrajNctPXF17b0cVIG01HtTAioEe7m6I=;
 b=jn/XYYH0MyIjhKbylI8A6VLNf7BBRLoPqWYYhtyA8kC5cnu2+XHkHMfiIutRfR5rpoRk
 aYxAx+vo12rqmzICpTA9pIMK5430QQBm3BaMth9t4T+pPD5qGRAclr0ILqwS60dh+16M
 4QgTZ+s03J+2DvxIZVUft/G71hNzYunB6RE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w9c1ava8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 Nov 2019 15:19:13 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 14 Nov 2019 15:19:11 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 14 Nov 2019 15:19:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGyvcUITTv+PjHfbc89/bPbBxFgyj2ygirTKOVq0xSxRXGCIYv2w7I9aJl4ESm1HKonSzrHSb+nJkfpbvyYB84qL38IV+pHZB/brxQffeuOKASKLlGpxulseLrzAm5EtgSO3WF1vjEVtI9cNDOd9hlp4ilpbfj8WVX0wHQZeHjiWhpRmjY+gINztLILE9hz8s6vl0+5Vy3uI9nkAXN2YJzqyRA9GdwmaTHCmuQ9G6gK1/XOG2fUjK1kLDnGIDB2SalM+TM3jbjJRKJR64coXISPQtUZJwxXXYYJ+rBZwNpx9mT7FOHna6AblaI5fOl+i+X54/6fFissawX0NVnzfsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXRfFn5Jk5qjrajNctPXF17b0cVIG01HtTAioEe7m6I=;
 b=ZPhpF3vvyving9zAXp5jojfRanWUkBgZhBQZkDCuzI8tCiDUKVm6vlBq+rHuJ69bRpiUPUgUvyK30sngnVqPokdOwRvrp2zlXV9lflCyjhYHdJ32/Y5NJChng15Xvd8jtVNECi2ewFMfKjmIivSb4FiB4+04ux5COcT0sR/CQKr4ZEEhObdJTEHfEAxBgHQPNoFcqGz04Z0BuLryne6V0LHBKvZdGK1Qm869dJtAgnOL4CKcgNY18yq13XzUZMEVDFvCVTWMhvbXDM19nqgrpdpiY+lWVPBrnl+sCYKzDwH4z5OS7VzhxxCAvwQBXfoUkMyyCuDuAZiQj7gGjED2Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXRfFn5Jk5qjrajNctPXF17b0cVIG01HtTAioEe7m6I=;
 b=OrwmMaEI/hY/By4B4HNIJ/o4IZChY5d14qCEz7sdvH5TmtIyDsho+4DEltZIwjHeISVU5wZDbcLB3F2d0SHO/6RdFozPudccqbIWVJrrY/kJ+/Ov5YBJLaYEBXNxoEcURQFGxSUJX4XTOWxMkWlKzEaFmODzY3w0vQtGxXD+17c=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1919.namprd15.prod.outlook.com (10.174.100.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 14 Nov 2019 23:19:09 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9%4]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 23:19:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 15/20] bpf: Annotate context types
Thread-Topic: [PATCH v4 bpf-next 15/20] bpf: Annotate context types
Thread-Index: AQHVmx12SNoDMBP720G92P3g3yLwPaeLRweAgAABl4CAAAT8gA==
Date:   Thu, 14 Nov 2019 23:19:09 +0000
Message-ID: <E4C70DF1-372F-4129-94DB-E036FB262BEA@fb.com>
References: <20191114185720.1641606-1-ast@kernel.org>
 <20191114185720.1641606-16-ast@kernel.org>
 <7092A2D7-BE2A-431F-B6A4-55BA963C36BF@fb.com>
 <20191114230117.wtusupri5p5xw63b@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191114230117.wtusupri5p5xw63b@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::3:e9ac]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1722a30a-4a3f-4d74-22ec-08d769590dbc
x-ms-traffictypediagnostic: MWHPR15MB1919:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB19196A376EEE4C246BCBEDC3B3710@MWHPR15MB1919.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(39860400002)(136003)(346002)(189003)(199004)(51914003)(8676002)(186003)(102836004)(14454004)(5660300002)(305945005)(71190400001)(7736002)(71200400001)(5024004)(14444005)(256004)(6916009)(25786009)(46003)(6512007)(2906002)(4326008)(81156014)(6246003)(33656002)(11346002)(6486002)(316002)(99286004)(446003)(6506007)(76116006)(76176011)(66476007)(66946007)(66556008)(476003)(229853002)(478600001)(64756008)(86362001)(36756003)(54906003)(8936002)(6436002)(2616005)(66446008)(6116002)(81166006)(50226002)(486006)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1919;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MQsSWu9MgJau59UNgGw9/ljkOQRFExPYYsll/zozuDm+NCMHSCjXuh/606GSkZa+V7AA5SMD3O9Au3GDpafioZBwWpe5ljLDgfCqo1RQPTdIrvAsap5BsWG/M7ZmlPMpJVMqwG6UX3cNaN6GRcRTChaJUeaYPbpq8yHve9jwuUj1WtNp68RgmqYPxfMkeNB7CrStkyvMjvZEBxMndDgFv3DvSKthU5oanFbw+eavgOa0utbCPu3FTp6tZl40RgT/vfegXz3u0UYPY6hFUwdKfykbx0FHZOP8MxVtZ1LlEyJOV4AphyL433SsmdLVDHwum3rA2DXLDtarlvlDOVFJQ+1mNcWTYnY3M8D67S3H1B6BlPkyL6Rpz/3lDZMMwELivZW6kc+LrrlQt2fIqY4SpyXmNlExElBLFpXPUexZcX8Vhh2zNqXcJdnUyjl1e9nF
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FE05F941A2F54A4985ABB8A628BB542E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1722a30a-4a3f-4d74-22ec-08d769590dbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 23:19:09.7864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7bz/ZTmPFWB4ZoSZXCekokQ/n36qSLLaB69fCuik29lMxU7KZXQM5aNJz9OF+CsJMnOmHA0guuFGvIl8FkM7rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1919
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140190
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 14, 2019, at 3:01 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Thu, Nov 14, 2019 at 10:55:37PM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Nov 14, 2019, at 10:57 AM, Alexei Starovoitov <ast@kernel.org> wrote=
:
>>>=20
>>> Annotate BPF program context types with program-side type and kernel-si=
de type.
>>> This type information is used by the verifier. btf_get_prog_ctx_type() =
is
>>> used in the later patches to verify that BTF type of ctx in BPF program=
 matches to
>>> kernel expected ctx type. For example, the XDP program type is:
>>> BPF_PROG_TYPE(BPF_PROG_TYPE_XDP, xdp, struct xdp_md, struct xdp_buff)
>>> That means that XDP program should be written as:
>>> int xdp_prog(struct xdp_md *ctx) { ... }
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>=20
>>=20
>> [...]
>>=20
>>> +	/* only compare that prog's ctx type name is the same as
>>> +	 * kernel expects. No need to compare field by field.
>>> +	 * It's ok for bpf prog to do:
>>> +	 * struct __sk_buff {};
>>> +	 * int socket_filter_bpf_prog(struct __sk_buff *skb)
>>> +	 * { // no fields of skb are ever used }
>>> +	 */
>>> +	if (strcmp(ctx_tname, tname))
>>> +		return NULL;
>>=20
>> Do we need to check size of the two struct? I guess we should not=20
>> allow something like
>>=20
>> 	struct __sk_buff {
>> 		char data[REALLY_BIG_NUM];=20
>> 	};
>> 	int socket_filter_bpf_prog(struct __sk_buff *skb)
>> 	{ /* access end of skb */ }
>=20
> I don't think we should check sizes either. Same comment above applies. T=
he
> prog's __sk_buff can be different from kernel's view into __sk_buff. Eith=
er
> bigger or larger doesn't matter. If it's accessed by the prog the verifie=
r will
> check that all accessed fields are correct. Extra unused fields (like cha=
r
> data[REALLY_BIG_NUM];) don't affect safety.
> When bpf-tracing is attaching to bpf-skb it doesn't use bpf-skb's
> __sk_buff with giant fake data[BIG_NUM];. It's using kernel's __sk_buff.
> That is what btf_translate_to_vmlinux() in patch 17 is doing.

I see. Thanks for the pointer.=20

Song=
