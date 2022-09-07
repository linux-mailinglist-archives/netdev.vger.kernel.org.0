Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6B55AFC6C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiIGGaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiIGGaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:30:11 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4851FCE21
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 23:29:59 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id by6so14748475ljb.11
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 23:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8T4wFcSQis3DWrnDl8j28CkECsrB4vzGjp7sp/ptmmk=;
        b=E/VyXnfg0tFRH8FjvthPZOKT2HfSWWRnxVcrEw7zn3Fmjjn/DZEt+HpR+IMIF6CQTs
         srbl4WU+QOngLmcgpVBxLHAOizRyjuBRhMae+KobG8kyT1LGl4PBNzFKxWI0P9j99Jnz
         Ert7UPZGT+FZD9jqFgBoCF0LmLIvFsWSe7Wm8JHKtjoG/Uc9e+THXVn7lxqIo1pp981t
         V+paNiCq6rErEnRCRkq/prWh+BjAXPSQC7Z8satLBwqBev5rZlQISE7G/g/+5vy6px2l
         kFJk36yp1TaDUi8y7vvg5JxfFoXVRTj2mLTFkKadeszyUzfJrziUkXSr18/busNDpJqz
         Yf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8T4wFcSQis3DWrnDl8j28CkECsrB4vzGjp7sp/ptmmk=;
        b=M1ITBqB9tLhazIzASLYkfZBv3O8YPw+TIQsviBq6ry6EFVPKNIPbEt1IFRNfZ/rA56
         CW6PwO5807zeVqh+7gy+YfAUR+sVWrncf+I8DPe/5By809OOB/S1Zn4rF3+ppaoFWYiV
         b/OEpVgooxbvWBKz/Z9YuNmsk+F63jd2amWI/RaTxvBzBg1iglqVFbt6DdIYP4Flqj0r
         tH45N7QkQRXUX9WGETvOjSyFDKzk9jMz7lRwCRhbAJF9vEdSeI+YO0RAHmrTLtPfGVOt
         jOku3+Z+Wt5PlseOsdccOjs+N9smjLMgokIwC7upyqjzvQnHeUn1Uo/vk0L5DRddCUun
         H3CQ==
X-Gm-Message-State: ACgBeo0y3VZ7zwbUREcTdiSYbl1fL5G3g+GbqdeqR8ajbB3GNEDPUyFL
        1ZConAqnua/7eNulzwlVh6fki7tgNSZIbMMQ
X-Google-Smtp-Source: AA6agR5nj2e/F+slA+23Cjbxydr3WySjwpoxMRwIjpXReZCdOve/nwocjQkvBM7XGjXhrx1mVacAVA==
X-Received: by 2002:a2e:a4b4:0:b0:268:cb78:271c with SMTP id g20-20020a2ea4b4000000b00268cb78271cmr549235ljm.156.1662532196600;
        Tue, 06 Sep 2022 23:29:56 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id e7-20020a05651236c700b0048a85bd4429sm2245220lfs.126.2022.09.06.23.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 23:29:56 -0700 (PDT)
Message-ID: <8fed012c-a683-89d8-0738-a3ea66412892@gmail.com>
Date:   Wed, 7 Sep 2022 08:29:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 1/6] net: dsa: mv88e6xxx: Add RMU enable for
 select switches.
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-2-mattias.forsblad@gmail.com>
 <d0908a9e-cfe3-a178-1b40-a93b12b980da@gmail.com>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <d0908a9e-cfe3-a178-1b40-a93b12b980da@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-06 23:46, Florian Fainelli wrote:
> 
> 
> On 9/5/2022 11:34 PM, Mattias Forsblad wrote:
>> Add RMU enable functionality for some Marvell SOHO switches.
>>
>> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
>> ---
> 
> [snip]
> 
>> +int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
>> +{
>> +    int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
>> +
>> +    dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
> 
> This debug print is in every chip-specific function, so maybe you can consider moving it to mv88e6xxx_master_change()?
> 

Ofc, will fix.
>> +
>> +    switch (upstream_port) {
>> +    case 9:
>> +        val = MV88E6085_G1_CTL2_RM_ENABLE;
>> +        break;
>> +    case 10:
>> +        val = MV88E6085_G1_CTL2_RM_ENABLE | MV88E6085_G1_CTL2_P10RM;
>> +        break;
>> +    default:
>> +        return -EOPNOTSUPP;
>> +    }
>> +
>> +    return mv88e6xxx_g1_ctl2_mask(chip, MV88E6085_G1_CTL2_P10RM |
>> +                      MV88E6085_G1_CTL2_RM_ENABLE, val);
>> +}
>> +
>>   int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip)
>>   {
>>       return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
>>                         MV88E6352_G1_CTL2_RMU_MODE_DISABLED);
>>   }
>>   +int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port)
> 
> Can we name this argument upstream_port and pass it a dsa_switch_upstream_port() port already?

Will fix.

	Mattias

