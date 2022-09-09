Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525885B30B1
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 09:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiIIHlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 03:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiIIHki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 03:40:38 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6FD12463F
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 00:36:41 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f14so304934lfg.5
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 00:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=3jlQpqQP8wu2BH0IZiLWUPEleca8l2DARj572CEMtt8=;
        b=Xh9hoylJ4mIg85t5TdI9rsD40sd/XX1G0v+aSxsuHt61C31CO+J2NxCGy5IF+dd0uJ
         bsnTOlf5MBGk9dLpXxYF/5B8VuvlFEgbFtlbxxq6We6ywL1KQarqAanQqUXEIxnBu2Gf
         8KFBdQlNxQr/UIBkZUdu6K64mCgOIzg8XpuJ2O5qX+6vP8FHyQE+EZivufaLMsio95DW
         3eHicLrOWHaGtkt7EIzpuaiqXnBgAo1/agmJLcA14uA81UWn/0e9qJWONNZH5/Iy/5wn
         EvA9Xs19h+fBEMZmAi/sSD9vDB/i+7H+Ul5FYC+6YU/iAGhOIVjlBLxEmFp7XZetAsIn
         Vrhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3jlQpqQP8wu2BH0IZiLWUPEleca8l2DARj572CEMtt8=;
        b=lARFXB0tuc0T7cX8k2H9Sks2JLeYt6afvDr58NMk0g8nzv9/VzHusKxbxgNqJf747R
         gEQkeP5xjl7CqsaJjYuYPJVlXbcxCr6GEuK1z6RxdP9g7Uk3QAkovT1grIJRO+m49Bdt
         A5iqZUAfC4LgfJCLKySCWZ7qBRqwoxB9TP6yul1oCR/MaQ3yhCaZMl12Q7rObsAg3SeD
         ySg44Z5ideHHFki7iqHzVvrX+kmmi4ny/AqAu+9aIquCZFrConFJHvn4etVfdVX/EmJx
         e4T4RcQ3RTvBFv3DRVihc+EmKmMViZtxwDLqivR5z2x7+oiwOeowWTNP/elc3rFUUFyC
         hf5A==
X-Gm-Message-State: ACgBeo1U6D6j+nPN46GVw8ZLZCUQ0sq7m1dCweATocowVXOFAzFaX0ov
        HNukgq8fYld4sAGbtVTyg8Y=
X-Google-Smtp-Source: AA6agR5BuzHd1PaeDC3iAmvQa4bP4Gcp2sv+TlO6XGetOeP/XUSlYkYTBwzWN7xH37HTq9/Z0rSiHQ==
X-Received: by 2002:a05:6512:304c:b0:494:8cd2:73bb with SMTP id b12-20020a056512304c00b004948cd273bbmr3735526lfb.207.1662708987162;
        Fri, 09 Sep 2022 00:36:27 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id a18-20020a195f52000000b0049311968ca4sm154843lfj.261.2022.09.09.00.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 00:36:26 -0700 (PDT)
Message-ID: <c70f64b2-6651-8090-82ad-f264455291c3@gmail.com>
Date:   Fri, 9 Sep 2022 09:36:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v7 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for
 reading RMON data
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
 <20220908132109.3213080-6-mattias.forsblad@gmail.com>
 <YxqbvwlHi4Au0Q5Z@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <YxqbvwlHi4Au0Q5Z@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-09 03:49, Andrew Lunn wrote:
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index bbdf229c9e71..bd16afa2e1a5 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1234,16 +1234,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
>>  				     u16 bank1_select, u16 histogram)
>>  {
>>  	struct mv88e6xxx_hw_stat *stat;
>> +	int offset = 0;
>> +	u64 high;
>>  	int i, j;
>>  
>>  	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
>>  		stat = &mv88e6xxx_hw_stats[i];
>>  		if (stat->type & types) {
>> -			mv88e6xxx_reg_lock(chip);
>> -			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
>> -							      bank1_select,
>> -							      histogram);
>> -			mv88e6xxx_reg_unlock(chip);
>> +			if (mv88e6xxx_rmu_available(chip) &&
> 
> I was trying to avoid code like this, by the use of the ops.
> 

The call path with this patch is:

dsa_slave_get_ethtool_stats->
  get_ethtool_stats(ops)->
    mv88e6xxx_get_ethtool_stats->
      get_rmon(ops)->  (1)
        mv88e6xxx_rmu_stats_get->
          stats_get_stats(ops)->
            (per chip implementation:mv88e6095/6250/6320/6390_stats_get_stats->
              mv88e6xxx_stats_get_stats(with different parameters)

Here we want to decode the raw RMU data according to specific chip.
This function is not an ops and furthermore some RMON data is still
fetched through MDIO, i.e. !(stat->type & STATS_TYPE_PORT).
I'm not sure what you want me to do? The ops I've changed is at (1)

/Mattias

