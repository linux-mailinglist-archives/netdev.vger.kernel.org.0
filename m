Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5432C5795
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391259AbgKZOxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391236AbgKZOxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:53:40 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18D2C0613D4;
        Thu, 26 Nov 2020 06:53:39 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id x17so1860920ybr.8;
        Thu, 26 Nov 2020 06:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DTotsfb8u+PB0eT0g4gTrA/vgT4HfiDZTYQ/geteWC4=;
        b=QWuS1TBfImi/m9J+5lB37414TjwoB+kfRyX/7ohuLNDuEazbBA4fEE506RPmuhzrQT
         KCYao+uRLv4Su9SW/eKLjGfymcNDAcVP9irkT5MfO/ys+N1YXqwwODp/at6Hjf5mbn7y
         sEjBq+fitA5RwLT9szzutyPemHxF/3vzz+qMkDnIA1HF+rIjtAU7PcoRO+GQ0ANzP2/3
         4RgPAdoGGim7svP8Zrp9IWC0s7kVtrSQn/PXobh5aGfJoVk3uyVZYliED/q0Nk6tCoA8
         W9fyUHPup50QVVdVd9NqYx0m2pkDUcyuxLwwV68mOS3NFLJOgvtFKpngAgg7rBEfKLyO
         Kn5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DTotsfb8u+PB0eT0g4gTrA/vgT4HfiDZTYQ/geteWC4=;
        b=CxT71O0skNbqxZZYNrpNlfBXq/yMv1hzDrC5LNOqokEKnWAtdhpwuPiLpmVQtcybTz
         GmVYTQTYdRA9BeL6JxLp85IwMFcGLoHB00wjH3pQW/M3azObMsF69eNnY/RvzAuCoOmP
         nPuRviVwfj0JspS302WOmLcIthMr2Clo96XzEj29bZHn8a0RKRPo1brxojfOcUQjQMbt
         waS9T4c5qKAZJhX4rtBV7b4zJbfKrBk4QOoppRxT2C8DiZEGMJc8bTRcT25slxgckcUq
         agaWJ1OBs5yElrMd0OxJ6s4/iS1mXC/WWIXwg+Rar+U1Pc9ZAIS+28QwOafTeoND3SOG
         +m3w==
X-Gm-Message-State: AOAM530F+PtCE6W3dasrBf+SXkck7DF01rsPxEsPsL2tWjxsvGYKBsHj
        2SbaV3tICxAkScyGHC9VVtyJGvT3MqJ3feW3Qck=
X-Google-Smtp-Source: ABdhPJxnOXTYq+iR4KCiqWmvI5brXjGTtWFP5n3J8AJAa70YoLiXvitjZtrbfPlByRts+Q0mJZBucXgMnTrbOCoAA44=
X-Received: by 2002:a25:aac5:: with SMTP id t63mr5128050ybi.22.1606402419264;
 Thu, 26 Nov 2020 06:53:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605896059.git.gustavoars@kernel.org> <20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011201129.B13FDB3C@keescook> <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011220816.8B6591A@keescook> <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
 <CANiq72nZrHWTA4_Msg6MP9snTyenC6-eGfD27CyfNSu7QoVZbw@mail.gmail.com>
 <1c7d7fde126bc0acf825766de64bf2f9b888f216.camel@HansenPartnership.com>
 <CANiq72m22Jb5_+62NnwX8xds2iUdWDMAqD8PZw9cuxdHd95W0A@mail.gmail.com>
 <fc45750b6d0277c401015b7aa11e16cd15f32ab2.camel@HansenPartnership.com>
 <CANiq72k5tpDoDPmJ0ZWc1DGqm+81Gi-uEENAtvEs9v3SZcx6_Q@mail.gmail.com>
 <4993259d01a0064f8bb22770503490f9252f3659.camel@HansenPartnership.com>
 <CANiq72kqO=bYMJnFS2uYRpgWATJ=uXxZuNUsTXT+3aLtrpnzvQ@mail.gmail.com> <44005bde-f6d4-5eaa-39b8-1a5efeedb2d3@gmail.com>
In-Reply-To: <44005bde-f6d4-5eaa-39b8-1a5efeedb2d3@gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 26 Nov 2020 15:53:27 +0100
Message-ID: <CANiq72nobq=ptWK-qWxU91JHqkKhMcRtJNnw2XJd5-vSJWZd8Q@mail.gmail.com>
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        bridge@lists.linux-foundation.org, ceph-devel@vger.kernel.org,
        cluster-devel@redhat.com, coreteam@netfilter.org,
        devel@driverdev.osuosl.org, dm-devel@redhat.com,
        drbd-dev@lists.linbit.com,
        dri-devel <dri-devel@lists.freedesktop.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
        keyrings@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-acpi@vger.kernel.org, linux-afs@lists.infradead.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-atm-general@lists.sourceforge.net,
        linux-block@vger.kernel.org, linux-can@vger.kernel.org,
        linux-cifs@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fbdev@vger.kernel.org, linux-geode@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-i3c@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
        op-tee@lists.trustedfirmware.org, oss-drivers@netronome.com,
        patches@opensource.cirrus.com, rds-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, samba-technical@lists.samba.org,
        selinux@vger.kernel.org, target-devel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        usb-storage@lists.one-eyed-alien.net,
        virtualization@lists.linux-foundation.org,
        wcn36xx@lists.infradead.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        xen-devel@lists.xenproject.org, linux-hardening@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 11:44 PM Edward Cree <ecree.xilinx@gmail.com> wrote=
:
>
> To make the intent clear, you have to first be certain that you
>  understand the intent; otherwise by adding either a break or a
>  fallthrough to suppress the warning you are just destroying the
>  information that "the intent of this code is unknown".

If you don't know what the intent of your own code is, then you
*already* have a problem in your hands.

> Figuring out the intent of a piece of unfamiliar code takes more
>  than 1 minute; just because
>     case foo:
>         thing;
>     case bar:
>         break;
>  produces identical code to
>     case foo:
>         thing;
>         break;
>     case bar:
>         break;
>  doesn't mean that *either* is correct =E2=80=94 maybe the author meant

What takes 1 minute is adding it *mechanically* by the author, i.e. so
that you later compare whether codegen is the same.

>  to write
>     case foo:
>         return thing;
>     case bar:
>         break;
>  and by inserting that break you've destroyed the marker that
>  would direct someone who knew what the code was about to look
>  at that point in the code and spot the problem.

Then it means you already have a bug. This patchset gives the
maintainer a chance to notice it, which is a good thing. The "you've
destroyed the market" claim is bogus, because:
  1. you were not looking into it
  2. you didn't notice the bug so far
  3. is implicit -- harder to spot
  4. is only useful if you explicitly take a look at this kind of bug.
So why don't you do it now?

> Thus, you *always* have to look at more than just the immediate
>  mechanical context of the code, to make a proper judgement that
>  yes, this was the intent.

I find that is the responsibility of the maintainers and reviewers for
tree-wide patches like this, assuming they want. They can also keep
the behavior (and the bugs) without spending time. Their choice.

> If you think that that sort of thing
>  can be done in an *average* time of one minute, then I hope you
>  stay away from code I'm responsible for!

Please don't accuse others of recklessness or incompetence, especially
if you didn't understand what they said.

> A warning is only useful because it makes you *think* about the
>  code.  If you suppress the warning without doing that thinking,
>  then you made the warning useless; and if the warning made you
>  think about code that didn't *need* it, then the warning was
>  useless from the start.

We are not suppressing the warning. Quite the opposite, in fact.

> So make your mind up: does Clang's stricter -Wimplicit-fallthrough
>  flag up code that needs thought (in which case the fixes take
>  effort both to author and to review)

As I said several times already, it does take time to review if the
maintainer wants to take the chance to see if they had a bug to begin
with, but it does not require thought for the author if they just go
for equivalent codegen.

> or does it flag up code
>  that can be mindlessly "fixed" (in which case the warning is
>  worthless)?  Proponents in this thread seem to be trying to
>  have it both ways.

A warning is not worthless just because you can mindlessly fix it.
There are many counterexamples, e.g. many
checkpatch/lint/lang-format/indentation warnings, functional ones like
the `if (a =3D b)` warning...

Cheers,
Miguel
