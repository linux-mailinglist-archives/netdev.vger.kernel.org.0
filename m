Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1CF699A75
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBPQrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBPQrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:47:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842D74CC95
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676566018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=59uNXmnY+5xpfv8KNp1rUASo+YONUDHrOKaND1BYqkc=;
        b=O3N8vgfzyISBWETXa54WpsFCMHlLpk3ifEpoqj0W13Le2DEHNhQ+MpB8C7maMbZ/s43iJR
        LdWBtxtVjsVTm7G5IekNXYKGXytbt06D09wsjf+PADSJtMJ8aLMybAEtPbKemrekwXAUSo
        6Gw+ytcZKtsVH6bAgqqg5kQZ0o7dCP4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-630-Mz_kFk0dPum1F66F51ijfw-1; Thu, 16 Feb 2023 11:46:57 -0500
X-MC-Unique: Mz_kFk0dPum1F66F51ijfw-1
Received: by mail-ed1-f71.google.com with SMTP id fd23-20020a056402389700b004aaa054d189so2347718edb.11
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:46:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=59uNXmnY+5xpfv8KNp1rUASo+YONUDHrOKaND1BYqkc=;
        b=GiKpWSE8TVljfK0Biq4ZC9mtfFwQsO9YtK8gwvbbtltAfKmnKiMYEm7YYEYMHra8I3
         n2vvYbm+qNr+UMoDntQUMrslAuHhCGNLKvoOnOkThzRDXMP/fD+FxzsMvNqpSdN39A8b
         UvknmRZ2zuAyW6AW0aNsEaYCiyGOKqQ31tiwZ5xIq6SucJFmUtxi10BRrTzz5b/DxJDy
         /k+Q8AgvUYNuN2Q4yKiY7rChpOjiSW++OdWvBZ/TxMPu03JHaleNsK8+xlbGo8meH2yT
         /55eeyGrgWtrjhQDRTUFKZH4YFdqdecEU8rdAgG/CZ55dwaQ27xO54qS1t4qzphvIBRI
         E06Q==
X-Gm-Message-State: AO0yUKXR+s/MB4u4B+ZLko1OVkFha65JQWtG2905RntLx1mC3qe71/UO
        IKsTMVkaXsJlxbqoJm1aVL3hqinvI9UMhz0KJhrggdO4PnPHWoNNmdzwI4SS5ueZL9Hd3+axxQo
        VpgPmu/h+9brPpURm
X-Received: by 2002:aa7:d28d:0:b0:4ac:bcef:505a with SMTP id w13-20020aa7d28d000000b004acbcef505amr6881334edq.38.1676566016259;
        Thu, 16 Feb 2023 08:46:56 -0800 (PST)
X-Google-Smtp-Source: AK7set80Fzbld5F2gDEWeKiKO6SZW4LBZxJ3poPT7SamcTW7fAXxk1srziilHzzaelgpB+gTsNh7sw==
X-Received: by 2002:aa7:d28d:0:b0:4ac:bcef:505a with SMTP id w13-20020aa7d28d000000b004acbcef505amr6881312edq.38.1676566015902;
        Thu, 16 Feb 2023 08:46:55 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id v14-20020a50c40e000000b004acaa4d51bdsm1136242edf.32.2023.02.16.08.46.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 08:46:55 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <fe613404-9d1c-d816-404f-9af4526a42a3@redhat.com>
Date:   Thu, 16 Feb 2023 17:46:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, yoong.siang.song@intel.com,
        anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        xdp-hints@xdp-project.net
Subject: Re: [PATCH bpf-next V1] igc: enable and fix RX hash usage by netstack
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <af69e040-3884-aa73-1241-99207aa577b4@intel.com>
In-Reply-To: <af69e040-3884-aa73-1241-99207aa577b4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2023 14.21, Alexander Lobakin wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Fri, 10 Feb 2023 16:07:59 +0100
> 
>> When function igc_rx_hash() was introduced in v4.20 via commit 0507ef8a0372
>> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
>> hardware wasn't configured to provide RSS hash, thus it made sense to not
>> enable net_device NETIF_F_RXHASH feature bit.
> 
> [...]
> 
>> @@ -311,6 +311,58 @@ extern char igc_driver_name[];
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
>> +#define IGC_RSS_TYPE_MASK		0xF
> 
> GENMASK()?
> 

hmm... GENMASK(3,0) looks more confusing to me. The mask we need here is
so simple that I prefer not to complicate this with GENMASK.

>> +
>> +/* igc_rss_type - Rx descriptor RSS type field */
>> +static inline u8 igc_rss_type(union igc_adv_rx_desc *rx_desc)
> 
> Why use types shorter than u32 on the stack?

Changing to u32 in V2

> Why this union is not const here, since there are no modifications?

Sure

>> +{
>> +	/* RSS Type 4-bit number: 0-9 (above 9 is reserved) */
>> +	return rx_desc->wb.lower.lo_dword.hs_rss.pkt_info & IGC_RSS_TYPE_MASK;
> 
> The most important I wanted to mention: doesn't this function make the
> CPU read the uncached field again, while you could just read it once
> onto the stack and then extract all such data from there?

I really don't think this is an issues here. The igc_adv_rx_desc is only
16 bytes and it should be hot in CPU cache by now.

To avoid the movzx I have changed this to do a u32 read instead.

>> +}
>> +
>> +/* Packet header type identified by hardware (when BIT(11) is zero).
>> + * Even when UDP ports are not part of RSS hash HW still parse and mark UDP bits
>> + */
>> +enum igc_pkt_type_bits {
>> +	IGC_PKT_TYPE_HDR_IPV4	=	BIT(0),
>> +	IGC_PKT_TYPE_HDR_IPV4_WITH_OPT=	BIT(1), /* IPv4 Hdr includes IP options */
>> +	IGC_PKT_TYPE_HDR_IPV6	=	BIT(2),
>> +	IGC_PKT_TYPE_HDR_IPV6_WITH_EXT=	BIT(3), /* IPv6 Hdr includes extensions */
>> +	IGC_PKT_TYPE_HDR_L4_TCP	=	BIT(4),
>> +	IGC_PKT_TYPE_HDR_L4_UDP	=	BIT(5),
>> +	IGC_PKT_TYPE_HDR_L4_SCTP=	BIT(6),
>> +	IGC_PKT_TYPE_HDR_NFS	=	BIT(7),
>> +	/* Above only valid when BIT(11) is zero */
>> +	IGC_PKT_TYPE_L2		=	BIT(11),
>> +	IGC_PKT_TYPE_VLAN	=	BIT(12),
>> +	IGC_PKT_TYPE_MASK	=	0x1FFF, /* 13-bits */
> 
> Also GENMASK().

GENMASK would make more sense here.

>> +};
>> +
>> +/* igc_pkt_type - Rx descriptor Packet type field */
>> +static inline u16 igc_pkt_type(union igc_adv_rx_desc *rx_desc)
> 
> Also short types and consts.
> 

Fixed in V2

>> +{
>> +	u32 data = le32_to_cpu(rx_desc->wb.lower.lo_dword.data);
>> +	/* Packet type is 13-bits - as bits (16:4) in lower.lo_dword*/
>> +	u16 pkt_type = (data >> 4) & IGC_PKT_TYPE_MASK;
> 
> Perfect candidate for FIELD_GET(). No, even for le32_get_bits().

I adjusted this, but I could not find a central define for FIELD_GET 
(but many drivers open code this).

> Also my note above about excessive expensive reads.
> 
>> +
>> +	return pkt_type;
>> +}
>> +
>>   /* Interrupt defines */
>>   #define IGC_START_ITR			648 /* ~6000 ints/sec */
>>   #define IGC_4K_ITR			980
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
>> index 8b572cd2c350..42a072509d2a 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -1677,14 +1677,40 @@ static void igc_rx_checksum(struct igc_ring *ring,
>>   		   le32_to_cpu(rx_desc->wb.upper.status_error));
>>   }
>>   
>> +/* Mapping HW RSS Type to enum pkt_hash_types */
>> +struct igc_rss_type {
>> +	u8 hash_type; /* can contain enum pkt_hash_types */
> 
> Why make a struct for one field? + short type note
> 
>> +} igc_rss_type_table[IGC_RSS_TYPE_MAX_TABLE] = {
>> +	[IGC_RSS_TYPE_NO_HASH].hash_type	  = PKT_HASH_TYPE_L2,
>> +	[IGC_RSS_TYPE_HASH_TCP_IPV4].hash_type	  = PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_IPV4].hash_type	  = PKT_HASH_TYPE_L3,
>> +	[IGC_RSS_TYPE_HASH_TCP_IPV6].hash_type	  = PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_IPV6_EX].hash_type	  = PKT_HASH_TYPE_L3,
>> +	[IGC_RSS_TYPE_HASH_IPV6].hash_type	  = PKT_HASH_TYPE_L3,
>> +	[IGC_RSS_TYPE_HASH_TCP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_UDP_IPV4].hash_type	  = PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_UDP_IPV6].hash_type	  = PKT_HASH_TYPE_L4,
>> +	[IGC_RSS_TYPE_HASH_UDP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
>> +	[10].hash_type = PKT_HASH_TYPE_L2, /* RSS Type above 9 "Reserved" by HW */
>> +	[11].hash_type = PKT_HASH_TYPE_L2,
>> +	[12].hash_type = PKT_HASH_TYPE_L2,
>> +	[13].hash_type = PKT_HASH_TYPE_L2,
>> +	[14].hash_type = PKT_HASH_TYPE_L2,
>> +	[15].hash_type = PKT_HASH_TYPE_L2,
> 
> Why define those empty if you could do a bound check in the code
> instead? E.g. `if (unlikely(bigger_than_9)) return PKT_HASH_TYPE_L2`.

Having a branch for this is likely slower.  On godbolt I see that this 
generates suboptimal and larger code.


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
> 
> 	if (!(feature & HASH))
> 		return;
> 
> and -1 indent level?

Usually, yes, I also prefer early return style code.
For one I just followed the existing style.

Second, I tried to code it up, but it looks ugly in this case, as the
variable defines need to get moved outside the if statement.

>> +		u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
>> +		u8  rss_type = igc_rss_type(rx_desc);
>> +		enum pkt_hash_types hash_type;
>> +
>> +		hash_type = igc_rss_type_table[rss_type].hash_type;
>> +		skb_set_hash(skb, rss_hash, hash_type);
>> +	}
>>   }
> 
> [...]
> 
> Thanks,
> Olek
> 

