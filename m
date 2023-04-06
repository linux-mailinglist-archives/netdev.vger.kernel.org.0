Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC126D9291
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbjDFJV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbjDFJV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:21:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FBDD83;
        Thu,  6 Apr 2023 02:21:54 -0700 (PDT)
Date:   Thu, 6 Apr 2023 11:21:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chen Aotian <chenaotian2@163.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: Modify nla_memdup's flag to
 GFP_KERNEL_ACCOUNT
Message-ID: <ZC6PLsY0+WWW21wE@salvia>
References: <20230406040151.1676-1-chenaotian2@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230406040151.1676-1-chenaotian2@163.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 12:01:51PM +0800, Chen Aotian wrote:
> For memory alloc that store user data from nla[NFTA_OBJ_USERDATA], 
> use GFP_KERNEL_ACCOUNT is more suitable.
>

Fixes: 33758c891479 ("memcg: enable accounting for nft objects")

> Signed-off-by: Chen Aotian <chenaotian2@163.com>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 6004d4b24..cd52109e6 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -7052,7 +7052,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
>  	}
>  
>  	if (nla[NFTA_OBJ_USERDATA]) {
> -		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL);
> +		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL_ACCOUNT);
>  		if (obj->udata == NULL)
>  			goto err_userdata;
>  
> -- 
> 2.25.1
> 
