Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B564E1EE3
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 02:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344081AbiCUBtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 21:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344077AbiCUBtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 21:49:31 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48C233E27;
        Sun, 20 Mar 2022 18:48:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o68-20020a17090a0a4a00b001c686a48263so6591659pjo.1;
        Sun, 20 Mar 2022 18:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MXaHjSqW1X8Va2iXmuY0GdSIMSz0sws/QMoV4WVeEt8=;
        b=bXw8LgDE+o11taz8NT95gJXNCd0JYnAVosKlZ3yFvjmLg4jhiTCWKd4sVOsYzNyMiI
         E5W3oHErXcbJ1uLYklqrhWXpDnrKsGsJ86cZ/D9THR6l11pkUeHqWULGsoYipq1Q8Aug
         YaO66Ox26YrcTvAk/VxszYXDHxdoENQC7D4s+y9H+//iYhOhv5rpdSDqyMCVbDtY1wgJ
         y/tABDaGrswWJZ59x9Df5+1b9Nuo7Hr1Rqsr5/DZSvybQAgQldym+nQFev4VJbkISgGR
         9cqyfmYHh0ogOifKOY2WbpNfXr3+Yw3uHpz5vLKtlYDaWnEjPJCSDccMHKKYjotvd8rj
         pQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MXaHjSqW1X8Va2iXmuY0GdSIMSz0sws/QMoV4WVeEt8=;
        b=wY0n0t4a8WpdqKxtVyT4dsN7/3gPZ1EqnIDxZcIvCGRx4TbkdYKwbJ9OWYe5/kzf4l
         bLNSiWwlYWg8mEB79HjyjDquBZ1avo7iVRB+z98PmUlK7iipKrSyG3pi6w4aY2suZlQn
         AN0pa75yaxKjpELuMNoZpX+4oML/5wWJcDIxpISBojD9GKXSUME7x6dlMHb7UATIbjbu
         thwIo8L39v9I3aXJ6muc26kxKYP0Wr5ybwj5PToeYnQl1qla3HM+ASVD0Q75sJZFBJ9+
         4a9705sE+R/Sxe2Q0AIeIkhUUj3J56QSP1xvf/ByWsrdpwMPvbNFDr9zIwY99k65MhBc
         Rd4w==
X-Gm-Message-State: AOAM533e8VDSUNPOtTgP7gX1+DOoT43gh+EV4Uu+i1nHdaskcd7gOEcG
        /XfX+wiMMVQmgUxTKMsNYdXcA+iZT+jXTw==
X-Google-Smtp-Source: ABdhPJzwqjSayPfEdLMbnZ9hl+6ggCJT03NPCSGkybxAu1cj53SWeZ32/CQmZb6HD69avg0sPg8YnQ==
X-Received: by 2002:a17:903:1205:b0:151:8ae9:93ea with SMTP id l5-20020a170903120500b001518ae993eamr10752168plh.37.1647827285428;
        Sun, 20 Mar 2022 18:48:05 -0700 (PDT)
Received: from [10.11.37.162] ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00218200b004f6519ce666sm17329005pfi.170.2022.03.20.18.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 18:48:05 -0700 (PDT)
Message-ID: <de416319-c027-837d-4b8c-b8c3c37ed88e@gmail.com>
Date:   Mon, 21 Mar 2022 09:47:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] can: usb_8dev: fix possible double dev_kfree_skb in
 usb_8dev_start_xmit
Content-Language: en-US
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, b.krumboeck@gmail.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220311080614.45229-1-hbh25y@gmail.com>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220311080614.45229-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle ping.

On 2022/3/11 16:06, Hangyu Hua wrote:
> There is no need to call dev_kfree_skb when usb_submit_urb fails beacause
> can_put_echo_skb deletes original skb and can_free_echo_skb deletes the cloned
> skb.
> 
> Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>   drivers/net/can/usb/usb_8dev.c | 30 ++++++++++++++----------------
>   1 file changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
> index 431af1ec1e3c..b638604bf1ee 100644
> --- a/drivers/net/can/usb/usb_8dev.c
> +++ b/drivers/net/can/usb/usb_8dev.c
> @@ -663,9 +663,20 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
>   	atomic_inc(&priv->active_tx_urbs);
>   
>   	err = usb_submit_urb(urb, GFP_ATOMIC);
> -	if (unlikely(err))
> -		goto failed;
> -	else if (atomic_read(&priv->active_tx_urbs) >= MAX_TX_URBS)
> +	if (unlikely(err)) {
> +		can_free_echo_skb(netdev, context->echo_index, NULL);
> +
> +		usb_unanchor_urb(urb);
> +		usb_free_coherent(priv->udev, size, buf, urb->transfer_dma);
> +
> +		atomic_dec(&priv->active_tx_urbs);
> +
> +		if (err == -ENODEV)
> +			netif_device_detach(netdev);
> +		else
> +			netdev_warn(netdev, "failed tx_urb %d\n", err);
> +		stats->tx_dropped++;
> +	} else if (atomic_read(&priv->active_tx_urbs) >= MAX_TX_URBS)
>   		/* Slow down tx path */
>   		netif_stop_queue(netdev);
>   
> @@ -684,19 +695,6 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
>   
>   	return NETDEV_TX_BUSY;
>   
> -failed:
> -	can_free_echo_skb(netdev, context->echo_index, NULL);
> -
> -	usb_unanchor_urb(urb);
> -	usb_free_coherent(priv->udev, size, buf, urb->transfer_dma);
> -
> -	atomic_dec(&priv->active_tx_urbs);
> -
> -	if (err == -ENODEV)
> -		netif_device_detach(netdev);
> -	else
> -		netdev_warn(netdev, "failed tx_urb %d\n", err);
> -
>   nomembuf:
>   	usb_free_urb(urb);
>   
