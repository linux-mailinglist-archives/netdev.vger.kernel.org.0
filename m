Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4D3318B46
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhBKMzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhBKMxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:53:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4CAC061756;
        Thu, 11 Feb 2021 04:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=b+d/UsRJbDcvXOU7lVKV60HeDxwwY/1A5/qcbhLE4dA=; b=V+dTCIhJyFvGttNB4GvsqDqTn
        KiA3/PTaORHH143rcJyJtmQ3iU3Z0x2jRMchnwyhG/0Oz0je0x4iOOG8sHXNCgNwzmJmiz0HLc01m
        y/dizdLNf4YwtM5TwL0rkF8UNLKN018NKuPq8W8UZ6YrhIvif/rLEO1BBVHmDZz7wB5Rcf+IowNxT
        5BHlhkzJE0G7xvdzdSk8U4oYZihX5cToyljYh1l0pGWpV7GyZguqkAYwQC4Bmx4SkCrcz4MXsOvM5
        IMjEAVvqiCxtMEa/j8xgZuyJz53Te60ZBxL8nIlR94Pm1B2JCW6JDpA+zcDBRTHt89SkxbDSI0xt1
        5dYqTcltA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42032)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lABSW-0006AO-P2; Thu, 11 Feb 2021 12:52:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lABSV-00066Z-Oe; Thu, 11 Feb 2021 12:52:35 +0000
Date:   Thu, 11 Feb 2021 12:52:35 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 09/15] net: mvpp2: enable global flow control
Message-ID: <20210211125235.GG1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-10-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-10-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:48:56PM +0200, stefanc@marvell.com wrote:
> +static void mvpp2_cm3_write(struct mvpp2 *priv, u32 offset, u32 data)
> +{
> +	writel(data, priv->cm3_base + offset);
> +}
> +
> +static u32 mvpp2_cm3_read(struct mvpp2 *priv, u32 offset)
> +{
> +	return readl(priv->cm3_base + offset);
> +}
> +

Would it also make sense to have mvpp2_cm3_modify() ? You seem to be
adding several instances of read-modify-write sequences to CM3 RAM in
your series.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
