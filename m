Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9056157F60E
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 18:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiGXQyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 12:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiGXQyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 12:54:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6770BBE3F;
        Sun, 24 Jul 2022 09:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rd7gfuHS1mYyrmMLm2WVSQ9W4kvSVg++rNp13+sTY1A=; b=letdUExvJuCNd4JAb3hIJ/ZtIt
        AYjBE+BD0KSDaIhpX4vNW62fLdIBCCSwXv5j4SOmIeJCdzFA7iM7PYio/J3YKrOp+VsiZyL9uV+ln
        jR53Rpikh48zuZXN2KMqFjV1zm3I2UOQ+Wt7hcSjoUuOJjJhnXy3bXkxUXdYbnd/3eXk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oFerf-00BNKY-Mg; Sun, 24 Jul 2022 18:53:59 +0200
Date:   Sun, 24 Jul 2022 18:53:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc:     michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ronak.jain@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, git@xilinx.com, git@amd.com
Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Message-ID: <Yt15J6fO5j9jxFxp@lunn.ch>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		ret = of_property_read_u32_array(pdev->dev.of_node, "power-domains",
> +						 pm_info, ARRAY_SIZE(pm_info));
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "Failed to read power management information\n");
> +			return ret;
> +		}
> +		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
> +		if (ret < 0)
> +			return ret;
> +

Documentation/devicetree/bindings/net/cdns,macb.yaml says:

  power-domains:
    maxItems: 1

Yet you are using pm_info[1]?

    Andrew
