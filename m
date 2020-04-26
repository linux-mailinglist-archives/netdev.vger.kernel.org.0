Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FCD1B942C
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 23:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgDZVXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 17:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725996AbgDZVXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 17:23:01 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCC2C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:23:01 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id hi11so6600410pjb.3
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xiLMQkCx7ni+hFiV7GE10ECbgztOIFtbbbLvAX3zbnc=;
        b=UYWe2UUvXQsZKlgbdEdClPJJFqjnOtXcZdUmFyLBNdOLqKOA2CicWbHebP5sLBh1pM
         UzfqyCX/LfvkY7Mfk2uNm6+sb/31XiLUvXVBhQV4AUGDUVHXFN3h1GI6BdegJKSIPdA3
         ywzfV2BShMYiRbf3hEeZrypJHdfymdxGnSoSnjqY4puu5TzXeCGbm1tcU3AQFDaB+0hF
         nNOO+ckQaM/1c+t6z8SOsXH/PaJQJAAJTYyiShxHRit3P3YLiKqDZBq8yfqJngjDy17R
         WlgmNNarjQA74oYopvPK6v1wXnAMJbSZ9m/7CNDfCZRC7xo2D08RZYlRJjJ01dbPM10e
         uMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xiLMQkCx7ni+hFiV7GE10ECbgztOIFtbbbLvAX3zbnc=;
        b=ihUgzP49uRcdVfJbJttP7A6BfBsqmiHgl2fmsGj80buTHpCGg9LcOSUQwZOOvHIDyO
         y5u1BMXwJy19NBWjVSAAqM2J1A+r8WJ2C57jycx+Z8izYWlMWfIfImljVQn3sqGsOw2F
         n2mJronCFY9vjvihzzLj5RpaoLfMkRrHgEfbrNhbYbrA9GdNcG2Z5E+TtsqA+BLRiy+4
         W1vkdOuNc5pmWcEP5g9rrMGsu8Rf0Okb3v0jsTDGX+Qt8zNw9oec45FacMfrqsHqylQQ
         KcWc7of23hHoCPMpiJfpCI4QFQ7HcHqLnvik9oq/coMgtnI8vD5bWtYo09fYnPSJTNmm
         gvrg==
X-Gm-Message-State: AGi0PuZjCLCEEWJBK8ZQ4Hk8n/feyb6Q7uDGquRsjWywQRuz/tDY7bl3
        nEwdqJSz88KGw20/2VfmV43qLy9q
X-Google-Smtp-Source: APiQypJLGHqQlYfrzl/0aJcFcwscpHoImbHpB37ss4zbwUVXoCGQVXTp5+crc9SxMJqCMp/3R6DnWw==
X-Received: by 2002:a17:90a:d0c3:: with SMTP id y3mr13336576pjw.25.1587936180394;
        Sun, 26 Apr 2020 14:23:00 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v127sm10371020pfv.77.2020.04.26.14.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 14:22:59 -0700 (PDT)
Subject: Re: [PATCH net-next v1 1/9] net: phy: Add cable test support to state
 machine
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a77a19a5-bb81-434a-161c-bdbea6e9c884@gmail.com>
Date:   Sun, 26 Apr 2020 14:22:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200425180621.1140452-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/25/2020 11:06 AM, Andrew Lunn wrote:
> Running a cable test is desruptive to normal operation of the PHY and
> can take a 5 to 10 seconds to complete. The RTNL lock cannot be held
> for this amount of time, and add a new state to the state machine for
> running a cable test.
> 
> The driver is expected to implement two functions. The first is used
> to start a cable test. Once the test has started, it should return.
> 
> The second function is called once per second, or on interrupt to
> check if the cable test is complete, and to allow the PHY to report
> the status.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

[snip]

>  
> +static void phy_cable_test_abort(struct phy_device *phydev)
> +{
> +	genphy_soft_reset(phydev);

Some drivers implement a soft_reset callback which would not be covered
here, so I believe you need to call phy_init_hw() here. With that fixed

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>	
-- 
Florian
