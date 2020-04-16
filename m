Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49EC1AD044
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgDPTVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727844AbgDPTVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:21:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352DFC061A0C;
        Thu, 16 Apr 2020 12:21:09 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q16so1440758pje.1;
        Thu, 16 Apr 2020 12:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=czdAFM6p6v4HQnalKB/1Vj+iwWqk9dWQoxg5HWsT0cw=;
        b=TCAsK+LJL2ZXC/c/k81+myBJTXrWpR8xZC9KxhbBqPsvm01uq4XHI/P/KEpPP4vtoo
         4IEBoYoY2RKXvJ9DdBTzU6C5FOOWBVlzrfNtSY6ZAU/wrCm1b4gCCbJfbaZYia56nNO7
         0m588yJUuLlLQi9P25zlOzNUQ2ViRpl9R8RhAu22F8BVUqJTnVot7WrBSq5xiqvSQBGc
         xgJmOAAAeanK/8hvQs7NQ9vzakXSxyiDQ9c95cJTy4bK+TklDSWRW0InIHKddx9LnVz+
         BmKEFLQsR9lyIJnDNPSkz0n/fhyokUYakgFcFUmZZOIboqjwIM+P3ITC860H3bxrFFiY
         /i8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=czdAFM6p6v4HQnalKB/1Vj+iwWqk9dWQoxg5HWsT0cw=;
        b=Bc6FE3CYinkOEIkwuDooLAaogv3gNNYkznW5fEEytdY7b9ZK5/nM1D11OQMV6gFF+n
         2R4J/NzNb4oC41Q0Rw3Lko4QN5StKrpUf+1za7s2y5WrNmrpAMcuznimx4VzhV7E7a2/
         WbHXqbDnwm5Q0xurw/rrbJ19Z+T9kGjybL05IM2McQNMrYuNxE5VuGgkV+qWZSNy45XL
         MyOJYBjenVP9OAtsYvFH5EH5ik6n6+OwJ1gM0IQhF9ccztqQ607ZySn3n+32R39EysvG
         gNDBsJvKydeRLpxIz2urn6M4XlFB7gJZMpRa7EKhXQWz6UNWm1HrHHoIEduFCUpy90X5
         oLvg==
X-Gm-Message-State: AGi0PuasFB6BXQQ65wfhYf4eI/X30EWAg27xTrnaPUJHzvR2f77usyxG
        /isAY98WptAwS8sspdQVLVk=
X-Google-Smtp-Source: APiQypK4k4ZVOOeLeqmkjjED5k/uXPYQlei03Asq4FRd/Gw+sVBDOwUYO6nOrjbZkSP6vWw+rOwfSg==
X-Received: by 2002:a17:90a:d808:: with SMTP id a8mr6883176pjv.6.1587064868660;
        Thu, 16 Apr 2020 12:21:08 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p11sm15197764pff.173.2020.04.16.12.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 12:21:07 -0700 (PDT)
Subject: Re: [PATCH 1/5] net: macb: fix wakeup test in runtime suspend/resume
 routines
To:     nicolas.ferre@microchip.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        harini.katakam@xilinx.com
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        pthombar@cadence.com, sergio.prado@e-labworks.com,
        antoine.tenart@bootlin.com, linux@armlinux.org.uk, andrew@lunn.ch,
        michal.simek@xilinx.com, Rafal Ozieblo <rafalo@cadence.com>
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
 <eba7f3605d6dcad37f875b2584d519cd6cae9fd1.1587058078.git.nicolas.ferre@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <758a8d30-1065-c98f-3c8d-590be35935ff@gmail.com>
Date:   Thu, 16 Apr 2020 12:21:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <eba7f3605d6dcad37f875b2584d519cd6cae9fd1.1587058078.git.nicolas.ferre@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/2020 10:44 AM, nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> Use the proper struct device pointer to check if the wakeup flag
> and wakeup source are positioned.
> Use the one passed by function call which is equivalent to
> &bp->dev->dev.parent.
> 
> It's preventing the trigger of a spurious interrupt in case the
> Wake-on-Lan feature is used.
> 
> Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Cc: Harini Katakam <harini.katakam@xilinx.com>
> Cc: Rafal Ozieblo <rafalo@cadence.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
