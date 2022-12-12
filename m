Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEA464A9B5
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiLLVsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiLLVsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:48:18 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADD415A2B
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:48:14 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id r18so9125238pgr.12
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PNR/l0ULK/kMsMHHgPtajMRj1Pvr/PHmTYKsH3Rgbxw=;
        b=ILz7QCbjV1k+1+/TVOaGruQgL/VvgLKjpQXwt/7i+cUdTzTvddGl00cNYTfFsWQdo4
         RGnH9d9QBH9FSMdFMSf0hIjvGmmQ9NUmT9ogncZzF3uw2X6aogG+xkaqdTDCkYjI5P7S
         joPcCAeBLhXx6tJpJyBjvd8NNqVaBMpSkXjYMLT+mMoC+/gOEVIjixjGv4UtMqFCEIwz
         IB1sn3EbjTRxvzBj0pkapoFUGG20Lo1EnA6WAQ02GrBfALCSAUJ7199xmR4V0qmOK7U1
         b3HzjiVAIl8EFFbyvcyxNJd9I0pc3r7UMEYd8mj2W+OkHrwcijzEKfdZ+Z8Ii7q68FQ4
         sm1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PNR/l0ULK/kMsMHHgPtajMRj1Pvr/PHmTYKsH3Rgbxw=;
        b=KSalZ4yU7n757Hrza7dWiOt/bQ0p4idTS7+GwpPoTgzatnw22cJ7i5TJ9PlqrRhJVd
         td5z+RfWw+AIF/UJKBwuRdxS4znwsmbDakpg/3YTRU1bLSe9bk5gAu4UO1c10JZ4zpE3
         45iSjaCwO4sCCWUA7FZcMsxsVbiWlfBgL/k3mMgq8r8v+kudwtreledASdjyPCcvS5ye
         gvmikafjI0OlrQ1FRtxeVDlh9MIrK9O+ENjJt/0Nswnaj3Jp8bS9lsz1pD6atKegk3eI
         78lpqnzN+8Ctr6VBHl6TSPNNhF/p1fC3f7n1vWV9t+DXaBVm3IZYdGI1OExWnHQmJhKB
         D4+w==
X-Gm-Message-State: ANoB5pnxXi23cBFFVUcTBTcSVyQReip37U1s5UUx4Y5BYTmY5onZKner
        mhyCyKH7F+cwaTxeXXcPBzg=
X-Google-Smtp-Source: AA0mqf5O8JuqNB7n/lmfHsqBuwrTLR5wyWj+KdUK7pCVdXnsfjNPZ90qdF0tr7h0+k2jA818xc6TYA==
X-Received: by 2002:a05:6a00:278c:b0:578:3bc0:57d7 with SMTP id bd12-20020a056a00278c00b005783bc057d7mr7620338pfb.13.1670881693469;
        Mon, 12 Dec 2022 13:48:13 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id i125-20020a628783000000b00576b603a913sm6292950pfe.0.2022.12.12.13.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 13:48:13 -0800 (PST)
Message-ID: <cb96792bdc95682b79c1f1adcf615ae8b999cbd7.camel@gmail.com>
Subject: Re: [PATCH net v2 2/3] mISDN: hfcpci: don't call
 dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us
Date:   Mon, 12 Dec 2022 13:48:11 -0800
In-Reply-To: <20221212084139.3277913-3-yangyingliang@huawei.com>
References: <20221212084139.3277913-1-yangyingliang@huawei.com>
         <20221212084139.3277913-3-yangyingliang@huawei.com>
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
> skb_queue_purge() is called under spin_lock_irqsave() in hfcpci_l2l1D(),
> kfree_skb() is called in it, to fix this, use skb_queue_splice_init()
> to move the dch->squeue to a free queue, also enqueue the tx_skb and
> rx_skb, at last calling __skb_queue_purge() to free the SKBs afer unlock.
>=20
> Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/isdn/hardware/mISDN/hfcpci.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware=
/mISDN/hfcpci.c
> index e964a8dd8512..c0331b268010 100644
> --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> @@ -1617,16 +1617,19 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_b=
uff *skb)
>  		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
>  		spin_lock_irqsave(&hc->lock, flags);
>  		if (hc->hw.protocol =3D=3D ISDN_P_NT_S0) {
> +			struct sk_buff_head free_queue;
> +
> +			__skb_queue_head_init(&free_queue);
>  			/* prepare deactivation */
>  			Write_hfc(hc, HFCPCI_STATES, 0x40);
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
> @@ -1639,10 +1642,12 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_b=
uff *skb)
>  			hc->hw.mst_m &=3D ~HFCPCI_MASTER;
>  			Write_hfc(hc, HFCPCI_MST_MODE, hc->hw.mst_m);
>  			ret =3D 0;
> +			spin_unlock_irqrestore(&hc->lock, flags);
> +			__skb_queue_purge(&free_queue);
>  		} else {
>  			ret =3D l1_event(dch->l1, hh->prim);
> +			spin_unlock_irqrestore(&hc->lock, flags);
>  		}
> -		spin_unlock_irqrestore(&hc->lock, flags);
>  		break;
>  	}
>  	if (!ret)

Looks good to me, though I wonder if we couldn't look at moving the
locking so that this code was handled more like patch 3 with the
locking only covering the freeing path instead of also having to wrap
the l1_event.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
