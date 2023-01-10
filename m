Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E702666476A
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjAJR3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjAJR3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:29:43 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450B318B09
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:29:42 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id dw9so11698777pjb.5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=emWQGeW/C5OIcC0l1LjYUxsng7sswHzCLcGm9B8puB0=;
        b=MkKR3JXF7E+p1eM4aCtzq5DabBlKrTqh64QWgtnPmndnB8uVDzc0zkkP14XA4cCzoP
         5X0FF4POPkNaAreLtKBIGU1HCTeiJ08pGM5nHRuhdfNbgwTJcopSt1Ow7jNHFfByA0ax
         kPcOJDzkHoiVpXLRLsJALwWEn5zjMfTQMd35kdRrd9qvGTlg9ITMm1LjadMw0frW8Z8F
         rwTJItqJdQinsgp788dZYesCDgdNB5UGDfuLoHBx4DWpIMmo3EzqBAeBG0DIjV1S3Bbj
         8H7wiI1h10kdhcfuJBNcmrViTK9b/E7Wps2w4Wsyv1T9633oY0LYOU6UxRLUxn6sItGs
         8Vuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=emWQGeW/C5OIcC0l1LjYUxsng7sswHzCLcGm9B8puB0=;
        b=ZgqjeZZF/MdRYoY4FrgHfGUuZBO+nBVdBcxibqnTps/IKxdf1owfDnsV/6OLo7C+rn
         xU9lruFrkqzMiE8s1jwYXEl42/yhzU5KqcglrFWIg9xbmDsqtXguYNIAiIsMl15FhsbN
         XbtSuPY/Y8UZdojZ6H7kly79w3HeJo6SAi4xWxNlZptJ+6dJVyDzjuJCEYtoABuclaDr
         vbovDK5G84s/thrsnAE9G8nauQRubuAqiWjZR4+6wVSUFoj3M/wHyNYz9xFDg3e/7CNG
         Nl813kRX1lhlgjMqkzZw07zI2ZxCDcdDUGG6kY3H3mo4dX5Odd1xx0GqiYQ4aURaR7FX
         YvXw==
X-Gm-Message-State: AFqh2kqUSkvNAgIAZ1FeolWFMLB9EeKIAsXpgJj/Bjg+oWrAbciTaxPB
        sUMcE4jUpk+0UhrwOQUFeJ4=
X-Google-Smtp-Source: AMrXdXs4iy8YOz5qj9tqT3tcHOfw0GeCEBTZ4uh2DY5Hh7wjiXZXfTS3Ria8tYwVoC1OeeGGLPIQpQ==
X-Received: by 2002:a05:6a20:12ca:b0:ab:e8a7:6137 with SMTP id v10-20020a056a2012ca00b000abe8a76137mr100073268pzg.3.1673371781581;
        Tue, 10 Jan 2023 09:29:41 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id r23-20020a17090b051700b002271f55157bsm3329866pjz.9.2023.01.10.09.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 09:29:41 -0800 (PST)
Message-ID: <464fd490273bf0df9f0725a69aa1c890705d0513.camel@gmail.com>
Subject: Re: [PATCH net-next v4 08/10] tsnep: Add RX queue info for XDP
 support
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Saeed Mahameed <saeed@kernel.org>
Date:   Tue, 10 Jan 2023 09:29:39 -0800
In-Reply-To: <20230109191523.12070-9-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
         <20230109191523.12070-9-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> Register xdp_rxq_info with page_pool memory model. This is needed for
> XDP buffer handling.
>=20
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |  2 ++
>  drivers/net/ethernet/engleder/tsnep_main.c | 39 ++++++++++++++++------
>  2 files changed, 31 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet=
/engleder/tsnep.h
> index 855738d31d73..2268ff793edf 100644
> --- a/drivers/net/ethernet/engleder/tsnep.h
> +++ b/drivers/net/ethernet/engleder/tsnep.h
> @@ -134,6 +134,8 @@ struct tsnep_rx {
>  	u32 dropped;
>  	u32 multicast;
>  	u32 alloc_failed;
> +
> +	struct xdp_rxq_info xdp_rxq;
>  };
> =20

Rather than placing it in your Rx queue structure it might be better to
look at placing it in the tsnep_queue struct. The fact is this is more
closely associated with the napi struct then your Rx ring so changing
it to that might make more sense as you can avoid a bunch of extra
overhead with having to pull napi to it.

Basically what it comes down it is that it is much easier to access
queue[i].rx than it is for the rx to get access to queue[i].napi.

>  struct tsnep_queue {
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/eth=
ernet/engleder/tsnep_main.c
> index 0c9669edb2dd..451ad1849b9d 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -792,6 +792,9 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx=
)
>  		entry->page =3D NULL;
>  	}
> =20
> +	if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
> +		xdp_rxq_info_unreg(&rx->xdp_rxq);
> +
>  	if (rx->page_pool)
>  		page_pool_destroy(rx->page_pool);
> =20
> @@ -807,7 +810,7 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx=
)
>  	}
>  }
> =20
> -static int tsnep_rx_ring_init(struct tsnep_rx *rx)
> +static int tsnep_rx_ring_init(struct tsnep_rx *rx, unsigned int napi_id)
>  {
>  	struct device *dmadev =3D rx->adapter->dmadev;
>  	struct tsnep_rx_entry *entry;
> @@ -850,6 +853,15 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
>  		goto failed;
>  	}
> =20
> +	retval =3D xdp_rxq_info_reg(&rx->xdp_rxq, rx->adapter->netdev,
> +				  rx->queue_index, napi_id);
> +	if (retval)
> +		goto failed;
> +	retval =3D xdp_rxq_info_reg_mem_model(&rx->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					    rx->page_pool);
> +	if (retval)
> +		goto failed;
> +
>  	for (i =3D 0; i < TSNEP_RING_SIZE; i++) {
>  		entry =3D &rx->entry[i];
>  		next_entry =3D &rx->entry[(i + 1) % TSNEP_RING_SIZE];
> @@ -1104,7 +1116,8 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
>  }
> =20
>  static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *ad=
dr,
> -			 int queue_index, struct tsnep_rx *rx)
> +			 unsigned int napi_id, int queue_index,
> +			 struct tsnep_rx *rx)
>  {
>  	dma_addr_t dma;
>  	int retval;
> @@ -1118,7 +1131,7 @@ static int tsnep_rx_open(struct tsnep_adapter *adap=
ter, void __iomem *addr,
>  	else
>  		rx->offset =3D TSNEP_SKB_PAD;
> =20
> -	retval =3D tsnep_rx_ring_init(rx);
> +	retval =3D tsnep_rx_ring_init(rx, napi_id);
>  	if (retval)
>  		return retval;
> =20
> @@ -1245,14 +1258,19 @@ static void tsnep_free_irq(struct tsnep_queue *qu=
eue, bool first)
>  static int tsnep_netdev_open(struct net_device *netdev)
>  {
>  	struct tsnep_adapter *adapter =3D netdev_priv(netdev);
> -	int i;
> -	void __iomem *addr;
>  	int tx_queue_index =3D 0;
>  	int rx_queue_index =3D 0;
> -	int retval;
> +	unsigned int napi_id;
> +	void __iomem *addr;
> +	int i, retval;
> =20
>  	for (i =3D 0; i < adapter->num_queues; i++) {
>  		adapter->queue[i].adapter =3D adapter;
> +
> +		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
> +			       tsnep_poll);
> +		napi_id =3D adapter->queue[i].napi.napi_id;
> +

This is a good example of what I am referring to.

>  		if (adapter->queue[i].tx) {
>  			addr =3D adapter->addr + TSNEP_QUEUE(tx_queue_index);
>  			retval =3D tsnep_tx_open(adapter, addr, tx_queue_index,
> @@ -1263,7 +1281,7 @@ static int tsnep_netdev_open(struct net_device *net=
dev)
>  		}
>  		if (adapter->queue[i].rx) {
>  			addr =3D adapter->addr + TSNEP_QUEUE(rx_queue_index);
> -			retval =3D tsnep_rx_open(adapter, addr,
> +			retval =3D tsnep_rx_open(adapter, addr, napi_id,
>  					       rx_queue_index,
>  					       adapter->queue[i].rx);
>  			if (retval)
> @@ -1295,8 +1313,6 @@ static int tsnep_netdev_open(struct net_device *net=
dev)
>  		goto phy_failed;
> =20
>  	for (i =3D 0; i < adapter->num_queues; i++) {
> -		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
> -			       tsnep_poll);
>  		napi_enable(&adapter->queue[i].napi);
> =20
>  		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);

What you could do here is look at making all the napi_add/napi_enable
and xdp_rxq_info items into one function to handle all the enabling.

> @@ -1317,6 +1333,8 @@ static int tsnep_netdev_open(struct net_device *net=
dev)
>  			tsnep_rx_close(adapter->queue[i].rx);
>  		if (adapter->queue[i].tx)
>  			tsnep_tx_close(adapter->queue[i].tx);
> +
> +		netif_napi_del(&adapter->queue[i].napi);
>  	}
>  	return retval;
>  }
> @@ -1335,7 +1353,6 @@ static int tsnep_netdev_close(struct net_device *ne=
tdev)
>  		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
> =20
>  		napi_disable(&adapter->queue[i].napi);
> -		netif_napi_del(&adapter->queue[i].napi);
> =20
>  		tsnep_free_irq(&adapter->queue[i], i =3D=3D 0);
> =20

Likewise here you could take care of all the same items with the page
pool being freed after you have already unregistered and freed the napi
instance.

> @@ -1343,6 +1360,8 @@ static int tsnep_netdev_close(struct net_device *ne=
tdev)
>  			tsnep_rx_close(adapter->queue[i].rx);
>  		if (adapter->queue[i].tx)
>  			tsnep_tx_close(adapter->queue[i].tx);
> +
> +		netif_napi_del(&adapter->queue[i].napi);
>  	}
> =20
>  	return 0;

