Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE27209DD7
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404539AbgFYLyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404530AbgFYLyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:54:07 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AF6C061573
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:54:07 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 17so5628232wmo.1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A+8DNTwPTrqWV9XPKAnnx4MrDkAfz5yRU2Rp9COzdPI=;
        b=dxn3mon9w6eseYb+gRQ3Op7xYvzJMstrGkYMYGq9ssAiklqMjA6dIPlJzlAO8kTMOM
         7OfABoG7fcZguaTgR5jVnroL+UaRBunY42V9Ei8PFjS4N/R+i6yHPFXwU8Hl12ncM8EK
         TTIPMp9qQbZdqGqZhNpMUMPDgDgTWWOWo9MKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A+8DNTwPTrqWV9XPKAnnx4MrDkAfz5yRU2Rp9COzdPI=;
        b=BHdrI+uaLM44DoJ3lX3rVPK74Ek3WgrstMu5jZ4enVRHJiS/Rzhcs5J6/hF4JTlbN6
         ivWCGW2fGxlemA/HjneORHMfDpJjFUDTaSQ3O0RuiYxKrik/tD7KZnRHqalxmjE+62c4
         PCe5FFv4XKAEZeDu1bDx+f/TyM9UIqXfIpvcN/fO+1zexS+G7I05wGKBI1hfWe/QtDp9
         EF281a52CQHRXubgJ4KSIEXN8fpwl+7XGNK4NTEQe26wabgENtAoTD5/slhuBL3xusmW
         SPgv9yPnX8XjtGo4t39Z1Wsz7CYS/fDZLxUzLT9qDwsZNKSUL37372OQRoBH4jb2NZDD
         Mzyw==
X-Gm-Message-State: AOAM533ZIvV+BR9yJhGt4/7x+J0fyruTemxwCVN+fNZz//P6iTifcDs/
        tcqkeiTiMXJhg7hc7g6sNC/XLA==
X-Google-Smtp-Source: ABdhPJwn+XSqv+8QmTLeaF/shei+HCIPInxytmOVyfHe2owPXKtIpbIHfDTy9bkg0qZARd/9cnuOYg==
X-Received: by 2002:a1c:7f81:: with SMTP id a123mr2952428wmd.107.1593086045745;
        Thu, 25 Jun 2020 04:54:05 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b17sm22128105wrp.32.2020.06.25.04.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 04:54:03 -0700 (PDT)
Subject: Re: [PATCH] net: bridge: enfore alignment for ethernet address
To:     Thomas Martitz <t.martitz@avm.de>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        stable@vger.kernel.org
References: <20200625065407.1196147-1-t.martitz@avm.de>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <b25f8e1c-2a45-b522-52d0-7628586b2ef8@cumulusnetworks.com>
Date:   Thu, 25 Jun 2020 14:54:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200625065407.1196147-1-t.martitz@avm.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/06/2020 09:54, Thomas Martitz wrote:
> The eth_addr member is passed to ether_addr functions that require
> 2-byte alignment, therefore the member must be properly aligned
> to avoid unaligned accesses.
> 
> The problem is in place since the initial merge of multicast to unicast:
> commit 6db6f0eae6052b70885562e1733896647ec1d807 bridge: multicast to unicast
> 
> Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Felix Fietkau <nbd@nbd.name>
> Cc: stable@vger.kernel.org
> Signed-off-by: Thomas Martitz <t.martitz@avm.de>
> ---
>  net/bridge/br_private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 7501be4eeba0..22cb2f1993ef 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -217,8 +217,8 @@ struct net_bridge_port_group {
>  	struct rcu_head			rcu;
>  	struct timer_list		timer;
>  	struct br_ip			addr;
> +	unsigned char			eth_addr[ETH_ALEN]; /* 2-byte aligned */
>  	unsigned char			flags;
> -	unsigned char			eth_addr[ETH_ALEN];
>  };
>  
>  struct net_bridge_mdb_entry {
> 

Hi Thomas,
To document it and guarantee that future struct changes won't break it I think
it'd be a good idea to add __aligned(2) for that member instead of the comment.

Other than that the patch looks good.

Thanks,
 Nik

