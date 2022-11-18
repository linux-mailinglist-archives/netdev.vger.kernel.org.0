Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB0262F0CB
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 10:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241843AbiKRJPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 04:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241210AbiKRJPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 04:15:47 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE0B419B8;
        Fri, 18 Nov 2022 01:15:47 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id t4so3180580wmj.5;
        Fri, 18 Nov 2022 01:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3X/1S90GjlN8tePoyh8v6JfLXXtmp5QanUR4qTwUYyg=;
        b=ivrCl7eR87WFMl7HIEh9g8KNEgNJ7CyRSqNkagy0HUc6kI78j7+z/acrsRITNfpM6p
         RMKX7zGXAABr383aK3RMwkXgNmx8hMDQUrU3m1B6dAe3xyh3arDqB6Yqp/2gV1ZOkgw6
         HHNQWvtMXq8J3olEVAKX4aSeSMuO6j8p3+JbXjjcWzv4HzqVNZt2iF31pAUlBgzfwqXE
         rSDM6gYyFTALm2OvWQVXie1eP4XW5R07pOp+T/EPtiP+I+Px6PAL3+gVbtWdZ+wicO1+
         4zcedJI+Npvysmd43guvP+0e+urmfr1+jioLF+WJywwSjF2+6FQA6OfnqDdhje7fLTIe
         ifWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3X/1S90GjlN8tePoyh8v6JfLXXtmp5QanUR4qTwUYyg=;
        b=cEDQbLS/q9YBaBIyOalkr35MFyfIo8Ov+WgnCLvubUo4gF+uXkh//5H3dlsB+EEZJw
         0zN9gY9P+jD6elpMvqDE91hEWYKKzayo6D9snUMLh6W/sh17/0tTo0j1+tTJmTkBuPkt
         5sBmG/MXuBQVSyIM8LBXFMyYo18WI4A0pPdNjbnP+aKLFjWhwG0Bn6jR+eTITQIDJm1H
         2Ghhw86GTYvRetPEttR7vcnE8hpvQhyQnMsjibdKKeK3SR1uaTLbUcxLn8kybbGoHfLS
         le63asJMZEqTjZX6vkUwwv6n7YcxeW7wvZzg0CbTrGdfUSdCoI7vGC58RQgIVKdAciW1
         2oxw==
X-Gm-Message-State: ANoB5pm5holhQJjJFuO9a/UzJRwOCTctpq3lLdU/CSj90QttPWsapLQW
        lyf1VyTJ13EoeMg8g6zPaUo=
X-Google-Smtp-Source: AA0mqf7F/GY8GL5t96td0LCmkzg1Y6ivleyOyKEYRj0gjjaDZLmMGYBgf27oi9om7DHMcX3fjDswJw==
X-Received: by 2002:a05:600c:34c5:b0:3cf:39b3:16bb with SMTP id d5-20020a05600c34c500b003cf39b316bbmr4193929wmq.201.1668762945535;
        Fri, 18 Nov 2022 01:15:45 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id h8-20020a05600c350800b003d005aab31asm3080706wmq.40.2022.11.18.01.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 01:15:45 -0800 (PST)
Date:   Fri, 18 Nov 2022 09:15:43 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] sfc: fix potential memleak in
 __ef100_hard_start_xmit()
Message-ID: <Y3dNP6iEj2YyEwqJ@gmail.com>
Mail-Followup-To: Leon Romanovsky <leon@kernel.org>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
 <Y3YctdnKDDvikQcl@unreal>
 <efedaa0e-33ce-24c6-bb9d-8f9b5c4a1c38@huawei.com>
 <Y3YxlxPIiw43QiKE@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3YxlxPIiw43QiKE@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 03:05:27PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 17, 2022 at 08:41:52PM +0800, Zhang Changzhong wrote:
> > 
> > 
> > On 2022/11/17 19:36, Leon Romanovsky wrote:
> > > On Thu, Nov 17, 2022 at 03:50:09PM +0800, Zhang Changzhong wrote:
> > >> The __ef100_hard_start_xmit() returns NETDEV_TX_OK without freeing skb
> > >> in error handling case, add dev_kfree_skb_any() to fix it.
> > >>
> > >> Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
> > >> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> > >> ---
> > >>  drivers/net/ethernet/sfc/ef100_netdev.c | 1 +
> > >>  1 file changed, 1 insertion(+)
> > >>
> > >> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> > >> index 88fa295..ddcc325 100644
> > >> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> > >> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> > >> @@ -218,6 +218,7 @@ netdev_tx_t __ef100_hard_start_xmit(struct sk_buff *skb,
> > >>  		   skb->len, skb->data_len, channel->channel);
> > >>  	if (!efx->n_channels || !efx->n_tx_channels || !channel) {
> > >>  		netif_stop_queue(net_dev);
> > >> +		dev_kfree_skb_any(skb);
> > >>  		goto err;
> > >>  	}
> > > 
> > > ef100 doesn't release in __ef100_enqueue_skb() either. SKB shouldn't be
> > > NULL or ERR at this stage.
> > 
> > SKB shouldn't be NULL or ERR, so it can be freed. But this code looks weird.
> 
> Please take a look __ef100_enqueue_skb() and see if it frees SKB on
> error or not. If not, please fix it.

That function looks ok to me, but I appreciate the extra eyes on it.

Martin

> Thanks
> 
> > 
> > > 
> > > diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
> > > index 29ffaf35559d..426706b91d02 100644
> > > --- a/drivers/net/ethernet/sfc/ef100_tx.c
> > > +++ b/drivers/net/ethernet/sfc/ef100_tx.c
> > > @@ -497,7 +497,7 @@ int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
> > > 
> > >  err:
> > >         efx_enqueue_unwind(tx_queue, old_insert_count);
> > > -       if (!IS_ERR_OR_NULL(skb))
> > > +       if (rc)
> > >                 dev_kfree_skb_any(skb);
> > > 
> > >         /* If we're not expecting another transmit and we had something to push
> > > 
> > > 
> > >>  
> > >> -- 
> > >> 2.9.5
> > >>
> > > .
> > > 
