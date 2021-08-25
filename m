Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BEC3F7AA9
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241168AbhHYQeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbhHYQef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:34:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15001C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:33:50 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id oa17so200235pjb.1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5wYPZzWGFYsws6hclRiC9uDyBEAzIQRF4Ye6FrOI3rs=;
        b=mYZjkwzE77Sa6zoAE/v9VGZrqmGoE7F+1pInDV71n1YKkJgxdN0cXXE1530W8ArXyd
         8gHMZtgvdJ/yxbVUYSfY41Vd2tiuHyVRDz+x5M5iFTN7NzquQ+FsE/+J6CAqSv8isHUt
         9yqWSruIRIOqohNpqVg43rbloSnwlwFL7BhbvjxSSW9B48Q+jra8s7niRTLUXmMtXNXx
         eXrUFeaJLF1ilZ9ihGgUkKsN7+eSAD4RcvNilQKFQA4TS/xtC1z4LBbQYe83E70NnKNg
         hRZRULWZdejkvM8wl16zgtDEw2a0YVw3S9/aKl7CE1FaBKo6j17FHYCvygHm07LJ79g2
         pQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5wYPZzWGFYsws6hclRiC9uDyBEAzIQRF4Ye6FrOI3rs=;
        b=dVhz0CAXYbO0hG5lNx8+khqhTd09n6tbL9O75yfPJYZfU7rMaOSyilGG3lea+Dwjlh
         WQijCXo/spOVSur+Qx0mmew9JEnzxw2RCE3W4eWbNMg7e1tlJbH6l8SjkocIesE48mTW
         4OZualLfXbIS/a+dzBth1RwcnwpfBnMcmyonDyUDw8VKHgg+FaVjW8OFnRo5Zq7t/Ph5
         uE4DmiP6tiywASWT5gtzMeSJakyoXhZwE5xMvfTwBYCoWLd0K3TSm1pkOWrLpCKmp4DR
         uEnE4JhU7AFgnOEWj2Qx8hk7WXaWago2d7BwaABdnT3WhMqtIknS4HPcnmwKVjUfNXw3
         nGlg==
X-Gm-Message-State: AOAM531kP7Y5lfO477I54ihS4F0DdM0J5SHtXWM+CM9JsjeEAqcZYiys
        MkJN8K9Z8gGnMceESVHBYcs=
X-Google-Smtp-Source: ABdhPJxBPBWSvBDCdx81dvcfkCNSc82nLfYaJRechUyaenuNcEcRg9rp6U8//OmMC4EWXQOvMvUq7w==
X-Received: by 2002:a17:90a:bd18:: with SMTP id y24mr11630217pjr.83.1629909229650;
        Wed, 25 Aug 2021 09:33:49 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with UTF8SMTPSA id u25sm265993pfn.209.2021.08.25.09.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:33:49 -0700 (PDT)
Message-ID: <aab4ab70-01f7-e874-4bbf-aa3a94412fb9@gmail.com>
Date:   Wed, 25 Aug 2021 18:33:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH net 1/2] net: dsa: hellcreek: Fix incorrect setting of GCL
Content-Language: en-US
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <20210825135813.73436-1-kurt@linutronix.de>
 <20210825135813.73436-2-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210825135813.73436-2-kurt@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/2021 3:58 PM, Kurt Kanzenbach wrote:
> Currently the gate control list which is programmed into the hardware is
> incorrect resulting in wrong traffic schedules. The problem is the loop
> variables are incremented before they are referenced. Therefore, move the
> increment to the end of the loop.
> 
> Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
