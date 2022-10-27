Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1592A60F757
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiJ0MdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiJ0MdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:33:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CD115819D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EOWnwd5ogTKTrTO5IJM3kbMguYNixvt8b7C9UHJO00k=; b=Tww9yWQaNaL2XQWfKlfUJJGR+Z
        uaoxZCMdW2xiu8JDJ+jBqoIxGx0icN21vc3bFuxpEPGZSCoeMDxVQR05rC415C1CVWihdb/l5k39i
        H0jmQalb2wXT2PTg9BnqwmReShCWm+Il0fUgnin9mH+xo6Qq47H/XVlGHYCZJvBtkswY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oo24B-000hnv-Tx; Thu, 27 Oct 2022 14:32:59 +0200
Date:   Thu, 27 Oct 2022 14:32:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@denx.de>
Subject: Re: Marvell 88E6320 connected to i.MX8MN
Message-ID: <Y1p6ex85pFapxz3s@lunn.ch>
References: <CAOMZO5DJAsj8-m2tEfrHn4xZdK6FE0bZepRZBrSD9=tWSSCNOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DJAsj8-m2tEfrHn4xZdK6FE0bZepRZBrSD9=tWSSCNOA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is my devicetree:
> https://pastebin.com/raw/TagQJK2a

You have rgmii-id on both the FEC and the CPU port. So in theory you
might be getting double the needed delays? The mv88e6xxx driver will
apply these delays on the CPU port, but i don't know if the FEC does.

The other thing i've done wrong in the past with FEC is get the pinmux
wrong, so the reference clock was not muxed. Check how the reference
clock should used, is it from the switch to the FEC, or the other way
around. If the FEC is providing it, is it ticking?

	Andrew
