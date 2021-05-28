Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9136394804
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhE1Uj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhE1Uj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:39:26 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3A5C061574;
        Fri, 28 May 2021 13:37:51 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r23so6267381edw.1;
        Fri, 28 May 2021 13:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DkO7KkIwe01ErJXqAh+Jjg9Az5VUL8MEyBBRoVlHynw=;
        b=WZkwedPm5+2gBSws81l9sQR3FeK80M8suim20wY5Dau6s0nPMRv96gjgWfLBXnQDR6
         yzRK1WFYjlkjj9opT23Bh/VXwX6+Bh8fDL9rflnWSQ3pdzODeBa4+qK1/ThPGtoMNhvf
         A7p1OHQwJmeNFe12ssWc4udp2PJTsZFkRdFAQpKc2aLKHXXoUZJpoqTCfKEK4QP0e2yx
         fyFBU8ru/rOrN6p6/yTDXb6JqWH7qp60Q0O6jTZRdcKLBF0YDeEa5yTL0nTq/nRVojdp
         2Tf9GnqWGimh9Z/A6UhQrDwaBTO3/s5KVRGzM35xL9byYGv8KFF7v0jNqTBHC9heS/M+
         2tAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DkO7KkIwe01ErJXqAh+Jjg9Az5VUL8MEyBBRoVlHynw=;
        b=tbh9cZuJnR34Ysq3WTjnlSPMRx9qiR5eJLlxPR+JA3FeCSBVGibcJYfRG42JNkROv/
         mhaWRT2cNScu29UQfXsbux0SjDsbmfevEZK7jzmBqzV2Ptzkp36kZB8psLUV/ZoucnSY
         qbzmi94RzG/UmJzg8llbMk+ueTPznurR/p0e+k8OdVNB4HWAt0QudLjEfKtLVj0mjr86
         vlyT4930WyHmEXyTtzn7g07qZLt7fakNVDVyx61KGy5qOX+r1pSBN/uUeYffi6AMADjF
         tN5RSgLmodl1GKiW0pCAWNd35/KykLdjK50TVKnHljCeH/P9Sb+prmrkuc+ZTS9FPySx
         kcKg==
X-Gm-Message-State: AOAM531rNxuPIxmLTCwRzOkd4Z3vuKgwg3pfviEpXunIQ1rBGPCIMcUn
        6d+JNtnIoo8Am51Ib3M9hkjvkPu9Yis=
X-Google-Smtp-Source: ABdhPJy/iLd1ZCOIwzFRFpcv2ir0evEkuhmz1FVXSRrkehE/zjUFi7eFKgLm8BU1g2AIIrdYKD0lwg==
X-Received: by 2002:a05:6402:1755:: with SMTP id v21mr11476409edx.22.1622234269676;
        Fri, 28 May 2021 13:37:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:1db2:82d3:aa5f:84de? (p200300ea8f3846001db282d3aa5f84de.dip0.t-ipconnect.de. [2003:ea:8f38:4600:1db2:82d3:aa5f:84de])
        by smtp.googlemail.com with ESMTPSA id f7sm3304309edd.5.2021.05.28.13.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 13:37:49 -0700 (PDT)
Subject: Re: [PATCH][next] r8169: Fix fall-through warning for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210528202327.GA39994@embeddedor>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <96f95c74-e827-23c6-ac0a-c0d555768491@gmail.com>
Date:   Fri, 28 May 2021 22:37:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210528202327.GA39994@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.05.2021 22:23, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> JFYI: We had thousands of these sorts of warnings and now we are down
>       to just 25 in linux-next. This is one of those last remaining
>       warnings.
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Heiner Kallweit <hkallweit1@gmail.com>
