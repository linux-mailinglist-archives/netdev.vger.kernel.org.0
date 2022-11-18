Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23DB62F0C0
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 10:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241818AbiKRJOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 04:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241814AbiKRJOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 04:14:00 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1112B24A;
        Fri, 18 Nov 2022 01:13:59 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so7080562wmb.2;
        Fri, 18 Nov 2022 01:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RLChsz4krtzZTev2yEyKsYVgVakCijZO7dCu1rvHy2k=;
        b=RdVcq7M4Wc42iB80ZoHSmZYqEHaN8Q28idRv677+gfsMoQrPw4IzufiWZNb0qdQaNt
         AtmSx+5Rklz52O2YrC4vd9dkmcmsOn4e+TzvmDPIjFrInkBJpSC2MWyKxcuX9ayCEbM1
         SRndnvZ7630749DfLuvbCBIBhJglYBXi+SqumCRWzhDpcG69FjfYwbhjDb00wad/i5ci
         ew0kBBmIszeP7wONHBpX9RNj0xaLppPbe06zZoeNK2inItHIsJq0uQ3Ai7Ne6AHXxCFJ
         y5RcC05AWgJ4ojciSxRiSEtfyQDsZ9GZ7lJUznYS+6BCPrzzfuDOh37HsEH+6ulpB6uU
         neiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RLChsz4krtzZTev2yEyKsYVgVakCijZO7dCu1rvHy2k=;
        b=KI/Hke72ggphR5nWD164UNwrNu38n8SsabySD783XptwiJadCEAQ13vwXk9kU/poAK
         yLi0ydgGWyGaF2vpElBCD6WTTPzKgHw0TuMiEZFhyR3QN7K337SghLjul1cWUcucsaMS
         eqHTrBn7dGwpXlNfhYpntHSD53vk0AXNRM99y7vijd401qMvUReEQZ9RvHaaxliKMt4n
         ExUo7IFOS+XMmNh8dZTp0vqsxwxIdd0ttTpY+XrRpIl2G6fVaXdUoL1L9A6XbSxzU2/9
         yxqIg4bB1Hc0WQng5wkR+l+4o6wLK8tv/mbiVbyvtohUiHXzK6zOsmmvxhe/zN8h0vIA
         7e6A==
X-Gm-Message-State: ANoB5pmI8xeY38Hk9oBDILmY0Tpu6JFAejxF40eRDbliQkcyeQJSnJ2k
        xWIHk0F1e0ts9gryBuKRCyY=
X-Google-Smtp-Source: AA0mqf4Ayn84pZBf1NHTWk/8lPRC9d/qgwxKatvL62t08L4NG6pp0jgZyYbG6h0dCC9fXWynwI9DEA==
X-Received: by 2002:a05:600c:4d07:b0:3cf:8108:de64 with SMTP id u7-20020a05600c4d0700b003cf8108de64mr7908422wmp.139.1668762837605;
        Fri, 18 Nov 2022 01:13:57 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id n27-20020a05600c3b9b00b003cfa81e2eb4sm4379859wms.38.2022.11.18.01.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 01:13:56 -0800 (PST)
Date:   Fri, 18 Nov 2022 09:13:54 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] sfc: fix potential memleak in
 __ef100_hard_start_xmit()
Message-ID: <Y3dM0rG8JeYgE5pX@gmail.com>
Mail-Followup-To: Zhang Changzhong <zhangchangzhong@huawei.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 03:50:09PM +0800, Zhang Changzhong wrote:
> The __ef100_hard_start_xmit() returns NETDEV_TX_OK without freeing skb
> in error handling case, add dev_kfree_skb_any() to fix it.
> 
> Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> index 88fa295..ddcc325 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> @@ -218,6 +218,7 @@ netdev_tx_t __ef100_hard_start_xmit(struct sk_buff *skb,
>  		   skb->len, skb->data_len, channel->channel);
>  	if (!efx->n_channels || !efx->n_tx_channels || !channel) {
>  		netif_stop_queue(net_dev);
> +		dev_kfree_skb_any(skb);
>  		goto err;
>  	}
>  
> -- 
> 2.9.5
