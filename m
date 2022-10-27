Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDB360F31D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 11:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiJ0JCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 05:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbiJ0JBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 05:01:39 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659E31EADC;
        Thu, 27 Oct 2022 02:01:35 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5029F320093C;
        Thu, 27 Oct 2022 05:01:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 27 Oct 2022 05:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1666861291; x=1666947691; bh=rMDXDmInnn
        n3apmcgfz7oqvT7y5En/5bpNpI3tjFcBQ=; b=wXqoMDIaQ1UFf6fGuUd9LAeJDl
        YpS05zuNqVB6kZVvte3cRjAlzU+gGlXDNS5Fqeds2XThPZE2/oKoQjB3N+1siaz7
        lMyEGp66RSefYL8f9xbhMXgZIGHjpO3LSemwLdcy2NawTu1mzAowCPj4XDFZehNi
        lfr6vzT3aUO28BVF3HLtewQ5V3TscQtXpDPoKuieqB+4zsyMycwduF6SYXBytobz
        GMG6Hk+oN3u0Sp0bHg3ly/HG2U5dhDrFPa4bBdFKJh0sGkE+E/HzOMoeO2oBqVFe
        ddFYMPi/QsUEmXVB5KSEt4KKUzi8pAOHTd3C5yXLDRdUIWiw8yL1td6BgAng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666861291; x=1666947691; bh=rMDXDmInnnn3apmcgfz7oqvT7y5E
        n/5bpNpI3tjFcBQ=; b=M+iQ67tfFjJVqEE2ZgCcG+WgT0a0PFxLRngshfmWffB9
        0coNPYe+y04ug901LzALqceDsUV0Fo7zBz3py6Ba41844rFdEAHViKcCq6TDFRZZ
        RpNzm3Vdbb4229tMFl2dYotwpPnB72VmXOxnV6g/K+sK3cGcFrzVqQ/bS5Q28j9x
        UG8rU1q0NpvnPfEg+CCNDVb8C2V4dx2RrHKWCdJOiW/YrYmRt8bcWb1Yr8LbsYkd
        BLiyASe0c9JL/itNRuT2+0Go43+yh6TSGWiY+jcQXhjoJTSns7mo8rAp2Cv7I1Mu
        BiI9E47oGLr69mTzcv6mqE5ucvS+1+CRoQkbcK8J+w==
X-ME-Sender: <xms:60haY-dDDZ4IZAyaYupe94erqRmxWKsHoNeR2uiX7jENJulqqqMvwQ>
    <xme:60haY4OPkWlc24CM5OetM6l8jlT-srIdbE7mIUwvMR8_wG0V8MH-Hko__ZnVKEIsM
    nRoZQye-2EntgMAjg>
X-ME-Received: <xmr:60haY_gkDpi3AydHTSefzcnMXGU0RgjtYaR1lkj4UbExzHlQwU_-_cn157TZl-GqtLqTmz6hRdaE8BG3aLa7>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdefhedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddt
    vdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqeenuc
    ggtffrrghtthgvrhhnpeevuddugeeihfdtffehgffgudeggeegheetgfevhfekkeeileeu
    ieejleekiedvgfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:60haY7_5v9wO0K5Oom2yTqdbZGSh7EgY8a6bFJzhvP1n6GTk6enSlQ>
    <xmx:60haY6u0dpIVFBqtT2mezalXDVSp5LG3sLEtlvoLulQ83KMX_MmYGA>
    <xmx:60haYyErZ1s219j6ED6oB14URiYiWewyVmAVNJCr6tHbYf2wWrD0gg>
    <xmx:60haY_O_wYGakplMWRt2ZzvQ_W1J-UjJnPBu3ER3K5DoV4ygs2yVnA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 05:01:26 -0400 (EDT)
Date:   Thu, 27 Oct 2022 03:01:32 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joe Stringer <joe@cilium.io>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach
 tc BPF programs
Message-ID: <20221027090132.s6fsqeo3z4s3vphj@k2>
References: <875ygvemau.fsf@toke.dk>
 <Y0BaBUWeTj18V5Xp@google.com>
 <87tu4fczyv.fsf@toke.dk>
 <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
 <8cc9811e-6efe-3aa5-b201-abbd4b10ceb4@iogearbox.net>
 <CAADnVQLpcLWrL-URhRgqCQa6XRZzib4BorZ2QKpPC+Uw_JNW=Q@mail.gmail.com>
 <87sfjysfxt.fsf@toke.dk>
 <20221008203832.7syl3rbt6lblzqxk@macbook-pro-4.dhcp.thefacebook.com>
 <CAEf4BzbFawYvHBWZEh2RN+YMv6r2kEiVNXFVZqXRH1eWK+u_UA@mail.gmail.com>
 <CAADnVQLyff07uCCj6SaA0=DQ1FsKsgpP01+sptWiTYSVoam=ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLyff07uCCj6SaA0=DQ1FsKsgpP01+sptWiTYSVoam=ag@mail.gmail.com>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Fri, Oct 14, 2022 at 08:38:52AM -0700, Alexei Starovoitov wrote:
> On Thu, Oct 13, 2022 at 11:30 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >

[...]

> > No one proposed a slight variation on what Daniel was proposing with
> > prios that might work just as well. So for completeness, what if
> > instead of specifying 0 or explicit prio, we allow specifying either:
> >   - explicit prio, and if that prio is taken -- fail
> >   - min_prio, and kernel will find smallest untaken prio >= min_prio;
> > we can also define that min_prio=-1 means append as the very last one.
> >
> > So if someone needs to be the very first -- explicitly request prio=1.
> > If wants to be last: prio=0, min_prio=-1. If we want to observe, we
> > can do something like min_prio=50 to leave a bunch of slots free for
> > some other programs for which exact order matters.
> 
> Daniel, was suggesting more or less the same thing.
> My point is that prio is an unnecessary concept and uapi
> will be stuck with it. Including query interface
> and bpftool printing it.

I apologize if I'm piling onto the bikeshedding, but I've been working a
lot more with TC bpf lately so I thought I'd offer some thoughts.

I quite like the intent of this patchset; it'll help simply using TC bpf
greatly. I also think what Andrii is suggesting makes a lot of sense. My
biggest gripe with TC priorities is that:

1. "Priority" is a rather arbitrary concept and hard to come up with
values for.

2. The default replace-on-collision semantic (IIRC) is error prone as
evidenced by this patch's motivation.

My suggestion here is to rename "priority" -> "position". Maybe it's
just me but I think "priority" is too vague of a concept whereas a
0-indexed "position" is rather unambiguous.

> 
> > This whole before/after FD interface seems a bit hypothetical as well,
> > tbh.
> 
> The fd approach is not better. It's not more flexible.
> That was not the point.
> The point is that fd does not add stuff to uapi that
> bpftool has to print and later the user has to somehow interpret.
> prio is that magic number that users would have to understand,
> but for them it's meaningless. The users want to see the order
> of progs on query and select the order on attach.

While I appreciate how the FD based approach leaves less confusing
values for bpftool to dump, I see a small semantic ambiguity with it:

For example, say we start with a single prog, A. Then add B as
"after-A".  Then add C as "before-B". It's unclear what'll happen.
Either you invalidate B's guarantees or you return an error. If you
invalidate, that's unfortunate. If you error, how does userspace retry?
You'd have to express all the existing relationships to the user thru
through bpftool or something. Whereas with Andrii's proposal it's
unambiguous.

[...]

Thanks,
Daniel
