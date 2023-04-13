Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85296E1543
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDMTgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDMTgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:36:38 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A30B212F
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:36:37 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e16so2022153wra.6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681414595; x=1684006595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CwBUYlPXveGckiMzYAg4jZq9lyOd7xo+VfqnMgQQmwI=;
        b=DcEviKE0qiLx3qtDvMBBtfzUh0aMHISBmEV9fN+fAZHyaFXYH7we4jQVT/WG1ZuA2J
         TLFipMktv9Tz7ebLuNQEW7I5sEautMvBSHri410jaxqzDCrbNIG9imDWHjWcz8M+m4gM
         9PXlt/1hWDtQRMS+dRZEY8UfvGwpzHEQphmsLBRU0etmQuC921Uw7CYPV9AEmYubkPeD
         KoMypBUrvCF+USMVv4i45eumjsQomZo7DyhJYuuoDNmdfEKk3lm0n+YOeOX8jyGqdeh1
         eMKR0eav3TrePskdKkO4lT4DBkcg9S49MlzUMzlOku4/JSSqon4egzHdCRCqOsoQfj8c
         60qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681414595; x=1684006595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwBUYlPXveGckiMzYAg4jZq9lyOd7xo+VfqnMgQQmwI=;
        b=YFh+1nORVYtH7UJhHIBIzPlnmv/Wx/el2iOeHhIx45AsoqesSaN+fzjypa6oya13qv
         ZMmxCDX2dwMpX17FdiS0GwcXKpKKaDgfjXUL03KyVMQ4chDbcJl640O39TIR4AdWfxD1
         DpXco973vC8jSDXHTZXgXK/xa0z+gV1DlYQtbz7f69d5/2Q0pC8/vVeYliGi4DBb86V1
         0Bs2L745Egq9V/Dz7frR2wPyjHDVHxLmqCXvx5sLehVStrsHdFbrx2gaWGnVb3PZDOKg
         Eiz2UEm4uHljz/LUnDUm6oEYZDwD70TSeDze4C8sZ7NxdxYHkwvdXK6bxK6QQlR/ujIx
         Gs+A==
X-Gm-Message-State: AAQBX9ffbsBq3hoW3RvVSEO95V/zcW7tm95wDnphB66eVxDr+mdJnRSN
        7+c8+B+XmRIuZ1EWq4WjRpb2bOovIVA=
X-Google-Smtp-Source: AKy350aVt2WwNHm4yW5p3hXA+swlGM5e8Dn/pg/U1lmyl45tj+HnJdbRPlrvftUuzqMnEGsqn//Htg==
X-Received: by 2002:a05:6000:1a42:b0:2f6:208d:2239 with SMTP id t2-20020a0560001a4200b002f6208d2239mr2258763wry.11.1681414595674;
        Thu, 13 Apr 2023 12:36:35 -0700 (PDT)
Received: from ?IPV6:2a01:c22:738e:4400:f580:be04:1a64:fc5e? (dynamic-2a01-0c22-738e-4400-f580-be04-1a64-fc5e.c22.pool.telefonica.de. [2a01:c22:738e:4400:f580:be04:1a64:fc5e])
        by smtp.googlemail.com with ESMTPSA id k7-20020a5d6287000000b002e463bd49e3sm1894704wru.66.2023.04.13.12.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 12:36:35 -0700 (PDT)
Message-ID: <c817e882-9683-8b6f-c2a2-c78396ff0011@gmail.com>
Date:   Thu, 13 Apr 2023 21:36:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 3/3] r8169: use new macro
 netif_subqueue_completed_wake in the tx cleanup path
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
 <3ef7166d-ce47-e24c-1df4-bb76a39c96c3@gmail.com>
 <ac076400-e086-15be-47db-59556413094f@intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <ac076400-e086-15be-47db-59556413094f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.04.2023 21:25, Jacob Keller wrote:
> 
> 
> On 4/13/2023 12:16 PM, Heiner Kallweit wrote:
>> Use new net core macro netif_subqueue_completed_wake to simplify
>> the code of the tx cleanup path.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 16 ++++------------
>>  1 file changed, 4 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 3f0b78fd9..5cfdb60ab 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -4372,20 +4372,12 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>>  	}
>>  
>>  	if (tp->dirty_tx != dirty_tx) {
>> -		netdev_completed_queue(dev, pkts_compl, bytes_compl);
>>  		dev_sw_netstats_tx_add(dev, pkts_compl, bytes_compl);
>> +		WRITE_ONCE(tp->dirty_tx, dirty_tx);
>>  
>> -		/* Sync with rtl8169_start_xmit:
>> -		 * - publish dirty_tx ring index (write barrier)
>> -		 * - refresh cur_tx ring index and queue status (read barrier)
>> -		 * May the current thread miss the stopped queue condition,
>> -		 * a racing xmit thread can only have a right view of the
>> -		 * ring status.
>> -		 */
>> -		smp_store_mb(tp->dirty_tx, dirty_tx);
> 
> 
> We used to use a smp_store_mb here, but now its safe to just WRITE_ONCE?
> Assuming that's correct:
> 
netdev_completed_queue() has a smp_mb() and is called from
netif_subqueue_completed_wake(). So it's supposed to be safe.

> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> 
>> -		if (netif_queue_stopped(dev) &&
>> -		    rtl_tx_slots_avail(tp) >= R8169_TX_START_THRS)
>> -			netif_wake_queue(dev);
>> +		netif_subqueue_completed_wake(dev, 0, pkts_compl, bytes_compl,
>> +					      rtl_tx_slots_avail(tp),
>> +					      R8169_TX_START_THRS);
>>  		/*
>>  		 * 8168 hack: TxPoll requests are lost when the Tx packets are
>>  		 * too close. Let's kick an extra TxPoll request when a burst

