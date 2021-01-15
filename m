Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F252F75AC
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbhAOJmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:42:15 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:34631 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbhAOJmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:42:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610703672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/qJ3aiIFnwWxV/gtiNpq8bZvryQvbxxElRu4bU08cIc=;
        b=H04Ybkx0pxpTqlVHrAmvX4vWJ1tuky+Lp8aBuuESs9TLY0FOuSOPZCemagPm3MPMdovsYa
        y5cfhZ+IM24an8ob48DLhrKUdh0nXB8Th6/Xr1CPlWtnQF+ZgBCfyQ/HrpW7bwPRBj6QUA
        bxVy2PhsGBGfanN/84yXUeJNow0NFMw=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2052.outbound.protection.outlook.com [104.47.4.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-LGF9L3c6PoOadp6yEIYR_Q-1; Fri, 15 Jan 2021 10:41:11 +0100
X-MC-Unique: LGF9L3c6PoOadp6yEIYR_Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBGa6acFFx/+P/MMM/05h5gjUGK0uWziC+GSwAy9UC5WrVRD6jF5F9USTJp2T/D9NafiNsCKEdVTyoJZ91nMP3P9rdLBdA/S/RCy9nFQPsnxgN+hUeVYCBFdkI71KYLA8voH/lIz04XFHC7gucUqMfSVehiuox3b4zF/tLGhn+MLCBG9Wp9BzUP/BWMmcRdokC2a4a6XKbqaONQN4xZdXzl144AdWVfKWeDv4zHvJAJWgRjcVtpXcXbyd7xtS3PZZOIDw0wA75NlMqJCnQVvleEEme/yM36ANDhNsnxvioX75/9SaCN8CximHauQ25ykDEajWKNS3FcFO96PbLpQjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qJ3aiIFnwWxV/gtiNpq8bZvryQvbxxElRu4bU08cIc=;
 b=F5dFVBnNG143gKxc2zLgq4WYm3gsR6rFbsjdlIkyOFmUf56QsuMsGbxxqIENoRVsK24v9OmfRjg8Q/h+eSzN0MwBXHHdRyOOMg6LsEHKIvrpNCKUTKIA6MdgvbCn0Fo4uH4ar9iv+eSt/CsYbUTMN0g4Gk+XBSVyzxK3QiJ14DLGS+Y/KEdpxLlIdVf9mEpIAolWroEgN3hx52wHH4mhAMme/pwEm8UqU7SWuAj6T9sw3gUL5Dfee5dqbRKS18uMfSbHdVgUTeOomi5SsDlUV9iLxw80Meu0GkZFb7orogessNPTXaB897BbwAiD2TcQ2tW6V1Y3RqjWU10tvv418Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBBPR04MB8026.eurprd04.prod.outlook.com (2603:10a6:10:1ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 09:41:09 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 09:41:08 +0000
Date:   Fri, 15 Jan 2021 17:41:00 +0800
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
Message-ID: <YAFjLNg2XStnTL3W@GaryWorkstation>
References: <20210114095411.20903-1-glin@suse.com>
 <20210114095411.20903-2-glin@suse.com>
 <CAADnVQJiK3BWLr5LRhThUySC=6VyiP=tt3ttiyZPHGLmoU4jDg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJiK3BWLr5LRhThUySC=6VyiP=tt3ttiyZPHGLmoU4jDg@mail.gmail.com>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::34) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Fri, 15 Jan 2021 09:41:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c839c25b-9a3d-4eba-5455-08d8b939afde
X-MS-TrafficTypeDiagnostic: DBBPR04MB8026:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB8026784B8E13C0A24F319D1FA9A70@DBBPR04MB8026.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rsNM07ac/YtKyU25YJR0f2XsBt/5Sko67e7CFIhlk/Fx+TKZenPr2GhVCXb6l4nY63BVpBu0p+IM3RVHG3/RqBZ7gPtuySgHL6uSj/hZibbfl4gkzNKuJ354G25F6xTymlULytc94OEMLtZIGjkEimk/uhzNP8EH1QiAeUgLtaV88rWxi7gCpeIoZQF+k7daOK5z4CyjTTxgiLSdbFpxjQygrCHTSRRqxKFyaHa6JIyMzk6FquNuO5jmE9rZ9KgtPK4uTzgVHRxIoXGuWP+9iv7f6Le2QRhu2YfhsbFhWBpgb2mmIoDl9W3tVXUjQ/PyKyX6PMe4dxj0uDeY71EAuucyO5mn7AjqL5mhSpHW2EzP+4ImrpZZBb9Y55VSVR8d/HeMZ6jaObgPXYX2Pzhhew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(396003)(39860400002)(16526019)(66946007)(26005)(186003)(53546011)(2906002)(66476007)(6916009)(316002)(66556008)(54906003)(956004)(9686003)(6496006)(55236004)(5660300002)(55016002)(6666004)(107886003)(8936002)(4326008)(86362001)(478600001)(8676002)(33716001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?M1ph3pL8Yh4MpQ0SYZw0owK5us/jOAdW+r7e6WRANY1EokgOBuBbFkYrlW3T?=
 =?us-ascii?Q?cIVOlOTRNbNrmd90EYrwQ7HEhQtRT0LH7XqJ+r6DNpONyahXtiAdtNjLq/Wa?=
 =?us-ascii?Q?0Bl2kPce7POhj++7jabXUWCbAOPEl7Y/n0+V83y+It5nVAx/PgnNUdLnvTVM?=
 =?us-ascii?Q?Wl9sWIxSH8eK0Iq7hwXtNUvTDZ05P+GF8kD2DF5+6d+c3G+7TaRiQWfiyfc8?=
 =?us-ascii?Q?6Gxq8BbJQkgE46rlIpm2ekSV0KbQm4vQGZBYci5272H/97ffIu1fY0rjp/wu?=
 =?us-ascii?Q?u/akK+cYmroo6C6myPbodLo9nWG4oJmNTGIUWOEWpMkzMoJIV2Tn5SKkjNQD?=
 =?us-ascii?Q?SV4ibVk6yMdvWvaWv3rhup+CfXgtNrHca/UNbpS9nURI7USWr1YAQ99l3zkQ?=
 =?us-ascii?Q?JdEw6Rl0L3TBW3WLfZ30ixbWfuLHiQSdPC1od3MKXGKsvNc0gjn2C8vHZ+BO?=
 =?us-ascii?Q?lkJE9uoXTkh9USuNC8qMu47SWjY+Wk8VsWMvlWEihPToS7wgTQCfvZUDYL2a?=
 =?us-ascii?Q?0jdlGg1dVwYHsycvjsdV8Okcn06KEh2xNzUulzn7pJ8HkauixIxefPNbx202?=
 =?us-ascii?Q?gxP+rXFR7GgbAcJaF2F5ydAhYHHIzRb1r4Uv2kzSpZ7n2udYKlOQqf+j/FJ6?=
 =?us-ascii?Q?IpWjjLVjR7gs6hiT6BnBEYKaq3B/MDrTN0iD/C/Gh1qzQEF980ftJnccVupf?=
 =?us-ascii?Q?ol2yxgZpT9Ds6RJz+Yqxnr1wLH6li3Nn45E3hpg3xMvqfcmAfcC/5lmZ4Irt?=
 =?us-ascii?Q?hmFTOrrRfDXuhlY2b/0sEzlw3rBLc2mD8oj7AiIuAS3QXOekvfr6TMNUHQt7?=
 =?us-ascii?Q?9LNFm4I7QxHWRiI/5j5mDkQGVv3KUOj10pInp3qvs0MSFxrrE62K6a83Zx3C?=
 =?us-ascii?Q?YXDwP22x+lY/tqJAOIK2KHqSlPWuFzA44b31GVZiHEJmNy7wRNq5f6r2wU9N?=
 =?us-ascii?Q?swIsOm/RtvlDz9c/fMashXGizIS4i/O57VYCBh/M5h8puhKHI3kPfMj5QsNJ?=
 =?us-ascii?Q?wZ1D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c839c25b-9a3d-4eba-5455-08d8b939afde
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 09:41:08.9332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N6CVfzvonX+91jA/ke56SgulQlAjcDTTSF+37QpGU1znfMVUBcnVza3LYRbXKE2k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8026
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 10:37:33PM -0800, Alexei Starovoitov wrote:
> On Thu, Jan 14, 2021 at 1:54 AM Gary Lin <glin@suse.com> wrote:
> >          * pass to emit the final image.
> >          */
> > -       for (pass = 0; pass < 20 || image; pass++) {
> > -               proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> > +       for (pass = 0; pass < MAX_PASSES || image; pass++) {
> > +               if (!padding && pass >= PADDING_PASSES)
> > +                       padding = true;
> > +               proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);
> 
> I'm struggling to reconcile the discussion we had before holidays with
> the discussion you guys had in v2:
> 
> >> What is the rationale for the latter when JIT is called again for subprog to fill in relative
> >> call locations?
> >>
> > Hmmmm, my thinking was that we only enable padding for those programs
> > which are already padded before. But, you're right. For the programs
> > converging without padding, enabling padding won't change the final
> > image, so it's safe to always set "padding" to true for the extra pass.
> >
> > Will remove the "padded" flag in v3.
> 
> I'm not following why "enabling padding won't change the final image"
> is correct.
> Say the subprog image converges without padding.
> Then for subprog we call JIT again.
> Now extra_pass==true and padding==true.
> The JITed image will be different.
Actually no.

> The test in patch 3 should have caught it, but it didn't,
> because it checks for a subprog that needed padding.
> The extra_pass needs to emit insns exactly in the right spots.
> Otherwise jump targets will be incorrect.
> The saved addrs[] array is crucial.
> If extra_pass emits different things the instruction starts won't align
> to places where addrs[] expects them to be.
> 
When calculating padding bytes, if the image already converges, the
emitted instruction size just matches (addrs[i] - addrs[i-1]), so
emit_nops() emits 0 byte, and the image doesn't change.

> So I think the padded flag has to be part of x64_jit_data.
> Please double check my analysis and see why your test keeps working.
> And please add another test that crashes with this v3 and works when
> 'padding' is saved.
> I expected at least some tests in test_progs to be crashing, but
> I've applied patch 1 and run the tests manually and everything passed,
> so I could be missing something or our test coverage for subprogs is too weak.
> 

