Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70C7461A08
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbhK2Oob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:44:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378723AbhK2Om1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:42:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638196749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O7S5OjizQijBIczl+/4wBXHSjD2sJgr/PTbq1lX6VZ4=;
        b=XpXEEVQDWC8KBgPoS10ox6zrsyG4I4IvHyhBlyeIm4fkRB8HTl5s+LemdrypPb+CREc6tz
        Nwa8DppYz4oClsf36pv1A6MZSVYzksIQbqOXvE8/NmN7QRRUcKgqwjBp9TefJA8UlCR/nA
        FR0JiUoq2UbsLwWAhbvrL3GTLGkjuK8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-Mcq7tAITMoaU0Oz8noVp2g-1; Mon, 29 Nov 2021 09:39:07 -0500
X-MC-Unique: Mcq7tAITMoaU0Oz8noVp2g-1
Received: by mail-ed1-f69.google.com with SMTP id s12-20020a50ab0c000000b003efdf5a226fso7766257edc.10
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 06:39:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=O7S5OjizQijBIczl+/4wBXHSjD2sJgr/PTbq1lX6VZ4=;
        b=A8xVmZEhtizt+m2j3lBf52wl2jc+Hv3LwpqzWhDzjbOzzPPqGQdQ+SnDmU98SrifWB
         jelXr60rl4eJpDG7QXEsfrN63zo8+an7KOM/UGW5nWVGm7bvsE//FLRIZycI4m2Nz5jA
         a1hMvs+MbWAqRkc3qjb4sQ+yRpJ4ZIfmxxVntPSQ50sDIayGFFNh1qZ4tWBOhxQpd6VU
         Niwh5QmKyEMU0JEFILwIclOUBmvou6dA9lU24SK8m6jM55x4j/llJXV4akVRo/S0Y8mq
         xO93ftqDywDrI9tvP9NX9dJxBL6TJ4XqU4sUKqIlX3xQX+2D9z+r9toynCZ5Qrpp5dmD
         z6Kg==
X-Gm-Message-State: AOAM532P2dQ47Ip4slu/fVYFGraV9PrSRe3DiZME1ouH6uqzlS9N23/B
        zrXly7GWL/LkLZ6v2c8zt8lFKf5/4lc6REl22NmPzUMrFtD1Jixw2F0Hf2tbCBTJTv/26iVmwsN
        1QVmGEdJLTR6h7ti8
X-Received: by 2002:a17:907:6e8e:: with SMTP id sh14mr60718732ejc.536.1638196745923;
        Mon, 29 Nov 2021 06:39:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6bdVXynDkMurbo0wdDJkXKq7sUHLsLuYlZSX0wdDkgLTI+lyg0CzaDm0yWoDDUyjO4luUjQ==
X-Received: by 2002:a17:907:6e8e:: with SMTP id sh14mr60718710ejc.536.1638196745735;
        Mon, 29 Nov 2021 06:39:05 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id hg19sm7327636ejc.1.2021.11.29.06.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 06:39:05 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <6de05aea-9cf4-c938-eff2-9e3b138512a4@redhat.com>
Date:   Mon, 29 Nov 2021 15:39:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] igc: enable XDP metadata in driver
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
 <163700859087.565980.3578855072170209153.stgit@firesoul>
 <20211126161649.151100-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211126161649.151100-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/11/2021 17.16, Alexander Lobakin wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Mon, 15 Nov 2021 21:36:30 +0100
> 
>> Enabling the XDP bpf_prog access to data_meta area is a very small
>> change. Hint passing 'true' to xdp_prepare_buff().
>>
>> The SKB layers can also access data_meta area, which required more
>> driver changes to support. Reviewers, notice the igc driver have two
>> different functions that can create SKBs, depending on driver config.
>>
>> Hint for testers, ethtool priv-flags legacy-rx enables
>> the function igc_construct_skb()
>>
>>   ethtool --set-priv-flags DEV legacy-rx on
>>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   drivers/net/ethernet/intel/igc/igc_main.c |   29 +++++++++++++++++++----------
>>   1 file changed, 19 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
>> index 76b0a7311369..b516f1b301b4 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -1718,24 +1718,26 @@ static void igc_add_rx_frag(struct igc_ring *rx_ring,
>>   
>>   static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
>>   				     struct igc_rx_buffer *rx_buffer,
>> -				     union igc_adv_rx_desc *rx_desc,
>> -				     unsigned int size)
>> +				     struct xdp_buff *xdp)
>>   {
>> -	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
>> +	unsigned int size = xdp->data_end - xdp->data;
>>   	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
>> +	unsigned int metasize = xdp->data - xdp->data_meta;
>>   	struct sk_buff *skb;
>>   
>>   	/* prefetch first cache line of first page */
>> -	net_prefetch(va);
>> +	net_prefetch(xdp->data);
> 
> I'd prefer prefetching xdp->data_meta here. GRO layer accesses it.
> Maximum meta size for now is 32, so at least 96 bytes of the frame
> will stil be prefetched.

Prefetch works for "full" cachelines. Intel CPUs often prefect two 
cache-lines, when doing this, thus I guess we still get xdp->data.

I don't mind prefetching xdp->data_meta, but (1) I tried to keep the 
change minimal as current behavior was data area I kept that. (2) 
xdp->data starts on a cacheline and we know NIC hardware have touched 
that, it is not a full-cache-miss due to DDIO/DCA it is known to be in 
L3 cache (gain is around 2-3 ns in my machine for data prefetch).
Given this is only a 2.5 Gbit/s driver/HW I doubt this make any difference.

Tony is it worth resending a V2 of this patch?

>>   
>>   	/* build an skb around the page buffer */
>> -	skb = build_skb(va - IGC_SKB_PAD, truesize);
>> +	skb = build_skb(xdp->data_hard_start, truesize);
>>   	if (unlikely(!skb))
>>   		return NULL;
>>   
>>   	/* update pointers within the skb to store the data */
>> -	skb_reserve(skb, IGC_SKB_PAD);
>> +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>>   	__skb_put(skb, size);
>> +	if (metasize)
>> +		skb_metadata_set(skb, metasize);
>>   
>>   	igc_rx_buffer_flip(rx_buffer, truesize);
>>   	return skb;
>> @@ -1746,6 +1748,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
>>   					 struct xdp_buff *xdp,
>>   					 ktime_t timestamp)
>>   {
>> +	unsigned int metasize = xdp->data - xdp->data_meta;
>>   	unsigned int size = xdp->data_end - xdp->data;
>>   	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
>>   	void *va = xdp->data;
>> @@ -1756,7 +1759,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
>>   	net_prefetch(va);
> 
> ...here as well.
> 

