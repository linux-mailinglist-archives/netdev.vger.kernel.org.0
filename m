Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437033EEEE9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbhHQPGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbhHQPGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 11:06:13 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC79C061764;
        Tue, 17 Aug 2021 08:05:40 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id r16-20020a0568304190b02904f26cead745so25244185otu.10;
        Tue, 17 Aug 2021 08:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QVfvljS9yxMRLzJtSOULzVoQt76MWkNy0TQqqNBW6Ig=;
        b=qhGKl1NxybX2OZInj1F15H7pPHUfQ4Dpbv/J38dZIdgu9nN6y5fjjBuZsWVD2SC5fB
         5bY+gkep8cKcRx0dwj3xV4232jYrbdKEwQoI98+dsQYIC/3FAawJ7t6s+gceuLHmVPTg
         YI6GkzMQTS2MfY8TDy9168Zsnxb4xnhHCj1NzSI+tA3MIWQDk5ejigGZavGI4/AgQuLd
         1yC6T2uJSHfKTBhO5y6E7JmQEkcl6hatqrZyj344WBxg9mO6TJoyCEngXkHYGiBaTMV3
         RdjIGF19V5OdMW+NzFIn4PRHJNZjQ83CI/giVjaHxizaHmfINZgqwQ8+eEHud/1NQY7N
         Cm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QVfvljS9yxMRLzJtSOULzVoQt76MWkNy0TQqqNBW6Ig=;
        b=gF9MG5tsfnDemQLkvUxXDzT8C+M1HMIUY2ugzBr+ztuLNG6xDtmczA+/ZEdPRGyzIv
         Unj4Xnq74wmUy7GFjixaAGFF8Y+qVAqlygP4D+NRNuDb8YDzSO4iOYlxYnWRvZ1cyN67
         j1GawdRtVj2lQN9/xSLEhaEHtB/BVf8fKxCyV8GMiNn0BiqnktwZSEhW0/WMvo5G0Dxs
         igpjASI0TXkoqlCsrS6U8GPK9rIpY6aUckBgpaP7CjW2TnAb28S+qZIC5ZO9Yix6iEyS
         bxgh8TmdCvo/dbX2bUUFK5b908j6cu03D1i/+p4lNKwzyhst1ndpwznt9qPuY39Iu8U5
         /v3w==
X-Gm-Message-State: AOAM532p+W5WPi4GSUBVyhXIgApAsbtw/C9YiI4Ojw7PeA9C3hgoZx82
        rh8Pt8hHm6bZ6iDeaEOPRU8=
X-Google-Smtp-Source: ABdhPJwbmBTJXUOlktACFWj/KDoKpiNsYfLOJ16DAofBaApV6Fzby8JQrRKv67PyndRVp7LHyDoxmw==
X-Received: by 2002:a05:6830:236d:: with SMTP id r13mr3040332oth.130.1629212739821;
        Tue, 17 Aug 2021 08:05:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.6.112.214])
        by smtp.googlemail.com with ESMTPSA id u14sm425086oth.73.2021.08.17.08.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 08:05:39 -0700 (PDT)
Subject: Re: [PATCH net-next v4] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20210817072609.2110-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ad32c931-3056-cdef-4b9b-aab654c61cb9@gmail.com>
Date:   Tue, 17 Aug 2021 09:05:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817072609.2110-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/21 1:26 AM, Rocco Yue wrote:
> @@ -1496,6 +1490,11 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>  		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
>  		mtu = ntohl(n);
>  
> +		if (in6_dev->ra_mtu != mtu) {
> +			in6_dev->ra_mtu = mtu;
> +			send_ifinfo_notify = true;
> +		}
> +
>  		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
>  			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
>  		} else if (in6_dev->cnf.mtu6 != mtu) {


If an RA no longer carries an MTU or if accept_ra_mtu is reset, then
in6_dev->ra_mtu should be reset to 0 right?

rest of the change looks good to me.
