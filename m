Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D6B456773
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhKSBba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhKSBba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:31:30 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F366AC061574;
        Thu, 18 Nov 2021 17:28:28 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so35415424eda.12;
        Thu, 18 Nov 2021 17:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZbzwtryDR+hGktgbaR8c9lz4tfdgQb7C7Aw3g98hkK4=;
        b=ZsN2vXq/Z8iJV/mOGo+y8eVRk7+Zh1UWaS05SjnfusBk9ftPskRHOKL5bkcKz+/nC/
         kQQg9QBeyYh5PcMPbiaCE1gJtw8yM3cZ7fF6IRWvd550bqO/1XaCtifqQLqZgk2o+NNA
         /R+T57xPN7nftSHd6Zk8XADldsn4SZagjNaJzIZM35NGK4ch5aTWEHfuQp1UdJ4FzKuW
         1NKBp//40DJcdvLOh0UmBh57QoaRRVy/IvhQHAtsyFtIB+wsDtv00ioms3C5+tib47Wc
         rJVGuktMB4OE0lbrtH+uO4YaW6SS4iFKJd9QYP04uXX+vsy25lLrABcT98Tg2AYbR1Nt
         10RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZbzwtryDR+hGktgbaR8c9lz4tfdgQb7C7Aw3g98hkK4=;
        b=SQUzZfoaVoDYN7exOjeVSNfI0bxWFybFOxaIfZx4kqM0N2lFrpNZ10+7kg4tF+VRU7
         9Pdaf9hUezZH5FDwtXcNvYegrabaPPcQddtcM4G4oQHviSCkyOVN1na5NDofk9gjVhdS
         Hhvcm9sDX5hg6OlpcHF32FTSCi9XBT8NiAX5Tdu2h6h+DTDFLKaECeFP7HEU1mJUnaQN
         5keGmxXLKF2aeE/JnpjOHJ4BdmwXcHf5SI3j8sWohuI3ywHR6JA7fg8MAz6KJ4awncsD
         Gw5CrKRwpm0g3XIEa5585uZGS9A/PiJQOWh3rvT25wYUVRWmuGoKzM1DTQNBSvDF43eW
         Z6YQ==
X-Gm-Message-State: AOAM5329AZvAOHY7Liqkdc9cB2MQcgeiVNH6UzLavyHAfZMakBmMUKQb
        0Nfw3Blkw/lX7i995/YSRQ4=
X-Google-Smtp-Source: ABdhPJzRLLcizZqcZP5C/Jh33sf83+jNQPAr32COMixoQotVymY69F3o7gZuPuNJoaGCSHIV/Ki2fw==
X-Received: by 2002:a17:907:2a8c:: with SMTP id fl12mr2478566ejc.569.1637285307393;
        Thu, 18 Nov 2021 17:28:27 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id sa3sm544519ejc.113.2021.11.18.17.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:28:27 -0800 (PST)
Message-ID: <6196fdbb.1c69fb81.e8741.2b6c@mx.google.com>
X-Google-Original-Message-ID: <YZb9t5+uJSqKgtd4@Ansuel-xps.>
Date:   Fri, 19 Nov 2021 02:28:23 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 08/19] net: dsa: qca8k: convert qca8k to regmap
 helper
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-9-ansuelsmth@gmail.com>
 <20211119011410.nvrfm72ccvp4psi6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119011410.nvrfm72ccvp4psi6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 03:14:10AM +0200, Vladimir Oltean wrote:
> On Wed, Nov 17, 2021 at 10:04:40PM +0100, Ansuel Smith wrote:
> > Convert any qca8k read/write/rmw/set/clear/pool to regmap helper and add
> > missing config to regmap_config struct.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> The important question is "why" and this commit message seems to omit that.
> Using regmap will be slower than using the equivalent direct I/O.

Yes sorry, will improve the message.
The transition to regmap is needed to permit the use of common code by
different switch that have different read/write/rmw function.
It seems cleaner to use regmap instead of using some helper or putting
the read/write/rmw in the priv struct.
Also in theory the overhead created by using regmap should be marginal
as the internal mdio use dedicated function and bypass regmap. So the
overhead should be present only in the configuration operation or fdb
access.

-- 
	Ansuel
