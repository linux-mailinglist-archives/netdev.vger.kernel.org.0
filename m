Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742D02EF768
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbhAHScf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbhAHSce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:32:34 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CF0C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:31:54 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id b8so6121798plx.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MHha8esqBvN69/8JH8dAoEXVd97RlxgY9vW/1xU6L9c=;
        b=aqjB5j8TTSudG7fEkA7vQN4ZF1/14xftQi8/Jullpr6a9qbyksPloia+o35JHK7q0q
         e+IbxFqxK7qf5/vkm1ukE1xJ9VPbTg6jXzTAt80c852Q+WBRN1Z0sfyzsGoc1GRzn9Ii
         17oo/PN/OAMThpwIc0Y8fs5UnreKIeY5N212+e0oSpqFR8YVoX9cl9QPsiEij1PDfsN9
         YADwHvLDUuwsSSuMcragdQY7dODi28jKkgxlnEK72eOzo5tmfwYTnjO6BZw2VRpBMBbw
         +uGzkJXJswqDJ2qGhizWctzd5LH2lTvB4V95rWTsk1Y7SE4kT56egNTXbetwgC3xZHV+
         vFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MHha8esqBvN69/8JH8dAoEXVd97RlxgY9vW/1xU6L9c=;
        b=hEEVmVyoDi6MvbewamAH8s9wvehd9QoGx5YctfZGbu+kblbvr3nPrVLC7Ko86lM4Kb
         LuQ9FStaIOIYoWayzF1RJAQjDA5uJLqIbDt9779cLISCMcCCTGmVDWXny36bQjlUNUHN
         ME+TTuUfwq0Aw1AJILdAVxCUIbqG+vHTRUtPoM8sYoOqEQaUgw4ZiDRMjQzA9uE06Cc4
         8u50sMT+I1SoGQAVH1T0Lc/e0YhnLSkKbmAFr9RwxhzZKDGH6ccJ1u/G8HhypJMJr9Sl
         Q9HKVorXAQ227gUQIynzZEjmMRzlYJyUPOzUZombVvqLHSxOc/Craw9PD4vfh6TgpYUE
         O4qw==
X-Gm-Message-State: AOAM533tx6yYNof5/vmMvTDCu65oseOaOObYxxuTH8K7GTyjd41Lf8+G
        IRxE7wowozhF/j46QQE7j/8=
X-Google-Smtp-Source: ABdhPJwgu5/H+RfxB+ILk07/i6Q/TETlmkfr4XdjcjpKqW7etYU5J+mJRFAKO5HmKg41xWrLyDfzzQ==
X-Received: by 2002:a17:902:9f88:b029:dc:292d:37c5 with SMTP id g8-20020a1709029f88b02900dc292d37c5mr5066111plq.26.1610130714048;
        Fri, 08 Jan 2021 10:31:54 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b189sm9225164pfb.194.2021.01.08.10.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 10:31:53 -0800 (PST)
Subject: Re: [PATCH v3 net-next 03/10] net: dsa: add ops for devlink-sb
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7e36b837-3e0f-df60-14c0-6c028b8bbf9c@gmail.com>
Date:   Fri, 8 Jan 2021 10:31:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Switches that care about QoS might have hardware support for reserving
> buffer pools for individual ports or traffic classes, and configuring
> their sizes and thresholds. Through devlink-sb (shared buffers), this is
> all configurable, as well as their occupancy being viewable.
> 
> Add the plumbing in DSA for these operations.
> 
> Individual drivers still need to call devlink_sb_register() with the
> shared buffers they want to expose. A helper was not created in DSA for
> this purpose (unlike, say, dsa_devlink_params_register), since in my
> opinion it does not bring any benefit over plainly calling
> devlink_sb_register() directly.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
