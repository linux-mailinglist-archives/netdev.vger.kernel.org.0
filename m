Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A53407E77
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhILQPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhILQPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:15:34 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FD9C061574;
        Sun, 12 Sep 2021 09:14:19 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id 22so7932994qkg.2;
        Sun, 12 Sep 2021 09:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=P60SQ/CsW1eZndcpQR8AR/xrEVIdL+Rao4L2rbgdhaA=;
        b=HUwk6qnr0kgyqmTOdj14K7PvRl+vIgLwhfa/Soxserjlx37Q0bl82oHT4huLR3WgeI
         ulPWtV72/igDuyPZofm4nb4dckNhxmprUg38UWVo82a3Ykx8O2lBRxLO3iNi63n2Tu4f
         HOf9CaMXpjic2WE20hT1aDR7vdocgvMZDfCkWbq6EmVifM3Z54ZbqLU9GGkNE+Bv41S5
         jHaTArKj1jA2hXTnoF+JnyIZOpCvlyn+m9mau3lq0PprQygy/o20YjltGrBjt31GQEJ+
         EE7gWGuBUAOOfH/adHuIEKG0qB2zLImFBPmodyG7nJdrHzzSsd3OTUomkJBeeKHlIdR/
         9Q1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P60SQ/CsW1eZndcpQR8AR/xrEVIdL+Rao4L2rbgdhaA=;
        b=QgIlnQlgReqoi98Z4L8VWMn33HSJVKyiC51EAEm0JlQQf5wvhmWZ9VR7RXvqf+7QZX
         xrUMqexk9Zs/mJgrclpq2PkvTadQ53KHwDel1DZ5Jtb+NcrddwIKHsYGNOQ2v2E+f56R
         0BIR7CXQ23hlJrSdlapZHnE7u8FYZDNGi1bAxEdKL/tyPMC8v8jKrc0CTDGUrCmgejlw
         m01TE7AxytNU0mU+Xxm09y0dt8yyXFNmRLrQBxwtAPr+7OIhEJPR6yUNEbn0ntuZv/WW
         VWwhKX2w9G7OjvyfvFcH8BkMXD9rurbFmI/rFNlO6QIcOuB68RNwZ3y+iFZe7qsr3Su5
         JAQw==
X-Gm-Message-State: AOAM5314Eosh35vjjD7QIM+24tcnkov0DuJY9I+fTQBUa+xLDIse4Q5X
        hGORhCWP1nBOpCTVNyxr8mZE/G/Ass0=
X-Google-Smtp-Source: ABdhPJwCHzJ7tC9DgCi07ahFY8D4qJ10evt3UqKBcCnZz212piHDTdmcK+JNd5y6GzOPE3C02xNDQw==
X-Received: by 2002:ae9:f40b:: with SMTP id y11mr6289972qkl.107.1631463259134;
        Sun, 12 Sep 2021 09:14:19 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:b198:60c0:9fe:66c9? ([2600:1700:dfe0:49f0:b198:60c0:9fe:66c9])
        by smtp.gmail.com with ESMTPSA id y12sm2693999qtj.3.2021.09.12.09.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 09:14:18 -0700 (PDT)
Message-ID: <c745be4c-2b7f-3f36-36ce-75ae8601a697@gmail.com>
Date:   Sun, 12 Sep 2021 09:14:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net 1/5] net: mdio: introduce a shutdown method to
 mdio device drivers
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
 <20210912120932.993440-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210912120932.993440-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2021 5:09 AM, Vladimir Oltean wrote:
> MDIO-attached devices might have interrupts and other things that might
> need quiesced when we kexec into a new kernel. Things are even more
> creepy when those interrupt lines are shared, and in that case it is
> absolutely mandatory to disable all interrupt sources.
> 
> Moreover, MDIO devices might be DSA switches, and DSA needs its own
> shutdown method to unlink from the DSA master, which is a new
> requirement that appeared after commit 2f1e8ea726e9 ("net: dsa: link
> interfaces with the DSA master to get rid of lockdep warnings").
> 
> So introduce a ->shutdown method in the MDIO device driver structure.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
