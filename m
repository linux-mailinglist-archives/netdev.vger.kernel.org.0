Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F772C5A34
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 18:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404345AbgKZRGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 12:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391545AbgKZRF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 12:05:59 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC77C0617A7;
        Thu, 26 Nov 2020 09:05:58 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id r127so2177763yba.10;
        Thu, 26 Nov 2020 09:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/jaIJrbif54isUECHds/J8Ujq0NdoNxUTCCwJWwQ80=;
        b=YymqsvqKytU8xghgrWvO9q2MBm/qo/QfMLfSKpWw4/r/4uRHhZxuPq9ek+nW3ctzYi
         vs3zi1yLEuFoGUDgrnF15wpJAK9RqJ1aO9sTXa0PjOzjLe+d4O/pTFiiO013Mx2qKoL4
         SkUMUUIjag5bjqwHGLYc9f20TwOaOWbGTale/6i8ahvnaZymX26ArF3ReuQKFVdof495
         iKDDkr6mQvIIbdynQAd2wxd2GUAuBku/vDm4jIdtOw4Ph7wkJ5rD2TxigEVm3yQ5C9tu
         pJCfZKqtAfLebSyeKrm6VDCN2G4oKvj4TFU9uFOnavPNoLjuB5eIt+ODZ6yyvDDDthAD
         GeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/jaIJrbif54isUECHds/J8Ujq0NdoNxUTCCwJWwQ80=;
        b=aBKS9dP5F50l3Jly7k9SSc/LK5erhBpycSZOv4wk5BN5RL5nJRXG22JXb51uhHUZXT
         KIo7NPNuDQAaoFptzyQLY5+V165LaaM4A3SDftsG6r8jUKFTe3kOZlTNhFO98Omgyp9Q
         a9Nhl4BC3JSKnQNtrA5BlkEEIiNZTXLFXBewv/QXrjtqSWNsWQaFfWQufRE4KuzbXqKR
         PzrYxYYizDdcU7tHSLlPDoetCmkwwegjts2/MTRKSxYZHry2gE2IZ3EABAxgsDNNKkjr
         HczI/bTiV/H0UdQWLP6YbSuhnjf+4UX9HDOCvOW26oy0A/Bet4FJA2uZGgwPUNbj9RMn
         pyQw==
X-Gm-Message-State: AOAM532cLFujGBf04/OSYyfwCvyItoqdB5R+dfwsdw217khsKAQ0vy+N
        l26UMdbWZCDXWtXxdN3IQjQv/nw3FiJxL8cvQg0=
X-Google-Smtp-Source: ABdhPJxMy5ncXEZ6TSWkZ0cAXTnkQ7iw+jjdg+cNNUWTZPlZcmFMrQQcJd2JAoeBontKFrtwmzLazAacI3fdsjx9xvQ=
X-Received: by 2002:a5b:40e:: with SMTP id m14mr4835621ybp.33.1606410357153;
 Thu, 26 Nov 2020 09:05:57 -0800 (PST)
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
 <CANiq72kqO=bYMJnFS2uYRpgWATJ=uXxZuNUsTXT+3aLtrpnzvQ@mail.gmail.com>
 <44005bde-f6d4-5eaa-39b8-1a5efeedb2d3@gmail.com> <CANiq72nobq=ptWK-qWxU91JHqkKhMcRtJNnw2XJd5-vSJWZd8Q@mail.gmail.com>
 <CAMuHMdV5kOakvZJMWLxbpigFPS+Xuw6DVYsWCWZy7wGsv3idcw@mail.gmail.com>
In-Reply-To: <CAMuHMdV5kOakvZJMWLxbpigFPS+Xuw6DVYsWCWZy7wGsv3idcw@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 26 Nov 2020 18:05:45 +0100
Message-ID: <CANiq72=n4rVvmKt0RCb5aOfQydA8bgDxfntRLDieV8Q2efP8Zg@mail.gmail.com>
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-atm-general@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-ide@vger.kernel.org, dm-devel@redhat.com,
        keyrings@vger.kernel.org,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
        samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        usb-storage@lists.one-eyed-alien.net,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        oss-drivers@netronome.com, bridge@lists.linux-foundation.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        linux-stm32@st-md-mailman.stormreply.com, cluster-devel@redhat.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org,
        linux-input <linux-input@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, selinux@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-geode@lists.infradead.org, linux-can@vger.kernel.org,
        linux-block@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        op-tee@lists.trustedfirmware.org,
        linux-mediatek@lists.infradead.org, xen-devel@lists.xenproject.org,
        Nouveau Dev <nouveau@lists.freedesktop.org>,
        linux-hams@vger.kernel.org,
        ceph-devel <ceph-devel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-hwmon@vger.kernel.org,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        GR-Linux-NIC-Dev@marvell.com,
        tipc-discussion@lists.sourceforge.net,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-sctp@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        patches@opensource.cirrus.com, Joe Perches <joe@perches.com>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 4:28 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> The maintainer is not necessarily the owner/author of the code, and
> thus may not know the intent of the code.

Agreed, I was not blaming maintainers -- just trying to point out that
the problem is there :-)

In those cases, it is still very useful: we add the `fallthrough` and
a comment saying `FIXME: fallthrough intended? Figure this out...`.
Thus a previous unknown unknown is now a known unknown. And no new
unknown unknowns will be introduced since we enabled the warning
globally.

> BTW, you cannot mindlessly fix the latter, as you cannot know if
> "(a == b)" or "((a = b))" was intended, without understanding the code
> (and the (possibly unavailable) data sheet, and the hardware, ...).

That's right, I was referring to the cases where the compiler saves
someone time from a typo they just made.

Cheers,
Miguel
