Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC11231AEA4
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhBNBSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBNBSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:18:31 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B7EC061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:17:51 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id u66so4053041oig.9
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F5e/BsLBCqAAU2ayIqxHkQ9TXoLeHejuRav7SK6dtM8=;
        b=oqFqgovKxwwZMYJC4JiMQE2EoXhMtVAHFw0KiLJlTO3Uq9HWnhRg0loBhg8K7/eSzf
         bLFUIg0pX31S4VCrJR34Cvghi0d2g+P9PNu5r+EiB+29GQpXiISrFvaM2AJwpdIqAaKc
         BRL5sCVNgQgjK5TExnZRgXjRTsJ9MdcGuF3Ynf+zcw/HLeukDQs2utsJ/ZrajHNOHFeR
         aZgi2AFxFf6+Y+chZUo3JvufH1HPWWKEH6P6TWmsDN79CrMTli/yhBeJVdyvBTY+xupX
         5wipBMjqp1NzG0zxlEwNaiA0s/1xtna71M5LQPNppkwrqP7tIX2EcjhEnLP0RVUKN4AP
         EVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F5e/BsLBCqAAU2ayIqxHkQ9TXoLeHejuRav7SK6dtM8=;
        b=c2qDZ5kUMzLFNXo9XefP3A61XTt7L1Ce/a1+JwAmnvH50HR03ZvLSC2mERkkRCFCya
         JreHXmWRPeJhlx9MnSgGjDLw4Ih9bEuDwv/u+f4llPr143OMv+3/l5Zvc6bWwKUT6X2V
         WSnPknzlgK5/qJSAl16C/ru/4V625cAfXILHXHrqCQCKdll6Tfl+Qm9oIKel8S/tR7Fa
         FOepsHfJlAHv+e9PSfRVJJVjhXe++SYQi2tBEwXINyMN9/3jDigfJPqntN8Sv9/8w9AB
         lxtN03XCpf7Az4GA2o02vrpyPLQJF6DPQyMbNsexjExobK7Vh9u4BkNrm+pHtTR5Z5FZ
         /w9w==
X-Gm-Message-State: AOAM533YFIcNDNl87fOmjz5gtdC1/ZceFFvtgfxCD/M1heexDRgRRbpQ
        xIOZ707BUuUbpfKuVpWraL8=
X-Google-Smtp-Source: ABdhPJzNYJcdN59xw2UR5rrht3uhfz3kHvQh7uyDEUF5nIXI+2ZPt1s65dg4IZ9rMtqC963T9QTLew==
X-Received: by 2002:a54:4106:: with SMTP id l6mr4385533oic.110.1613265470833;
        Sat, 13 Feb 2021 17:17:50 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id z8sm1952893oib.36.2021.02.13.17.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:17:50 -0800 (PST)
Subject: Re: [PATCH net-next 5/5] net: dsa: propagate extack to
 .port_vlan_filtering
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20210213204319.1226170-1-olteanv@gmail.com>
 <20210213204319.1226170-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2121afa5-72f1-a184-d06a-2314d4774a1a@gmail.com>
Date:   Sat, 13 Feb 2021 17:17:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213204319.1226170-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 12:43, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some drivers can't dynamically change the VLAN filtering option, or
> impose some restrictions, it would be nice to propagate this info
> through netlink instead of printing it to a kernel log that might never
> be read. Also netlink extack includes the module that emitted the
> message, which means that it's easier to figure out which ones are
> driver-generated errors as opposed to command misuse.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
