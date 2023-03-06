Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E9E6ADB8E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCGKPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjCGKPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:15:51 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F6851CB0
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 02:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678184151; x=1709720151;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=fBqJhzy29aiktCj4u3ibcJuoGgvjuWr0caDAKdaFnkc=;
  b=V6msDisN7us/1pZ16IbhcWLTNURiVwr4uxbf3X8vPwgUrl+sQqb+byNn
   t9v8PH9mPajYRLMInME+HafveAHRGLMwS9qIU3yw0WD85I3GWidgoclDD
   1EHmykAD/miPZVwsnhPoj5L0KBuXFi0hO+ByThP8IzqJQNxbfYSZeN3k5
   Q=;
X-IronPort-AV: E=Sophos;i="5.98,240,1673913600"; 
   d="scan'208";a="300303462"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 10:15:47 +0000
Received: from EX19D004EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id 1790B414F7;
        Tue,  7 Mar 2023 10:15:46 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D004EUA002.ant.amazon.com (10.252.50.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 7 Mar 2023 10:15:45 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 7 Mar 2023 10:15:37 +0000
References: <20230302203045.4101652-1-shayagr@amazon.com>
 <20230302203045.4101652-5-shayagr@amazon.com>
 <20230303155039.5f6c99af@kernel.org>
User-agent: mu4e 1.8.13; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v2 net-next 4/4] net: ena: Add support to changing
 tx_push_buf_len
Date:   Mon, 6 Mar 2023 13:54:40 +0200
In-Reply-To: <20230303155039.5f6c99af@kernel.org>
Message-ID: <pj41zllek827gc.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D037UWC002.ant.amazon.com (10.13.139.250) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 2 Mar 2023 22:30:45 +0200 Shay Agroskin wrote:
>> @@ -496,11 +509,40 @@ static int ena_set_ringparam(struct 
>> net_device *netdev,
>>  			ENA_MIN_RING_SIZE : ring->rx_pending;
>>  	new_rx_size = rounddown_pow_of_two(new_rx_size);
>>  
>> -	if (new_tx_size == adapter->requested_tx_ring_size &&
>> -	    new_rx_size == adapter->requested_rx_ring_size)
>> +	changed |= new_tx_size != adapter->requested_tx_ring_size 
>> ||
>> +		   new_rx_size != adapter->requested_rx_ring_size;
>> +
>> +	/* This value is ignored if LLQ is not supported */
>> +	new_tx_push_buf_len = 0;
>> +	if (adapter->ena_dev->tx_mem_queue_type == 
>> ENA_ADMIN_PLACEMENT_POLICY_HOST)
>> +		goto no_llq_supported;
>
> Are you rejecting the unsupported config in this case or just 
> ignoring
> it? You need to return an error if user tries to set something 
> the
> device does not support/allow.
>

I'll explicitly set 0s to push buffer in 'get' when LLQ isn't 
supported and return -ENOSUPP if the user
tries to set it when no LLQ is used.

> BTW your use of gotos to skip code is against the kernel coding 
> style.
> gotos are only for complex cases and error handling, you're 
> using them
> to save indentation it seems. Factor the code out to a helper 
> instead,
> or some such.
>

Modified the code to remove the gotos (although I thought they 
were an elegant implementation)

>> +	new_tx_push_buf_len = kernel_ring->tx_push_buf_len;
>> +
>> +	/* support for ENA_LLQ_LARGE_HEADER is tested in the 'get' 
>> command */
>> +	if (new_tx_push_buf_len != ENA_LLQ_HEADER &&
>> +	    new_tx_push_buf_len != ENA_LLQ_LARGE_HEADER) {
>> +		bool large_llq_sup = 
>> adapter->large_llq_header_supported;
>> +		char large_llq_size_str[40];
>> +
>> +		snprintf(large_llq_size_str, 40, ", %lu", 
>> ENA_LLQ_LARGE_HEADER);
>> +
>> +		NL_SET_ERR_MSG_FMT_MOD(extack,
>> +				       "Only [%lu%s] tx push buff 
>> length values are supported",
>> +				       ENA_LLQ_HEADER,
>> +				       large_llq_sup ? 
>> large_llq_size_str : "");
>> +
>> +		return -EINVAL;
>> +	}
>> +
>> +	changed |= new_tx_push_buf_len != 
>> adapter->ena_dev->tx_max_header_size;
>> +
>> +no_llq_supported:
>> +	if (!changed)
>>  		return 0;
>>  
>> -	return ena_update_queue_sizes(adapter, new_tx_size, 
>> new_rx_size);
>> +	return ena_update_queue_params(adapter, new_tx_size, 
>> new_rx_size,
>> +				       new_tx_push_buf_len);

