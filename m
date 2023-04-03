Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89536D527E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjDCUce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjDCUcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:32:32 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1047109
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 13:32:30 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r11so30633704wrr.12
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 13:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680553949;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ey2H8pEuNuKHyUoN1U05NLZzezgDa8OosuFB18eS3w=;
        b=Xn9NBm6y/Gk8de23mO2NnmpY7bZcX+OYSyKDlf8d2ZfM48aZER1PSKuBPdMkmmZ8Sr
         C3UpfxpYBNL9T/rYLAs0w6HZkq7x1yBlt7QTAzwzk8ZxXc+MCKncNODWTETICyC9RGu5
         R7kmwYSOmA34ZOQr2/hTjerqlIWVUTWJLM8r8Z3M3OTUOvmihl1XtwuQ4dcVQAcpYKjN
         im6jnrvB0hCNpGT3Selb0cpy6sjZ6TUqQL3YISnxbmOp52QdQSeojZxwCTJLBWfH+gkA
         JCI70EdzUfUFyYgi9JLHMeCg0aiiSV0dnI2Hbrq2xxrUyMNq9qXGRG1j5BGUBdTz/uhp
         st3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553949;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ey2H8pEuNuKHyUoN1U05NLZzezgDa8OosuFB18eS3w=;
        b=Tuly50G1R/H93ettzL96lcD55bFluP4mQMfQwfIA09JRdLIj9Dpn3jKwPRq+UXm6it
         1WyFoUNMjkfsv6jeMgN1bVuogxR0pdStMc47uVAknKI17AA9yCWUEUk2cf4NBkSjfaQW
         ZpzzYMhq5xLR/dDkT5IBpvQ1CvgPsEgfmCfcnFAfjvpqrZpCkP9eAdK0DY4NsiseleQQ
         Ua5/QCdYuUmZETGBr3+uLmTgQ6As9INjQ0cbTQLEd/NTsq3hjPv+Z9dX09lNy0rGyYI4
         fA3Mfs5xOAnv5+Pws1YCrZ3Ih2vx5+lgkwe2auOvIfd9fwgtIk8FeLlA4aueQ7ssULJ7
         W0yA==
X-Gm-Message-State: AAQBX9f5lEt5e4Tot4tX1Nzh6AmkWsFc/W3SpiodeuAHGfOveGyroONa
        w9wt8Bh/4jKPBNBqPK7I4z0=
X-Google-Smtp-Source: AKy350Y09nlt7QoZGjLJyFWkQV13w+lVrMWv7/7Who3S4/dEjy3tvnn7xWuhBrJDNLqEN6arcEq8tg==
X-Received: by 2002:a5d:4847:0:b0:2cf:e956:9740 with SMTP id n7-20020a5d4847000000b002cfe9569740mr14083669wrs.6.1680553948870;
        Mon, 03 Apr 2023 13:32:28 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b9a3:9100:5849:b3bc:e358:e393? (dynamic-2a01-0c23-b9a3-9100-5849-b3bc-e358-e393.c23.pool.telefonica.de. [2a01:c23:b9a3:9100:5849:b3bc:e358:e393])
        by smtp.googlemail.com with ESMTPSA id b2-20020a5d4b82000000b002d828a9f9ddsm10432160wrt.115.2023.04.03.13.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 13:32:28 -0700 (PDT)
Message-ID: <16b9c260-d744-eba3-5c88-e511465bb94e@gmail.com>
Date:   Mon, 3 Apr 2023 22:32:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     Chris Healy <cphealy@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
 <CAFXsbZq=uzfFjkYw3eWuTjvcGpn6TSoc_OJYCwgthr5jU9qBpQ@mail.gmail.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: enable edpd tunable support
 for G12A internal PHY
In-Reply-To: <CAFXsbZq=uzfFjkYw3eWuTjvcGpn6TSoc_OJYCwgthr5jU9qBpQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.04.2023 22:24, Chris Healy wrote:
> On Mon, Apr 3, 2023 at 12:35 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> Enable EDPD PHY tunable support for the G12A internal PHY, reusing the
>> recently added tunable support in the smsc driver.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/meson-gxl.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
>> index 3dea7c752..bb9b33b6b 100644
>> --- a/drivers/net/phy/meson-gxl.c
>> +++ b/drivers/net/phy/meson-gxl.c
>> @@ -210,6 +210,10 @@ static struct phy_driver meson_gxl_phy[] = {
>>                 .read_status    = lan87xx_read_status,
>>                 .config_intr    = smsc_phy_config_intr,
>>                 .handle_interrupt = smsc_phy_handle_interrupt,
>> +
>> +               .get_tunable    = smsc_phy_get_tunable,
>> +               .set_tunable    = smsc_phy_set_tunable,
>> +
>>                 .suspend        = genphy_suspend,
> Why add the empty lines before and after the two new lines?
> 
Just for readability, because these two entries belong together.
Sometimes it's a little hard to read if drivers have 10+ callbacks
in a flat list in different, arbitrary order.

>>                 .resume         = genphy_resume,
>>                 .read_mmd       = genphy_read_mmd_unsupported,
>> --
>> 2.40.0
>>

