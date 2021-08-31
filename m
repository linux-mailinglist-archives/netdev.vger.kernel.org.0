Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0E63FC055
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 03:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239221AbhHaBFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 21:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbhHaBFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 21:05:48 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2D1C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:04:54 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r2so15118004pgl.10
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oraGdt1WeV34hQw0n5FRjOzfjtOiL1Oan+wVJeTxZ5o=;
        b=oxq0hSCPK78d9YuRTbCdB7K6XRsBPjzlY4KzaXAkQ43SaecA32yLST3MogsWzcUuZt
         v5ZHgiWYgUYHdrji67gDRAJu8uM/Zklihe/iEBTf+5wLih5bS0mA6entYf6yuo3eXKt1
         W5DGfgQRZPmLbUXpT+MB2qg65COuzE1CC+8aivP4O4uEG369YKSRfK4h5pxv/UhJPcwl
         MTmjB6UdSqbbdKnODIvBTJeVt1FqKqZzxGm8uz+ddmqt/I7X2en+lGMyiV+aGUWUI6NO
         Ae4v/79t17WR//5hOpT9TcXGjJ5hBMufwXyioJaBVIyN5LfUxqWE7X0OwM9IQXGytuKn
         FZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oraGdt1WeV34hQw0n5FRjOzfjtOiL1Oan+wVJeTxZ5o=;
        b=MZqbq95rUcgYFiBSbmTsoc4fwfD6CNMTSFsAgOp7/kpoegasIqXElBKnKw7iAdzOYC
         15bDDS8iOHz4gfhkCe3GfGEghEXw1Rf33HeiN2C5ZdifJm8s29w3/8CpSLCXBhTgQ0Ik
         W8GWha3sV+Kaz7+OK9fbJKmj9P9DwlREROVrgnSdoMIK+fH8koGAoBxAT0ql3DdfJW5T
         dXCdzG+P3Cs2PVJfs3J5gYu50brFe9Ut+5Bmes5UjuSiNZ/Ms3wfJ4RCjwajNwIeDMn2
         GA6KP29DUHxDuGaizulQmlcxf+dBrg2oVGS0c11dtbTRLuAAdKHH+ck7Pp20NqT4Wgq4
         n1NQ==
X-Gm-Message-State: AOAM530rgtw+AJxyVSZW6Xk4jwT9ZIrxYW6f1BxpS0NBufgIaM3q1Rw2
        Y11vrBNlNbueIQU7QF+Knrt3ZfzYhBM=
X-Google-Smtp-Source: ABdhPJz+sfNiNyR43ETZYuV6p44GNL/anOLviJwdtfgeuDu9ljqVegkim9oGHmdh+VeheE/OyP2RLQ==
X-Received: by 2002:a05:6a00:1984:b029:3cd:c2ed:cd5a with SMTP id d4-20020a056a001984b02903cdc2edcd5amr25659869pfl.12.1630371893883;
        Mon, 30 Aug 2021 18:04:53 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with UTF8SMTPSA id k12sm657791pjg.6.2021.08.30.18.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 18:04:53 -0700 (PDT)
Message-ID: <1ef84af3-fbd5-829f-e1d7-276e174b9b79@gmail.com>
Date:   Mon, 30 Aug 2021 18:04:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH net-next 4/5 v2] net: dsa: rtl8366rb: Support flood
 control
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-5-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210830214859.403100-5-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/2021 2:48 PM, Linus Walleij wrote:
> Now that we have implemented bridge flag handling we can easily
> support flood (storm) control as well so let's do it.

storm control is usually defined by switch vendors about defining an 
acceptable bit rate for a certain type of traffic (unicast, multicast, 
broadcast) whereas the flags you are controlling here are about 
essential bridge functional, regardless of the bitrate, I would just 
drop that mention of (storm) altogether in your v3.
-- 
Florian
