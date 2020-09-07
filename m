Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA42825FCD4
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgIGPRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730152AbgIGPRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:17:08 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F182DC061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 08:07:08 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id ay8so13086816edb.8
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 08:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XxcidO8a+cinJq3hmwByDbolPQmkAkMTZXQIbSdXVHo=;
        b=JwCUzCxYZpnniVuXgc0XE+9Ctb8F7Rof6IBnPXAFlQ4iG7m9CpTgS0vqjUatRzgSy7
         85uMzvIt8naJC8pHuvjdc77iwjh10lqDTAns1cS1qj4V6Upl8iq9mnzD1V1iUm+hEQCA
         qL5e8OkMxIw9cjeuqx0qNEQnfU4xRit8JcLch8HdflzAuuFAhwwRJFPEGPJ+sjkv4yzI
         7by0gPVUgUKHA5ShrO9eVq97r0pdtx7MKMjfrLs5hQ/oENZxpx2vJq4pp4QVt8xZ2ScT
         iEtTmU4bbZkSQmDCQBJ+mb9Inm9pZh84ZT8gz0DwiooZYRuukPSMXmxvyW0mr0ht5WgG
         n/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XxcidO8a+cinJq3hmwByDbolPQmkAkMTZXQIbSdXVHo=;
        b=n6PWco6aAWZJIMAfenfuaafQ5z67UJx2xdhFLfI4DDpwl39L5cEbAXDZMGzDUxq2CT
         CwxB9LJKU8N6e71+XtXSuUB0njL25j86COFSnvN1xJ8QiiU4KQcLlIEXnCox6dQHq/oH
         jEW4NXPxcrQ5d2bNTT2xSiR4LuLyGv/yAFimMPDLPzmkxutoIeoPja2PQIey5RSe4MHv
         6XVjsP/rvOslaQLMy2uQJQj8qQfwhhd8xOCX6ikbPGo7IdV3vhrQYayiYFgS0UzfBKpp
         oj2hzYOwnMCkxoasKMHMuQ+3ICMEztTtBEhv9WjgpuUc/vKuH1Ytrq60VAFZkfsqZbi3
         85Lg==
X-Gm-Message-State: AOAM531LzYdDGtU6uN3ip1k+M0hdR8saZ8REhDAETnzCazXiICLLX0UF
        viPRguzi7W4YzTv32cpz7zdyBw==
X-Google-Smtp-Source: ABdhPJwUYtu5Wh4wP00EeoH9Nc/nnekbcAB308ysGJIKxnvaJOGwL647SZ9eyrk9dI+ksoBfrfmlnw==
X-Received: by 2002:a05:6402:1d0f:: with SMTP id dg15mr23107770edb.342.1599491227444;
        Mon, 07 Sep 2020 08:07:07 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:8ddf:bedd:580e:7a7e])
        by smtp.gmail.com with ESMTPSA id r9sm2634939eji.111.2020.09.07.08.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 08:07:06 -0700 (PDT)
Subject: Re: [MPTCP][PATCH net 1/2] mptcp: fix subflow's local_id issues
To:     Geliang Tang <geliangtang@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
References: <f24ee917e4043d2befe2a0f96cd57aa74d2a4b26.1599474422.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <16c012eb-7bf9-2606-5a60-d43c2579873b@tessares.net>
Date:   Mon, 7 Sep 2020 17:07:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f24ee917e4043d2befe2a0f96cd57aa74d2a4b26.1599474422.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 07/09/2020 12:29, Geliang Tang wrote:
> In mptcp_pm_nl_get_local_id, skc_local is the same as msk_local, so it
> always return 0. Thus every subflow's local_id is 0. It's incorrect.
> 
> This patch fixed this issue.
> 
> Also, we need to ignore the zero address here, like 0.0.0.0 in IPv4. When
> we use the zero address as a local address, it means that we can use any
> one of the local addresses. The zero address is not a new address, we don't
> need to add it to PM, so this patch added a new function address_zero to
> check whether an address is the zero address, if it is, we ignore this
> address.

Thank you for this patch!

As any patch for -net, may you add a "Fixes:" tag please?

(Also, I don't know if it is normal but I didn't receive the cover-letter)

(...)

> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 2c208d2e65cd..dc2c57860d2d 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -66,6 +66,19 @@ static bool addresses_equal(const struct mptcp_addr_info *a,
>   	return a->port == b->port;
>   }
>   
> +static bool address_zero(const struct mptcp_addr_info *addr)
> +{
> +	struct mptcp_addr_info zero;
> +
> +	memset(&zero, 0, sizeof(zero));
> +	zero.family = addr->family;
> +
> +	if (addresses_equal(addr, &zero, false))

Small detail: here you can simply have:

   return addresses_equal(addr, &zero, false);

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
