Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E4C20BB98
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgFZVaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:30:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64552 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725824AbgFZVaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:30:06 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05QLFN3N008512;
        Fri, 26 Jun 2020 14:29:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=eoNgHQiMqSqs7G/MgLO+t1ANoVaKiksDZ8f7DVJuuIw=;
 b=TWL2KiFOrn6wZK+Q913AJ1HmRarDT//OTwZnMvg3XZDcWgEq34GHBQxN2/euzjvEd3dA
 2vQLgCpG9bJo4knuIl+vYePq32KVOUNnN8xFQpFzRXNU56TIhz4gEIxc2V0hxcpgFJlH
 9gW1j8iPubziMBCTUxa6DMsJFZlnw4n/QaM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 31ux0nyghe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 14:29:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 14:29:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4hYYuhD+jKB4cdTqzUwendc3B8mAqYXwJaE1FcbMOw9/uigbkqRJwEKaUwJ4C8XrXBdCBBC5UnCLzrBQaOJwYuCLa9Go+Mhi+tvkgKynH8vElTfYcu2ssJ7OwNzjeW1HFSOOuHeut55noZm7P2pVB3Fu9flAkjBIdYAPKqhGnAEdHpAqU90ZTRz8x41J30uDQChZW58NoYVDKIPBYPC0oXeDQZrPQMQr/eIB6arAu71Dx+CW1to9Ex9dZzWmWYHntkxYQGhVy25yGQRq7vWUZXm8gtpe5+nOYB8VLVOsBk6TWubsX1XamYT6PHbLjqSWhJAfA6OSXsaTVBm9tv6Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoNgHQiMqSqs7G/MgLO+t1ANoVaKiksDZ8f7DVJuuIw=;
 b=GmvjyRZvSi+xL7YC+63uIqjLOUzxL3VFqzKz+r+RiICej2KFIEwdFSPPkVJ9lfsh451mUwwpYEKJ5weLgKRIElm8bTOeEmkVYleM0DwlQFuoLxLMrugLvTK8B/YV+t1NRtJ+g9o3CxK+dpnyG5aXkyM6fzvrY+n++Q65zoLwT7Kr/UoCrbLutqpJ4aNyBozJDO+MUjLGUVn00iFmRIZCrtm4DQNssjQVG+WQsWXmsD7bz1AHvyrWqNuTfbqG7IZmLg90myyncz/wX0ku7q4VmREb0aCDDjh7WtvCi/Dg3mbnmTcvY4bywSdiv/i2Fte5u/g8yrWawSOqMUgovTT19Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoNgHQiMqSqs7G/MgLO+t1ANoVaKiksDZ8f7DVJuuIw=;
 b=aSbHKO5/cqPyvlRurpGAJn4fQNTSgSwCB2/zUnRqKf80edxA2tMt1C3+Mct2F0XKLT9gPUWXMflJ0MgDUaT4NLprYFxhlxSoOEhjy+dStmiPtWApfs/WesAW9mbeLDuzDmDSUeDWbrV+CcB8GfI5MI1Ubm+tGGaDFV4DCj5Q1yw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2952.namprd15.prod.outlook.com (2603:10b6:a03:f9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Fri, 26 Jun
 2020 21:29:38 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Fri, 26 Jun 2020
 21:29:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 1/4] perf: export get/put_chain_entry()
Thread-Topic: [PATCH v2 bpf-next 1/4] perf: export get/put_chain_entry()
Thread-Index: AQHWS06t5H2BZnsAuEuKRuZX7jQ17qjqu3gAgACvs4A=
Date:   Fri, 26 Jun 2020 21:29:38 +0000
Message-ID: <6A3C511C-4749-4672-988C-AA8149FB6355@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-2-songliubraving@fb.com>
 <20200626110046.GB4817@hirez.programming.kicks-ass.net>
In-Reply-To: <20200626110046.GB4817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1a00]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ed4d8d1-6596-454e-89f5-08d81a1807dc
x-ms-traffictypediagnostic: BYAPR15MB2952:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB295242B350C861F44F6233CBB3930@BYAPR15MB2952.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZpgVoLY54s88F3Rdi2E6qDHGDzfe647NC57uGuCMLPaSNUwSeTC7qoFJ34hi/BVKtLQL49Zy4sk9BsmEufxguPb4arhgVOvajZ+enex91mIFrwppJNfIf03dJnQWJpchSfcvz0DKhTaVRjV1p5/JjEf4/XGnXAVuQLUtXAHao+xHNgo4dk0g9wC5buixN1LEDUYB/gbyWa2dW/dwMdPYowfQ17oiPiOMB7cDvkm/FRNa4J9MWxWKS/995xcc8ksAbaoM9ajEnptbIgP4wUJNq/xNNMvKvRyd1dqAZLQSnIfkfritDkDEM0bkeJi/46ikclTqIf5FW9Boh5DEgJTz6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(376002)(346002)(136003)(396003)(33656002)(53546011)(66556008)(6916009)(4326008)(64756008)(66476007)(6506007)(76116006)(54906003)(66946007)(66446008)(5660300002)(6486002)(316002)(478600001)(6512007)(36756003)(186003)(86362001)(8676002)(2616005)(2906002)(71200400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Xo7TqFhdY5g6Gr/aQAPmgQm/TsELHMyDo/FDs/iDAfoUgGHYOy8xpwx5tbXBgsNaRH6k9ifgLAM5hBTL1dIsh/dymYav1Pu0kzdqJPQ1z13IxCGWbTfuotpWABsnWXQcTbUmnx6FeF3JpTEOmu0MvR/0Ha2iecm6IIYnAzcapGvEcWXmwX7JfdJvnXjrkC1ZLyNeogqPtATSsyDhTCmgY+Upo3yMh+/Kp3BtUjatwmJQm4nK+9TTlyWLyAzGHPN3VfMjmxxRh3Iw6VHh8G5zUvtVHlx3BBRGK2ZHkUvh+gsW6rXCPDTD6LEnyEx5ZN3iEdY0+ZQPiOOb3SAkTam51Oig2/1K2mX8r2SoqAbBj8frN8FcqHkfaQW/irejtGa9ocqOJ2HwxS21k74gKSg/oqSSQ6rXcvVLS5f2fQF+CsUsH15lFGeJMwkyNNUAcn9gdt9QXxnocMgMTBlmy5Fd2ZJwC3G6DP0Os5SYKZps5tCaxRmOttXTxUk970vH6zSAeiXJ3X583z4+IQ5eOFvXLA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <00A4AEF1A6F3A74C9B8CBE62837BB472@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed4d8d1-6596-454e-89f5-08d81a1807dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 21:29:38.1479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fzTYFJ4IIF3DbqVf/co9cDpUeeV3ur+dimtceI+WD2E1gR7bX8M1CPgujkCL5gEyGb1R8vY2ZQcoVOOPt6ib/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2952
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 cotscore=-2147483648 spamscore=0 suspectscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2020, at 4:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Thu, Jun 25, 2020 at 05:13:29PM -0700, Song Liu wrote:
>> This would be used by bpf stack mapo.
>=20
> Would it make sense to sanitize the API a little before exposing it?

I will fold this in the next version.=20

Thanks,
Song

>=20
> diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> index 334d48b16c36..016894b0d2c2 100644
> --- a/kernel/events/callchain.c
> +++ b/kernel/events/callchain.c
> @@ -159,8 +159,10 @@ static struct perf_callchain_entry *get_callchain_en=
try(int *rctx)
> 		return NULL;
>=20
> 	entries =3D rcu_dereference(callchain_cpus_entries);
> -	if (!entries)
> +	if (!entries) {
> +		put_recursion_context(this_cpu_ptr(callchain_recursion), rctx);
> 		return NULL;
> +	}
>=20
> 	cpu =3D smp_processor_id();
>=20
> @@ -183,12 +185,9 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr=
, bool kernel, bool user,
> 	int rctx;
>=20
> 	entry =3D get_callchain_entry(&rctx);
> -	if (rctx =3D=3D -1)
> +	if (!entry || rctx =3D=3D -1)
> 		return NULL;
>=20
> -	if (!entry)
> -		goto exit_put;
> -
> 	ctx.entry     =3D entry;
> 	ctx.max_stack =3D max_stack;
> 	ctx.nr	      =3D entry->nr =3D init_nr;

