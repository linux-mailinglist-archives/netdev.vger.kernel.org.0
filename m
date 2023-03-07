Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8D56AD722
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 07:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjCGGH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 01:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjCGGHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 01:07:55 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC67D6F639;
        Mon,  6 Mar 2023 22:07:50 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cw28so48035427edb.5;
        Mon, 06 Mar 2023 22:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678169269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NaaJ5mwp2B7vcZxepa8ael4JwFO3FvkcfAQA0ygTwxs=;
        b=mNytflcnoXuCs8IiRPnXYvDyR3rhOzSwHkfCamZmHh5C+9wBPL+OWZnI4ACmotADvt
         nkRHZEKEvCOeCwP7Hg/6bVgUdO5hJabWjReZsjEZW5JanndolH3cjpGK4WXtu5+lnyUF
         OJGldBUy/JKwC/kDUqYLkAWWC5I0oXcFWl770FRJe69IQcw2gnftZXWz8JyUtDelFoQO
         NAXD7b6PLQGk8x51M+UjPhjw9X10epCKUzCGBiMvQ0+b4qoQ2IKdDFFTXQdlsr5r7rFE
         0oz7esXyqtmQYGe+CTimsCq/RHK7itf95EiHDS2kwVYngJxNXxV8TWrCprgkH+PDiTV3
         M+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678169269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NaaJ5mwp2B7vcZxepa8ael4JwFO3FvkcfAQA0ygTwxs=;
        b=11RmVZnpvQUNERJUypiewekoRoaLhRRqe9FwuxaqYP4ov/xXPydBgcU/OR2WjNLH3U
         9DLQyVbhnCnUWSgrl45rD1MxbpnHnjkeYPwYUiGW/plth95ggSG+/q9uYOa5Inu5Dpde
         sD21dqzbemmDfOzwa6sY6DQ9cou3XnHJCABCe3B7CO08jFoL0ErXcxCGNQ0s75Z+5ZuK
         Rw6DhfXVAWa3oPyBhzyICiOGBJcxN4C/zRvIa9jvd891ofBqq4+aWaWSCtLYtdOnRnS+
         Sb01EwQSEVUQNoXyvttaqB7hwWjwAVUlQV/c3hw/v934Uye/G6CPO5BjoRzekUM20Jd5
         Bulw==
X-Gm-Message-State: AO0yUKXW6n7qeuzcmLz9Kan2NgYbD6L6wBafzAtcy7yeeYq8NWjNG2Rv
        nFWU1TUO4T9DaSZdUJgB6sE=
X-Google-Smtp-Source: AK7set9hxHeh9sazqSlyf+hBXCxINb64stdSubzvzrbRx4sTUJKOCsLZhjebVa+SFeEIIjaJjt92jg==
X-Received: by 2002:a17:906:a08f:b0:8f8:35c2:1357 with SMTP id q15-20020a170906a08f00b008f835c21357mr11938387ejy.23.1678169269288;
        Mon, 06 Mar 2023 22:07:49 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id n8-20020a17090695c800b008c76facbbf7sm5636760ejy.171.2023.03.06.22.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 22:07:48 -0800 (PST)
Message-ID: <dcebc99b-0e30-773f-3ae9-209463939751@gmail.com>
Date:   Tue, 7 Mar 2023 08:07:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH][next] net/mlx4_en: Replace fake flex-array with
 flexible-array member
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <ZAZ8mNbphtPyZWM6@work>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <ZAZ8mNbphtPyZWM6@work>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/03/2023 1:51, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Transform zero-length array into flexible-array member in struct
> mlx4_en_rx_desc.
> 
> Address the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> drivers/net/ethernet/mellanox/mlx4/en_rx.c:88:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
> drivers/net/ethernet/mellanox/mlx4/en_rx.c:149:30: warning: array subscript 0 is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
> drivers/net/ethernet/mellanox/mlx4/en_rx.c:127:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
> drivers/net/ethernet/mellanox/mlx4/en_rx.c:128:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
> drivers/net/ethernet/mellanox/mlx4/en_rx.c:129:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
> drivers/net/ethernet/mellanox/mlx4/en_rx.c:117:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
> drivers/net/ethernet/mellanox/mlx4/en_rx.c:119:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/264
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> index 544e09b97483..034733b13b1a 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> @@ -323,7 +323,7 @@ struct mlx4_en_tx_ring {
>   
>   struct mlx4_en_rx_desc {
>   	/* actual number of entries depends on rx ring stride */
> -	struct mlx4_wqe_data_seg data[0];
> +	DECLARE_FLEX_ARRAY(struct mlx4_wqe_data_seg, data);
>   };
>   
>   struct mlx4_en_rx_ring {

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
