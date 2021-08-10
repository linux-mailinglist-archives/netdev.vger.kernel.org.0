Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FCE3E570F
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbhHJJea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbhHJJe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:34:29 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41115C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:34:08 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id a5so4496373plh.5
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ISUMRBOtCvQ3gv+fsGVKsvdTzD8wnrryvuhZTqBLeTU=;
        b=sshDxIEhFuQxBehAkY2gltCaXJQulJhMeQEmrVKx0VfjAKEunKoRm/rB3lpdHcolih
         FK8vdOXdQ4KPOgbRDJI0NW72T5uiVaL8xuHNiIhCWysr6K2RWmGuySgZAWuI3v3hn87H
         2MboVgvYNV/8PD3zZ48pYhnXaZOkHUvSkbYBlRcWdjJ2R77CZldRYawva3l8aC07CFHL
         iX2xjjQES+xCxNtc7rjdd8Occ6xZlw9VACJcFHjC3ixiWRuWgp6jELDg/BhDQU/Z22dB
         wBWfcrhI4ThFyjeBrVrtq+Eask5TnvAnpeP4Twknh2gcgdm4X/7bCdcWzLXCgPpuCqlO
         N5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ISUMRBOtCvQ3gv+fsGVKsvdTzD8wnrryvuhZTqBLeTU=;
        b=XHGeL6brwZt6CZcpxTsrWwZu+1tSUqdTu1ykjQ8BSXTxYoRCCF1vyQ66B6qk9QSzHW
         fQpXHeeCzX7EM9ZpFLU/xq7QrbC0psEKptOOGyimv75LD7hxow77rLMXZpI9oWVBA4B0
         Zv0uRxFK1Vv9N/t7mbPqrrG9dPdyVKQE2cQminUOwcMFxIXmx7NgLEbyjym6RCVSXMHf
         wjQLCIkdknO1kotOaURZz59hfHEYebrFkX1WBqdzoJ6N2jH6Cr9TsqXLGolWdCHI7oEo
         A/tfp6IaoGO+eO0IPJl2nZA27SiK7BLUzZI2H9xaWvRH0wvw+1hFyRpCtyLLHT+ebzZ0
         8FFw==
X-Gm-Message-State: AOAM532Nh1CPjjR03HwH872OSZYjF+dRposRXMUEs8ekAKbZjQriTHPP
        NBoe4FC4n/ZdZLRM980jb/o=
X-Google-Smtp-Source: ABdhPJyPPds3DkW9QJ9iGQjhgzmwtFuN8QYwNsX4Pg6UyDqaBO8jE01naBmERA/x4umfqujOmbzz+g==
X-Received: by 2002:a65:6787:: with SMTP id e7mr519586pgr.345.1628588047770;
        Tue, 10 Aug 2021 02:34:07 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id x19sm23523266pfa.104.2021.08.10.02.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:34:07 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/4] net: dsa: introduce a dsa_port_is_unused
 helper
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
 <20210809190320.1058373-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6f369fd7-02bb-a543-4696-0a6a8ec3f48f@gmail.com>
Date:   Tue, 10 Aug 2021 02:34:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809190320.1058373-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 12:03 PM, Vladimir Oltean wrote:
> Similar to the existing dsa_port_is_{cpu,user,dsa} helpers which operate
> directly on a struct dsa_port *dp, let's introduce the equivalent of
> dsa_is_unused_port. We will use this to create a more efficient iterator
> over the available ports of a switch.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
