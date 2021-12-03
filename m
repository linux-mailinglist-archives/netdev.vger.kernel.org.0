Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF16467E68
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 20:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbhLCTrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbhLCTry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 14:47:54 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF35C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 11:44:30 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x131so3797423pfc.12
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 11:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=02DESyIzbjgbOZDhqo9wX9Q2qNygwOQ/lLvQwUC4LzU=;
        b=khG5l0r7jFFsxtUojzw5dXqrTs5OacbAEAirmb5SgTUlMzHflvmn9UX6y3zRhmSODC
         0XTbUt+rHXvV93UL8IaZu113y0e7H1PsQFNQEJpGJ8kel5+/x2B5hiizLmsn2z6NoVHJ
         zuEHsP5glWpBB/RnAGVkz034/yuPaFwzRRonnS+baDYIWfXptouGt1W7zsOUW3hDB0XZ
         CwFqJqNedvPNKONI4ARjuHiGgKEZ93PCP27aKL/Aacnp7wYoinS9M8kNTa0sCCJw4Api
         AcRPi1MrOhNF3BbYGPC8DDWZVWmG26RfF/LlOeIfpMKdjbtA/GS4WDEefutcIJ3Yl0cM
         7scw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=02DESyIzbjgbOZDhqo9wX9Q2qNygwOQ/lLvQwUC4LzU=;
        b=eOMzUkZ/81/Fer5WTIO9gRjRCf8AvZJcv3+wQn0l/mn90EnI06mUyayKOYdlYxm/HD
         q2nRJs5c/cEStFkW6CwUK2s7BM3FRIwVecCJ/ooZ3KjRkYtuIcK/kKF3aE9NDrdmGBYb
         KqL+t6VD4Bwzv80LpQRIYQaRqbvpedjAdiCowmNpaNmXXvaqj9mx+P5HAX/7iMz4s1aO
         OQAKqJRp3k2FjLMOWjYEcCEZSpdrUCgzZ8cQZluDEpJlbtfKiL2Ns6+u0MzjjbnpMd2b
         gUBCm+Q2nE9u4lSQSmGkXMjqKz0zdM9ctFBDEhIHko23UA4vtk7Fbvedv8jBSqWk+55p
         VKIg==
X-Gm-Message-State: AOAM531xw1I4doUgX7WRKzfiwb1xjXuvMmAvCdoBQFghuqs0jxfv51LA
        45trA/M7Alg05lIlpuatcRQ=
X-Google-Smtp-Source: ABdhPJyQvOcwKx5b4DBrEx8R2aGIKwn3trmq2QyLBMXZSkjGrhJ32kda94bF5oHN+jkuJc5C71qp9A==
X-Received: by 2002:a63:3f89:: with SMTP id m131mr5983516pga.560.1638560669721;
        Fri, 03 Dec 2021 11:44:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id qe2sm3113791pjb.42.2021.12.03.11.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 11:44:28 -0800 (PST)
Subject: Re: [PATCH RFC net-next 00/12] Allow DSA drivers to set all phylink
 capabilities
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <YapCthCbtjXpab6v@shell.armlinux.org.uk>
 <0e6553bb-e188-d7aa-7e58-2c872faa41df@gmail.com>
Message-ID: <5ac2ff62-c1d9-753d-0009-b3a910aff36e@gmail.com>
Date:   Fri, 3 Dec 2021 11:44:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0e6553bb-e188-d7aa-7e58-2c872faa41df@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/21 11:28 AM, Florian Fainelli wrote:
> On 12/3/21 8:15 AM, Russell King (Oracle) wrote:
>> On Wed, Nov 24, 2021 at 05:46:01PM +0000, Russell King (Oracle) wrote:
>>> During the last cycle, I introduced a phylink_get_interfaces() method
>>> for DSA drivers to be able to fill out the supported_interfaces member
>>> of phylink_config. However, further phylink development allowing the
>>> validation hook to be greatly simplified became possible when a bitmask
>>> of MAC capabilities is used along with the supported_interfaces bitmap.
>> ...
>>
>> Hi all,
>>
>> Patches 1 through 3, 6 and 8 have been merged, the rest have not.
>> Getting patches 4, 5, 7, 10 and 12 tested and reviewed would be great
>> please. These are ar9331, bcm_sf2, ksz8795, qca8k and xrs700x. Thanks!
> 
> Do you have a re-based version that does not conflict with what is
> currently in net-next?

Nevermind, grabbed the patches of interest and will report back on the
testing.
-- 
Florian
