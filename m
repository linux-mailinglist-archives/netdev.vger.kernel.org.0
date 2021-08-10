Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9B73E5732
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbhHJJjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbhHJJjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:39:35 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421DBC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:39:14 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id a20so20262839plm.0
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d2E0nG0ETTBn0qq2WtjDtUP2gKLM8j/WmW5ppqAkkg8=;
        b=A2FC6YVRnrbJky/X230btGVDIvNmMKK6QSI2D/wBl4d/0+sfaKo9RCHksE+aKih0Ik
         aRTZoPudgxzvrn74nSgpfXEkaD428QLeY7TSmQdoK/YHLHRQdcP8KfBq+gwNmcw4tGfK
         Hr+KGoePwNBBtazLDiEOpxASCMRTsL+CtMsTPGj7jGK3l6yrGqWm5uOaMYm+0WS/RXMK
         IaoXRHTrG1LNXv2eeakRx9frNKeN/9t0eWxKE8YewTO2eoADhZ3yZm7vfmPZCECyqc3r
         H4nh0Lr4qMm1Rsu/MYM19/rHWX/1zwi5PvPbCiF1d4yfZbyOzKVW0rQc5LjTKIEKoI6W
         UU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d2E0nG0ETTBn0qq2WtjDtUP2gKLM8j/WmW5ppqAkkg8=;
        b=e7o2phpVoGU60Jab1Xks8jxjzYEWDiMh7CS2KJfKnsKYtZPjnDN7kb22uZjTOjk0tV
         jY5S/FFsUCnX3WZPoE70rL3VqeEtJAyKM0LnvgvLagxMHGA2kH5EiN5PQ7TKIknm3eVm
         oEoHdIMfMiBJUaY/aLDK1YfjLOtmjf+eU8Btkn0Ef0OSHfoQj+7mBw5i7lzlAuLG8Aj9
         /htUs+93J54E+I6UUz1Wvl7QZHjYddrPvHEj9U3d7n8+cK0dA7qkFUU7Kc/RtcA3dh95
         MVryybHJ2F4HgkhWngklSauVeMOONWCoWxdp0PlQ7YFTVgXymeOJyUgGriAyvyrHz7qV
         JaPQ==
X-Gm-Message-State: AOAM531BpSJhu51B8MmfYFaTNLKEri9gHxEE1F3TyhrklY5s74rJkDXN
        FuQxYuBCBeX0GF0Ly2jyjeU=
X-Google-Smtp-Source: ABdhPJxfGoefCLJk5m9Jm8dL5mNDqbHcitgpCjrQAWUSxA204UMrkIqUfJu3N3ayi3QsKt/gbqF/Yw==
X-Received: by 2002:a17:90a:9292:: with SMTP id n18mr4055164pjo.120.1628588353869;
        Tue, 10 Aug 2021 02:39:13 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id v15sm23305554pff.105.2021.08.10.02.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:39:13 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 4/4] net: dsa: b53: express b53_for_each_port
 in terms of dsa_switch_for_each_port
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
 <20210809190320.1058373-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f7de1977-d13e-d6cd-f25e-17eeea294b96@gmail.com>
Date:   Tue, 10 Aug 2021 02:39:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809190320.1058373-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 12:03 PM, Vladimir Oltean wrote:
> Merging the two allows us to remove the open-coded
> "dev->enabled_ports & BIT(i)" check from b53_br_join and b53_br_leave,
> while still avoiding a quadratic iteration through the switch's ports.
> 
> Sadly I don't know if it's possible to completely get rid of
> b53_for_each_port and replace it with dsa_switch_for_each_available_port,
> especially for the platforms that use pdata and not OF bindings.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

We should really be able to eliminate b53_for_each_port() entirely, let 
me try to submit a patch doing that when I come back from vacation or 
you can do it, and if there are bugs, I will address them.
-- 
Florian
