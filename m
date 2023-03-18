Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3906BFAE2
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 15:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCROcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 10:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCROcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 10:32:00 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DB75B88;
        Sat, 18 Mar 2023 07:31:50 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h19so8615393qtn.1;
        Sat, 18 Mar 2023 07:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679149910;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=omCnbS+/el6Gly59ONAmBPzqOmEUBWn8/iuc5jWJ1YQ=;
        b=L2R/pBH1xsowFR2hmOG6tXoKiu793PrNxctl4YrquecUGvxll7o/4jX7faMLqVDj8V
         RO2gZ6LVmfFgC2WTzX3EiMULshBzX1RoQsMbMfZz5ViDwZitplHGul8M7RmeU40FTz8y
         rv1VzTM5ezwA05recgzoOYDhzA2I2foAISTgAmFLSPPqIYhem1XJi8VBMKcuDeevZPxR
         HjpGuAh9in4fX15aIiJNwLMd6lcGa1Nv/ZEk2p8NvTtle68Ic3ZmK+q1JJl/g+G1gZ4x
         KEdkIktgBz8U0F82mB2yLcBLKifnrXL0mc+mI4GORA5xQwfd/LyHTetRsoY1nKE3or4J
         gGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679149910;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omCnbS+/el6Gly59ONAmBPzqOmEUBWn8/iuc5jWJ1YQ=;
        b=5FiSmaUMHO/S04DmAA+0uXTTqROhglI6zvMi88ORIZ7yETnb7DnFDSN80Zv1HSYwr7
         IR9kbCgmtCBlke4vu69rf3Kk0xQWstc/YaHgHfclqIxZ10vYJnLeRb5lJ0EtvO0k9cW4
         fusxxUYPyMOeOO5lgu+9ljLPZ//7JbrNUqepsU0nH4cOX3Os6FafMz+KJLLoMhWxdsAd
         WZcrfdE/EyyiTQWm4E1h26xlJg0t8Wfp2vZxwDjbbFGrEInCVKJ5YzBfO72HCCimltK1
         9M2dHQdxGvEZYVjaIpja6Kmd/2+DW9nrvAglZkge5rcUkpv/FV9kHsmD/+OJUEu8giQo
         UARg==
X-Gm-Message-State: AO0yUKXBmJBlfV0rGZ1vTJ+h07w4NE52ngDyUz7evXPp8C7E5gNuDtrk
        7Am77NaUS9IUZGDWqDYhr2U=
X-Google-Smtp-Source: AK7set8G64Xq6FLgbzcP7GqrJFvNKbAeHHtLFIhn/5F9U5byCRAWghjBQ9ZW9xZegZXzRmnCe7TGIA==
X-Received: by 2002:a05:622a:170c:b0:3b9:bc8c:c212 with SMTP id h12-20020a05622a170c00b003b9bc8cc212mr10993812qtk.29.1679149909883;
        Sat, 18 Mar 2023 07:31:49 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id i62-20020a37b841000000b00742a252ba06sm3635115qkf.135.2023.03.18.07.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 07:31:49 -0700 (PDT)
Message-ID: <ef07016f-fe3b-99d5-1f93-fc8e34baf18c@gmail.com>
Date:   Sat, 18 Mar 2023 10:31:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 1/9] net: sunhme: Just restart autonegotiation
 if we can't bring the link up
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-2-seanga2@gmail.com> <ZBV4LSBOwEzSiAvA@corigine.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <ZBV4LSBOwEzSiAvA@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/23 04:37, Simon Horman wrote:
> On Mon, Mar 13, 2023 at 08:36:05PM -0400, Sean Anderson wrote:
>> If we've tried regular autonegotiation and forcing the link mode, just
>> restart autonegotiation instead of reinitializing the whole NIC.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> 
> ...
> 
>> @@ -606,6 +604,124 @@ static int is_lucent_phy(struct happy_meal *hp)
>>   	return ret;
>>   }
>>   
>> +/* hp->happy_lock must be held */
>> +static void
>> +happy_meal_begin_auto_negotiation(struct happy_meal *hp,
>> +				  void __iomem *tregs,
>> +				  const struct ethtool_link_ksettings *ep)
>> +{
>> +	int timeout;
>> +
>> +	/* Read all of the registers we are interested in now. */
>> +	hp->sw_bmsr      = happy_meal_tcvr_read(hp, tregs, MII_BMSR);
>> +	hp->sw_bmcr      = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
>> +	hp->sw_physid1   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID1);
>> +	hp->sw_physid2   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID2);
>> +
>> +	/* XXX Check BMSR_ANEGCAPABLE, should not be necessary though. */
>> +
>> +	hp->sw_advertise = happy_meal_tcvr_read(hp, tregs, MII_ADVERTISE);
>> +	if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
>> +		/* Advertise everything we can support. */
>> +		if (hp->sw_bmsr & BMSR_10HALF)
>> +			hp->sw_advertise |= (ADVERTISE_10HALF);
>> +		else
>> +			hp->sw_advertise &= ~(ADVERTISE_10HALF);
>> +
>> +		if (hp->sw_bmsr & BMSR_10FULL)
>> +			hp->sw_advertise |= (ADVERTISE_10FULL);
>> +		else
>> +			hp->sw_advertise &= ~(ADVERTISE_10FULL);
>> +		if (hp->sw_bmsr & BMSR_100HALF)
>> +			hp->sw_advertise |= (ADVERTISE_100HALF);
>> +		else
>> +			hp->sw_advertise &= ~(ADVERTISE_100HALF);
>> +		if (hp->sw_bmsr & BMSR_100FULL)
>> +			hp->sw_advertise |= (ADVERTISE_100FULL);
>> +		else
>> +			hp->sw_advertise &= ~(ADVERTISE_100FULL);
>> +		happy_meal_tcvr_write(hp, tregs, MII_ADVERTISE, hp->sw_advertise);
>> +
>> +		/* XXX Currently no Happy Meal cards I know off support 100BaseT4,
>> +		 * XXX and this is because the DP83840 does not support it, changes
>> +		 * XXX would need to be made to the tx/rx logic in the driver as well
>> +		 * XXX so I completely skip checking for it in the BMSR for now.
>> +		 */
>> +
>> +		ASD("Advertising [ %s%s%s%s]\n",
>> +		    hp->sw_advertise & ADVERTISE_10HALF ? "10H " : "",
>> +		    hp->sw_advertise & ADVERTISE_10FULL ? "10F " : "",
>> +		    hp->sw_advertise & ADVERTISE_100HALF ? "100H " : "",
>> +		    hp->sw_advertise & ADVERTISE_100FULL ? "100F " : "");
>> +
>> +		/* Enable Auto-Negotiation, this is usually on already... */
>> +		hp->sw_bmcr |= BMCR_ANENABLE;
>> +		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
>> +
>> +		/* Restart it to make sure it is going. */
>> +		hp->sw_bmcr |= BMCR_ANRESTART;
>> +		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
>> +
>> +		/* BMCR_ANRESTART self clears when the process has begun. */
>> +
>> +		timeout = 64;  /* More than enough. */
>> +		while (--timeout) {
>> +			hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
>> +			if (!(hp->sw_bmcr & BMCR_ANRESTART))
>> +				break; /* got it. */
>> +			udelay(10);
> 
> nit: Checkpatch tells me that usleep_range() is preferred over udelay().
>       Perhaps it would be worth looking into that for a follow-up patch.

This will be fixed in another series.

>> +		}
>> +		if (!timeout) {
>> +			netdev_err(hp->dev,
>> +				   "Happy Meal would not start auto negotiation BMCR=0x%04x\n",
>> +				   hp->sw_bmcr);
>> +			netdev_notice(hp->dev,
>> +				      "Performing force link detection.\n");
>> +			goto force_link;
>> +		} else {
>> +			hp->timer_state = arbwait;
>> +		}
>> +	} else {
>> +force_link:
>> +		/* Force the link up, trying first a particular mode.
>> +		 * Either we are here at the request of ethtool or
>> +		 * because the Happy Meal would not start to autoneg.
>> +		 */
>> +
>> +		/* Disable auto-negotiation in BMCR, enable the duplex and
>> +		 * speed setting, init the timer state machine, and fire it off.
>> +		 */
>> +		if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
>> +			hp->sw_bmcr = BMCR_SPEED100;
>> +		} else {
>> +			if (ep->base.speed == SPEED_100)
>> +				hp->sw_bmcr = BMCR_SPEED100;
>> +			else
>> +				hp->sw_bmcr = 0;
>> +			if (ep->base.duplex == DUPLEX_FULL)
>> +				hp->sw_bmcr |= BMCR_FULLDPLX;
>> +		}
>> +		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
>> +
>> +		if (!is_lucent_phy(hp)) {
>> +			/* OK, seems we need do disable the transceiver for the first
>> +			 * tick to make sure we get an accurate link state at the
>> +			 * second tick.
>> +			 */
>> +			hp->sw_csconfig = happy_meal_tcvr_read(hp, tregs,
>> +							       DP83840_CSCONFIG);
>> +			hp->sw_csconfig &= ~(CSCONFIG_TCVDISAB);
>> +			happy_meal_tcvr_write(hp, tregs, DP83840_CSCONFIG,
>> +					      hp->sw_csconfig);
>> +		}
>> +		hp->timer_state = ltrywait;
>> +	}
>> +
>> +	hp->timer_ticks = 0;
>> +	hp->happy_timer.expires = jiffies + (12 * HZ)/10;  /* 1.2 sec. */
> 
> nit: as a follow-up perhaps you could consider something like this.
>       (* completely untested! * )
> 
> 	hp->happy_timer.expires = jiffies + msecs_to_jiffies(1200);

ditto.

>> +	add_timer(&hp->happy_timer);
>> +}
>> +
> 
> ...

--Sean
