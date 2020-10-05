Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214ED282F0E
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 05:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgJED2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 23:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgJED2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 23:28:30 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC32C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 20:28:30 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o25so5110328pgm.0
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 20:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PWg4Pv7I7i8SxJxSi+Yee/MbErvW7PWEAQXEu7kOAmo=;
        b=MJh1Xj0q9WuQaHffsgrapHvKJYXcEH1kcfsAZeAaNZMfHSCmYQ5a0F6B88AqP6Pxvp
         4zuxX0ZLk+c6ISTreSXCuUyfETpUivTdk+qR2B2sj8oZ4t7HzYHDOajwsUt9pGc26+KJ
         R+QSKqxDeE1K3ohheM3sS2mwB9T/mfZEYW9ofOirYLXLM6KlrZSUeLa8FqQhxoc7YXx4
         NGX6e4c8qDqfQ57gUmaCPouyVu5400e4BocWbAcj0nlKkECYV7N2AZBl6dqB5iOjOQsR
         Hirlm7ew/BNEPWyoXxFYydyvCMGG5XovuukUQFXHzMqhIxb1BzDHqKNNeoVHQMlzRXq0
         aVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PWg4Pv7I7i8SxJxSi+Yee/MbErvW7PWEAQXEu7kOAmo=;
        b=Mf1cNr3mdHC9tJlDMk1DrXSKHPoFY2SZJLgP0EU9JMS/83gC3rt2Yhyxsg92a/taX+
         RyO2pEYAw0/0LW9Rq8HdJBAJVySeJLx/GOgPO9t9NHNIVaWT7o6I7CjBJ/RoaCBo5bR8
         OvXqn4Njjy4Z7mksrhl6a9ylKo0W/5R18wOgermIiloG3xVuc6fo/c/t1FPJ/bIGAhFs
         s+PU83woCzw6yDFHBQtnxAPfLgjDYMfztgoYeEkeA1HhGeqkOLFvPiVDE0unZJfOhW8F
         z23mpDo/OzVTG2W1AmyDFDV2XzTn2QT+YcvirXTfAVk/fl7b+GaqcpYdX0ICftVrM+a2
         bxpA==
X-Gm-Message-State: AOAM532uJIAIbw60+P0z0nIdY8MutI3c/CHVCb+UhRlouvavcIw3+ytE
        ZiOUS0KQZVa9LPrwsmpoYMY=
X-Google-Smtp-Source: ABdhPJylTUE8wOqrHkYqos/PbfAoeVM94gJHGvsYG8w01Y8TXCWeVdWtyQrFAj9IcF+FF8L4WfN6cQ==
X-Received: by 2002:a63:d245:: with SMTP id t5mr11773234pgi.283.1601868509710;
        Sun, 04 Oct 2020 20:28:29 -0700 (PDT)
Received: from [192.168.1.2] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j20sm9890134pfh.146.2020.10.04.20.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 20:28:28 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: propagate switchdev vlan_filtering
 prepare phase to drivers
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20201002220646.3826555-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f6cf6685-892e-694a-45a1-1c09ece0b086@gmail.com>
Date:   Sun, 4 Oct 2020 20:28:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002220646.3826555-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/2020 15:06, Vladimir Oltean wrote:
> A driver may refuse to enable VLAN filtering for any reason beyond what
> the DSA framework cares about, such as:
> - having tc-flower rules that rely on the switch being VLAN-aware
> - the particular switch does not support VLAN, even if the driver does
>    (the DSA framework just checks for the presence of the .port_vlan_add
>    and .port_vlan_del pointers)
> - simply not supporting this configuration to be toggled at runtime
> 
> Currently, when a driver rejects a configuration it cannot support, it
> does this from the commit phase, which triggers various warnings in
> switchdev.
> 
> So propagate the prepare phase to drivers, to give them the ability to
> refuse invalid configurations cleanly and avoid the warnings.
> 
> Since we need to modify all function prototypes and check for the
> prepare phase from within the drivers, take that opportunity and move
> the existing driver restrictions within the prepare phase where that is
> possible and easy.
> 
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Cc: Sean Wang <sean.wang@mediatek.com>
> Cc: Landen Chao <Landen.Chao@mediatek.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Jonathan McDowell <noodles@earth.li>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Rewieved-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
