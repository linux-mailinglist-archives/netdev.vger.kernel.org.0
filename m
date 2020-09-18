Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8974E26EF71
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgIRCfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbgIRCfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:35:38 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E96C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:35:38 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y1so2549488pgk.8
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MQDybMje2pkW/UmJDhlDHVQ6ciIJ2Xtim1UjNCWtOwI=;
        b=I0REWk/Pi2zigciAsPJwf/yLDhYEolDpXPscI0FGPKqK4/EC7fHIUo43Bj5EIcdvVP
         2xr9Kp0jmCawAjP/zWFrB8+O7EPsW3Dc2YA2EcSwURleqBYZE5vJgqEEK6CL4a0RdZlS
         Rm1wyjjyD5YLgqyDJu87v7H9zRFtL4W4ljKy85sNQ4L6bK3YEJZYBnMj7R7wPR0xKIfq
         TELKzXJSrroHbfzD9n+4eFrDY7jW+WD8VKPTDQ6jEXHJBofcCaZ4UPSqHLy5T9dWlGJz
         lxvssXCQMiF3zO3NobKkDkX3hIoA2/opuE/zKXnDCp/2ytFJptOaGVYrhpCnbRHqOiD5
         4wkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MQDybMje2pkW/UmJDhlDHVQ6ciIJ2Xtim1UjNCWtOwI=;
        b=YC8xzxIqbpW0rX25hOXv1z8hh3xsYWbYLSfBuYAzy8pS7yfm7cMXJYXkCzyAS+hFB1
         3/BYSZv5Ak/SPG277jNSU9wB905/Ag20oMFWNxBbrFIeau0WBpyC5SjQt9geO8cQYl6T
         NfdTTzbumMzUVo+XBnaupnannXXKRRdpRhqaasK3PPAQ/PlfKFKisYZPUDsKQ0As0Gzv
         kkSKhr+rXfSMcPKF6MwFzJjilnacI8uVD8kwsXfMtO641wPATsMs99OiAnWEkcWeoWIn
         quDxMlzSLCm+FXXPuI8XcXeqyIKl6Lk2Kiy7z3yfG0w8CXHjAlYAg9yw6+s/AZssesqo
         jOTw==
X-Gm-Message-State: AOAM532NSOFG+qIu2RjqIVLUomT4+2mAvREElVdtZRm1EO+QKCDcY14u
        xcEQuxapoeuodyOI/wuXVwo=
X-Google-Smtp-Source: ABdhPJzaMrIoTDYA9r7JrRyTDZE+4dAoMFGavIqfTbldJ/sajqiSD8O/ERcg73dyytBwzvqYuqwxZg==
X-Received: by 2002:a05:6a00:1356:b029:13e:5203:fba3 with SMTP id k22-20020a056a001356b029013e5203fba3mr29266767pfu.3.1600396537571;
        Thu, 17 Sep 2020 19:35:37 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g24sm1059219pfk.65.2020.09.17.19.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:35:36 -0700 (PDT)
Subject: Re: [PATCH v2 net 5/8] net: mscc: ocelot: error checking when calling
 ocelot_init()
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5a65272f-4964-a866-96f4-4e1634e5101a@gmail.com>
Date:   Thu, 17 Sep 2020 19:35:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918010730.2911234-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 6:07 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ocelot_init() allocates memory, resets the switch and polls for a status
> register, things which can fail. Stop probing the driver in that case,
> and propagate the error result.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
