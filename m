Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA216508BB
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 09:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiLSIrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 03:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiLSIrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 03:47:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6423631C;
        Mon, 19 Dec 2022 00:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xECLJ6vvuGycZgsWCavR/22ByPpdv0Uc/q/a2trfbwU=; b=Ic1zhl1DaygTj4JKq8+KUL+L/+
        f0g6dHAHYDpy92tYoDjZbnCL/NwSRtWO6cnIdbCfZjjD2MJUKbp0gY9PZHtPWgYY7DZ9UCuOsyHck
        Nsa2kHy+xNoDK0s4lSGm87ifxFlURLGf9mmuiRswIGUL/MGaRd/O7yq94opN9hm886d1ZiZPAh2VJ
        xIT79fpXKtZ+M0cq8Se41Tvp0xuermhtTZuLQ7AERVkpM/IRm+yDzHA3purJkEkCSpLL37OpHVZt/
        rVSkG/zHu4y4ZcuKDO942YHPUwDtGMR9BUkYIi1GyF0VbY1wivRKTtOG+rgwR4W8UoowerQ4g9h0X
        4Yafh3uQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35776)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p7Bni-0008Cf-CD; Mon, 19 Dec 2022 08:47:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p7Bnf-0004Ur-1t; Mon, 19 Dec 2022 08:47:07 +0000
Date:   Mon, 19 Dec 2022 08:47:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>
Subject: Re: [PATCH RFC 1/2] i2c: add fwnode APIs
Message-ID: <Y6AlC+9iGVGzWSbc@shell.armlinux.org.uk>
References: <Y5B3S6KZTrYlIH8g@shell.armlinux.org.uk>
 <E1p2sVM-009tqA-Vq@rmk-PC.armlinux.org.uk>
 <Y5G2kkGC69FVWaiK@black.fi.intel.com>
 <Y5G5ZyO1XRgjfN90@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5G5ZyO1XRgjfN90@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mika,

On Thu, Dec 08, 2022 at 10:16:07AM +0000, Russell King (Oracle) wrote:
> Hi Mika,
> 
> On Thu, Dec 08, 2022 at 12:04:02PM +0200, Mika Westerberg wrote:
> > Hi,
> > 
> > On Wed, Dec 07, 2022 at 11:22:24AM +0000, Russell King (Oracle) wrote:
> > > +EXPORT_SYMBOL(i2c_find_device_by_fwnode);
> > > +
> > 
> > Drop this empty line.
> 
> The additional empty line was there before, and I guess is something the
> I2C maintainer wants to logically separate the i2c device stuff from
> the rest of the file.
> 
> > > +/* must call put_device() when done with returned i2c_client device */
> > > +struct i2c_client *i2c_find_device_by_fwnode(struct fwnode_handle *fwnode);
> > 
> > With the kernel-docs in place you probably can drop these comments.
> 
> It's what is there against the other prototypes - and is very easy to
> get wrong, as I've recently noticed in the sfp.c code as a result of
> creating this series.
> 
> I find the whole _find_ vs _get_ thing a tad confusing, and there
> probably should be just one interface with one way of putting
> afterwards to avoid subtle long-standing bugs like this.
> 
> Thanks.

Do you have any comments on my reply please?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
