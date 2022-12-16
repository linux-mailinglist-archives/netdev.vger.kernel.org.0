Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E2264EDFF
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 16:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiLPPe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 10:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLPPeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 10:34:25 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6411415725;
        Fri, 16 Dec 2022 07:34:24 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id a9so2657795pld.7;
        Fri, 16 Dec 2022 07:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YEVI3jaQZmzPme07G5Ofwk/sQtPIHxWgPIC24zb09uU=;
        b=UjFYN63MJNj1bErRevHeWiJoAKy5yLUsff1nglGBSeqdcbRLMxq+nYpEocEGFBbjw+
         hTxLRNrtvWFNBXpWDBV0YJDGiZ4mfOMRbMJEHiHAY59CWFIG+G1KwNQU7yv9A9ehnI5e
         jGqEUnh0OaG/JNtuox9fmu7N2krl7f1Qtr1jamTUZwVFWxhP8Wj6DWwlLUvUlVLKhzJ+
         LD3Fsr9uB2I6p6avKRTWByy/UQoT+MtYdpPAiNcLoOq42jsDXHbpXCSL9wF3cz5Ih73s
         nKNoiFJ8r+XK1xVHlG3KnXgv/xMmWzdxblG5vN3Zc/vVYmLE9oS7hIBWD5MceiNmgncQ
         7pnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YEVI3jaQZmzPme07G5Ofwk/sQtPIHxWgPIC24zb09uU=;
        b=NWjUUgz3iUDOjqQbw2uYYA1CgqEheLjVdYTcIbSeboHwV9kiM87RUbLMaJHArF3lyf
         ptEq874TYQh4jPTQKUnD6fJ4sHbWcZ606NniR4R+pWlZnmYWSyNGPooCb22Dm/CMUV2m
         JRUYTNtY00ea0UsUiAYHk5pJiBF1i3EN7O3fmOjjBLw4yQGLKWt9UMcT8nJIWRPkGAUA
         t6rpkFyqXipM4Zv1HBb5ScP5wO1LaQ8kBehwvIjoQJdJ8+BdYbvcfDhQxJRd+9/QBHNo
         +hlQAZITOniWc3TtpvHjhOUTBgR48FRayvCBTIBokvod0Xek9VhuLzZGSPyJDRKlhcVp
         VsoA==
X-Gm-Message-State: ANoB5pkH6Ifi2ZOu/ldiuc6qTin6HDmYuFssPevV5+z4xxUitKajq87a
        kjI67eo0wPOl3pomXjUAqrTC+O2Y5U4=
X-Google-Smtp-Source: AA0mqf7I5KZdMNSF9aaI2vKKGbP4LOiiPy3I9RdLOcFamodVtcVvWmGI5k58KPZpgP+4WmMtLxnGpg==
X-Received: by 2002:a17:90a:eb0e:b0:21a:67f:5d34 with SMTP id j14-20020a17090aeb0e00b0021a067f5d34mr32867029pjz.16.1671204863632;
        Fri, 16 Dec 2022 07:34:23 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id x20-20020a17090ab01400b00219186abd7csm1547900pjq.16.2022.12.16.07.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 07:34:23 -0800 (PST)
Message-ID: <be98552a061f6249de558b210ff25de45e80d690.camel@gmail.com>
Subject: Re: [PATCH net] net: fec: Coverity issue: Dereference null return
 value
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiaoning.wang@nxp.com,
        shenwei.wang@nxp.com, linux-imx@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 16 Dec 2022 07:34:21 -0800
In-Reply-To: <20221215091149.936369-1-wei.fang@nxp.com>
References: <20221215091149.936369-1-wei.fang@nxp.com>
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

On Thu, 2022-12-15 at 17:11 +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
>=20
> The build_skb might return a null pointer but there is no check on the
> return value in the fec_enet_rx_queue(). So a null pointer dereference
> might occur. To avoid this, we check the return value of build_skb. If
> the return value is a null pointer, the driver will recycle the page and
> update the statistic of ndev. Then jump to rx_processing_done to clear
> the status flags of the BD so that the hardware can recycle the BD.
>=20
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> Reviewed-by: Shenwei Wang <Shenwei.wang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethe=
rnet/freescale/fec_main.c
> index 5528b0af82ae..c78aaa780983 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1674,6 +1674,16 @@ fec_enet_rx_queue(struct net_device *ndev, int bud=
get, u16 queue_id)
>  		 * bridging applications.
>  		 */
>  		skb =3D build_skb(page_address(page), PAGE_SIZE);
> +		if (unlikely(!skb)) {
> +			page_pool_recycle_direct(rxq->page_pool, page);
> +			ndev->stats.rx_packets--;
> +			ndev->stats.rx_bytes -=3D pkt_len;
> +			ndev->stats.rx_dropped++;

I'm not sure you really need to bother with rewinding the rx_packets
and rx_bytes counters. I know that the rx_dropped statistic will get
incremented in the network stack in the event of a packet failing to
enqueue to the backlog, so it might be better to just leave the
rx_packets counter as is and assume the actual packet count is
rx_packets - rx_dropped.

> +
> +			netdev_err(ndev, "build_skb failed!\n");

Instead of netdev_err you may want to consider netdev_err_once for
this. Generally speaking when we start seeing memory allocation error
issues they can get very noisy very quickly as you are likely to fail
the allocation for every packet in a given polling session, and
sessions to follow.

> +			goto rx_processing_done;
> +		}
> +
>  		skb_reserve(skb, data_start);
>  		skb_put(skb, pkt_len - sub_len);
>  		skb_mark_for_recycle(skb);

