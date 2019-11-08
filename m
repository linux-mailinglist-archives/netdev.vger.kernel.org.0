Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5566CF3D5A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfKHBSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:18:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30108 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726094AbfKHBSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 20:18:07 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA81H7KD002311;
        Thu, 7 Nov 2019 17:17:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=eVezWZFLQzrWPfx/8WnVD0/pYoirzpd5aQtRdewhZ24=;
 b=pJCtmMJCs3otw8pbEO6O7O3+kM2yB0Dhi2kVJTLMFWAVXJ2fnVDruxr08qj2vo/tfS3g
 LhH89RGXrQDPvFaYWhJ3AGgm/wK9J49Ujl3slQxgJI7cder9sNvpOYmc6OXbMPSCxfGL
 rzqFD33K57EenBbifqWviEYc94DwhW2wzvc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2w4tyjh3u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 17:17:52 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 17:17:51 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 17:17:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKlTZ8Rg0vBqqejgpSts74dI6v3ftYHxXKXbSvEmfA91cLZEymQEztskS7pg5gjt+porvK9KhmGBJ7lyupGttIrsTYAp7dNSgYVeO/QFWZ15toNO3Hg1zkmjMhg3pFvLSynMzjiwbXJzA1NDC1NvyxWTd9djcSM5R9DCGxMh88wNmdf0NW7hv/vXNczdiY9mJgMsKHdr6fpn0cykp9Zmtx82QN0+QrAZd7DDG298itm5HOSfRqxllSworUC9q1ZFg/QsCyxWuAVKuRyu10Ssc9d/tbaNx403YEZemLNHgcgadE1vw6oQzdBc9KuYT7qItyo4ztuIoPVurVDDvO9cAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVezWZFLQzrWPfx/8WnVD0/pYoirzpd5aQtRdewhZ24=;
 b=fjkY8M8jgsNUiBBlunC1Lb8ZPfOwa2309KSxCv7H6Q2ox5fKz/8S6WeuaT6QyPpY/i02+Ws1Nwo+PJaKvIt+yssvPsKBa3YrTAPCUGER/7WDyY0HzDp7v5EXb/7pMfvY5B07R7MuEFk9yqWlETZsGgXFuIx76/x2cfm2kS2U/TaXQQj/tvloBLVmR8CJ4ApF5FCQnVX6/umcr3k62vxwt53cwEMn29SVDt51lo//XvD9Rx+salZeOU9XMhen705nqIcnvcUH8MnphjhG6zOIpcS3jZJwav7tAP6nE0Ib1sMAoo1sE2Gdoi53P5VKmnMGBeU/FA5E+Mg0iqHxk3zHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVezWZFLQzrWPfx/8WnVD0/pYoirzpd5aQtRdewhZ24=;
 b=aDf0gJn2V7NQrUQtf5Kw/oxkuFDxySAuM4g6PCRJxAQYk30pEXP6O3svtBXqxGs5pgoRg8L3GozJ3zdtZq/z/CKUOLwlLfgGLr0dXvA4pjV3NWs69wOUcAwK2N3TBgQ4TNjvf25cRjUzhQmwuvPGKn5W4hImNNPnPVyTobnEjok=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1583.namprd15.prod.outlook.com (10.173.235.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 01:17:50 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 01:17:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 07/17] selftests/bpf: Add test for BPF
 trampoline
Thread-Topic: [PATCH v2 bpf-next 07/17] selftests/bpf: Add test for BPF
 trampoline
Thread-Index: AQHVlS7RevEx1N07DEimoS0lTY6I26eAdyeA
Date:   Fri, 8 Nov 2019 01:17:50 +0000
Message-ID: <1929869B-945B-4DBC-B6CD-0B6C397DA4EA@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-8-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-8-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::b23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1491f5f6-b993-41ab-e541-08d763e978f1
x-ms-traffictypediagnostic: MWHPR15MB1583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1583E82879D9CE7B05C9ADE2B37B0@MWHPR15MB1583.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(50226002)(8676002)(2906002)(6436002)(6916009)(99286004)(6486002)(66556008)(6246003)(186003)(4326008)(14454004)(46003)(2616005)(476003)(102836004)(11346002)(25786009)(66476007)(86362001)(229853002)(6116002)(478600001)(14444005)(256004)(305945005)(5660300002)(76176011)(7736002)(6512007)(33656002)(446003)(316002)(54906003)(6506007)(486006)(53546011)(36756003)(66446008)(64756008)(66946007)(76116006)(8936002)(81156014)(71200400001)(71190400001)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1583;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CTRV7vLCmi6Yli2GZ/lzl60OKcHuMyXU1zwtHw+YCny8TfXuuKKgTpQsQhorjvusyZblo3xqmrjsg9ZL2g8NlxWul91y2FwzeHsNkdFCnxRT+kbun8A8/8wfUHV0BGbsW4d6zRtRdPgf/2kI+2rsekTLccoORkdq8p7Q8shPSuIRH00GBYLzwj/+NdOyDrxNV3v8sK27/UEdRlFnBqs8Z3l0EtFb9cAIkzuAu86kUfgJ40RX0xUv9cd2C+Wok/WXnpy1iUSCKB8o1uu31ufzs5TNh0IR9+kOEhPZHJ6d8USQE4aStWPfljMp//DSy3D87akq8WWddO381DkBtMOvfNYjTxgAh0GJ49debYWSvSxdyESfzaX5Sn5DvCPypljyQTxRNRvUCs8z7NWoZsNLFviEhTSb5PC/D1VyFNmQ6EKZlG3PTslWXDkbbx2pw7Lc
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A09BCF165F443F499D041AA61F96ECB0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1491f5f6-b993-41ab-e541-08d763e978f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 01:17:50.3043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hK1qlmt6PpJuiJxjYgpmJfHDQObDCF589CaBFE+bfL24L8k/PGUJn5rUY6VT0bUlL8Q+5yh4dDBNj0W6hB60cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add sanity test for BPF trampoline that checks kernel functions
> with up to 6 arguments of different sizes.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> tools/lib/bpf/bpf_helpers.h                   | 13 +++
> .../selftests/bpf/prog_tests/fentry_test.c    | 64 +++++++++++++
> .../testing/selftests/bpf/progs/fentry_test.c | 90 +++++++++++++++++++
> 3 files changed, 167 insertions(+)
> create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_test.c
> create mode 100644 tools/testing/selftests/bpf/progs/fentry_test.c
>=20
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 0c7d28292898..c63ab1add126 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -44,4 +44,17 @@ enum libbpf_pin_type {
> 	LIBBPF_PIN_BY_NAME,
> };
>=20
> +/* The following types should be used by BPF_PROG_TYPE_TRACING program t=
o
> + * access kernel function arguments. BPF trampoline and raw tracepoints
> + * typecast arguments to 'unsigned long long'.
> + */
> +typedef int __attribute__((aligned(8))) ks32;
> +typedef char __attribute__((aligned(8))) ks8;
> +typedef short __attribute__((aligned(8))) ks16;
> +typedef long long __attribute__((aligned(8))) ks64;
> +typedef unsigned int __attribute__((aligned(8))) ku32;
> +typedef unsigned char __attribute__((aligned(8))) ku8;
> +typedef unsigned short __attribute__((aligned(8))) ku16;
> +typedef unsigned long long __attribute__((aligned(8))) ku64;
> +
> #endif

Maybe a separate patch for bpf_helpers.h?

Otherwise,=20

Acked-by: Song Liu <songliubraving@fb.com>
