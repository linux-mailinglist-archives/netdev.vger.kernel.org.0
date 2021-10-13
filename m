Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB69942B2B0
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 04:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhJMCfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 22:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhJMCfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 22:35:24 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B21C061570;
        Tue, 12 Oct 2021 19:33:22 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id k2-20020a056830168200b0054e523d242aso1763933otr.6;
        Tue, 12 Oct 2021 19:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bcEsa+sI2EXkheHsoe75kuAxpaLmz4nDKnJI4rcst5U=;
        b=bi99xq2xlfmX8gHx/JDCUhkBmUC7GwIBxwapVKoXIq1tsXuj6FwYqddmY7+khfnwAI
         sVnOdrMGanHB/SULSC2lJ2lL4KxknKtWxqg9uLetI3mUNBvodbLRxANPvyvzE5nY8pKI
         7ZlbxU87HKtpmd1oWXFfQ2EUEkCVKThLExmt6yGrkLA+tTZqHvRemZjtx0nb+uOknGcA
         Ub7Kaidho8bZtQz5jlNwgsKhwnluGS3T18vnScvbWe0f1JGjUTy/GBdZLhhXSgOV0kFe
         i4WT2qtbutQo1nUf5MxthMfryTL/Gq8xNwkL8MXZkujLIcRms1S/vyGNaS64ZPHxB4hK
         wk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bcEsa+sI2EXkheHsoe75kuAxpaLmz4nDKnJI4rcst5U=;
        b=K7M1mjOky6TjD9ktZJT27GX6TaMf5UdzO9eG5TPHy+mmOyeBe22NM62GHeEYhPodpk
         wQSX3xOlLe6pqDHZuC/yJvQziF+/6FfoO/jNN+vRsiPct64MNsScuuQh7QTZGK34RY3I
         fdZeN8Pw0xrHMKSTnCrSBXOp0g907rldCdakHLAjiW2ncyK7ow2Xz+guRxuLWDX9HGw5
         J6h1ErJMMZxonU3YVEXyVD94t0IVzBVP0qQfChHL6UDFkHvY37snPYV+NWU0ZEpjAdek
         EmmG1Ext7TafRNJ/pgTrBPS7UaWVcZqqt4wJ6GzKjs+pMfQpVzD4QEkurcl7xrcxvZCq
         xLdg==
X-Gm-Message-State: AOAM533b64bkPju08+9VxeVnyDHuYr0/0OboCjD9RZziBYsNuEDPcU9A
        xewPfcOk+lNmyUQLdmsd9rzqW6TQklu6bg==
X-Google-Smtp-Source: ABdhPJzX37RvNA7zq9t0ndIWu6hytJ4TLNcvjoDNzoHj83iFIwy2kIetLJfplRBPzPnt0YawTJF3Bw==
X-Received: by 2002:a05:6830:2486:: with SMTP id u6mr27916709ots.353.1634092401617;
        Tue, 12 Oct 2021 19:33:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id k6sm2705768otf.80.2021.10.12.19.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 19:33:21 -0700 (PDT)
Subject: Re: [PATCH] ipv4: only allow increasing fib_info_hash_size
To:     =?UTF-8?B?5byg5Yev?= <zhangkaiheb@126.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211012110658.10166-1-zhangkaiheb@126.com>
 <23911752-3971-0230-cfd2-f8e30e8805db@gmail.com>
 <3bd88b51.6c7.17c77339c10.Coremail.zhangkaiheb@126.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9404e2d8-0976-1726-5f08-c277cdc14945@gmail.com>
Date:   Tue, 12 Oct 2021 20:33:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <3bd88b51.6c7.17c77339c10.Coremail.zhangkaiheb@126.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 7:10 PM, 张凯 wrote:
> 
> 1) Below shift operation will set fib_info_hash_size to zero if there
> are so many routes: 
>   unsigned int new_size = fib_info_hash_size << 1;
> 
>     This will wrap value of fib_info_hash_size, and a lot of fib_info
> will insert to a small hash bucket.
> so this patch disables above wrap.
> 2) Check whether fib_info_hash_size is zero only needed after allocation
> failed:
> if (!new_info_hash || !new_laddrhash) {
> 
> 

why not something simpler like this:

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 3364cb9c67e0..5c4bd1cebe0a 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1401,6 +1401,10 @@ struct fib_info *fib_create_info(struct
fib_config *cfg,

                if (!new_size)
                        new_size = 16;
+
+               if (new_size < fib_info_hash_size)
+                       goto failure;
+
                bytes = new_size * sizeof(struct hlist_head *);
                new_info_hash = fib_info_hash_alloc(bytes);
                new_laddrhash = fib_info_hash_alloc(bytes);


