Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004AA68BFAE
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjBFOMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjBFOMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:12:32 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEF810411;
        Mon,  6 Feb 2023 06:11:35 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id fi26so11767855edb.7;
        Mon, 06 Feb 2023 06:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjNCZihD+JyD+X/NqX2K/WinbFURiWlVJdPI5oFlnRU=;
        b=QQ2WJQq/56bvYDCjn/ZQVSCLF5CXnhAeDIv8hnHuLczMo1QRcvFrRQXT/TC0cxr3zp
         k0iIpIo3Ia0CkBfayjEyxcJpjkzpmbafGFV77ldIH94AqOtchcdy1ipBzBTIYTkJUfcq
         bGSpr/hDAHlgmBHMgmqPs5rCuMb1IRlQWLjRtgTOOd6qMSAdHgcqxCuRxx585IVRbYZU
         jHELaRm5AeuD924dDzoffPxIzGV7doJcZe8Re4OnExtTmoKiYaxesUb0PDrv/aMrhLsk
         MX68caGC9fD72wPYo3cJk4vkoZ0ESHaySCtVX8rrXEwr0Vh6BkH37Tw/swo3/hkJSAxi
         JqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjNCZihD+JyD+X/NqX2K/WinbFURiWlVJdPI5oFlnRU=;
        b=YPkAGBCsaNY6aJq07Su3/NnRG8Yk0T7vLbZzqzXgYFZehzwXROFub0bcat/NORMz7C
         oQIuEHUXuYO+qgXYZFkiAfZmZqF9GoPjX3n39BarVypudoQegWw5tV78i6o4q118kBes
         Juy865ieHqtSYYHkpAf69yiwyXw38+464uqpJ0O9J+hUnESOLc46BYew+f845h8xICSh
         U7BvCrXpxo0/oUN8apX51jG7h2rKdR5jrGUzlpVfZE6dx6knzdnC1HNkCIbQHLHySkGm
         QYppNjN835or/dM8SWqkPfsE4FqKU6uH7D9LGrl7LBd8Lut0lNe/x/qqBpe+amEjp3VR
         ZySQ==
X-Gm-Message-State: AO0yUKVrRn4GPVcO2LDWqJGhzigEVk+mk1OzNFjKnArazlOhiBD4k3sz
        rN5aqDylraMh0+Slg57lDWE=
X-Google-Smtp-Source: AK7set8hg1nL1fqQAN1ybZnXS9qFzQW0YjWs7NHJRoLnM5b8Z5L6iTX8HkkYeaqd45qCQI7MJwNwwQ==
X-Received: by 2002:a50:bb27:0:b0:4aa:a172:6616 with SMTP id y36-20020a50bb27000000b004aaa1726616mr8970529ede.24.1675692641057;
        Mon, 06 Feb 2023 06:10:41 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id en14-20020a056402528e00b0049622a61f8fsm5137456edb.30.2023.02.06.06.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 06:10:40 -0800 (PST)
Date:   Mon, 6 Feb 2023 16:10:38 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 00/23] net: add EEE support for KSZ9477 and
 AR8035 with i.MX6
Message-ID: <20230206141038.vp5pdkjyco6pyosl@skbuf>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230204001332.dd4oq4nxqzmuhmb2@skbuf>
 <20230206054713.GD12366@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206054713.GD12366@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:47:13AM +0100, Oleksij Rempel wrote:
> On Sat, Feb 04, 2023 at 02:13:32AM +0200, Vladimir Oltean wrote:
> > On Wed, Feb 01, 2023 at 03:58:22PM +0100, Oleksij Rempel wrote:
> > > With this patch series we provide EEE control for KSZ9477 family of switches and
> > > AR8035 with i.MX6 configuration.
> > > According to my tests, on a system with KSZ8563 switch and 100Mbit idle link,
> > > we consume 0,192W less power per port if EEE is enabled.
> > 
> > What is the code flow through the kernel with EEE? I wasn't able to find
> > a good explanation about it.
> > 
> > Is it advertised by default, if supported? I guess phy_advertise_supported()
> > does that.
> 
> Ack.
> 
> > But is that desirable? Doesn't EEE cause undesired latency for MAC-level
> > PTP timestamping on an otherwise idle link?
> 
> Theoretically, MAC controls Low Power Idle states and even with some
> "Wake" latency should be fully aware of actual ingress and egress time
> stamps.

I'm not sure if this is also true with Atheros SmartEEE, where the PHY
is the one who enters LPI mode and buffers packets until it wakes up?

> 
> Practically, right now I do not have such HW to confirm it. My project
> is affected by EEE in different ways:

Doesn't FEC support PTP?

> - with EEE PTP has too much jitter
> - without EEE, the devices consumes too much power in standby mode with
>   WoL enabled. Even switching to 10BaseT less power as 100BaseTX with
>   EEE would do.
> 
> My view is probably biased by my environment - PTP is relatively rare
> use case. EEE saves power (0,2W+0,2W per link in my case). Summary power
> saving of all devices is potentially equal to X amount of power plants. 
> So, EEE should be enabled by default.

I'm not contesting the value of EEE. Just wondering whether it's best
for the kernel, rather than user space, to enable it by default.

> 
> Beside, flow control (enabled by default) affects PTP in some cases too.

You are probably talking about the fact that flow control may affect
end-to-end delay measurements (across switches in a LAN). Yes, but EEE
(or at least SmartEEE) may affect peer-to-peer delay measurements, which
I see as worse.

> 
> May be ptp4l should warn about this options? We should be able to detect
> it from user space.

This isn't necessarily a bad idea, even though it would end up
renegotiating and losing the link.

Maybe it would be good to drag Richard Cochran into the discussion too.
After all he's the one who should agree what should and what shouldn't
ptp4l be concerned with.

> 
> Regards,
> Oleksij
> -- 
> Pengutronix e.K.                           |                             |
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
