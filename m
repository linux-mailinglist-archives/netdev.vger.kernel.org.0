Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D252B6D5C16
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbjDDJln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbjDDJlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:41:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702D7E7C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 02:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=viEUy6XvgjwI/YAj1d0mmBUQTlYsko5hrhU3t25wBLA=; b=i2wqh6nOgFvWrLcnEUZ8rWszV0
        O0iZFTtpJ/bReu+wOLL8BnYpdpfPmum6Oi/UHY39At1sG2CUa/wdH+k7zygcsCyvX9crMJjLjYlXF
        l0ui+z8P5mDaRUhTfK4P8VOUntjd+TyU1aOEgc4nByV3NVvskV1IZOSGYGMZoxiuhQD4CRUXU0DUR
        aYJDAQj6cFLTt8CKRJn0TKV/Un3aDZR5uuEBmdQYm67kZLD/p735uN5AHwcGCunF/Co/0wd5CyRj/
        jcopqBqm/Ratd9DazBR7K8Z63qkwAA14MglApNyJlYzRF2Cbmd749TjPh+F1Q6JNTtQRLmc/8h0GR
        qa5HnfVw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39858)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjdAZ-0003rt-Av; Tue, 04 Apr 2023 10:41:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjdAY-0005AJ-9i; Tue, 04 Apr 2023 10:41:38 +0100
Date:   Tue, 4 Apr 2023 10:41:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        John Crispin <john@phrozen.org>
Subject: Re: Convention regarding SGMII in-band autonegotiation
Message-ID: <ZCvw0vOSkKMa2vlz@shell.armlinux.org.uk>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
 <a0570b00-669f-120d-2700-a97317466727@gmail.com>
 <ZCvqJAVjOdogEZKD@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCvqJAVjOdogEZKD@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 10:13:59AM +0100, Daniel Golle wrote:
> On Tue, Apr 04, 2023 at 08:31:12AM +0200, Heiner Kallweit wrote:
> > Ideas from the patches can be re-used. Some patches itself are not ready
> > for mainline (replace magic numbers with proper constants (as far as
> > documented by Realtek), inappropriate use of phy_modify_mmd_changed,
> > read_status() being wrong place for updating interface mode).
> 
> Where is updating the interface mode supposed to happen?

I think Heiner may be confused.

The interface mode update can _only_ happen in read_status(). It's just
another parameter that the PHY changes as a result of media
negotiation, just like "speed" and "duplex" etc.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
