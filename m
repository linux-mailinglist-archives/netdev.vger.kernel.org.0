Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFBE6BA4F5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 02:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCOB6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 21:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCOB6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 21:58:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793E11D93C;
        Tue, 14 Mar 2023 18:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cZXJ8oSjvlAjO9dl8hZv7ony8k6kk06ukLqbV6cbeyE=; b=h5ySyWe0uaxLa/3IUKIQLGTuF9
        lOnVTz8EMh+eph5z5jTnybcMy91yjf58GU7sg92/8AUjqcgMkX1teEJHr9lDAcaH0J3umrf/r5bJG
        WdiV8kZwFWxPujviN8EmnbGK7eClvEjudS7TbXxPaAT8IuyJReQud7hJgTeLE9BPtA/A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pcGPH-007Llj-7v; Wed, 15 Mar 2023 02:58:23 +0100
Date:   Wed, 15 Mar 2023 02:58:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [net-next PATCH v3 09/14] dt-bindings: net: dsa: dsa-port:
 Document support for LEDs node
Message-ID: <afd1f052-6bb6-4388-9620-1adb02e6d607@lunn.ch>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-10-ansuelsmth@gmail.com>
 <20230314101516.20427-10-ansuelsmth@gmail.com>
 <20230315005000.co4in33amy3t3xbx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315005000.co4in33amy3t3xbx@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:50:00AM +0200, Vladimir Oltean wrote:
> On Tue, Mar 14, 2023 at 11:15:11AM +0100, Christian Marangi wrote:
> > Document support for LEDs node in dsa port.
> > Switch may support different LEDs that can be configured for different
> > operation like blinking on traffic event or port link.
> > 
> > Also add some Documentation to describe the difference of these nodes
> > compared to PHY LEDs, since dsa-port LEDs are controllable by the switch
> > regs and the possible intergated PHY doesn't have control on them.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/dsa/dsa-port.yaml | 21 +++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> 
> Of all schemas, why did you choose dsa-port.yaml? Why not either something
> hardware specific (qca8k.yaml) or more generic (ethernet-controller.yaml)?

The binding should be generic. So qca8k.yaml is way to specific. The
Marvell switch should re-use it at some point.

Looking at the hierarchy, ethernet-controller.yaml would work since
dsa-port includes ethernet-switch-port, which includes
ethernet-controller.

These are MAC LEDs, and there is no reason why a standalone MAC in a
NIC could not implement such LEDs. So yes,
ethernet-controller.yaml.

Is there actually anything above ethernet-controller.yaml? This is
about a netdev really, so a wifi MAC, or even a CAN MAC could also use
the binding....

    Andrew
