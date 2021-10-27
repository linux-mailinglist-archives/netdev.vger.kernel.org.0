Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DA743C8AF
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 13:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbhJ0LhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 07:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhJ0LhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 07:37:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A36C061745;
        Wed, 27 Oct 2021 04:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vkzTnRsFNQy28hg2qAojgnTTG6uRtg36mAzN67icHy0=; b=G1TJyFRuxR/e28VjSxIRUhSgSs
        q1j+KIA+7XsorRJQpJXZzUSfguLLOaWeXFZ5ie0oJbBRziZ82XOiCXPs+C9CqmFyM38xiLWFhgK52
        FcRlco+MIfTAMbDrN0ceMVzEiOBJJtOpxahtFepqFHzTxEymhfyppVGy4XTsDOOdVWtDjtm02hl8h
        b8dRQzHwFk/yGz1d09hqIXtwiSw3hOXlHsNlf+rNctWEGhVsQMNWe2AxC72ft/Pjy/0T9aSzk3JrY
        cCCF0VsFfnO7hvzzlKG3flhcC76Jzq2Vot47swa8hZnR/AvXpImWwa4l66QlF0AD4h/iPyeNM+dmp
        N1weyPCA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55340)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mfhCe-0006Kr-Gs; Wed, 27 Oct 2021 12:34:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mfhCc-0007gl-Un; Wed, 27 Oct 2021 12:34:42 +0100
Date:   Wed, 27 Oct 2021 12:34:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <YXk5Uii+pNPaDiSR@shell.armlinux.org.uk>
References: <20211027220721.5a941815@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027220721.5a941815@canb.auug.org.au>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 10:07:21PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced this warning:
> 
> include/linux/phylink.h:82: warning: Function parameter or member 'DECLARE_PHY_INTERFACE_MASK(supported_interfaces' not described in 'phylink_config'
> 
> Introduced by commit
> 
>   38c310eb46f5 ("net: phylink: add MAC phy_interface_t bitmap")
> 
> Or maybe this is a problem with the tool ...

Hmm. Looks like it is a tooling problem.

 * @supported_interfaces: bitmap describing which PHY_INTERFACE_MODE_xxx
 *                        are supported by the MAC/PCS.

        DECLARE_PHY_INTERFACE_MASK(supported_interfaces);

I'm guessing the tool doesn't use the preprocessed source. I'm not sure
what the solution to this would be.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
