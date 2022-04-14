Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B625005B6
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 07:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239975AbiDNGBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 02:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiDNGBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 02:01:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA0B38BDB;
        Wed, 13 Apr 2022 22:58:50 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23DMLhkn010364;
        Wed, 13 Apr 2022 22:58:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=FWzvDjhvnRE5v2+8amTk0siTIYQ38zkXikxgAc6U3NY=;
 b=jy1khSLOsGJZUXTBoBiG+heNrw8W+BtTtooy3YLcUTaVO+hNKLOr2Op+gi0hXFQPXfz9
 DXCVHnOX29mIJakRWc/9YtwZIEvDRYZio65zRh3ExcyqaBa70SEFGGUKJfUcpaO/Sp00
 BZJFBHUV3mGp++LC4jc3PDCMQqaL6d8uS8g= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fdx3unypm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 22:58:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOqfN3sxQjkrjy/ErtNllM1pkuEUZG0l76kKFtCQoUWA2nQKtqxfTiKFO3cmOvBn0DyPkj9LEMsx468hkIiTWDfHwsx0hCaMR2kCEzU2IPjiAcvya62/puDpgyS7gvr6cnhCklvbHXssmVrXD/2gPuyMXGpDTXhg/ZeJvE0k7saqz98nSOV27kYJ6VKsua12LjOMe5HjxFli4pVpoQireIw6kYZUO6K4oX6c9L47QDSWtGDUqiuwDzs6a7R9H0SIuQ6iPsUT8I/ReM8v49WR88154xr6H+M6af92BCNSrSnXeM+diq+YbY5jDTDb12WbazkPX/AhOUkamn3u4XoIhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWzvDjhvnRE5v2+8amTk0siTIYQ38zkXikxgAc6U3NY=;
 b=BwhTxPR/4rHtqHjZQRjjB7SbEZFRFfj2Y1QBBjYB83rHOsu7j/UJ8vW4yEqvMvzerIEBHjSTxMAHgNPmZDJbbU2YRze7dXK8yr35bWYtTtuOYnu96PfRWutDlrE45xbz+aLx+386/tBUANEI2iOmGfE0Ktn5HRWWfWzkGM+BCQGthbTQd+yKN5+KiA5hIM178RKfs0cfktxt5F6NrqELpS7Y/UAdVmPEJVCx9Abqy9Mf/AaoicW0m3oC+Iz5BP2pox8bQeFmxhGp3NanqzNphsZm+/DeRJ0KUrBq2gj5GJ/CG875AviDugx/Ky4UpKvyMYXm95q+B03FAcrPu10dEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SN6PR1501MB2032.namprd15.prod.outlook.com (2603:10b6:805:9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 05:58:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b%6]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 05:58:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Xu Kuohai <xukuohai@huawei.com>
CC:     bpf <bpf@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
Subject: Re: [PATCH bpf-next 1/5] arm64: ftrace: Add ftrace direct call
 support
Thread-Topic: [PATCH bpf-next 1/5] arm64: ftrace: Add ftrace direct call
 support
Thread-Index: AQHYTvidAzSM/VM5mEa+KklxQeGrDazu63OA
Date:   Thu, 14 Apr 2022 05:58:45 +0000
Message-ID: <D829ABEB-5504-4682-9A20-AAD21AFE3CB3@fb.com>
References: <20220413054959.1053668-1-xukuohai@huawei.com>
 <20220413054959.1053668-2-xukuohai@huawei.com>
In-Reply-To: <20220413054959.1053668-2-xukuohai@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d90ba6ac-bdac-458e-6900-08da1ddbd68c
x-ms-traffictypediagnostic: SN6PR1501MB2032:EE_
x-microsoft-antispam-prvs: <SN6PR1501MB2032954F6B71551D957FDB8BB3EF9@SN6PR1501MB2032.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M5lo721OONaAtBggqXe5mO1OwX4dHqa2t7ryIpWQEpMIRsR38x9iVDWKg/RtiaxycoDQccLmJItwr+QHdVUnYucV09ssd/pJayEgKOfrPDXgv9OR5guNIBJzqakQrmj3vDq/RECz9Lbw6K9nV2IAupu0dXYllESdqihCNh/LfJoyxB0eWbllPDnuxN43EGHC4eMLQcsP6xTAShnNPEK2tzEbeD3q4OKddYiWyWMmtLvZl7j/CAksgixsAnB98evYd6saz6XJeX6N+boURlT6wi7SZRXlyQoe/IXxt65fZ1QzNLR8AZX4nDn9eBos5sWjrpsC65oeKqxjLQKE79t2DEPI73ZMSeloLN8Am4KE9a3fZdYDOI9OV9C+tKWETLkFcpe5ifm0yZT21O6/JVCIw87jtM3dFVKrDUcnPsZPt6NCuBu4S56qk14xffN9soc+X610IHScVRwbufIip66iY4D8Q6HHeJYnGg7GJl7dCoV6TcL3qfvclHnt6PGjw0Ddv4rL+h1NyCedBbqVr5ipxedVkFuG1Nij8/o6mzZXtN3MEuExUVRnZt60ugoKyEaciTQrT7J+C1LI+chIeTiaPxgpJglgZLxT8JZ1GV0s+QWDPlTeQg/ICJm8oZUDjpAiXRSvJVOKvXVU52SR42+QxMdAn9pKIT5msTaU1GelweENo/Xvv1Ke1Q4EQ0DKatwRTCOUcuvWgBrW6HQDbN4VR7+BpD40GPnkYO8249Mk4pXl8Vs/sv6qDxUy8vpcGUea
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(64756008)(38070700005)(316002)(76116006)(122000001)(53546011)(38100700002)(2616005)(54906003)(186003)(6916009)(2906002)(91956017)(71200400001)(66446008)(66556008)(4326008)(66946007)(66476007)(8676002)(33656002)(36756003)(8936002)(7416002)(86362001)(83380400001)(6486002)(6506007)(5660300002)(508600001)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ETtZ3X7b1Yy/NDxZl1gZQ7vphVv1NVUhyJic7cl5/3BiwT/eE0MJqKkQ/Pd3?=
 =?us-ascii?Q?dshJF7xqdcrfdZ/7D88XSzI0wnfNBtnU1QdWsOj7naURU4LZb6UAA0qoRcxO?=
 =?us-ascii?Q?JvqiyzwA8M1UNXHIlsnGKXDlMwDuBmG6Sac+HfyCB39+4BojfturbZZ4Pd02?=
 =?us-ascii?Q?pPbRlDui7gszebNyshFmkoHNjasJYRPnXlUCP1FB0NMplQyayk9+CaoPOUkE?=
 =?us-ascii?Q?ZMx3fxanDXn1j4z2ZaWUBxVhh7ATmzj9IdbH739Yq87TmeFDfKHmCa5VthcS?=
 =?us-ascii?Q?S2HoPG7Hm56y9KDPiNOfzAzfZO4zt0M7kC8vyp0vPwzmDrsustDy2xQG75a9?=
 =?us-ascii?Q?Rnc7pRLTsF6cRkTcbyP5HnvOo6/qyVqUJ5bouoOaVISGbrh60Et1aPri2eP6?=
 =?us-ascii?Q?EHpnyMtlZMKKrlNzeT6lHflc5r0PTrJTxAUVaXKRCsWBvIMa4qaYZpViyypU?=
 =?us-ascii?Q?GBNcJargu/Dj+a9cY3SbW+z3iYcZPLf/sbjQ2CXS7e0DtrbHjI7Tcog0MHdR?=
 =?us-ascii?Q?4QJ3HyHx9kkiBYlyt3aSR2i+66bZZ4NTXE7yJLbJd2P3pwzOtqHlIzHb36i9?=
 =?us-ascii?Q?nydD5qqinaAb8ND3b3TuG2jPYImqxtqjKCjaZnC5oxG7gIZOEbJcu30MWW/+?=
 =?us-ascii?Q?VfT/uHknjTH8wSWQPXa4wZBP0Okk/9IPDp45Yu3C5C8n5kgSS68+Bc/PHkeA?=
 =?us-ascii?Q?rE9Kw5QF44SFnGNJm5A2Y3nKROmclaYj6LoUHZdVjMFH2P8uQUe0ZkyUkeMV?=
 =?us-ascii?Q?We5gdzVzxzKVHl697Q1S/Tn0EWWchtWS3yEQuUfJzavPRASvMc0dRZM9L11B?=
 =?us-ascii?Q?RSUHF39qxu83MtFG3gc0XmYfOAEXPHV3KVdOY7mv2nuFhtR1mUEIvYOUyrQf?=
 =?us-ascii?Q?Bbjgq/wBErfRogiFMW8/SXJt9izCYR5dhbncf7rOxT4/sdisqr320opA+TFu?=
 =?us-ascii?Q?DEiX4vBSC0UyjhH9u33j4X72o07dsJBfPFgwdkbkT16RjcGjoab65QCAKTn0?=
 =?us-ascii?Q?AmmnOPiqndaawgdRC1H6lclvjt3mh+k4DQQGdgqXPTf4J1Tww60qoE0tjci7?=
 =?us-ascii?Q?pDipMmTNuRG2vbr0fJNvriVMt6xp4XXK8RhGPftZPjJ+0Rpbymqw/w608WFd?=
 =?us-ascii?Q?Yz+H9yaWR36AnBSIS3R3dEFjUGaXSc2CUCsB5vSBSQmUzeMRP2dF2B6UX0iw?=
 =?us-ascii?Q?NbLvxLRatfPeylcPOSM+b8I3ZeHkIdQ/VC9EwoRZYNRjHvZmFNtT6h0UZcap?=
 =?us-ascii?Q?m5IsdJbfT7LqH9Za+DWu8lnwCcfrRADUX8QvRdetf4akxzravCGGM3JGtx7n?=
 =?us-ascii?Q?im4mpmEHSmWi/GLZyeRyhF8xC+57m9Fva0J7VDsAK9RiLaPQw+62noFuzKAJ?=
 =?us-ascii?Q?KhTpYSbeskyuT/3QkCAJ7dQ5GLfMxI+f1YIj1KiWW1If8XxHTCWS2YqwzBkq?=
 =?us-ascii?Q?ZOgp2lMSkaObRV1/z4ztn02TAQtLvsYTZRm7faR9/3bvKdiHa7WZackvfj//?=
 =?us-ascii?Q?PAuFHhSHY26BmdGiPc3c+F0HoP69DzGgFcCUj7TO3y6x+WJcPl++5l+CUYdP?=
 =?us-ascii?Q?lVeDShmQrbthK4Z5c+wQMp91XkzaIqqj8cAzKbC6EcdVLrgVNrgMx8jFpWiB?=
 =?us-ascii?Q?tA/2K4Hkl02FsAzTOE1nRyRngZopZdINMMMUzfa8xo9dTcZ5sNhjZ9WEgm3W?=
 =?us-ascii?Q?qbU73aq4uv1jumXol58FulBlB9vrD0AboPTmUevXvUvGeyp9yjcBnEVv+r2a?=
 =?us-ascii?Q?dbNaLhcrFwKus9mFSIRZprC6zgqUpTIL0u6oAd3Qj+kuOtjRE/uT?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2B0C5F2AC36FA54B8F26028A83FC9746@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90ba6ac-bdac-458e-6900-08da1ddbd68c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 05:58:45.9353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jI3xZtjEpyaDSXJTeBGgW/WHVJcKKKQxpoFFP1cGf2fxWOJdTRVK4r+/Y36MohhcnQFJXP52ZiI013+uplzk1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2032
X-Proofpoint-ORIG-GUID: A_ZO7GBUlPjrI9Og6epD35zRa4YDYcKm
X-Proofpoint-GUID: A_ZO7GBUlPjrI9Og6epD35zRa4YDYcKm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_01,2022-04-13_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 12, 2022, at 10:49 PM, Xu Kuohai <xukuohai@huawei.com> wrote:
> 
> Add ftrace direct support for arm64.
> 
> 1. When there is custom trampoline only, replace the fentry nop to a
>   jump instruction that jumps directly to the custom trampoline.
> 
> 2. When ftrace trampoline and custome coexist, jump from fentry to
>   ftrace trampoline first, then jump to custom trampoline when ftrace
>   trampoline exits. The currently unused register pt_regs->x0 is used
>   as an intermediary for jumping from ftrace trampoline to custom
>   trampoline.
> 
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>

For the series: 

Acked-by: Song Liu <songliubraving@fb.com>

(Pardon my laziness, I somehow only got 1/5 and 3/5 in one of my 
inboxes, and nothing in my other inbox. :( ) 

Just one nitpick for 2/5: as we move is_valid_bpf_tramp_flags to
trampoline.c, we should change the multi-line comment into net
style:

	/* BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
	 * and it must be used alone.
	 */

Thanks,
Song

> ---
> arch/arm64/Kconfig               |  2 ++
> arch/arm64/include/asm/ftrace.h  | 10 ++++++++++
> arch/arm64/kernel/asm-offsets.c  |  1 +
> arch/arm64/kernel/entry-ftrace.S | 18 +++++++++++++++---
> 4 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 57c4c995965f..81cc330daafc 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -177,6 +177,8 @@ config ARM64
> 	select HAVE_DYNAMIC_FTRACE
> 	select HAVE_DYNAMIC_FTRACE_WITH_REGS \
> 		if $(cc-option,-fpatchable-function-entry=2)
> +	select HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS \
> +		if DYNAMIC_FTRACE_WITH_REGS
> 	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
> 		if DYNAMIC_FTRACE_WITH_REGS
> 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
> diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
> index 1494cfa8639b..3a363d6a3bd0 100644
> --- a/arch/arm64/include/asm/ftrace.h
> +++ b/arch/arm64/include/asm/ftrace.h
> @@ -78,6 +78,16 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
> 	return addr;
> }
> 
> +static inline void arch_ftrace_set_direct_caller(struct pt_regs *regs,
> +						 unsigned long addr)
> +{
> +	/*
> +	 * Place custom trampoline address in regs->orig_x0 to let ftrace
> +	 * trampoline jump to it.
> +	 */
> +	regs->orig_x0 = addr;
> +}
> +
> #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
> struct dyn_ftrace;
> int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec);
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 1197e7679882..b1ed0bf01c59 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -80,6 +80,7 @@ int main(void)
>   DEFINE(S_SDEI_TTBR1,		offsetof(struct pt_regs, sdei_ttbr1));
>   DEFINE(S_PMR_SAVE,		offsetof(struct pt_regs, pmr_save));
>   DEFINE(S_STACKFRAME,		offsetof(struct pt_regs, stackframe));
> +  DEFINE(S_ORIG_X0,		offsetof(struct pt_regs, orig_x0));
>   DEFINE(PT_REGS_SIZE,		sizeof(struct pt_regs));
>   BLANK();
> #ifdef CONFIG_COMPAT
> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
> index e535480a4069..b1bd6576f205 100644
> --- a/arch/arm64/kernel/entry-ftrace.S
> +++ b/arch/arm64/kernel/entry-ftrace.S
> @@ -60,6 +60,9 @@
> 	str	x29, [sp, #S_FP]
> 	.endif
> 
> +	/* Set orig_x0 to zero  */
> +	str     xzr, [sp, #S_ORIG_X0]
> +
> 	/* Save the callsite's SP and LR */
> 	add	x10, sp, #(PT_REGS_SIZE + 16)
> 	stp	x9, x10, [sp, #S_LR]
> @@ -119,12 +122,21 @@ ftrace_common_return:
> 	/* Restore the callsite's FP, LR, PC */
> 	ldr	x29, [sp, #S_FP]
> 	ldr	x30, [sp, #S_LR]
> -	ldr	x9, [sp, #S_PC]
> -
> +	ldr	x10, [sp, #S_PC]
> +
> +	ldr	x11, [sp, #S_ORIG_X0]
> +	cbz	x11, 1f
> +	/* Set x9 to parent ip before jump to bpf trampoline */
> +	mov	x9,  x30
> +	/* Set lr to self ip */
> +	ldr	x30, [sp, #S_PC]
> +	/* Set x10 (used for return address) to bpf trampoline */
> +	mov	x10, x11
> +1:
> 	/* Restore the callsite's SP */
> 	add	sp, sp, #PT_REGS_SIZE + 16
> 
> -	ret	x9
> +	ret	x10
> SYM_CODE_END(ftrace_common)
> 
> #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -- 
> 2.30.2
> 

