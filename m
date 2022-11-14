Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC16627C5E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiKNLcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiKNLcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:32:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA12BC50;
        Mon, 14 Nov 2022 03:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WWLpgrUnMpDL7blwsvF5dOfQKm1L1ZS3Z5Ep+83hIgU=; b=eliEjRqitFRP24Nf4GZqFcjjMG
        VNcj/ugP24nWY/LhW0mAh2PQSXPGx09anHEamUWVV1VuS+SmsYMdJgeFyK4HQyIewpQ5vK46fDbTU
        L1Mk0YBBvKN4GUg/8HaDiKEY0nF1rTJoJ2RbF0So/OsLuZlM525Ez/V6Th/ijVKA6oJkldC6vByoN
        2vkUwxV9lGEPmfDqXSJRj+XL6IQtF5tjYO9mGMA/MtF4h9dAhbgqvplSp1pz+UkUYftw4WwCNYm2B
        +y+DzGcDAMGdZL7KCfglBUvmgkBttyMfiT+sieE5/43PRt9xprPOs0EImeRI1d1MsDbFTrHm8ui6b
        U59aNjSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35256)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ouXgw-0000hT-QD; Mon, 14 Nov 2022 11:31:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ouXgu-0003m0-KS; Mon, 14 Nov 2022 11:31:52 +0000
Date:   Mon, 14 Nov 2022 11:31:52 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, andre.edich@microchip.com,
        linux-usb@vger.kernel.org
Subject: Re: [net] net: usb: smsc95xx: fix external PHY reset
Message-ID: <Y3InKCr9BGaf8wiI@shell.armlinux.org.uk>
References: <20221114131643.19450-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114131643.19450-1-alexandru.tachici@analog.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 03:16:43PM +0200, Alexandru Tachici wrote:
> +	} else {
> +		/* Driver has no knowledge at this point about the external PHY.
> +		 * The 802.3 specifies that the reset process shall
> +		 * be completed within 0.5 s.
> +		 */
> +		fsleep(500000);
> +	}

It's slightly more code, but would it be better to do this in the
mdiobus reset() method?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
