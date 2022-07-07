Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BBE56AB90
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 21:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbiGGTMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 15:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbiGGTMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 15:12:51 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9D431384;
        Thu,  7 Jul 2022 12:12:50 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267Eg1VG021300;
        Thu, 7 Jul 2022 12:12:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=MPjclmKlJgddaBjAtjw4s5+hRcIR3opa0U/7lZPDDME=;
 b=Yo80sj4a/fjpI7RBFcwRPDJ5a319vOBrHxgqCWyx43MHrSbujg+JWSgY/FGBUc4pjw7m
 btbMRMSxWGNfbewZbrcTtEqiMq9JiZKD2DH6lAxmd7Z7FzbIuk/wEaZ1sK52DsIVh+dk
 hlqhd6DJoHJmJ/ktkpP4MzJoY6J08X5uUlM= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h4uaqr98r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 12:12:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Re+ZKRTxp1ccjX8Ps40T4zgwoCek1eZYBrYbdfTqfHwudq8cqDbK6T7SjFLz9MS0jc5QG0h0RzelchnV8tiQWyxqy8o1KUudlzWWXjOjNEb8EPejEvDkmf9Vcxzs2+mMt+gbFafTjoMC2keFRqZwg74iht7KMhOBp/BNcDTISQpC7aPkga7LrcL1d5nIG1R24KRH2rdFiXwkecDTz55Oq3GdTkWyh9mDlkGPo0VQN5E28BYbX4aQoY1rxVQKdp9J5WPekuPDvqKUeu31MoWwJxGQm1EOppWrmxMBsdX+eQSJI5YD4vxQoBhYFh/uNgQwSx+l6KNcRx6hROyL2fWCgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPjclmKlJgddaBjAtjw4s5+hRcIR3opa0U/7lZPDDME=;
 b=U0DXutAZNvUo3Dw6OxrbDfhiSzg+ALTmHxumIdHf6lRTpY5JXbKJtwvU592QpTzyUnEW2Dz7UKEHUR0UrjlOOxFRZV5WPMQxzJrDg3XplzjSeeOvh7xQNluEagCKQ2IEysEVRw0KyPR23tJmjsQozEJxaReJhZHeeXR7hKiFhK0aAX/akX9i/LZ/w8o6vRm7hCrQ2Im8ZwdIPBg3g0wrbfYp7pBXVgrQjQzNPlu9eDCRxh49xwKUUZMT/pqfPBHa8mNOSLSU95y9mTTCyJ6S8VQHlEQDQfClfk97T1nf0FMQRzS8EsBvKdSGMcqnHt5ABjzoHt6i6xgVwWmIx5Nw1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB4105.namprd15.prod.outlook.com (2603:10b6:5:c3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 19:12:47 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 19:12:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pu Lehui <pulehui@huawei.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH bpf-next] samples: bpf: Fix cross-compiling error about
 bpftool
Thread-Topic: [PATCH bpf-next] samples: bpf: Fix cross-compiling error about
 bpftool
Thread-Index: AQHYkga7HcKsl6ueBUOt13UUFx+YDK1zRwcA
Date:   Thu, 7 Jul 2022 19:12:47 +0000
Message-ID: <FDFF5B78-F555-4C55-96D3-B7B3FAA8E84F@fb.com>
References: <20220707140811.603590-1-pulehui@huawei.com>
In-Reply-To: <20220707140811.603590-1-pulehui@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 103eb64e-2fbb-4d64-b288-08da604cadad
x-ms-traffictypediagnostic: DM6PR15MB4105:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RtXVi0S7df5Ls7iTw7v+JAJvebFrvxQCw4HRaapF4oo4YRRvYYiS6354qvAJVbIKvPpJlcsI5FcbHxPCzvLEbOYypGcjFs63JR/z4+EPhOJadjQDdvE/zStfbo+vWu720EdwG7gs7aNXCXcpblUN3KJMTkT6Dp/IJ3Z56O3sniTFY8Ax7RpvFNQE0b5R07sH6vemvFRiOPDApj1MAVZ+o9DG+j0ZvS9p9ovLizyBoraj2TpyV6XgiZWKbnge72xbOh1m53pPSmyEBrGj5ulp4WTZlmSzLH55Pm50LrHNX0SS+dqWhOWUiWviDz1wbex6W1tay0eDuBstXp0kcIHVc5eowT4WZkaEcwLVbdB3aT0YlowqUNB+aTKnwDb4RAghRZmD/KSKcPlAvKosjATopH3PgzkPbSkT5yr4/P0DXLWbmZspROjFNI45hcz52CWjJiu6yMH0TFNVJ7B5GmYPDT5eXyhvFMrxY//qCLFRWkLJo/d/wKFQngtFyRTs73PA9jZ7ff9fCMFCwCnJSLt5AOgU8qqGV0ebowjk9EYQKronlAiPpU3K+HJxVfqEQ7WYBSeD20t+Zzi5C3hW+PxZUqKS3tXkhNGWysdRQ+b0T/OO+xHq8aQSlt11RqT3Uv/AquI7+3nQ6WgtfI/3+wjuhM2+9mHblLYIuvVXq7XqvprGZTGXq00BUP84Z3RRRsbts4kgTwLToGe13/Ghuxmr5gG7QyEjVFZ08Nau66x103olzHpal6Hzw9LXlDHnj6BdBZIFh2Nu0KDLPL/aIlxcBfD8HM4tLtgmpzOm3fblfxA2xvEKS3bM01WixNM3PPYVRSOpM+/wMZl82dCo/7DIau3T+VwDrB0DzAftzxOhbeQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(54906003)(6512007)(8936002)(38070700005)(122000001)(83380400001)(33656002)(53546011)(6506007)(5660300002)(71200400001)(316002)(478600001)(6486002)(41300700001)(6916009)(86362001)(38100700002)(64756008)(8676002)(66446008)(66476007)(66556008)(186003)(36756003)(76116006)(4326008)(2906002)(91956017)(2616005)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/vWp1fWeFQV66U0CFypu2u6FxDU4+mwNMYbMhH2hjoF91995cWBsVKi+9G3v?=
 =?us-ascii?Q?0sk+45p151PpLkhNjYugsEPGHkR/7HNEmahGUJfBLP8teQexBnwBmMY7mQYj?=
 =?us-ascii?Q?GNCJhZ9BWTBfe2Bs5tNWNCBPrHoSr/Jmdyt+WIMOMprSI/jP+zTOQ+rth8P1?=
 =?us-ascii?Q?PeIqFIJXy1eJJmz1FegnGJwFC7OZzv9ldvWqBYWFGJdFrzRDrDKgrE04CtZM?=
 =?us-ascii?Q?TmPW1Ix9nGVGKQaew9ZPQL+uo/5a59+KGcP2Ij8FIwNCqzcc6SEstVJ3H4pN?=
 =?us-ascii?Q?15Rj1R3i4BIs1ooG39a9aNs6rZWzX3+qW8yAcnRd7aKtKJgVb6ltGyFm2ojR?=
 =?us-ascii?Q?By+aHAPLnAY7dUmXxN0T0sb4M3B86jGG4VKGop1f5yIRLyNxiqmxQipPyUqR?=
 =?us-ascii?Q?o1fZ+VK2WsaSsd9TqiGKespUfF8tDKgqh41ScZB4JO0kjDRxudc48Qoez5nv?=
 =?us-ascii?Q?aMArkyBGpRobD1mFA5vUFLTamiXefbyHH7u+ZWYokUxn7ACL1qhYynCgyMPy?=
 =?us-ascii?Q?umLcakoPphhieIh/YYiVT2Zmtt6XbuMs54xWGG+LtJ8qUGlKiaa0yfXJy7FL?=
 =?us-ascii?Q?yovqLHRtRgVWqh3wVFCM4Fo5aWs7bSSIeMyvGvv1beXKNPBSdIHztX9Sb8gY?=
 =?us-ascii?Q?ITlIT51JtxhLAODUNK3sDCJvv3n6wdJsPDzR8+Bec045laQTAbnuI3NcWib4?=
 =?us-ascii?Q?Yqsjq2E7i+vy3YJYvYaM1Qt4S0lljqfcxwHGTesAJrdXQY+uYKyNDpL30wbz?=
 =?us-ascii?Q?/qJbDi2VR1nD9DJzqCXT9/Km4u3XqQ7zWv9d5nqFTIxgK/r0IZmny2DkidEo?=
 =?us-ascii?Q?UEa31yPqZbSL/4hOjlaAXGR6qqbQPmqdRuFTpqvwdqPO3TnTakw55fWBGPsL?=
 =?us-ascii?Q?XI5F8+GeA443+X+aBuj1RdoofKMMy0tbm4KpScPVJOoWyZIeOfy1n1KdwUh/?=
 =?us-ascii?Q?1r4NmYXNmZBx/hRhNwr6evfF0yyJMnR++nyNlJ8h58FkVIg1d7ysEzMT/esJ?=
 =?us-ascii?Q?7JOSVgpUi3VoxrsuREcEsYxFMISHduLRRvAEDH2mh1MTdynhQuVcqdgx7PMO?=
 =?us-ascii?Q?kNZoGubvJcqKXTnkNOcad40zV9Z3HEud1893rcJSoErsYx6zOUEbNiA3h7Rg?=
 =?us-ascii?Q?blzSVU4rv00uIHzjJuqB8p9rzmBIAfg+4XMEQpL2M9billpTs3RJdVS9T5Qx?=
 =?us-ascii?Q?wtXkdO6ec6Q2IcTBEusWGDAnYY4VTq5TUmeKa941+3p8PMyyIDZYw6QtzFzA?=
 =?us-ascii?Q?4PYX1OLjrsQnlzk+GyisQjCAFkv3wGaTNVIrS5BLmikh85x530KrHIA8CwcX?=
 =?us-ascii?Q?DKi9njRqc/ltin9Lw9bvqj/SMEFqCkqLBr1y/m4Oba7R/DGH0HI1gEemP/Ld?=
 =?us-ascii?Q?7hlv6UXFUgcSUtfgE0oUsnMKXLLmBXLBhfiNBjGKccypMCDzVkk94vNHA66K?=
 =?us-ascii?Q?7cxBGplkvrFX1pb99mMiV4NVSoSAwXN8sYGafAU+LtnMxUsbID+fqOXnVM5I?=
 =?us-ascii?Q?9T/mBPlHcFargctZPWq+WQ6w2/IfXuTHNp2WI25BVnG4zx4338M96bkwGwki?=
 =?us-ascii?Q?dCLQTUtWxIt69Ud/j2/TLC/JrPj6lCAYUpcYq6ZWN/7RuDMEi+3rYk2TQO4C?=
 =?us-ascii?Q?01lR0kvbOhNHtcRIXSm32e8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94DE9506783811458C3F87E342FE2A1F@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103eb64e-2fbb-4d64-b288-08da604cadad
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 19:12:47.3500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7NKM6vNWWcfv/it9ZN4Tx3+t1kxRaWRs49cqoF39Kpm2fy5qTI6RgsNF1u3K00Wostj43QjEWqAb9iFoT9eBcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4105
X-Proofpoint-GUID: XsYMPfKQOlz9d83xoBW3ygv5Gu6hSrDH
X-Proofpoint-ORIG-GUID: XsYMPfKQOlz9d83xoBW3ygv5Gu6hSrDH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_15,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 7, 2022, at 7:08 AM, Pu Lehui <pulehui@huawei.com> wrote:
> 
> Currently, when cross compiling bpf samples, the host side
> cannot use arch-specific bpftool to generate vmlinux.h or
> skeleton. We need to compile the bpftool with the host
> compiler.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
> samples/bpf/Makefile | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 5002a5b9a7da..fe54a8c8f312 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -1,4 +1,5 @@
> # SPDX-License-Identifier: GPL-2.0
> +-include tools/scripts/Makefile.include

Why do we need the -include here? 

Thanks,
Song

> 
> BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
> TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
> @@ -283,11 +284,10 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
> BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
> BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
> BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
> -$(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
> +$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
> 	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
> -		OUTPUT=$(BPFTOOL_OUTPUT)/ \
> -		LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
> -		LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
> +		ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
> +		OUTPUT=$(BPFTOOL_OUTPUT)/
> 
> $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
> 	$(call msg,MKDIR,$@)
> -- 
> 2.25.1
> 

