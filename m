Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C7C56EDC
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfFZQdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:33:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37580 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfFZQdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:33:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB29414B5B882;
        Wed, 26 Jun 2019 09:33:18 -0700 (PDT)
Date:   Wed, 26 Jun 2019 09:33:18 -0700 (PDT)
Message-Id: <20190626.093318.2241574529231651608.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com
Subject: Re: [PATCH net-next 01/10] net: stmmac: dwxgmac: Enable EDMA by
 default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6df599b8c2d57db9d82e42861ce897d7cf003424.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
        <cover.1561556555.git.joabreu@synopsys.com>
        <6df599b8c2d57db9d82e42861ce897d7cf003424.1561556555.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 09:33:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Wed, 26 Jun 2019 15:47:35 +0200

> @@ -122,6 +122,8 @@ static void dwxgmac2_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
>  	}
>  
>  	writel(value, ioaddr + XGMAC_DMA_SYSBUS_MODE);
> +	writel(GENMASK(29, 0), ioaddr + XGMAC_TX_EDMA_CTRL);
> +	writel(GENMASK(29, 0), ioaddr + XGMAC_RX_EDMA_CTRL);
>  }

This mask is magic and there is no indication what the bits mean and
in particular what it means to set bits 0 -- 29

You have to document what these bits mean and thus what these register
writes actually do.
