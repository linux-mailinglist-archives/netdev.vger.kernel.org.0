Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B53571C09
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiGLOPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiGLOPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1264561B31
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657635303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=266GFhUCmmCN8xc8Ndw3pmarVXi3iQp2eA7vy//odYI=;
        b=gkFcTK2yEYCpHd4dWZTpNGeMCMPAOJQE0w6FomPR1QYsaAhxoRGgb+PH99QD/+uDev6h1Z
        C/UeJj7pyTPGFHxxBmIP6/JDxEjRl+yRV35HdvbrJ35TSF4rpEXi1vcFESfjye2ce8e4Tm
        rXC2czL1MitQEK3G71kegCnK5N4/VGY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-3kdVpQlzMU6Z-aICss1AbA-1; Tue, 12 Jul 2022 10:15:02 -0400
X-MC-Unique: 3kdVpQlzMU6Z-aICss1AbA-1
Received: by mail-lf1-f69.google.com with SMTP id f29-20020a19dc5d000000b004811c8d1918so3653467lfj.2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=266GFhUCmmCN8xc8Ndw3pmarVXi3iQp2eA7vy//odYI=;
        b=CKiAKCXoAm0peOwLAXGXJNk2sPUpfWORwTvaGS7f4r8z2D9sFgy6GBg2VymJfGi3JK
         LSCeV5TX+Z6i63wnE0ieI6TL2KABC7Hm6P+YZeSAMBWxR5Hox8lLYDrlb6WnQfL2mzcs
         QKfytPasCFVlmCXlKrTU0T0j7T9t3qCZ0234BXyjl2VRUe20Zx4LRDQBw1xsQLw+0cHB
         hsfXdOn1Yj3keroGZ7jb9g8zizM21TTbD8x/cHtswxfcK32XEYbagNr2PMi6ogvVB5jx
         LuFlfafKJuHGF9LeGpNWTdowXfqxJwLKHv4DScQpioVFZnTKvrvoONEaq9c65ipGT5xl
         KOZQ==
X-Gm-Message-State: AJIora9ZxiRFxT7Zh+qMgO16go5njcx5Od7upp1joyaKtorsf4+xONTX
        wMYIXoCkj2ZQaJ/6z3zFa0AfRGlyJlnS2Wt3wkvTPl4JKVOKmmlRcFIxIrIF2mciUpbDef9dodk
        BEjlctNer9AalbTUH
X-Received: by 2002:a05:6512:68b:b0:485:f4a1:c2db with SMTP id t11-20020a056512068b00b00485f4a1c2dbmr15959885lfe.119.1657635300347;
        Tue, 12 Jul 2022 07:15:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sNfcQ+bZlAH4C3wrlLJwVUL5oiknHzbXe7KBmMTkwnayCg4aRM46N29uwvgOAa3knZGCI5pw==
X-Received: by 2002:a05:6512:68b:b0:485:f4a1:c2db with SMTP id t11-20020a056512068b00b00485f4a1c2dbmr15959841lfe.119.1657635299873;
        Tue, 12 Jul 2022 07:14:59 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id h28-20020a2ea49c000000b0025d71ab224fsm1069821lji.55.2022.07.12.07.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 07:14:59 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <bea0164c-53dc-efc7-27f3-d1a1b799d880@redhat.com>
Date:   Tue, 12 Jul 2022 16:14:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, Alexander Lobakin <alexandr.lobakin@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce
 and use Generic Hints/metadata
Content-Language: en-US
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
 <20220704154440.7567-1-alexandr.lobakin@intel.com> <87a69o94wz.fsf@toke.dk>
 <20220705154120.22497-1-alexandr.lobakin@intel.com> <87pmij75r1.fsf@toke.dk>
 <20220706135023.1464979-1-alexandr.lobakin@intel.com>
 <87edyxaks0.fsf@toke.dk>
 <CAJ8uoz1XVqVCpkKo18qbkh6jq_Lejk24OwEWCB9cWhokYLEBDQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz1XVqVCpkKo18qbkh6jq_Lejk24OwEWCB9cWhokYLEBDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/07/2022 12.33, Magnus Karlsson wrote:
> On Thu, Jul 7, 2022 at 1:25 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
>>
>>> From: Toke H??iland-J??rgensen <toke@redhat.com>
>>> Date: Tue, 05 Jul 2022 20:51:14 +0200
>>>
>>>> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
>>>>
>>>> [... snipping a bit of context here ...]
>>>>
>>>>>>>> Yeah, I'd agree this kind of configuration is something that can be
>>>>>>>> added later, and also it's sort of orthogonal to the consumption of the
>>>>>>>> metadata itself.
>>>>>>>>
>>>>>>>> Also, tying this configuration into the loading of an XDP program is a
>>>>>>>> terrible interface: these are hardware configuration options, let's just
>>>>>>>> put them into ethtool or 'ip link' like any other piece of device
>>>>>>>> configuration.
>>>>>>>
>>>>>>> I don't believe it fits there, especially Ethtool. Ethtool is for
>>>>>>> hardware configuration, XDP/AF_XDP is 95% software stuff (apart from
>>>>>>> offload bits which is purely NFP's for now).
>>>>>>
>>>>>> But XDP-hints is about consuming hardware features. When you're
>>>>>> configuring which metadata items you want, you're saying "please provide
>>>>>> me with these (hardware) features". So ethtool is an excellent place to
>>>>>> do that :)
>>>>>
>>>>> With Ethtool you configure the hardware, e.g. it won't strip VLAN
>>>>> tags if you disable rx-cvlan-stripping. With configuring metadata
>>>>> you only tell what you want to see there, don't you?
>>>>
>>>> Ah, I think we may be getting closer to identifying the disconnect
>>>> between our way of thinking about this!
>>>>
>>>> In my mind, there's no separate "configuration of the metadata" step.
>>>> You simply tell the hardware what features you want (say, "enable
>>>> timestamps and VLAN offload"), and the driver will then provide the
>>>> information related to these features in the metadata area
>>>> unconditionally. All XDP hints is about, then, is a way for the driver
>>>> to inform the rest of the system how that information is actually laid
>>>> out in the metadata area.
>>>>
>>>> Having a separate configuration knob to tell the driver "please lay out
>>>> these particular bits of metadata this way" seems like a totally
>>>> unnecessary (and quite complicated) feature to have when we can just let
>>>> the driver decide and use CO-RE to consume it?
>>>
>>> Magnus (he's currently on vacation) told me it would be useful for
>>> AF_XDP to enable/disable particular metadata, at least from perf
>>> perspective. Let's say, just fetching of one "checksum ok" bit in
>>> the driver is faster than walking through all the descriptor words
>>> and driver logics (i.e. there's several hundred locs in ice which
>>> just parse descriptor data and build an skb or metadata from it).
>>> But if we would just enable/disable corresponding features through
>>> Ethtool, that would hurt XDP_PASS. Maybe it's a bad example, but
>>> what if I want to have only RSS hash in the metadata (and don't
>>> want to spend cycles on parsing the rest), but at the same time
>>> still want skb path to have checksum status to not die at CPU
>>> checksum calculation?
>>
>> Hmm, so this feels a little like a driver-specific optimisation? I.e.,
>> my guess is that not all drivers have a measurable overhead for pulling
>> out the metadata. Also, once the XDP metadata bits are in place, we can
>> move in the direction of building SKBs from the same source, so I'm not
>> sure it's a good idea to assume that the XDP metadata is separate from
>> what the stack consumes...
>>
>> In any case, if such an optimisation does turn out to be useful, we can
>> add it later (backed by rigorous benchmarks, of course), so I think we
>> can still start with the simple case and iterate from there?
> 
> Just to check if my intuition was correct or not I ran some benchmarks
> around this. I ported Jesper's patch set to the zero-copy driver of
> i40e, which was really simple thanks to Jesper's refactoring. One line
> of code added to the data path of the zc driver and making
> i40e_process_xdp_hints() a global function so it can be reached from
> the zc driver. 

Happy to hear it was simple to extend this to AF_XDP in the driver.
Code design wise I'm trying to keep it simple for drivers to add this.
I have a co-worker that have already extended ixgbe.

> I also moved the prefetch Jesper added to after the
> check if xdp_hints are available since it really degrades performance
> in the xdp_hints off case.

Good to know.

> First number is the throughput change with hints on, and the second
> number is with hints off. All are compared to the performance without
> Jesper's patch set applied. The application is xdpsock -r (which used
> to be part of the samples/bpf directory).

For reviewer to relate to these numbers we need to understand/explain
the extreme numbers we are dealing with.  In my system with i40e and
xdpsock --rx-drop I can AF_XDP drop packets with a rate of 33.633.761 pps.

This corresponds to a processing time per packet: 29.7 ns (nanosec)
  - Calc: (1/33633761)*10^9

> Copy mode with all hints: -21% / -2%

The -21% for enabling all hints does sound like an excessive overhead,
but time-wise this is a reduction/overhead of 6.2 ns.

The real question: Is this 6.2 ns overhead that gives us e.g.
RX-checksumming lower than the gain we can obtain from avoiding doing
RX-checksumming in software?
  - A: My previous experiments conclude[1] that for 1500 bytes frames we
    can save 54 ns (or increase performance with 8% for normal netstack).


I was going for zero overhead when disabling xdp-hints, which is almost
true as the -2% is time-wise a reduction/overhead of 0.59 ns.

  [1] 
https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp_frame01_checksum.org#measurements-compare-results--conclusion


> Zero-copy mode with all hints: -29% / -9%

I'm unsure why the percentages increase here, perhaps because zero-copy 
is faster and thus the overhead becomes a larger percentage?


> Copy mode rx timestamp only (the rest removed with an #if 0): -11%
> Zero-copy mode rx timestamp only: -20%
> 
> So, if you only want rx timestamp, but can only enable every hint or
> nothing, then you get a 10% performance degradation with copy mode and
> 9% with zero-copy mode compared to if you were able just to enable rx
> timestamp alone. With these rough numbers (a real implementation would
> not have an #if 0) I would say it matters, but that does not mean we
> should not start simple and just have a big switch to start with. But
> as we add hints (to the same btfid), this will just get worse.

IMHO we *do* already have individual enable/disable hints features via 
ethtool.
Have you tried to use the individual ethtool switches. e.g.:

  ethtool -K i40e2 rx-checksumming off

The i40e code uses bitfields for extracting the descriptor, which cause
code that isn't optimal or fully optimized by the compiler.  On my setup
I gained 4.2% (or 1.24 ns) by doing this.


> Here are some other numbers I got, in case someone is interested. They
> are XDP numbers from xdp_rxq_info in samples/bpf.
> 
> hints on / hints off
> XDP_DROP: -18% / -1.5%

My xdp_rxq_info (no-touch XDP_DROP) nanosec numbers are:

           hints on / hints off
  XDP_DROP: 35.97ns / 29.80ns  (diff 6.17 ns)

Maybe interesting if I touch data (via option --read), then the overhead
is reduced to 4.84 ns.

--Jesper

> XDP_TX: -10% / -2.5%
> 
>>>>>>> I follow that way:
>>>>>>>
>>>>>>> 1) you pick a program you want to attach;
>>>>>>> 2) usually they are written for special needs and usecases;
>>>>>>> 3) so most likely that program will be tied with metadata/driver/etc
>>>>>>>     in some way;
>>>>>>> 4) so you want to enable Hints of a particular format primarily for
>>>>>>>     this program and usecase, same with threshold and everything
>>>>>>>     else.
>>>>>>>
>>>>>>> Pls explain how you see it, I might be wrong for sure.
>>>>>>
>>>>>> As above: XDP hints is about giving XDP programs (and AF_XDP consumers)
>>>>>> access to metadata that is not currently available. Tying the lifetime
>>>>>> of that hardware configuration (i.e., which information to provide) to
>>>>>> the lifetime of an XDP program is not a good interface: for one thing,
>>>>>> how will it handle multiple programs? What about when XDP is not used at
>>>>>
>>>>> Multiple progs is stuff I didn't cover, but will do later (as you
>>>>> all say to me, "let's start with something simple" :)). Aaaand
>>>>> multiple XDP progs (I'm not talking about attaching progs in
>>>>> differeng modes) is not a kernel feature, rather a libpf feature,
>>>>> so I believe it should be handled there later...
>>>>
>>>> Right, but even if we don't *implement* it straight away we still need
>>>> to take it into consideration in the design. And expecting libxdp to
>>>> arbitrate between different XDP programs' metadata formats sounds like a
>>>> royal PITA :)
>>>>
>>>>>> all but you still want to configure the same features?
>>>>>
>>>>> What's the point of configuring metadata when there are no progs
>>>>> attached? To configure it once and not on every prog attach? I'm
>>>>> not saying I don't like it, just want to clarify.
>>>>
>>>> See above: you turn on the features because you want the stack to
>>>> consume them.
>>>>
>>>>> Maybe I need opinions from some more people, just to have an
>>>>> overview of how most of folks see it and would like to configure
>>>>> it. 'Cause I heard from at least one of the consumers that
>>>>> libpf API is a perfect place for Hints to him :)
>>>>
>>>> Well, as a program author who wants to consume hints, you'd use
>>>> lib{bpf,xdp} APIs to do so (probably in the form of suitable CO-RE
>>>> macros)...
>>>>
>>>>>> In addition, in every other case where we do dynamic data access (with
>>>>>> CO-RE) the BPF program is a consumer that modifies itself to access the
>>>>>> data provided by the kernel. I get that this is harder to achieve for
>>>>>> AF_XDP, but then let's solve that instead of making a totally
>>>>>> inconsistent interface for XDP.
>>>>>
>>>>> I also see CO-RE more fitting and convenient way to use them, but
>>>>> didn't manage to solve two things:
>>>>>
>>>>> 1) AF_XDP programs, so what to do with them? Prepare patches for
>>>>>     LLVM to make it able to do CO-RE on AF_XDP program load? Or
>>>>>     just hardcode them for particular usecases and NICs? What about
>>>>>     "general-purpose" programs?
>>>>
>>>> You provide a library to read the fields. Jesper actually already
>>>> implemented this, did you look at his code?
>>>>
>>>> https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interaction
>>>>
>>>> It basically builds a lookup table at load-time using BTF information
>>>> from the kernel, keyed on BTF ID and field name, resolving them into
>>>> offsets. It's not quite the zero-overhead of CO-RE, but it's fairly
>>>> close and can be improved upon (CO-RE for userspace being one way of
>>>> doing that).
>>>
>>> Aaaah, sorry, I completely missed that. I thought of something
>>> similar as well, but then thought "variable field offsets, that
>>> would annihilate optimization and performance", and our Xsk team
>>> is super concerned about performance hits when using Hints.
>>>
>>>>
>>>>>     And if hardcode, what's the point then to do Generic Hints at
>>>>>     all? Then all it needs is making driver building some meta in
>>>>>     front of frames via on-off button and that's it? Why BTF ID in
>>>>>     the meta then if consumers will access meta hardcoded (via CO-RE
>>>>>     or literally hardcoded, doesn't matter)?
>>>>
>>>> You're quite right, we could probably implement all the access to
>>>> existing (fixed) metadata without using any BTF at all - just define a
>>>> common struct and some flags to designate which fields are set. In my
>>>> mind, there are a couple of reasons for going the BTF route instead:
>>>>
>>>> - We can leverage CO-RE to get close to optimal efficiency in field
>>>>    access.
>>>>
>>>> and, more importantly:
>>>>
>>>> - It's infinitely extensible. With the infrastructure in place to make
>>>>    it really easy to consume metadata described by BTF, we lower the bar
>>>>    for future innovation in hardware offloads. Both for just adding new
>>>>    fixed-function stuff to hardware, but especially for fully
>>>>    programmable hardware.
>>>
>>> Agree :) That libxdp lookup translator fixed lots of stuff in my
>>> mind.
>>
>> Great! Looks like we're slowly converging towards a shared
>> understanding, then! :)
>>
>>>>> 2) In-kernel metadata consumers? Also do CO-RE? Otherwise, with no
>>>>>     generic metadata structure they won't be able to benefit from
>>>>>     Hints. But I guess we still need to provide kernel with meta?
>>>>>     Or no?
>>>>
>>>> In the short term, I think the "generic structure" approach is fine for
>>>> leveraging this in the stack. Both your and Jesper's series include
>>>> this, and I think that's totally fine. Longer term, if it turns out to
>>>> be useful to have something more dynamic for the stack consumption as
>>>> well, we could extend it to be CO-RE based as well (most likely by
>>>> having the stack load a "translator" BPF program or something along
>>>> those lines).
>>>
>>> Oh, that translator prog sounds nice BTW!
>>
>> Yeah, it's only a rough idea Jesper and I discussed at some point, but I
>> think it could have potential (see also point above re: making XDP hints
>> *the* source of metadata for the whole stack; wouldn't it be nice if
>> drivers didn't have to deal with the intricacies of assembling SKBs?).
>>
>> -Toke
>>
> 

