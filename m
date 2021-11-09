Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC1A44B412
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 21:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244469AbhKIUhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 15:37:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53314 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239648AbhKIUhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 15:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NZmg3j0EAUz6SRjH0lLT+qY9ZFf2Fx+/cHi7xXQ221k=; b=minbOTZiNi6GoEgekr24PBPWFW
        wJdqcet8470M6FxSH98y41OHosHueu8nRrp7A33FuPRnuK9jz/RbQNJFODaSQwxBcTWCfOnfBOjbl
        wMn1MwCJ+vFP7DxKXM9aCplqrnyoMrzxgqKb+MRLoKdCjkz8fjGaZnS58tPhqRSs+KZw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkXp1-00D1Mt-Pd; Tue, 09 Nov 2021 21:34:23 +0100
Date:   Tue, 9 Nov 2021 21:34:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v3 1/8] leds: add support for hardware driven LEDs
Message-ID: <YYrbT6pMGXqA2EVn@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109022608.11109-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 03:26:01AM +0100, Ansuel Smith wrote:
> Some LEDs can be driven by hardware (for example a LED connected to
> an ethernet PHY or an ethernet switch can be configured to blink on
> activity on the network, which in software is done by the netdev trigger).
> 
> To do such offloading, LED driver must support this and a supported
> trigger must be used.
> 
> LED driver should declare the correct blink_mode supported and should set
> the blink_mode parameter to one of HARDWARE_CONTROLLED or
> SOFTWARE_HARDWARE_CONTROLLED.
> The trigger will check this option and fail to activate if the blink_mode
> is not supported. By default if a LED driver doesn't declare blink_mode,
> SOFTWARE_CONTROLLED is assumed.
> 
> The LED must implement 3 main API:
> - trigger_offload_status(): This asks the LED driver if offload mode is
>     enabled or not.
>     Triggers will check if the offload mode is supported and will be
>     activated accordingly. If the trigger can't run in software mode,
>     return -EOPNOTSUPP as the blinking can't be simulated by software.

I don't understand this last part. The LED controller is not
implementing software mode, other than providing a method to manually
turn the LED on and off. And there is a well defined call for that. If
that call is a NULL, it is clear it is not implemented. There is no
need to ask the driver.

     Andrew
