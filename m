Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D3F4E86F4
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 10:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbiC0IeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 04:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbiC0IeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 04:34:15 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8512E192B0;
        Sun, 27 Mar 2022 01:32:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w7so7305004pfu.11;
        Sun, 27 Mar 2022 01:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a8W6NfMk0B3fe7GVZNxqPs/w6ty4Ubyw6mWBBlTbHxw=;
        b=AN8BxtvbVVdUVozmZGv0MPBUH0lNwLqERAEeOsxpBbJfwmcFnJDWOQLR13Rd2DNCNM
         AKQ4oE9rmgjfSnFV0tzK+WQtKwDpc8EDdRqFWbU3trAtRWg9URWs1EKT6t2+rWvCe734
         BC3DFyeUstHkl6yGb3rfMIJieXZzMS+Odu3RoKiUuhiiPgd2LXO2rEk6MdqC/TwX4QuH
         QZwItDmuubAliwYGJ/T52zvlAru4bffICq4P84Lp2pthJ0VwuJxraKSHoQu1+Hr94Ueu
         dZ/NwlvfftAe8lo+7uPak2xrrYBRX+J/P9Fd1VsT0OIux9PCIKPKL7DYbL3mihAhJGI/
         mGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a8W6NfMk0B3fe7GVZNxqPs/w6ty4Ubyw6mWBBlTbHxw=;
        b=vrPFz79j0o7XDy9qlRZg0uTnXInA0XQVtqkeYx5t/zMSUBRQ0syJprOUqm/DHmS14i
         bmH4WCEVnaBFAnMDYJRABtS/5OeZ3x4chx8q/bLjZopvd9fpp50qrYhMb6S6Nv93zDJ+
         ocZZZFGmJYmDklo5lLI7rkVGN3Mx3DqjiFh+1KrUiNTVkXHpamz8qGREbnPex2JM0sje
         1J0dfVPDh5+5DJNJP/q4ulPIjVmF/yiUa6aUH7NzAL66ejys2FY2azzDNmx3JGGGBGAi
         BI4tM03u4Dvgy2n/mCO7NsU9wUibiX72zXfTK28OG7me8lfjS3WHzUWfhe9Rgw2cw90z
         boQQ==
X-Gm-Message-State: AOAM532tuMoMWO2UsV5So8l/I+95JCfr2FbZUQWTlciuFNUnL1cbmCbs
        GRZbjoZOzYS4dZ7taXvWq2A=
X-Google-Smtp-Source: ABdhPJy3ZgtSpiQ5EWru2cLEHXcTTN64jQrCl49Q5MntIvrND04eywZ9Zfr10n0ClD/CDkDT9Fqp0A==
X-Received: by 2002:a63:5744:0:b0:385:fe08:e835 with SMTP id h4-20020a635744000000b00385fe08e835mr5899661pgm.397.1648369956042;
        Sun, 27 Mar 2022 01:32:36 -0700 (PDT)
Received: from localhost ([2405:201:2003:b021:6001:8ce1:3e29:705e])
        by smtp.gmail.com with ESMTPSA id k3-20020a056a00168300b004f7e60da26csm12546396pfc.182.2022.03.27.01.32.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Mar 2022 01:32:35 -0700 (PDT)
Date:   Sun, 27 Mar 2022 14:02:29 +0530
From:   Raag Jadav <raagjadav@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <20220327083229.GB3254@localhost>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <YhdimdT1qLdGqPAW@shell.armlinux.org.uk>
 <20220226072327.GA6830@localhost>
 <YhpV/Q8Pnv+OZ3Fr@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhpV/Q8Pnv+OZ3Fr@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 26, 2022 at 04:31:57PM +0000, Russell King (Oracle) wrote:
> On Sat, Feb 26, 2022 at 12:53:27PM +0530, Raag Jadav wrote:
> > On Thu, Feb 24, 2022 at 10:48:57AM +0000, Russell King (Oracle) wrote:
> > > Sorry for the late comment on this patch.
> > > 
> > > On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> > > > +static int vsc85xx_config_inband_aneg(struct phy_device *phydev, bool enabled)
> > > > +{
> > > > +	int rc;
> > > > +	u16 reg_val = 0;
> > > > +
> > > > +	if (enabled)
> > > > +		reg_val = MSCC_PHY_SERDES_ANEG;
> > > > +
> > > > +	mutex_lock(&phydev->lock);
> > > > +
> > > > +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
> > > > +			      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
> > > > +			      reg_val);
> > > > +
> > > > +	mutex_unlock(&phydev->lock);
> > > 
> > > What is the reason for the locking here?
> > > 
> > > phy_modify_paged() itself is safe due to the MDIO bus lock, so you
> > > shouldn't need locking around it.
> > > 
> > 
> > True.
> > 
> > My initial thought was to have serialized access at PHY level,
> > as we have multiple ports to work with.
> > But I guess MDIO bus lock could do the job as well.
> 
> The MDIO bus lock is the only lock that will guarantee that no other
> users can nip onto the bus and possibly access your PHY in the middle
> of an operation that requires more than one access to complete. Adding
> local locking at PHY driver level does not give you those guarantees.
> This is exactly why phy_modify() etc was added - because phy_read()..
> phy_write() does not give that guarantee.
> 
> As an example of something that could interfere - the userspace MII
> ioctls.
> 
> > I've gone through Vladimir's patches and they look more promising
> > than this approach.
> > Let me know if I could be of any help.
> 
> I haven't seen them - so up to you.
> 

Definitely worth a look.

> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
