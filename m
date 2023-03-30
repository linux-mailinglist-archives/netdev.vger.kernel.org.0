Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048CE6CFEF3
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjC3Is7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjC3Is5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:48:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC444224;
        Thu, 30 Mar 2023 01:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DeoOfJL7K3GiaKcfJFMtzEsEv1I6MZwA6BRk3bNkuzo=; b=JGQ5zvhVGHb6PnmUfHz26YdCdI
        Q0jblHgYA8Ba6VeYMYomKYccVYenAppAY1ABeKiTIEJNaHKvfbWPkmRBvm3KTVsf2HgYPVgCrYWYS
        reuKnGxaoDBXoqrGfPaMfUSnfqRqxThg+lVgc6FxlVq49LnQfWsWy/ohJ1ctYvWIe/t0f3qHHuNqc
        lYXpuvU8xA8+0sNB0wWv9LLomocgb5QFhM8gymEqNJZoy66FoS5Xo7odCLB6v/g85NhUTdTJm1p9m
        VIgEwoeIuMQUGaOxGU+hLPYzBCT0+LWB0zm03X00+beN8y24EkNOjAfpLttekHkU8VUO9aXVacSpK
        N0BgcFeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37588)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1phnxR-0001y4-3E; Thu, 30 Mar 2023 09:48:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1phnxN-0008Pd-GB; Thu, 30 Mar 2023 09:48:29 +0100
Date:   Thu, 30 Mar 2023 09:48:29 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, andrew@lunn.ch,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v4 1/3] net: phylink: add phylink_expects_phy() method
Message-ID: <ZCVM3c+Pk38pv6vs@shell.armlinux.org.uk>
References: <20230330084000.3292487-1-michael.wei.hong.sit@intel.com>
 <20230330084000.3292487-2-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330084000.3292487-2-michael.wei.hong.sit@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 04:39:58PM +0800, Michael Sit Wei Hong wrote:
> Provide phylink_expects_phy() to allow MAC drivers to check if it
> is expecting a PHY to attach to. Since fixed-linked setups do not
> need to attach to a PHY.
> 
> Provides a boolean value as to if the MAC should expect a PHY.
> returns true if a PHY is expected.
> 
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---
>  drivers/net/phy/phylink.c | 17 +++++++++++++++++
>  include/linux/phylink.h   |  1 +
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 1a2f074685fa..4c080656e280 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1586,6 +1586,23 @@ void phylink_destroy(struct phylink *pl)
>  }
>  EXPORT_SYMBOL_GPL(phylink_destroy);
>  
> +/**
> + * phylink_expects_phy() - Determine if phylink expects a phy to be attached
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * Fixed-link mode does not need a PHY, returns a boolean value to check if
> + * phylink will be expecting a PHY to attach.

This description could be clearer (for example, it isn't just about
fixed-link mode), but apart from that, it's good. I don't think that's
a reason to delay this any further, but please follow-up with a patch
to improve this description.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
