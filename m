Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B116C437C10
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhJVRmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhJVRmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:42:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A18CC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:40:05 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id np13so3450316pjb.4
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3+M/uV7IF+G3Cwjai4LQ92zUifisbhBwSkDnCPVNXSM=;
        b=BqDzLyzPa1j3+rhNI4/yVQGKeT1U7/5XPQ6DcQbHaWFvN/Yu3v/hmlBdLI/BJE6kao
         9LSgDRCLaB0aKADA5MS7MqeMGoT7mvzxQgQiel/7ng/KfLh1M7BMrsMe4jq5STZ+iDBs
         csrObP6DVAH0j71mNLRypIQKQyeQgVrulh0QC2OYZkfjvYEuQrBAev/lcuMnD+y2EykG
         dJmttDGKE3L1C1lTfafOncfvJ8wI699AOCG9iT3b8giMQL69hoQIrSlQ3o0Y+WHnpq9Y
         DgAb/nvRTCM6AHCtTLnG8ILmO8jCK/re9mDA5pCpKx0923Mhl4ILAd4Jr7qzJGt1h8b2
         Co/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3+M/uV7IF+G3Cwjai4LQ92zUifisbhBwSkDnCPVNXSM=;
        b=3tpqXGNNyqlZcD7Pp9RVcow61tW5Bpx6uvFHsGrpGewkFCo/bdZXnwEAjkB9ZVUpsE
         1c/3qrBEDialv0ipenXAITeiRYkOuF28LmJi4tY3PiuVUDb8+H32i75vp/fovT59fjQZ
         ZaKmjv0ND35GV2Xk69icO5j+sfFnkefTk+QU2Y9hkoCkxG+QXvke3/PWkmBSyX6eV+id
         USRHvZ05vpQIU0YrVprbFOYHEIElos+xomPSpOhAv6icDgzrsW8EpXTIMZ9Y+zVWF/0l
         wNU9mWbLzN0OnftY/DpcyOb14+XqHE9i1Xu4Zbt7Qjf4eDIhkrr3FNQXMvosQhnhrSGv
         NTYw==
X-Gm-Message-State: AOAM531sz0zt8kqQSQwRLzBuoY8l9QgqNc0O4mUmv4WSQC7PRR2F1aMu
        5yY+5pN4pgqrpjYCeyv2HMI=
X-Google-Smtp-Source: ABdhPJzKDAqMOn90dNWvx9n0UnoXcOZ2ZgjKUpjp7Na6eaV1iPdmn989bNC4rqDTSKDVtUqLBwJsdQ==
X-Received: by 2002:a17:902:7243:b0:13f:505b:5710 with SMTP id c3-20020a170902724300b0013f505b5710mr863250pll.36.1634924404967;
        Fri, 22 Oct 2021 10:40:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c3sm3497736pji.0.2021.10.22.10.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 10:40:04 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 9/9] selftests: net: dsa: add a stress test
 for unlocked FDB operations
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
 <20211022172728.2379321-10-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b0c589f4-35c6-c743-7ebd-f23ff546fc1e@gmail.com>
Date:   Fri, 22 Oct 2021 10:40:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022172728.2379321-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> This test is a bit strange in that it is perhaps more manual than
> others: it does not transmit a clear OK/FAIL verdict, because user space
> does not have synchronous feedback from the kernel. If a hardware access
> fails, it is in deferred context.
> 
> Nonetheless, on sja1105 I have used it successfully to find and solve a
> concurrency issue, so it can be used as a starting point for other
> driver maintainers too.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
