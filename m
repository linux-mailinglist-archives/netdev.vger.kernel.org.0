Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B04F3FBC6F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbhH3SbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhH3SbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 14:31:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2496560E98;
        Mon, 30 Aug 2021 18:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630348221;
        bh=iGr981xcSnijXF8G9kE3OksIBLXLhE2eR5tL5v52HjI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l1ZiIQeR7nvunSoOQ4SXApPYwqDnc72r9/FdvCmYTj7KFqgjQGKoe0nBXqP/7wrJm
         T2vR9JOyUYu1yWPVpBq43A87FDgWNr4Qs/o57VMVl5qiFcn8fiDk9+3rvA1XkJ5oNa
         qbyOmTewCYKeZ6nRrbPoQ1E1xticbSXc5o1/zWlRx9s8WYfiF1olW9oITP5RBsBPbo
         Lpf7Z8nSDSP9WeOFPE7R6x+TxxT5E+98jOi+OewB2hWeJBQbPfleuHzD3YqPtpseE+
         OUi/llEcmM03U3WsuCagLGEm7T3Y2IzFmis9g4HU08aFmT6rCzDd6cX6lzAuuwIf6I
         8YMkhETsaUg6Q==
Date:   Mon, 30 Aug 2021 11:30:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qing Zhang <zhangqing@loongson.cn>
Cc:     zhaoxiao <zhaoxiao@uniontech.com>, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stmmac: dwmac-loongson:add the return value
Message-ID: <20210830113020.3ea992a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830052913.12793-1-zhaoxiao@uniontech.com>
References: <20210830052913.12793-1-zhaoxiao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 13:29:13 +0800 zhaoxiao wrote:
> Add the return value when phy_mode < 0.
> 
> Signed-off-by: zhaoxiao <zhaoxiao@uniontech.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> index 4c9a37dd0d3f..ecf759ee1c9f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> @@ -109,8 +109,10 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
>  		plat->bus_id = pci_dev_id(pdev);
>  
>  	phy_mode = device_get_phy_mode(&pdev->dev);
> -	if (phy_mode < 0)
> +	if (phy_mode < 0) {
>  		dev_err(&pdev->dev, "phy_mode not found\n");
> +		return phy_mode;
> +	}
>  
>  	plat->phy_interface = phy_mode;
>  	plat->interface = PHY_INTERFACE_MODE_GMII;

Qing Zhang, does the change look correct to you?

Is it better to assume GMII and continue like the code is currently
doing?
