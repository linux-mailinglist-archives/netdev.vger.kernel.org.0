Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5AF4900BB
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 05:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbiAQEPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 23:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbiAQEPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 23:15:19 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C4CC061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:15:19 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id f13so9738542plg.0
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gRavpObHuSI6qH2Z8k0vTjhoA77trTpd0Fw3ZXI9ryU=;
        b=hEQKWKE17RUvnomrju1XvE4fEWHo/VWJFmsOOhlpX32cRr3EoGz0TAy3v5BnGm88Ro
         2C5oUwHpgNYx745sE/VZAKR7KL3x3MokxB9aXeSe3/BvSBcnrT4Vd+gWVY0jsu5t4lZD
         AYqgxwJuKq3PDVJe7bhnuEf8cAdnJGjT1f194pZEHhnLTUyP4tfZj2pAC1lAZsqPBgiM
         Y2HWQWj2a6m337tvNN98BjIGxsLP2GrcAATu52GhGsbK+iPRH3zn9vejC7UzjgTdxRNP
         u8hiuxdEuZ/hHzFDJJQT/raukSJS0zfr4FBEVe8/b1PRe5VStOorv+NjnO27m18aTJeU
         DL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gRavpObHuSI6qH2Z8k0vTjhoA77trTpd0Fw3ZXI9ryU=;
        b=xsb65dbyJV5+sqw1QUA4b9/Ao2Z5pqc8xVVe4Ei+Fcaa3VPM0y7jUmquIbFFl2Wezu
         DVrlDhewW6c97pCty0p6rUe6iPs1FhaJpRMctqOxJa05DofQY8F1YbgVmt24VPU9Addr
         nSQCsWRVT4mbmNE8VX6vI6VezbmEb5STWMcf5I1Y6TiTxcpDzJRbalHfhw5JNoC9oas9
         jhMWf/OJ8f2xgUMMavI9p4qeur3u6Y20auWOdhup8PLsIvV0dgMlUI5ZbiP8CyDQj0nq
         PVDRU9z+6U/xQ13YrbIBX5NXBS12jHp8EZRLlerg6A1Dl5TVYFFboXqs+krBrP0b5UGY
         46nQ==
X-Gm-Message-State: AOAM5307W1kjqPSogdIZAsb7QvlRWtqhonQvSTzEccJ0G4aICfqDWIKC
        Yoh39YKMnyuSSCK+UmnGA34=
X-Google-Smtp-Source: ABdhPJzilUKN4w2OQK5ZNiQWP+irqjqqNU8pmmlS37eIykfk7E2WHrLf3bOCFFSymbhA27lUTyuu/A==
X-Received: by 2002:a17:902:bc82:b0:148:eb68:f6dd with SMTP id bb2-20020a170902bc8200b00148eb68f6ddmr20243010plb.98.1642392918584;
        Sun, 16 Jan 2022 20:15:18 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:10a9:f333:2ba1:b094? ([2600:8802:b00:4a48:10a9:f333:2ba1:b094])
        by smtp.gmail.com with ESMTPSA id r4sm7572962pgp.54.2022.01.16.20.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 20:15:18 -0800 (PST)
Message-ID: <79a9c7c2-9bd0-d5d1-6d5a-d505cdc564be@gmail.com>
Date:   Sun, 16 Jan 2022 20:15:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 05/11] net: dsa: realtek: use phy_read in
 ds->ops
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-6-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105031515.29276-6-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2022 7:15 PM, Luiz Angelo Daros de Luca wrote:
> The ds->ops->phy_read will only be used if the ds->slave_mii_bus
> was not initialized. Calling realtek_smi_setup_mdio will create a
> ds->slave_mii_bus, making ds->ops->phy_read dormant.
> 
> Using ds->ops->phy_read will allow switches connected through non-SMI
> interfaces (like mdio) to let ds allocate slave_mii_bus and reuse the
> same code.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Humm assigning dsa_switch_ops::phy_read will force DSA into tearing down 
the MDIO bus in dsa_switch_teardown() instead of letting your driver do 
it and since realtek-smi-core.c uses devm_mdiobus_unregister(), it is 
not clear to me what is going to happen but it sounds like a double free 
might happen?

It seems more prudent to me to leave existing code.
-- 
Florian
