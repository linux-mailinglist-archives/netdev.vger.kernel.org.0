Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9792A4C545C
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 08:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiBZHYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 02:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiBZHYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 02:24:08 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8E114A6F0;
        Fri, 25 Feb 2022 23:23:34 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b22so6588930pls.7;
        Fri, 25 Feb 2022 23:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vmKathGK6mfgAHLPLOY5TXssiRrWVPGkmG385lwzvBE=;
        b=T3RjDHOa513Nwxhzbj+/Zrz982LT0OyqV0K2hCl3b5wt5pR1sM4KjzxwmWg7KF9GA9
         2G0nadY6nW9MB5sARr/01cFMPxFAzUrL+rygYksFjY7Eg5+YLFvnVNTK30LcZtyhhIam
         XGyRtZWyg3MUqPFdSRQcOZNjbZoh4bS8lyhybab2FypZk434pwVMeqn/lK6AJ56ot6Nn
         t0eAeqEeOGK2wOw4FaqMljvWyXTrLjQ7pefQI/r2KW6pyEeveUCHje/CeZToMGbfoQC+
         orG3s2ZfIkg7ESY3qV59HtEr44FjqcS0d5JiXMmrViBAMKJuHhsVUon0DtVDBqNver0Q
         ce+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vmKathGK6mfgAHLPLOY5TXssiRrWVPGkmG385lwzvBE=;
        b=rwPETCUjODtHmx5guWiSzOhrI91AvMfh4ylqrMngYmQva9YRj9G1qZLHkRgciIqC9N
         6CirqAu5eRzHyT2x8EG6QTqG3RvUoxZi67+vZlRJgLI7CMKuBbhZSmKvbLkDFXeIk5R1
         EhN0CPu+xqflwAJo6Pv5mOAJcHnrerKTN3Mt2EUIqMuPif5fa2EluPnnQUbPvQEw2c+2
         L4LACc2LigZFlELbNQIHEXIaLpCKZlcUFHaXfHy7SxT9tsgDtPhy+zMCp//ilWRLluw1
         jsY2+0me3Yy18WaAI4QXyv2Dta1PGOsP3QlpNPIIt307XbSeAOrN/Nvfz09PEmac6VJc
         dN9A==
X-Gm-Message-State: AOAM533xpdJLxvqk2DDamClCAJlADKvFWdFh08iFgZ6a+gH4xIyFfQrO
        cClRm0mQPZAOaywXSYrmEqw=
X-Google-Smtp-Source: ABdhPJxIHC6vdgLY4plb4nLRWbHxo6QegFm8ozZ64RRk2jUixv2U5fsd+oUXOlJBi3jRMN0hsP1Uhw==
X-Received: by 2002:a17:902:f64d:b0:14f:fb63:f1a with SMTP id m13-20020a170902f64d00b0014ffb630f1amr11144031plg.159.1645860213759;
        Fri, 25 Feb 2022 23:23:33 -0800 (PST)
Received: from localhost ([2405:201:2003:b021:6001:8ce1:3e29:705e])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a000b4a00b004e12fd48035sm5757150pfo.96.2022.02.25.23.23.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Feb 2022 23:23:33 -0800 (PST)
Date:   Sat, 26 Feb 2022 12:53:27 +0530
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
Message-ID: <20220226072327.GA6830@localhost>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <YhdimdT1qLdGqPAW@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhdimdT1qLdGqPAW@shell.armlinux.org.uk>
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

On Thu, Feb 24, 2022 at 10:48:57AM +0000, Russell King (Oracle) wrote:
> Sorry for the late comment on this patch.
> 
> On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> > +static int vsc85xx_config_inband_aneg(struct phy_device *phydev, bool enabled)
> > +{
> > +	int rc;
> > +	u16 reg_val = 0;
> > +
> > +	if (enabled)
> > +		reg_val = MSCC_PHY_SERDES_ANEG;
> > +
> > +	mutex_lock(&phydev->lock);
> > +
> > +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
> > +			      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
> > +			      reg_val);
> > +
> > +	mutex_unlock(&phydev->lock);
> 
> What is the reason for the locking here?
> 
> phy_modify_paged() itself is safe due to the MDIO bus lock, so you
> shouldn't need locking around it.
> 

True.

My initial thought was to have serialized access at PHY level,
as we have multiple ports to work with.
But I guess MDIO bus lock could do the job as well.

Will fix it in v2 if required.

I've gone through Vladimir's patches and they look more promising
than this approach.
Let me know if I could be of any help.

Cheers,
Raag

> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
