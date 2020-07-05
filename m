Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA8D214FBF
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 23:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgGEVJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 17:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEVJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 17:09:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE61C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 14:09:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m22so7084004pgv.9
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 14:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/hC6iMBdGSn/XFu7o48pgXF3oqQMYy8GJrUhNLXbjMU=;
        b=C0qAHl6l2uAoUMKLXHJ0cMICIAUpHcZtMioAq0sPKgjzTyCaiF6qrT5s8nMX7B3bRa
         Je79KrOoPycb2HIzcE/fOwmGs+fjMuJXVU8bPegpHfZDWy0VhMkOlEprCK2bPXtIBPHT
         mXPJOuh0TJURk6MORPx4bQn7Rxd/ykuE22HL/R7Bsp3TBajucOPEeomXTDxlAxVp44ee
         2M13Oe3Vm4pjNUZht6n5pUH5skKtZHex/zoy//JtYvk14XVQrX2VPMe1xJ+vIQ5bAVQM
         O0/JqLnRcE9/t+twuRj9R3eM0st7BnpCOym7ujxsInKmd0n5ugpAY8lio1zjMt6FXnw4
         6N1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/hC6iMBdGSn/XFu7o48pgXF3oqQMYy8GJrUhNLXbjMU=;
        b=CJA/JDHolVf3BmzSFTjJkPrir59ITP6HSIM2agFDV9HWaLQZCX7iNBkU59qlZQqTSI
         AOrOySUzdHtWn1m4PNZQelE6deUNfAPC0sNsOtlvoDVm6Jsvmya+WIpLgdLMIfOfUud3
         vO9zinSwY9CUPfmVTRu0WboGSDbNERsE6PjxeYFyEtDJoxXTlfbFQde0dgZq46ZSVcnX
         m3D7SrIlNWSWlFDYIaI6xNAXUN4JDrezcHj+rQgk2NFLIay1t7YfJjeQ6IyeXHuQTkC4
         y1hs63ocmB3dMcqt25z2cpxSPs8HMM8waP/vwKiR1Ued6+6S1QhqCZ/A2gXr9Qoc0O4w
         Eu4g==
X-Gm-Message-State: AOAM533FHGxrWxmDW5iz5xNGnE+yRXo4TcOS32wHXYh9HpgXL2PJVCap
        uNvWYvrt9Lb28JqUjeXabdc=
X-Google-Smtp-Source: ABdhPJzSRNiNhezrk272OQV1eg8XaDl2DV213rAJokQmQWr4Xtmw6Iprh+MGBjGULqnrynMqT+WOsQ==
X-Received: by 2002:a63:4c08:: with SMTP id z8mr36463702pga.201.1593983374190;
        Sun, 05 Jul 2020 14:09:34 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id q66sm736873pga.29.2020.07.05.14.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 14:09:33 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 4/6] net: dsa: felix: set proper pause frame
 timers based on link speed
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        linux@armlinux.org.uk
References: <20200705161626.3797968-1-olteanv@gmail.com>
 <20200705161626.3797968-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3b84975f-5990-b4d7-7c4c-df42459172d2@gmail.com>
Date:   Sun, 5 Jul 2020 14:09:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705161626.3797968-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 9:16 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> state->speed holds a value of 10, 100, 1000 or 2500, but
> SYS_MAC_FC_CFG_FC_LINK_SPEED expects a value in the range 0, 1, 2 or 3.
> 
> So set the correct speed encoding into this register.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Did you want to provide a Fixes: tag for this change?
-- 
Florian
