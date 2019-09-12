Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49E8B1647
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfILW0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:26:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33211 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfILW0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:26:50 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so14219507pgn.0
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 15:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=8zVuqLLArCNDyf90ouh2+klGJ4O2EK7fvOsS/SJaVq0=;
        b=w4y0ptvcmvhfLt83WlIsgBz8iRVI6iptwN1C6FCjOJImSxJEFvedU+jNhwIJiWhimU
         ldzO7QhNOMX7scGwOZdsguCrfs4BoOMNJta6rgjf6arnI1MWljNSyIlzvH0qVE547L+I
         StQI57RdgyoEymEU8f6j70927EbeTCMzThSqx/0E51CwB8/QM/Puj9T8hvgtCNJyUOPo
         Gts1SXIi7s9LOvNNpsknzL8xaDL7nRWl2kM/WdNCjRGZJ21OTH5l8tJJqfokq0EwKl/E
         cjkSHcd9n927jKXvE3BE86Ah/hzc2kTWf2GPDGkUtYMuzA9xgr8AD7tbTgWUDvFoKxAV
         8vHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8zVuqLLArCNDyf90ouh2+klGJ4O2EK7fvOsS/SJaVq0=;
        b=rkAu2lfDqqHXYShjknr3P48D/YPX6FtrI84AHarC1DhJJ2ZYEb5ZQgxnO3yCpVXH3P
         gzYXUleoCxsIVBVd6AdX01OF6UVQKeLEH5jKiyxB09uutBOwCF3/WuE5gEjlO4NYIU+g
         LfMk/4w/uYBIMDHuJkNLR0ui1USQ/072PB0XcjbWRzDO2Teidrdtw4WtwPUclwXWo6ad
         g9gFbAzCkykmlejUKTY4vxBXNMmaZNvxf6Zqg0tM7ps1s+Go3kBo3lcEotYAhBMTRPyJ
         6NyvdliLLRt9m8zEk9xQgD7d/F8lwRk6O2zB6Xf7QyjlURvbkmLsk68odEKKiZwigoya
         UW8w==
X-Gm-Message-State: APjAAAW/dn1cO8RvoTq1G9uogF4YLUyHnQGhslA7jraiyJD+jkDboOOz
        NOmz1uuDFDKJMA4aWCrLZ552cbb4JAzAMBqJ
X-Google-Smtp-Source: APXvYqxLQxf5Wc+bYpDvGOaEcSIfo5Oy9g+/mZbpbcQchsM6pwQmIrgmK2rmWqZ/DoQDAa66Lg0eYg==
X-Received: by 2002:a17:90a:db53:: with SMTP id u19mr1071782pjx.39.1568327209431;
        Thu, 12 Sep 2019 15:26:49 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id s7sm289490pjn.8.2019.09.12.15.26.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 15:26:48 -0700 (PDT)
Subject: Re: [net] ixgbevf: Fix secpath usage for IPsec Tx offload
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org
Cc:     Jonathan Tooker <jonathan@reliablehosting.com>
References: <20190912190734.10560-1-jeffrey.t.kirsher@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <15ee31e8-11e7-59e4-97ae-75f3fe6daa89@pensando.io>
Date:   Thu, 12 Sep 2019 23:26:45 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190912190734.10560-1-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/19 8:07 PM, Jeff Kirsher wrote:
> Port the same fix for ixgbe to ixgbevf.
>
> The ixgbevf driver currently does IPsec Tx offloading
> based on an existing secpath. However, the secpath
> can also come from the Rx side, in this case it is
> misinterpreted for Tx offload and the packets are
> dropped with a "bad sa_idx" error. Fix this by using
> the xfrm_offload() function to test for Tx offload.
>
> CC: Shannon Nelson <snelson@pensando.io>
> Fixes: 7f68d4306701 ("ixgbevf: enable VF IPsec offload operations")
> Reported-by: Jonathan Tooker <jonathan@reliablehosting.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>   drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index d2b41f9f87f8..72872d6ca80c 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -30,6 +30,7 @@
>   #include <linux/bpf.h>
>   #include <linux/bpf_trace.h>
>   #include <linux/atomic.h>
> +#include <net/xfrm.h>
>   
>   #include "ixgbevf.h"
>   
> @@ -4161,7 +4162,7 @@ static int ixgbevf_xmit_frame_ring(struct sk_buff *skb,
>   	first->protocol = vlan_get_protocol(skb);
>   
>   #ifdef CONFIG_IXGBEVF_IPSEC
> -	if (secpath_exists(skb) && !ixgbevf_ipsec_tx(tx_ring, first, &ipsec_tx))
> +	if (xfrm_offload(skb) && !ixgbevf_ipsec_tx(tx_ring, first, &ipsec_tx))
>   		goto out_drop;
>   #endif
>   	tso = ixgbevf_tso(tx_ring, first, &hdr_len, &ipsec_tx);

Acked-by: Shannon Nelson <snelson@pensando.io>

