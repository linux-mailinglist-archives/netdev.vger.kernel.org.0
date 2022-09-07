Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505735B00C4
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiIGJmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiIGJmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:42:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664D78982D;
        Wed,  7 Sep 2022 02:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bBF+Rv278ELaWQYomVC/R80IlaIGgocgfWpC09/monk=; b=BmU7sg+GF1Of3WQeA96HPNTZv0
        SpBcXOo4lMKY6pvWPnioBiXflfXx5ILHzziKjynM8D6ix0PApYa3dKN8opEh1pAqubmJyG50wsJLu
        6EKXCO5xB6pxs8hBozRNb+dMtAPv06fNbXJmqg/FbIUHNSHyxV6luWp5ida5Qc5P5LP+Nf0rhYl8h
        joX9R1r0/CeCTWF//jmLhqZFQSMBgYE6wnWiqO9s27iqG9ZUbPCz4jh3bpmtYYmHIg14Ox5jWOkRG
        9jTWq9b5QtBnB0D0VDoB0E0ezkksDNmjI5g7xdv1/Xn4GpJF74/p97JhA/W9/WSMpjATM7VrwP9Y+
        zwxJTDGQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34170)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oVrZL-0005CI-8k; Wed, 07 Sep 2022 10:42:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oVrZK-0000sV-F6; Wed, 07 Sep 2022 10:42:02 +0100
Date:   Wed, 7 Sep 2022 10:42:02 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v5 3/8] net: phylink: Generate caps and convert
 to linkmodes separately
Message-ID: <YxhnaqCfKMKm5zFy@shell.armlinux.org.uk>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-4-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906161852.1538270-4-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 12:18:47PM -0400, Sean Anderson wrote:
> @@ -409,11 +407,14 @@ void phylink_generic_validate(struct phylink_config *config,
>  			      unsigned long *supported,
>  			      struct phylink_link_state *state)
>  {
> +	unsigned long caps;
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };

net code requires reverse christmas tree for variable declarations.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
