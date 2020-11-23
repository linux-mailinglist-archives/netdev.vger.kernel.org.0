Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95CC2C16F2
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgKWUiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:38:08 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:54984 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728669AbgKWUiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:38:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7C3BA128091F;
        Mon, 23 Nov 2020 12:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1606163883;
        bh=+EDGs3PYzl3z47JpXWUueALZlElPDdJywkYLk/HcIjg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Tyy0xQy0htMQEdpfMUvFUuPG04g7ZXvYvYsCjWoq+QOlUp2WQfo8Vk+CnXXw5nkQT
         a3Wz7+ONj/4K4WJ6m4qOiNdEl9e5tbHlW07s/zxEoMhv+eMdbQKfvYZ25zqNb6Olj/
         onXIz2W3FBWOnXIoTYXwnsUNPzdRLL+aS2e3QsY4=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MaRt-fv30puO; Mon, 23 Nov 2020 12:38:03 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id EBC5C128091E;
        Mon, 23 Nov 2020 12:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1606163883;
        bh=+EDGs3PYzl3z47JpXWUueALZlElPDdJywkYLk/HcIjg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Tyy0xQy0htMQEdpfMUvFUuPG04g7ZXvYvYsCjWoq+QOlUp2WQfo8Vk+CnXXw5nkQT
         a3Wz7+ONj/4K4WJ6m4qOiNdEl9e5tbHlW07s/zxEoMhv+eMdbQKfvYZ25zqNb6Olj/
         onXIz2W3FBWOnXIoTYXwnsUNPzdRLL+aS2e3QsY4=
Message-ID: <4993259d01a0064f8bb22770503490f9252f3659.camel@HansenPartnership.com>
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
Date:   Mon, 23 Nov 2020 12:37:58 -0800
In-Reply-To: <CANiq72k5tpDoDPmJ0ZWc1DGqm+81Gi-uEENAtvEs9v3SZcx6_Q@mail.gmail.com>
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
         <CANiq72k5tpDoDPmJ0ZWc1DGqm+81Gi-uEENAtvEs9v3SZcx6_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-23 at 19:56 +0100, Miguel Ojeda wrote:
> On Mon, Nov 23, 2020 at 4:58 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Well, I used git.  It says that as of today in Linus' tree we have
> > 889 patches related to fall throughs and the first series went in
> > in october 2017 ... ignoring a couple of outliers back to February.
> 
> I can see ~10k insertions over ~1k commits and 15 years that mention
> a fallthrough in the entire repo. That is including some commits
> (like the biggest one, 960 insertions) that have nothing to do with C
> fallthrough. A single kernel release has an order of magnitude more
> changes than this...
> 
> But if we do the math, for an author, at even 1 minute per line
> change and assuming nothing can be automated at all, it would take 1
> month of work. For maintainers, a couple of trivial lines is noise
> compared to many other patches.

So you think a one line patch should take one minute to produce ... I
really don't think that's grounded in reality.  I suppose a one line
patch only takes a minute to merge with b4 if no-one reviews or tests
it, but that's not really desirable.

> In fact, this discussion probably took more time than the time it
> would take to review the 200 lines. :-)

I'm framing the discussion in terms of the whole series of changes we
have done for fall through, both what's in the tree currently (889
patches) both in terms of the produce and the consumer.  That's what I
used for my figures for cost.

> > We're also complaining about the inability to recruit maintainers:
> > 
> > https://www.theregister.com/2020/06/30/hard_to_find_linux_maintainers_says_torvalds/
> > 
> > And burn out:
> > 
> > http://antirez.com/news/129
> 
> Accepting trivial and useful 1-line patches

Part of what I'm trying to measure is the "and useful" bit because
that's not a given.

> is not what makes a voluntary maintainer quit...

so the proverb "straw which broke the camel's back" uniquely doesn't
apply to maintainers

>  Thankless work with demanding deadlines is.

That's another potential reason, but it doesn't may other reasons less
valid.

> > The whole crux of your argument seems to be maintainers' time isn't
> > important so we should accept all trivial patches
> 
> I have not said that, at all. In fact, I am a voluntary one and I
> welcome patches like this. It takes very little effort on my side to
> review and it helps the kernel overall.

Well, you know, subsystems are very different in terms of the amount of
patches a maintainer has to process per release cycle of the kernel. 
If a maintainer is close to capacity, additional patches, however
trivial, become a problem.  If a maintainer has spare cycles, trivial
patches may look easy.

> Paid maintainers are the ones that can take care of big
> features/reviews.
> 
> > What I'm actually trying to articulate is a way of measuring value
> > of the patch vs cost ... it has nothing really to do with who foots
> > the actual bill.
> 
> I understand your point, but you were the one putting it in terms of
> a junior FTE.

No, I evaluated the producer side in terms of an FTE.  What we're
mostly arguing about here is the consumer side: the maintainers and
people who have to rework their patch sets. I estimated that at 100h.

>  In my view, 1 month-work (worst case) is very much worth
> removing a class of errors from a critical codebase.
> 
> > One thesis I'm actually starting to formulate is that this
> > continual devaluing of maintainers is why we have so much
> > difficulty keeping and recruiting them.
> 
> That may very well be true, but I don't feel anybody has devalued
> maintainers in this discussion.

You seem to be saying that because you find it easy to merge trivial
patches, everyone should.  I'm reminded of a friend long ago who
thought being a Tees River Pilot was a sinecure because he could
navigate the Tees blindfold.  What he forgot, of course, is that just
because it's easy with a trawler doesn't mean it's easy with an oil
tanker.  In fact it takes longer to qualify as a Tees River Pilot than
it does to get a PhD.

James


