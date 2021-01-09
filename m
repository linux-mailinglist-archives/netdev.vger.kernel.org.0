Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81842F03A9
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 22:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAIVBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 16:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:32840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAIVBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 16:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA60323AC4;
        Sat,  9 Jan 2021 21:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610226031;
        bh=yqI9vg0160hp8Dql4BtSfSsA+K9HjTlYgnfKGH2cuaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LXZUbUzuVSenP6ejtAkeO3F1uvlQlHG+3NWskawhBp61lxXcI3N37UJk5zSsuxYk2
         nWpihGKfPf8U+CalTCcMZgkd5EvjdrZUNnfYkxr/H0EaU4daPLaLdpv0OR0GEYtlse
         OwHr9yAYJKdZBfFfjk5GBDYp6Fi4QQkRcIVZertv9YRt8B4rJZfmulHra8EQV1Hp7J
         yPdYEUBzzgJ8W4adHUix8lAggfrmAb6w9iH0HsPceWn3Sk3YzjGRvPQWx3urlfire1
         NVQWzkT8N3CorrhVyLBIzw0oG5mW7WSo2lF6tqDCArH3OdJEyMH7tpCgXwz/ZSBmmF
         UQ5L6JQSPvMhA==
Date:   Sat, 9 Jan 2021 13:00:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv6: warning: %u in format string (no. 2) requires
 'unsigned int' but the argument type is 'signed int'.
Message-ID: <20210109130030.733e8bb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1609987654-11647-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1609987654-11647-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 10:47:34 +0800 Jiapeng Zhong wrote:
> The print format of this parameter does not match, because it is defined
> as int type, so modify the matching format of this parameter to %d format.
> 
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>
> ---
>  net/ipv6/proc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
> index d6306aa..26c702b 100644
> --- a/net/ipv6/proc.c
> +++ b/net/ipv6/proc.c
> @@ -169,7 +169,7 @@ static void snmp6_seq_show_icmpv6msg(struct seq_file *seq, atomic_long_t *smib)
>  		val = atomic_long_read(smib + i);
>  		if (!val)
>  			continue;
> -		snprintf(name, sizeof(name), "Icmp6%sType%u",
> +		snprintf(name, sizeof(name), "Icmp6%sType%d",
>  			i & 0x100 ?  "Out" : "In", i & 0xff);
>  		seq_printf(seq, "%-32s\t%lu\n", name, val);
>  	}

Type can't be negative, there is no reason for @i to be signed.
Changing type of @i sounds like a better idea.
