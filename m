Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6151326EE13
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIRC0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgIRCZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:25:50 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4788AC061788
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:25:50 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l71so2548759pge.4
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GrPpFfViSWBlkjD8qUhinBCdC/NY8mE9TUs6Erx4apk=;
        b=VYH4J+2gx2wDXQvjm/PjzYwmEBBRRVa+r9Px47Qb3Usy9/oYk0p+MAE+8HdYa2VQ9R
         uOdTQMQ4BleGEpFYeMQjSLOFbCG2IjkXcPDIVgowydfv2KYKKUkcHIfdYGMpV8+F7Rn6
         8BIywnUU12wrm94s257VFgYBiBsT7EMqnfVbS2iPTiccnwgnh+huVGDiotxsqeE5F09X
         TZGwhD36TYd47kKniO1jF5KIEe680vRHDZCm35Q/Tu7mNOvO2/tYZI9afU2NB4Uk7qwG
         huNYMscIKtjcwCgHuQmS8yslIRj1p2Hrc1n2C+hQ9DH9jZt9pT+P/p4NCebus/Dp9GkC
         w+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GrPpFfViSWBlkjD8qUhinBCdC/NY8mE9TUs6Erx4apk=;
        b=Vp6tqKkc0XU9y3NoMXP6sFAjQ+Sv1f24+RRzg3p+KQT44Lmuo5OZXZNnZaIb6OWRRq
         94AVrSeDjkK2rcDKzgzGVPRdnXkPBScN7gklsFWLPDCUW93Zf02Zrp+RF8EBfo2jon38
         U0BL/IUqMkL85I/XX2vkAz9F4CGsWfBL/bGOZxn7F5jeMG1jVvLFbvTOwmp3tggK5tic
         ZJfHpgPG7P2IcWCqCFfGhLT9xxM/PiTFXHs1ltG08ngQIIRKcxWVpCeIZWC8b9Hbf5Z6
         z5W0Goih+n92fdxZvCpJLip3fa+3cTuhkFzfHa7TeJEJi1enCSLKUtZcefqhYWf/HBJG
         ByOA==
X-Gm-Message-State: AOAM533Cd/1YkxPTBd7QLRTHADEdBoScwOjeZL2EwmRuSFNszkZ1Xr6A
        cQhc6ClpMqKgb9nO9R3i3Gg=
X-Google-Smtp-Source: ABdhPJwAvRW1hef5UOs6VklBAnGjWRNfljnfxw/bQXs76robNArD5o8451mACo2ItxYCgybPqvjD0A==
X-Received: by 2002:a62:36c7:0:b029:13e:d13d:a05f with SMTP id d190-20020a6236c70000b029013ed13da05fmr29408468pfa.37.1600395949811;
        Thu, 17 Sep 2020 19:25:49 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bx18sm964975pjb.6.2020.09.17.19.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:25:49 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 5/9] net: dsa: mv88e6xxx: Move devlink code
 into its own file
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20200909235827.3335881-1-andrew@lunn.ch>
 <20200909235827.3335881-6-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ea88eb9f-8029-08fc-b514-5ea9b92f58f2@gmail.com>
Date:   Thu, 17 Sep 2020 19:25:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200909235827.3335881-6-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 4:58 PM, Andrew Lunn wrote:
> There will soon be more devlink code. Move the existing code into a
> file of its own, before we start adding this new code.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
