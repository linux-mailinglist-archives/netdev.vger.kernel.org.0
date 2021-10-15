Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2F342F9E4
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 19:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242113AbhJORSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 13:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238023AbhJORSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 13:18:04 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4419C061570;
        Fri, 15 Oct 2021 10:15:57 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id d23so9158272pgh.8;
        Fri, 15 Oct 2021 10:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WBU+852C24LCvIYpivfs9O8LFGGPFOo7ZH8BtmCdNC4=;
        b=TGfr9UStHYoJqjhC96U1rii6CH1JoT64eerkCrevRB1+VHlvfdxYw+8k5YsPgefD12
         /TUetV2v90RArPFFuGLnBJhmQO0NgmWGz9GVNWDpTleRdoVEos9skunFO9pizdcwAFRB
         Gz1r7xFlXZgc+/WUTiyvQ5E7sGUwrYY7XJDB7bN08DQigYuXipQD8BLHQfASkybG84bJ
         yAi3sQmD+V6h2bHSc+PB9DP1PxsEHZ3xr0RcQiXXKJphtJezEefUd/A0pL2JvyG7nNjb
         Inz5ZBhrcTRXe2xtG9ZnnReUUJ6Q2AjwG3K65OLbDoBUdxisCC5niKKp9QIVZJQs+H0b
         EqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WBU+852C24LCvIYpivfs9O8LFGGPFOo7ZH8BtmCdNC4=;
        b=NMru2sTLSJku5LrXQcoXwRz0qUshsbxqxtzoeeLFIvQASiinGqAbBTZygjILcDTlLS
         OHBoJ0ychyahc1/yzfadtDqvyB8cr6boqJ7NL9FPVBmBmVWAY4av1VnVXtsw0n4hkkhT
         pAaqr+Ar0EINQspss64OFNd//ch9YDPVbdrKRKveUwlXBALpkxaW/4J88VuZEgY60v2t
         38Ti1nss6HQMrBckWuw+HvyWdzQoiJO5nbJhVVtuROA5Sc811ACjmwC4N4bfHS3cZGGB
         r2no4Yb4HP8MRxMXaFrAo47PzIg7/Rg32pe0clLJakpnZdGwxowDUXNSwZCvYvX5bTNx
         PADg==
X-Gm-Message-State: AOAM533L4Pyc8i+1UKuim7mbkP1NpEZDv+QfRB9V7ROToaUHZWfpyc2k
        rqNLQ5IhcIy5Ux8f/+wtqPU=
X-Google-Smtp-Source: ABdhPJwgNMSm+od/U5t8OTywgAa7TjHYL+xQLgxBtdELzHFcnmEcyqci9dj4evEifJzdqwOhBJjIBQ==
X-Received: by 2002:a62:5297:0:b0:3f4:263a:b078 with SMTP id g145-20020a625297000000b003f4263ab078mr12524004pfb.20.1634318157160;
        Fri, 15 Oct 2021 10:15:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bb12sm1837350pjb.0.2021.10.15.10.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 10:15:56 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] net: dsa: sja1105: parse
 {rx,tx}-internal-delay-ps properties for RGMII delays
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
 <20211013222313.3767605-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cfe7abdb-5f6e-a0f5-ddd8-6500b794de62@gmail.com>
Date:   Fri, 15 Oct 2021 10:15:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013222313.3767605-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 3:23 PM, Vladimir Oltean wrote:
> This change does not fix any functional issue or address any real life
> use case that wasn't possible before. It is just a small step in the
> process of standardizing the way in which Ethernet MAC drivers may apply
> RGMII delays (traditionally these have been applied by PHYs, with no
> clear definition of what to do in the case of a fixed-link).
> 
> The sja1105 driver used to apply MAC-level RGMII delays on the RX data
> lines when in fixed-link mode and using a phy-mode of "rgmii-rxid" or
> "rgmii-id" and on the TX data lines when using "rgmii-txid" or "rgmii-id".
> But the standard definitions don't say anything about behaving
> differently when the port is in fixed-link vs when it isn't, and the new
> device tree bindings are about having a way of applying the delays in a
> way that is independent of the phy-mode and of the fixed-link property.
> 
> When the {rx,tx}-internal-delay-ps properties are present, use them,
> otherwise fall back to the old behavior and warn.
> 
> One other thing to note is that the SJA1105 hardware applies a delay
> value in degrees rather than in picoseconds (the delay in ps changes
> depending on the frequency of the RGMII clock - 125 MHz at 1G, 25 MHz at
> 100M, 2.5MHz at 10M). I assume that is fine, we calculate the phase
> shift of the internal delay lines assuming that the device tree meant
> gigabit, and we let the hardware scale those according to the link speed.
> 
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210723173108.459770-6-prasanna.vengateshan@microchip.com/
> Link: https://patchwork.ozlabs.org/project/netdev/patch/20200616074955.GA9092@laureti-dev/#2461123
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

FWIW, this is definitively a step in the right direction, and this is a
good way to deal with the phy-mode RGMII mess that has plagued us, thanks!
-- 
Florian
