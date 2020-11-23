Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C411D2C0FA6
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389817AbgKWP6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:58:15 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:35000 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732564AbgKWP6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:58:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 82CCB12803A5;
        Mon, 23 Nov 2020 07:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1606147090;
        bh=lBjYTVUJkmNX+Ql1BcMOHCS5uLgrfuyir/PBRp4vAgY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=tw2BKkTzWzFWEQdrm6zgBKJtIh2PRfv5Mb0TfkjZKqSr5KeTmWZWgl8VEPx5No8bX
         gdEQ1NYoCzrZ51ueWl3PIAwT19fSirwyiz4cqIKbNqhoqeMTMjHgs4jilQhkGLvH0x
         +YA09wNIiuW9eCRS9chAzVTlxjJYgA69RXyn6sLU=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aM_gK-Y9XcvU; Mon, 23 Nov 2020 07:58:10 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 1690C12802D9;
        Mon, 23 Nov 2020 07:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1606147090;
        bh=lBjYTVUJkmNX+Ql1BcMOHCS5uLgrfuyir/PBRp4vAgY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=tw2BKkTzWzFWEQdrm6zgBKJtIh2PRfv5Mb0TfkjZKqSr5KeTmWZWgl8VEPx5No8bX
         gdEQ1NYoCzrZ51ueWl3PIAwT19fSirwyiz4cqIKbNqhoqeMTMjHgs4jilQhkGLvH0x
         +YA09wNIiuW9eCRS9chAzVTlxjJYgA69RXyn6sLU=
Message-ID: <fc45750b6d0277c401015b7aa11e16cd15f32ab2.camel@HansenPartnership.com>
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org, amd-gfx@lists.freedesktop.org,
        bridge@lists.linux-foundation.org, ceph-devel@vger.kernel.org,
        cluster-devel@redhat.com, coreteam@netfilter.org,
        devel@driverdev.osuosl.org, dm-devel@redhat.com,
        drbd-dev@lists.linbit.com, dri-devel@lists.freedesktop.org,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
        keyrings@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-acpi@vger.kernel.org, linux-afs@lists.infradead.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
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
        linux-rdma@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
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
Date:   Mon, 23 Nov 2020 07:58:06 -0800
In-Reply-To: <CANiq72m22Jb5_+62NnwX8xds2iUdWDMAqD8PZw9cuxdHd95W0A@mail.gmail.com>
References: <cover.1605896059.git.gustavoars@kernel.org>
         <20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <202011201129.B13FDB3C@keescook>
         <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <202011220816.8B6591A@keescook>
         <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
         <CANiq72nZrHWTA4_Msg6MP9snTyenC6-eGfD27CyfNSu7QoVZbw@mail.gmail.com>
         <1c7d7fde126bc0acf825766de64bf2f9b888f216.camel@HansenPartnership.com>
         <CANiq72m22Jb5_+62NnwX8xds2iUdWDMAqD8PZw9cuxdHd95W0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-23 at 15:19 +0100, Miguel Ojeda wrote:
> On Sun, Nov 22, 2020 at 11:36 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Well, it seems to be three years of someone's time plus the
> > maintainer review time and series disruption of nearly a thousand
> > patches.  Let's be conservative and assume the producer worked
> > about 30% on the series and it takes about 5-10 minutes per patch
> > to review, merge and for others to rework existing series.  So
> > let's say it's cost a person year of a relatively junior engineer
> > producing the patches and say 100h of review and application
> > time.  The latter is likely the big ticket item because it's what
> > we have in least supply in the kernel (even though it's 20x vs the
> > producer time).
> 
> How are you arriving at such numbers? It is a total of ~200 trivial
> lines.

Well, I used git.  It says that as of today in Linus' tree we have 889
patches related to fall throughs and the first series went in in
october 2017 ... ignoring a couple of outliers back to February.

> > It's not about the risk of the changes it's about the cost of
> > implementing them.  Even if you discount the producer time (which
> > someone gets to pay for, and if I were the engineering manager, I'd
> > be unhappy about), the review/merge/rework time is pretty
> > significant in exchange for six minor bug fixes.  Fine, when a new
> > compiler warning comes along it's certainly reasonable to see if we
> > can benefit from it and the fact that the compiler people think
> > it's worthwhile is enough evidence to assume this initially.  But
> > at some point you have to ask whether that assumption is supported
> > by the evidence we've accumulated over the time we've been using
> > it.  And if the evidence doesn't support it perhaps it is time to
> > stop the experiment.
> 
> Maintainers routinely review 1-line trivial patches, not to mention
> internal API changes, etc.

We're also complaining about the inability to recruit maintainers:

https://www.theregister.com/2020/06/30/hard_to_find_linux_maintainers_says_torvalds/

And burn out:

http://antirez.com/news/129

The whole crux of your argument seems to be maintainers' time isn't
important so we should accept all trivial patches ... I'm pushing back
on that assumption in two places, firstly the valulessness of the time
and secondly that all trivial patches are valuable.

> If some company does not want to pay for that, that's fine, but they
> don't get to be maintainers and claim `Supported`.

What I'm actually trying to articulate is a way of measuring value of
the patch vs cost ... it has nothing really to do with who foots the
actual bill.

One thesis I'm actually starting to formulate is that this continual
devaluing of maintainers is why we have so much difficulty keeping and
recruiting them.

James



