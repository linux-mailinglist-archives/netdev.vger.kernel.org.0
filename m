Return-Path: <netdev+bounces-11807-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3E47347F3
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 21:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B7EE1C208DB
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308468472;
	Sun, 18 Jun 2023 19:18:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242671FD1
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 19:18:47 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992ADF5
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 12:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7BifcjyD6BZdTKC4YpG2UA6p9aySU0fn6yTbC6MsAA8=; b=GDnv7aXsy2SrnDIeeiD9BTL56d
	QZG3YGvvYcItnIC32qhPkFqJmZ+RC6nbLyutMN7vV3rEL7/aug3eNqyBZRT4LJOIQ8/uHIHNvnj5F
	2BspnmwBkQ/Sm8ZbW5XiMeYyEKxk2vA6Cqc9/RfQzDaL8+vrOaasV8qXgT6UjoHwomf/iSLATsN7D
	PzVn8D87/atfhuNwM6jCToTURJw0GoYWyWRNc164Q4g5C6h7cLJimetE+D7VwrZTU2g4yvg0ElUb5
	GN/pOZkV33VH5c54G9N8sme1IIUx+LcXL0hXz+0vKPXnttSMSsMoueaWbNxJAjsfneUqKpo7yifnX
	jWAlHJDw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54598)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qAxv9-0007XG-CV; Sun, 18 Jun 2023 20:18:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qAxv8-0004r1-Cc; Sun, 18 Jun 2023 20:18:42 +0100
Date: Sun, 18 Jun 2023 20:18:42 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>, Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v4 net-next 1/9] net: phy-c45: Fix
 genphy_c45_ethtool_set_eee description
Message-ID: <ZI9YkpEsaCj+cDqP@shell.armlinux.org.uk>
References: <20230618184119.4017149-1-andrew@lunn.ch>
 <20230618184119.4017149-2-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230618184119.4017149-2-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 08:41:11PM +0200, Andrew Lunn wrote:
> The text has been cut/paste from  genphy_c45_ethtool_get_eee but not
> changed to reflect it performs set.
> 
> Additionally, extend the comment. This function implements the logic
> that eee_enabled has global control over EEE. When eee_enabled is
> false, no link modes will be advertised, and as a result, the MAC
> should not transmit LPI.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/phy-c45.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index fee514b96ab1..d1d7cf34ac0b 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -1425,12 +1425,15 @@ int genphy_c45_ethtool_get_eee(struct phy_device *phydev,
>  EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
>  
>  /**
> - * genphy_c45_ethtool_set_eee - get EEE supported and status
> + * genphy_c45_ethtool_set_eee - set EEE supported and status
>   * @phydev: target phy_device struct
>   * @data: ethtool_eee data
>   *
> - * Description: it reportes the Supported/Advertisement/LP Advertisement
> - * capabilities.
> + * Description: it set the Supported/Advertisement/LP Advertisement

      Description: sets the ...

> + * capabilities. If eee_enabled is false, no links modes are
> + * advertised, but the previously advertised link modes are

I'd suggest moving "advertised," to the preceding line to fill it
more...

> + * retained. This allows EEE to be enabled/disabled in a none
> + * destructive way.

which then would allow "non-destructive" here rather than the slightly
more awkward (but correct) "non-
destructive" formatting here.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

