Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA5620F8F8
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 17:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389820AbgF3P5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 11:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730478AbgF3P5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 11:57:17 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B22AC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 08:57:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j12so9595968pfn.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 08:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eHFecfuBTnSHKQrrpNWliNJAbNKXJIY0nzYCS+o9aV8=;
        b=bIMaiKPY3B+9krvbyX8cOOWUqkRKRuQAilOsXjD7UhVdTQ2vw2pNUGgbje6p89lqpD
         ktxsEmai7d4EiqPy7BTmzYLEM/PIGPp2JJ5GboXRK4aCpdgfjObqhlo4vpYRDQ41OAWd
         1tN1Uukr+E3j5Bu8VX9Rn6VFBk88iwsc7pFstWE9CjXFP+EAwQS/CQd3YVIvqjyDOqLt
         Bz8+XRz/g01604XX95RrMrNtww1jibFk709Cj9HyZFwCxHM99Db4i1u0GcaHpRwgCu6S
         Gz7em1lDxOMAa7Uy/MJTxb3OYCfCwkce7yUVsU40D2lWZRRsaHIMpNVTh8MixSWoyIPy
         XV+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eHFecfuBTnSHKQrrpNWliNJAbNKXJIY0nzYCS+o9aV8=;
        b=Yrg3imbGHf/k5wbfVKrlbQ3KfcFkMDpwKCl4siPdbC/tdy+SLiIOO+Z3K/cmzcmz5w
         svlz8SPlmYIrXbcc/vlinZIsqL8+raeB5V+GktrrwNsA+/2SpIWqGayjTjyV+aCAWCtV
         AE6iV2Ei/RpIfZ8lMm7F2JF3W5WNRwc0PMKlWZGcbJq109ztUXIRMrbYySgoKYF3OJwO
         M+xAnvg/XmNXP93Bnzyo8i+KqXBZ1hTep/I0nfK0zJNNsfTa/21utdRrXpLJGUReEbnM
         EWQ6Kae7UiGcrzpBnKfCfZOZMquVlGOPw4UU5K3IHqbbBoJWBaa+hmZYe2xPxaD6GEY1
         b5zA==
X-Gm-Message-State: AOAM531IhwfFnVMrpFtSA1WJxogUwM6XvQSp3N/Nj0FRtSyWu8eV1HPu
        rzqY65RM02hDz6Ujgv62iTCJuOnZ
X-Google-Smtp-Source: ABdhPJy5BonEj1vBTctmWsYeAuGUyEcuHgNh7sVuzbgRLgDT32Lti+SWsmBLI6d6IM5cyJYLqJ09HQ==
X-Received: by 2002:a63:d74c:: with SMTP id w12mr15920268pgi.260.1593532635497;
        Tue, 30 Jun 2020 08:57:15 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j2sm2721928pjf.4.2020.06.30.08.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 08:57:14 -0700 (PDT)
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     wenxu@ucloud.cn, paulb@mellanox.com
Cc:     netdev@vger.kernel.org
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b01df9df-4b46-ea62-9591-66c720a2a4ab@gmail.com>
Date:   Tue, 30 Jun 2020 08:57:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/20 7:54 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The fragment packets do defrag in act_ct module. The reassembled packet
> over the mtu in the act_mirred. This big packet should be fragmented
> to send out.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> This patch is based on
> http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/
> 
>  include/net/sch_generic.h |   6 +-
>  net/sched/act_ct.c        |   7 ++-
>  net/sched/act_mirred.c    | 157 ++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 158 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index c510b03..3597244 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -384,6 +384,7 @@ struct qdisc_skb_cb {
>  	};
>  #define QDISC_CB_PRIV_LEN 20
>  	unsigned char		data[QDISC_CB_PRIV_LEN];
> +	u16			mru;
>  };
> 


Wow, this change is potentially a big problem.

Explain why act_ct/act_mirred need to pollute qdisc_skb_cb 


