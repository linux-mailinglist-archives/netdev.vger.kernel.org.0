Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DDD2C3BBA
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 10:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgKYJJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 04:09:56 -0500
Received: from gofer.mess.org ([88.97.38.141]:33717 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbgKYJJw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 04:09:52 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2020 04:09:46 EST
Received: by gofer.mess.org (Postfix, from userid 1000)
        id C2D44C63FB; Wed, 25 Nov 2020 09:01:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1606294874; bh=KH9dzgywMXfGPGDwmO8Qm6o//zr8KQDL4nO6EawRuDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJYLrwiKZrmMRjkeBYo7cqsbs6xljPuQypU3vE6W0mhxhiBNmXN2bqL5RV07d2awA
         Wb5Oa7L0TiIxfU/vxoLt2vFycI3gN8Kh1qdOF59uK2dEnqITAnDV+wsiQw/exDF78D
         hoTz22IC76edW7bl4Xm8hYrqoRAlLOCNTSbizDTKI7x8BBnutJW03OyPsTxurVqfdC
         T9t8y4uSMzXA9L5TYoAbkkzEdR07qHfBTYdhaiYGGYuE1E1bdzLhtRTU2iYu251NBa
         zqIr2827TZMk9I1fNh/951tgkmCQWewUCt5nrmXnkgqHhLp9nxDE6gWAGCUXG6XCXv
         3mw8Hv064saVQ==
Date:   Wed, 25 Nov 2020 09:01:14 +0000
From:   Sean Young <sean@mess.org>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
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
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
Message-ID: <20201125090114.GA24274@gofer.mess.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011201129.B13FDB3C@keescook>
 <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011220816.8B6591A@keescook>
 <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
 <CANiq72nZrHWTA4_Msg6MP9snTyenC6-eGfD27CyfNSu7QoVZbw@mail.gmail.com>
 <1c7d7fde126bc0acf825766de64bf2f9b888f216.camel@HansenPartnership.com>
 <CANiq72m22Jb5_+62NnwX8xds2iUdWDMAqD8PZw9cuxdHd95W0A@mail.gmail.com>
 <fc45750b6d0277c401015b7aa11e16cd15f32ab2.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc45750b6d0277c401015b7aa11e16cd15f32ab2.camel@HansenPartnership.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 07:58:06AM -0800, James Bottomley wrote:
> On Mon, 2020-11-23 at 15:19 +0100, Miguel Ojeda wrote:
> > On Sun, Nov 22, 2020 at 11:36 PM James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> > > It's not about the risk of the changes it's about the cost of
> > > implementing them.  Even if you discount the producer time (which
> > > someone gets to pay for, and if I were the engineering manager, I'd
> > > be unhappy about), the review/merge/rework time is pretty
> > > significant in exchange for six minor bug fixes.  Fine, when a new
> > > compiler warning comes along it's certainly reasonable to see if we
> > > can benefit from it and the fact that the compiler people think
> > > it's worthwhile is enough evidence to assume this initially.  But
> > > at some point you have to ask whether that assumption is supported
> > > by the evidence we've accumulated over the time we've been using
> > > it.  And if the evidence doesn't support it perhaps it is time to
> > > stop the experiment.
> > 
> > Maintainers routinely review 1-line trivial patches, not to mention
> > internal API changes, etc.
> 
> We're also complaining about the inability to recruit maintainers:
> 
> https://www.theregister.com/2020/06/30/hard_to_find_linux_maintainers_says_torvalds/
> 
> And burn out:
> 
> http://antirez.com/news/129
> 
> The whole crux of your argument seems to be maintainers' time isn't
> important so we should accept all trivial patches ... I'm pushing back
> on that assumption in two places, firstly the valulessness of the time
> and secondly that all trivial patches are valuable.

You're assuming burn out or recruitment problems is due to patch workload
or too many "trivial" patches.

In my experience, "other maintainers" is by far the biggest cause of
burn out for my kernel maintenance work.

Certainly arguing with a maintainer about some obviously-correct patch
series must be a good example of this.


Sean
