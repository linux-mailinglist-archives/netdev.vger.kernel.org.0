Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C503487B7C
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbiAGRdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348575AbiAGRdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 12:33:32 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D1CC061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 09:33:32 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z3so5368687plg.8
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 09:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E/Ti5fam8FLyH98wySojNiBdA8anpYv94ObFch2uoeQ=;
        b=U5yrvQtLBBfZM+xpj5X6Ini1qYdQqRRz4b0rmwLN7soh/UJmgLbAwTYFwAuUyHH5Ij
         R13rZU83mQ8g5PyvEkB+6KZOsUQe2Ztn/6MK8d0MFeFl0/UMlPbb7/CsOUWa8zfHobRu
         X1I0LXLjn2/d/TsUT3LbJAZASqPwKaNydWulayPNmNZFD4qV5w3fJiUlUb/pwgKtvyWF
         LmWn1Jl5fXp2rpx6v+rXih1cz8g7lfIp8yHaPznitqS6/zYaEXARAY4IWYEQTGKM23SR
         NbJYZeptwzFvoqW3m/vqACLZVx994oh5VPaB+c6r3m/+aSY61Skp8U7NVvd2AT9Sgsbb
         kZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/Ti5fam8FLyH98wySojNiBdA8anpYv94ObFch2uoeQ=;
        b=zLxm7Cxe6LHyBqTKi2MVMz/MYmZ71NZ3fVAcoIK5q3oHeO9N1FTJaG3XDyxmjdAHDB
         xwhIZG8E69HU/Du+lSm4pBHzZDQNGttt1ngPJBszfQIMp9qqspcKZYvCnFsniK2v1Lim
         hXJESDaU64lz4im5mr8ev6M4tL3icwgxmYp4SRFq7rUIFU9TKw0mMHJLdmYPDU5UT4U+
         UI2qRtSQ7RVpJfwjb9qwe5yGQMEgLEGWqYfWdpMwKzO2OhsSdGowRXU5wVWbuN653ERv
         dzoWxC9Gy9AR4sgUkP8YEbYFOvSUw449p5Ck/0qF3Yy/qcgWYpBJJ7wKi7CkgbX5e0YS
         pMMg==
X-Gm-Message-State: AOAM530dbP6M01Yr8JvASYhtk+wH9szzONz4jYOzsGEQoaLfoE3ePk4y
        5mH/LGdTMMQGhNYZCuRMQc8=
X-Google-Smtp-Source: ABdhPJw5QWXFJR7tMoaoy09CMRGjY9Vm1F7Q2MPHjPfJ8wwy4Rqsw3PeB3h1FDog9TzoDaaMwmwRnw==
X-Received: by 2002:a17:902:e885:b0:14a:1262:2801 with SMTP id w5-20020a170902e88500b0014a12622801mr1357998plg.122.1641576812043;
        Fri, 07 Jan 2022 09:33:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d17sm6426333pfl.125.2022.01.07.09.33.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 09:33:31 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: felix: add port fast age support
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
References: <20220107144229.244584-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7cff5061-ef98-4593-e109-fa8979bbae25@gmail.com>
Date:   Fri, 7 Jan 2022 09:33:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220107144229.244584-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/22 6:42 AM, Vladimir Oltean wrote:
> Add support for flushing the MAC table on a given port in the ocelot
> switch library, and use this functionality in the felix DSA driver.
> 
> This operation is needed when a port leaves a bridge to become
> standalone, and when the learning is disabled, and when the STP state
> changes to a state where no FDB entry should be present.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
