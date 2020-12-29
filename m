Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BDD2E6D87
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 04:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgL2DPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 22:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgL2DPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 22:15:22 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD67EC061793;
        Mon, 28 Dec 2020 19:14:42 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id w5so8470564pgj.3;
        Mon, 28 Dec 2020 19:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tjd/OXf18xEhxGNxVftvNLNmW8+p3AhfTQkFXz0FtiA=;
        b=nC8k5uortZIcgEV6k+zxbPZYIj5DnJyPB3CWuefwHOnoTBsMzThKajEs7EGzEirdAn
         F+41ynsfzQpdYCXYwZ3EoUruBu5LweFTcS6F5o2MrCHeJBV/iHYERtTW2LTTInw8P3Yq
         QzOm+a8v9myyGbzieoGoabwc3fmZm/fvzfISRoG3tLpJ0H9LVa73od7YmYvpWVYuAYvu
         SSvUaHbHsac9OAzqBL7hSoACeJTb8FhfY0krpoRBcdFvh71ZXEx33Z7WMKUxwcD8yB0K
         KNfwGvAyjW/vgKxMoPjba4kpTNS10XPi0NMOWEe4e0xh4h/HnHrvOaL17dw5SD2OWHt3
         JtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tjd/OXf18xEhxGNxVftvNLNmW8+p3AhfTQkFXz0FtiA=;
        b=oLuC6aNTKUIoCgD+QoRQV7Omj+tJ0uhGAP49ODH/ffPHSVu8liPLlAzcMPuNw1nnKy
         WYpleftzWvBxY00C4V0aeKrW6MDvnXK6H3ngE5N/cI9huCoKggp9dmo8CJcry8khM1Tk
         lwfaWKUQeizmVxRXx4oplPNO+Ll9tWZRnzWtiiLbxYKIVit4KjFzLdhzyzoD5Aq+YGgq
         tPAjwmHnocgO2A89Lnz0Xxhnf0rT2we9VL9VzmygtEwn1r2m+SNrP0zM9QArJo47YDAV
         yNdVvJ2Q5u5aW2BG124dCmzqE7ucaBtCgmgHL/fD3xh9W2A+Eyr9mgjn9jcRIKyK6kr/
         ECCQ==
X-Gm-Message-State: AOAM5303rGJ8M7km3BmPSY/jqLSewtIUP4Nc3Yq1WiXssCn73gtiMWOS
        DtVbv1nMfjF17cImr2Dc2wHZ7d7U29c=
X-Google-Smtp-Source: ABdhPJx46TzljXVa78xkHySDM0YXs4TbZKXISBuNFpGG1HvivD+ck+8u+FziQ0FGSS+r6eCg5cWiJw==
X-Received: by 2002:a05:6a00:228a:b029:18b:212a:1af7 with SMTP id f10-20020a056a00228ab029018b212a1af7mr42879341pfe.55.1609211681825;
        Mon, 28 Dec 2020 19:14:41 -0800 (PST)
Received: from [10.230.29.27] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p15sm38370621pgl.19.2020.12.28.19.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 19:14:40 -0800 (PST)
Subject: Re: [PATCH net-next v2 4/6] bcm63xx_enet: alloc rx skb with
 NET_IP_ALIGN
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
 <20201224142421.32350-5-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f5ea41d8-3870-8a48-21c6-d5d81abebd3b@gmail.com>
Date:   Mon, 28 Dec 2020 19:14:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224142421.32350-5-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/24/2020 6:24 AM, Sieng Piaw Liew wrote:
> Use netdev_alloc_skb_ip_align on newer SoCs with integrated switch
> (enetsw) when refilling RX. Increases packet processing performance
> by 30% (with netif_receive_skb_list).
> 
> Non-enetsw SoCs cannot function with the extra pad so continue to use
> the regular netdev_alloc_skb.
> 
> Tested on BCM6328 320 MHz and iperf3 -M 512 to measure packet/sec
> performance.
> 
> Before:
> [ ID] Interval Transfer Bandwidth Retr
> [ 4] 0.00-30.00 sec 120 MBytes 33.7 Mbits/sec 277 sender
> [ 4] 0.00-30.00 sec 120 MBytes 33.5 Mbits/sec receiver
> 
> After (+netif_receive_skb_list):
> [ 4] 0.00-30.00 sec 155 MBytes 43.3 Mbits/sec 354 sender
> [ 4] 0.00-30.00 sec 154 MBytes 43.1 Mbits/sec receiver
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
