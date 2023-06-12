Return-Path: <netdev+bounces-9976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F8372B89F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68977281137
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F75D2EE;
	Mon, 12 Jun 2023 07:29:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA175136D
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:29:25 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDA01985;
	Mon, 12 Jun 2023 00:24:24 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 35C7LU7s010928;
	Mon, 12 Jun 2023 02:21:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1686554490;
	bh=nXgYQUTMWJSqVDan5W/Cw3CjNmSlg9Z2AfbOWjOXde4=;
	h=Date:CC:Subject:To:References:From:In-Reply-To;
	b=eMSWLMHfUSrgJYWcfOUIZWv3YHgIpeFPq/xh64jKT9asuA5e5RDKE+880qMp2nIjR
	 S6G7HBq6nxuHNTEV+8YtW5RN1bEp+eNK/uWUi5J5qYqLey83VvMljQ7dpka2Rj4E+K
	 UPRi7nNqFbdnM9/9A5+C5TTpsvuBmJmmHHlS7cAM=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 35C7LUw0012263
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Jun 2023 02:21:30 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 12
 Jun 2023 02:21:30 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 12 Jun 2023 02:21:30 -0500
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 35C7LRmf094823;
	Mon, 12 Jun 2023 02:21:28 -0500
Message-ID: <75c8dba6-cfcc-977d-6e55-7b7c85689f3f@ti.com>
Date: Mon, 12 Jun 2023 12:51:26 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, Roger Quadros <rogerq@kernel.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Call of_node_put() on
 error path
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@linaro.org>
References: <e3012f0c-1621-40e6-bf7d-03c276f6e07f@kili.mountain>
From: Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <e3012f0c-1621-40e6-bf7d-03c276f6e07f@kili.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Hello Dan,

Thank you for the fix.

On 12/06/23 12:48, Dan Carpenter wrote:
> This code returns directly but it should instead call of_node_put()
> to drop some reference counts.
> 
> Fixes: dab2b265dd23 ("net: ethernet: ti: am65-cpsw: Add support for SERDES configuration")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>

> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 11cbcd9e2c72..bebcfd5e6b57 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -2068,7 +2068,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
>  		/* Initialize the Serdes PHY for the port */
>  		ret = am65_cpsw_init_serdes_phy(dev, port_np, port);
>  		if (ret)
> -			return ret;
> +			goto of_node_put;
>  
>  		port->slave.mac_only =
>  				of_property_read_bool(port_np, "ti,mac-only");

-- 
Regards,
Siddharth.

