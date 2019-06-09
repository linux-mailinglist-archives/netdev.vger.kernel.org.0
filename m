Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A283A371
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 04:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfFICzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 22:55:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34710 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbfFICzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 22:55:50 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so2293571plt.1
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 19:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6SloElht0+kK9IdeUxCZ/kHHsv5bNLLn40Hb18Nm8BU=;
        b=pYrO7HCkhJeK23EDlJdGEAXjEd6KmXVyDL+A2ovhca8T+gj6zsj2ccknXd4dZCwquN
         2FArIvix/QbUIJzVXrGaebgzdr0YLwYQJnpwD41MAndBOUVVes7XzNaZYdnsaWtmt5/T
         RBWevWmzhpCxlkes1nSSRrX4VMdmin3pyp9/ncVS/Vypt47xH8eVPKwkFw2M02TetcAb
         Azt0+Wq34h5G+dokBFpnGkLxSqYnRE5I+Vdx4Pk8HR1TKbZhvPTc5oUsaI2DCSL/8qby
         yhwuV3sVEf4ZfK3cXOjPF/sJjuyCHgK564lCE40jxsaPcSpOhitiALwzDRo0MhRZNm27
         LEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6SloElht0+kK9IdeUxCZ/kHHsv5bNLLn40Hb18Nm8BU=;
        b=NHyPlABg6uAotGb7GmSVXV9vPmbtyH2qXxHWe553l0/zgbb6afXb3jQLiHFN0NPDee
         rlmi0dfEqJ1fj2ZmjEpwPIdT7rmr2g76W0V4/kJ3a5I53lqFSpzYBZs6dEOQeWNvCqa+
         pc9LMOov1MVOH2A8kwmc3mzt+lS1reNCpoQvNVFrOwCRNZIB99jZxEAwjiyQLWGbuZ02
         eLbXuOmZ5T7V8j8QrT6g2h8F9rQZg+TgYJbSxkaXjfrLr7I5xe2dD9UYPhbMmhx7BITm
         2dgyCBuQC81k3i7hm3Z8lSPKTf2bIHnjsnNphzz2QLR/PNRWybAnM/yDZx+a9cedPh7q
         e7pQ==
X-Gm-Message-State: APjAAAXoYYSd0DO1xSlwL3Pfdi50HnQn3ySWRCs/9dL6ElTm7a0G5unL
        lowZYOXgkeXjJmdEtVLWqrE8qZxe
X-Google-Smtp-Source: APXvYqyDBgNb/sDFnH5gw+7Haqmf4eJtzmxiOeEPdhRjRwF7gbPIoLlRXzZzC0b2vx2tzamespHzag==
X-Received: by 2002:a17:902:2ae8:: with SMTP id j95mr27814765plb.276.1560048949252;
        Sat, 08 Jun 2019 19:55:49 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id c142sm8672174pfb.171.2019.06.08.19.55.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 19:55:48 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: dsa: sja1105: Rethink the PHYLINK
 callbacks
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190608130344.661-1-olteanv@gmail.com>
 <20190608130344.661-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <5d1efb1c-24f2-cbad-77d8-9bd76601a5b7@gmail.com>
Date:   Sat, 8 Jun 2019 19:55:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190608130344.661-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/2019 6:03 AM, Vladimir Oltean wrote:
> The first fact that needs to be stated is that the per-MAC settings in
> SJA1105 called EGRESS and INGRESS do *not* disable egress and ingress on
> the MAC. They only prevent non-link-local traffic from being
> sent/received on this port.
> 
> So instead of having .phylink_mac_config essentially mess with the STP
> state and force it to DISABLED/BLOCKING (which also brings useless
> complications in sja1105_static_config_reload), simply add the
> .phylink_mac_link_down and .phylink_mac_link_up callbacks which inhibit
> TX at the MAC level, while leaving RX essentially enabled.
> 
> Also stop from trying to put the link down in .phylink_mac_config, which
> is incorrect.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
