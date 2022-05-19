Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8F852D5DD
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbiESOXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiESOXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:23:15 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229A96FA05;
        Thu, 19 May 2022 07:23:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gi33so1809184ejc.3;
        Thu, 19 May 2022 07:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y6gDKrJBOB/JTUPKj6orU/0LVD95EntzsWkvK0NGWVQ=;
        b=TVP3NwR0ZixyvFtor7fDuY8X/Ncd2o23Rcjla8NgbypEfmkW9n5RcM9tFLaYYi/Hx4
         y3W5kBYd7tlbxtJ/b+r4moi/DGNdNeOqZ0kLUEK8AMA/beNdaF3uCBRaBufGGPChku29
         DsVRAY0BCTk99FS45+o8RQn6kdHQKGeOijLI86BkXCa4p+wUDTE3cZXHYUDD17gnyyPy
         rzwalvPRvyU6IG60BG5HfgwkCfxJGEPaFGpIAo5oPDnRSPYToBY+6rxIdqc+dNujR+Kn
         UogjGnNRPvQvrpxf67w3xnGdn5yr7Ll0T7/IDtjtUzfV8b0szKJmN2iTiejcBVFr+NaH
         Hkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y6gDKrJBOB/JTUPKj6orU/0LVD95EntzsWkvK0NGWVQ=;
        b=2R0HBL3e7+XZjx6aQHsYPUlgU0DeS4NxTZRZwtG39nmGg1SnpEVYgA4G3v4Gt/fwuw
         Ya5QsSYgoN8T/xXCP/RZbfALIoWMW7kTPgzR4WelOaJjR3SLr6KdKXhBYGFu0t3Jf2nc
         A4+PeWZkRx34qz1NWjxtwNsc+WtOrfXPAh/q8siMCJ4fQojR98pbJ0Bcma0BdR1V68Ug
         OvV0l2SN4gmFrvn7DButp0//iMnvgDpm+MsfX6CRh5Fs6xiWoOegYWrMLtmnwoIY+eiC
         JjhB/eaYtehny2285B75aYWct8KYNC3FXRFAm0AaVjZVGg2BuvBs+k77QBWrLSK3ZKsS
         Pw7w==
X-Gm-Message-State: AOAM530YfUWNuxbM3ONrH/tG3jOWoJUh5S2oiE7+V3cMkL8elPNtgnS0
        NxrnNt5eYo/XhlVyT1hfQm09nyBg0xoa3pcoaz8=
X-Google-Smtp-Source: ABdhPJy/8sdt6yaCpNtINLDv3yNY8g6gXgZa0jnSq2AmUkRCoySh17BoWbxOGYPFiliHoAnaaCsG7TpUq+95y2IgJxM=
X-Received: by 2002:a17:906:7313:b0:6f4:9079:2b2a with SMTP id
 di19-20020a170906731300b006f490792b2amr4539763ejc.377.1652970193597; Thu, 19
 May 2022 07:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <YoUuy4iTjFAcSn03@kili>
In-Reply-To: <YoUuy4iTjFAcSn03@kili>
From:   =?UTF-8?B?5ZGC6Iqz6aiw?= <wellslutw@gmail.com>
Date:   Thu, 19 May 2022 22:23:04 +0800
Message-ID: <CAFnkrsnR0LZRmZq0qAnhU9ysjYR2PAY15TmEHMt4EwdrD_AU-A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: SP7021: fix a use after free of skb->len
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

> The netif_receive_skb() function frees "skb" so store skb->len before
> it is freed.
>
> Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/sunplus/spl2sw_int.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_int.c b/drivers/net/ethernet/sunplus/spl2sw_int.c
> index 69b1e2e0271e..a37c9a4c281f 100644
> --- a/drivers/net/ethernet/sunplus/spl2sw_int.c
> +++ b/drivers/net/ethernet/sunplus/spl2sw_int.c
> @@ -29,6 +29,7 @@ int spl2sw_rx_poll(struct napi_struct *napi, int budget)
>         u32 mask;
>         int port;
>         u32 cmd;
> +       u32 len;
>
>         /* Process high-priority queue and then low-priority queue. */
>         for (queue = 0; queue < RX_DESC_QUEUE_NUM; queue++) {
> @@ -63,10 +64,11 @@ int spl2sw_rx_poll(struct napi_struct *napi, int budget)
>                         skb_put(skb, pkg_len - 4); /* Minus FCS */
>                         skb->ip_summed = CHECKSUM_NONE;
>                         skb->protocol = eth_type_trans(skb, comm->ndev[port]);
> +                       len = skb->len;
>                         netif_receive_skb(skb);
>
>                         stats->rx_packets++;
> -                       stats->rx_bytes += skb->len;
> +                       stats->rx_bytes += len;
>
>                         /* Allocate a new skb for receiving. */
>                         new_skb = netdev_alloc_skb(NULL, comm->rx_desc_buff_size);
> --
> 2.35.1
>

Thanks a lot for fixing the bug.

Can we just move the statement "stats->rx_bytes += skb->len;" to
before free skb?
For example,

skb_put(skb, pkg_len - 4); /* Minus FCS */
skb->ip_summed = CHECKSUM_NONE;
skb->protocol = eth_type_trans(skb, comm->ndev[port]);
stats->rx_packets++;
stats->rx_bytes += skb->len;
netif_receive_skb(skb);

/* Allocate a new skb for receiving. */
new_skb = netdev_alloc_skb(NULL, comm->rx_desc_buff_size);

Best regards,
Wells
