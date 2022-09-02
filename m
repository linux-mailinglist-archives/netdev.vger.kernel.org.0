Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553A95AB75D
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 19:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiIBRUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 13:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235980AbiIBRUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 13:20:10 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C4F23BD2
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 10:20:07 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so1789868wms.5
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 10:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=6PpIZRvaoxIOKluqpp9kK6PsXeOYuu4+CnZ7rQsB0PA=;
        b=hL8Xj+S9v1BXNbwCYTUujrg34JLNyzO5+2j8Gj4+4km6E1yh5FqvXdtK0EnyCiLNPk
         X24m3gFN4bhj4F15pdqVfLMSRa2xKanwk47ZgWy4cvj4Pr2C61Vx6FdronC2LAX8zT3D
         y7fLEwdu4wKMUPIYV9NzJc58K4Ts5hIYDNaq0LEUta/AxAUradxub9gBJG20qBZOX05K
         pecSD/yATPtu6Ry9rHABoejnr8ahxx3r4WY109zwJho32lahKJ9QKTc9MpW7ESk0bZfA
         zlCHu9k3G70L+G3cycZe/4wbXlM3z91JEW52tGRPjCRXUetJL1nxij8uDpooeuBnbmqA
         rwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6PpIZRvaoxIOKluqpp9kK6PsXeOYuu4+CnZ7rQsB0PA=;
        b=5UUcI5XU2KPE6+7bl45uQzROj1hj6RKUwzJG0coLGdxc2WPrxOcwdRlzPkiA8yXBTB
         OkX57CKJf5qSOAvKsMHjoa9mxY7CJy8ogkNpcg/d+Cv9HeddqCY1botAANUYbQ8Yhwul
         CUAp+/W7RP9fKiXEkbtZz9dmHq7sGvVs6EE4nE+4F/3EpF7dAKUS7IWyjnNkrGg5pdIY
         /2S3XYJ6XohyDXa2XpwvbvJQdL2VOmrC4dHk7mXzrHXyzyLHEa04/OWT7Qe7w1pgvNjy
         24HO6RuQfQAd97Wjzek41mu0cKzdLpbDFOLyuy+YKGV+BlnV9tWv9d1s2wo3xNGLhZWm
         Ctlw==
X-Gm-Message-State: ACgBeo0VxUzTki5JJq7dWXsdteFUNTJ+di0rXdKzlyZLhFXOuSe7tUaG
        ZRuCUUz+RoB0cxh1Gds76XzIBIfFo4/tXQ==
X-Google-Smtp-Source: AA6agR4Xf6WeScULj3lEiXHvJZsD0v5I8q3sP8Ay72oR+gnN1uCbg2wh4fbI1Bk/HrB78XNZg9RZIA==
X-Received: by 2002:a05:600c:2256:b0:3a5:c27d:bfb2 with SMTP id a22-20020a05600c225600b003a5c27dbfb2mr3509908wmm.102.1662139205679;
        Fri, 02 Sep 2022 10:20:05 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f? (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id y14-20020a056000108e00b0022585f6679dsm1968016wrw.106.2022.09.02.10.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 10:20:05 -0700 (PDT)
Message-ID: <353a35c2-477e-2183-109b-e2a08aeab66d@smile.fr>
Date:   Fri, 2 Sep 2022 19:20:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3: net-next 4/4] net: dsa: microchip: add regmap_range
 for KSZ9896 chip
Content-Language: en-US
To:     Arun.Ramadoss@microchip.com, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, Woojung.Huh@microchip.com,
        romain.naour@skf.com, davem@davemloft.net
References: <20220902101610.109646-1-romain.naour@smile.fr>
 <20220902101610.109646-4-romain.naour@smile.fr>
 <cde230f7a85e4f84e3171836cc0e2f73c47d2b82.camel@microchip.com>
From:   Romain Naour <romain.naour@smile.fr>
In-Reply-To: <cde230f7a85e4f84e3171836cc0e2f73c47d2b82.camel@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

Le 02/09/2022 à 15:33, Arun.Ramadoss@microchip.com a écrit :
> On Fri, 2022-09-02 at 12:16 +0200, Romain Naour wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>> know the content is safe
>>
>> From: Romain Naour <romain.naour@skf.com>
>>
>> Add register validation for KSZ9896.
>>
> 
> Hi Oleksij,
> Do we have any support for regular expression support for the
> regmap_reg_range, since all the ports have same register configuration
> except the port number in the msb. Becaue If I need to add regmap
> validation for lan937x which has 5 variant with port count from 4 to 8
> it will increase the file size. Do we need to move the register map to
> other file or adding in ksz_common.c itself is fine.
> 

Notice that the cpu port is special, it has two extra registers (XMII Port Control)

regmap_reg_range(0x6300, 0x6301)

Best regards,
Romain


>> +
>> +       /* port 5 */
>> +       regmap_reg_range(0x5000, 0x5001),
>> +       regmap_reg_range(0x5013, 0x5013),
>> +       regmap_reg_range(0x5017, 0x5017),
>> +       regmap_reg_range(0x501b, 0x501b),
>> +       regmap_reg_range(0x501f, 0x5020),
>> +       regmap_reg_range(0x5030, 0x5030),
>> +       regmap_reg_range(0x5100, 0x5115),
>> +       regmap_reg_range(0x511a, 0x511f),
>> +       regmap_reg_range(0x5122, 0x5127),
>> +       regmap_reg_range(0x512a, 0x512b),
>> +       regmap_reg_range(0x5136, 0x5139),
>> +       regmap_reg_range(0x513e, 0x513f),
>> +       regmap_reg_range(0x5400, 0x5401),
>> +       regmap_reg_range(0x5403, 0x5403),
>> +       regmap_reg_range(0x5410, 0x5417),
>> +       regmap_reg_range(0x5420, 0x5423),
>> +       regmap_reg_range(0x5500, 0x5507),
>> +       regmap_reg_range(0x5600, 0x5612),
>> +       regmap_reg_range(0x5800, 0x580f),
>> +       regmap_reg_range(0x5820, 0x5827),
>> +       regmap_reg_range(0x5830, 0x5837),
>> +       regmap_reg_range(0x5840, 0x584b),
>> +       regmap_reg_range(0x5900, 0x5907),
>> +       regmap_reg_range(0x5914, 0x5915),
>> +       regmap_reg_range(0x5a00, 0x5a03),
>> +       regmap_reg_range(0x5a04, 0x5a07),
>> +       regmap_reg_range(0x5b00, 0x5b01),
>> +       regmap_reg_range(0x5b04, 0x5b04),
>> +
>> +       /* port 6 */
>> +       regmap_reg_range(0x6000, 0x6001),
>> +       regmap_reg_range(0x6013, 0x6013),
>> +       regmap_reg_range(0x6017, 0x6017),
>> +       regmap_reg_range(0x601b, 0x601b),
>> +       regmap_reg_range(0x601f, 0x6020),
>> +       regmap_reg_range(0x6030, 0x6030),
>> +       regmap_reg_range(0x6100, 0x6115),
>> +       regmap_reg_range(0x611a, 0x611f),
>> +       regmap_reg_range(0x6122, 0x6127),
>> +       regmap_reg_range(0x612a, 0x612b),
>> +       regmap_reg_range(0x6136, 0x6139),
>> +       regmap_reg_range(0x613e, 0x613f),
>> +       regmap_reg_range(0x6300, 0x6301),
>> +       regmap_reg_range(0x6400, 0x6401),
>> +       regmap_reg_range(0x6403, 0x6403),
>> +       regmap_reg_range(0x6410, 0x6417),
>> +       regmap_reg_range(0x6420, 0x6423),
>> +       regmap_reg_range(0x6500, 0x6507),
>> +       regmap_reg_range(0x6600, 0x6612),
>> +       regmap_reg_range(0x6800, 0x680f),
>> +       regmap_reg_range(0x6820, 0x6827),
>> +       regmap_reg_range(0x6830, 0x6837),
>> +       regmap_reg_range(0x6840, 0x684b),
>> +       regmap_reg_range(0x6900, 0x6907),
>> +       regmap_reg_range(0x6914, 0x6915),
>> +       regmap_reg_range(0x6a00, 0x6a03),
>> +       regmap_reg_range(0x6a04, 0x6a07),
>> +       regmap_reg_range(0x6b00, 0x6b01),
>> +       regmap_reg_range(0x6b04, 0x6b04),
>> +};
>> +
