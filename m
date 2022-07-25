Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D0B58046E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236586AbiGYTXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiGYTXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:23:50 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2049BE3B;
        Mon, 25 Jul 2022 12:23:48 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2807D5C0187;
        Mon, 25 Jul 2022 15:23:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 25 Jul 2022 15:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1658777028; x=1658863428; bh=Itqe3cTqeN
        O2sng2SyRO7speA9C+VjPJM1GP+0IL4Yc=; b=p23MTh7vV6M/9Y8DgbLcYqKxL+
        zzfF/B6G4DGFsbT9OipRrwTUV83aTB9cAnQP/uZ6tf4U+JTB9789vzCiNLgGff0P
        RS5QxyPXIl4MZa+AgDWBlQrqkXXe3pPmM52kRbt7FYpNP6PnaZKg3wvjhGiKnJN8
        aY7PSeN5wnWmyttizj8ITuiWmREI/s7T+Xqrq+eSrgDGuQfLJDyMALkO4L12wtMD
        45hFIWNC28xuV6hOFZfwhCYkSYKCsIZ4l7sWxgxDILS9vTNVE3nDkVpqcy8EAwod
        hBppe1dtNoYRvA+4xK7m1wj/bYkHEZnG/Y6VqG5htyRUkA07JrdCAINeJD4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1658777028; x=1658863428; bh=Itqe3cTqeNO2sng2SyRO7speA9C+
        VjPJM1GP+0IL4Yc=; b=MvPHNurBQRSE63/x+TnBwR5hlX0Tdnl1lktx3Lna9puq
        hdlhl2+wFKteipc+TTgAC+boFW1Z4ghGMxz20gnWEN52Cpcjq82QWjkBBGSlnh46
        wQQpd3PKvJbw/oym2dLyB1DzFchyw/cTNXBD1/8OrB2Ll1mBJlG/ER2orRQBL/n4
        FgA5AXbP2yWo+DQhuvjJ1W7XOsl80eu0JE1z9pqMWf9Po+nP0XPEtlw4O55Dhu4H
        2OQLf6cp95Gwlpf9biR5UtarGcyJMtpoic7HDaXnh7VbCaK4CkrtNY79YBTKEBXH
        lqig+RKhhiqF8bUB6S23OOdnI5APio0v7+k1YTlUvg==
X-ME-Sender: <xms:w-3eYk1XGsAVRPMu1xXflCMUtgekQE3vx880iuwT8GDoWXdKtWGmUQ>
    <xme:w-3eYvF1mP7gl-8GZb1PXljtDYmt6UA2jpB6gF_uydnCDdhoQwjlApSFg6SdGNwor
    LxjRr7wNeuRVpZxAQ>
X-ME-Received: <xmr:w-3eYs4VbRBNJcjicVJT5y3nvOYKPnLQ-n91K2t5M_3xhcE2pTlAHitLK1AYeGa36Gci2TZ0dm1pZimtYkc7sA4v8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtkedgudefiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdefhedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredt
    tddtvdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpeevuddugeeihfdtffehgffgudeggeegheetgfevhfekkeei
    leeuieejleekiedvgfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:w-3eYt3I1AKUN1RSeaRxdUs7zSvLURWTBA8XS7hDU0AIUQFSYFILEQ>
    <xmx:w-3eYnHYD2_9-UYSXuEJeHXniL0f2GlZBRt6B9DYqWpiV9Yp-O5haA>
    <xmx:w-3eYm9KR41LvOKr4-IFVG_neXZ3zATk7Yb8t_Xlhh3jhvlAPxJy9g>
    <xmx:xO3eYv9oUVYuk62pM7ieLtYRuYXHwricA_hYT-jn7UZfvnrnZsAX2Q>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Jul 2022 15:23:46 -0400 (EDT)
Date:   Mon, 25 Jul 2022 14:23:45 -0500
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Artem Savkov <asavkov@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 1/4] bpf: add BPF_F_DESTRUCTIVE flag for
 BPF_PROG_LOAD
Message-ID: <20220725192345.jlrqyfktpmttiypp@fedora>
References: <20220720114652.3020467-1-asavkov@redhat.com>
 <20220720114652.3020467-2-asavkov@redhat.com>
 <CAADnVQ+mt1iEsXUGBeL-dgXRoRwPxoz+G=aRcZTkhx2AA10R-A@mail.gmail.com>
 <YtolJfvSGjSSwbc3@sparkplug.usersys.redhat.com>
 <CAADnVQLyCc7reM1By+TYBaNGh1SBpVqyNyT+WJXOooCqX_w2GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLyCc7reM1By+TYBaNGh1SBpVqyNyT+WJXOooCqX_w2GA@mail.gmail.com>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 09:32:51PM -0700, Alexei Starovoitov wrote:
> On Thu, Jul 21, 2022 at 9:18 PM Artem Savkov <asavkov@redhat.com> wrote:
> >
> > On Thu, Jul 21, 2022 at 07:02:07AM -0700, Alexei Starovoitov wrote:
> > > On Wed, Jul 20, 2022 at 4:47 AM Artem Savkov <asavkov@redhat.com> wrote:
> > > >
> > > > +/* If BPF_F_DESTRUCTIVE is used in BPF_PROG_LOAD command, the loaded program
> > > > + * will be able to perform destructive operations such as calling bpf_panic()
> > > > + * helper.
> > > > + */
> > > > +#define BPF_F_DESTRUCTIVE      (1U << 6)
> > >
> > > I don't understand what value this flag provides.
> > >
> > > bpf prog won't be using kexec accidentally.
> > > Requiring user space to also pass this flag seems pointless.
> >
> > bpf program likely won't. But I think it is not uncommon for people to
> > run bpftrace scripts they fetched off the internet to run them without
> > fully reading the code. So the idea was to provide intermediate tools
> > like that with a common way to confirm user's intent without
> > implementing their own guards around dangerous calls.
> > If that is not a good enough of a reason to add the flag I can drop it.
>
> The intent makes sense, but bpftrace will set the flag silently.
> Since bpftrace compiles the prog it knows what helpers are being
> called, so it will have to pass that extra flag automatically anyway.
> You can argue that bpftrace needs to require a mandatory cmdline flag
> from users to run such scripts, but even if you convince the bpftrace
> community to do that everybody else might just ignore that request.
> Any tool (even libbpf) can scan the insns and provide flags.

FWIW I added --unsafe flag to bpftrace a while ago for
situations/helpers such as these. So this load flag would work OK for
bpftrace.

[...]
> Do you have other ideas to achieve the goal:
> 'cannot run destructive prog by accident' ?
>
> If we had an UI it would be a question 'are you sure? please type: yes'.
>
> I hate to propose the following, since it will delay your patch
> for a long time, but maybe we should only allow signed bpf programs
> to be destructive?

I don't have any opinion on the signing part but I do think it'd be nice
if there was some sort of opt-in mechanism. It wouldn't be very nice if
some arbitrary tracing tool panicked my machine. But I suppose tracing
programs could already do some significant damage by bpf_send_signal()ing
random processes.

Thanks,
Daniel
