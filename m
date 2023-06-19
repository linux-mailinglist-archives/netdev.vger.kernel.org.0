Return-Path: <netdev+bounces-11909-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 542ED73517D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A1BA1C20941
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73BB7C2FE;
	Mon, 19 Jun 2023 10:07:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7A4C14A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:07:00 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD881A4;
	Mon, 19 Jun 2023 03:06:57 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f90bff0f27so9162675e9.1;
        Mon, 19 Jun 2023 03:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687169216; x=1689761216;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U23/xHV0ei4EVImWKttlfTqd/TatZwJhK0xVsnWuDjA=;
        b=ADSCIZGPx24tiejtP/uZ/mGtHXDzDbI2ms1INdvNTBRjElD4K1b83zP4Uji2Lj9isz
         KLrEHAwROOxOEWBz+F2G6tO6zkty8Trk882UbKNfRjdICMENZlSnxewq/ppXfB0LudbB
         lJzMTEhxCnhuGW41Y430O95bGRrGiBx+z922GktosqOhn1HNyPv9IoX1U2bIG+TC00Gc
         eyuMhWBXcGrekphvLuHj9m9wcmgRErfiRvepDgcyA9g+AKhmeNcFBB8cYvDazYYskgRq
         u/bijV8S60lKgKyG/BZwARndnwvwX/VRBZyazgw3saLwk7XgIFTSOxAqSjx2qkJyikx5
         oL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687169216; x=1689761216;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U23/xHV0ei4EVImWKttlfTqd/TatZwJhK0xVsnWuDjA=;
        b=dusQyXvBtLgFotnJdGZeHKSamZze3ZkzB3sPs4pGkB4irBJce1po0Smz0+2O8i26Yo
         Vdt+dgYFy8A1y7sltWJz6nitzipw0VXssycV6U02UB1nnsSVI20BPcLDRA5EKnb6OVP0
         NhdY/IWoH/lGBNgLnT295eOnXkFB6dX09QE88+jTq1AU79ku6baGyTJPz7wXaFVBrixj
         LuCrtFuNtYEqFymGpADdn+6UHdJTICLKjWtFx2Q+rFLV5p/O77XPj35q6ztKzGNq5Hup
         kKYaUbWB6lRaQkkb+RpU2vaipcx4LyGKA9Ob95EfGEmx7nW4Salybs2K7YBB+9/mR78C
         Jrrg==
X-Gm-Message-State: AC+VfDwTeYIVrDlZlmFE2/8qj7LHNmkJLQLexgne6L3b0BmLi070Ol3j
	5W+KoaHV7ADt2qLgbolbuOuMznHgOJI=
X-Google-Smtp-Source: ACHHUZ7z6iuKuUnrA5k+PAkGFpJuuB9ubkfTktqQjWv2rJzK3DZCpnf3Xg+bpXyLcCWHp4uS2AlXTQ==
X-Received: by 2002:a7b:c356:0:b0:3f8:f6fe:26bf with SMTP id l22-20020a7bc356000000b003f8f6fe26bfmr5938053wmj.12.1687169216104;
        Mon, 19 Jun 2023 03:06:56 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id q1-20020a7bce81000000b003f819faff24sm10168164wmj.40.2023.06.19.03.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 03:06:55 -0700 (PDT)
Subject: Re: [PATCH 2/3] [v2] sfc: fix uninitialized variable use
To: Arnd Bergmann <arnd@kernel.org>, Martin Habets
 <habetsm.xilinx@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
 Simon Horman <simon.horman@corigine.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
 linux-net-drivers@amd.com, linux-kernel@vger.kernel.org
References: <20230619091215.2731541-1-arnd@kernel.org>
 <20230619091215.2731541-2-arnd@kernel.org>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <01bad0cf-f67c-3357-d373-cd2b46e26a90@gmail.com>
Date: Mon, 19 Jun 2023 11:06:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230619091215.2731541-2-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 19/06/2023 10:12, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The new efx_bind_neigh() function contains a broken code path when IPV6 is
> disabled:
> 
> drivers/net/ethernet/sfc/tc_encap_actions.c:144:7: error: variable 'n' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>                 if (encap->type & EFX_ENCAP_FLAG_IPV6) {
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/sfc/tc_encap_actions.c:184:8: note: uninitialized use occurs here
>                 if (!n) {
>                      ^
> drivers/net/ethernet/sfc/tc_encap_actions.c:144:3: note: remove the 'if' if its condition is always false
>                 if (encap->type & EFX_ENCAP_FLAG_IPV6) {
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/sfc/tc_encap_actions.c:141:22: note: initialize the variable 'n' to silence this warning
>                 struct neighbour *n;
>                                    ^
>                                     = NULL
> 
> Change it to use the existing error handling path here.
> 
> Fixes: 7e5e7d800011a ("sfc: neighbour lookup for TC encap action offload")
> Suggested-by: Edward Cree <ecree.xilinx@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>

> ---
> v2: use 'goto' instead of incorrectly entering another error path
> ---
>  drivers/net/ethernet/sfc/tc_encap_actions.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.c b/drivers/net/ethernet/sfc/tc_encap_actions.c
> index aac259528e73e..7e8bcdb222ad1 100644
> --- a/drivers/net/ethernet/sfc/tc_encap_actions.c
> +++ b/drivers/net/ethernet/sfc/tc_encap_actions.c
> @@ -164,6 +164,7 @@ static int efx_bind_neigh(struct efx_nic *efx,
>  			 */
>  			rc = -EOPNOTSUPP;
>  			NL_SET_ERR_MSG_MOD(extack, "No IPv6 support (neigh bind)");
> +			goto out_free;
>  #endif
>  		} else {
>  			rt = ip_route_output_key(net, &flow4);
> 


