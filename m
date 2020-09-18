Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FEE26EAB7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIRByv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgIRByv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:54:51 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90615C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:54:51 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u3so2177871pjr.3
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yeDQ7WVZftU7kePfS6HHrDw2+K9T1LU+MTYiJR5MeQI=;
        b=ti4AWfxLyTcPr0qmLgGHixfkOkEcpTY/GC1j5kwzdMKAT/17Bb6zVhOVQJ9axj+ie9
         6GtEB+gKe4A8LGpCEul+Jo6izXINuJZZTkvnvSfQYeNtmBTvR5eBufFw1qOcSJbKct5V
         5zsCYGuAycVizkUXlI1WQhfDyYb0dgU/5Phnym484AA3v/AFv2iaVMRZ2uBTZ2fwNcfZ
         S9zeOgHrc5QRlx6/hnYToqK/pOro9rZ6tRxgW4lLAfrpKtRWIVgAk0Ft6SvRGu4tX5Gz
         6NKHnMZl5Zf7KEqrjEWX0RcLSxOjqVjOZ5FqJXmRMiy4CMKDnTZTewk4KBSSO6hK7/lX
         qC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yeDQ7WVZftU7kePfS6HHrDw2+K9T1LU+MTYiJR5MeQI=;
        b=smAkPO44Qm2CWcJQg42dHe8O3VWdwH/Fc23kjxJTQeMj3g82LfNTkL1Z3UYWhhu4C4
         wnVwbKx0ZMXu/8IxSR92V/sBCeXk+qvGqTFFBI62t96qaOcBCRmwPsrLQ7SK8FoA84gS
         v0Q3DuNjq3XGl0J0imZhHlhtGTUO14BLjSwyjh1iFji4GbFaEG4n5xW5C0ztV5dDLW6g
         UpFR3IAqee+/1cK94AIX6+QUr9wvu7aOYBHRsSRo+z8KG1qn7Dzo6FiZMSCDd7HMa80j
         /MPd9FMS7hg70EN9mhVa0n+4H7E4KnI7OI5CSRMKE93HmIBKP7ODuow3nG6IBOPUXei7
         Halw==
X-Gm-Message-State: AOAM531IphSVamRjD31Sq2S3sC++AkMLhVuu5zMdwJe2XsfjJRM5KaGo
        fdWGRdv73F87nPrrIxUqGkOZj1GPEF+9fg==
X-Google-Smtp-Source: ABdhPJw8avjPp1L009axc/KjVv6YMHFJmtM8hSaT63otcZjPSmaZh8wXgjkKKr3AVwCeX766kyJuiA==
X-Received: by 2002:a17:902:bd8d:b029:d1:cbfc:6137 with SMTP id q13-20020a170902bd8db02900d1cbfc6137mr19566446pls.23.1600394090828;
        Thu, 17 Sep 2020 18:54:50 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m20sm973150pfa.115.2020.09.17.18.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 18:54:49 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 1/9] net: devlink: regions: Add a priv member
 to the regions ops struct
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20200909235827.3335881-1-andrew@lunn.ch>
 <20200909235827.3335881-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3bc1e6ce-fc45-c8c5-4713-5b03a4b08d11@gmail.com>
Date:   Thu, 17 Sep 2020 18:54:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200909235827.3335881-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 4:58 PM, Andrew Lunn wrote:
> The driver may have multiple regions which can be dumped using one
> function. However, for this to work, additional information is
> needed. Add a priv member to the ops structure for the driver to use
> however it likes.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
