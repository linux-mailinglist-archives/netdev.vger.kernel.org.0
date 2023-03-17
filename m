Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D0C6BEA25
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 14:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjCQNfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 09:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjCQNfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 09:35:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2255932CF6;
        Fri, 17 Mar 2023 06:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sMgPoyPPbmthFsOo4pbmCIyEwyFeSHdtD951iyErX4c=; b=N+Y1sHinP4QOoLsO2qOFjgGPGD
        jRqmx45xn4xtEWFjeN/F1sNKAbV2b8yySim0h7I3sEDVUc40Afz25wbdGX3CpsTO0jPXXKMGa0AFO
        P6/YbERXaivsDWH5iiN3L0afOlZAfYU3tYqA6Zntm6CSMgDRnsY4+Ov+7Ej5lr41Owww=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdAE7-007c37-QO; Fri, 17 Mar 2023 14:34:35 +0100
Date:   Fri, 17 Mar 2023 14:34:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v4 02/14] net: dsa: qca8k: add LEDs basic support
Message-ID: <1c84a42a-2691-4ee9-bbe3-dc8e65fc31b1@lunn.ch>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-3-ansuelsmth@gmail.com>
 <ZBRN563Zw9Z28aET@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBRN563Zw9Z28aET@localhost.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> (I guess the LED configuration i only makes sense for non-CPU ports? It
> seems you want to configure up to 15 LEDs in total for 5 ports).

Hi Michal

In the general case, there is no reason that i can think that stops
the CPU port having LEDs. For many switch designs, there is no
specific CPU port, any can be used. And all ports are likely to have
an LED controller.

What becomes tricky with Linux is offloading blinking to CPU ports.
There is no netdev to represent it, hence no netdev based software
blinking. And without software blinking, you have nothing to offload
to hardware. But you could still use the LEDs for other things.

Having said all that, i don't think i have ever seen a box with LEDs
for the CPU port.

    Andrew
