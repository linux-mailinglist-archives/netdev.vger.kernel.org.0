Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0A86BEB27
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjCQO22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjCQO20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:28:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087093AB7;
        Fri, 17 Mar 2023 07:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gjrdsh/T7y7UViQuEc8wrsbz0zXKzRtwCtUIMh9Yoic=; b=A9+BHSR86sQNv3Lb9wFr9RJXBO
        X9d6T5BCctIsGMKrD1vEJWQEqRk/1G6fkbLr9t/qfWHeA4g2NJGK3WGoyZKqjV/nl9MR6NMrSRHFM
        potdTIhljFxCaS7MUtnamZwAueWDD1ujyCAlBuLkdZaYVWkXt71nZEpGjvM+GtwzATTA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdB45-007cLI-8B; Fri, 17 Mar 2023 15:28:17 +0100
Date:   Fri, 17 Mar 2023 15:28:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Bartosz Wawrzyniak <bwawrzyn@cisco.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        claudiu.beznea@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        danielwa@cisco.com, olicht@cisco.com, mawierzb@cisco.com
Subject: Re: [PATCH] net: macb: Set MDIO clock divisor for pclk higher than
 160MHz
Message-ID: <1636986a-9748-4a37-aaf0-945590c042c8@lunn.ch>
References: <20230316100339.1302212-1-bwawrzyn@cisco.com>
 <7f3d0f2c-8bf9-41aa-8a7f-79407753df3b@lunn.ch>
 <3a625bc5-80ed-925d-2e16-bc3535320963@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a625bc5-80ed-925d-2e16-bc3535320963@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I see them existing in all variants of "GEM" controller and the older "MACB"
> uses a different path so I think that we are save enabling these values.

Great. Thanks for checking.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

FYI: Documentation/devicetree/bindings/net/mdio.yaml defines:

  clock-frequency:
    description:
      Desired MDIO bus clock frequency in Hz. Values greater than IEEE 802.3
      defined 2.5MHz should only be used when all devices on the bus support
      the given clock speed.

So you could if you want make the bus speed configurable. Some devices
do work at faster than 2.5MHz, which can be nice if you have a lot of
traffic, e.g. an Ethernet switch, or raw TDR cable test data.

    Andrew
