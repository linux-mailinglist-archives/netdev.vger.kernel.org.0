Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1775A955B5
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 05:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfHTDlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 23:41:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34184 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728647AbfHTDlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 23:41:04 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so2384646pgc.1
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2/2OuChhyTAqQ8PJvjO6U6+W19RzmJ8vLQvLTYGl5VI=;
        b=eZ02XPhd9KSSvgTRixodsKJZONnUsdFeK5S9ZQAOZnxVkIwRMROrI8WXI7qzZ8tTWx
         9H0HLG+bzJ1JJhJW1BCVHdF5/xsvTzmOZ6wAL9XcEzzfWGWMRz9eQtC5c3WfJDB5VP/w
         ca/DGZaMObpREyICKZQ3DZL0el6w6QirPMMKbgSnhy+La3bo9fqmly2yo9tXQtybVh+q
         fbSrRKkMIZMhI7PcbvWYUUQMRNuYMxGGHLgf64zH7DAdLY+90NCFzzmVCuvWRBNiiT2U
         R4FEOybHR2aVYqf/nv0CkJkb730So3Va8RL0dUjhVVDIRoMzSn5EkLPSdKWnRA6AfAnX
         K+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2/2OuChhyTAqQ8PJvjO6U6+W19RzmJ8vLQvLTYGl5VI=;
        b=cfxxzeYoyy1YMZwroYe2sxg3VkODnQx1CCjYeqwwKNjXj+N9XXtGGi7mtS75JLLDYn
         qtMTCya8sgXXSiwue1WxoATk6vP5VPaXthgOXIkfnPkVxEtp2OBqkMmcPMAbEv1QHb6X
         h109L8ifBpLukzPbcL0AO3m+wjsQZ3WsuwN0JHtl3v95tGCHmMl9rS1IiTcZN/TxqzQ7
         Bm5xAz+sN3c+cXj+8AGWwsALeO2UP/Uijqd9sfzPY39mpMFIFWRGGYJt1Q7uin3QIgHy
         6aUX+JQY+q8uzQJsUBu4XIktHIHFM49a7BefN8siTXGQsV/xqb/lU/D3Ug1zkEerBf91
         BP+A==
X-Gm-Message-State: APjAAAUtj/QkTVHVRRVPCbLCAdz9flCNbATDkjXATBDgvk9XfiZntvsO
        cWbCzW9IOR7P3ZU4VNtqN3Vkzb16
X-Google-Smtp-Source: APXvYqy7OWn5R2+EjK8KTbSAHaxa6SSim4NI33Q2s6F6oAHZElsZDNuGAGuZlN4oYK0gBsqMknuOcw==
X-Received: by 2002:a62:1858:: with SMTP id 85mr28170027pfy.120.1566272464241;
        Mon, 19 Aug 2019 20:41:04 -0700 (PDT)
Received: from [10.230.7.147] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id e9sm17283842pge.39.2019.08.19.20.41.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 20:41:03 -0700 (PDT)
Subject: Re: [PATCH] net: Fix __ip_mc_inc_group argument 3 input
To:     Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        Zhang Yu <zhangyu31@baidu.com>
References: <1566267933-30434-1-git-send-email-lirongqing@baidu.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <39691d93-4150-2d0f-2978-4c5c68c893eb@gmail.com>
Date:   Mon, 19 Aug 2019 20:41:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566267933-30434-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2019 7:25 PM, Li RongQing wrote:
> It expects gfp_t, but got unsigned int mode
> 
> Fixes: 6e2059b53f98 ("ipv4/igmp: init group mode as INCLUDE when join source group")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>

You have identified a problem, but I don't think it came from this
commit, rather from:

9fb20801dab4 ("net: Fix ip_mc_{dec,inc}_group allocation context")

see below for details.

> ---
>  net/ipv4/igmp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 180f6896b98b..b8352d716253 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -1475,7 +1475,7 @@ EXPORT_SYMBOL(__ip_mc_inc_group);
>  
>  void ip_mc_inc_group(struct in_device *in_dev, __be32 addr)
>  {
> -	__ip_mc_inc_group(in_dev, addr, MCAST_EXCLUDE);
> +	__ip_mc_inc_group(in_dev, addr, GFP_KERNEL);

That part looks fine.

>  }
>  EXPORT_SYMBOL(ip_mc_inc_group);
>  
> @@ -2197,7 +2197,7 @@ static int __ip_mc_join_group(struct sock *sk, struct ip_mreqn *imr,
>  	iml->sflist = NULL;
>  	iml->sfmode = mode;
>  	rcu_assign_pointer(inet->mc_list, iml);
> -	__ip_mc_inc_group(in_dev, addr, mode);
> +	__ip_mc_inc_group(in_dev, addr, GFP_KERNEL);

But here, we probably want to pass both mode and gfp_t and use
____ip_mc_inc_group(in_dev, addr, mode, GFP_KERNEL):

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 180f6896b98b..2459b5e3fd98 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2197,7 +2197,7 @@ static int __ip_mc_join_group(struct sock *sk,
struct ip_mreqn *imr,
        iml->sflist = NULL;
        iml->sfmode = mode;
        rcu_assign_pointer(inet->mc_list, iml);
-       __ip_mc_inc_group(in_dev, addr, mode);
+       ____ip_mc_inc_group(in_dev, addr, mode, GFP_KERNEL);
        err = 0;
 done:
        return err;

What do you think?
-- 
Florian
