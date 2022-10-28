Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F7D6116B0
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiJ1QA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiJ1P7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:59:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A77C21E101
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 08:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=UgiDe1mvjaMx7XNNDngE47i9skXbVnYdPGoUIcgFqOA=; b=eJ
        5ToRdYjlgcITcybjZc403q3Vhf22/nCDHei8hkmfuua7wikEVZo9fs2oKhD/syzcZ318ca07bS3kI
        GMDxM37hMfAjbWMQ2MGbP6RnDasGfic3LIrFYMbpGJ8Nujax+imENp8dVFDzyHz9+MXFYK8wCC41L
        CymSqfrvnZ5oRsw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooRk9-000pIi-Ps; Fri, 28 Oct 2022 17:58:01 +0200
Date:   Fri, 28 Oct 2022 17:58:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com,
        netdev@vger.kernel.org,
        Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH v2 net-next] net: dsa: mv88e6xxx: Add
 .port_set_rgmii_delay to 88E6320
Message-ID: <Y1v8CdFhpNSG8sHZ@lunn.ch>
References: <20221028135148.105691-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221028135148.105691-1-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 10:51:48AM -0300, Fabio Estevam wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Currently, the port_set_rgmii_delay hook is missing for the 88E6320
> family, which causes failure to retrieve an IP address via DHCP.
> 
> Add mv88e6320_port_set_rgmii_delay() that allows applying the RGMII
> delay for ports 2, 5 and 6, which are the ports only that can be used
> in RGMII mode.
> 
> Tested on a i.MX8MN board connected to an 88E6320 switch.
> 
> This change also applies safely to the 88E6321 variant.

> @@ -5029,6 +5029,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
>  	.phy_write = mv88e6xxx_g2_smi_phy_write,
>  	.port_set_link = mv88e6xxx_port_set_link,
>  	.port_sync_link = mv88e6xxx_port_sync_link,
> +	.port_set_rgmii_delay = mv88e6320_port_set_rgmii_delay,
>  	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
>  	.port_tag_remap = mv88e6095_port_tag_remap,
>  	.port_set_frame_mode = mv88e6351_port_set_frame_mode,

You say it is safe, but then don't actually add it to mv88e6321_ops ?

    Andrew
