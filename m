Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1612F976F
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 02:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbhARBxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 20:53:21 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:43125 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730175AbhARBxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 20:53:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610934728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NffE09iWwPFTSqcpx7r+nLatDO8jMQYyon2fWOih50Q=;
        b=TuINkDZB/1pKs2cl265XDnmPnST5+fK4AAZuxzZSRlQ8E2a9R3fadWJXAJARW5OsxVR+j7
        L9bv7QOvHFduU2j7qJ6qMthXQZ9rRqxBHKwrj6u4OK4xvP1kPLqUqzI8egyibJloAvJpfp
        7jKeY1aA7/UTdyLpngrCGgzbYAI8Ims=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-p_oia9JTP_a3gNfc9cnHrw-1; Mon, 18 Jan 2021 02:52:06 +0100
X-MC-Unique: p_oia9JTP_a3gNfc9cnHrw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLGAhoAgYJbv4IseGbihLWvhy4lHdE+wdY2uib3fJnBoEuqy+ylZ3mt+TPyShtPkcL3E/wmCYTB5BO1Xtz9PaNUYvIQwHEMmo/JyZ1Onmzj/sr+EmMwBJopxp9AAEkeIUh21uFWyn5beo73K/WrnaPHb3iH2Kb7DXb3xP0hcyrgpjqB42p6dZic4l0qrn0/itrNRaCQZSAdHexIlAcVFmdLb/6GNu/tQ96m9WU1Sk3XIL4PryhQgz2O145opuRnkOTGZXpkqgFw3qSLJFPg+ZGS4MGmeTJjh0ZK3lg0TPAndDdfzOIjWXXLUuXUi48M6VmPGaOxBlnxGAr+7fNvs/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NffE09iWwPFTSqcpx7r+nLatDO8jMQYyon2fWOih50Q=;
 b=dd1Ra/FLgebrojADMMAr8UzZl6h5q0b7n915CzpoEa2yKmd0mpFqXtCVqF2EDDhl+tzYAOGGn7A2+C+gRif+EnWQ571ZTYinMzyW6/1Wsw3mKekr94EEBCqlYxcdtjiUitDtf/QgVPzNEsDnwcddRXGK/Kaw3bLLRlQHGArwGLjrOp1f0/Ojo9+kOSbj0/no5hP1hcMNAiw53j75Sux/nTPYYzymt9o+DCxt0/VQ5nn7iPV7h6xA4UlrOQCCKk0NBH4PB3Cdm8c4QRjLSvXZzFaM7sY0DN3eCtk9nyTcju7esyF6SxtYboZ47lh2TqvIBz/EEc86WqiqAbdEVxS3Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBAPR04MB7318.eurprd04.prod.outlook.com (2603:10a6:10:1ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 01:52:05 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 01:52:05 +0000
Date:   Mon, 18 Jan 2021 09:51:55 +0800
From:   Gary Lin <glin@suse.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: Re: [PATCH v3 1/3] bpf,x64: pad NOPs to make images converge more
 easily
Message-ID: <YATpux8F5RTK8ElY@GaryWorkstation>
References: <20210114095411.20903-1-glin@suse.com>
 <20210114095411.20903-2-glin@suse.com>
 <CAADnVQJiK3BWLr5LRhThUySC=6VyiP=tt3ttiyZPHGLmoU4jDg@mail.gmail.com>
 <YAFjLNg2XStnTL3W@GaryWorkstation>
 <CAADnVQJ7LQMv513dDwy3ogdq+PaFN5gu6DOS-GiRT72MP4mmcQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJ7LQMv513dDwy3ogdq+PaFN5gu6DOS-GiRT72MP4mmcQ@mail.gmail.com>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR02CA0213.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::20) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM0PR02CA0213.eurprd02.prod.outlook.com (2603:10a6:20b:28f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11 via Frontend Transport; Mon, 18 Jan 2021 01:52:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0de6a0a2-77de-4212-0394-08d8bb53a830
X-MS-TrafficTypeDiagnostic: DBAPR04MB7318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB731871D169C1F33DAFF3ED60A9A40@DBAPR04MB7318.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8VcTr7aO/4lPaGG0QrpYfL8JWDs4LfAjs8qJWFqgS2aZUVR199gp7MdppY1ny4xFB9deJeCs1M8zn7r/sFaQfVrsOzRp2F8b1xy2CDFJC1bBf8laGIqA5aAUNTang22YQhKaShxkKLYDE7buITm6J2VAhpNwWcKBh0kAUSMrcVQNwbq6x+szbkTzpSsj9Pta7Bv+Mr2U8ZCgUOuDvi2rjczGPtlhTdOuugJfcVv5fAa9DgUnnL68zMY4AOk580PNyaLwaEzAamOVXRK81rqhLP3wmzF+KaEZCFxy1Gk6clurr40G/tqNC5sL5Y2zvBVSuhLFTZBngXcYB9R3BVX6yFSGUlqrDiGqfN6pKakXSIwylSvmh+UQhnEPWBYpUawbARejDgD23KXrVm+8Dg/nA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(136003)(396003)(376002)(6916009)(8676002)(9686003)(86362001)(66946007)(26005)(66556008)(6666004)(66476007)(2906002)(6496006)(4326008)(478600001)(5660300002)(55236004)(186003)(956004)(52116002)(16526019)(55016002)(316002)(53546011)(54906003)(33716001)(8936002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AGfUWjSQoaokSx1BHniMS0lpNbLXN+BzCSOMx8XeGcklb6vHwvh/g2AYeSWz?=
 =?us-ascii?Q?wKB1kqImma8MePHzYWU3q9CDYPTBqnlQAiyXB2E6etj2EXAVOANACcnDxYRq?=
 =?us-ascii?Q?uzvm0vAFvPjDpF+la1rL14lYHecJilykuPp5KJKweZhAbR/IJtSXplkmL8Fa?=
 =?us-ascii?Q?sQ4ARIR239zHIx08JH0yc3vgksWmMYxWgnxdw4gVXtto3INJ0o16jbhoRITo?=
 =?us-ascii?Q?Cc63bIwwlT0r1wIiMDgwZ+Sat/iprN/KWuPjR0bIiTtM+7kVJhR+DkVoLlw7?=
 =?us-ascii?Q?m2SSsMwTxoSCXbSXzw5yXIHl9SQhGIL0wEdDcrptvmrVekrmct+hdh7OyRTP?=
 =?us-ascii?Q?OMucQMDQz6dZlv2uUkRifwShiPFYqEDi6C3hYFHT/oOb//XJ7wHr/07HF5fL?=
 =?us-ascii?Q?KyPVeEl5hyQJEWXoiv/QeAkgX4HjB9zCirjYNvkpLw4oBMD3WTE75TkdNx2d?=
 =?us-ascii?Q?CdSqMGxksmnMt7ofcCd/B5+0dckANJVA1mdSVPzxMQFvKBOQWhogEAEeLZK/?=
 =?us-ascii?Q?JaUDAGrUX0vXu+TMbOUwqcJqWlKxEKwGwJwqoEg/ZMa3EF23GotU25bzmXPP?=
 =?us-ascii?Q?nKymEK3RajWjFGP5A8Q+leHB3/YT1xHnjHKBZkivp1+59eyNj/DcrRbnkDZG?=
 =?us-ascii?Q?JgOmTxaCPiN8bbGHGFipDoTCQ0rNzBlImEqdt9E7xym3G48fjVuOpygsUhax?=
 =?us-ascii?Q?2MsQfSTgwBlnDFC8+sSr9sjdQJfzidsLWMdCKvcPXWJ0fxCGDVzn+/xtA2TG?=
 =?us-ascii?Q?PSlD0J+DawFbsITqwD2NnPiY/k9NBgTmF7g9n4Z9Mcf6ofXC0qGlSIDInxP3?=
 =?us-ascii?Q?prCeKRzGE/ZuhdqRTocIRcv9DK/x5A3C9Q0P9e62ew9U5QvBqQ2OYNSW3IWH?=
 =?us-ascii?Q?00DFCRDpoh76EJcQlXAOn+x3t91c8PNhA5L0mRjEqGKrltSnM9uJTPDhBNMU?=
 =?us-ascii?Q?vs9sB/T8P/P8E+xw33lBd1wq6Blcc2gWzpxfpAhxDDILqYrPcpFFPDsMKmDk?=
 =?us-ascii?Q?MjIQ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0de6a0a2-77de-4212-0394-08d8bb53a830
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 01:52:05.4192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lo0zfG38jfFkvZ3u26uqQF4xJpP1ODft+6sgbIN23Nw1KrKLxuQcCAlKJS0TDmAo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7318
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 08:04:06AM -0800, Alexei Starovoitov wrote:
> On Fri, Jan 15, 2021 at 1:41 AM Gary Lin <glin@suse.com> wrote:
> >
> > On Thu, Jan 14, 2021 at 10:37:33PM -0800, Alexei Starovoitov wrote:
> > > On Thu, Jan 14, 2021 at 1:54 AM Gary Lin <glin@suse.com> wrote:
> > > >          * pass to emit the final image.
> > > >          */
> > > > -       for (pass = 0; pass < 20 || image; pass++) {
> > > > -               proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> > > > +       for (pass = 0; pass < MAX_PASSES || image; pass++) {
> > > > +               if (!padding && pass >= PADDING_PASSES)
> > > > +                       padding = true;
> > > > +               proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);
> > >
> > > I'm struggling to reconcile the discussion we had before holidays with
> > > the discussion you guys had in v2:
> > >
> > > >> What is the rationale for the latter when JIT is called again for subprog to fill in relative
> > > >> call locations?
> > > >>
> > > > Hmmmm, my thinking was that we only enable padding for those programs
> > > > which are already padded before. But, you're right. For the programs
> > > > converging without padding, enabling padding won't change the final
> > > > image, so it's safe to always set "padding" to true for the extra pass.
> > > >
> > > > Will remove the "padded" flag in v3.
> > >
> > > I'm not following why "enabling padding won't change the final image"
> > > is correct.
> > > Say the subprog image converges without padding.
> > > Then for subprog we call JIT again.
> > > Now extra_pass==true and padding==true.
> > > The JITed image will be different.
> > Actually no.
> >
> > > The test in patch 3 should have caught it, but it didn't,
> > > because it checks for a subprog that needed padding.
> > > The extra_pass needs to emit insns exactly in the right spots.
> > > Otherwise jump targets will be incorrect.
> > > The saved addrs[] array is crucial.
> > > If extra_pass emits different things the instruction starts won't align
> > > to places where addrs[] expects them to be.
> > >
> > When calculating padding bytes, if the image already converges, the
> > emitted instruction size just matches (addrs[i] - addrs[i-1]), so
> > emit_nops() emits 0 byte, and the image doesn't change.
> 
> I see. You're right. That's very tricky.
> 
> The patch set doesn't apply cleanly.
> Could you please rebase and add a detailed comment about this logic?
> 
> Also please add comments why we check:
> nops != 0 && nops != 4
> nops != 0 && nops != 2 && nops != 5
> nops != 0 && nops != 3
> None of it is obvious.
Sure, I'll add comments for them.

> 
> Does your single test cover all combinations of numbers?
> 
The test case only covers the NOP JUMP for nops == 0 and nops == 2.
I have to figure out how to create a large enough program to trigger the
transition of imm32 jump to imm8 jump.

Gary Lin

