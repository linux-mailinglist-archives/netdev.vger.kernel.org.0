Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDC66F0547
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 14:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243657AbjD0MET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 08:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243215AbjD0MES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 08:04:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4C1524F;
        Thu, 27 Apr 2023 05:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nYa/8ox879vAurF3/ChPDco9/s1SvwncDHNZ4lY9C8M=; b=zrxHHg1qFaP7dAOLkgqO8584Wy
        s4gWCW4GOLcD5t+6p/KraezkOfzqEk/GVLX7cD0dWLlsDThHXdkh1dP+IUhfungYRc/twulwG5gpD
        pxGnSDyi6Ia8vcoxZ4dYLhx1tBBhS0mLTo+nEpy51O28YMbLlfz4dO6WyZbCKbGEOIEM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ps0Lz-00BLck-Em; Thu, 27 Apr 2023 14:04:03 +0200
Date:   Thu, 27 Apr 2023 14:04:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
Subject: Re: [RFC PATCH 2/2] net: phy: dp83869: fix mii mode when rgmii strap
 cfg is used
Message-ID: <f5c5b4e6-c0a6-4782-b1a7-822df6369cc4@lunn.ch>
References: <20230425054429.3956535-1-s-vadapalli@ti.com>
 <20230425054429.3956535-3-s-vadapalli@ti.com>
 <cbbedaab-b2bf-4a37-88ed-c1a8211920e9@lunn.ch>
 <99932a4f-4573-b80b-080b-7d9d3f57bef0@ti.com>
 <5a2bc044-5fb0-4162-a75a-24c94f8ed3f7@lunn.ch>
 <cce70be8-4d2a-1499-fea5-5efa6c5f1420@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce70be8-4d2a-1499-fea5-5efa6c5f1420@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If you say so. I was just thinking you could give the poor software
> > engineer a hint the hardware engineer has put on strapping resistors
> > which means the PHY is not going to work.
> 
> I understand now. I will update this patch to add a print if the MII mode is not
> valid with the configured "dp83869->mode". Would you suggest using a dev_err()
> or a dev_dbg()?

dev_err(). And you can return -EINVAL when asked to set the interface
mode.

	Andrew
