Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873C8667A96
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 17:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjALQTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 11:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjALQS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 11:18:28 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270F765C6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 08:15:23 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d15so20705338pls.6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 08:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ewrO05Bhb3jX6FL0/VYkNt5jbh/e+ff7P/mH2A7OGB8=;
        b=OHBjWfD89uoN2JkksSkNvWqFQDeUnwVUh91N1KXnIj4sY+axbXBnPCMz4gDiE5G1fN
         l9f3IeoW5XbdFFLY2I2nyRNZcGsjzXET6pJVi+HMIrKCuiPhDonWzl6dOocDXTZDgIjM
         IYEX8KWsmJRkReqv7J/GEp3Z7ccLfjGMEE9H/JrNTqtFzYcTVYLB1crtXjWcLHjKWd3T
         PkDcRl1i9WeGVEqu9Z2Qlod7CLQkHMnWSK/tdMeXKlB5nRJClP5meOwH7Rouwq3kvhhN
         MxF2CjdQ3k3UEkz57D626/BijcUbQs/URbnYtwZ500B18fYK7F23Ir4P8xDhxGoJsS0H
         vuSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ewrO05Bhb3jX6FL0/VYkNt5jbh/e+ff7P/mH2A7OGB8=;
        b=zb38Vtc+ljtEK/UefeQNJhH6/WIjWWixnLSH4dmbvgeK7TtlU/CzHS0R7h9pfkio7M
         atbsH2SCQbiqVKbCLk8brcLaRKF6Dds2RQVxt2cKWLhwEhsynHTYyLlEHiOxeJtj3pa2
         tfSwsX4rj3/66CT451Gne1ZRxj4dXJ3gop7wMJAoaMjig7y1pQUHYDaH8Xao5MdH1xvV
         dvajjgNmE3oLQRqmimSmx95go4I6eMWLt/kvhdKy1LgL3jsZGfmZUexYGPVzUh5ZJa9V
         ixzudsjHzyp5hwq4b+4PXhpiEu+C8kk56xgAwpSXX3fqSFIaKsASOZni6duuDqNQvffF
         Yf2Q==
X-Gm-Message-State: AFqh2kr5YH+yTdypOs8MF6tfjXd9+YJ+YwOsSLUwoHf0uDa/iUm/as3s
        g7GtFnX1PDS9DpwFaEbc3LY=
X-Google-Smtp-Source: AMrXdXu5HNuDFsZYFvnqdV59TAtd53aHig90HFUWGWnegNacldGM8pD7LdbM48zPkXM282lru/63kA==
X-Received: by 2002:a05:6a21:3284:b0:ad:4a3e:a6e1 with SMTP id yt4-20020a056a21328400b000ad4a3ea6e1mr118490538pzb.11.1673540122508;
        Thu, 12 Jan 2023 08:15:22 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id c4-20020a631c04000000b004774b5dc24dsm10181856pgc.12.2023.01.12.08.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 08:15:22 -0800 (PST)
Message-ID: <02cfb1dd78f6efb1ae3077de24fa357091168d39.camel@gmail.com>
Subject: Re: [PATCH v5 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Date:   Thu, 12 Jan 2023 08:15:20 -0800
In-Reply-To: <0a22f0c81e87fde34e3444e1bc83012a17498e8e.1673457624.git.lorenzo@kernel.org>
References: <cover.1673457624.git.lorenzo@kernel.org>
         <0a22f0c81e87fde34e3444e1bc83012a17498e8e.1673457624.git.lorenzo@kernel.org>
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

On Wed, 2023-01-11 at 18:22 +0100, Lorenzo Bianconi wrote:
> Introduce reset and reset_complete wlan callback to schedule WLAN driver
> reset when ethernet/wed driver is resetting.
>=20
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  7 ++++
>  drivers/net/ethernet/mediatek/mtk_wed.c     | 40 +++++++++++++++++++++
>  drivers/net/ethernet/mediatek/mtk_wed.h     |  8 +++++
>  include/linux/soc/mediatek/mtk_wed.h        |  2 ++
>  4 files changed, 57 insertions(+)
>=20

Do we have any updates on the implementation that would be making use
of this? It looks like there was a discussion for the v2 of this set to
include a link to an RFC posting that would make use of this set.

> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/et=
hernet/mediatek/mtk_eth_soc.c
> index 1af74e9a6cd3..0147e98009c2 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -3924,6 +3924,11 @@ static void mtk_pending_work(struct work_struct *w=
ork)
>  	set_bit(MTK_RESETTING, &eth->state);
> =20
>  	mtk_prepare_for_reset(eth);
> +	mtk_wed_fe_reset();
> +	/* Run again reset preliminary configuration in order to avoid any
> +	 * possible race during FE reset since it can run releasing RTNL lock.
> +	 */
> +	mtk_prepare_for_reset(eth);
> =20
>  	/* stop all devices to make sure that dma is properly shut down */
>  	for (i =3D 0; i < MTK_MAC_COUNT; i++) {
> @@ -3961,6 +3966,8 @@ static void mtk_pending_work(struct work_struct *wo=
rk)
> =20
>  	clear_bit(MTK_RESETTING, &eth->state);
> =20
> +	mtk_wed_fe_reset_complete();
> +
>  	rtnl_unlock();
>  }
> =20
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethern=
et/mediatek/mtk_wed.c
> index a6271449617f..4854993f2941 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> @@ -206,6 +206,46 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
>  	iounmap(reg);
>  }
> =20
> +void mtk_wed_fe_reset(void)
> +{
> +	int i;
> +
> +	mutex_lock(&hw_lock);
> +
> +	for (i =3D 0; i < ARRAY_SIZE(hw_list); i++) {
> +		struct mtk_wed_hw *hw =3D hw_list[i];
> +		struct mtk_wed_device *dev =3D hw->wed_dev;
> +
> +		if (!dev || !dev->wlan.reset)
> +			continue;
> +
> +		/* reset callback blocks until WLAN reset is completed */
> +		if (dev->wlan.reset(dev))
> +			dev_err(dev->dev, "wlan reset failed\n");

The reason why having the consumer would be useful are cases like this.
My main concern is if the error value might be useful to actually
expose rather than just treating it as a boolean. Usually for things
like this I prefer to see the result captured and if it indicates error
we return the error value since this could be one of several possible
causes for the error assuming this returns an int and not a bool.

> +	}
> +
> +	mutex_unlock(&hw_lock);
> +}
> +
> +void mtk_wed_fe_reset_complete(void)
> +{
> +	int i;
> +
> +	mutex_lock(&hw_lock);
> +
> +	for (i =3D 0; i < ARRAY_SIZE(hw_list); i++) {
> +		struct mtk_wed_hw *hw =3D hw_list[i];
> +		struct mtk_wed_device *dev =3D hw->wed_dev;
> +
> +		if (!dev || !dev->wlan.reset_complete)
> +			continue;
> +
> +		dev->wlan.reset_complete(dev);
> +	}
> +
> +	mutex_unlock(&hw_lock);
> +}
> +
>  static struct mtk_wed_hw *
>  mtk_wed_assign(struct mtk_wed_device *dev)
>  {

