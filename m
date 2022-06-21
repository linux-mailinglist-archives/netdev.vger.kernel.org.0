Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC895534A9
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 16:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351757AbiFUOiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 10:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351041AbiFUOiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 10:38:51 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA1922530
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 07:38:50 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id e5so7635885wma.0
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 07:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fgAsmHRa0I7boS8KfaFAiezDw43TzbbHvdTT8A1mzvc=;
        b=fjgiTzrSnM0+9EZN4+GD2LFTOVMK6/CYnddY6bA6LT3kVBxneVuAR/IRd7DD19M95T
         etHmCVpCNdZ9q5zwc2CgcesKFVzR/mWRY3Tg/G+djiXjlKgzSh6Adex56jqTAVfvnWVo
         EVy5XBKOS+v2vxkkfIlUKIYUk8i6aNrT2ESpuOJQajB8p9/7uyAPhPqwy4SCWIAt36JN
         MI4Rmegi1hVM2YKX7ZlqJ+1aFXsKgmSl1JZx9Brrx8KOLUIo9zkWxZ5Q1LruWNj146hr
         KoqrgsjsXSPzqQH+WE8gng4QpOrnGwIlLzVt+2q7tD+XdE9S9vpp4L+T0jBfNWfX6nlZ
         vxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fgAsmHRa0I7boS8KfaFAiezDw43TzbbHvdTT8A1mzvc=;
        b=h0N1S4DQDrrUGxAO9ccDJDCF6/+nHWhXXGQa7RaNyscWYJDEVpqLK7Tx0uJI2e7XlS
         dsRmifadwOQFkPr8bkHZ8F9mCXo3GepKUXMo2etyV9fjZe1OkooPjNbvQQH7ItHZKxdd
         eX7OoaV25NINfSlpOPR614Un37UO70ZmKWEUhXuzBMPfiWr1NeDdYz0fYt4y94kf27yq
         THaJ1wrIOlTSObDLimcUsplWkM7IRcLzw1fPeoM1uARp7NYy0qBz2tXqUKwdSyHG6cG/
         oCCaMiQJUh9edXECFaQUVgd2geQiWLJwb3jfSWz9K5r4Mxc9IhnvoTi1LRsx7D184/gD
         fg4w==
X-Gm-Message-State: AJIora/9RvzNDzzu1E1K76j1dRFAyJXdQry6L2WbXntYzw1b8A5ZZ2aq
        YvuIZKxl2/JbcwHiqPk2MVdRJA==
X-Google-Smtp-Source: AGRyM1sNQRrQWpqX4g8bgwJGWY0NhrzcXOBJO6ADZYtWQl2HzembPJy9LgFIsb3r+3mbwmURTA5n3w==
X-Received: by 2002:a05:600c:a182:b0:39e:fea2:c5d6 with SMTP id id2-20020a05600ca18200b0039efea2c5d6mr12746841wmb.54.1655822329201;
        Tue, 21 Jun 2022 07:38:49 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id e16-20020adfdbd0000000b0021b91ec8f6esm5175694wrj.67.2022.06.21.07.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 07:38:48 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:38:46 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     linux-kernel@vger.kernel.org, stable@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] Bluetooth: Use chan_list_lock to protect the whole
 put/destroy invokation
Message-ID: <YrHX9pj/f0tkqJis@google.com>
References: <20220607134709.373344-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220607134709.373344-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Jun 2022, Lee Jones wrote:

> This change prevents a use-after-free caused by one of the worker
> threads starting up (see below) *after* the final channel reference
> has been put() during sock_close() but *before* the references to the
> channel have been destroyed.
> 
>   refcount_t: increment on 0; use-after-free.
>   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
>   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705
> 
>   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.14.234-00003-g1fb6d0bd49a4-dirty #28
>   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM sm8150 Flame DVT (DT)
>   Workqueue: hci0 hci_rx_work
>   Call trace:
>    dump_backtrace+0x0/0x378
>    show_stack+0x20/0x2c
>    dump_stack+0x124/0x148
>    print_address_description+0x80/0x2e8
>    __kasan_report+0x168/0x188
>    kasan_report+0x10/0x18
>    __asan_load4+0x84/0x8c
>    refcount_dec_and_test+0x20/0xd0
>    l2cap_chan_put+0x48/0x12c
>    l2cap_recv_frame+0x4770/0x6550
>    l2cap_recv_acldata+0x44c/0x7a4
>    hci_acldata_packet+0x100/0x188
>    hci_rx_work+0x178/0x23c
>    process_one_work+0x35c/0x95c
>    worker_thread+0x4cc/0x960
>    kthread+0x1a8/0x1c4
>    ret_from_fork+0x10/0x18
> 
> Cc: stable@kernel.org
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  net/bluetooth/l2cap_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

No reply for 2 weeks.

Is this patch being considered at all?

Can I help in any way?

> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index ae78490ecd3d4..82279c5919fd8 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -483,9 +483,7 @@ static void l2cap_chan_destroy(struct kref *kref)
>  
>  	BT_DBG("chan %p", chan);
>  
> -	write_lock(&chan_list_lock);
>  	list_del(&chan->global_l);
> -	write_unlock(&chan_list_lock);
>  
>  	kfree(chan);
>  }
> @@ -501,7 +499,9 @@ void l2cap_chan_put(struct l2cap_chan *c)
>  {
>  	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
>  
> +	write_lock(&chan_list_lock);
>  	kref_put(&c->kref, l2cap_chan_destroy);
> +	write_unlock(&chan_list_lock);
>  }
>  EXPORT_SYMBOL_GPL(l2cap_chan_put);
>  

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
