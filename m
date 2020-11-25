Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5756F2C4645
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 18:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbgKYREa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 12:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730445AbgKYRE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 12:04:27 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3713EC0613D4;
        Wed, 25 Nov 2020 09:04:27 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id k65so372661ybk.5;
        Wed, 25 Nov 2020 09:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U7yONu+GErpj3wVA3mUEvd1gZrZu1iMtuB4J5cc4iYs=;
        b=bn+pL/HmrYW2tlvsO08UsmlB+e0sDsIo/gBe6lZBPy5Ml0r7IepVRmwL3Z1msCDTmB
         4Fj8yYJnSSwKpycrMD6jc9mJYcLEOxyjBt+mj/swgeJwfcTqBWFSYbINT99XJh8MBLLG
         BhdJX4URpdAlU1PS41QCV8cX0uycEbKi5uankHMmLYXfRheyb1dBSnJ2lYbkM9jPzYRg
         +YL1Fiv4xli6A/G5oR00+c/fqffNKJdLOgNLmafCTxGe8sUqpvTjraMjrzXLQkd2Vyg7
         6NJIAQ3gm8Ro9XvzXTxxo6aHXEqSB5bdv5UB5bHkEX37ZUG4NR8CwSl4aaovOFcf7q/J
         MTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U7yONu+GErpj3wVA3mUEvd1gZrZu1iMtuB4J5cc4iYs=;
        b=ql30V3/AY7QbTMGqCub08su8oTMfUmvr1t/8CGEB/Lm0R2uEQRfW5f7BPJ6qJSyf9O
         oKDvxOFt8OkoogAW/nlox1l/9SJ1QniYGNKbxfDUXpq1zOm3BaaH3b4VS31/LVWDMP5e
         CrMPqXQNH3b04Efsg6bCOUG7G7sFsn4yoFrIMb+/j2JY2r1NWBWG0h4WXyB1umkxWOJN
         fMLHNEFf0Gkx6XN/Im6mlOmyD2cEM8TwDxC59mjJlqYwDgkGUn2Piq6DQZzjxReoLpQl
         dm5DrX9VI1QOJslbqDKuEmXE4XZAl1RzlPhaXjmWihBeaj1ERLip07fPe+/klbdcl/d+
         uWDw==
X-Gm-Message-State: AOAM530HmG34Xxl9oraCKyjbygTOo6DKP6lHLUss0CcIqkOH+yOkn21G
        1oFu9S/7uVuDI3sLQvvyJ1JRtJr+jQGWeffKiZM=
X-Google-Smtp-Source: ABdhPJwRDTWwRnnt/vVfXeVU3lUNCXdaAf9CCrzUJdkBRbFdtXrCpJBbeymEiGhAam+E5oqqQjDTbAdkVQMGwErIDPw=
X-Received: by 2002:a25:aac5:: with SMTP id t63mr6307293ybi.22.1606323866493;
 Wed, 25 Nov 2020 09:04:26 -0800 (PST)
MIME-Version: 1.0
References: <202011201129.B13FDB3C@keescook> <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011220816.8B6591A@keescook> <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
 <ca071decb87cc7e905411423c05a48f9fd2f58d7.camel@perches.com>
 <0147972a72bc13f3629de8a32dee6f1f308994b5.camel@HansenPartnership.com>
 <d8d1e9add08cdd4158405e77762d4946037208f8.camel@perches.com>
 <dbd2cb703ed9eefa7dde9281ea26ab0f7acc8afe.camel@HansenPartnership.com>
 <20201123130348.GA3119@embeddedor> <8f5611bb015e044fa1c0a48147293923c2d904e4.camel@HansenPartnership.com>
 <202011241327.BB28F12F6@keescook> <a841536fe65bb33f1c72ce2455a6eb47a0107565.camel@HansenPartnership.com>
 <CAKwvOdkGBn7nuWTAqrORMeN1G+w3YwBfCqqaRD2nwvoAXKi=Aw@mail.gmail.com> <20201125082405.1d8c23dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125082405.1d8c23dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 25 Nov 2020 18:04:15 +0100
Message-ID: <CANiq72=RuekXf1O6Fxrz2Eend0GtS6=E72P4T2=48SDqVcTChA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 000/141] Fix fall-through warnings for Clang
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Joe Perches <joe@perches.com>, alsa-devel@alsa-project.org,
        linux-atm-general@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-fbdev@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-ide@vger.kernel.org, dm-devel@redhat.com,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
        samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        usb-storage@lists.one-eyed-alien.net, drbd-dev@lists.linbit.com,
        devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org,
        linux-rdma@vger.kernel.org, oss-drivers@netronome.com,
        bridge@lists.linux-foundation.org,
        linux-security-module@vger.kernel.org,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        linux-stm32@st-md-mailman.stormreply.com, cluster-devel@redhat.com,
        linux-acpi@vger.kernel.org, coreteam@netfilter.org,
        intel-wired-lan@lists.osuosl.org,
        linux-input <linux-input@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-watchdog@vger.kernel.org, selinux@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, linux-geode@lists.infradead.org,
        linux-can@vger.kernel.org, linux-block@vger.kernel.org,
        linux-gpio@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        linux-mediatek@lists.infradead.org, xen-devel@lists.xenproject.org,
        nouveau@lists.freedesktop.org, linux-hams@vger.kernel.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-hwmon@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
        Linux Memory Management List <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net, linux-mmc@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-sctp@vger.kernel.org, linux-usb@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        =?UTF-8?Q?open_list=3AHARDWARE_RANDOM_NUMBER_GENERATOR_CORE_=3Clinux=2Dcrypt?=
         =?UTF-8?Q?o=40vger=2Ekernel=2Eorg=3E=2C_patches=40opensource=2Ecirrus=2Ecom=2C_linux=2Dint?=
         =?UTF-8?Q?egrity=40vger=2Ekernel=2Eorg=2C_target=2Ddevel=40vger=2Ekernel=2Eorg=2C_linux=2D?=
         =?UTF-8?Q?hardening=40vger=2Ekernel=2Eorg=2C_Jonathan_Cameron_=3CJonathan=2ECamero?=
         =?UTF-8?Q?n=40huawei=2Ecom=3E=2C_Greg_KH?= 
        <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 5:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> And just to spell it out,
>
> case ENUM_VALUE1:
>         bla();
>         break;
> case ENUM_VALUE2:
>         bla();
> default:
>         break;
>
> is a fairly idiomatic way of indicating that not all values of the enum
> are expected to be handled by the switch statement.

It looks like a benign typo to me -- `ENUM_VALUE2` does not follow the
same pattern like `ENUM_VALUE1`. To me, the presence of the `default`
is what indicates (explicitly) that not everything is handled.

> Applying a real patch set and then getting a few follow ups the next day
> for trivial coding things like fallthrough missing or static missing,
> just because I didn't have the full range of compilers to check with
> before applying makes me feel pretty shitty, like I'm not doing a good
> job. YMMV.

The number of compilers, checkers, static analyzers, tests, etc. we
use keeps going up. That, indeed, means maintainers will miss more
things (unless maintainers do more work than before). But catching
bugs before they happen is *not* a bad thing.

Perhaps we could encourage more rebasing in -next (while still giving
credit to bots and testers) to avoid having many fixing commits
afterwards, but that is orthogonal.

I really don't think we should encourage the feeling that a maintainer
is doing a bad job if they don't catch everything on their reviews.
Any review is worth it. Maintainers, in the end, are just the
"guaranteed" reviewers that decide when the code looks reasonable
enough. They should definitely not feel pressured to be perfect.

Cheers,
Miguel
