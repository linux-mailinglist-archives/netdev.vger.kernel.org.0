Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5CF4B2D6B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243487AbiBKTSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:18:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240055AbiBKTSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:18:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C250CD8;
        Fri, 11 Feb 2022 11:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tyRsIYgDptHBZbcunPbQiuuAcO0oa86ux35WhIg4QdA=; b=UkJN2NlFx/1TF6rXDBwt6dk5UA
        zmV/f4DdqQovSjEp9P/0wK4woCeO78UknY2JmEFjN6S6E2UlUSKJp9BzW/PlfZ1PMmo9zs26o/FCw
        H6z4nzktfBXEZUr2moDo7BJuZLPecHNFSghgseHAfz4a2b2CKqxWukRKdgcOE1qS69zQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIbQX-005VmV-CB; Fri, 11 Feb 2022 20:17:53 +0100
Date:   Fri, 11 Feb 2022 20:17:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led
 functions
Message-ID: <Yga2YbglzJ6CvMFo@lunn.ch>
References: <YfspazpWoKuHEwPU@lunn.ch>
 <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
 <YfwEvgerYddIUp1V@lunn.ch>
 <CAJ+vNU1qY1VJgw1QRsbmED6-TLQP2wwxSYb+bXfqZ3wiObLgHg@mail.gmail.com>
 <YfxtglvVDx2JJM9w@lunn.ch>
 <CAJ+vNU1td9aizbws-uZ-p-fEzsD8rJVS-mZn4TT2YFn9PY2n_w@mail.gmail.com>
 <Yf2usAHGZSUDvLln@lunn.ch>
 <CAJ+vNU3EY0qp-6oQ6Bjd4mZCKv9AeqiaJp=FSrN84P=8atKLrw@mail.gmail.com>
 <YgRWl5ykcjPW0xvx@lunn.ch>
 <CAJ+vNU1kmxgFjX2HeTok-6FcnCAApvzszhh2dbNnDgFD7ZsAiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU1kmxgFjX2HeTok-6FcnCAApvzszhh2dbNnDgFD7ZsAiQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 07:52:49AM -0800, Tim Harvey wrote:
> On Wed, Feb 9, 2022 at 4:04 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > The errata can be summarized as:
> > > - 1 out of 100 boots or cable plug events RGMII GbE link will end up
> > > going down and up 3 to 4 times then resort to a 100m link; workaround
> > > has been found to require a pin level reset
> >
> > So that sounds like it is downshifting because it thinks there is a
> > broken pair. Can you disable downshift? Problem is, that might just
> > result in link down.
> 
> Its a bad situation. The actual errata is that the device latches into
> a bad state where there is some noise on an ADC or something like that
> that cause a high packet error rate. The firmware baked into the PHY
> has a detection mechanism looking at these errors (SSD errors) and if
> there are enough of them it takes the link down and up again and if
> that doesn't resolve in 3 times it shifts down to 100mbs. They call
> this 'ADS' or 'auto-down-speed' and you can disable it but it would
> just result in leaving your bad gbe link up. It's unclear yet if it's
> better to just detect the ADS event and reset or to disable ADS and
> look for the SSD errors myself (which I can do).

I don't think it matters too much which way you detect there is a
problem. But ideally you need a recovery which does not need a
hardware reset. Than you don't need to worry about the other PHY
sharing the reset line. But you know that...

> I agree that I can't do anything in boot firmware. I was planning on
> having some static code that registered a PHY fixup to get a call when
> these PHYs were detected and I could then kick off a polling thread to
> watch for errors and trigger a reset. The reset could have knowledge
> of the PHY devices that called the fixup handler so that I can at
> least setup each PHY again.

That sounds like a reasonable architecture. Your thread would need to
do:

phy_stop()
phy_init_hw()
phy_start()

and phylib probably will do the reset.

Maybe you can put the problem detection code in the .read_status
callback, which sets am 'im_fubar' flag in the drivers private
structure. That gives some building blocks for other users of this PHY
who don't have a shared reset line, and can maybe solve the problem
within the driver.

       Andrew
