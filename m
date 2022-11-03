Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FF36182AE
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiKCP0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiKCP0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:26:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBA017591
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667489121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FxLknX4Dr+lEWZuVdXeEwVh4CFMkJIAad9Vx7F97Myg=;
        b=GPu/aZJAjr8z0DrAAchqdrxzfiBnPdgalJoA3qYdPYDHzPh02vCoEc2zPA0/z1k66JGpQs
        oFa5/E/1wi3xEf3tyEx540DwTOxIijvu5HleEy21i04KbfsvlMXTnwf+95VUBa/nCamzZl
        Bge3ON/GK2COAeU4tIJe0a1q2AhMXBg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542--XdN2r9XPtOVXCi75NRpLQ-1; Thu, 03 Nov 2022 11:25:19 -0400
X-MC-Unique: -XdN2r9XPtOVXCi75NRpLQ-1
Received: by mail-ej1-f70.google.com with SMTP id qw17-20020a1709066a1100b0078e25b6a52fso1489367ejc.3
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 08:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FxLknX4Dr+lEWZuVdXeEwVh4CFMkJIAad9Vx7F97Myg=;
        b=R2cTAYExGgactBsg5+hHA4mcrUlcRBvXjhiUOxThFq+fQPa8tPKNRgB261vwhInfLD
         c0xxv17imnBdQTzoaIWlaejHQVR17R7E5FBmpaHUxOCR7ZqqpGxCfhhB6PVjEYRlIIeT
         HzTC6eD+UQzzCvrnyb2Ib5IDQCKhZRnigJUBD8uMxr79hURfIVkLZZo8y/QY+cgN16Tz
         qgqQb7TAIQm7sxkpm1YK++VsGBRfZZ124awsZ6k654skHByX9GYHFQB9oJsSc7clKu8e
         HGGP+v2L58Zc+jwFj2tJP3zqqmbNrVA7L75I2XGStCK8ukvQqWyQrDLCTkrFFFc8q+gX
         smAQ==
X-Gm-Message-State: ACrzQf1UZObkBpeKIr+orgNK4yc/3YM1y5pX6dbU0FOBp+YiiVQlHIKm
        ULknk1zUjdDtah5r5ZTY8hB24muojkhOEEEFVwZVeK4XyKg70gnVPM9jXC1zkgtniWwhpuIkVij
        +yrgFQ4mc+V/8FDl7
X-Received: by 2002:a05:6402:5510:b0:459:5ea:9bc0 with SMTP id fi16-20020a056402551000b0045905ea9bc0mr4209430edb.152.1667489118581;
        Thu, 03 Nov 2022 08:25:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4HulvbSJDEYzS6l9D4wa2lXruzJnGJ2K7yGk5WihK6Ks0IyqLtq43ro6Q5Wd+UvnSrDG5IEg==
X-Received: by 2002:a05:6402:5510:b0:459:5ea:9bc0 with SMTP id fi16-20020a056402551000b0045905ea9bc0mr4209393edb.152.1667489118199;
        Thu, 03 Nov 2022 08:25:18 -0700 (PDT)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id l1-20020a1709060cc100b007adf2e4c6f7sm599887ejh.195.2022.11.03.08.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:25:17 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <7fafd655-950f-bf1d-a37a-aa08978ddfa8@redhat.com>
Date:   Thu, 3 Nov 2022 16:25:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     brouer@redhat.com, Martin KaFai Lau <martin.lau@linux.dev>,
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
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch> <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk>
 <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev>
 <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
 <0c00ba33-f37b-dfe6-7980-45920ffa273b@linux.dev>
 <48ba6e77-1695-50b3-b27f-e82750ee70bb@redhat.com> <87iljx2ey4.fsf@toke.dk>
 <CAKH8qBt31WBpDWb+SkNpuzE1PuwC1O_v7seF9TMJfc6SvhN7MQ@mail.gmail.com>
 <87cza43nlu.fsf@toke.dk> <df32c60e-84de-16a3-f751-d393f37e5347@redhat.com>
 <874jvg2og4.fsf@toke.dk>
In-Reply-To: <874jvg2og4.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/11/2022 13.48, Toke Høiland-Jørgensen wrote:
> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
> 
>> On 03/11/2022 01.09, Toke Høiland-Jørgensen wrote:
>>> Stanislav Fomichev <sdf@google.com> writes:
>>>
>>>> On Wed, Nov 2, 2022 at 3:02 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>>>
>>>>> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
>>>>>
>>>>>> On 01/11/2022 18.05, Martin KaFai Lau wrote:
>>>>>>> On 10/31/22 6:59 PM, Stanislav Fomichev wrote:
>>>>>>>> On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau
>>>>>>>> <martin.lau@linux.dev> wrote:
>>>>>>>>>
>>>>>>>>> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
>>>>>>>>>>> 2. AF_XDP programs won't be able to access the metadata without
>>>>>>>>>>> using a
>>>>>>>>>>> custom XDP program that calls the kfuncs and puts the data into the
>>>>>>>>>>> metadata area. We could solve this with some code in libxdp,
>>>>>>>>>>> though; if
>>>>>>>>>>> this code can be made generic enough (so it just dumps the available
>>>>>>>>>>> metadata functions from the running kernel at load time), it may be
>>>>>>>>>>> possible to make it generic enough that it will be forward-compatible
>>>>>>>>>>> with new versions of the kernel that add new fields, which should
>>>>>>>>>>> alleviate Florian's concern about keeping things in sync.
>>>>>>>>>>
>>>>>>>>>> Good point. I had to convert to a custom program to use the kfuncs :-(
>>>>>>>>>> But your suggestion sounds good; maybe libxdp can accept some extra
>>>>>>>>>> info about at which offset the user would like to place the metadata
>>>>>>>>>> and the library can generate the required bytecode?
>>>>>>>>>>
>>>>>>>>>>> 3. It will make it harder to consume the metadata when building
>>>>>>>>>>> SKBs. I
>>>>>>>>>>> think the CPUMAP and veth use cases are also quite important, and that
>>>>>>>>>>> we want metadata to be available for building SKBs in this path. Maybe
>>>>>>>>>>> this can be resolved by having a convenient kfunc for this that can be
>>>>>>>>>>> used for programs doing such redirects. E.g., you could just call
>>>>>>>>>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>>>>>>>>>>> would recursively expand into all the kfunc calls needed to extract
>>>>>>>>>>> the
>>>>>>>>>>> metadata supported by the SKB path?
>>>>>>>>>>
>>>>>>>>>> So this xdp_copy_metadata_for_skb will create a metadata layout that
>>>>>>>>>
>>>>>>>>> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
>>>>>>>>> Not sure where is the best point to specify this prog though.
>>>>>>>>> Somehow during
>>>>>>>>> bpf_xdp_redirect_map?
>>>>>>>>> or this prog belongs to the target cpumap and the xdp prog
>>>>>>>>> redirecting to this
>>>>>>>>> cpumap has to write the meta layout in a way that the cpumap is
>>>>>>>>> expecting?
>>>>>>>>
>>>>>>>> We're probably interested in triggering it from the places where xdp
>>>>>>>> frames can eventually be converted into skbs?
>>>>>>>> So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW,
>>>>>>>> anything that's not XDP_DROP / AF_XDP redirect).
>>>>>>>> We can probably make it magically work, and can generate
>>>>>>>> kernel-digestible metadata whenever data == data_meta, but the
>>>>>>>> question - should we?
>>>>>>>> (need to make sure we won't regress any existing cases that are not
>>>>>>>> relying on the metadata)
>>>>>>>
>>>>>>> Instead of having some kernel-digestible meta data, how about calling
>>>>>>> another bpf prog to initialize the skb fields from the meta area after
>>>>>>> __xdp_build_skb_from_frame() in the cpumap, so
>>>>>>> run_xdp_set_skb_fileds_from_metadata() may be a better name.
>>>>>>>
>>>>>>
>>>>>> I very much like this idea of calling another bpf prog to initialize the
>>>>>> SKB fields from the meta area. (As a reminder, data need to come from
>>>>>> meta area, because at this point the hardware RX-desc is out-of-scope).
>>>>>> I'm onboard with xdp_copy_metadata_for_skb() populating the meta area.
>>>>>>
>>>>>> We could invoke this BPF-prog inside __xdp_build_skb_from_frame().
>>>>>>
>>>>>> We might need a new BPF_PROG_TYPE_XDP2SKB as this new BPF-prog
>>>>>> run_xdp_set_skb_fields_from_metadata() would need both xdp_buff + SKB as
>>>>>> context inputs. Right?  (Not sure, if this is acceptable with the BPF
>>>>>> maintainers new rules)
>>>>>>
>>>>>>> The xdp_prog@rx sets the meta data and then redirect.  If the
>>>>>>> xdp_prog@rx can also specify a xdp prog to initialize the skb fields
>>>>>>> from the meta area, then there is no need to have a kfunc to enforce a
>>>>>>> kernel-digestible layout.  Not sure what is a good way to specify this
>>>>>>> xdp_prog though...
>>>>>>
>>>>>> The challenge of running this (BPF_PROG_TYPE_XDP2SKB) BPF-prog inside
>>>>>> __xdp_build_skb_from_frame() is that it need to know howto decode the
>>>>>> meta area for every device driver or XDP-prog populating this (as veth
>>>>>> and cpumap can get redirected packets from multiple device drivers).
>>>>>
>>>>> If we have the helper to copy the data "out of" the drivers, why do we
>>>>> need a second BPF program to copy data to the SKB?
>>>>>
>>
>> IMHO the second BPF program to populate the SKB is needed to add
>> flexibility and extensibility.
>>
>> My end-goal here is to speedup packet parsing.
>> This BPF-prog should (in time) be able to update skb->transport_header
>> and skb->network_header.  As I mentioned before, HW RX-hash already tell
>> us the L3 and L4 protocols and in-most-cases header-len.  Even without
>> HW-hints, the XDP-prog likely have parsed the packet once. This parse
>> information is lost today, and redone by netstack. What about storing
>> this header parse info in meta data and re-use in this new XDP2SKB hook?
>>
>> The reason for suggesting this BPF-prog to be a callback, associated
>> with the net_device, were that HW is going to differ on what HW hints
>> that HW support.  Thus, we can avoid a generic C-function that need to
>> check for all the possible hints, and instead have a BPF-prog that only
>> contains the code that is relevant for this net_device.
> 
> But that's exactly what the xdp_copy_metadata_for_skb() is! It's a
> dynamic "BPF program" (generated as unrolled kfunc calls) just running
> in the helper and stashing the results in an intermediate struct in the
> metadata area. And once it's done that, we don't need *another* dynamic
> BPF program to read it back out and populate the SKB, because the
> intermediate format it's been stashed into is under the control of the
> kernel (we just need a flag to indicate that it's there).
> 
>>>>> I.e., the XDP program calls xdp_copy_metadata_for_skb(); this invokes
>>>>> each of the kfuncs needed for the metadata used by SKBs, all of which
>>>>> get unrolled. The helper takes the output of these metadata-extracting
>>>>> kfuncs and stores it "somewhere". This "somewhere" could well be the
>>>>> metadata area; but in any case, since it's hidden away inside a helper
>>>>> (or kfunc) from the calling XDP program's PoV, the helper can just stash
>>>>> all the data in a fixed format, which __xdp_build_skb_from_frame() can
>>>>> then just read statically. We could even make this format match the
>>>>> field layout of struct sk_buff, so all we have to do is memcpy a
>>>>> contiguous chunk of memory when building the SKB.
>>>>
>>>> +1
>>
>> Sorry, I think this "hiding" layout trick is going in a wrong direction.
>>
>> Imagine the use-case of cpumap redirect.  The physical device XDP-prog
>> calls xdp_copy_metadata_for_skb() to extract info from RX-desc, then it
>> calls redirect into cpumap.  On remote CPU, the xdp_frame is picked up,
>> and then I want to run another XDP-prog that want to look at these
>> HW-hints, and then likely call XDP_PASS which creates the SKB, also
>> using these HW-hints.  I take it, it would not be possible when using
>> the xdp_copy_metadata_for_skb() helper?
> 
> You're right that it should be possible to read the values back out
> again later. That is totally possible with this scheme, though; the
> 'xdp_to_skb_metadata' is going to be in the vmlinux BTF, so an XDP
> program can just read that. We can explicitly support it by using the
> BTF ID as the "magic value" as you suggest, which would be fine by me.
> 

I'm on-board if we as you suggest, add the BTF_ID as the "magic value" 
(as last member due to AF_XDP processing).  When 
xdp_copy_metadata_for_skb() writes 'xdp_to_skb_metadata' in metadata 
area.  We should simply see this BTF-ID as a 'cookie' or magic number.

> I still think we should be using the __randomize_layout trick, though,
> precisely so that BPF consumers are forced to use BTF relocations to
> read it; otherwise we risk the struct layout ossifying into UAPI because
> people are just going to assume it's static...
> 

I'm also on-board with some level of randomization to the struct to 
force consumers to use BTF for relocations. e.g BTF-ID cookie/magic 
should be at a fixed location.


>>>> I'm currently doing exactly what you're suggesting (minus matching skb layout):
>>>>
>>>> struct xdp_to_skb_metadata {
>>>>     u32 magic; // randomized at boot
>>>>     ... skb-consumable-metadata in fixed format
>>>> } __randomize_layout;
>>>>
>>>> bpf_xdp_copy_metadata_for_skb() does bpf_xdp_adjust_meta(ctx,
>>>> -sizeof(struct xdp_to_skb_metadata)) and then calls a bunch of kfuncs
>>>> to fill in the actual data.
>>>>
>>>> Then, at __xdp_build_skb_from_frame time, I'm having a regular kernel
>>>> C code that parses that 'struct xdp_to_skb_metadata'.
>>>> (To be precise, I'm trying to parse the metadata from
>>>> skb_metadata_set; it's called from __xdp_build_skb_from_frame, but not
>>>> 100% sure that's the right place).
>>>> (I also randomize the layout and magic to make sure userspace doesn't
>>>> depend on it because nothing stops this packet to be routed into xsk
>>>> socket..)
>>>
>>> Ah, nice trick with __randomize_layout - I agree we need to do something
>>> to prevent userspace from inadvertently starting to rely on this, and
>>> this seems like a great solution!
>>
>> Sorry, I disagree where this is going.  Why do all of a sudden want to
>> prevent userspace (e.g. AF_XDP) from using this data?!?
> 
> See above: I don't think we should prevent userspace from using it (and
> we're not), but we should prevent the struct layout from ossifying.
> 

Okay, then we are in agreement, avoid ossifying struct layout.

>> The hole exercise started with wanting to provide AF_XDP with these
>> HW-hints. The hints a standard AF_XDP user wants is likely very
>> similar to what the SKB user wants. Why do the AF_XDP user need to
>> open code this?
>>
>> The BTF-ID scheme precisely allows us to expose this layout to
>> userspace, and at the same time have freedom to change this in kernel
>> space, as userspace must decode the BTF-layout before reading this.
>> I was hoping xdp_copy_metadata_for_skb() could simply use the BTF-ID
>> scheme, with the BTF-ID of struct xdp_hints_rx_common, is to too much to
>> ask for?  You can just consider the BTF-ID as the magic number, as it
>> will be more-or-less random per kernel build (and module load order).
> 
> As mentioned above, I would be totally fine with just having the
> xdp_to_skb_metadata be part of BTF, enabling both XDP programs and
> AF_XDP consumers to re-use it.
>

My use-case is that AF_XDP will need to key on this runtime BTF-ID magic 
value anyway to read out 'xdp_to_skb_metadata' values.  I have an 
XDP-prog running, that will RX-timestamp only the time-sync protocol 
packets.  Code wise, I will simply add my RX-timestamp on top of struct 
'xdp_to_skb_metadata' and then update the BTF-ID magic value.  I don't 
need to add a real BTF-ID but just some magic value that my AF_XDP 
userspace prog knows about.  In my current code[1], I'm playing nice and 
adds the BPF-prog's own local BTF-ID via bpf_core_type_id_local().

[1] 
https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L80


>>> Look forward to seeing what the whole thing looks like in a more
>>> complete form :)
>>
>> I'm sort of on-board with the kfuncs and unroll-tricks, if I can see
>> some driver code that handles the issues of getting HW setup state
>> exposed needed to decode the RX-desc format.
>>
>> I sense that I myself, haven't been good enough to explain/convey the
>> BTF-ID scheme.  Next week, I will code some examples that demo how
>> BTF-IDs can be used from BPF-progs, even as a communication channel
>> between different BPF-progs (e.g. drv XDP-prog -> cpumap XDP-prog ->
>> TC-BPF).
> 
> For my part at least, it's not a lack of understanding that makes me
> prefer the kfunc approach. Rather, it's the complexity of having to
> resolve the multiple BTF IDs, and the risk of ossifying the struct
> layouts because people are going to do that wrong. Using kfuncs gives us
> much more control of the API, especially if we combine it with struct
> randomisation for the bits we do expose.
> 
> Translating what we've discussed above into the terms used in your patch
> series, this would correspond to *only* having the xdp_metadata_common
> struct exposed via BTF, and not bothering with all the other
> driver-specific layouts. So an XDP/AF_XDP user that only wants to use
> the metadata that's also used by the stack can just call
> xdp_copy_metadata_for_skb(), and then read the resulting metadata area
> (using BTF). And if someone wants to access metadata that's *not* used
> by the stack, they'd have to call additional kfuncs to extract that.
> 

I agree, that this patchset does/will simplify my patchset.  My driver 
specific structs for BTF-IDs will no-longer be needed.  As it is now 
up-to XDP-prog to explicitly extend with fields. This should reduce your 
concern with resolving multiple BTF IDs.

Maybe after this patchset, I would suggest that we could create some 
"kernel-central" struct's that have e.g. RX-timestamp and mark (mlx5 
have HW support for mark) and protocol types (via RX-hash). As these 
could be used by XDP-prog's that explicitly extract these, and 
communicate the layout via setting the BTF-ID (via calling 
bpf_core_type_id_kernel()).  Making it easier to consume from chained 
BPF-progs, AF_XDP and even via kernel C-code that updates SKB fields as 
the number of these magic BTF-ID's will be small enough.


> And similarly, if someone wants only a subset of the metadata used by an
> SKB, they can just *not* call xdp_copy_metadata_for_skb(), and instead
> just call the individual kfuncs to extract just the fields they want.
> 
> I think this strikes a nice balance between the flexibility by the
> kernel to change things, the flexibility of XDP consumers to request
> only the data they want, and the ability for the same metadata to be
> consumed at different points. WDYT?

With above comments, I think we are closer to an agreement again.

--Jesper

