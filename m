Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DB25FACCA
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 08:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJKG3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 02:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJKG3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 02:29:17 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324457DF51;
        Mon, 10 Oct 2022 23:29:16 -0700 (PDT)
Message-ID: <c8a712d8-dc97-8df5-6421-a5ccb1357b67@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665469754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zUi8fTh0XUn9xbcYsioWxqspfv8zn7O04vzgZgzRS88=;
        b=UA8C3ojhTfDtRVyRXWhwFANJ6RsYjfkchO9bvG1nWJCiIYr86Ho9V/ZuMLtTVbJjY7mHXv
        MvsWPErArT42abXWlz8626f4RGlC4oXeLSNE3mGx64oBETuLJl6OC7vEsL7g/KjvLbnj/u
        aHCh6xyp7F6DizbieEETHyMIZLZHJYo=
Date:   Mon, 10 Oct 2022 23:29:07 -0700
MIME-Version: 1.0
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     brouer@redhat.com, Stanislav Fomichev <sdf@google.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
 <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
 <20221004175952.6e4aade7@kernel.org>
 <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
 <20221004182451.6804b8ca@kernel.org>
 <CAKH8qBtTPNULZDLd2n1r2o7XZwvs_q5OkNqhdq0A+b5zkHRNMw@mail.gmail.com>
 <e29082a8-bbd5-6ee3-34bf-c16d0f6ed45a@linux.dev>
 <CAJ8uoz2ng=wv=dWQqxomQX4h11QsYq=scU++MSJ3Q0PMQWuzWQ@mail.gmail.com>
 <cc7e4a27-93ab-e9de-55e0-10029948d738@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <cc7e4a27-93ab-e9de-55e0-10029948d738@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/22 8:29 AM, Jesper Dangaard Brouer wrote:
> 
> On 06/10/2022 11.14, Magnus Karlsson wrote:
>> On Wed, Oct 5, 2022 at 9:27 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>
>>> On 10/4/22 7:15 PM, Stanislav Fomichev wrote:
>>>> On Tue, Oct 4, 2022 at 6:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>>
>>>>> On Tue, 4 Oct 2022 18:02:56 -0700 Stanislav Fomichev wrote:
>>>>>> +1, sounds like a good alternative (got your reply while typing)
>>>>>> I'm not too versed in the rx_desc/rx_queue area, but seems like worst
>>>>>> case that bpf_xdp_get_hwtstamp can probably receive a xdp_md ctx and
>>>>>> parse it out from the pre-populated metadata?
>>>>>
>>>>> I'd think so, worst case the driver can put xdp_md into a struct
>>>>> and container_of() to get to its own stack with whatever fields
>>>>> it needs.
>>>>
>>>> Ack, seems like something worth exploring then.
>>>>
>>>> The only issue I see with that is that we'd probably have to extend
>>>> the loading api to pass target xdp device so we can pre-generate
>>>> per-device bytecode for those kfuncs?
>>>
>>> There is an existing attr->prog_ifindex for dev offload purpose.  May be we can
>>> re-purpose/re-use some of the offload API.  How this kfunc can be presented also
>>> needs some thoughts, could be a new ndo_xxx.... not sure.
>>>> And this potentially will block attaching the same program
>>>   > to different drivers/devices?
>>>> Or, Martin, did you maybe have something better in mind?
>>>
>>> If the kfunc/helper is inline, then it will have to be per device.  Unless the
>>> bpf prog chooses not to inline which could be an option but I am also not sure
>>> how often the user wants to 'attach' a loaded xdp prog to a different device.
>>> To some extend, the CO-RE hints-loading-code will have to be per device also, 
>>> no?
>>>
>>> Why I asked the kfunc/helper approach is because, from the set, it seems the
>>> hints has already been available at the driver.  The specific knowledge that the
>>> xdp prog missing is how to get the hints from the rx_desc/rx_queue.  The
>>> straight forward way to me is to make them (rx_desc/rx_queue) available to xdp
>>> prog and have kfunc/helper to extract the hints from them only if the xdp prog
>>> needs it.  The xdp prog can selectively get what hints it needs and then
>>> optionally store them into the meta area in any layout.
>>
>> This sounds like a really good idea to me, well worth exploring. To
>> only have to pay, performance wise, for the metadata you actually use
>> is very important. I did some experiments [1] on the previous patch
>> set of Jesper's and there is substantial overhead added for each
>> metadata enabled (and fetched from the NIC). This is especially
>> important for AF_XDP in zero-copy mode where most packets are directed
>> to user-space (if not, you should be using the regular driver that is
>> optimized for passing packets to the stack or redirecting to other
>> devices). In this case, the user knows exactly what metadata it wants
>> and where in the metadata area it should be located in order to offer
>> the best performance for the application in question. But as you say,
>> your suggestion could potentially offer a good performance upside to
>> the regular XDP path too.

Yeah, since we are on this flexible hint layout, after reading the replies in 
other threads, now I am also not sure why we need a xdp_hints_common and 
probably I am missing something also.  It seems to be most useful in 
__xdp_build_skb_from_frame.  However, the xdp prog can also fill in the 
xdp_hints_common by itself only when needed instead of having the driver always 
filling it in.

> 
> Okay, lets revisit this again.  And let me explain why I believe this
> isn't going to fly.
> 
> I was also my initial though, lets just give XDP BPF-prog direct access
> to the NIC rx_descriptor, or another BPF-prog populate XDP-hints prior
> to calling XDP-prog.  Going down this path (previously) I learned three
> things:
> 
> (1) Understanding/decoding rx_descriptor requires access to the
> programmers datasheet, because it is very compacted and the mean of the
> bits depend on other bits and plus current configuration status of the HW.
> 
> (2) HW have bugs and for certain chip revisions driver will skip some
> offload hints.  Thus, chip revisions need to be exported to BPF-progs
> and handled appropriately.
> 
> (3) Sometimes the info is actually not available in the rx_descriptor.
> Often for HW timestamps, the timestamp need to be read from a HW
> register.  How do we expose this to the BPF-prog?

hmm.... may be I am missing those hw specific details here.  How would the 
driver handle the above cases and fill in the xdp_hints in the meta?  Can the 
same code be called by the xdp prog?

> 
>> [1] 
>> https://lore.kernel.org/bpf/CAJ8uoz1XVqVCpkKo18qbkh6jq_Lejk24OwEWCB9cWhokYLEBDQ@mail.gmail.com/
> 
> 
> Notice that this patchset doesn't block this idea, as it is orthogonal.
> After we have established a way to express xdp_hints layouts via BTF,
> then we can still add a pre-XDP BPF-prog that populates the XDP-hints,
> and squeeze out more performance by skipping some of the offloads that
> your-specific-XDP-prog are not interested in.
> 
> --Jesper
> 

