Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77EB42BD02
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfE1BxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:53:02 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:2188 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727651AbfE1BxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 21:53:02 -0400
X-UUID: fd636dd8cdae44f3a0da8defedf6958d-20190528
X-UUID: fd636dd8cdae44f3a0da8defedf6958d-20190528
Received: from mtkcas36.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 97317882; Tue, 28 May 2019 09:52:51 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31N1.mediatek.inc
 (172.27.4.69) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 28 May
 2019 09:52:50 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 28 May 2019 09:52:49 +0800
Message-ID: <1559008369.24897.66.camel@mhfsdcap03>
Subject: Re: [v3, PATCH] net: stmmac: add support for hash table size
 128/256 in dwmac4
From:   biao huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>
CC:     <joabreu@synopsys.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <mcoquelin.stm32@gmail.com>,
        <matthias.bgg@gmail.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <jianguo.zhang@mediatek.com>, <boon.leong.ong@intel.com>
Date:   Tue, 28 May 2019 09:52:49 +0800
In-Reply-To: <20190527.100800.1719164073038257292.davem@davemloft.net>
References: <1558926867-16472-1-git-send-email-biao.huang@mediatek.com>
         <1558926867-16472-2-git-send-email-biao.huang@mediatek.com>
         <20190527.100800.1719164073038257292.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear David,

On Mon, 2019-05-27 at 10:08 -0700, David Miller wrote:
> From: Biao Huang <biao.huang@mediatek.com>
> Date: Mon, 27 May 2019 11:14:27 +0800
> 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> > index 5e98da4..029a3db 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> > @@ -403,41 +403,50 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
> >  			      struct net_device *dev)
> >  {
> >  	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
> > -	unsigned int value = 0;
> > +	unsigned int value;
> > +	int numhashregs = (hw->multicast_filter_bins >> 5);
> > +	int mcbitslog2 = hw->mcast_bits_log2;
> > +	int i;
> 
> Please retain the reverse christmas tree ordering here.
I'm a little confused about the reverse xmas tree ordering.

should I reorder them only according to the total length like this:

	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
	int numhashregs = (hw->multicast_filter_bins >> 5);
	int mcbitslog2 = hw->mcast_bits_log2;
	unsigned int value;
	int i;

or should I gather the same type together, and order types as reverse
xmas tree, then order the same type definitions as reverse xmas tree,
like this:

	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
	unsigned int value;
	int numhashregs = (hw->multicast_filter_bins >> 5);
	int mcbitslog2 = hw->mcast_bits_log2;
	int i;

Thank you.
> 
> Thank you.


