Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B48380EB6
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 19:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbhENRVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 13:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbhENRVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 13:21:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC03DC061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 10:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iySrnbfW16Rxiwqj/hCwANi8fjAvoHIod8ma2eHQLQU=; b=0/LpkPmwSDZN0ntt7VJuJjdOH
        yjhFxiXnHps3K887jYNo25/cOPa/ci7zOgPxDzkjEJreJszm+ScAkcCPPePJ+hMRmnyzTOX7rTL8f
        2KqFpaTjwxTr1xbGpx/6BeAu2/G1aXPaaNUA5ABIFp0IUzuYpwjq/9AF4q6NLWOqCfH3YBfvmhl73
        N3EuHFilt75q/C910MrpwThxK/CwYrMcUiC9jWfY9Ya+l0pLhP4dEGDRBYu5a+mqVjnZyw418Lm0C
        NDXwjO3/CUDvQmz4Yh8sI59E6ZnuTphWH/ObIYHZRiKdfIjrmF/2kvgpJIPM9rbIXrYS/DMQpNTN8
        ipVPo2BWQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43976)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhbTW-0008VH-LL; Fri, 14 May 2021 18:19:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhbTV-0004Af-Lk; Fri, 14 May 2021 18:19:45 +0100
Date:   Fri, 14 May 2021 18:19:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: mvpp2: incorrect max mtu?
Message-ID: <20210514171945.GF12395@shell.armlinux.org.uk>
References: <20210514130018.GC12395@shell.armlinux.org.uk>
 <CAPv3WKcRpk+7y_TN1dsSE0rS90vTk5opU59i5=4=XP-805axfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKcRpk+7y_TN1dsSE0rS90vTk5opU59i5=4=XP-805axfQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 04:25:48PM +0200, Marcin Wojtas wrote:
> Thank your for the information. I will take a look after the weekend.
> To be aligned - what exactly kernel baseline are you using?

That was with 5.11 with these additional mvpp2 patches:

net: mvpp2: add TX FC firmware check
net: mvpp2: set 802.3x GoP Flow Control mode
net: mvpp2: add PPv23 RX FIFO flow control
net: mvpp2: add BM protection underrun feature support
net: mvpp2: add ethtool flow control configuration support
net: mvpp2: add RXQ flow control configurations
net: mvpp2: enable global flow control
net: mvpp2: add FCA RXQ non occupied descriptor threshold
net: mvpp2: add FCA periodic timer configurations
net: mvpp2: increase BM pool and RXQ size
net: mvpp2: add PPv23 version definition
net: mvpp2: always compare hw-version vs MVPP21
net: mvpp2: add CM3 SRAM memory map
dts: marvell: add CM3 SRAM memory to cp11x ethernet device tree
doc: marvell: add CM3 address space and PPv2.3 description
net: marvell: Fixed two spellings,controling to controlling and oen to one
net: mvpp2: prs: improve ipv4 parse flow

I'll also try to work out what's happening, but I think we need to find
out what the correct value for dev->max_mtu should be. That's all rather
convoluted:

	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;

#define MVPP2_BM_JUMBO_PKT_SIZE MVPP2_RX_MAX_PKT_SIZE(MVPP2_BM_JUMBO_FRAME_SIZE)
#define MVPP2_BM_JUMBO_FRAME_SIZE       10432   /* frame size 9856 */
#define MVPP2_RX_MAX_PKT_SIZE(total_size) \
        ((total_size) - MVPP2_SKB_HEADROOM - MVPP2_SKB_SHINFO_SIZE)

The maximum settable MTU on eth0 (9888) disagrees with the comment
"frame size 9856" by 32 bytes.

I haven't checked to see whether 9856 works yet, because that will
first need me to reboot the machine... which I'll do over the weekend.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
