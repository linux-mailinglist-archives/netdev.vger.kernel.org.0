Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACB827459
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfEWC0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:26:32 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43425 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWC0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:26:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id gn7so1970599plb.10
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 19:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WjASiQyN6e1+ppgfl8dNueZd27mnY9bWJ190JnoYfJI=;
        b=OxrYHxj+jpQTpneVXgW4YT1WkVFEB4WrFWLCzL/EGorQXaMOgKuXH8HWOPiMHPImlB
         2N+Ph9oPGhuwvJxqFIum2CNq9r6PxCkOnLgdLDWh2T5s+RotWuPoMCKgT+FwVioViARP
         /MTnMEiUVURI8UGRlPXumFdewXY1nUxvwuK2F2/cHvKrXFe3poQgeKOySx8FCTl+apZ9
         hJD7FPhqFhTvw0KzvbsOLlvKzenUkoJEehDd+8AbT77+602BMsZEqIYFKpCgw3pxOxuy
         iLsDP4EqxNUMh/J32iX4TVq6zMJ13BDW7KlMTQuW1fOW6KetACS8JiLpuwXVJYODoK5C
         pBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WjASiQyN6e1+ppgfl8dNueZd27mnY9bWJ190JnoYfJI=;
        b=EfdAd/bxPuiBlDJlZmHPrgkjoE8ygcRnx7UHg0F2IKMorUPeMn+Fzo3xCygZmuBtgc
         fEWsZcKF1Rn3wvWRYOIv38TCeO/pZSKaAw0/YMVUruxy8o8T7BOTyMS5yk4A13jzVzUI
         xpDwMGWN6fRmqy/OcyOH6Geg9NHgeix6D/s51FVjRWhii7/Id7JFpg4jGB3ydM1eSWFy
         9MCmJQWXtw/MvsjjwaB6XZ1GP+ztkocfiPcbd7WqzLqwyQWFMWk3eNvN1vza/WxGI+1k
         /xob68je94+N6ffD0QkuEzJR1Cfy29fKRpsKvajAi8DNu6ifTWuRyh255BvtT1tCuYS4
         qJfA==
X-Gm-Message-State: APjAAAVYBT+xx0ZC/S+nMNtpUfjZ3CO70lW0KO2lh0f7CP19oCPXtMW+
        93RoLmyfds07wKi4zN6+RsVXM+xc
X-Google-Smtp-Source: APXvYqzJMRgG7/0P7eDR0qUsmETKEQ6WPq7asLzb2yuR0FTNguSE3liwapieYFBGAylpRF7nY8G3CA==
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr36786969plo.252.1558578391592;
        Wed, 22 May 2019 19:26:31 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r18sm57627981pfg.141.2019.05.22.19.26.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:26:30 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 9/9] net: dsa: sja1105: Fix broken fixed-link
 interfaces on user ports
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-10-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <3472d995-7247-be63-02c2-73515cd1f8ef@gmail.com>
Date:   Wed, 22 May 2019 19:26:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523011958.14944-10-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> 
> PHYLIB and PHYLINK handle fixed-link interfaces differently. PHYLIB
> wraps them in a software PHY ("pseudo fixed link") phydev construct such
> that .adjust_link driver callbacks see an unified API. Whereas PHYLINK
> simply creates a phylink_link_state structure and passes it to
> .mac_config.
> 
> At the time the driver was introduced, DSA was using PHYLIB for the
> CPU/cascade ports (the ones with no net devices) and PHYLINK for
> everything else.
> 
> As explained below:
> 
> commit aab9c4067d2389d0adfc9c53806437df7b0fe3d5
> Author: Florian Fainelli <f.fainelli@gmail.com>
> Date:   Thu May 10 13:17:36 2018 -0700
> 
>   net: dsa: Plug in PHYLINK support
> 
>   Drivers that utilize fixed links for user-facing ports (e.g: bcm_sf2)
>   will need to implement phylink_mac_ops from now on to preserve
>   functionality, since PHYLINK *does not* create a phy_device instance
>   for fixed links.
> 
> In the above patch, DSA guards the .phylink_mac_config callback against
> a NULL phydev pointer.  Therefore, .adjust_link is not called in case of
> a fixed-link user port.
> 
> This patch fixes the situation by converting the driver from using
> .adjust_link to .phylink_mac_config.  This can be done now in a unified
> fashion for both slave and CPU/cascade ports because DSA now uses
> PHYLINK for all ports.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
