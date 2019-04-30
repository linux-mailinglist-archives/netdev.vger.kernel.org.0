Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE2FE45
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 19:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfD3Q74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 12:59:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbfD3Q74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 12:59:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DpyzH6C7CDzVv5rpAbyNDaHnn+kRSb3nqDne+G2smGk=; b=zrsmprsfOsmr3PVItgVW65jyC+
        w94doDuf92Q955drappbRDqSk2RC3NVZHRX9L+6cSVatkujdMCpfQQGhEDZ0UvFeVH+l6moueXPEo
        wLZLCJrXhuP7Prm1kzSDUF9Q2JnRo71EXhS2iWB5L3FN4k64wUTdWgKP6XQl0vcxxxNg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLW6O-0001v8-07; Tue, 30 Apr 2019 18:59:32 +0200
Date:   Tue, 30 Apr 2019 18:59:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Esben Haabendal <esben@geanix.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/12] net: ll_temac: Support indirect_mutex share
 within TEMAC IP
Message-ID: <20190430165931.GC30817@lunn.ch>
References: <20190429083422.4356-1-esben@geanix.com>
 <20190430071759.2481-1-esben@geanix.com>
 <20190430071759.2481-8-esben@geanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430071759.2481-8-esben@geanix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 09:17:54AM +0200, Esben Haabendal wrote:
> Indirect register access goes through a DCR bus bridge, which
> allows only one outstanding transaction.  And to make matters
> worse, each TEMAC IP block contains two Ethernet interfaces, and
> although they seem to have separate registers for indirect access,
> they actually share the registers.  Or to be more specific, MSW, LSW
> and CTL registers are physically shared between Ethernet interfaces
> in same TEMAC IP, with RDY register being (almost) specificic to
> the Ethernet interface.  The 0x10000 bit in RDY reflects combined
> bus ready state though.
> 
> So we need to take care to synchronize not only within a single
> device, but also between devices in same TEMAC IP.
> 
> This commit allows to do that with legacy platform devices.
> 
> For OF devices, the xlnx,compound parent of the temac node should be
> used to find siblings, and setup a shared indirect_mutex between them.
> I will leave this work to somebody else, as I don't have hardware to
> test that.  No regression is introduced by that, as before this commit
> using two Ethernet interfaces in same TEMAC block is simply broken.
> 
> Signed-off-by: Esben Haabendal <esben@geanix.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
