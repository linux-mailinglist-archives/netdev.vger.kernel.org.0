Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EE344CA0A
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 21:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhKJUH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 15:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbhKJUH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 15:07:27 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EE2C061764;
        Wed, 10 Nov 2021 12:04:39 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b15so14951716edd.7;
        Wed, 10 Nov 2021 12:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cEprkKWugIyir4IOICGqOMOwdA9a4f1VHM/48xPomgc=;
        b=EKnMoFbi1i1znGD1K1TC4EnD6lyMHP8+WdWFz0V5zGQah9W/wqE2dAel2/Gc/VlcaT
         7NDkvRa40moEenshF8oBQyouT97g4fZuHdo9vNRI2osAI5TE2ryejnWqKRH93xpR4C9P
         UcOr1wgdwLJhrQ6OlvebhtdzoVe8K1a2Xh+34F/T0CZlG5v1ysYSNIpPb2pYPTAF/rE7
         ZIMQ/aJwJnF/OYUa6tn7eFi62v3letZYSF/1gYJ6PeZ1XbciJsKGfT6pT+TFOLZS2svB
         gIKMvOXDRYzahIxptOc+4ES47W/twRt56LtaB5fsoLHDakSvMxJogBaV10292xDNpqkk
         kEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cEprkKWugIyir4IOICGqOMOwdA9a4f1VHM/48xPomgc=;
        b=FhOwRBGkcQX8RfM3sMvWYX45hWnJEVVpSn+uC7ljrwr239eIt5dcIm/9FfTzU6sOFJ
         rxFsmFI8BDO7Z7N+QL4bRQMMgyKx8M1Pbh2GcHNCK0smKMEgUh9ayCVoR4MFKEd8+e1n
         umxaIr65vWZmIFKZ12LPW0JVj34+cCGWEtYxR7R3x3GARDuteHrjpX6rawyNji3rbVq/
         RzX0Z67OiV8GQ2yiqqi/rKn6ICjb+LQFwjbTn4/snCTVtD5raHVtyHCB1WubUf7IMptd
         u/NdiRR2zDPjdeJ3TTf4dT28M4ySawHnKLURzk0bp2bDovVH9euoJD+ldwRhr6U7+35z
         lnBQ==
X-Gm-Message-State: AOAM5306JYq6zWpfo3sQQSE6oP/ML8nGGGiKgeX+9HW1Dt3OC+j+vSZy
        WSQsorLzySFTD49nZY1nxZo=
X-Google-Smtp-Source: ABdhPJwDL9HUK6sva11ruWXjITB3NLPQGUdvKguPe5k9Tye3HPZxgraLisj3BDzXc/1YwgYcy7xflA==
X-Received: by 2002:a05:6402:2554:: with SMTP id l20mr2096866edb.33.1636574676922;
        Wed, 10 Nov 2021 12:04:36 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id e20sm389977edv.64.2021.11.10.12.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 12:04:36 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:04:34 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 6/8] leds: trigger: add hardware-phy-activity
 trigger
Message-ID: <YYwl0ursbAtsBdxX@Ansuel-xps.localdomain>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-7-ansuelsmth@gmail.com>
 <20211109042517.03baa809@thinkpad>
 <YYrjlHz/UgTUwQAm@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYrjlHz/UgTUwQAm@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 10:09:40PM +0100, Andrew Lunn wrote:
> > > +/* Expose sysfs for every blink to be configurable from userspace */
> > > +DEFINE_OFFLOAD_TRIGGER(blink_tx, BLINK_TX);
> > > +DEFINE_OFFLOAD_TRIGGER(blink_rx, BLINK_RX);
> > > +DEFINE_OFFLOAD_TRIGGER(keep_link_10m, KEEP_LINK_10M);
> > > +DEFINE_OFFLOAD_TRIGGER(keep_link_100m, KEEP_LINK_100M);
> > > +DEFINE_OFFLOAD_TRIGGER(keep_link_1000m, KEEP_LINK_1000M);
> 
> You might get warnings about CamelCase, but i suggest keep_link_10M,
> keep_link_100M and keep_link_1000M. These are megabits, not millibits.
> 
> > > +DEFINE_OFFLOAD_TRIGGER(keep_half_duplex, KEEP_HALF_DUPLEX);
> > > +DEFINE_OFFLOAD_TRIGGER(keep_full_duplex, KEEP_FULL_DUPLEX);
> 
> What does keep mean in this context?
>

LED is turned on but doesn't blink. Hint for a better name?

> > > +DEFINE_OFFLOAD_TRIGGER(option_linkup_over, OPTION_LINKUP_OVER);
> > > +DEFINE_OFFLOAD_TRIGGER(option_power_on_reset, OPTION_POWER_ON_RESET);
> > > +DEFINE_OFFLOAD_TRIGGER(option_blink_2hz, OPTION_BLINK_2HZ);
> > > +DEFINE_OFFLOAD_TRIGGER(option_blink_4hz, OPTION_BLINK_4HZ);
> > > +DEFINE_OFFLOAD_TRIGGER(option_blink_8hz, OPTION_BLINK_8HZ);
> > 
> > This is very strange. Is option_blink_2hz a trigger on itself? Or just
> > an option for another trigger? It seems that it is an option, so that I
> > can set something like
> >   blink_tx,option_blink_2hz
> > and the LED will blink on tx activity with frequency 2 Hz... If that is
> > so, I think you are misnaming your macros or something, since you are
> > defining option_blink_2hz as a trigger with
> >  DEFINE_OFFLOAD_TRIGGER
> 
> Yes, i already said this needs handling differently. The 2Hz, 4Hz and
> 8Hz naturally fit the delay_on, delay_of sysfs attributes.
> 
>     Andrew

You are totally right. I tought the blink control was something specific
that only some PHY had, but considering we have more than 1 that
supports a variant of it, I can see how it should be handled separately.
I assume even more have this kind of customizzation.

-- 
	Ansuel
