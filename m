Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2A65BDD7E
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 08:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiITGlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 02:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiITGlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 02:41:35 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6756BC28
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 23:41:34 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id j16so2196145lfg.1
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 23:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=I6f9Xu3oOm5TQPGLHRpxuXeF0ks4IclqsW8C47l8Xio=;
        b=QjLLgww6CE7ZipTONAP2xFqbAogSsR2DSlOCQ31cOBoxjPywHXMA7TpCiieIaqLPF+
         Tm2h8WnMMKyClLaas8GUJu6DlDGQXzDbjXPKduLDavCMOzoHy0lgEPVDdpAZnpSWx81A
         4DlmszrABSPKKLZUmslEOPX2LhzCRgATQhrSUaFwHxFQG3ADw/UwgoGHV4R0yHVpfuzf
         pw79RTA0AjQI/TMbcpV8jOgXyJwZTrMLBV43yQ/zEG9qxjZPbma5+kUSnFOcOuDJpFl9
         XJtYPJXzE+1lN0dTT10Pd/cR+ZKrhF2EMMWLrU+1nf5pS/l861zhr+L3FXQrsqg9Xqk7
         HQIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=I6f9Xu3oOm5TQPGLHRpxuXeF0ks4IclqsW8C47l8Xio=;
        b=QgAqQ/bnhhEs2Gk5Smc1x9EgdLDGHc4iZ60GvCeFKHlnlomaZtRJ6zvijj5+K1/eIV
         +lxvFX+LMGir9VlQHLLAONt7aPVJCkRzkuLVrUjn147Us1rVyWDX/FVvWVrCnmo85ZLR
         H71aVv2mFF+1hq8lI550eF12UWMnGhY0FL/IKDcSjfTOYGHLH579tpSaJqHmSqHMw0Ri
         lxdvU6mWMI0QU7W5+3tCSmKi4cYxJOmC/UUhzBeDviXnyW1VY5PevdVlqic150CcewYl
         BNijrx2NRG3FBQ/+SNLklEG5ChIGGQXMr8LkHSRXhFGftDZCIDsan90vRcHOuCFxRjxY
         O6aA==
X-Gm-Message-State: ACrzQf3n/q+ir6+5DdhBaqUvBOg+levCsPqlMt1LZnBG/D7mR9wmWpec
        qO1CAx37jkzVLerio3KmnZYWTFuinkPYeQ==
X-Google-Smtp-Source: AMsMyM6kHe3KuIzh56/0FHg+bJC9lo6AjenxHp/LgUYS9DH0nUssOYtvBFaIqM8Dl4s81jUYFTBvyA==
X-Received: by 2002:a05:6512:b81:b0:494:78cc:ca9c with SMTP id b1-20020a0565120b8100b0049478ccca9cmr7240841lfv.564.1663656092510;
        Mon, 19 Sep 2022 23:41:32 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id m2-20020ac24242000000b00499f700430fsm149999lfl.224.2022.09.19.23.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 23:41:32 -0700 (PDT)
Message-ID: <3f29e40e-1a3b-8580-3fbd-6fba8fc02f1f@gmail.com>
Date:   Tue, 20 Sep 2022 08:41:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v14 3/7] net: dsa: Introduce dsa tagger data
 operation.
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-4-mattias.forsblad@gmail.com>
 <20220919110847.744712-4-mattias.forsblad@gmail.com>
 <20220919220056.dactchsdzhcb5sev@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220919220056.dactchsdzhcb5sev@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-20 00:00, Vladimir Oltean wrote:
>> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
>> index e4b6e3f2a3db..e7fdf3b5cb4a 100644
>> --- a/net/dsa/tag_dsa.c
>> +++ b/net/dsa/tag_dsa.c
>> @@ -198,8 +198,11 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>>  static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>>  				  u8 extra)
>>  {
>> +	struct dsa_port *cpu_dp = dev->dsa_ptr;
>> +	struct dsa_tagger_data *tagger_data;
>>  	bool trap = false, trunk = false;
>>  	int source_device, source_port;
>> +	struct dsa_switch *ds;
>>  	enum dsa_code code;
>>  	enum dsa_cmd cmd;
>>  	u8 *dsa_header;
>> @@ -218,9 +221,16 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>>  
>>  		switch (code) {
>>  		case DSA_CODE_FRAME2REG:
>> -			/* Remote management is not implemented yet,
>> -			 * drop.
>> -			 */
>> +			source_device = FIELD_GET(DSA_FRAME2REG_SOURCE_DEV, dsa_header[0]);
>> +			ds = dsa_switch_find(cpu_dp->dst->index, source_device);
>> +			if (ds) {
>> +				tagger_data = ds->tagger_data;
> 
> Can you please also parse the sequence number here, so the
> decode_frame2reg() data consumer doesn't have to concern itself with the
> dsa_header at all?
> 

The sequence number is in the chip structure which isn't available here.
Should we really access that here in the dsa layer?

/Mattias

>> +				if (likely(tagger_data->decode_frame2reg))
>> +					tagger_data->decode_frame2reg(ds, skb);
>> +			} else {
>> +				net_err_ratelimited("RMU: Didn't find switch with index %d",
>> +						    source_device);
>> +			}
>>  			return NULL;
>>  		case DSA_CODE_ARP_MIRROR:
>>  		case DSA_CODE_POLICY_MIRROR:
>> @@ -254,7 +264,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>>  	source_port = (dsa_header[1] >> 3) & 0x1f;
>>  
>>  	if (trunk) {
>> -		struct dsa_port *cpu_dp = dev->dsa_ptr;
>>  		struct dsa_lag *lag;
>>  
>>  		/* The exact source port is not available in the tag,
>> @@ -323,6 +332,25 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>>  	return skb;
>>  }
>>  
>> +static int dsa_tag_connect(struct dsa_switch *ds)
>> +{
>> +	struct dsa_tagger_data *tagger_data;
>> +
>> +	tagger_data = kzalloc(sizeof(*tagger_data), GFP_KERNEL);
>> +	if (!tagger_data)
>> +		return -ENOMEM;
>> +
>> +	ds->tagger_data = tagger_data;
>> +
>> +	return 0;
>> +}
>> +
>> +static void dsa_tag_disconnect(struct dsa_switch *ds)
>> +{
>> +	kfree(ds->tagger_data);
>> +	ds->tagger_data = NULL;
>> +}
>> +
>>  #if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA)
>>  
>>  static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
>> @@ -343,6 +371,8 @@ static const struct dsa_device_ops dsa_netdev_ops = {
>>  	.proto	  = DSA_TAG_PROTO_DSA,
>>  	.xmit	  = dsa_xmit,
>>  	.rcv	  = dsa_rcv,
>> +	.connect  = dsa_tag_connect,
>> +	.disconnect = dsa_tag_disconnect,
>>  	.needed_headroom = DSA_HLEN,
>>  };
>>  
>> @@ -385,6 +415,8 @@ static const struct dsa_device_ops edsa_netdev_ops = {
>>  	.proto	  = DSA_TAG_PROTO_EDSA,
>>  	.xmit	  = edsa_xmit,
>>  	.rcv	  = edsa_rcv,
>> +	.connect  = dsa_tag_connect,
>> +	.disconnect = dsa_tag_disconnect,
>>  	.needed_headroom = EDSA_HLEN,
>>  };
>>  
>> -- 
>> 2.25.1
>>
> 

