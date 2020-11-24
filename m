Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864302C1AF0
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 02:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgKXBdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 20:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730068AbgKXBdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 20:33:09 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1C7C09424B
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 17:33:05 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id w16so3606365pga.9
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 17:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Fpt+3NGNjcuXPoKd+YKzvfWCCI+i2QS11ln4xb/K2c=;
        b=mZ10EKN9Q6HwSmECmmsUHbUHF/oTLT4c/YpQVGCE0gPLnlz6SgHQW3ieQ7zeUHJnUi
         XUPs+F1GoZaFLBKWU3CvMTPUTS8a5+RdM3NBjgdsJpNB5L7Gee8a5rDblh6bnWIWT9TK
         uir+AjWjaGJnRAA0K84IM0yu+WQnaSePUaJNJPiE7LfLBhB3Pd0A4gWblql3Lao7defI
         n9Uw15itvZVSId22hyle+f6GM1M4THjCwMgL7v1hyU5f7oNm+YC3/Fk6KnTIGBq7Lgby
         +eM5Ju8Jh9l5BxBe3HwjA5bt+bnUjVm7e9zM9zQUlIbVcSVLiqKYS2m+arIIzBAIXu/j
         s+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Fpt+3NGNjcuXPoKd+YKzvfWCCI+i2QS11ln4xb/K2c=;
        b=f4GKOgb4tLrGUKdil++KacW/ZZjqMsNtMvJLHnhzLbPpfoZcLxzNQC8iMSxoWBjojH
         bFajPr9LP9cIgMfHkVieDwfnWudxbIATDNQQ+7jbsRiGJXq7RzgrwWI9DHu6vTXNxjLr
         I0suyes1BFtwNOASj96/E5PGV6oR1BBe3LY6LsquFXKaLIDAziVazEhsIxTYcDkGcora
         JBPANc2hjRJGtKVF6nddAp3IW6h4l/bdVvRtzImY/i2veUfmzJzMQBJZDc2Iozizr9rM
         wW0lKH30y0V/d7zthP2g7MdXX4syqFD1VUAfGk7aBc+HGANO5fN5zZ8NBrlz/8coB2AQ
         DYpA==
X-Gm-Message-State: AOAM531a06yuHWIx51s9F391kxlSWvpNtW633JL0FYF21DqJqM3DdQHU
        +XH3xxPCWBW/HrSqD2xr4Esn5KDcXpJqFmjtArpGSg==
X-Google-Smtp-Source: ABdhPJwQDF2vxX46wbajF4ioOOwzM/J33jC4qlEIQ0nX0CJ8Ae2/iYNAtfiNkgC6UbM9BT3sKlieSNPFWrTquhIIwSk=
X-Received: by 2002:a65:6a4e:: with SMTP id o14mr1859973pgu.263.1606181584110;
 Mon, 23 Nov 2020 17:33:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605896059.git.gustavoars@kernel.org> <20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011201129.B13FDB3C@keescook> <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011220816.8B6591A@keescook>
In-Reply-To: <202011220816.8B6591A@keescook>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 23 Nov 2020 17:32:51 -0800
Message-ID: <CAKwvOdntVfXj2WRR5n6Kw7BfG7FdKpTeHeh5nPu5AzwVMhOHTg@mail.gmail.com>
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
To:     Kees Cook <keescook@chromium.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
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
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net,
        linux-ext4@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-geode@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i3c@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
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
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 8:17 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Nov 20, 2020 at 11:51:42AM -0800, Jakub Kicinski wrote:
> > If none of the 140 patches here fix a real bug, and there is no change
> > to machine code then it sounds to me like a W=2 kind of a warning.
>
> FWIW, this series has found at least one bug so far:
> https://lore.kernel.org/lkml/CAFCwf11izHF=g1mGry1fE5kvFFFrxzhPSM6qKAO8gxSp=Kr_CQ@mail.gmail.com/

So looks like the bulk of these are:
switch (x) {
  case 0:
    ++x;
  default:
    break;
}

I have a patch that fixes those up for clang:
https://reviews.llvm.org/D91895

There's 3 other cases that don't quite match between GCC and Clang I
observe in the kernel:
switch (x) {
  case 0:
    ++x;
  default:
    goto y;
}
y:;

switch (x) {
  case 0:
    ++x;
  default:
    return;
}

switch (x) {
  case 0:
    ++x;
  default:
    ;
}

Based on your link, and Nathan's comment on my patch, maybe Clang
should continue to warn for the above (at least the `default: return;`
case) and GCC should change?  While the last case looks harmless,
there were only 1 or 2 across the tree in my limited configuration
testing; I really think we should just add `break`s for those.
-- 
Thanks,
~Nick Desaulniers
