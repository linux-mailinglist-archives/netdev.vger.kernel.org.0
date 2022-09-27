Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7055ECD1F
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiI0Tq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiI0Tqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:46:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253271B3490;
        Tue, 27 Sep 2022 12:46:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5E0D61B1F;
        Tue, 27 Sep 2022 19:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD93C433D6;
        Tue, 27 Sep 2022 19:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664308013;
        bh=e5aDBKk9NK4a1QWira1pG3Pp+doScKrC1ane/mpBN3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vHR+DB5QsrizGiSsJZYLaH8Bt36twqWRizKrEcipq/mH5ylFlLP/JfyTbKjwRgEVU
         Hv/hDy+wB1mer94r2Upk8FVHgZod9IzQwFKVVbvFWRDi80hl48GhsKe9YIyQHJFTWA
         9+zMDPiHZ6G34TfdaemGQvHV1Jfu1dtKWV/Af+wXQYhWUyzYEiZXy0SePk60zjZEcM
         JeHuJhLusgrvh7ZsixQzCv5BZdeOaywcpblMZcnMvkURpDrHKyItYu62lNMKtT2JRF
         ueWbQnxnevo2BcnALQQc6N7HKhvw80xBt7lhrxhqkJUZnF2bDWY3F34gomxsv3MEb9
         TGoZw9qT08oSQ==
Date:   Tue, 27 Sep 2022 14:46:47 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] wifi: nl80211: Split memcpy() of struct
 nl80211_wowlan_tcp_data_token flexible array
Message-ID: <YzNTJ4D8HyeIvSiR@work>
References: <20220927022923.1956205-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927022923.1956205-1-keescook@chromium.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 07:29:23PM -0700, Kees Cook wrote:
> To work around a misbehavior of the compiler's ability to see into
> composite flexible array structs (as detailed in the coming memcpy()
> hardening series[1]), split the memcpy() of the header and the payload
> so no false positive run-time overflow warning will be generated.
> 
> [1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org/
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
> v2: - fix typo leading "+" (Gustavo)
> v1: https://lore.kernel.org/lkml/20220927003903.1941873-1-keescook@chromium.org
> ---
>  net/wireless/nl80211.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 2705e3ee8fc4..169e3ec33466 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -13171,7 +13171,9 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
>  	       wake_mask_size);
>  	if (tok) {
>  		cfg->tokens_size = tokens_size;
> -		memcpy(&cfg->payload_tok, tok, sizeof(*tok) + tokens_size);
> +		cfg->payload_tok = *tok;
> +		memcpy(cfg->payload_tok.token_stream, tok->token_stream,
> +		       tokens_size);
>  	}
>  
>  	trig->tcp = cfg;
> -- 
> 2.34.1
> 
