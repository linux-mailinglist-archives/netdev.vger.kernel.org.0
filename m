Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F071729A2
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgB0UoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:44:08 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38792 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgB0UoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 15:44:07 -0500
Received: by mail-qt1-f196.google.com with SMTP id e20so363349qto.5
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wNQXZQVRVzF3/QhY3WxQnPzwhdQB95qxj0q9fin+SqI=;
        b=Pn4zkzyNxL7BPyga2pEYeOHop8FSLaTJhANeeA4KSbkdQk9pxJHVvoNrtRLf62uEVY
         q23I2MEioQHZYLZOyp+z7FZNFb9Tr229u6+egBBpmIrCZRw7sIV8jVdgrtdLoqYrjJmz
         s0wScrDho+MbrbvjyFfAusA3MSV4qdbaFYtso=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wNQXZQVRVzF3/QhY3WxQnPzwhdQB95qxj0q9fin+SqI=;
        b=GqM5xXdlvnfN8rOGy+H7wYt/EJ7USQ//rSP1e6EI4z8IXsuBe/V81yzOTyAIUsqA3u
         zEi6uD6+/Tz46+eNVVsHeY1Cydq9XEhvNbTrA58XYrrze1Up1mEQqmks6z+aAychFoMq
         HSa6T8jMmYaAdG44cwZ6AsSb/ulgxEclxO5GHTaFpBsUFoQsQGwbcA6zpakH4b+CuvQn
         9ZT/dmm9j1PCDmQX6Vtk2gKYD6V0xY4TYs3POCUpf/tgBZniHDa+3qBC3M2maWnztlnY
         5B0nOxdcCCenu/6njItLjZ+vnDuqUM64GwJOEYDPvQYxw5ZshCfW/vmvH7bCIWaxBKOD
         /1lA==
X-Gm-Message-State: APjAAAWHvmR23gTZtK1+3qSNyd7fHoR1wjTrasgF2otS6/IhC1GiSIbX
        DqpgHadG63CNcKHfZY3C4DADNA==
X-Google-Smtp-Source: APXvYqzjaiwbsoC+DCM5pwHoVfRSjO4rM+mT5tt7FaixV7buklJ8jjCsAB4TuS5xDW2v0FiVVepi0Q==
X-Received: by 2002:ac8:377a:: with SMTP id p55mr1174351qtb.87.1582836247002;
        Thu, 27 Feb 2020 12:44:07 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:a58e:e5e0:4900:6bcd? ([2601:282:803:7700:a58e:e5e0:4900:6bcd])
        by smtp.gmail.com with ESMTPSA id u2sm3920215qtd.72.2020.02.27.12.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 12:44:06 -0800 (PST)
Subject: Re: [PATCH RFC v4 bpf-next 03/11] xdp: Add xdp_txq_info to xdp_buff
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-4-dsahern@kernel.org> <20200227090046.3e3177b3@carbon>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <423dd8d6-6e84-01d4-c529-ce85d84fa24b@digitalocean.com>
Date:   Thu, 27 Feb 2020 13:44:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200227090046.3e3177b3@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/20 1:00 AM, Jesper Dangaard Brouer wrote:
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 7850f8683b81..5e3f8aefad41 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3334,8 +3334,10 @@ struct xdp_md {
>>  	__u32 data;
>>  	__u32 data_end;
>>  	__u32 data_meta;
>> -	/* Below access go through struct xdp_rxq_info */
>> -	__u32 ingress_ifindex; /* rxq->dev->ifindex */
>> +	union {
>> +		__u32 ingress_ifindex; /* rxq->dev->ifindex */
>> +		__u32 egress_ifindex;  /* txq->dev->ifindex */
>> +	};
> 
> Are we sure it is wise to "union share" (struct) xdp_md as the
> XDP-context in the XDP programs, with different expected_attach_type?
> As this allows the XDP-programmer to code an EGRESS program that access
> ctx->ingress_ifindex, this will under the hood be translated to
> ctx->egress_ifindex, because from the compilers-PoV this will just be an
> offset.
> 
> We are setting up the XDP-programmer for a long debugging session, as
> she will be expecting to read 'ingress_ifindex', but will be getting
> 'egress_ifindex'.  (As the compiler cannot warn her, and it is also
> correct seen from the verifier).

It both cases it means the device handling the packet. ingress_ifindex
== device handling the Rx, egress_ifindex == device handling the Tx.
Really, it is syntactic sugar for program writers. It would have been
better had xdp_md only called it ifindex from the beginning.

> 
> 
>>  	__u32 rx_queue_index;  /* rxq->queue_index  */
> 
> So, the TX program can still read 'rx_queue_index', is this wise?
> (It should be easy to catch below and reject).

See patch 2.

In time I expect rx_queue_index to be a union with tx_queue_index for
the same reasons as the ifindex.
