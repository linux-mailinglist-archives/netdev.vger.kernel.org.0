Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5553A645818
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiLGKlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGKlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:41:00 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668E310B6A;
        Wed,  7 Dec 2022 02:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1670409658; x=1701945658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xk5goH3/wEb7wDqojnwzNi5RZQ/mTp7ePcv/KyIwGtk=;
  b=Lu/8SbVYERU2ypF1xeTQ7401jEkMArfHWLW6mpUFFg0Yo6NjzUxll/mu
   l0S6ud2WlVnEbhpsEQ/ZzgoUcg9WQhDSuKdC1aNIjNyEMsOjp3ph0C6PB
   FIVtIrmOpsLUR0mLfp/tLRm2axrycW2rzjBqzVST81vqtL1zrjy9gnJcl
   96Fswwds7avpzXzA/SJZFkNBk/uXk7l9MZ3IsNeAtdbivKBzsEFyObCUs
   B/+IROuwvG0o2keYDx3C6fmY7ZOjCAhfesK/MVPfLDgTJ06UmIMrZWS0E
   AqsOGX/Pi/wof/3Kvxd/Yxt0gi+wO2rQff3PAWQ1EYQL9NZh5lavnnjNG
   g==;
X-IronPort-AV: E=Sophos;i="5.96,225,1665439200"; 
   d="scan'208";a="27807287"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 07 Dec 2022 11:40:56 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 07 Dec 2022 11:40:56 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 07 Dec 2022 11:40:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1670409656; x=1701945656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xk5goH3/wEb7wDqojnwzNi5RZQ/mTp7ePcv/KyIwGtk=;
  b=Cc25EGHsoxmorVkUmO/qr+rRB+xUGdR4Ip4NgCkQ5fvqyvZ5tudvxNNr
   MPa1ubhkMsa/+HGjaiv/RUuWVtYUBF5zq4QuD8KBIVb2FEmFgPeBcgvWN
   /0d64aa1zuw9lgXuJuxEy5x2u6M7DhlPO3E4SnOmkD46PG8KW182j/+wo
   PBf7KBM0Qi3Xu4ITi7n8hH2HgUupZhh7gKqeE5OT4REPkYAvzJafVpb3A
   6jNqbKnJMSDQn0zO6K1x8+7hX9Huy/ZNiD6z7a+ESlUgCaCUgHsk2pC4X
   SWedk4Ju15x1iZWTC2U5u9lE5qxsTK4hQkerucjfCRPOH6Su1WwNwdjOb
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,225,1665439200"; 
   d="scan'208";a="27807286"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 07 Dec 2022 11:40:55 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 8A2FE280071;
        Wed,  7 Dec 2022 11:40:55 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Tim Harvey <tharvey@gateworks.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
Date:   Wed, 07 Dec 2022 11:40:51 +0100
Message-ID: <4792263.31r3eYUQgx@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <6388f4ab.5d0a0220.a137.068e@mx.google.com>
References: <20221118001548.635752-1-tharvey@gateworks.com> <CAJ+vNU2AbaDAMhQ0-mDh6ROC7rdkbmXoiSijRTN2ryEgT=QHiQ@mail.gmail.com> <6388f4ab.5d0a0220.a137.068e@mx.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ansuel,

Am Donnerstag, 1. Dezember 2022, 19:38:36 CET schrieb Christian Marangi:
> On Thu, Dec 01, 2022 at 10:35:46AM -0800, Tim Harvey wrote:
> > On Thu, Dec 1, 2022 at 10:31 AM Christian Marangi <ansuelsmth@gmail.com> 
wrote:
> > > On Thu, Dec 01, 2022 at 10:26:09AM -0800, Tim Harvey wrote:
> > > > On Sun, Nov 20, 2022 at 3:35 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > > > On Fri, Nov 18, 2022 at 11:57:00AM -0800, Tim Harvey wrote:
> > > > > > On Fri, Nov 18, 2022 at 5:11 AM Andrew Lunn <andrew@lunn.ch> 
wrote:
> > > > > > > > Andrew,
> > > > > > > > 
> > > > > > > > I completely agree with you but I haven't seen how that can be
> > > > > > > > done
> > > > > > > > yet. What support exists for a PHY driver to expose their LED
> > > > > > > > configuration to be used that way? Can you point me to an
> > > > > > > > example?
> > > > > > > 
> > > > > > > Nobody has actually worked on this long enough to get code
> > > > > > > merged. e.g.
> > > > > > > https://lore.kernel.org/netdev/20201004095852.GB1104@bug/T/
> > > > > > > https://lists.archive.carbon60.com/linux/kernel/3396223
> > > > > > > 
> > > > > > > This is probably the last attempt, which was not too far away
> > > > > > > from getting merged:
> > > > > > > https://patches.linaro.org/project/linux-leds/cover/20220503151
> > > > > > > 633.18760-1-ansuelsmth@gmail.com/
> > > > > > > 
> > > > > > > I seem to NACK a patch like yours every couple of months. If all
> > > > > > > that
> > > > > > > wasted time was actually spent on a common framework, this would
> > > > > > > of
> > > > > > > been solved years ago.
> > > > > > > 
> > > > > > > How important is it to you to control these LEDs? Enough to
> > > > > > > finish
> > > > > > > this code and get it merged?
> > > > > > 
> > > > > > Andrew,
> > > > > > 
> > > > > > Thanks for the links - the most recent attempt does look
> > > > > > promising.
> > > > > > For whatever reason I don't have that series in my mail history so
> > > > > > it's not clear how I can respond to it.
> > > > > 
> > > > > apt-get install b4
> > > > > 
> > > > > > Ansuel, are you planning on posting a v7 of 'Adds support for PHY
> > > > > > LEDs
> > > > > > with offload triggers' [1]?
> > > > > > 
> > > > > > I'm not all that familiar with netdev led triggers. Is there a way
> > > > > > to
> > > > > > configure the default offload blink mode via dt with your series?
> > > > > > I
> > > > > > didn't quite follow how the offload function/blink-mode gets set.
> > > > > 
> > > > > The idea is that the PHY LEDs are just LEDs in the Linux LED
> > > > > framework. So read
> > > > > Documentation/devicetree/bindings/leds/common.yaml.
> > > > > The PHY should make use of these standard DT properties, including
> > > > > linux,default-trigger.
> > > > > 
> > > > >         Andrew
> > > > 
> > > > Ansuel,
> > > > 
> > > > Are you planning on posting a v7 of 'Adds support for PHY LEDs with
> > > > offload triggers' [1]?
> > > > 
> > > > Best Regards,
> > > > 
> > > > Tim
> > > > [1] https://patches.linaro.org/project/linux-leds/list/?series=174704
> > > 
> > > I can consider that only if there is a real interest for it and would
> > > love some help by the netdev team to actually have a review from the
> > > leds team...
> > > 
> > > I tried multiple time to propose it but I never got a review... only a
> > > review from an external guy that wanted to follow his idea in every way
> > > possible with the only intention of applying his code (sorry to be rude
> > > about that but i'm more than happy to recover the work and search for a
> > > common solution)
> > > 
> > > So yes this is still in my TODO list but it would help if others can
> > > tell me that they want to actually review it. That would put that
> > > project on priority and I would recover and push a v7.
> > > 
> > > --
> > > 
> > >         Ansuel
> > 
> > Ansuel,
> > 
> > Considering Andrew is nak'ing any phy code to configure LED's until a
> > solution using via /sys/class/leds is provided I would say there is
> > real interest.
> > 
> > It seems to me that you got very positive feedback for this last
> > series. I would think if you submitted without RFC it would catch more
> > eyes as well.
> 
> Well yes that's the fun part. netdev really liked the concept and how it
> was implemented (and actually also liked the use of a dedicated trigger
> instead of bloating the netdev trigger)
> 
> But I never got a review from LED team and that result in having the
> patch stalled and never merged... But ok I will recover the work and
> recheck/retest everything from the start hoping to get more traction
> now...

I was just trying to use your RFC patchset from May 2022 for dp83867 as well, 
with some success at least.
I have some comments, fixes and uncertainties. How do you want to progress? 
Resend so I can rebase on that? Anyway, put me on CC.

Best regards,
Alexander



