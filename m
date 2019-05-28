Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FE92CC46
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfE1Qka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:40:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35992 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfE1Qka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 12:40:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5O70O6OB10YmWngTAKAkcQIdQ8sIfTqZZD+NK309vZU=; b=XDQ9N9RTp0puDZabOwzrob//Kv
        y5oy66ii5xp4F7st5YdpcGsQfHk49y6kt4E3Nzy9SeaASuX4lI0LHIfxYYfomjcKTlLGyWF2elUYj
        DESlvmLxyQMfXIHDIaQ9P/Wb7VkStdDsD43MTeQEvS5DmeCYX7npfkM0NZCBD5mlRUME=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVf99-0000Gw-95; Tue, 28 May 2019 18:40:19 +0200
Date:   Tue, 28 May 2019 18:40:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     biao huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>, jianguo.zhang@mediatek.com,
        alexandre.torgue@st.com, boon.leong.ong@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yt.shen@mediatek.com, joabreu@synopsys.com,
        linux-mediatek@lists.infradead.org, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com, peppe.cavallaro@st.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [v3, PATCH] net: stmmac: add support for hash table size 128/256
 in dwmac4
Message-ID: <20190528164019.GR18059@lunn.ch>
References: <1558926867-16472-1-git-send-email-biao.huang@mediatek.com>
 <1558926867-16472-2-git-send-email-biao.huang@mediatek.com>
 <20190527.100800.1719164073038257292.davem@davemloft.net>
 <1559008369.24897.66.camel@mhfsdcap03>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559008369.24897.66.camel@mhfsdcap03>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 09:52:49AM +0800, biao huang wrote:
> Dear David,
> 
> On Mon, 2019-05-27 at 10:08 -0700, David Miller wrote:
> > From: Biao Huang <biao.huang@mediatek.com>
> > Date: Mon, 27 May 2019 11:14:27 +0800
> > 
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> > > index 5e98da4..029a3db 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> > > @@ -403,41 +403,50 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
> > >  			      struct net_device *dev)
> > >  {
> > >  	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
> > > -	unsigned int value = 0;
> > > +	unsigned int value;
> > > +	int numhashregs = (hw->multicast_filter_bins >> 5);
> > > +	int mcbitslog2 = hw->mcast_bits_log2;
> > > +	int i;
> > 
> > Please retain the reverse christmas tree ordering here.
> I'm a little confused about the reverse xmas tree ordering.
> 
> should I reorder them only according to the total length like this:
> 
> 	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
> 	int numhashregs = (hw->multicast_filter_bins >> 5);
> 	int mcbitslog2 = hw->mcast_bits_log2;
> 	unsigned int value;
> 	int i;

Yes.
	Andrew
