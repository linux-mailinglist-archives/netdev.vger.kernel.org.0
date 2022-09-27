Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B12B5EB6AB
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 03:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiI0BKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 21:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiI0BKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 21:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C94895FC;
        Mon, 26 Sep 2022 18:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 782C5614AE;
        Tue, 27 Sep 2022 01:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338EAC433D6;
        Tue, 27 Sep 2022 01:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664241019;
        bh=j62kZQvZjX2MamKzJ/+2NC/9HEZsfcjCjPmXppmw/ak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CRuS58M9M+FfroV0sQPqfmHUUVvXOqFwVGgzs32D9um7RsRmxhFQ7Nv82cFf+4sY1
         1gjxMKqjMZ2snLZfN6iuHQm4ZBS8aiS7Yie8dghI4kv6BMe+da/eVcasQTwMVIBNYh
         4n1+N9/vsEuehVP17xTUkJZLMVffj+rlYZudbfp3DJAZWrswhbZLmYHAKaTe3eedTo
         NeyqB3EKIzH4QjQmCg5SVxPGDWUe8uSKetVJ/bNUnCzrjxJm++JsgeW+EXsk784w4m
         t+z1nEO+ciQVGm8N9W8mG+Rwaa06WrYBfmrXnYncQTGuCQW9558/CHH0+cdYFgIgVl
         60AGILne4eOcQ==
Date:   Mon, 26 Sep 2022 20:10:11 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mlxsw: core_acl_flex_actions: Split memcpy() of struct
 flow_action_cookie flexible array
Message-ID: <YzJNc1P5c2lbD8vC@work>
References: <20220927004033.1942992-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927004033.1942992-1-keescook@chromium.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 05:40:33PM -0700, Kees Cook wrote:
> To work around a misbehavior of the compiler's ability to see into
> composite flexible array structs (as detailed in the coming memcpy()
> hardening series[1]), split the memcpy() of the header and the payload
> so no false positive run-time overflow warning will be generated.
> 
> [1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org
> 
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>


Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
> index 636db9a87457..9dfe7148199f 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
> @@ -737,8 +737,9 @@ mlxsw_afa_cookie_create(struct mlxsw_afa *mlxsw_afa,
>  	if (!cookie)
>  		return ERR_PTR(-ENOMEM);
>  	refcount_set(&cookie->ref_count, 1);
> -	memcpy(&cookie->fa_cookie, fa_cookie,
> -	       sizeof(*fa_cookie) + fa_cookie->cookie_len);
> +	cookie->fa_cookie = *fa_cookie;
> +	memcpy(cookie->fa_cookie.cookie, fa_cookie->cookie,
> +	       fa_cookie->cookie_len);
>  
>  	err = rhashtable_insert_fast(&mlxsw_afa->cookie_ht, &cookie->ht_node,
>  				     mlxsw_afa_cookie_ht_params);
> -- 
> 2.34.1
> 
