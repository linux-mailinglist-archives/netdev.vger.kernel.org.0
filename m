Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7FE5A75FC
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 07:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiHaFv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 01:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiHaFvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 01:51:12 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDA4BB685
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 22:51:06 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id v26so8223886lfd.10
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 22:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=YNzh62ZBAGcav3YWtqHv7cr7GoUpJCoDSI7mFQm4U14=;
        b=A8+0UmmGnB3r98q4Oiu4U7B+hoMWTu33zyN5FoVSER4eijMp1xw8hxU5gqDd396RA3
         O5OFiIvxK8uR/yAfK7UBbGFVLRAIi2ux15ENJNzjhX3DkwLadXCY6lpkNfSqhDQW8044
         vX9V9htav3ghn4mCrZXwoFMPwP3wpQyxAfTNjsw68IniIoZCXbVGLR/SMfcL3+fSFX0O
         bhCycKypNFUv/kVv6cyOtrsxEPhOJzHqe2sD1nL9sEaZhZAeXoGxzN/XfY2LSi605OvI
         BXv/EPzI/UpsUUv5BGZZAlxGa5X3FVdqjLMNMdBhFj6jLvE8Yw4uZhryBYoUhZscpsjH
         0v3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=YNzh62ZBAGcav3YWtqHv7cr7GoUpJCoDSI7mFQm4U14=;
        b=iozlvZ+di4xA7MnpigDAXoGwCQP1ROzaSsmKqWzEetVojzBm1pWHcOvkRt1AOqOdL+
         oJ8540BRJmzx+tVu4P22qnAI4990mnBqpEquismXIN494fHCHmooDF/np1cJdsEy01tu
         kTxTdvr9xUsnSJCPZw203+xSoX7H0RYfYWMvseZHAvJ4mlrQRjHYBCwYHsWyMTe+dOe9
         U8U7rNSUd/u2R2NQaTXUKIv69psxwL1AZFQsLC3Lg+10Mxmm9kNffEIGEl2bUJKF7NwE
         AAxEubkiiesuH0wgXvqX7rr6sE+Yi4AOLCDiCIq0OPDypMnOOJGjnxXbFH2YlsiXbHZg
         im1A==
X-Gm-Message-State: ACgBeo0K/104pcftLRJhfQ6PCVvtgHQZX0wvhdRcrrGeM1/cXsrJBy1k
        mDYluPjnTz2dGRwDrR082Ls=
X-Google-Smtp-Source: AA6agR418vPPSoTRl/pOYCNbU/sm1vurm0i0L46zNZkEowFr9vvpDmIY6RHkypMDNkSMvQu3EyCYCw==
X-Received: by 2002:a05:6512:3f9b:b0:492:d6c7:24e8 with SMTP id x27-20020a0565123f9b00b00492d6c724e8mr8208718lfa.346.1661925064141;
        Tue, 30 Aug 2022 22:51:04 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id v25-20020ac258f9000000b004918fff6a93sm374330lfo.296.2022.08.30.22.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 22:51:03 -0700 (PDT)
Message-ID: <c735b39c-7685-fc4c-ab0f-527f7d8262fb@gmail.com>
Date:   Wed, 31 Aug 2022 07:51:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 3/3] rmon: Use RMU if available
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-4-mattias.forsblad@gmail.com>
 <20220830142014.pytgaiacq2iq2rka@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220830142014.pytgaiacq2iq2rka@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-30 16:20, Vladimir Oltean wrote:
> Hi Forsblad,
> 
> On Fri, Aug 26, 2022 at 08:38:16AM +0200, Mattias Forsblad wrote:
>> If RMU is supported, use that interface to
>> collect rmon data.
> 
> A more adequate commit message would be:
> 
> net: dsa: mv88e6xxx: use RMU to collect RMON stats if available
> 
> But then, I don't think the splitting of patches is good. I think
> mv88e6xxx_inband_rcv(), the producer of rmu_raw_stats[], should be
> introduced along with its consumer. Otherwise I have to jump between one
> patch and another to be able to comment and see things.
> 

I'll have that in mind for the next round. The next version will
look way different after Andrews suggestion.

> Also, it would be good if you could consider actually reporting the RMON
> stats through the standardized interface (ds->ops->get_rmon_stats) and
> ethtool -S lan0 --groups rmon, rather than just unstructured ethtool -S.
>

Cool, I didn't know it existed. I'll look into that.
 
>>
>> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
>> ---
>>  drivers/net/dsa/mv88e6xxx/chip.c | 41 ++++++++++++++++++++++++++------
>>  1 file changed, 34 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 4c0510abd875..0d0241ace708 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1226,16 +1226,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
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
>> +			if (chip->rmu.ops && chip->rmu.ops->get_rmon &&
>> +			    !(stat->type & STATS_TYPE_PORT)) {
>> +				if (stat->type & STATS_TYPE_BANK1)
>> +					offset = 32;
>> +
>> +				data[j] = chip->ports[port].rmu_raw_stats[stat->reg + offset];
>> +				if (stat->size == 8) {
>> +					high = chip->ports[port].rmu_raw_stats[stat->reg + offset
>> +							+ 1];
>> +					data[j] += (high << 32);
> 
> What exactly protects ethtool -S, a reader of rmu_raw_stats[], from
> reading an array that is concurrently overwritten by mv88e6xxx_inband_rcv?
> 

So for the Marvell SOHO the RMU is purely a request/response protocol. The switchcore
will not send a frame unless requested, thus no barrier is needed. For other switchcores
which may have send frames spontaneous additional care may be needed.

>> +				}
>> +			} else {
>> +				mv88e6xxx_reg_lock(chip);
>> +				data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
>> +								      bank1_select, histogram);
>> +				mv88e6xxx_reg_unlock(chip);
>> +			}
>>  
>>  			j++;
>>  		}
>> @@ -1304,8 +1318,8 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
>>  	mv88e6xxx_reg_unlock(chip);
>>  }
>>  
>> -static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
>> -					uint64_t *data)
>> +static void mv88e6xxx_get_ethtool_stats_mdio(struct dsa_switch *ds, int port,
>> +					     uint64_t *data)
>>  {
>>  	struct mv88e6xxx_chip *chip = ds->priv;
>>  	int ret;
>> @@ -1319,7 +1333,20 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
>>  		return;
>>  
>>  	mv88e6xxx_get_stats(chip, port, data);
>> +}
>>  
>> +static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
>> +					uint64_t *data)
>> +{
>> +	struct mv88e6xxx_chip *chip = ds->priv;
>> +
>> +	/* If initialization of RMU isn't available
>> +	 * fall back to MDIO access.
>> +	 */
>> +	if (chip->rmu.ops && chip->rmu.ops->get_rmon)
> 
> I would create a helper
> 
> static bool mv88e6xxx_rmu_available(struct mv88e6xxx_chip *chip)
> 
> and use it here and everywhere, for clarity. Testing the presence of
> chip->rmu.ops is not wrong, but confusing.
> 
> Also, testing chip->rmu.ops->get_rmon gains exactly nothing, since it is
> never NULL when chip->rmu.ops isn't NULL.
> 

Agreed. The next version will draw inspiration from qca8k.
>> +		chip->rmu.ops->get_rmon(chip, port, data);
>> +	else
>> +		mv88e6xxx_get_ethtool_stats_mdio(ds, port, data);
>>  }
>>  
>>  static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
>> -- 
>> 2.25.1
>>

