Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44E462ECDB
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240833AbiKRE3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbiKRE3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:29:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B99A1ADAE;
        Thu, 17 Nov 2022 20:29:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81FE962308;
        Fri, 18 Nov 2022 04:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E46C433C1;
        Fri, 18 Nov 2022 04:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668745790;
        bh=mOMFpTq0wEGsUBY3eHX7t2CuNkWSUb9x9HDIWPh/G68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MUl75vX/jZrj9JXskHpLcLDqZjQ7XejdiKXXWoLT/OLQRRG18NsuRhhQpGyk+P7Vl
         sIVJf6Hp48eLdHrDx6OG7MNjISteFtYAzxi0zA+9VigXLqWMaWiVHzX5mlA69ZqmFm
         n2/SYvmszW9/FTDZm+or5iFKV6SBzBuSLyMtg0ZsYzgsBdXw83UUHUI8bzYFi5wV3A
         DQmNoIr964Ot6BUGE9/OlyBVwklMBcjnrDGvwFhuE6Vm8AE35md1ta0H1UwNcTL/7P
         k+jWEOyzKXlfzbAkZ1IGiqXu6sbAUw8vH3NEO3CX9xMpSRdwZ1F2B0v/kTqMcA22NK
         O4j1OZDTd/8jQ==
Date:   Thu, 17 Nov 2022 22:29:36 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] ipv4/fib: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <Y3cKMI/vq0wJOrCY@work>
References: <20221118042142.never.400-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118042142.never.400-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 08:21:52PM -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1] and are being replaced with
> flexible array members in support of the ongoing efforts to tighten the
> FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
> with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.
> 
> Replace zero-length array with flexible-array member in struct key_vector.
> 
> This results in no differences in binary output.
> 
> [1] https://github.com/KSPP/linux/issues/78
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  net/ipv4/fib_trie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 452ff177e4da..c88bf856c443 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -126,7 +126,7 @@ struct key_vector {
>  		/* This list pointer if valid if (pos | bits) == 0 (LEAF) */
>  		struct hlist_head leaf;
>  		/* This array is valid if (pos | bits) > 0 (TNODE) */
> -		struct key_vector __rcu *tnode[0];
> +		DECLARE_FLEX_ARRAY(struct key_vector __rcu *, tnode);
>  	};
>  };
>  
> -- 
> 2.34.1
> 
