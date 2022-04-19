Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7BC506CE2
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 14:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243487AbiDSNAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240912AbiDSNAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:00:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BE43388C;
        Tue, 19 Apr 2022 05:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8WBVcaV6iEXDOrTecuRrSTx95lLOpawtAYD16O9vexE=; b=VjL15INsCpOnI7UDTwDOjC1Ccr
        Oz6NOqDOqp5VE8iQDKxVC9SNLs8DLGNJGXxHDAo4hYqT9q9MaPgReKl0744ilAFiowXf00llHmDL8
        MY4a/6OUgQM7+RywlBbMU7wLSOJFOZ7ZpFjAa8y3DHNUIHM0OoWOa/a2spK3G5TkyxXY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngnQI-00GV3L-45; Tue, 19 Apr 2022 14:57:38 +0200
Date:   Tue, 19 Apr 2022 14:57:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <Yl6xwmbsTLWMaXAv@lunn.ch>
References: <YlismVi8y3Vf6PZ0@lunn.ch>
 <20220415102453.1b5b3f77@fixe.home>
 <Yll+Tpnwo5410B9H@lunn.ch>
 <20220415163853.683c0b6d@fixe.home>
 <YlmLWv4Hsm2uk8pa@lunn.ch>
 <20220415172954.64e53086@fixe.home>
 <YlmbIjoIZ8Xb4Kh/@lunn.ch>
 <20220415184541.0a6928f5@fixe.home>
 <YlrJQ47tkmQdhtMu@lunn.ch>
 <20220419110328.0241fb1f@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419110328.0241fb1f@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hum, that could be done but since only some values/combinations are
> allowed, it would potentially require to validate the setting at each
> request, leading to potential non working devices due to invalid MUX
> configuration required.

Yes, validation is messy, you have to incrementally validate as each
device probes and requests its PCS. I would not only return -EINVAL,
but also dump the current partial configuration to the kernel log. I
guess the implementation would have a big table as shown in the
datasheet. You walk the table trying to find a match for those
settings you have so far, and wildcard those you don't know yet. Fun
little coding problem.

	 Andrew
