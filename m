Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80893CCB47
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 00:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhGRWWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 18:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGRWWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 18:22:24 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2980DC061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 15:19:26 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m11-20020a05600c3b0bb0290228f19cb433so11625817wms.0
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 15:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OE/LMuYqjnJUIStGdObqSisI/+g4NzXiAhPzhfCrwtA=;
        b=hvbdIOEHwsaygA6vy7x+KgxAmV0wX8tqO9DLtwsF2UUyGkXyqwTzBAPkMfXSuDOFfV
         3wMk+G2yGBKR6B2yHWvt9Za3XKVlCEqFYm1P+BM671BQkRqtYahJZT3KLiDXMR3P+PRQ
         bAsY1Pti6JXmwlTWbaz9uF+274Ora7o6777uCZYrwcf3El2NDQUvaei5Nn4jqf76XDYp
         4orvrXWudA5pavCgRzYVspx5WwgB3WaJnFd288q1KXZwR8JVSppPs+sjswq4YITQOU6F
         XehHo0Wu8/uBNEKxPFFNucPUU82lRdAmP+GGfQcHTz6ehZz0JSdjlUbtr0zosYGaTzwP
         hciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OE/LMuYqjnJUIStGdObqSisI/+g4NzXiAhPzhfCrwtA=;
        b=cyAV4hYLY9rmZinslnRj798zRGbMLcfitYNeZfWRd3LxVOB/6T1vy0ObfOVnnHxs2w
         8rVAEUHZWp4MD4/pK5/rY4r4CYk5yVHON+zJqIkzuDFdI3efrkPAhgWjSUN20wmOw0hQ
         K+RXJBzapj2Wh2leiGGlcQkOTGe9YOWwW6XQesBYnBpedcAJCWLioYLXyGJLEUI1htHM
         MH0lIILvqUC8ADdVLBqlsqJY0S8WRfQKj7vR7riGPHc+lm4PvupQSkhnkkv+yRKNzKfH
         KAhr1oIWEdQE/5rJTmrYSLB0+tuKcuLCvo2PgylS35tEEX8Ecgm3KklplaZ/LTo3Ne5a
         xbFQ==
X-Gm-Message-State: AOAM5338K1ApCliLxtTquZSgvB7qe6Nz++IY4D2jglkFO+TOEnJzr2dd
        CPBAd6W9obVayjD6QyVTAvjyqjQInSqL/w==
X-Google-Smtp-Source: ABdhPJzHGy1pHEieFWL2KKW/VcdxxMgXfDpKVKhTWq9tMMzuny3hLSgxHvyzgcUe3F3gYtDm7MsbrQ==
X-Received: by 2002:a05:600c:33a2:: with SMTP id o34mr5720376wmp.157.1626646764617;
        Sun, 18 Jul 2021 15:19:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3f:3d00:8dda:3d64:bacc:f1f5? (p200300ea8f3f3d008dda3d64baccf1f5.dip0.t-ipconnect.de. [2003:ea:8f3f:3d00:8dda:3d64:bacc:f1f5])
        by smtp.googlemail.com with ESMTPSA id p11sm18126834wrw.53.2021.07.18.15.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 15:19:24 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <YPIAnq6r3KgQ5ivI@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <f42099b8-5ba3-3514-e5fa-8d1be37192b5@gmail.com>
Date:   Mon, 19 Jul 2021 00:10:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPIAnq6r3KgQ5ivI@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.07.2021 23:56, Andrew Lunn wrote:
> On Fri, Jul 16, 2021 at 02:24:27PM -0700, Tony Nguyen wrote:
>> From: Kurt Kanzenbach <kurt@linutronix.de>
>>
>> Each i225 has three LEDs. Export them via the LED class framework.
>>
>> Each LED is controllable via sysfs. Example:
>>
>> $ cd /sys/class/leds/igc_led0
>> $ cat brightness      # Current Mode
>> $ cat max_brightness  # 15
>> $ echo 0 > brightness # Mode 0
>> $ echo 1 > brightness # Mode 1
>>
>> The brightness field here reflects the different LED modes ranging
>> from 0 to 15.
> 
> What do you mean by mode? Do you mean blink mode? Like On means 1G
> link, and it blinks for packet TX?
> 
Supposedly mode refers to a 4-bit bitfield in a LED control register
where each value 0 .. 15 stands for a different blink mode.
So you would need the datasheet to know which value to set.

>     Andrew
> 
Heiner
