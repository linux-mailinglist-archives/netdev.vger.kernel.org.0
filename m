Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6242C0E81
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389361AbgKWPLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731680AbgKWPLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:11:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58512C0613CF;
        Mon, 23 Nov 2020 07:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PMZZSROSJPWNUmLipsds+x4wr12FZn6VKprvQCUEVms=; b=htPboi/h4okOakVohzsKIn+HU
        U0C2YkVCvpkzv9b+2Bn0fK9UZj2WmAEe/3QLIraAEa/UBMpGXxttojzOsxAXZsJ1tQ8Ig+ecFLnk/
        3i2Wfh+Tz/aDipIgFAoy7vdZMWKCZ6VmsOf2KIkCiwBrDAk9HwClnnUK9X1FTPsjPpvE+nXA/LvLz
        r+yBtXvwEIgCN6AtfuPN7ILNQKRt/++aYP4P2YxwGRWbOxCzQMazyzMjGvgtse8R6OwEQA0avHyGV
        wUa4NY5isWKr2CcWyY6+0/yTzrIxrnpO+Vej8LAB8haUxjukYclRRGONi2ZQYqj47rvYr4cSuLuUF
        /IAyWMxuw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35102)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khDUT-00068T-8Z; Mon, 23 Nov 2020 15:10:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khDUP-0006Pw-Kz; Mon, 23 Nov 2020 15:10:49 +0000
Date:   Mon, 23 Nov 2020 15:10:49 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch
Subject: Re: [PATCH v1] net: mvpp2: divide fifo for dts-active ports only
Message-ID: <20201123151049.GV1551@shell.armlinux.org.uk>
References: <1606143160-25589-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606143160-25589-1-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Nov 23, 2020 at 04:52:40PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Tx/Rx FIFO is a HW resource limited by total size, but shared
> by all ports of same CP110 and impacting port-performance.
> Do not divide the FIFO for ports which are not enabled in DTS,
> so active ports could have more FIFO.
> 
> The active port mapping should be done in probe before FIFO-init.

It would be nice to know what the effect is from this - is it a
small or large boost in performance?

What is the effect when the ports on a CP110 are configured for
10G, 1G, and 2.5G in that order, as is the case on the Macchiatobin
board?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
