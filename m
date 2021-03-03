Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BDC32C450
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392065AbhCDAMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:50 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:59009 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380317AbhCCNaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 08:30:30 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1lHRWR-0004eQ-3X; Wed, 03 Mar 2021 14:26:39 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1lHRWP-0000NT-Lz; Wed, 03 Mar 2021 14:26:37 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id EFA0E240041;
        Wed,  3 Mar 2021 14:26:36 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 4FC9B240040;
        Wed,  3 Mar 2021 14:26:36 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id B706B200E7;
        Wed,  3 Mar 2021 14:26:35 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Mar 2021 14:26:35 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xie He <xie.he.0141@gmail.com>, Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
Organization: TDT AG
In-Reply-To: <20210302153034.5f4e320b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210216201813.60394-1-xie.he.0141@gmail.com>
 <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal>
 <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal>
 <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
 <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
 <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com>
 <906d8114f1965965749f1890680f2547@dev.tdt.de>
 <CAJht_EPBJhhdCBoon=WMuPBk-sxaeYOq3veOpAd2jq5kFqQHBg@mail.gmail.com>
 <e1750da4179aca52960703890e985af3@dev.tdt.de>
 <CAJht_ENP3Y98jgj1peGa3fGpQ-qPaF=1gtyYwMcawRFW_UCpeA@mail.gmail.com>
 <ff200b159ef358494a922a676cbef8a6@dev.tdt.de>
 <CAJht_EMG27YU+Jxtb2qeq1nXwu8uV8FXQPr62OcNHsE7DozD1g@mail.gmail.com>
 <41b77b1c3cf1bb7a51b750faf23900ef@dev.tdt.de>
 <20210302153034.5f4e320b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <8cac820a181070ac2bad983dc49e4e4e@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151534::1614777998-0000B5A4-ED31A05D/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-03 00:30, Jakub Kicinski wrote:
> On Tue, 02 Mar 2021 08:04:20 +0100 Martin Schiller wrote:
>> On 2021-03-01 09:56, Xie He wrote:
>> > On Sun, Feb 28, 2021 at 10:56 PM Martin Schiller <ms@dev.tdt.de> wrote:
>> >> I mean the change from only one hdlc<x> interface to both hdlc<x> and
>> >> hdlc<x>_x25.
>> >>
>> >> I can't estimate how many users are out there and how their setup
>> >> looks
>> >> like.
>> >
>> > I'm also thinking about solving this issue by adding new APIs to the
>> > HDLC subsystem (hdlc_stop_queue / hdlc_wake_queue) for hardware
>> > drivers to call instead of netif_stop_queue / netif_wake_queue. This
>> > way we can preserve backward compatibility.
>> >
>> > However I'm reluctant to change the code of all the hardware drivers
>> > because I'm afraid of introducing bugs, etc. When I look at the code
>> > of "wan/lmc/lmc_main.c", I feel I'm not able to make sure there are no
>> > bugs (related to stop_queue / wake_queue) after my change (and even
>> > before my change, actually). There are even serious style problems:
>> > the majority of its lines are indented by spaces.
>> >
>> > So I don't want to mess with all the hardware drivers. Hardware driver
>> > developers (if they wish to properly support hdlc_x25) should do the
>> > change themselves. This is not a problem for me, because I use my own
>> > out-of-tree hardware driver. However if I add APIs with no user code
>> > in the kernel, other developers may think these APIs are not
>> > necessary.
>> 
>> I don't think a change that affects the entire HDLC subsystem is
>> justified, since the actual problem only affects the hdlc_x25 area.
>> 
>> The approach with the additional hdlc<x>_x25 is clean and purposeful 
>> and
>> I personally could live with it.
>> 
>> I just don't see myself in the position to decide such a change at the
>> moment.
>> 
>> @Jakub: What is your opinion on this.
> 
> Hard question to answer, existing users seem happy and Xie's driver
> isn't upstream, so the justification for potentially breaking backward
> compatibility isn't exactly "strong".
> 
> Can we cop out and add a knob somewhere to control spawning the extra
> netdev? Let people who just want a newer kernel carry on without
> distractions and those who want the extra layer can flip the switch?

Yes, that would be a good compromise.
I think a compile time selection option is enough here.
We could introduce a new config option CONFIG_HDLC_X25_LEGACY (or
something like that) and then implement the new or the old behavior in
the driver accordingly.

A switch that can be toggled at runtime (e.g. via sethdlc) would also be
conceivable, but I don't think this is necessary.

