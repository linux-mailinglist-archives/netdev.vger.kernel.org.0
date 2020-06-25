Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB18F209E73
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 14:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404690AbgFYM3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 08:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404343AbgFYM3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 08:29:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA46AC061573
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 05:29:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so5619426wrs.11
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 05:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=73iKzUgDyHRFOj3NbLKG7YPlDqRRtV15fke3CQiuJfI=;
        b=gPUr7u36+aH0aCuOPahh1xa2NR9f02BdGBGmt8l0Qm6CDd93hgqKl8fbMz4LzLnWTW
         7EaqlYMhuoY/rJExsrUKq7cNazb+Z0kdh54BPibiklnZC6SjI3IBYymPT0EROb4wzs/R
         Ni44bPaeW9I6bmuqH1rgkgZaIceENJ8jOo22w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=73iKzUgDyHRFOj3NbLKG7YPlDqRRtV15fke3CQiuJfI=;
        b=FfKHmp9AeIHQI7pjwZmwGiEgYjfNqplG5xiHGhG4qRXgmHbapwTpBLjn7k9ESG84/k
         Dj+bdGxaxIoifVBSqNyIbvwwypVGwQT/OuFSpHuZ9fYid6D748B7XL8OFriozEJKw/Xu
         ZRpfPg70ZKnsZwinks7aunvYj/Sj5dhLaPb6uCPXDVG+0Eq41f70OLpH5iRogQUtXODl
         al+/kDTxEkJpAQZCLZFHTy9yX3/xdhQf+FSnq14FOrb5GmzIPTLkTTe3pBf0hNVgp4Tr
         6RSQ0pPb7/7dTAEXZXPyU23n0erzJr3ofHSE0WQvhPq94D+iOypwubE84g7SNVpOASjT
         g5TA==
X-Gm-Message-State: AOAM530j4/383KA+VFOwJBYON9LH9HGqTxohXYhqt7u47KOdL3OR+EK2
        H+JW976NijxKBkGt69bvGAXvzA==
X-Google-Smtp-Source: ABdhPJx6WqTOiXIuWAdOE8mQlOoWpWFYaMTzG3e54xLGnt55TmAFnKDcXnP7TtLJ/asjtqo0GTCdzw==
X-Received: by 2002:adf:82f5:: with SMTP id 108mr9369379wrc.218.1593088160490;
        Thu, 25 Jun 2020 05:29:20 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id k185sm8990373wmk.47.2020.06.25.05.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 05:29:19 -0700 (PDT)
Subject: Re: [PATCH v2] net: bridge: enfore alignment for ethernet address
To:     Thomas Martitz <t.martitz@avm.de>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        stable@vger.kernel.org
References: <20200625065407.1196147-1-t.martitz@avm.de>
 <20200625122602.2582222-1-t.martitz@avm.de>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <2a4836c4-76ab-6fb2-0474-b74f0087047c@cumulusnetworks.com>
Date:   Thu, 25 Jun 2020 15:29:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200625122602.2582222-1-t.martitz@avm.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/06/2020 15:26, Thomas Martitz wrote:
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
> index 7501be4eeba0..2130fe0194e6 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -217,8 +217,8 @@ struct net_bridge_port_group {
>  	struct rcu_head			rcu;
>  	struct timer_list		timer;
>  	struct br_ip			addr;
> +	unsigned char			eth_addr[ETH_ALEN] __aligned(2);
>  	unsigned char			flags;
> -	unsigned char			eth_addr[ETH_ALEN];
>  };
>  
>  struct net_bridge_mdb_entry {
> 

Thanks!
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
