Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3EDE5F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfD2Ivq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:51:46 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:53386 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727572AbfD2Ivq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 04:51:46 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AC019C0070;
        Mon, 29 Apr 2019 08:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1556527906; bh=wJX6bGWdlKPbsdOdJyT3D6DTbahJBisRdZKY2ByzFdM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=CUKpkuCNXsp8rWOQtRoufEAf+S/ZNN0U47pNC4m1eNnMW5BdVlhndu0OCffNhpOEI
         bmYSrUfNC+FbiMhVcroDIDR3kHdfr1wOlVRXh0idCUJGSygZluE+0uZ4aE7Zur5UK4
         6kloCVJ4ERdI8Txz8JSbduI2ii9LkIK1ZXXc/+nG49aj3kEP7UJefSbsaLVJhC+l8/
         TrSBNVuClq1EZ29Vgp09F5GpSc78fg8CV+RzrlMgv9XCsemtct+/uEqftDEhSO/V/W
         zoAxvGzidAsHkhDWg86FVcWGEUJSHfEwMJahxQNsuJcpNXpcImPP735Vtp+330/qi+
         4vbBZOz5DGALA==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id EE4B8A0091;
        Mon, 29 Apr 2019 08:51:41 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 29 Apr 2019 01:51:42 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Mon,
 29 Apr 2019 10:51:40 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Biao Huang <biao.huang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "yt.shen@mediatek.com" <yt.shen@mediatek.com>,
        "jianguo.zhang@mediatek.com" <jianguo.zhang@mediatek.com>
Subject: RE: [PATCH 1/4] net: stmmac: update rx tail pointer register to fix
 rx dma hang issue.
Thread-Topic: [PATCH 1/4] net: stmmac: update rx tail pointer register to
 fix rx dma hang issue.
Thread-Index: AQHU/lMO5G2GtMH+wUeCSibnjv/EX6ZS1H8A
Date:   Mon, 29 Apr 2019 08:51:39 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B46DDF0@DE02WEMBXB.internal.synopsys.com>
References: <1556518556-32464-1-git-send-email-biao.huang@mediatek.com>
 <1556518556-32464-2-git-send-email-biao.huang@mediatek.com>
In-Reply-To: <1556518556-32464-2-git-send-email-biao.huang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>
Date: Mon, Apr 29, 2019 at 07:15:53

> Currently we will not update the receive descriptor tail pointer in
> stmmac_rx_refill. Rx dma will think no available descriptors and stop
> once received packets exceed DMA_RX_SIZE, so that the rx only test will f=
ail.
>=20
> Update the receive tail pointer in stmmac_rx_refill to add more descripto=
rs
> to the rx channel, so packets can be received continually
>=20
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index 97c5e1a..818ad88 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -3336,6 +3336,9 @@ static inline void stmmac_rx_refill(struct stmmac_p=
riv *priv, u32 queue)
>  		entry =3D STMMAC_GET_ENTRY(entry, DMA_RX_SIZE);
>  	}
>  	rx_q->dirty_rx =3D entry;
> +	stmmac_set_rx_tail_ptr(priv, priv->ioaddr,
> +			       rx_q->dma_rx_phy + (entry * sizeof(struct dma_desc)),

I think you can just use the "rx_q->rx_tail_addr" here. It'll always=20
trigger a poll demand for the channel.

Thanks,
Jose Miguel Abreu
