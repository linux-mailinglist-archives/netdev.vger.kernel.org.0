Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2EF64A9AF
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiLLVqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiLLVqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:46:08 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C4D19C20
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:46:02 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d82so851810pfd.11
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zucWMnYpA+9lAVSxvp3xaxbGQIBgGxTkjhUBcYvLz9g=;
        b=IBlL8R7HunBjKQXv9O58vJ1CUChSDUMnc7OSeLQ3LMSCH+H8VBzs6BSmBbfUhur6Ua
         5YK+MNkiNC+TIuNdQhcboKl2P0OTUGRk7dUiZNJkkqn47E0cjsoQGyXiOiK5e2Oli42W
         w4lSBIU2MAxqObERZEAwl14BZA7wOrzs8uIotV8ixRLvNWXeAo2JwIB1T5G7xRSkq14x
         Zspnwrpon0lTlQebkaThl5br6Wald6dFLKbz2TnIr4AXUzNQX2j1IcmebEAK83CdRPHx
         H54ez8aZ24SZC328DPxyJoytEXVsogpyJnbGmuyXPkAnE0Fm6H/IettFq/umsyrf3kf+
         m1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zucWMnYpA+9lAVSxvp3xaxbGQIBgGxTkjhUBcYvLz9g=;
        b=nG+dRgwSLYQ469p7za3pKJiNNMjULL0uC+juCZKYrezDYqOLZs2Maza9LvoUTUkXgl
         TaQjMic8K8BnmUlc2ynP4qIK6Ed4xXVJpO1Y2GPub3mMIOzs8NNN5Kp+DpxpKqf8TZTF
         h6cxacpt+6hDhRVErW1MgD0a5U2GskjTetOWylQYZoGYIPz4KTWetgm+RODjPH++9n92
         doehcoeGmAe4eGKst722zDgq9h8ElpZzw6w0xmtk9PSWUHRrAyHx9hC2WJzFkCZYbOUx
         nbypOtW1Dd31OToY+6mwC85ry1npCxsBPbVSgQLT255Usa8LXraLxzA9NwAky4jxnWzg
         oD3A==
X-Gm-Message-State: ANoB5pn28S08GDMtfeLfbIxVOSMoU1UJ6nyHG82dvIbr9LIeQxF/QYhU
        d7rvrmYhKbvdJ7rQfC+F5ltjH5DFLp8=
X-Google-Smtp-Source: AA0mqf6dDEod0nkyy2edoxtAkUWMO7Udsf9d6Lu/ScsnrA9UPst7n6x3oWFlkh9cOTJcjhsoeJIK6Q==
X-Received: by 2002:aa7:9f04:0:b0:577:4168:b5ef with SMTP id g4-20020aa79f04000000b005774168b5efmr17544130pfr.3.1670881561842;
        Mon, 12 Dec 2022 13:46:01 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id y130-20020a62ce88000000b0056d73ef41fdsm6237753pfg.75.2022.12.12.13.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 13:46:01 -0800 (PST)
Message-ID: <94f08a44b4c25ef041e43a6731413e6efcb73161.camel@gmail.com>
Subject: Re: [PATCH net v2 1/3] mISDN: hfcsusb: don't call
 dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us, Martin Bachem <m.bachem@gmx.de>
Date:   Mon, 12 Dec 2022 13:45:57 -0800
In-Reply-To: <20221212084139.3277913-2-yangyingliang@huawei.com>
References: <20221212084139.3277913-1-yangyingliang@huawei.com>
         <20221212084139.3277913-2-yangyingliang@huawei.com>
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
> It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
> The difference between them is free reason, dev_kfree_skb_irq() means
> the SKB is dropped in error and dev_consume_skb_irq() means the SKB
> is consumed in normal.
>=20
> skb_queue_purge() is called under spin_lock_irqsave() in hfcusb_l2l1D(),
> kfree_skb() is called in it, to fix this, use skb_queue_splice_init()
> to move the dch->squeue to a free queue, also enqueue the tx_skb and
> rx_skb, at last calling __skb_queue_purge() to free the SKBs afer unlock.
>=20
> In tx_iso_complete(), dev_kfree_skb() is called to consume the transmitte=
d
> SKB, so replace it with dev_consume_skb_irq().
>=20
> Fixes: 69f52adb2d53 ("mISDN: Add HFC USB driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/isdn/hardware/mISDN/hfcsusb.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardwar=
e/mISDN/hfcsusb.c
> index 651f2f8f685b..1efd17979f24 100644
> --- a/drivers/isdn/hardware/mISDN/hfcsusb.c
> +++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
> @@ -326,20 +326,24 @@ hfcusb_l2l1D(struct mISDNchannel *ch, struct sk_buf=
f *skb)
>  		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
> =20
>  		if (hw->protocol =3D=3D ISDN_P_NT_S0) {
> +			struct sk_buff_head free_queue;
> +
> +			__skb_queue_head_init(&free_queue);
>  			hfcsusb_ph_command(hw, HFC_L1_DEACTIVATE_NT);
>  			spin_lock_irqsave(&hw->lock, flags);
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
>  			spin_unlock_irqrestore(&hw->lock, flags);
> +			__skb_queue_purge(&free_queue);
>  #ifdef FIXME
>  			if (test_and_clear_bit(FLG_L1_BUSY, &dch->Flags))
>  				dchannel_sched_event(&hc->dch, D_CLEARBUSY);
> @@ -1330,7 +1334,7 @@ tx_iso_complete(struct urb *urb)
>  					printk("\n");
>  				}
> =20
> -				dev_kfree_skb(tx_skb);
> +				dev_consume_skb_irq(tx_skb);
>  				tx_skb =3D NULL;
>  				if (fifo->dch && get_next_dframe(fifo->dch))
>  					tx_skb =3D fifo->dch->tx_skb;

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
