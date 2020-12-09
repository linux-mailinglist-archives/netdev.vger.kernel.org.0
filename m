Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76DF2D3903
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 03:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgLICxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 21:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgLICxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 21:53:47 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74947C0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 18:53:07 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id a109so13934otc.1
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 18:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SBXsvCTSYTxp6fl+gvrd76q/m92fr/8ES4X4b+soQAI=;
        b=c6Hwvpjk0M2751JtINkMG0N/mgTHBr0SdACzhustXBnRlGS2I7As3HJzKkbjVBuH7E
         qSwI+t/vyAgZ0lnshUS3Bn8HMLZvQbCi+FCkvSS4S9FzDi8eEmJm1xfAR/O/Ut0yuw1b
         xdfXsGbh8BBbMwr/ORxKcb7AFnoFh1PR/KQ2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SBXsvCTSYTxp6fl+gvrd76q/m92fr/8ES4X4b+soQAI=;
        b=kiEheX5MQKV8GTyHkOps03D2RZG6n9HhX65f6ct0ZgBNKdHa1d6KRs4ua3Uq5SDxeN
         5yn+IUyBQdB3rV4uEHXLjN8FLbqQP7ixmH44/2PmlXmbrwxpx+hK9X263xDeU0gqEshm
         SzTfRKmEORYQBm+6KE7Z7OzBuXPZ24yUzXHQTKvR6vTsWpEVQt7RIAuFgw6DgzJmyorY
         2+/h9QVQbVNAniIFcxLtO73Jd1jQmDytmtm3MjmxE2wCusEH3RQVA22brcUkdCSqe0/a
         NoHPqzOwuhKxKo2FQltvNlQ3PhCSuJi3ACTdKGQ+GMiXMlNPdE//UL2IEls6Mtq2OXN2
         2Z3g==
X-Gm-Message-State: AOAM530VOpiTzO5VAFQBwIDgpLYyWooyQW2W01sDxHwzWG01F8XSR02b
        H+dn2rFG7JvcSqdzNmKrxu23oHzo02Rgag==
X-Google-Smtp-Source: ABdhPJzFam2lEY6ODwr1mDWwmVKm9ggDGv9BibZ3pfCk3ZcjqBmBoRHhUlBgbLh/XABMAE6c//Oxpw==
X-Received: by 2002:a9d:6b10:: with SMTP id g16mr83962otp.301.1607482385515;
        Tue, 08 Dec 2020 18:53:05 -0800 (PST)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com. [209.85.167.175])
        by smtp.gmail.com with ESMTPSA id g3sm64173oif.26.2020.12.08.18.53.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 18:53:04 -0800 (PST)
Received: by mail-oi1-f175.google.com with SMTP id o25so221256oie.5
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 18:53:04 -0800 (PST)
X-Received: by 2002:aca:d696:: with SMTP id n144mr330067oig.77.1607482383969;
 Tue, 08 Dec 2020 18:53:03 -0800 (PST)
MIME-Version: 1.0
References: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
 <20201204111715.04d5b198@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87tusxgar5.fsf@codeaurora.org> <CA+ASDXNT+uKLLhTV0Nr-wxGkM16_OkedUyoEwx5FgV3ML9SMsQ@mail.gmail.com>
 <20201207121029.77d48f2c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207121029.77d48f2c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 8 Dec 2020 18:52:51 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNLvxKncpj4YJ2PnD9+wStZ6VjChQp4J=bqeXawMTsrmg@mail.gmail.com>
Message-ID: <CA+ASDXNLvxKncpj4YJ2PnD9+wStZ6VjChQp4J=bqeXawMTsrmg@mail.gmail.com>
Subject: Re: pull-request: wireless-drivers-next-2020-12-03
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Dec 7, 2020 at 12:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 7 Dec 2020 11:35:53 -0800 Brian Norris wrote:
> > On Mon, Dec 7, 2020 at 2:42 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> > > Jakub Kicinski <kuba@kernel.org> writes:
> > > > On Thu,  3 Dec 2020 18:57:32 +0000 (UTC) Kalle Valo wrote:
> > > > There's also a patch which looks like it renames a module parameter.
> > > > Module parameters are considered uAPI.
> > >
> > > Ah, I have been actually wondering that if they are part of user space
> > > API or not, good to know that they are. I'll keep an eye of this in the
> > > future so that we are not breaking the uAPI with module parameter
> > > changes.
> >
> > Is there some reference for this rule (e.g., dictate from on high; or
> > some explanation of reasons)? Or limitations on it? Because as-is,
> > this sounds like one could never drop a module parameter, or remove
> > obsolete features.
>
> TBH its one of those "widely accepted truth" in networking which was
> probably discussed before I started compiling kernels so I don't know
> the full background. But it seems pretty self-evident even without
> knowing the casus that made us institute the rule.
>
> Module parameters are certainly userspace ABI, since user space can
> control them either when loading the module or via sysfs.

I'm not sure it's as self-evident as you claim. Similar arguments
could be made of debugfs (it's even typically mounted under /sys, so
one could accidentally think it *is* sysfs!), except that somewhere
along the line it has been decreed to not be a stable interface.

But anyway, I can acknowledge it's a "widely accepted truth [in some
circles]" and act accordingly (e.g., closer review on their
introduction). I'll also maintain my counter-acknowledgment, that this
approach is not universal. Taking another subystem (fs/) as an
example, I didn't have to look far for similar approaches, where
module parameters were removed as features became obsolete, handled
automatically, etc.:

d3df14535f4a ext4: mballoc: make mb_debug() implementation to use pr_debug()
1565bdad59e9 fscrypt: remove struct fscrypt_ctx
73d03931be2f erofs: kill use_vmap module parameter

Although to be fair, I did find at least one along the way where the
author made a special attempt at a "deprecation notice" while handling
it gracefully:

791205e3ec60 pstore/ram: Introduce max_reason and convert dump_oops

I wouldn't be surprised if that module parameter disappears eventually
though, with little fanfare.

> > It also suggests that debug-related knobs (which
> > can benefit from some amount of flexibility over time) should go
> > exclusively in debugfs (where ABI guarantees are explicitly not made),
> > even at the expense of usability (dropping a line into
> > /etc/modprobe.d/ is hard to beat).
>
> Indeed, debugfs seems more appropriate.

I'll highlight (and agree with) Emmanuel's notice that debugfs is not
a suitable replacement in some cases. I'd still agree debugfs is
better where possible though, because it's clearer about the
(in)stability guarantees, and harder for users to "set and forget"
(per your below notes).

> > Should that parameter have never been introduced in the first place,
> > never be removed, or something else? I think I've seen this sort of
> > pattern before, where features get phased in over time, with module
> > parameters as either escape hatches or as opt-in mechanisms.
> > Eventually, they stabilize, and there's no need (or sometimes, it's
> > actively harmful) to keep the knob around.
...
> If I'm reading this right the pattern seems to be that module
> parameters are used as chicken bits. It's an interesting problem,
> I'm not sure this use case was discussed. My concern would be that
> there is no guarantee users will in fact report the new feature
> fails for them, and therefore grow to depend on the chicken bits.

That's a valid concern. I'm not sure what to do about that, beyond
documentation (which such users probably fail to read) or maybe loud
WARN() prints (which such users could easily ignore).

> Since updating software is so much easier than re-etching silicon
> I'd personally not use chicken bits in software, especially with
> growing adoption of staggered update roll outs.

I'm not sure I understand this sentence; it's perfectly easy to handle
all manner of changed/dropped module params through staged rollout. If
a param is deleted, one can keep it in their modprobe.d configs until
it's fully phased out. If it's renamed with a slightly different
purpose, encode both purposes in your configs. Et cetera.

Brian

> Otherwise I'd think
> debugfs is indeed a better place for them.
