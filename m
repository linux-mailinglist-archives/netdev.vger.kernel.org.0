Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBEF6B0A93
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjCHOIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjCHOIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:08:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3065ADF5;
        Wed,  8 Mar 2023 06:06:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AD2AB81BEB;
        Wed,  8 Mar 2023 14:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EF7C433D2;
        Wed,  8 Mar 2023 14:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678284411;
        bh=c4godVAn6HjOWriTqbDfMbdcTlhXhbEHeIYFkgIhqE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c3zW/ilEvzKm8sQ1YvCRc6PMjZ7hUSBRDaM+R6u5gVm2j/XlCYYzKs+Yj9sgoWfaK
         xF4oQ4mfPeQ1DazAWbdh1Wd9v7QLs6GCRa8c1hzqxDR/ERqNNWwNusJ2Bwuk+y12zu
         OssN1SK/Ow+Zvo9pn+pEDhuwXOr6V2DJlwEi6rC6PzOU34j8T8BTaXnhS+eVRwQRAL
         YmikLUlLzN6gbzRa+rxcSullmPtvdq7B9lzvoFXmkGv3gIq3BJs/b6ZVHeVzoFYfUs
         PRAYGunOslzfulvMunLELAY6zqPgEeg+YXmIwEuIKJnQ8FuXYBpiYWhqT8lyZ5OJg0
         daD58umJZWimw==
Date:   Wed, 8 Mar 2023 14:06:42 +0000
From:   Lee Jones <lee@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v8 00/13] Adds support for PHY LEDs with offload triggers
Message-ID: <20230308140642.GO9667@google.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <Y++PdVq+DlzdotMq@lunn.ch>
 <Y/YubNUBvQ5fBjtG@google.com>
 <6406344a.050a0220.693b3.6689@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6406344a.050a0220.693b3.6689@mx.google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Mar 2023, Christian Marangi wrote:

> On Wed, Feb 22, 2023 at 03:02:04PM +0000, Lee Jones wrote:
> > On Fri, 17 Feb 2023, Andrew Lunn wrote:
> >
> > > On Thu, Feb 16, 2023 at 02:32:17AM +0100, Christian Marangi wrote:
> > > > This is another attempt on adding this feature on LEDs, hoping this is
> > > > the right time and someone finally notice this.
> > >
> > > Hi Christian
> > >
> > > Thanks for keeping working on this.
> > >
> > > I want to review it, and maybe implement LED support in a PHY
> > > driver. But i'm busy with reworking EEE at the moment.
> > >
> > > The merge window is about to open, so patches are not going to be
> > > accepted for the next two weeks. So i will take a look within that
> > > time and give you feedback.
> >
> > Thanks Andrew.  If Pavel is still unavailable to conduct reviews, I'm
> > going to need all the help I can get with complex submissions such as
> > these.
> >
>
> Hi Lee,
> thanks for stepping in. Just wanted to tell you I got some message with
> Andrew to make this thing less problematic and to dry/make it more
> review friendly.
>
> We decided on pushing this in 3 step:
> 1. Propose most basic things for some switch and some PHY. (brightness
> and blink_set support only, already supported by LED core)
> 2. A small series that should be just a cleanup for the netdev trigger
> 3. Support for hw_control in the most possible clean and way with small
> patch to they are not hard to track and understand the concept of this
> feature.
>
> I'm starting with the step 1 and sending some of my patch and Andrew
> patch to add basic support and I will add you and LED mailing list in
> Cc.

Sounds like a plan.  Thank you both.

> Again thanks for starting checking this and feel free to ask any
> question about this to me also privately, I'm very open to any help.

--
Lee Jones [李琼斯]
