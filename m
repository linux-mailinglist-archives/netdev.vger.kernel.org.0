Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42BB35362B
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 04:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbhDDCUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 22:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbhDDCUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 22:20:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8BFC061756;
        Sat,  3 Apr 2021 19:20:40 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id v10so6012078pfn.5;
        Sat, 03 Apr 2021 19:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1nWds0fJN29rk2uMDm0KQFBeflTNB9KKpY7wmQwJEGY=;
        b=jqFXDi7GN+rcG/plPYV1dCYWZrD91E1KntrlAzDy0KY2DOR64S0k8qrRQzJCVfpREv
         YKQsNlt7uQGsG/EP3vykBCPt+jtZ8f+M2kSaVPurstrFgMxisjhBuVn1qPH7MZgxNmvi
         koo5pMcruQlBL+6PAKcMFiEMy0jI1RGj/BkCKkYAA4LiB/pP6aeW7KWAgTsHBJ1CJZGn
         whuohid1bbQS3c5/eZFpOUdKZBOcdN43asgoCNK/9XxjYa+nm5avy5deqpec9oujlbaG
         FFPOenqMmefhtRrWbjjFPTqkKRT0UpRpjta1Ry5S6H3j4JBYWsyzFV/xVOJj/R2f/QMD
         aJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1nWds0fJN29rk2uMDm0KQFBeflTNB9KKpY7wmQwJEGY=;
        b=BV2YQS95OXNYEb6XHxFlhmbjkRF64pXzAHnYnGuU17px0bTij96w1RWlhT3qD/aHzj
         4J8EiXmGrjLJT77Za31C9JhIK8khk9cX/XaWiSSnGjC61hYUSqX93HLiK4C0+j+UMQg9
         ujVDPy9sPiYqwWEczP0LE37Hi71UnvPvtJWhnnwiWMG75L0BBqLU3OwppGY54eKi3VFL
         4Cadl+iRz42foLH40VJcXtn4/H/qhxQwxwtxiBSeyd+LVkplhXQykbu7ZLlF5LCDqWDD
         bztfikn7v8Ht/+PTEtwT/hx+N+Daq4fKzI6T1ijgnC/xtw2VS1YO/RICtasRANhiZE8v
         JZ5A==
X-Gm-Message-State: AOAM533DVfVP6BPuH1fiZORrSDW78Mxvy4cAsHMOODnpjIQVgLd9lwz8
        OGOiDaW39ON37s0Wp703RjvuJjf1jOE=
X-Google-Smtp-Source: ABdhPJzQ60tlIXfSRQRof2b/LhtzbNl6iz7IH2eR6Y6xSnV+KL1vxP6GCC61I/UIXULx1KsIwukHOQ==
X-Received: by 2002:aa7:96bc:0:b029:1f6:9937:fe43 with SMTP id g28-20020aa796bc0000b02901f69937fe43mr18312733pfk.68.1617502839819;
        Sat, 03 Apr 2021 19:20:39 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:d9ea:8934:6811:fd93? ([2600:1700:dfe0:49f0:d9ea:8934:6811:fd93])
        by smtp.gmail.com with ESMTPSA id a191sm12156374pfa.115.2021.04.03.19.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Apr 2021 19:20:39 -0700 (PDT)
Subject: Re: [PATCH net-next v1 6/9] net: dsa: qca: ar9331: add ageing time
 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-7-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7ae15dbc-98ab-ddd8-e524-646567664746@gmail.com>
Date:   Sat, 3 Apr 2021 19:20:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210403114848.30528-7-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/3/2021 04:48, Oleksij Rempel wrote:
> This switch provides global ageing time configuration, so let DSA use
> it.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
