Return-Path: <netdev+bounces-2932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C575704996
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08DB81C20D74
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24C8168DB;
	Tue, 16 May 2023 09:44:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D092C726
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:44:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271BD1BC6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684230241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BWABmS2IQIZ2oxrjaFNnZzqN6v2DzCIktkUL3HnxD28=;
	b=D+eJ9KxjoxIL1sGYLaYJDzzayaousxEfl1Kf+6Y/D9NekvEC4E6F3IPRmX/VqiOKT+IGqQ
	gBXUYLoVELcG4330yJtPFjZ73qLnWgAlNUOxPysK0ZZKlWIXBqrRjjOOmkxY4mtHsTs/xr
	U/2r+Cd2Ythq7NLBxsH10wjHFP7Bnwg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-QpX3OqTkOECUc3dOod-zDA-1; Tue, 16 May 2023 05:43:59 -0400
X-MC-Unique: QpX3OqTkOECUc3dOod-zDA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f508671d98so3286255e9.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684230239; x=1686822239;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BWABmS2IQIZ2oxrjaFNnZzqN6v2DzCIktkUL3HnxD28=;
        b=jDdB9AWRs9zbigK0NN9lIWIhepiLFRz+V2Fft9UZTjQQXYExcyYJLLNgbn3R6MjgYO
         O5Pj00Kz/hw9CNlHi+f+a4ckXnO/LNBOpWizZghboWvE6TvDv3HAInnhcvpnR7/UxtTs
         PZksERZbMoshd7EiXdEypX9vq247pO4Rweu4DADKZhFIMj+y/b9XlytbWIjshLyL2CxX
         Wy+Fjt1siQYLusYAJW2ZC8AdSEeIByxgNkJUyR09oRddVzoAz1CVVul7VoAsN/zzwxqj
         a8IpoVjETa9u6P5nHEksORG1/u/X01EwN0Yp/SFdbRXqD5r5VK6Ojrkc9VXijzLXhElk
         VBPg==
X-Gm-Message-State: AC+VfDxbjPPjksvMM1HNp7Br5LqxF9+jEdbvb5fDUvosP2DJaBLuOFra
	eUEcCKoGXv7pEgVhpGQaNsA6btpDJP4a2AoCyf9ZaE0hehCH65wt++3W8iVUAeSGxBuxRYvIi17
	rNqXowWtPOy7E5/Q3
X-Received: by 2002:adf:ef11:0:b0:2f8:15d8:e627 with SMTP id e17-20020adfef11000000b002f815d8e627mr6852499wro.7.1684230238745;
        Tue, 16 May 2023 02:43:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5NthFFroAzAzAUa7dBHlFq1R6kEs+wLRCm00B5ENU53gPX1nrMkq3nAAd6O62R6qFIw7fmOw==
X-Received: by 2002:adf:ef11:0:b0:2f8:15d8:e627 with SMTP id e17-20020adfef11000000b002f815d8e627mr6852490wro.7.1684230238328;
        Tue, 16 May 2023 02:43:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-74.dyn.eolo.it. [146.241.225.74])
        by smtp.gmail.com with ESMTPSA id d3-20020adff2c3000000b0030629536e64sm1982144wrp.30.2023.05.16.02.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:43:57 -0700 (PDT)
Message-ID: <0cdb0dce62fcee7e840a89639b5ace525a151298.camel@redhat.com>
Subject: Re: [PATCH net-next v8 9/9] net: txgbe: Support phylink MAC layer
From: Paolo Abeni <pabeni@redhat.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org, 
 jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com, 
 mika.westerberg@linux.intel.com, jsd@semihalf.com, Jose.Abreu@synopsys.com,
  andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc: linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org, 
	mengyuanlou@net-swift.com
Date: Tue, 16 May 2023 11:43:56 +0200
In-Reply-To: <20230515063200.301026-10-jiawenwu@trustnetic.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
	 <20230515063200.301026-10-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-15 at 14:32 +0800, Jiawen Wu wrote:
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/ne=
t/ethernet/wangxun/txgbe/txgbe_main.c
> index ded04e9e136f..bdf735e863eb 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> @@ -7,6 +7,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/string.h>
>  #include <linux/etherdevice.h>
> +#include <linux/phylink.h>
>  #include <net/ip.h>
>  #include <linux/if_vlan.h>
> =20
> @@ -204,7 +205,8 @@ static int txgbe_request_irq(struct wx *wx)
> =20
>  static void txgbe_up_complete(struct wx *wx)
>  {
> -	u32 reg;
> +	struct net_device *netdev =3D wx->netdev;
> +	struct txgbe *txgbe =3D netdev_to_txgbe(netdev);

Please respect the reverse x-mass tree order. Either avoid 'netdev'
declaration or split txgbe declaration and assignment.

> =20
>  	wx_control_hw(wx, true);
>  	wx_configure_vectors(wx);
> @@ -213,24 +215,16 @@ static void txgbe_up_complete(struct wx *wx)
>  	smp_mb__before_atomic();
>  	wx_napi_enable_all(wx);
> =20
> +	phylink_start(txgbe->phylink);
> +
>  	/* clear any pending interrupts, may auto mask */
>  	rd32(wx, WX_PX_IC(0));
>  	rd32(wx, WX_PX_IC(1));
>  	rd32(wx, WX_PX_MISC_IC);
>  	txgbe_irq_enable(wx, true);
> =20
> -	/* Configure MAC Rx and Tx when link is up */
> -	reg =3D rd32(wx, WX_MAC_RX_CFG);
> -	wr32(wx, WX_MAC_RX_CFG, reg);
> -	wr32(wx, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
> -	reg =3D rd32(wx, WX_MAC_WDG_TIMEOUT);
> -	wr32(wx, WX_MAC_WDG_TIMEOUT, reg);
> -	reg =3D rd32(wx, WX_MAC_TX_CFG);
> -	wr32(wx, WX_MAC_TX_CFG, (reg & ~WX_MAC_TX_CFG_SPEED_MASK) | WX_MAC_TX_C=
FG_SPEED_10G);
> -
>  	/* enable transmits */
> -	netif_tx_start_all_queues(wx->netdev);
> -	netif_carrier_on(wx->netdev);
> +	netif_tx_start_all_queues(netdev);
>  }
> =20
>  static void txgbe_reset(struct wx *wx)
> @@ -264,7 +258,6 @@ static void txgbe_disable_device(struct wx *wx)
>  		wx_disable_rx_queue(wx, wx->rx_ring[i]);
> =20
>  	netif_tx_stop_all_queues(netdev);
> -	netif_carrier_off(netdev);
>  	netif_tx_disable(netdev);
> =20
>  	wx_irq_disable(wx);
> @@ -295,8 +288,12 @@ static void txgbe_disable_device(struct wx *wx)
> =20
>  static void txgbe_down(struct wx *wx)
>  {
> +	struct net_device *netdev =3D wx->netdev;
> +	struct txgbe *txgbe =3D netdev_to_txgbe(netdev);

You can replace the above 2 lines with:

	struct txgbe *txgbe =3D netdev_to_txgbe(wx->netdev);


Cheers,

Paolo


