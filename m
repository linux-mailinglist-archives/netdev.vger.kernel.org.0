Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACDB6ED037
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 16:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjDXOVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 10:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjDXOVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 10:21:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368191FEF
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 07:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682346057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//jrELvgx6BR5HUm/M7sZNnl5oKgho21nLGL8LRITlQ=;
        b=DREqNyNFMMXnrlfxybCQO4bIGerozNhrbeO2wbswFUq2GhaznPTEB3794AB5NUC6GknsCj
        gXgze/MgDK72iKsFKgO/FJBMHImb25YSxDkJDqTxLAR5WqEApHxFrsYeoqMf6YyMVPa7wd
        m+fkt7oBKPb7OJhi7xnoPiX85+BXCM8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-fYHa7EMbNBKuxbuk6st1tA-1; Mon, 24 Apr 2023 10:20:56 -0400
X-MC-Unique: fYHa7EMbNBKuxbuk6st1tA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-50670cfe17eso5184414a12.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 07:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682346053; x=1684938053;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=//jrELvgx6BR5HUm/M7sZNnl5oKgho21nLGL8LRITlQ=;
        b=OO9rDuBvjbFNY278G8YtIQBf4u2kphj57w3uXWVC7XGLgV9TU6JqCt0s9bD42cJ0f6
         KELyZ94t47Io0l9Wgntkp7w5o5Z+YihumZ+IsUy6Ma9slBPBRNri0CF7lJQW0IYLi3Su
         Iwmq+UJa8MRFApXsv0Qr0o3P699eu05Li6Wvcm7rilvoD1ENCxkbqpuYzuRuT53eaMxY
         /Uq++3vqREymvc9DVkhwVrxx7Lspjsj/PMOFn0FzYnCbiaIS7gDx69P4rsGZI3j2VuM8
         JtINNPzQf91F1TAf2VX7EX9zklFAqAbaqkkaAInqaBDWEBqVPfIdSAiQxTU7fBDPhYas
         08Bw==
X-Gm-Message-State: AAQBX9cTP6vSYYKlOOKhIta62nhwd1oMN7l07akrcVAOLPL9nnNvJ83T
        1mtsU+flSUEDXt0hq4eT27pnHPDPI8VP1GSgmK7wPDT6LaJ8a9WaT67ZYfqlbB7F8Pb+7tyxmvV
        Njp1NC8+f0ZOUkgK3
X-Received: by 2002:a50:fa89:0:b0:4fa:b302:84d4 with SMTP id w9-20020a50fa89000000b004fab30284d4mr12483369edr.13.1682346053664;
        Mon, 24 Apr 2023 07:20:53 -0700 (PDT)
X-Google-Smtp-Source: AKy350bc5OYEjhC9pT6b8xkC8b7wpOhe6MoG/ZhEbFBzK8m6qHfqOd6kL4Ojs2bU7cUsC459jN59kg==
X-Received: by 2002:a50:fa89:0:b0:4fa:b302:84d4 with SMTP id w9-20020a50fa89000000b004fab30284d4mr12483342edr.13.1682346053356;
        Mon, 24 Apr 2023 07:20:53 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id o25-20020aa7d3d9000000b00509bd19b869sm3666008edr.48.2023.04.24.07.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 07:20:52 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <622a8fa6-ec07-c150-250b-5467b0cddb0c@redhat.com>
Date:   Mon, 24 Apr 2023 16:20:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        yoong.siang.song@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, hawk@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next V2 1/5] igc: enable and fix RX hash usage by
 netstack
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>, Tony Nguyen <anthony.l.nguyen@intel.com>
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
 <168182464270.616355.11391652654430626584.stgit@firesoul>
 <644544b3206f0_19af02085e@john.notmuch>
In-Reply-To: <644544b3206f0_19af02085e@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/04/2023 16.46, John Fastabend wrote:
> Jesper Dangaard Brouer wrote:
>> When function igc_rx_hash() was introduced in v4.20 via commit 0507ef8a0372
>> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
>> hardware wasn't configured to provide RSS hash, thus it made sense to not
>> enable net_device NETIF_F_RXHASH feature bit.
>>
>> The NIC hardware was configured to enable RSS hash info in v5.2 via commit
>> 2121c2712f82 ("igc: Add multiple receive queues control supporting"), but
>> forgot to set the NETIF_F_RXHASH feature bit.
>>
>> The original implementation of igc_rx_hash() didn't extract the associated
>> pkt_hash_type, but statically set PKT_HASH_TYPE_L3. The largest portions of
>> this patch are about extracting the RSS Type from the hardware and mapping
>> this to enum pkt_hash_types. This was based on Foxville i225 software user
>> manual rev-1.3.1 and tested on Intel Ethernet Controller I225-LM (rev 03).
>>
>> For UDP it's worth noting that RSS (type) hashing have been disabled both for
>> IPv4 and IPv6 (see IGC_MRQC_RSS_FIELD_IPV4_UDP + IGC_MRQC_RSS_FIELD_IPV6_UDP)
>> because hardware RSS doesn't handle fragmented pkts well when enabled (can
>> cause out-of-order). This results in PKT_HASH_TYPE_L3 for UDP packets, and
>> hash value doesn't include UDP port numbers. Not being PKT_HASH_TYPE_L4, have
>> the effect that netstack will do a software based hash calc calling into
>> flow_dissect, but only when code calls skb_get_hash(), which doesn't
>> necessary happen for local delivery.
>>
>> For QA verification testing I wrote a small bpftrace prog:
>>   [0] https://github.com/xdp-project/xdp-project/blob/master/areas/hints/monitor_skb_hash_on_dev.bt
>>
>> Fixes: 2121c2712f82 ("igc: Add multiple receive queues control supporting")
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   drivers/net/ethernet/intel/igc/igc.h      |   28 ++++++++++++++++++++++++++
>>   drivers/net/ethernet/intel/igc/igc_main.c |   31 +++++++++++++++++++++++++----
>>   2 files changed, 55 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
>> index 34aebf00a512..f7f9e217e7b4 100644
>> --- a/drivers/net/ethernet/intel/igc/igc.h
>> +++ b/drivers/net/ethernet/intel/igc/igc.h
>> @@ -13,6 +13,7 @@
>>   #include <linux/ptp_clock_kernel.h>
>>   #include <linux/timecounter.h>
>>   #include <linux/net_tstamp.h>
>> +#include <linux/bitfield.h>
>>   
>>   #include "igc_hw.h"
>>   
>> @@ -311,6 +312,33 @@ extern char igc_driver_name[];
>>   #define IGC_MRQC_RSS_FIELD_IPV4_UDP	0x00400000
>>   #define IGC_MRQC_RSS_FIELD_IPV6_UDP	0x00800000
>>   
>> +/* RX-desc Write-Back format RSS Type's */
>> +enum igc_rss_type_num {
>> +	IGC_RSS_TYPE_NO_HASH		= 0,
>> +	IGC_RSS_TYPE_HASH_TCP_IPV4	= 1,
>> +	IGC_RSS_TYPE_HASH_IPV4		= 2,
>> +	IGC_RSS_TYPE_HASH_TCP_IPV6	= 3,
>> +	IGC_RSS_TYPE_HASH_IPV6_EX	= 4,
>> +	IGC_RSS_TYPE_HASH_IPV6		= 5,
>> +	IGC_RSS_TYPE_HASH_TCP_IPV6_EX	= 6,
>> +	IGC_RSS_TYPE_HASH_UDP_IPV4	= 7,
>> +	IGC_RSS_TYPE_HASH_UDP_IPV6	= 8,
>> +	IGC_RSS_TYPE_HASH_UDP_IPV6_EX	= 9,
>> +	IGC_RSS_TYPE_MAX		= 10,
>> +};
>> +#define IGC_RSS_TYPE_MAX_TABLE		16
>> +#define IGC_RSS_TYPE_MASK		GENMASK(3,0) /* 4-bits (3:0) = mask 0x0F */
>> +
>> +/* igc_rss_type - Rx descriptor RSS type field */
>> +static inline u32 igc_rss_type(const union igc_adv_rx_desc *rx_desc)
>> +{
>> +	/* RSS Type 4-bits (3:0) number: 0-9 (above 9 is reserved)
>> +	 * Accessing the same bits via u16 (wb.lower.lo_dword.hs_rss.pkt_info)
>> +	 * is slightly slower than via u32 (wb.lower.lo_dword.data)
>> +	 */
>> +	return le32_get_bits(rx_desc->wb.lower.lo_dword.data, IGC_RSS_TYPE_MASK);
>> +}
>> +
>>   /* Interrupt defines */
>>   #define IGC_START_ITR			648 /* ~6000 ints/sec */
>>   #define IGC_4K_ITR			980
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
>> index 1c4676882082..bfa9768d447f 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -1690,14 +1690,36 @@ static void igc_rx_checksum(struct igc_ring *ring,
>>   		   le32_to_cpu(rx_desc->wb.upper.status_error));
>>   }
>>   
>> +/* Mapping HW RSS Type to enum pkt_hash_types */
>> +static const enum pkt_hash_types igc_rss_type_table[IGC_RSS_TYPE_MAX_TABLE] = {
>> +	[IGC_RSS_TYPE_NO_HASH]		= PKT_HASH_TYPE_L2,
>> +	[IGC_RSS_TYPE_HASH_TCP_IPV4]	= PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_IPV4]	= PKT_HASH_TYPE_L3,
>> +	[IGC_RSS_TYPE_HASH_TCP_IPV6]	= PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_IPV6_EX]	= PKT_HASH_TYPE_L3,
>> +	[IGC_RSS_TYPE_HASH_IPV6]	= PKT_HASH_TYPE_L3,
>> +	[IGC_RSS_TYPE_HASH_TCP_IPV6_EX] = PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_UDP_IPV4]	= PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_UDP_IPV6]	= PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_UDP_IPV6_EX] = PKT_HASH_TYPE_L4,
>> +	[10] = PKT_HASH_TYPE_NONE, /* RSS Type above 9 "Reserved" by HW  */
>> +	[11] = PKT_HASH_TYPE_NONE, /* keep array sized for SW bit-mask   */
>> +	[12] = PKT_HASH_TYPE_NONE, /* to handle future HW revisons       */
>> +	[13] = PKT_HASH_TYPE_NONE,
>> +	[14] = PKT_HASH_TYPE_NONE,
>> +	[15] = PKT_HASH_TYPE_NONE,
>> +};
>> +
>>   static inline void igc_rx_hash(struct igc_ring *ring,
>>   			       union igc_adv_rx_desc *rx_desc,
>>   			       struct sk_buff *skb)
>>   {
>> -	if (ring->netdev->features & NETIF_F_RXHASH)
>> -		skb_set_hash(skb,
>> -			     le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
>> -			     PKT_HASH_TYPE_L3);
>> +	if (ring->netdev->features & NETIF_F_RXHASH) {
>> +		u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
>> +		u32 rss_type = igc_rss_type(rx_desc);
>> +
>> +		skb_set_hash(skb, rss_hash, igc_rss_type_table[rss_type]);
> 
> Just curious why not copy the logic from the other driver fms10k, ice, ect.
> 
> 	skb_set_hash(skb, le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
> 		     (IXGBE_RSS_L4_TYPES_MASK & (1ul << rss_type)) ?
> 		     PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3);

Detail: This code mis-categorize (e.g. ARP) PKT_HASH_TYPE_L2 as
PKT_HASH_TYPE_L3, but as core reduces this further to one SKB bit, it
doesn't really matter.

> avoiding the table logic. Do the driver folks care?

The define IXGBE_RSS_L4_TYPES_MASK becomes the "table" logic as a 1-bit
true/false table.  It is a more compact table, let me know if this is
preferred.

Yes, it is really upto driver maintainer people to decide, what code is
preferred ?

--Jesper

