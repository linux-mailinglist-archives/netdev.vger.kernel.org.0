Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBB3260939
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgIHELe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgIHELd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 00:11:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01230C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 21:11:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a9so4383216pjg.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 21:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BEEDTWC0DYvLuig0qtCIJlrRe3TuKMq/x/OlZ5LXUeY=;
        b=tljy/lOqSz8GeeTNwxRW/SMqfdhV3McHAZ+/RQ7PUxOrBUPMyTKNOuN/3l4bH9g087
         q8rzUvDYxkl5TN9fwQmZGi2xvLor/kdcBY0Fg4FQDty3IBRi4Hig/0mo1x8jHtnbmXFl
         PCryllGR6Yodbhlr+dLSm6+kai9i7UsWkUv/uavfsWg8DgNt2f/1xIdD86nKd5cImuzf
         GbjQFjdCnBmfwQOY7aufnKWSaKIkP0ywxXM/kbjl9Pc1qr2CPgIWJn6SnKfThc05VKF/
         oskd7FCKALTm+3EiiqbA7EaCjykv8mTE7BIZefTdfkWfEnAuUCEdKUWJHTBKRK7kjCYg
         8D2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BEEDTWC0DYvLuig0qtCIJlrRe3TuKMq/x/OlZ5LXUeY=;
        b=VopGuAYXFDB5txC7hxhWwXVOYhi0oB+o9rF8SJBle8BSZmsGbHPDqI5Izr5PS3ch/s
         1IwHRbVTmOEL5F8p1geE3VJOThoLu+dX96zFQP9Vf0rUvBsEpKLoRBFVHLnEUUxkYHD/
         QzaHmm1ufTb9r2bJA3GV/yXmRPYkLis8fe56N+MZ2YGK/dV1d4S4Y5BxAplnrlY1aa2M
         hDhXiTCysDGG6VFGayEVsKPFGFeNdP08QfLE4F4IMPSx9ZvXg/w1OPusqw0Am9CGteYT
         iouNXBTN6rskc0AnIC2VISOo34U4U7vIipEmHn6IpxnmQo3KNW+ItZf4M9vgnPxZkLHs
         TdOw==
X-Gm-Message-State: AOAM531Sq0HAFKdtjddJRP+0D6eFEc5kLmrPYHTpXzuHutr3Lur2NfpM
        wXoxqGHFryBI24gPZ6T1Pwzf0LMu2/g=
X-Google-Smtp-Source: ABdhPJy5/kjyCjfH+XYVa+SKuBeRj+rwzEEtbPCuUwGVKl38W9dJRvbcpxmXwR05OC4wS4Ym/PwrnQ==
X-Received: by 2002:a17:90a:d512:: with SMTP id t18mr2138866pju.106.1599538291977;
        Mon, 07 Sep 2020 21:11:31 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a18sm2396784pgw.50.2020.09.07.21.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 21:11:31 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] net: dsa: microchip: Make switch detection more
 informative
To:     Paul Barker <pbarker@konsulko.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200907101208.1223-1-pbarker@konsulko.com>
 <20200907101208.1223-2-pbarker@konsulko.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f735083d-7f91-f558-ece0-a748ba79a540@gmail.com>
Date:   Mon, 7 Sep 2020 21:11:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907101208.1223-2-pbarker@konsulko.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 3:12 AM, Paul Barker wrote:
> To make switch detection more informative print the result of the
> ksz9477/ksz9893 compatibility check. With debug output enabled also
> print the contents of the Chip ID registers as a 40-bit hex string.
> 
> As this detection is the first communication with the switch performed
> by the driver, making it easy to see any errors here will help identify
> issues with SPI data corruption or reset sequencing.
> 
> Signed-off-by: Paul Barker <pbarker@konsulko.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
