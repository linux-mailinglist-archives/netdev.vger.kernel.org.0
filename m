Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1812235A73
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHBUUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgHBUUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:20:33 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8636C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:20:33 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s26so17089460pfm.4
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OlhwetCtTtUznZmCCMRGJvmdKz5ekJzDvnyWo4vK2bU=;
        b=EDxAoqkmWGfjO1zVoYRmphgM+CbLWXhLv0BKKQAeWUZYP8R4mx6gKwsZFAHwp8Uzkz
         5qdcfIPThZD/rqLg/yYT7fj7LbOOOdJWFtD+J8R2xWgUoaSUyR+y9PIHNqENqrRpcsim
         X8WCX6rr14j0zqTh3WXuxv/sPyInXPASWqk+HVPWA9vD6K0A9t4EUoG7Qncm+dZBBSIt
         rZaKUo9yGwVuKdjpkWnr06OXhkp9UqnWufRekAgB+QB/IBmTyx9z0VbQNiNBfeN8TNFw
         L/vkLUvkMl6UPdExSZvajWTivEBCwsnpcDvEl+1zYRx2S8PZLnZa458MLpX6JrAcut+w
         lMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OlhwetCtTtUznZmCCMRGJvmdKz5ekJzDvnyWo4vK2bU=;
        b=lKSFFKqHRkzIpVczTX4Z/OzR3b4K4ChByMh28M9OH3jPzYPNZaRt9djn6DvKSF3TE/
         C7/Pb5B9gXHmup8vOocN80lsRIm83sigNgVVfux8YnF0icX8yGR7ZpGSSn3RI4uRJJPs
         9XARSjmzIhYsQZEDLj3KyTmI0jFQ6KVsbLQBrYX7cANn2gNlkcCPinmvM1Z1jqK7D+Ky
         goHxwhgOLiXmNIg/ts/8hfYvGcyps/6Oljj4eT52uZYYKz7hlu0DuJ9JjxKeLlX1H/In
         EofeCCAMRnyoGOjF7G5Z27SQiG16LPt5dMGdz4/Tx/CWnipjjxa/7qlM4Qqt2kXxVI/X
         uZVw==
X-Gm-Message-State: AOAM530rq3wc0fUq6NizjDEbY+vJnWYly7HvkHni4uY2xbwTtbWT4j09
        P+ftsddrhC+QtgFY19uWbcA=
X-Google-Smtp-Source: ABdhPJw5QBtnWkniE6Do5Gj0Ce/t8TtYvVDQPy+GW9y2NkdDsCO/GOaSOwmX8eL8oNaUA7khBArtxg==
X-Received: by 2002:a62:1c8b:: with SMTP id c133mr13316139pfc.134.1596399633344;
        Sun, 02 Aug 2020 13:20:33 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 75sm6749276pfx.187.2020.08.02.13.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:20:32 -0700 (PDT)
Subject: Re: [PATCH v3 2/9] ptp: Add generic ptp message type function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-3-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d20d2e33-67c8-5406-3762-82d9d307fefc@gmail.com>
Date:   Sun, 2 Aug 2020 13:20:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730080048.32553-3-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 1:00 AM, Kurt Kanzenbach wrote:
> The message type is located at different offsets within the ptp header depending
> on the ptp version (v1 or v2). Therefore, drivers which also deal with ptp v1
> have some code for it.
> 
> Extract this into a helper function for drivers to be used.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
