Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4D051B543
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 03:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiEEBdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 21:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiEEBdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 21:33:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930594BBB4;
        Wed,  4 May 2022 18:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Cj4UGQhE5SbBl27xX4oKe/1UFslY5BYuOULnOrIDVz0=; b=nwH0yzV32VnmqT9/Mt4VEzDmja
        0HscqFeiPjCwOip27unrxVYfqQP7fenifZazDDwQzeQcSTf232OVyp0aeR9gPTbqWvjW2SuyCTSxS
        Qb25QSydS0u/xB4YJanEQPhHHHo90umugQKByRLtouW6A1SbyhmGEaaW7Dt6wj8SDMEw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmQJ4-001Hs8-4L; Thu, 05 May 2022 03:29:26 +0200
Date:   Thu, 5 May 2022 03:29:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 09/11] leds: trigger: netdev: add additional
 hardware only triggers
Message-ID: <YnModmKCG3BD5nvd@lunn.ch>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503151633.18760-10-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 05:16:31PM +0200, Ansuel Smith wrote:
> Add additional hardware only triggers commonly supported by switch LEDs.
> 
> Additional modes:
> link_10: LED on with link up AND speed 10mbps
> link_100: LED on with link up AND speed 100mbps
> link_1000: LED on with link up AND speed 1000mbps
> half_duplex: LED on with link up AND half_duplex mode
> full_duplex: LED on with link up AND full duplex mode
> 
> Additional blink interval modes:
> blink_2hz: LED blink on any even at 2Hz (250ms)
> blink_4hz: LED blink on any even at 4Hz (125ms)
> blink_8hz: LED blink on any even at 8Hz (62ms)

I would suggest separating blink intervals into a patch of their own,
because they are orthogonal to the other modes. Most PHYs are not
going to support them, or they have to be the same across all LEDs, or
don't for example make sense with duplex etc. We need to first
concentrate on the basics, get that correct. Then we can add nice to
have features like this.

     Andrew
