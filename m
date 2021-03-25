Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3DD34943A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhCYOfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbhCYOem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:34:42 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A6CC06174A;
        Thu, 25 Mar 2021 07:34:41 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id g20so1301619wmk.3;
        Thu, 25 Mar 2021 07:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ynjweMD64YwpHQ7jlYvwJr6TBQ1yPhkY0RkphxEaM2M=;
        b=KBljaEXQHl3gUY+gKjbs4ppg6uRSYLE+xVa+FINEk+1BW8vpsfu0+DQWDVYNqiJQGH
         +rFmMxTpQsuSORwOrYt9jEIKvFyI7FZV0mNzG+zaAIKpBJdWYhncePlqhKMGL3SZGfnZ
         z00N+OIv6PUtowHxkYgia8RS+4Upgz9jgktLTYPe/iZHnmk/uG7rYx+iUJ8KLZC77LiR
         4ch8llxfBmq4RP6GIlmupxAJi81jQoP+6nODVjFI+EKSD5niJQix+SQwhSg8txP0obdF
         0UFIDh77rKExHi8vBK+14j8zkMghhKUuRHTxtNLPdpIAqrxhTinhl+qsBFujzB4eQNIw
         6o1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ynjweMD64YwpHQ7jlYvwJr6TBQ1yPhkY0RkphxEaM2M=;
        b=srrEjxqjWeGQrVuuvd15nYdBLl5Kmo1lFR4uVvcz8lssdUZczcnlH7OUyFpu54NSaZ
         qdT8l6vBj7t35ZZw2hO7Yq0fdVX+yMmeD3gQVzU7C8FRUxVPhhmfGrfxvsqYSt433XCF
         Lfy673WuCLKhOvtxxnPgyulHDrW8KHDSA3fWvbqH2D/1fgHEMhb23BNkcfKTjnjDbAnj
         /GXY0vXea03ClPrTT78DG6Ym0F+EpFmS7zDm96KqdqNCVLVbCfGOzdzg38atj7WE5o7T
         bOESkpTadM+GRyGGpZydxS9Lvi1OSb7fimXSYav2TEmHGQy7fs4ycPMFELTlI2H2zNoW
         ivGA==
X-Gm-Message-State: AOAM530B/TzOBecKMSI+LETiiIAEdNaix2xV2OQVBn3qJj6up9iT3goM
        dNwOZ0H69Ke0ni5eSgsTQEUpjC22X3Y=
X-Google-Smtp-Source: ABdhPJxcChO499zctJMW7cGfP4u3vqjzHxMrcrA9zoxp0fevz1/iDgOXcGFGrvKuaA8q4T87zmX9tA==
X-Received: by 2002:a1c:43c6:: with SMTP id q189mr8360520wma.80.1616682879425;
        Thu, 25 Mar 2021 07:34:39 -0700 (PDT)
Received: from [192.168.1.101] ([37.165.105.49])
        by smtp.gmail.com with ESMTPSA id w6sm7738910wrl.49.2021.03.25.07.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 07:34:38 -0700 (PDT)
Subject: Re: [PATCH] net: change netdev_unregister_timeout_secs min value to 1
To:     Dmitry Vyukov <dvyukov@google.com>, edumazet@google.com,
        davem@davemloft.net
Cc:     leon@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210325103105.3090303-1-dvyukov@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <651b7d2d-21b2-8bf4-3dc8-e351c35b5218@gmail.com>
Date:   Thu, 25 Mar 2021 15:34:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325103105.3090303-1-dvyukov@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/21 11:31 AM, Dmitry Vyukov wrote:
> netdev_unregister_timeout_secs=0 can lead to printing the
> "waiting for dev to become free" message every jiffy.
> This is too frequent and unnecessary.
> Set the min value to 1 second.
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---

Please respin your patch, and fix the merge issue [1]

For networking patches it is customary to tell if its for net or net-next tree.

[1]
diff --git a/net/core/dev.c b/net/core/dev.c
index 4bb6dcdbed8b856c03dc4af8b7fafe08984e803f..7bb00b8b86c6494c033cf57460f96ff3adebe081 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10431,7 +10431,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 
                refcnt = netdev_refcnt_read(dev);
 
-               if (refcnt &&
+               if (refcnt != 1 &&
                    time_after(jiffies, warning_time +
                               netdev_unregister_timeout_secs * HZ)) {
                        pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
