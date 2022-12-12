Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613FF64A9B6
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiLLVtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiLLVtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:49:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321AA1A22A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:48:38 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so1414650pjd.5
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cl/ziKDdK71kgpACc3PSlk5j/uH5Bj1azq3L6ViaBe4=;
        b=iTkLBmupQLWZABaA+IV9cU/P6vm3SG61uKFtAwG+jBPlGB0z+w0aJvcn4QJpjS3eAu
         f23eaMb3kYVnaDEMxjenA2Bv5ERK1h5MfuZ4A1J1WBoS6gkTiLHDlsu8NCxd0v8jwtn7
         YXgN+QXSCtT1GwYajyqJV5LH4t2aG9iewBit8Z9TW/mcmpnuDO2ji6xuNkhMkS7CSMfL
         mf2I8JdtTWkhaIiqKUETo8rzGVhUVnvFybZWHb31aySwIRX9NItnwUfLdKNac8io4JnE
         xAKkAhXVDHgGShi6G6D5xzVXB6wGMEPGjU8APFmkQg035vbiuvswD/ZdpTx3tgPydyHd
         4DfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cl/ziKDdK71kgpACc3PSlk5j/uH5Bj1azq3L6ViaBe4=;
        b=WWodGNqV9qWkLdxuCSJn38NP9hLx+17diCx0v9r9jVuyNl6Fg6X4c2ii3ZSYnGJwH8
         juAN936jKKV4Bn3PhqrL1fQkKy3BEnDWP2saL3YjLlryJBV+TcInv+/Wmm3T614tODWk
         og3l+mnU7k5i+WGK1bG2vxqIbn21rriJy8UpND7tOaR3rkwhZQaAdSnmgrUxtdvmCM5S
         OSM3QWHsl4QC7iGfQEUpMy8UIQK6t+MTKyzrjAO0ci3e7smUgc2+J25XUsNPb5W2j4iw
         +MJFN1pAPfxniW0CX+ovefaoLQUfvX1eu41J8yu+wX7S6BqWfcJ67MzPCqeZFwHTM7Ra
         zdDQ==
X-Gm-Message-State: ANoB5pke+yRKpCxgbeWb/QV8F6DM4TNrF7VJk4549ilMKs4XnwgmMNgY
        UknzWbru6ys6kGaDLBfm8gNrF4/njyw=
X-Google-Smtp-Source: AA0mqf5Bb7A4Webtz4p/adKLDJ4XlfwWcGHQisjsnC6Ksf10AMrJ2fLVhydNXEj8W8yJHB9grU4tkg==
X-Received: by 2002:a17:902:d18c:b0:189:df3c:1ba1 with SMTP id m12-20020a170902d18c00b00189df3c1ba1mr16335931plb.38.1670881718129;
        Mon, 12 Dec 2022 13:48:38 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id q7-20020a170902dac700b001837b19ebb8sm6853284plx.244.2022.12.12.13.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 13:48:37 -0800 (PST)
Message-ID: <dcf35b9828f5450b45d537dfdac8838d9063c3b5.camel@gmail.com>
Subject: Re: [PATCH net v2 3/3] mISDN: hfcmulti: don't call
 dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us
Date:   Mon, 12 Dec 2022 13:48:35 -0800
In-Reply-To: <20221212084139.3277913-4-yangyingliang@huawei.com>
References: <20221212084139.3277913-1-yangyingliang@huawei.com>
         <20221212084139.3277913-4-yangyingliang@huawei.com>
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

On Mon, 2022-12-12 at 16:41 +0800, Yang Yingliang wrote:
> It is not allowed to call kfree_skb() or consume_skb() from hardware
> interrupt context or with hardware interrupts being disabled.
>=20
> skb_queue_purge() is called under spin_lock_irqsave() in handle_dmsg()
> and hfcm_l1callback(), kfree_skb() is called in them, to fix this, use
> skb_queue_splice_init() to move the dch->squeue to a free queue, also
> enqueue the tx_skb and rx_skb, at last calling __skb_queue_purge() to
> free the SKBs afer unlock.
>=20
> Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/isdn/hardware/mISDN/hfcmulti.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardwa=
re/mISDN/hfcmulti.c
> index 4f7eaa17fb27..e840609c50eb 100644
> --- a/drivers/isdn/hardware/mISDN/hfcmulti.c
> +++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
> @@ -3217,6 +3217,7 @@ static int
>  hfcm_l1callback(struct dchannel *dch, u_int cmd)
>  {
>  	struct hfc_multi	*hc =3D dch->hw;
> +	struct sk_buff_head	free_queue;
>  	u_long	flags;
> =20
>  	switch (cmd) {
> @@ -3245,6 +3246,7 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
>  		l1_event(dch->l1, HW_POWERUP_IND);
>  		break;
>  	case HW_DEACT_REQ:
> +		__skb_queue_head_init(&free_queue);
>  		/* start deactivation */
>  		spin_lock_irqsave(&hc->lock, flags);
>  		if (hc->ctype =3D=3D HFC_TYPE_E1) {
> @@ -3264,20 +3266,21 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
>  				plxsd_checksync(hc, 0);
>  			}
>  		}
> -		skb_queue_purge(&dch->squeue);
> +		skb_queue_splice_init(&dch->squeue, &free_queue);
>  		if (dch->tx_skb) {
> -			dev_kfree_skb(dch->tx_skb);
> +			__skb_queue_tail(&free_queue, dch->tx_skb);
>  			dch->tx_skb =3D NULL;
>  		}
>  		dch->tx_idx =3D 0;
>  		if (dch->rx_skb) {
> -			dev_kfree_skb(dch->rx_skb);
> +			__skb_queue_tail(&free_queue, dch->rx_skb);
>  			dch->rx_skb =3D NULL;
>  		}
>  		test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
>  		if (test_and_clear_bit(FLG_BUSY_TIMER, &dch->Flags))
>  			del_timer(&dch->timer);
>  		spin_unlock_irqrestore(&hc->lock, flags);
> +		__skb_queue_purge(&free_queue);
>  		break;
>  	case HW_POWERUP_REQ:
>  		spin_lock_irqsave(&hc->lock, flags);
> @@ -3384,6 +3387,9 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff=
 *skb)
>  	case PH_DEACTIVATE_REQ:
>  		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
>  		if (dch->dev.D.protocol !=3D ISDN_P_TE_S0) {
> +			struct sk_buff_head free_queue;
> +
> +			__skb_queue_head_init(&free_queue);
>  			spin_lock_irqsave(&hc->lock, flags);
>  			if (debug & DEBUG_HFCMULTI_MSG)
>  				printk(KERN_DEBUG
> @@ -3405,14 +3411,14 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_bu=
ff *skb)
>  				/* deactivate */
>  				dch->state =3D 1;
>  			}
> -			skb_queue_purge(&dch->squeue);
> +			skb_queue_splice_init(&dch->squeue, &free_queue);
>  			if (dch->tx_skb) {
> -				dev_kfree_skb(dch->tx_skb);
> +				__skb_queue_tail(&free_queue, dch->tx_skb);
>  				dch->tx_skb =3D NULL;
>  			}
>  			dch->tx_idx =3D 0;
>  			if (dch->rx_skb) {
> -				dev_kfree_skb(dch->rx_skb);
> +				__skb_queue_tail(&free_queue, dch->rx_skb);
>  				dch->rx_skb =3D NULL;
>  			}
>  			test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
> @@ -3424,6 +3430,7 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff=
 *skb)
>  #endif
>  			ret =3D 0;
>  			spin_unlock_irqrestore(&hc->lock, flags);
> +			__skb_queue_purge(&free_queue);
>  		} else
>  			ret =3D l1_event(dch->l1, hh->prim);
>  		break;

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
