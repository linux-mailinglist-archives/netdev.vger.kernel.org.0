Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06366614B88
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 14:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiKANTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 09:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiKANTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 09:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F85F1B9F1
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 06:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667308688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/HLCak5UWgaDSHUmgCiIV/hjjF70l4ZieqfOV1b+ErI=;
        b=DV964G60pVQ9X/0SOv0YRYsm3SzZdAK99db2NS0rVuc3H56JAXbaJaATpM0qvVrq7uJNov
        yV3Kc75gNu6HP0Ir8H2O9KSLiRCusYy7wAdNWesYkRrkqVuh7wE96JBj8LleIODNvUlSGx
        awtBMMv+WlPzDvS412vkmM4SPRSCzfM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-652-YRSmbP-gNDOBNPNMF1QwCA-1; Tue, 01 Nov 2022 09:18:06 -0400
X-MC-Unique: YRSmbP-gNDOBNPNMF1QwCA-1
Received: by mail-ed1-f70.google.com with SMTP id m7-20020a056402430700b0045daff6ee5dso9870923edc.10
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 06:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:subject:cc
         :user-agent:mime-version:date:message-id:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/HLCak5UWgaDSHUmgCiIV/hjjF70l4ZieqfOV1b+ErI=;
        b=CXn3pnAt1K9WGUHi07hrKx0DG3GWHqxkO1HZ/G9sQnJdAr6b30ojdYA4iieh3HEkwA
         mRsVfiWfXNTOknNbY4mY7a5ytukBM4Pjb/qjzQmYujDvUQuBafDwGjeh9pKwM5dxVAC8
         rNe01o2ODZdKh8ThNqC12rOgF5P50VHuXZNkfbw+lmT76UoDg7obkZzAwtPmE+J4ZNOx
         b3HJA+2kW7hDVGEjefkvMbXCsP1BHRtFZGRj8wDET2RsVp37hTxAkO00k2dEW5BIRcMH
         dy9LZH54rkQ1eh/Rde3xYt26eUTY3HX9Q8gbhG0awAXa/TR/B3ykymj9vrlFOE3FZw+t
         pvtw==
X-Gm-Message-State: ACrzQf0QBohUV9pBdaniW9c3UtBhLrmJrrjcNtOP6ghe3IyjEqGCYa3d
        QotrTuwVAZfhjyeDOm6V/hUrvGqaewkS+jU48ebng4tEE8VFluXKXhecMXjbeUdMuQo+1Ke81uo
        43rArgh3os0MQyO/g
X-Received: by 2002:aa7:cc13:0:b0:453:52dc:1bbf with SMTP id q19-20020aa7cc13000000b0045352dc1bbfmr19402572edt.30.1667308685699;
        Tue, 01 Nov 2022 06:18:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6sbxUa24m+pHSvNOMXZoR0SFO8c1xzbXkkKuXtR3u7g7an212qRBo3yBbBCB6ZweXmusXDzg==
X-Received: by 2002:aa7:cc13:0:b0:453:52dc:1bbf with SMTP id q19-20020aa7cc13000000b0045352dc1bbfmr19402523edt.30.1667308685361;
        Tue, 01 Nov 2022 06:18:05 -0700 (PDT)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id w9-20020a170906384900b007ab1b4cab9bsm4202403ejc.224.2022.11.01.06.18.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 06:18:04 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <a5b70078-5223-b4d6-5aba-1dc698de68a7@redhat.com>
Date:   Tue, 1 Nov 2022 14:18:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC bpf-next 5/5] selftests/bpf: Test rx_timestamp metadata in
 xskxceiver
To:     Stanislav Fomichev <sdf@google.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <20221027200019.4106375-6-sdf@google.com>
 <31f3aa18-d368-9738-8bb5-857cd5f2c5bf@linux.dev>
 <1885bc0c-1929-53ba-b6f8-ace2393a14df@redhat.com>
 <CAKH8qBt3hNUO0H_C7wYiwBEObGEFPXJCCLfkA=GuGC1CSpn55A@mail.gmail.com>
 <20221031142032.164247-1-alexandr.lobakin@intel.com>
 <CAKH8qBt1qM1n0X5uwxcBph9gLOv3FXR2q11viUoxxn35Z2_=ag@mail.gmail.com>
In-Reply-To: <CAKH8qBt1qM1n0X5uwxcBph9gLOv3FXR2q11viUoxxn35Z2_=ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/10/2022 18.00, Stanislav Fomichev wrote:
> On Mon, Oct 31, 2022 at 7:22 AM Alexander Lobakin
> <alexandr.lobakin@intel.com> wrote:
>>
>> From: Stanislav Fomichev <sdf@google.com>
>> Date: Fri, 28 Oct 2022 11:46:14 -0700
>>
>>> On Fri, Oct 28, 2022 at 3:37 AM Jesper Dangaard Brouer
>>> <jbrouer@redhat.com> wrote:
>>>>
>>>>
>>>> On 28/10/2022 08.22, Martin KaFai Lau wrote:
>>>>> On 10/27/22 1:00 PM, Stanislav Fomichev wrote:
>>>>>> Example on how the metadata is prepared from the BPF context
>>>>>> and consumed by AF_XDP:
>>>>>>
>>>>>> - bpf_xdp_metadata_have_rx_timestamp to test whether it's supported;
>>>>>>     if not, I'm assuming verifier will remove this "if (0)" branch
>>>>>> - bpf_xdp_metadata_rx_timestamp returns a _copy_ of metadata;
>>>>>>     the program has to bpf_xdp_adjust_meta+memcpy it;
>>>>>>     maybe returning a pointer is better?
>>>>>> - af_xdp consumer grabs it from data-<expected_metadata_offset> and
>>>>>>     makes sure timestamp is not empty
>>>>>> - when loading the program, we pass BPF_F_XDP_HAS_METADATA+prog_ifindex
>>>>>>
>>>>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>>>> Cc: Willem de Bruijn <willemb@google.com>
>>>>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>>>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>>>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>>>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>>>>>> Cc: xdp-hints@xdp-project.net
>>>>>> Cc: netdev@vger.kernel.org
>>>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>>>>> ---
>>>>>>    .../testing/selftests/bpf/progs/xskxceiver.c  | 22 ++++++++++++++++++
>>>>>>    tools/testing/selftests/bpf/xskxceiver.c      | 23 ++++++++++++++++++-
>>>>>>    2 files changed, 44 insertions(+), 1 deletion(-)
>>
>> [...]
>>
>>>> IMHO sizeof() should come from a struct describing data_meta area see:
>>>>
>>>> https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L62
>>>
>>> I guess I should've used pointers for the return type instead, something like:
>>>
>>> extern __u64 *bpf_xdp_metadata_rx_timestamp(struct xdp_md *ctx) __ksym;
>>>
>>> {
>>>     ...
>>>      __u64 *rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
>>>      if (rx_timestamp) {
>>>          bpf_xdp_adjust_meta(ctx, -(int)sizeof(*rx_timestamp));
>>>          __builtin_memcpy(data_meta, rx_timestamp, sizeof(*rx_timestamp));
>>>      }
>>> }
>>>
>>> Does that look better?
>>
>> I guess it will then be resolved to a direct store, right?
>> I mean, to smth like
>>
>>          if (rx_timestamp)
>>                  *(u32 *)data_meta = *rx_timestamp;
>>
>> , where *rx_timestamp points directly to the Rx descriptor?
> 
> Right. I should've used that form from the beginning, that memcpy is
> confusing :-(
> 
>>>
>>>>>> +        if (ret != 0)
>>>>>> +            return XDP_DROP;
>>>>>> +
>>>>>> +        data = (void *)(long)ctx->data;
>>>>>> +        data_meta = (void *)(long)ctx->data_meta;
>>>>>> +
>>>>>> +        if (data_meta + sizeof(__u32) > data)
>>>>>> +            return XDP_DROP;
>>>>>> +
>>>>>> +        rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
>>>>>> +        __builtin_memcpy(data_meta, &rx_timestamp, sizeof(__u32));
>>>>
>>>> So, this approach first stores hints on some other memory location, and
>>>> then need to copy over information into data_meta area. That isn't good
>>>> from a performance perspective.
>>>>
>>>> My idea is to store it in the final data_meta destination immediately.
>>>
>>> This approach doesn't have to store the hints in the other memory
>>> location. xdp_buff->priv can point to the real hw descriptor and the
>>> kfunc can have a bytecode that extracts the data from the hw
>>> descriptors. For this particular RFC, we can think that 'skb' is that
>>> hw descriptor for veth driver.

Once you point xdp_buff->priv to the real hw descriptor, then we also
need to have some additional data/pointers to NIC hardware info + HW
setup state. You will hit some of the same challenges as John, like
hardware/firmware revisions and chip models, that Jakub pointed out.
Because your approach stays with the driver code, I guess it will be a
bit easier code wise. Maybe we can store data/pointer needed for this in
xdp_rxq_info (xdp->rxq).

I would need to see some code that juggling this HW NCI state from the
kfunc expansion to be convinced this is the right approach.


>>
>> I really do think intermediate stores can be avoided with this
>> approach.
>> Oh, and BTW, if we plan to use a particular Hint in the BPF program
>> only, there's no need to place it in the metadata area at all, is
>> there? You only want to get it in your code, so just retrieve it to
>> the stack and that's it. data_meta is only for cases when you want
>> hints to appear in AF_XDP.
> 
> Correct.

It is not *only* AF_XDP that need data stored in data_meta.

The stores data_meta are also needed for veth and cpumap, because the HW
descriptor is "out-of-scope" and thus no-longer available.


> 
>>>> Do notice that in my approach, the existing ethtool config setting and
>>>> socket options (for timestamps) still apply.  Thus, each individual
>>>> hardware hint are already configurable. Thus we already have a config
>>>> interface. I do acknowledge, that in-case a feature is disabled it still
>>>> takes up space in data_meta areas, but importantly it is NOT stored into
>>>> the area (for performance reasons).
>>>
>>> That should be the case with this rfc as well, isn't it? Worst case
>>> scenario, that kfunc bytecode can explicitly check ethtool options and
>>> return false if it's disabled?
>>
>> (to Jesper)
>>
>> Once again, Ethtool idea doesn't work. Let's say you have roughly
>> 50% of frames to be consumed by XDP, other 50% go to skb path and
>> the stack. In skb, I want as many HW data as possible: checksums,
>> hash and so on. Let's say in XDP prog I want only timestamp. What's
>> then? Disable everything but stamp and kill skb path? Enable
>> everything and kill XDP path?
>> Stanislav's approach allows you to request only fields you need from
>> the BPF prog directly, I don't see any reasons for adding one more
>> layer "oh no I won't give you checksum because it's disabled via
>> Ethtool".
>> Maybe I get something wrong, pls explain then :P
> 
> Agree, good point.

Stanislav's (and John's proposal) is definitely focused and addressing
something else than my patchset.

I optimized the XDP-hints population (for i40e) down to 6 nanosec (on
3.6 GHz CPU = 21 cycles).  Plus, I added an ethtool switch to turn it
off for those XDP users that cannot live with this overhead.  Hoping
this would be fast-enough such that we didn't have to add this layer.
(If XDP returns XDP_PASS then this decoded info can be used for the SKB
creation. Thus, this is essentially just moving decoding RX-desc a bit
earlier in the the driver).

One of my use-cases is getting RX-checksum support in xdp_frame's and
transferring this to SKB creation time.  I have done a number of
measurements[1] to find out how much we can gain of performance for UDP
packets (1500 bytes) with/without RX-checksum.  Initial result showed I
saved 91 nanosec, but that was avoiding to touching data.  Doing full
userspace UDP delivery with a copy (or copy+checksum) showed the real
save was 54 nanosec.  In this context, the 6 nanosec was very small.
Thus, I didn't choose to pursue a BPF layer for individual fields.

  [1]
https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp_frame01_checksum.org

Sure it is super cool if we can create this BPF layer that programmable
selects individual fields from the descriptor, and maybe we ALSO need that.
Could this layer could still be added after my patchset(?), as one could
disable the XDP-hints (via ethtool) and then use kfuncs/kptr to extract
only fields need by the specific XDP-prog use-case.
Could they also co-exist(?), kfuncs/kptr could extend the
xdp_hints_rx_common struct (in data_meta area) with more advanced
offload-hints and then update the BTF-ID (yes, BPF can already resolve
its own BTF-IDs from BPF-prog code).

Great to see all the discussions and different oppinons :-)
--Jesper

