Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD9D534F2E
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347309AbiEZMcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347281AbiEZMcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:32:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D5D9596;
        Thu, 26 May 2022 05:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wF8XuVv4mQ1+nmm8VPTygZ9HsG27ew/AaBd2b5MOd4g=; b=wC8se2ghyF+jb6nNGxIwCKn6/N
        HcTNdSoruv7771/MS7Vrmvb529ZovFG7BgUiVjo5s7CH85tvFAJ4FYkGP7b4gb9W4OgDcLmV50/Jg
        oK3i8Y98rAfBC8oNoqOQrAufk2u0k599YYz+sKezh7Bu8ZoajLAZbch1Bq35CD2nvubE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nuCf0-004Lth-Cu; Thu, 26 May 2022 14:32:14 +0200
Date:   Thu, 26 May 2022 14:32:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dan Murphy <dmurphy@ti.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net-next v2 1/1] net: phy: dp83867: retrigger SGMII AN
 when link change
Message-ID: <Yo9zTmMduwel8XeZ@lunn.ch>
References: <20220526090347.128742-1-tee.min.tan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526090347.128742-1-tee.min.tan@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 05:03:47PM +0800, Tan Tee Min wrote:
> There is a limitation in TI DP83867 PHY device where SGMII AN is only
> triggered once after the device is booted up. Even after the PHY TPI is
> down and up again, SGMII AN is not triggered and hence no new in-band
> message from PHY to MAC side SGMII.
> 
> This could cause an issue during power up, when PHY is up prior to MAC.
> At this condition, once MAC side SGMII is up, MAC side SGMII wouldn`t
> receive new in-band message from TI PHY with correct link status, speed
> and duplex info.
> 
> As suggested by TI, implemented a SW solution here to retrigger SGMII
> Auto-Neg whenever there is a link change.

Is there a bit in the PHY which reports host side link? There is no
point triggering an AN if there is already link.

      Andrew
