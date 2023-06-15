Return-Path: <netdev+bounces-10968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB47730DDB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8421C28165E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBDB7639;
	Thu, 15 Jun 2023 04:02:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC72E625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:02:40 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B66F2137
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=TFa/2y42vPdnrt5HKTbpePexHTJHRVp+0npwJc2abgM=; b=V3ABeDfPH+xIUy8xoXoap/cPT7
	39qjo8k3/nXZy8C9KuvWU8pltoi2TOU/WAp7PMql1RSCH2rDwkFvMdj68cLpPOEOkzgPE0wPJs1T8
	mwtLjG3GePSfjIj830q4WSPTDOyNr5WOruxgm7Kb6Gzn5AHfzbl1vLVGdUdGR3RDYUGnexKson1Zw
	y9OLJ+DwKqZW98f3SAA5BS3elYXLJEgU9aEY1EgKD5Z9UDwtHbK35AEsKlf6KsJgICgVUEUsDFFFO
	bODSotqrbCE6j+qG8okVPsCtZHVqi2aS49LwcbYUSCBwYwMxtTjXnDtSSvxV50qzqwYslP1r4iCEZ
	NURNtPog==;
Received: from [2601:1c2:980:9ec0::2764]
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1q9eBv-00DXVD-34;
	Thu, 15 Jun 2023 04:02:35 +0000
Message-ID: <4ebd2741-1788-dc05-2d04-448f3fea17ab@infradead.org>
Date: Wed, 14 Jun 2023 21:02:33 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] eth: fs_enet: fix print format for resource size
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 pantelis.antoniou@gmail.com, linuxppc-dev@lists.ozlabs.org
References: <20230615035231.2184880-1-kuba@kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230615035231.2184880-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/14/23 20:52, Jakub Kicinski wrote:
> Randy forwarded report from Stephen that on PowerPC:

Stephen forwarded report from Randy?

netdev & pantelis were cc-ed...

> drivers/net/ethernet/freescale/fs_enet/mii-fec.c: In function 'fs_enet_mdio_probe':
> drivers/net/ethernet/freescale/fs_enet/mii-fec.c:130:50: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long long unsigned int'} [-Wformat=]
>   130 |         snprintf(new_bus->id, MII_BUS_ID_SIZE, "%x", res.start);
>       |                                                 ~^   ~~~~~~~~~
>       |                                                  |      |
>       |                                                  |      resource_size_t {aka long long unsigned int}
>       |                                                  unsigned int
>       |                                                 %llx
> 
> Use the right print format.
> 
> Untested, I can't repro this warning myself. With or without
> the patch mpc512x_defconfig builds just fine.
> 
> Link: https://lore.kernel.org/all/8f9f8d38-d9c7-9f1b-feb0-103d76902d14@infradead.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: pantelis.antoniou@gmail.com
> CC: linuxppc-dev@lists.ozlabs.org

I'm using gcc-12.2.0.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> 
> Targeting net-next as I can't repro this, and I don't
> see recent changes which could cause this problem.
> So maybe it's something in linux-next... ?
> In any case res is a struct resource so patch shouldn't hurt.
> ---
>  drivers/net/ethernet/freescale/fs_enet/mii-fec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
> index d37d7a19a759..59a8f0bd0f5c 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
> @@ -127,7 +127,7 @@ static int fs_enet_mdio_probe(struct platform_device *ofdev)
>  	if (ret)
>  		goto out_res;
>  
> -	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%x", res.start);
> +	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%pap", &res.start);
>  
>  	fec->fecp = ioremap(res.start, resource_size(&res));
>  	if (!fec->fecp) {

-- 
~Randy

