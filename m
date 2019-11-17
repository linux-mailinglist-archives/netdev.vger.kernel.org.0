Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D996FFAD0
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 18:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfKQRBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 12:01:11 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50398 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfKQRBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 12:01:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=56L2Xd2v6LwVBR1J7f/EzgNcQChtNjfEA0WnAJiyHAc=; b=dY4d1U+9XtKSFjUOOKDzL8Dpv
        5IifM4x19Hym3GOQIVa8+MwDIgnlopf4aXpaaYhzOzgX+cokJB12qiqwBUfD3PUyIysJZQIMkj/XW
        d/1Sp6f5Y/v6UBcnN8dDA319WfTksX2AB451c4H5f8OPJN860PtW8BVVb12l9ZcN/c+K3JulZRMaE
        Jt2qyjUdEdVE8TeaQmqn0ZSfDFpGiPVUeyadUIZ3pulgLaveVacgGXLP9WJ94uiiWZdxH6NUVvuWx
        BHdmVAU9likEXrkpZpQlhxvXbdY/gq7NfpGUlUV8cyAsYbXyZuxfcD86SuZnMLr3xdUldKM8JOtAH
        ZeboJo1AQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:57492)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iWNv5-0006Ty-JV; Sun, 17 Nov 2019 17:01:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iWNv3-0007NG-EV; Sun, 17 Nov 2019 17:01:01 +0000
Date:   Sun, 17 Nov 2019 17:01:01 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191117170101.GJ1344@shell.armlinux.org.uk>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
 <1572477512-4618-5-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572477512-4618-5-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 01:18:31AM +0200, Ioana Ciornei wrote:
> +static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
> +	.validate = dpaa2_mac_validate,

I notice you haven't provided a mac_link_state function - this is a
mandatory function, which should read the settings from the PCS (it
ought to be renamed - it has its origin in Marvell's NETA controller
which didn't distinguish.)

Without this function, phylink can provoke an oops, particularly when
a SFP module has been inserted.

If you don't want to populate it, just provide a stub function.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
