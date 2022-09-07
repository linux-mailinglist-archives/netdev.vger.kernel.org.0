Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A325AFC48
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiIGGT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiIGGT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:19:27 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EF620E
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 23:19:22 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x14so5468134lfu.10
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 23:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ymsvTRHXCNvvnsumNgBrxVHtXrTys/FdvaRLzgGKxG0=;
        b=hxVDAKkDdfct6AphEBV3V7b/+48S7lJCP049Nldt2mNvH1j7UDfkAH+q0X7barHgqG
         FhXiw0SvVgBa3L75pBUFgFV4Cv0/yTetm37TxbsA+WTZooaNkREvCnczD8gn8nJQl4nm
         +qDt0fESddL3z6xDBpMUfFXQ4Yr+QyrRm+KaR6jw8L7WqIpWrvZimdyBa1o4ytG7AeJk
         MPVlSctVuFp9H889M4Wk5Sp26xT0uVTgeUvoasocaOZsjKD7DHx9iq7UdxpZURtsRWQg
         SZUGu2BrgVLy/Os+Lx15Ax3mkLYTxlFacBIHGomaORXW/d37qX1la/ErE9mHmG1D0j+d
         UEGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ymsvTRHXCNvvnsumNgBrxVHtXrTys/FdvaRLzgGKxG0=;
        b=Xv/cUblW6QfmjW9qK6iSurJjybGqmQEs6xYlrb0C4gbDcKG3ERWZHabJ6r2eqkAcZe
         CvF6t1LzQCISObb92cqmBcxRifbUW2JuNxJloIr+Qkf6UY0mNlBhOHBgEf2dbfjeOtsu
         bsY6tZmVX0P5bYLqSYoHGpFhgJzSjmEcx/F7O0aHE+I+vS7W1sNMjF+Q2IFSgV1F7yzT
         wzQ158bDU+4OoQc42Pc7boXFcGvG8ufwHxj/YFb5xcTKaRjAX6pylRzkXtCAqw6ZgceI
         5LPNapTI9/6P8KnMdjb4gIl7EBzU30bDf1gGKzpM0WeOg6Pzrjsfgy7m/2Hy7UY+HFKf
         H/LQ==
X-Gm-Message-State: ACgBeo3oZ+uNaW+01ewpdW9RlnE2MfsFj1+HtU+qE3c6eZ7Cc9ai3neH
        IUD7yT9pwbOGQNYbYv0QVZ8=
X-Google-Smtp-Source: AA6agR4UCXdbUp2jKG5PkyKYpQu4upb1FruSWyU9z6xkz2LFiXsyOiMDPdwldZVAMz01nuSWkHYufw==
X-Received: by 2002:a05:6512:1106:b0:494:7374:a05b with SMTP id l6-20020a056512110600b004947374a05bmr616956lfg.432.1662531561166;
        Tue, 06 Sep 2022 23:19:21 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id u24-20020ac258d8000000b0048b0975ac7asm2240168lfo.151.2022.09.06.23.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 23:19:20 -0700 (PDT)
Message-ID: <1ccbbf02-e285-0534-6845-93c0f3f34a80@gmail.com>
Date:   Wed, 7 Sep 2022 08:19:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 2/6] net: dsa: Add convenience functions for
 frame handling
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-3-mattias.forsblad@gmail.com>
 <YxdAhDHy1V22HFw+@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <YxdAhDHy1V22HFw+@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-06 14:43, Andrew Lunn wrote:
> On Tue, Sep 06, 2022 at 08:34:46AM +0200, Mattias Forsblad wrote:
>> Add common control functions for drivers that need
>> to send and wait for control frames.
> 
> It would be nice to explain why a custom complete is needed. Ideally,
> it should not be needed at all.
> 

My first approach was with without a custom complete as I only used
one single complete instance. However, when migrating the qca8k driver
I noticed they use two different complete instances, one in
qca8k_mgmt_eth_data and one in qca8k_mib_eth_data. This leads
to the suggestion that the qca8k implementation could have several
requests in-flight, thus the custom completion parameter.

>> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
>> ---
>>  include/net/dsa.h | 13 +++++++++++++
>>  net/dsa/dsa.c     | 28 ++++++++++++++++++++++++++++
>>  net/dsa/dsa2.c    |  2 ++
>>  3 files changed, 43 insertions(+)
>>
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index f2ce12860546..70a358641235 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -495,6 +495,8 @@ struct dsa_switch {
>>  	unsigned int		max_num_bridges;
>>  
>>  	unsigned int		num_ports;
>> +
>> +	struct completion	inband_done;
>>  };
>>  
>>  static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
>> @@ -1390,6 +1392,17 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
>>  void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
>>  				unsigned int count);
>>  
>> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
>> +			 struct completion *completion, unsigned long timeout);
> 
> Blank line please.
> 

Will fix.

>> +static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
>> +{
>> +	/* Custom completion? */
>> +	if (completion)
>> +		complete(completion);
>> +	else
>> +		complete(&ds->inband_done);
>> +}
>> +
>>  #define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
>>  static int __init dsa_tag_driver_module_init(void)			\
>>  {									\
>> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
>> index be7b320cda76..2d7add779b6f 100644
>> --- a/net/dsa/dsa.c
>> +++ b/net/dsa/dsa.c
>> @@ -324,6 +324,34 @@ int dsa_switch_resume(struct dsa_switch *ds)
>>  EXPORT_SYMBOL_GPL(dsa_switch_resume);
>>  #endif
>>  
>> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
>> +			 struct completion *completion, unsigned long timeout)
>> +{
>> +	int ret;
>> +	struct completion *com;
> 
> Reverse christmas tree. Longest lines first.
> 

Duh, again? Sorry, will fix.

>> +
>> +	/* Custom completion? */
>> +	if (completion)
>> +		com = completion;
>> +	else
>> +		com = &ds->inband_done;
>> +
>> +	reinit_completion(com);
>> +
>> +	if (skb)
>> +		dev_queue_xmit(skb);
>> +
>> +	ret = wait_for_completion_timeout(com, msecs_to_jiffies(timeout));
>> +	if (ret <= 0) {
>> +		dev_dbg(ds->dev, "DSA inband: timeout waiting for answer\n");
>> +
>> +		return -ETIMEDOUT;
>> +	}
> 
> It looks like wait_for_completion_timeout() can return a negative
> error code. You should return that error code, not replace it with
> -ETIMEDOUT. If it returns 0, then it has timed out, and returning
> -ETIMEDOUT does make sense. If the completion is indicated before the
> timeout, the return value is the remaining time. So you can return a
> positive number here. It is worth documenting that, since a common
> patterns is:
> 
> 	err = dsa_switch_inband_tx()
> 	if (err)
> 		return err;
> 
> does not work in this case.
> 
>      Andrew

Will fix.
	
	Mattias

