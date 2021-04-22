Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355D1368600
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbhDVRdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236660AbhDVRdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 13:33:17 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F170BC06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 10:32:41 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c3so13413249pfo.3
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 10:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+I8Y0kmKSwaa9lQS96JTngWmipK2WHWBBOyeAXUwAZI=;
        b=reE/NHupui8FpIX73j+GB4wbeHQ/fGfGPyzNzL1QjW0Wv0wGkMEPPBEz1QOvlq5rED
         oCBOh187V9Mi4mzsw53iETTtVzmzfHQSFIES87qH45WQ75QYlQ3E5rxxCmsxShv5bhm0
         6dvBV3Fl1B4jcvmDLCqCtGww9x54r1JISLBkopYHuPJdC9cBeWaLsbcBdPF6ykcTaL2A
         xcfhavACKJStpNpujsgX6hWOzUyqP2jqAWK2tnw8EAuRuibKqjMM5QfUXy4eeljli2MN
         AlPwBOtE8xLxiOIGive7Cj7MBbUq24XqeW3Zx65D1mjdwnSz7+EsMr7ZylXXFYRhJAyY
         muLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+I8Y0kmKSwaa9lQS96JTngWmipK2WHWBBOyeAXUwAZI=;
        b=BWaGMym5jlb7wqMkJztIVVEHADwCZWNj/4yP4toeLVe2TIbNQRzYr4WZdm19+v9WRR
         IR2lPPUcSJsJxt7dnBEVMh+XCnAJvKCkU6tzCQbe7EQpsF1vEaU2Yqs+vbYo+di1ft2+
         5ogbXqKnSb4+TRIXQjGubBlN/IfrRLCzjG6Nq05TBXHNbuVI/CaGHl98QPBxJ9Nil224
         f0ohfCHES6/L2HfxbmOLBTtf98O5yw+Sca3s7WjeDjRoPgosguxKxp3kkevwEnb1FoH1
         Kv5wXXkGc2YeLhWB08aJe4C75O7ZgVEKntN1vdW13UAS4SnE5cAVsXBlmuJ0FW3Yg+ql
         S+vA==
X-Gm-Message-State: AOAM531yC/vyFHQyD+1CyO8h32iahAbaKAO9osoWsp+nt83D0GhDEdma
        NVFbeSwCg5Gsp+Ufu5Wh6N+WCArB8Kc=
X-Google-Smtp-Source: ABdhPJwin8SePZUAX8ND8YCAzur/fgRSg5aa4mZrfgR6TmlWopPTBwfSrLNtf484tn9rJdghvTtbjA==
X-Received: by 2002:aa7:904e:0:b029:25a:4469:222a with SMTP id n14-20020aa7904e0000b029025a4469222amr4359393pfo.72.1619112761032;
        Thu, 22 Apr 2021 10:32:41 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e14sm2757089pga.14.2021.04.22.10.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 10:32:40 -0700 (PDT)
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Jon Hunter <jonathanh@nvidia.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <2cf60306-e2b9-cc24-359c-774c9d339074@gmail.com>
 <9abe58c4-a788-e07d-f281-847ee5b9fcf3@nvidia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <22bf351b-3f01-db62-8185-7a925f19998e@gmail.com>
Date:   Thu, 22 Apr 2021 10:32:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <9abe58c4-a788-e07d-f281-847ee5b9fcf3@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 10:00 AM, Jon Hunter wrote:
> 
> On 22/04/2021 17:12, Florian Fainelli wrote:
> 
> ...
> 
>> What does the resumption failure looks like? Does the stmmac driver
>> successfully resume from your suspend state, but there is no network
>> traffic? Do you have a log by any chance?
> 
> The board fails to resume and appears to hang. With regard to the
> original patch I did find that moving the code to re-init the RX buffers
> to before the PHY is enabled did work [0].

You indicated that you are using a Broadcom PHY, which specific PHY are
you using?

I suspect that the stmmac is somehow relying on the PHY to provide its
125MHz RXC clock back to you in order to have its RX logic work correctly.

One difference between using the Broadcom PHY and the Generic PHY
drivers could be whether your Broadcom PHY driver entry has a
.suspend/.resume callback implemented or not.

> 
>> Is power to the Ethernet MAC turned off in this suspend state, in which
>> case could we be missing an essential register programming stage?
> 
> It seems to be more of a sequencing issue rather than a power issue.
> 
> I have also ran 2000 suspend cycles on our Tegra platform without
> Joakim's patch to see how stable suspend is on this platform. I did not
> see any failures in 2000 cycles and so it is not evident to me that the
> problem that Joakim is trying to fix is seen on devices such as Tegra.
> Admittedly, if it is hard to reproduce, then it is possible we have not
> seen it yet.
> 
> Jon
> 
> [0]
> https://lore.kernel.org/netdev/e4864046-e52f-63b6-a490-74c3cd8045f4@nvidia.com/
> 

-- 
Florian
