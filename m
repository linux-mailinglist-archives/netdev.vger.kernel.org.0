Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECEB2DCAE8
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgLQCPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQCPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 21:15:07 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D448C06179C
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:14:27 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id n10so11223051pgl.10
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XwfNZ2jDMaCzYqPqoDtmm33S2nHDVLbtvH+mo6Lp0v8=;
        b=jEAjzmBuxqic2uXpOO+9I9/KQ3jhD+ISDl5NdL+lagzfRL5/Zm4TMdDlOaNviDycf5
         Zq4BXm1Rsh/wvG4rIE0wK9yKh8MEMvTR8LdvEqf5xcpUmlKEkpiVrXIdsJ2r2nXf6L32
         2e/HLUkbQI69CuN/b1Jr8lWpI7MpX8do3WoD7AVBM9NKeWcy0tCB9ybaHjmrc2Qp5Ro/
         vCfXbLyPGS7snECU+3HwRm7DumSixMgBdTD9ukX9H8hpih75TYSp1OJRtoKRg8jSFe88
         xNATfV7VxPphdfW9mdeuNRlqEcN0JQz+gJ7pgJABz9reCJxmjUUUJ83//yMxSQ3Dc83f
         Wtxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XwfNZ2jDMaCzYqPqoDtmm33S2nHDVLbtvH+mo6Lp0v8=;
        b=Y3g3ZVRK2ekCryW/SbxHp5iiwLa3G1r2FbW8UmyEvEtJiDArweiKh1JF+6ntXNqFxZ
         F8IbvsgWajBMPRhsVJDEnNTwypw29L04nUbGOUg0FTIqS6RNjJr6VeFJvWula+ITtwbI
         uDwIct582OonpgjpRCIjLKFJHjr8OFEfocjmVn1RJoaslgtLlbZcfyay0QAtEybYY3gy
         LDYegKK9qp4sfO3YRZxu3ueJOiLjQUPxznQcthUCCpIN9p4aMU5hmF+q1Y8R8PxSfWR+
         vMtgEaaeUJ1KbKO7fp5q3eJEv65pGhoWu0cw74UxR/VFaiv5LotWimDM1S+1bUQfq6os
         MmgQ==
X-Gm-Message-State: AOAM5338yMUaY032oR7rtbSwFmGX7kLhDv6hKPQJlpEQnuDfabFN9wJN
        7VArTpIUSCvOQAhVLOQcNBk=
X-Google-Smtp-Source: ABdhPJx1Xe4fn+6yhqfF22wCKsiTUG2mqMWSqow1E24L9Nmqy2hX/Zg9I+OOyd7dp59DNw6UUq0R6g==
X-Received: by 2002:a63:ea01:: with SMTP id c1mr6116163pgi.138.1608171267217;
        Wed, 16 Dec 2020 18:14:27 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p9sm3866530pfq.136.2020.12.16.18.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 18:14:26 -0800 (PST)
Subject: Re: [RFC PATCH net-next 2/9] net: switchdev: delete
 switchdev_port_obj_add_now
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
 <20201217015822.826304-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <69abc30b-6543-3817-9848-bfccdac76652@gmail.com>
Date:   Wed, 16 Dec 2020 18:14:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201217015822.826304-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2020 5:58 PM, Vladimir Oltean wrote:
> After the removal of the transactional model inside
> switchdev_port_obj_add_now, it has no added value and we can just call
> switchdev_port_obj_notify directly, bypassing this function. Let's
> delete it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
