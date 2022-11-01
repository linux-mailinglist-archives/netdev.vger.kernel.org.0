Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B416614C84
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 15:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiKAOYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 10:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiKAOYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 10:24:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B8E2DC7
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 07:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667312612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqDa+kN8lmTDBcXC/JgXxNqx9tt0i1T0RdgjKzwWXWI=;
        b=g4OiiySDWOo0hakuSTTbYbmh2LhwxW/ERvTyTL3lpEpvz992mYvaX7SMPHWUXXzlhBSpSj
        qMEKCdlmATGSnNXxZm/ybc9aHcHrcIjBD51ddBH6gJ7i2UqXaGqwruyp0WTsAvr1NaBESM
        ePP1MDyhUo+J48AmxCtIMqvZtorx4Do=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-116-zbhD9CgeNSaaBodrXy6-sw-1; Tue, 01 Nov 2022 10:23:31 -0400
X-MC-Unique: zbhD9CgeNSaaBodrXy6-sw-1
Received: by mail-ed1-f71.google.com with SMTP id t4-20020a056402524400b004620845ba7bso9934015edd.4
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 07:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sqDa+kN8lmTDBcXC/JgXxNqx9tt0i1T0RdgjKzwWXWI=;
        b=O7qN6F2Bt3fC3aZedl5Cg2D+vC7XvfsyyzLEfIlG3y4V9W6rxVrlFB8agrF9a30zRt
         rCV+T7Z7DXwiBCcEQkNzTmKspJKLFZWH5xbo75HDnMgEFcuvCBOS7/Ck2X29vXAzSZwT
         3GD3SW/fM4F1d/4xSDCh6eXREwYaPV9QHjsXtzqEmwzLcV+XbwmTkcfAJyLxT6TbWf4g
         thpRg0Ny6YNOYhMIm6CU6i3mvM/wF+ECvz//cymWUqbeVhuRJ3dqgJJGVr17PuI0ibnQ
         J3Dj6YlRwSKIaeaAQCDEe+YXcgReXD1OpalQ2Swn9scdDFaoXnLeVDdSTN0rS18c1McC
         cTmA==
X-Gm-Message-State: ACrzQf2fmbfv7wHJJ81sTWwKMTMMlcWpLOnWNZnY5I/g1T1ZzpZKjGxE
        CcGkCWeEAdmTpTuFGhIQAfWU3ziyJTDfnB7vPymQ1jGBidhlmmt9ZqCwcsB7Nw/rFvJpi+sGpmm
        SL8sYx12jWEAc/qb3
X-Received: by 2002:a05:6402:26cc:b0:462:2426:4953 with SMTP id x12-20020a05640226cc00b0046224264953mr19593323edd.13.1667312610510;
        Tue, 01 Nov 2022 07:23:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7EAtyXXEISCk5BIVxhvsExoR2XlOV+BKRQiRc3NgS2/IvtHQzYy6t/vNeNApzYS3rTkdcizg==
X-Received: by 2002:a05:6402:26cc:b0:462:2426:4953 with SMTP id x12-20020a05640226cc00b0046224264953mr19593307edd.13.1667312610241;
        Tue, 01 Nov 2022 07:23:30 -0700 (PDT)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id i2-20020aa7c9c2000000b00458947539desm4549046edt.78.2022.11.01.07.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 07:23:29 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <fb888d27-825c-37c9-128c-b67843777e32@redhat.com>
Date:   Tue, 1 Nov 2022 15:23:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     brouer@redhat.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, Yonghong Song <yhs@meta.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch> <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk> <663fb4f4-04b7-5c1f-899c-bdac3010f073@meta.com>
 <CAKH8qBt=As5ON+CbH304tRanudvTF27bzeSnjH2GQR2TVx+mXw@mail.gmail.com>
 <8892271c-fd8d-e8f3-5de9-b94e5f1ce5fe@meta.com>
 <CAKH8qBvVQnYXL4H1TmGJiOhVS2jeoEcapzp3UtjaGpz0jsJY-w@mail.gmail.com>
In-Reply-To: <CAKH8qBvVQnYXL4H1TmGJiOhVS2jeoEcapzp3UtjaGpz0jsJY-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/10/2022 23.55, Stanislav Fomichev wrote:
> On Mon, Oct 31, 2022 at 3:38 PM Yonghong Song<yhs@meta.com>  wrote:
>>
>> On 10/31/22 3:09 PM, Stanislav Fomichev wrote:
>>> On Mon, Oct 31, 2022 at 12:36 PM Yonghong Song<yhs@meta.com>  wrote:
>>>>
>>>> On 10/31/22 8:28 AM, Toke Høiland-Jørgensen wrote:
>>>>> "Bezdeka, Florian"<florian.bezdeka@siemens.com>  writes:
>>>>>>
>>>>>> On Fri, 2022-10-28 at 18:14 -0700, Jakub Kicinski wrote:
>>>>>>> On Fri, 28 Oct 2022 16:16:17 -0700 John Fastabend wrote:
[...]
>>>>>> All parts of my application (BPF program included) should not be
>>>>>> optimized/adjusted for all the different HW variants out there.
>>>>> Yes, absolutely agreed. Abstracting away those kinds of hardware
>>>>> differences is the whole*point*  of having an OS/driver model. I.e.,
>>>>> it's what the kernel is there for! If people want to bypass that and get
>>>>> direct access to the hardware, they can already do that by using DPDK.
>>>>>
>>>>> So in other words, 100% agreed that we should not expect the BPF
>>>>> developers to deal with hardware details as would be required with a
>>>>> kptr-based interface.
>>>>>
>>>>> As for the kfunc-based interface, I think it shows some promise.
>>>>> Exposing a list of function names to retrieve individual metadata items
>>>>> instead of a struct layout is sorta comparable in terms of developer UI
>>>>> accessibility etc (IMO).
>>>> >>>> Looks like there are quite some use cases for hw_timestamp.
>>>> Do you think we could add it to the uapi like struct xdp_md?
>>>>
>>>> The following is the current xdp_md:
>>>> struct xdp_md {
>>>>            __u32 data;
>>>>            __u32 data_end;
>>>>            __u32 data_meta;
>>>>            /* Below access go through struct xdp_rxq_info */
>>>>            __u32 ingress_ifindex; /* rxq->dev->ifindex */
>>>>            __u32 rx_queue_index;  /* rxq->queue_index  */
>>>>
>>>>            __u32 egress_ifindex;  /* txq->dev->ifindex */
>>>> };
>>>>
>>>> We could add  __u64 hw_timestamp to the xdp_md so user
>>>> can just do xdp_md->hw_timestamp to get the value.
>>>> xdp_md->hw_timestamp == 0 means hw_timestamp is not
>>>> available.
>>>>
>>>> Inside the kernel, the ctx rewriter can generate code
>>>> to call driver specific function to retrieve the data.
>>> If the driver generates the code to retrieve the data, how's that
>>> different from the kfunc approach?
>>> The only difference I see is that it would be a more strong UAPI than
>>> the kfuncs?
>> Right. it is a strong uapi.
>>
>>>> The kfunc approach can be used to*less*  common use cases?
>>> What's the advantage of having two approaches when one can cover
>>> common and uncommon cases?
>>
>> Beyond hw_timestamp, do we have any other fields ready to support?
>>
>> If it ends up with lots of fields to be accessed by the bpf program,
>> and bpf program actually intends to access these fields,
>> using a strong uapi might be a good thing as it can make code
>> much streamlined.
> > There are a bunch. Alexander's series has a good list:
> 
> https://github.com/alobakin/linux/commit/31bfe8035c995fdf4f1e378b3429d24b96846cc8
> 

Below are the fields I've identified, which are close to what Alexander 
also found.

  struct xdp_hints_common {
	union {
		__wsum		csum;
		struct {
			__u16	csum_start;
			__u16	csum_offset;
		};
	};
	u16 rx_queue;
	u16 vlan_tci;
	u32 rx_hash32;
	u32 xdp_hints_flags;
	u64 btf_full_id; /* BTF object + type ID */
  } __attribute__((aligned(4))) __attribute__((packed));

Some of the fields are encoded via flags:

  enum xdp_hints_flags {
	HINT_FLAG_CSUM_TYPE_BIT0  = BIT(0),
	HINT_FLAG_CSUM_TYPE_BIT1  = BIT(1),
	HINT_FLAG_CSUM_TYPE_MASK  = 0x3,

	HINT_FLAG_CSUM_LEVEL_BIT0 = BIT(2),
	HINT_FLAG_CSUM_LEVEL_BIT1 = BIT(3),
	HINT_FLAG_CSUM_LEVEL_MASK = 0xC,
	HINT_FLAG_CSUM_LEVEL_SHIFT = 2,

	HINT_FLAG_RX_HASH_TYPE_BIT0 = BIT(4),
	HINT_FLAG_RX_HASH_TYPE_BIT1 = BIT(5),
	HINT_FLAG_RX_HASH_TYPE_MASK = 0x30,
	HINT_FLAG_RX_HASH_TYPE_SHIFT = 0x4,

	HINT_FLAG_RX_QUEUE = BIT(7),

	HINT_FLAG_VLAN_PRESENT            = BIT(8),
	HINT_FLAG_VLAN_PROTO_ETH_P_8021Q  = BIT(9),
	HINT_FLAG_VLAN_PROTO_ETH_P_8021AD = BIT(10),
	/* Flags from BIT(16) can be used by drivers */
  };

> We can definitely call some of them more "common" than the others, but
> not sure how strong of a definition that would be.

The important fields that would be worth considering as UAPI candidates
are: (1) RX-hash, (2) Hash-type and (3) RX-checksum.
With these three we can avoid calling the flow-dissector and GRO frame
aggregations works. (This currently hurts xdp_frame to SKB performance a
lot in practice).

*BUT* in it's current form above (incl. Alexanders approach/patch) it
would be a mistake to UAPI standardize the "(2) Hash-type" in this
simplified "reduced" form (which is what the SKB "needs").

There is a huge untapped potential in the Hash-type.  Thanks to
Microsoft almost all NIC hardware provided a Hash-type that gives us the
L3-protocol (IPv4 or IPv6) and the L4-protocol (UDP or TCP and sometimes
SCTP), plus info if extention-headers are provided. (Digging in
datasheets, we can often also get the header-size).

Think about how many cycles XDP BPF-prog can save parsing protocol
headers.  I'm also hoping we can leveregate this to allow SKBs created
from an xdp_frame to have skb->transport_header and skb->network_header
pre-populated (and skip some of these netstack layers).

--Jesper

p.s. in my patchset, I exposed the "raw" Hash-type bits from the 
descriptor in hope this would evolve.

