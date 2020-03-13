Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73917184FDE
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 21:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgCMUEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 16:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgCMUEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 16:04:41 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43E55206E9;
        Fri, 13 Mar 2020 20:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584129880;
        bh=gRupmyo00Wss0GIjIjppM9vlDUc8QcO3JGaB5bZDcw0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wySOpkgqxbQJD5g6KiD7Zg9QaqgMlV9nM//LIsKidQZPlSi35BhoWmnPJoYTDf+w2
         tQfgbmd7Vtz0ji8O10i8+9uumn1r44l5hDq8yHiPBYyPJozrmY+Wo9KkTlD+ZzOH2r
         6zG3luklOjIkQ3hsJwDIgKN+uluqbVvNazS5Mjog=
Date:   Fri, 13 Mar 2020 13:04:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v3 05/10] net: ethernet: ti: introduce
 am65x/j721e gigabit eth subsystem driver
Message-ID: <20200313130438.73d9a56c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200313175511.2155-6-grygorii.strashko@ti.com>
References: <20200313175511.2155-1-grygorii.strashko@ti.com>
        <20200313175511.2155-6-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Mar 2020 19:55:06 +0200 Grygorii Strashko wrote:
> +static void am65_cpsw_nuss_free_tx_chns(void *data)
> +{
> +	struct am65_cpsw_common *common = data;
> +	int i;
> +
> +	for (i = 0; i < common->tx_ch_num; i++) {
> +		struct am65_cpsw_tx_chn	*tx_chn = &common->tx_chns[i];

nit: stray tab?

> +
> +		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
> +			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
> +
> +		if (!IS_ERR_OR_NULL(tx_chn->desc_pool))
> +			k3_udma_desc_pool_destroy(tx_chn->desc_pool);
> +
> +		memset(tx_chn, 0, sizeof(*tx_chn));
> +	};

nit: you also got some stray semicolons in a few places

Thanks for the changes, looks better. Hopefully someone who knows 
the HW better can have a look as well.

