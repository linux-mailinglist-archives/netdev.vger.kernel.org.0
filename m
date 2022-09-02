Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4815AA781
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 08:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbiIBGB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 02:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiIBGBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 02:01:32 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD946B652;
        Thu,  1 Sep 2022 23:01:28 -0700 (PDT)
Received: from [IPV6:2003:e9:d723:a53:a87:bbea:b9b2:796d] (p200300e9d7230a530a87bbeab9b2796d.dip0.t-ipconnect.de [IPv6:2003:e9:d723:a53:a87:bbea:b9b2:796d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 443C4C01ED;
        Fri,  2 Sep 2022 08:01:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1662098485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MdOZ1vsB6OCK/vj/I0U9SyTJCVUbgrAMu9qs/M7WtbM=;
        b=tPHYreDveRTprGUTe/84B103lAC4UJZKujfFiG3gCM9OwuO9F1vqsilCxu+nHAqg9QyNl3
        7xDQMd3t0FiUDLXQ9fQ0SHbmqzCkZiisV6tqSVJpyKQw59hvPgaNEX00UfSXBBKJz/KTjT
        FKJ8J29bD4fKcWL4ALCiMbbUY5OO2Ivhyq4JsupVm0cNtLFGmZg4084Mr5c55FL7I41oMR
        XpZpwoF3kuR1Bi7nsUzsyXJH3Q9J023toto3cMQ5V6Cf9FOGyO13P2UoYUUY8/CQjDlWFM
        /ldcvU7N4NKmZDTzFhJMgKkrBa0a/dk1Nm/AuyYR0LY0YyKmAlU9Ye5lnVQHDg==
Message-ID: <86260887-5027-aa75-5c64-015d3e0623bf@datenfreihafen.org>
Date:   Fri, 2 Sep 2022 08:01:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        leon@kernel.org, sudipm.mukherjee@gmail.com,
        Gal Pressman <gal@nvidia.com>, alex.aring@gmail.com,
        paul@paul-moore.com, linux-wpan@vger.kernel.org
References: <20220902030620.2737091-1-kuba@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220902030620.2737091-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Jabkub.

On 02.09.22 05:06, Jakub Kicinski wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> When CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled,
> NL802154_CMD_DEL_SEC_LEVEL is undefined and results in a compilation
> error:
> net/ieee802154/nl802154.c:2503:19: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
>   2503 |  .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
>        |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
>        |                   NL802154_CMD_SET_CCA_ED_LEVEL
> 
> Unhide the experimental commands, having them defined in an enum
> makes no difference.
> 
> Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v1: /tmp/0001-net-ieee802154-Fix-compilation-error-when-CONFIG_IEE.patch
> v2: unhide instead of changing the define used
> 
> CC: alex.aring@gmail.com
> CC: stefan@datenfreihafen.org
> CC: paul@paul-moore.com
> CC: linux-wpan@vger.kernel.org
> ---
>   include/net/nl802154.h | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> index 145acb8f2509..f5850b569c52 100644
> --- a/include/net/nl802154.h
> +++ b/include/net/nl802154.h
> @@ -58,9 +58,6 @@ enum nl802154_commands {
>   
>   	NL802154_CMD_SET_WPAN_PHY_NETNS,
>   
> -	/* add new commands above here */
> -
> -#ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
>   	NL802154_CMD_SET_SEC_PARAMS,
>   	NL802154_CMD_GET_SEC_KEY,		/* can dump */
>   	NL802154_CMD_NEW_SEC_KEY,
> @@ -74,7 +71,8 @@ enum nl802154_commands {
>   	NL802154_CMD_GET_SEC_LEVEL,		/* can dump */
>   	NL802154_CMD_NEW_SEC_LEVEL,
>   	NL802154_CMD_DEL_SEC_LEVEL,
> -#endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
> +
> +	/* add new commands above here */
>   
>   	/* used to define NL802154_CMD_MAX below */
>   	__NL802154_CMD_AFTER_LAST,


Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

Thanks for handling this! I will simply ack it as I assume you will take 
it directly instead of me taking it through my tree and adding delays.

regards
Stefan Schmidt
