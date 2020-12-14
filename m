Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0554A2D9223
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 05:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438475AbgLNEAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 23:00:10 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:32915 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438391AbgLNEAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 23:00:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607918340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r2lipl1YivPLlm+Qtcxz7tZc41EaLGD8okE7sSSQFhM=;
        b=hsgayQJAHe/QXEEXrNPgpSvbOf/fs6haVkdplKdysdmfOgvymDEAxPIiRXQ8/VH8eIJgcl
        Bh6QYSjUkeTyORwDiEIca0C25vZSBRD1DxPP23POuj/rh8wkrNm/ab5eG7/LRleQJc2dW0
        VVOSa3Qq6/EXyWVmPzyvlzmLruLkJKI=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2104.outbound.protection.outlook.com [104.47.18.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-3-CkFeoEDbNJGeWliBFGFkZw-1; Mon, 14 Dec 2020 04:56:33 +0100
X-MC-Unique: CkFeoEDbNJGeWliBFGFkZw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HF1p9A2T/WpiuATjj6u7HUGXRQoSaRnS3gbx/dkPd+8bcm1eq6ar/oWk+iJJW8G+vGDUH8mA7LWDdMzO2720H9y4AMKIwEILFuAXr4v837Uh9TzJseeuGAA6Cf/4H+Dnzvc14GWC8s9ZlqxARk5CWOovXNP4UoMVWLl6n5FLs8FnktIPioVz6WIWa3Bqxp8YVW+I6bw23oPfKjSPC3hZpPcJQm+V1ecZRsReYzr5erzcSFxg8zXAdUKlwuXzZaRxXLgFKlHOyySEhxk8JFEp26N4VV9x4DMo5u7oVelaBCY4PQfmGUavvUUoVjvJNfxysVUXoainCTqydfZ68w3H3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2lipl1YivPLlm+Qtcxz7tZc41EaLGD8okE7sSSQFhM=;
 b=GH7B/4I7x8gjqsJdXECl8WVLYC2RgDMWnGFQFj8KSHnDxheoxTZWwfhee1n3XoK76fxZ/+kRhKTs1OmFdkLpk8xTEGZI6HSkx37NBDXSk2exrXoohoil3tPPWV89iupwMrFr/2B4z4DS2dz+E2PAZUSC0Ovo4bqOF5Y1RXwFiqEeTz8WJPgxZCc2Qy33S9ROe1o0nMPk/1y7pj/UwPrraCRzHuRBW9mw5JKR962Ra7jjQrSrbyG7FCUoadYh9lpTkWYmkA3zAmY6PLDpNYb40I+uFEujZAKbJ7Jfak0PqGFLol89o/q/80NX7XcRuOvtLBji3hegNczchoXBrLehWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB6PR0402MB2918.eurprd04.prod.outlook.com (2603:10a6:4:9a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 03:56:33 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 03:56:32 +0000
Date:   Mon, 14 Dec 2020 11:56:22 +0800
From:   Gary Lin <glin@suse.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
Subject: Re: [PATCH] bpf,x64: pad NOPs to make images converge more easily
Message-ID: <X9biZvkGPfslPOL4@GaryWorkstation>
References: <20201211081903.17857-1-glin@suse.com>
 <61348cb4-6e61-6b76-28fa-1aff1c50912c@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61348cb4-6e61-6b76-28fa-1aff1c50912c@iogearbox.net>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR07CA0012.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::25) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM0PR07CA0012.eurprd07.prod.outlook.com (2603:10a6:208:ac::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Mon, 14 Dec 2020 03:56:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 700ab1e5-b8c1-46c8-550c-08d89fe43ee9
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2918:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2918C1116A80FC1EC2EA21DCA9C70@DB6PR0402MB2918.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Me0KNNy3RjyUy5s37GtxzcUw9Va2e+nV+vfPw2udm/8f4yy0/x3X8yMSx+/OYu8Q00t/Yy9isWzT/hzJCjMIa34tSadi+4DvcoMO0beGli7MNNf3QhDU7aoBafwDs/Z1fXmIgnhv6hRCm912iVvDf5kpdoMiLsRRJ47Mhs8HeIZZM6n/viqtSsVfqJte8ilpeLGCmUYhuYsOONaPTa5S6Fvvz1RQpn4E2mAdxBRMSxAUAstMTsln8U5sBfWt6xbvh1gsLJ/1qlGeYvgFDrhujFDXRRGL4OfWB70Xho5A1fGwlcn4MPTi0JMoioDS2vjgYCU7q4RvGeg6rG0aeXOk8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39850400004)(376002)(136003)(2906002)(6666004)(33716001)(55236004)(66946007)(54906003)(66476007)(83380400001)(53546011)(66556008)(5660300002)(8676002)(6496006)(52116002)(107886003)(4326008)(26005)(956004)(86362001)(478600001)(16526019)(55016002)(6916009)(9686003)(186003)(8936002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mx+ZW/QVZriXPmjyQXRQg1VZMzds4fsO2m/WqmfJKyJzeZBOmMJ6SgH9RElq?=
 =?us-ascii?Q?nCSfZMcsCj1adHZSl1KBxqzSC8OV/0RNN2Rvt7v0BBmxhOwFWaI/k0uR00uz?=
 =?us-ascii?Q?21ShVTnlmkOZG8p2JnIMDFQhpIyX+hYqQsTLH9RMudi5w2dUIkWpRqJq+EYe?=
 =?us-ascii?Q?qgbp7zc4or/jNcPPGMwp0fR3wusS1qhyxbl6fsWPfrQsVPBKxHIiEHmBIUEn?=
 =?us-ascii?Q?FadQiLM3cgqly++sfgQwbfCnTLKDZXX19eVbc6UC50AfntGu9ebmlsIRQFKw?=
 =?us-ascii?Q?xW+T5voz/lXgfJU8HinY87Ifl5/+bR8ol+byFynfc2B73KpUw7EvDJhp+FNi?=
 =?us-ascii?Q?Qq5YRD6/njgJS/IK6hgdbfdEFr5tk3/n6uRJdftOgEQ9bfB7YTSZS16SclfI?=
 =?us-ascii?Q?HZccW0+1ghGLFxccbLvT0Vw5UFu6y8A6jcPKa2hceNMkR289VXWDlo9jAtBb?=
 =?us-ascii?Q?1/zvu4mSimZXfhZeZwn+8TUCe6uGVdCRXb7APqmjlWLPNSsBbXhAyUcVlFCS?=
 =?us-ascii?Q?Qi0VaTJP+Zh0yKFq7vTE7XtS85hXsXfbEFqlXQ5O0NVLunbvuCxA7qkXgL6T?=
 =?us-ascii?Q?EvUukL5GRLUQbV7caeht66thj1gwNXrtv8nmkk6rhR5CB1hyP9kxWgrtB4VI?=
 =?us-ascii?Q?uTmxrxwR1/aZ/4FG3zN7Oxam/AN5M1TBMffq/2wA+XwGHo+j5NtNa3KkoAS/?=
 =?us-ascii?Q?igppQeMKPOuLCIj/88F4LfTWHpoQ5yX8FzOMj+Hm5Xip1GlR8opX9+TBOwui?=
 =?us-ascii?Q?DFbVRDYoZZO1eqok1qSgHfKzXYwwMN1TJlKuAFkZn7vZqW6sMlYf2q7eu6UU?=
 =?us-ascii?Q?5jPd2gmrJk7BU2GWH5mKJRlBSdA5d4jXcplZSfUhifsHkbOCRQ5Qk0NOYkQ9?=
 =?us-ascii?Q?zFITCUHCHNCWLatfc+2ONz2uzute84Cpr5q/ovwbtgd9+NBWE2EU9yxgqk58?=
 =?us-ascii?Q?RyZfGo7H/Tl4wMHPXoRLYxP7kDMQ6e+ooy/jcfZHOgRg7DdxB7gvvym9cPko?=
 =?us-ascii?Q?zSGe?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 03:56:32.8554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 700ab1e5-b8c1-46c8-550c-08d89fe43ee9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w1qAuH9ZJbprBJ6aVqFltAg7JkAQ8g/reqZFzyGRKFa0c6GLMVORjSV+siQ3KSFQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2918
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 09:05:05PM +0100, Daniel Borkmann wrote:
> On 12/11/20 9:19 AM, Gary Lin wrote:
> > The x64 bpf jit expects bpf images converge within the given passes, but
> > it could fail to do so with some corner cases. For example:
> > 
> >        l0:     ldh [4]
> >        l1:     jeq #0x537d, l2, l40
> >        l2:     ld [0]
> >        l3:     jeq #0xfa163e0d, l4, l40
> >        l4:     ldh [12]
> >        l5:     ldx #0xe
> >        l6:     jeq #0x86dd, l41, l7
> >        l8:     ld [x+16]
> >        l9:     ja 41
> > 
> >          [... repeated ja 41 ]
> > 
> >        l40:    ja 41
> >        l41:    ret #0
> >        l42:    ld #len
> >        l43:    ret a
> > 
> > This bpf program contains 32 "ja 41" instructions which are effectively
> > NOPs and designed to be replaced with valid code dynamically. Ideally,
> > bpf jit should optimize those "ja 41" instructions out when translating
> > the bpf instructions into x86_64 machine code. However, do_jit() can
> > only remove one "ja 41" for offset==0 on each pass, so it requires at
> > least 32 runs to eliminate those JMPs and exceeds the current limit of
> > passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> > is set even though it's legit as a classic socket filter.
> > 
> > To make the image more likely converge within 20 passes, this commit
> > pads some instructions with NOPs in the last 5 passes:
> > 
> > 1. conditional jumps
> >    A possible size variance comes from the adoption of imm8 JMP. If the
> >    offset is imm8, we calculate the size difference of this BPF instruction
> >    between the previous pass and the current pass and fill the gap with NOPs.
> >    To avoid the recalculation of jump offset, those NOPs are inserted before
> >    the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
> >    calculating the NOP number.
> > 
> > 2. BPF_JA
> >    There are two conditions for BPF_JA.
> >    a.) nop jumps
> >      If this instruction is not optimized out in the previous pass,
> >      instead of removing it, we insert the equivalent size of NOPs.
> >    b.) label jumps
> >      Similar to condition jumps, we prepend NOPs right before the JMP
> >      code.
> > 
> > To make the code concise, emit_nops() is modified to use the signed len and
> > return the number of inserted NOPs.
> > 
> > To support bpf-to-bpf, a new flag, padded, is introduced to 'struct bpf_prog'
> > so that bpf_int_jit_compile() could know if the program is padded or not.
> 
> Please also add multiple hand-crafted test cases e.g. for bpf-to-bpf calls into
> test_verifier (which is part of bpf kselftests) that would exercise this corner
> case in x86 jit where we would start to nop pad so that there is proper coverage,
> too.
> 
The corner case I had in the commit description is likely being rejected by
the verifier because most of those "ja 41" are unreachable instructions.
Is there any known test case that needs more than 15 passes in x86 jit?

Gary Lin

