Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522054D94DB
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345291AbiCOGv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345293AbiCOGv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:51:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2A204AE00
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647327014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uh3vrxxjU8Hin/U1XQleQsSYmlCl6J+ScBFFwizKeBI=;
        b=LQYXR3Ryv7rXH5uDN5Eyx0mTOHBOn8nOrmiS2Zt7cZvpDrD7sJokUy+VrLoQwPzdtlWe7Z
        EVY0L8kCoRID1w7a3qi9Z13Z0rBHRtv/OsAFN9U7PE0n/oc+fUA0dEjxvcybtCkzAVEWvj
        Yss0ueGO37VtlTtn7XHCBIjKvD7KhGY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-FAK8O9kKP1mGy6-WgLoKQg-1; Tue, 15 Mar 2022 02:50:12 -0400
X-MC-Unique: FAK8O9kKP1mGy6-WgLoKQg-1
Received: by mail-ed1-f72.google.com with SMTP id o20-20020aa7dd54000000b00413bc19ad08so10039864edw.7
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=uh3vrxxjU8Hin/U1XQleQsSYmlCl6J+ScBFFwizKeBI=;
        b=HNPMwPbj3fsfg+1fruQANtvbBRz4WvBe+oS4IXV+fssyFOCNtElm8dnoz6Pgo5c9Na
         R0Af6C5OvcfNnHPTRk69qsMl4bi3QKhFpgGl3CZ/C0Du1fuT0doZ8OmztKXQNlX85AVT
         MAd9b4L4+Mxcxkrvne3xj2TOW0ayxGBhUn7rKj7Oo1aN75l9XymbnSSDnnFxxG73QtwX
         ncmWbCx5mx6l79p13f5dKIV0t8kO9NHeYvtQNdWpLv8QAWx9kbzC9qJMBvs9wM/9boUV
         HkEIH2wKz8oH3SiBjEBZGFaVLbo12vGtnKacEuKjax5mrt0kUK8SNoL109871l0fkzPq
         /FLQ==
X-Gm-Message-State: AOAM532eK9V9jCh14KqQONcefYBczFmbL2dVTe3YSIss7QLbg7NrbNyD
        +CQtJhq8EWr2mgnB1oodIz3Z71qpHz0w3F8LPF6nm6Ggnpcfpi/piN0suiy7TRNWM8hCOxFpJT3
        knROsvoAOsR50haqZ
X-Received: by 2002:a17:906:58d3:b0:6da:bdb2:2727 with SMTP id e19-20020a17090658d300b006dabdb22727mr21412954ejs.549.1647327011177;
        Mon, 14 Mar 2022 23:50:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZ8DQk++KAezgy5tVvXRVReOVWKTNzLZiIMXrfaxJ8iI9z0hLMF1+7bVf6l80Sk9TO0KmxKw==
X-Received: by 2002:a17:906:58d3:b0:6da:bdb2:2727 with SMTP id e19-20020a17090658d300b006dabdb22727mr21412926ejs.549.1647327010886;
        Mon, 14 Mar 2022 23:50:10 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id g11-20020a170906538b00b006ae38eb0561sm7804504ejo.195.2022.03.14.23.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 23:50:10 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <86673054-9fbd-c4db-7a4b-0fe904a2ca7f@redhat.com>
Date:   Tue, 15 Mar 2022 07:50:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: xdp: allow user space to request a smaller packet
 headroom requirement
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Jesper D. Brouer" <netdev@brouer.com>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20220314102210.92329-1-nbd@nbd.name>
 <86137924-b3cb-3d96-51b1-19923252f092@brouer.com>
 <4ff44a95-2818-32d9-c907-20e84f24a3e6@nbd.name> <87pmmouqmt.fsf@toke.dk>
 <a61aef96-5364-e5a5-3827-e84da0c11218@iogearbox.net>
 <97489448-ab5a-8831-e6a2-c9f909824ad1@nbd.name>
In-Reply-To: <97489448-ab5a-8831-e6a2-c9f909824ad1@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2022 23.43, Felix Fietkau wrote:
> 
> On 14.03.22 23:20, Daniel Borkmann wrote:
>> On 3/14/22 11:16 PM, Toke Høiland-Jørgensen wrote:
>>> Felix Fietkau <nbd@nbd.name> writes:
>>>> On 14.03.22 21:39, Jesper D. Brouer wrote:
>>>>> (Cc. BPF list and other XDP maintainers)
>>>>> On 14/03/2022 11.22, Felix Fietkau wrote:
>>>>>> Most ethernet drivers allocate a packet headroom of NET_SKB_PAD. 
>>>>>> Since it is
>>>>>> rounded up to L1 cache size, it ends up being at least 64 bytes on 
>>>>>> the most
>>>>>> common platforms.
>>>>>> On most ethernet drivers, having a guaranteed headroom of 256 
>>>>>> bytes for XDP
>>>>>> adds an extra forced pskb_expand_head call when enabling SKB XDP, 
>>>>>> which can
>>>>>> be quite expensive.
>>>>>> Many XDP programs need only very little headroom, so it can be 
>>>>>> beneficial
>>>>>> to have a way to opt-out of the 256 bytes headroom requirement.
>>>>>
>>>>> IMHO 64 bytes is too small.
>>>>> We are using this area for struct xdp_frame and also for metadata
>>>>> (XDP-hints).  This will limit us from growing this structures for
>>>>> the sake of generic-XDP.
>>>>>
>>>>> I'm fine with reducting this to 192 bytes, as most Intel drivers
>>>>> have this headroom, and have defacto established that this is
>>>>> a valid XDP headroom, even for native-XDP.
>>>>>
>>>>> We could go a small as two cachelines 128 bytes, as if xdp_frame
>>>>> and metadata grows above a cache-line (64 bytes) each, then we have
>>>>> done something wrong (performance wise).
 >>>>
>>>> Here's some background on why I chose 64 bytes: I'm currently
>>>> implementing a userspace + xdp program to act as generic fastpath to
>>>> speed network bridging.

Cc. Lorenzo as you mention you wanted to accelerate Linux bridging.
We can avoid a lot of external FIB sync in userspace, if we
add some BPF-helpers to lookup in bridge FIB table.

>>>
>>> Any reason this can't run in the TC ingress hook instead? Generic XDP is
>>> a bit of an odd duck, and I'm not a huge fan of special-casing it this
>>> way...
>>
>> +1, would have been fine with generic reduction to just down to 192 bytes
>> (though not less than that), but 64 is a bit too little. 

+1

>> Also curious on why not tc ingress instead?
 >
> I chose XDP because of bpf_redirect_map, which doesn't seem to be 
> available to tc ingress classifier programs.

TC have a "normal" bpf_redirect which is slower than a bpf_redirect_map.
The secret to the performance boost from bpf_redirect_map is the hidden
TX bulking layer.  I have experimented with TC bulking, which showed a
30% performance boost on TC redirect to TX with fixed 32 frame bulking.

Notice that newer libbpf makes it easier to attach to the TC hook
without shell'ing out to 'tc' binary. See how to use in this example:
 
https://github.com/xdp-project/bpf-examples/blob/master/tc-policy/tc_txq_policy.c


> When I started writing the code, I didn't know that generic XDP 
> performance would be bad on pretty much any ethernet/WLAN driver that 
> wasn't updated to support it.

Yes, we kind of kept generic-XDP non-optimized as the real tool for
the  job is TC-BPF, given at this stage the SKB have already been 
allocate, and converting it back to a XDP representation is not
going to be faster that TC-BPF.

Maybe we should optimize generic-XDP a bit more, because I'm
buying the argument, that developers want to write one BPF program
that works across device drivers, instead of having to handle
both TC-BPF and XDP-BPF.

Notice that generic-XDP doesn't actually do the bulking step, even
though using bpf_redirect_map. (would be obvious optimization).

If we extend kernel/bpf.devmap.c with bulking for SKBs, then both
TC-BPF and generic-XDP could share that code path, and obtain
the TX bulking performance boost via SKB-list + xmit_more.


--Jesper

