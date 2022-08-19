Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C65B5994D5
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345075AbiHSFr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiHSFrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:47:52 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BFDE1929
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 22:47:51 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z25so4838820lfr.2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 22:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=umWeQ1SEpltCqESBlbFcclcjk/nqDIdLqqXsd+n5kpQ=;
        b=S/sPSZWcSx8nhq5Z6hQdcWEiTkLHKarFdZdEyWN2RNOT1/HGl4pAI7NYaDd8QHjLc9
         H9kmM8WJm6rI0TP/Jy3o7N62DN3d5DfcFV61WT56kBHDrx3ZWV3Gql9gcepIInlzPADu
         6RdKNbjv4Bc1qXNyQjvEtsPNEF6xzTuPUbqwPUJXuCC1o5BZJfwAXf5SAHkyYsZ8SpjG
         TjV9BwNGjlwEOFoiB69D4YJ1QyRkaegwPA7rmntv/3SF7Oe8gxoyaYWfrBhHns+EMIuT
         MfDdoXSUKyr+YSvCJQiilaQjvhmA0XAXlGT2QVVWNR7QP8GzJflwsYHNhIn9pq/ulyZ8
         dvxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=umWeQ1SEpltCqESBlbFcclcjk/nqDIdLqqXsd+n5kpQ=;
        b=jy591GMfRdCPSQLiyPeaiigVFx0lq2kgghAOyBnAzN0QFaDFN17uy9LCOhjDj23vYm
         dMqQMrl+rBucmqO1rWY36gp+JijLvDsLB2SyWUkhwI7RaMWBPjmkLl22Pc8qKwUKaiDn
         k3pdAhCv1TuJXe+4dQ3ln4VeG1I8UFPjLupm15SzMov2NvFnkt40wtHnomesxzwpdA5t
         Sg4G7YUTCGeT/W/XyIsmGadgymtRP4Hi2Jm2MpDzuHlxARhS7OfPO/t5qhuK0vhYXhTu
         SvWTpCQzOHe8PBRT/YGZfH1BgOhxXvIDHBTlin9g08HDmmMSmBVIiT5M5FXx0n9tueS9
         Flrw==
X-Gm-Message-State: ACgBeo1HyCDGUuyxcYgIYZ9iaPBKCCvSU9OMc4sPpiQZgo7lH91ZnkbK
        /svugoMsLNfj+Zdk7CdqV0c=
X-Google-Smtp-Source: AA6agR7K4Y4s6X4bMTHw1DqR/FkybCjaJVLnsA1W1IK0E6h+pp3Vdg5vo6KCYpCxBQBL0MdH3AURHQ==
X-Received: by 2002:a05:6512:3d8f:b0:48f:a80b:1872 with SMTP id k15-20020a0565123d8f00b0048fa80b1872mr1875690lfv.21.1660888070072;
        Thu, 18 Aug 2022 22:47:50 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id v9-20020ac25609000000b00492aeaf25a2sm500340lfd.136.2022.08.18.22.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 22:47:49 -0700 (PDT)
Message-ID: <00b2d570-a9a9-244c-51ca-7363b9a74aec@gmail.com>
Date:   Fri, 19 Aug 2022 07:47:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net-next PATCH 3/3] mv88e6xxx: rmon: Use RMU to collect rmon
 data.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
 <20220818102924.287719-4-mattias.forsblad@gmail.com>
 <Yv5cbL7xUFRo02Bu@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <Yv5cbL7xUFRo02Bu@lunn.ch>
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

On 2022-08-18 17:36, Andrew Lunn wrote:
>> @@ -1310,16 +1323,22 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
>>  	struct mv88e6xxx_chip *chip = ds->priv;
>>  	int ret;
>>  
>> -	mv88e6xxx_reg_lock(chip);
>> +	if (chip->rmu.ops && chip->rmu.ops->get_rmon) {
>> +		ret = chip->rmu.ops->get_rmon(chip, port, data);
>> +		if (ret == -ETIMEDOUT)
>> +			return;
>> +	} else {
>>  
>> -	ret = mv88e6xxx_stats_snapshot(chip, port);
>> -	mv88e6xxx_reg_unlock(chip);
>> +		mv88e6xxx_reg_lock(chip);
>>  
>> -	if (ret < 0)
>> -		return;
>> +		ret = mv88e6xxx_stats_snapshot(chip, port);
>> +		mv88e6xxx_reg_unlock(chip);
>>  
>> -	mv88e6xxx_get_stats(chip, port, data);
>> +		if (ret < 0)
>> +			return;
>>  
>> +		mv88e6xxx_get_stats(chip, port, data);
>> +	}
>>  }
> 
> I don't particularly like the way this is all mixed together.
> 
> Could you try to split it, so there is an MDIO set of functions and an
> RMU set of functions. Maybe you have some helpers which are used by
> both.
> 

I think that a great idea. Will split in separate functions.

> I would also suggest you try to think about ATU dump and VTU dump. You
> ideally want a code structure which is very similar for all these dump
> operations. Take a look at how qca8k-8xxx.c does things.
> 

I think that the ATU dump is the logical next step to implement. I'll
have a look in qca8k to see how they do things.

AFAIK there is no RMU operation for VTU dump. That needs to be done 
with register reads and writes.

> Is it documented in the datasheet that when RMU is used a snapshot is
> not required?
> 
>     Andrew

In the documentation they only mention captured counters with regards 
to MDIO accesses. I cannot see that that is necessary with RMU.
FYI on our board the time delta between request and reply 
is ~100us (which is nice)
