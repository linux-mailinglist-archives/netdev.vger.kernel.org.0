Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D8A305F3B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhA0POk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhA0POF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:14:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97636C061573;
        Wed, 27 Jan 2021 07:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6F17CTvYIALiq65AoqfJOblrS51pCyVqWNSm9pua6Tk=; b=qvqYWfb4BLt1DvC4i8rL9U65y
        au7cTchIflxjLA/GTBw21/wF2phenfAoclDz0fVjj2huRXpD3ls7iNxKRQqqSCdP/CgcCbgCWAJrt
        6U5FTONCBLZtuxZ699CXcQ0Jm9DQg34qLzozSbgyUz1T+HCrVFdRNFV9TTEjsipTcmdQi5kf8ky8N
        S4z0NiY0utlJYaxWDctvFv/T6CAP5mF212EQkSlhxUliesA+5vnDgaMM4e9WiEII5iRkR8fl2bDNn
        OdDwpmi0eZvtoSEwccvIE2NaI3qKJQMokDaIn4Dox72Lw2rB3wTR6vT53u1y0i6tbF/AypLYJyK0a
        2MwXAZ8wA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53422)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l4mVV-0005c1-8z; Wed, 27 Jan 2021 15:13:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l4mVT-0004vP-RY; Wed, 27 Jan 2021 15:13:19 +0000
Date:   Wed, 27 Jan 2021 15:13:19 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
 firmware check
Message-ID: <20210127151319.GO1551@shell.armlinux.org.uk>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
 <1611747815-1934-20-git-send-email-stefanc@marvell.com>
 <20210127140552.GM1551@shell.armlinux.org.uk>
 <CO6PR18MB3873034EAC12E956E6879967B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210127145955.GN1551@shell.armlinux.org.uk>
 <CO6PR18MB3873983229F0F664A0578A3DB0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873983229F0F664A0578A3DB0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 03:10:11PM +0000, Stefan Chulski wrote:
> You can devmem 0xF2400240(Device ID Status Register).
> #define A8040_B0_DEVICE_ID      0x8045
> #define A8040_AX_DEVICE_ID      0x8040
> #define A7040_B0_DEVICE_ID      0x7045
> #define A7040_AX_DEVICE_ID      0x7040
> #define A3900_A1_DEVICE_ID      0x6025
> #define CN9130_DEVICE_ID        0x7025

Thanks. 0x00028040, so it's AX silicon. Is there nothing that can be
done for flow control on that?

It would probably also be a good idea to state this requirement in the
message as well, rather than just suggesting the firmware revision.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
