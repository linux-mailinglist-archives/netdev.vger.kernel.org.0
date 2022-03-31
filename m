Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB0E4ED4AF
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 09:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiCaHQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 03:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiCaHQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 03:16:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793341C9B51;
        Thu, 31 Mar 2022 00:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Cftje8rQgS4kiDHkpH8Em2qt4GFjMGVk4OywwnZsT04=; b=ssEaxSvrpdL50MKhgA/GLcEdZz
        i9m33P4y2/jk8y2I+ZL/elPceIuEkXA45RCJWN2KjxG9mRjZdJEWo5KxtSZKCtqdqr+bJ6cuLQyLx
        CDsD/PeJ316Q+x8leqTfW4Z6s3jwQzC6UXvfTfnA9joUyWfUiRqolCSc1R3nrYXV2GIU6lohQpgzw
        I44ZNFkMqJLHtpEx3bYmUGX08DrMgSsJLL8ZTLU3ZeDVmVIhif+8NkU92cRiSa4uyS5eM2d/3vsSc
        9/bKLjQHacLGo6bsKXPWHznODqpyla/o/Y2B3CaNoCo1QQk7IKfBeO9SD07zpTdNP4pl47EUusC+T
        srf56/xQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58042)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZoyt-0004LR-Vq; Thu, 31 Mar 2022 08:12:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZoyn-0007QN-D8; Thu, 31 Mar 2022 08:12:25 +0100
Date:   Thu, 31 Mar 2022 08:12:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     robh+dt@kernel.org, joel@jms.id.au, andrew@aj.id.au,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, p.zabel@pengutronix.de,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, BMC-SW@aspeedtech.com
Subject: Re: [PATCH v3 2/3] net: mdio: add reset control for Aspeed MDIO
Message-ID: <YkVUWV0czTzo6MrJ@shell.armlinux.org.uk>
References: <20220325041451.894-1-dylan_hung@aspeedtech.com>
 <20220325041451.894-3-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325041451.894-3-dylan_hung@aspeedtech.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 25, 2022 at 12:14:50PM +0800, Dylan Hung wrote:
> Add reset assertion/deassertion for Aspeed MDIO.  There are 4 MDIO
> controllers embedded in Aspeed AST2600 SOC and share one reset control
> register SCU50[3].  To work with old DT blobs which don't have the reset
> property, devm_reset_control_get_optional_shared is used in this change.
> 
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

Should this really be specific to one driver rather than being handled
in the core mdio code?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
