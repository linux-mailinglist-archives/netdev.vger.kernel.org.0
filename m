Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42FE2C2F75
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404090AbgKXSA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403986AbgKXSA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 13:00:56 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ADDC0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:00:54 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a3so3800954wmb.5
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=quZ9mzytGMGKlv+/n1KHmnf1ZpUXeaZpSJV8urgYtPA=;
        b=MOWhQomGNGoqgBG+SE0jIH+DSRylSW3glFRamCZQM8Fm5IzJmy0+r0Rg2TACukGMim
         6pSTfNAUgWSs+YOqzS58ih5LKcu1unowVUFRTWejOyUbMisQPJkHOM+pFCV5J+KmCMuz
         zfEg8/lZ36VmP7m5QjFZVQofsa/u3Q/kLd+valbWweuxuzwM2bl+b+gcMf/p9zzpspBw
         1gHjlRwXJvZ7AsD9oNRveLayGO/pinXiVUrOPgYo8fJJZ+ISocq5i0BRqE9ilGc+wizo
         54R1a1TQhNDd34N3089KGcG708mQdti2XpbpVK/XG/MnX8LoYOuXhAe711jF4ZeZfoCW
         dqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=quZ9mzytGMGKlv+/n1KHmnf1ZpUXeaZpSJV8urgYtPA=;
        b=G/Prlhz8aPvOEdlC/210qEo3lcZoUdALnjudfqOTIZixM9BOGvPOyOE2dFPngSvlhm
         59XSHXVVau1QFuSWADljX7xi4olA6ORqvLVGJXzBeVWHFGDIKqqwNxmDuon0nlpyw6Gg
         YUp2xhqQZTMZymRiIosBiTIbCaDEcKa7gA6xNBwDQLC7XaO66d7t2CMwu4Swz5mOH5mz
         /62kdCd3qqtnYl6kP1fnhoBrS3P5JAbJF7OP0AtqF4uxFC77PrYhGjRGwPpyMU1pKczW
         iOFInSoIYgwKsGEECZ0l0cQbobCGuTwI43mHDAy3oGByEdPikzLMHRbyYlRnctvmmnxf
         BO/Q==
X-Gm-Message-State: AOAM531TkujaYMscAJkZlsBUueGG73Sy4YS7RtbRS6PWrrWvCTCNQYVT
        i9QqvLgEdCEOB4FLuIW9LJc=
X-Google-Smtp-Source: ABdhPJxHl2J1FfbUWstBBsdTAJTuHX2Kb9rKqs1YAMLCrx8hKFQ7Z/qxex/qIYSKyg52Gwug3EDtYg==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr5560865wmk.108.1606240853449;
        Tue, 24 Nov 2020 10:00:53 -0800 (PST)
Received: from [192.168.8.114] ([37.166.80.220])
        by smtp.gmail.com with ESMTPSA id g186sm8012661wma.1.2020.11.24.10.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 10:00:52 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] net: remove napi_hash_del() from
 driver-facing API
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kernel-team@fb.com
References: <20200909173753.229124-1-kuba@kernel.org>
 <20200909173753.229124-2-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8735d11e-e734-2ba9-7ced-d047682f9f3e@gmail.com>
Date:   Tue, 24 Nov 2020 19:00:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20200909173753.229124-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/20 7:37 PM, Jakub Kicinski wrote:
> We allow drivers to call napi_hash_del() before calling
> netif_napi_del() to batch RCU grace periods. This makes
> the API asymmetric and leaks internal implementation details.
> Soon we will want the grace period to protect more than just
> the NAPI hash table.
> 
> Restructure the API and have drivers call a new function -
> __netif_napi_del() if they want to take care of RCU waits.
> 
> Note that only core was checking the return status from
> napi_hash_del() so the new helper does not report if the
> NAPI was actually deleted.
> 
> Some notes on driver oddness:
>  - veth observed the grace period before calling netif_napi_del()
>    but that should not matter
>  - myri10ge observed normal RCU flavor
>  - bnx2x and enic did not actually observe the grace period
>    (unless they did so implicitly)
>  - virtio_net and enic only unhashed Rx NAPIs
> 
> The last two points seem to indicate that the calls to
> napi_hash_del() were a left over rather than an optimization.
> Regardless, it's easy enough to correct them.
> 
> This patch may introduce extra synchronize_net() calls for
> interfaces which set NAPI_STATE_NO_BUSY_POLL and depend on
> free_netdev() to call netif_napi_del(). This seems inevitable
> since we want to use RCU for netpoll dev->napi_list traversal,
> and almost no drivers set IFF_DISABLE_NETPOLL.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

After this patch, gro_cells_destroy() became damn slow
on hosts with a lot of cores.

After your change, we have one additional synchronize_net() per cpu as
you stated in your changelog.

gro_cells_init() is setting NAPI_STATE_NO_BUSY_POLL, and this was enough
to not have one synchronize_net() call per netif_napi_del()

I will test something like :
I am not yet convinced the synchronize_net() is needed, since these
NAPI structs are not involved in busy polling.


diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index e095fb871d9120787bfdf62149f4d82e0e3b0a51..8cfa6ce0738977290cc9f76a3f5daa617308e107 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -99,9 +99,10 @@ void gro_cells_destroy(struct gro_cells *gcells)
                struct gro_cell *cell = per_cpu_ptr(gcells->cells, i);
 
                napi_disable(&cell->napi);
-               netif_napi_del(&cell->napi);
+               __netif_napi_del(&cell->napi);
                __skb_queue_purge(&cell->napi_skbs);
        }
+       synchronize_net();
        free_percpu(gcells->cells);
        gcells->cells = NULL;
 }


