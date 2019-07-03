Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5AE5EDC4
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfGCUnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:43:05 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35467 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfGCUnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:43:05 -0400
Received: by mail-pl1-f195.google.com with SMTP id w24so1852723plp.2
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 13:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x4TV9OuGMH2IFAWRzYFxjVpyDgSmZpX4HKATzy9i5LE=;
        b=NqpSXt2ai4FWgYUhx9YUIQd8vWtb3B9ByuyfiMWY/XFkaiWfCj1FBGxkAwtk1xNHNN
         vgKEuCm1NC9cInuq+hL1kwDFHAL7pRfhG61zNFwnu36Z3oVL48mwQVXET+K0XU4M/2U4
         MxeCSPy7BE3iLKqtqYOwH2ulvCTGQgY8QrwSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x4TV9OuGMH2IFAWRzYFxjVpyDgSmZpX4HKATzy9i5LE=;
        b=Kkf0k6bPYO8NiXk83o+8AsnLx02ZK0jhZXg3JUauJXsP8LASvyPFGLDaqOkIx0vxq5
         dlf1kZ+UOFXI2zmTJGXbCCoj2a5LmruWbd7iJh/TsALyO/uM1fJbAi8NYdQ+90ym7Fyn
         pC5eqWfvPv1lLRgQtb7NmSa33zxBzHCpI8OvPRwTPD6EtENwGfIuMiQufMhHqk5ZIl6+
         Zh1bsnlUpzPjFy4Fqg7evN2V4ZksOYUHvNeHMGjDXDVm4zkJ1Dh6bSTJrixy2b2uyJG2
         tVTjqiBIgMLodJ6TX14Sb3ejNRt5bPZ7HUISyEk5XiKwcUVS2tVggvGAQOJiEhq/7hU3
         zX8g==
X-Gm-Message-State: APjAAAWxKTgYMARE8BaYLkU1T3BgE+dmHnxB5i5U8gijv6DhosE8AMn9
        jinfiRpzO/Z++kpBAMmQdP8KPw==
X-Google-Smtp-Source: APXvYqykgvMApITkPMMhHzregOurly8+6C4wq2UcUc1VFL1/AiRc7obmDF5E4wOp3JP2p5uh8rmkmw==
X-Received: by 2002:a17:902:9a06:: with SMTP id v6mr43660872plp.71.1562186584828;
        Wed, 03 Jul 2019 13:43:04 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id u7sm3086441pgr.94.2019.07.03.13.43.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 13:43:04 -0700 (PDT)
Date:   Wed, 3 Jul 2019 13:43:02 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 7/7] net: phy: realtek: configure RTL8211E LEDs
Message-ID: <20190703204302.GG250418@google.com>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-7-mka@chromium.org>
 <20190703201032.GG18473@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190703201032.GG18473@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 10:10:32PM +0200, Andrew Lunn wrote:
> > +	for (i = 0; i < count; i++) {
> > +		u32 val;
> > +
> > +		of_property_read_u32_index(dev->of_node,
> > +					   "realtek,led-modes", i, &val);
> 
> Please validate the value, 0 - 7.

ok, will be 0-7 and 0x10000 - 0x10007 (w/ RTL8211E_LINK_ACTIVITY) though.

This is the somewhat quirky part about the property, each value
translates to two registers. This seemed to be the cleanest solution
from the bindings perspective, but I'm open to other suggestions.
