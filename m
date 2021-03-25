Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1F334966B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhCYQHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCYQHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:07:25 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79675C06174A;
        Thu, 25 Mar 2021 09:07:24 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so1489270wmj.2;
        Thu, 25 Mar 2021 09:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eWpCpE1+dEBlLLFBkFHX/N/lZnfYujelxC3R7euwMPk=;
        b=kZac+IZtuE3REeWsFl0JncKaTi7IibI543AXwLmh0EW5ppCVeTPNtm59dvWMbGFs/d
         S0UeLnG4WxDRilGEuyQzW+s9t6mVCanWDTrb8b6MutCm8yHxnLLVg0iK1C66d83TfZXk
         GC/BsvF+0w9WFftV88ovvbF5w2bF95kVG1EJmYuUKwQeOkVWnzywnYXty99xstCR9BP2
         4K3ia1diopY9+iaOsvFRH+he9gLL3qDKCwNcvhUrolTwrcMhB5eUuvtLJfNjowaqEOR4
         fXdK1SMEf7NyHoOOLqxJznu3ZcWKm7UoqhNqyjEtM6PGo3fwQgr9XiIwcfjetwz2mITP
         iFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eWpCpE1+dEBlLLFBkFHX/N/lZnfYujelxC3R7euwMPk=;
        b=Uhp5EyCV3EfQhbziTi+XFB7lnDyRHI5+DhbGrCLxKcqROQYW/uNpmfTjjfwv+xRXwU
         /bf0yga+SJJf+Cw9DD1Gg7C+1V7Gl+wxQzW94z522FlPTl5W8MCR+fKJutpkHTW8Rs01
         BXXJmDZqSmScwtsBowZpTTM4ORIOgdmAHCp/yq4DCGp18wGqepyQLCT5zw4P54vAds5B
         zT6FhssxX8uwR4J3y0JsJZZEsFgK7zgBAeJ30hmiODrawSFyA9PJ5zrJqyU/N/YiJ/Dz
         GCJYBl6+sUcjZGqPsFW1ytYek9cDAaAD4WdcxX+9QCIEPDw0gBigeOZLQub79PhFvfNF
         /9Qw==
X-Gm-Message-State: AOAM530ZL+WPI7l93gsCtBdcTGRCDHU9x0YuslviB23czktcUjczizc8
        GfeS8oSgqOzJ/I63mQGj0PlRXSZ50w4=
X-Google-Smtp-Source: ABdhPJz4GxIgv7kIhqwJfdzPDbbkws+oUEJtSojtt7tWB4RMk4qpTAtrL3VofKD1lveiTsqdMLQGLQ==
X-Received: by 2002:a7b:c7ca:: with SMTP id z10mr8597937wmk.117.1616688442909;
        Thu, 25 Mar 2021 09:07:22 -0700 (PDT)
Received: from [192.168.1.101] ([37.165.105.49])
        by smtp.gmail.com with ESMTPSA id m2sm4321236wmp.1.2021.03.25.09.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 09:07:22 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: change netdev_unregister_timeout_secs
 min value to 1
To:     Dmitry Vyukov <dvyukov@google.com>, edumazet@google.com,
        davem@davemloft.net
Cc:     leon@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210325145245.3160366-1-dvyukov@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ea4e412d-f8b3-8c77-88db-344f14a36869@gmail.com>
Date:   Thu, 25 Mar 2021 17:07:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325145245.3160366-1-dvyukov@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/21 3:52 PM, Dmitry Vyukov wrote:
> netdev_unregister_timeout_secs=0 can lead to printing the
> "waiting for dev to become free" message every jiffy.
> This is too frequent and unnecessary.
> Set the min value to 1 second.
> 
> Also fix the merge issue introduced by
> "net: make unregister netdev warning timeout configurable":
> it changed "refcnt != 1" to "refcnt".
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Changes since v1:
>  - fix merge issue related to refcnt check

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

