Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547272E3FC
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfE2SAj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 May 2019 14:00:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:2701 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfE2SAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:00:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:00:38 -0700
X-ExtLoop1: 1
Received: from pgsmsx111.gar.corp.intel.com ([10.108.55.200])
  by fmsmga001.fm.intel.com with ESMTP; 29 May 2019 11:00:35 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.93]) by
 PGSMSX111.gar.corp.intel.com ([169.254.2.3]) with mapi id 14.03.0415.000;
 Thu, 30 May 2019 02:00:35 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH net-next v4 5/5] net: stmmac: add EHL SGMII 1Gbps PCI
 info and PCI ID
Thread-Topic: [PATCH net-next v4 5/5] net: stmmac: add EHL SGMII 1Gbps PCI
 info and PCI ID
Thread-Index: AQHVFfyuR7ayxWr7LkCDJUhVgZwmvaaBYH8AgAD+qXA=
Date:   Wed, 29 May 2019 18:00:34 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814707D4C@PGSMSX103.gar.corp.intel.com>
References: <1559149107-14631-1-git-send-email-weifeng.voon@intel.com>
 <1559149107-14631-6-git-send-email-weifeng.voon@intel.com>
 <78EB27739596EE489E55E81C33FEC33A0B933497@DE02WEMBXB.internal.synopsys.com>
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B933497@DE02WEMBXB.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> > +	plat->axi->axi_lpi_en = 0;
> > +	plat->axi->axi_xit_frm = 0;
> > +	plat->axi->axi_wr_osr_lmt = 0;
> 
> This is not a valid value.

Can you please explained why is not a valid value? And what should
be the recommended value? 
Databook mentioned that "Maximum outstanding requests =
WR_OSR_LMT + 1"

> 
> > +	plat->axi->axi_rd_osr_lmt = 2;
> > +	plat->axi->axi_blen[0] = 4;
> > +	plat->axi->axi_blen[1] = 8;
> > +	plat->axi->axi_blen[2] = 16;
> > +
> > +	/* Set default value for multicast hash bins */
> > +	plat->multicast_filter_bins = HASH_TABLE_SIZE;
> > +
> > +	/* Set default value for unicast filter entries */
> > +	plat->unicast_filter_entries = 1;
> > +
> > +	/* Set the maxmtu to a default of JUMBO_LEN */
> > +	plat->maxmtu = JUMBO_LEN;
> > +
> > +	/* Set 32KB fifo size as the advertised fifo size in
> > +	 * the HW features is not the same as the HW implementation
> > +	 */
> 
> Hmm ? I'm curious, can you explain ?

The RTL comes with a 64KB selection in HW features. But the HW implementation
only uses a 32KB RAM. This will be documented as errata.  

> 
> > +	plat->tx_fifo_size = 32768;
> > +	plat->rx_fifo_size = 32768;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ehl_sgmii1g_data(struct pci_dev *pdev,
> > +			    struct plat_stmmacenet_data *plat) {
> > +	int ret;
> > +
> > +	/* Set common default data first */
> > +	ret = ehl_common_data(pdev, plat);
> > +
> 

Regards
Weifeng
