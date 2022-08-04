Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C999589E00
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 16:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbiHDO7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 10:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240091AbiHDO7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 10:59:34 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44643AB17;
        Thu,  4 Aug 2022 07:59:32 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id v131-20020a1cac89000000b003a4bb3f786bso2626861wme.0;
        Thu, 04 Aug 2022 07:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fIvr7r4dFld5MIm2rh62nNS+UOBVr/ErA+zOy7iWMao=;
        b=A/Fik9lv/2gethHz0fZ+UAEGw/3qSbGg1E/Low6x0iRRXTokgLR9yM7uvtfz/YbA3W
         h7dprtwYZPWTK/bb+r8SFqGnQ9iixgLf+ONaYlfiF7egl5W6Ws1ldtQ22Vqz4p99SYa2
         mrHDQnzWvctMh29FtMXilAEU/zIqyOgE78K1zD4SBYvBkPZCQzeNPeMRaCR8yXOuUsiX
         3bXoynGTGR+4l5aJwMzUw6Hm5KlrFTwMqdtN0s8MPuht6S7bx9MuALUwVJExTUVoi4+r
         VlIcP+pR/iatTPn6dR+Jmm4UqfhVM8tXID19LeXH9HbgSIIQd0pXIrdEWp+yK50QeJH8
         r6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fIvr7r4dFld5MIm2rh62nNS+UOBVr/ErA+zOy7iWMao=;
        b=OFlsdVHTKdlCQcIoPRgxNWrHrwc9Psvfds484klwIfYKydABKwes9ySPHoS6Yp4KmB
         fLiFWsDJLYbDcsWb7flcXfh4l+i7kT0wYNM5x9JJMvo9QaOjW/eShLqNkIRmdtcnL0S2
         XTtXAgBOIqT99cFK1rHjsicNtMZUTm5F7fxVUbPBk+LySmbs/UFJ363u3suOCKXky7jb
         lIKQNLwIG4sWh2/yi+QhXUXDjlnn3MGkaHqSS77GgU2lwZoTnCM6PreJ4UprsBuDuay7
         tjbTfhoRrlwdJrU1yf1ytg+gilOZpNwqvNaNayet6IC8z5MBS5XJo7hsRSjPmwnKDkh8
         G3fg==
X-Gm-Message-State: ACgBeo2u9cS6j3CLr2E4M686u4qIJq+jGVpprTHiUjCDCcQljMrnlfQC
        Geein3oKzWP+WwAvUMQDXNijQP5ajps=
X-Google-Smtp-Source: AA6agR5TCZxbnnhJsvsjr7VRv9JM2gcdz57C0mjg2APxHzpck97bLs/MVKv6BbloUIKc4pxx2xVGyA==
X-Received: by 2002:a05:600c:1e0f:b0:3a3:191c:a3c8 with SMTP id ay15-20020a05600c1e0f00b003a3191ca3c8mr1821727wmb.151.1659625171368;
        Thu, 04 Aug 2022 07:59:31 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id c6-20020a05600c0a4600b003a308e9a192sm8004735wmq.30.2022.08.04.07.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 07:59:31 -0700 (PDT)
Message-ID: <b6857098-63c8-f1ca-9907-04ef1cad3f23@gmail.com>
Date:   Thu, 4 Aug 2022 17:59:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net/mlx5e: kTLS, Use _safe() iterator in
 mlx5e_tls_priv_tx_list_cleanup()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
References: <YuvbN3hr1F/KbeCh@kili>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <YuvbN3hr1F/KbeCh@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2022 5:44 PM, Dan Carpenter wrote:
> Use the list_for_each_entry_safe() macro to prevent dereferencing "obj"
> after it has been freed.
> 
> Fixes: c4dfe704f53f ("net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX connections")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> index 6b6c7044b64a..e6f604f9561d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> @@ -246,7 +246,7 @@ static void mlx5e_tls_priv_tx_cleanup(struct mlx5e_ktls_offload_context_tx *priv
>   static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
>   					   struct list_head *list, int size)
>   {
> -	struct mlx5e_ktls_offload_context_tx *obj;
> +	struct mlx5e_ktls_offload_context_tx *obj, *n;
>   	struct mlx5e_async_ctx *bulk_async;
>   	int i;
>   
> @@ -255,7 +255,7 @@ static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
>   		return;
>   
>   	i = 0;
> -	list_for_each_entry(obj, list, list_node) {
> +	list_for_each_entry_safe(obj, n, list, list_node) {
>   		mlx5e_tls_priv_tx_cleanup(obj, &bulk_async[i]);
>   		i++;
>   	}

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch!
