Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D0C149BE6
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 17:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgAZQim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 11:38:42 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35968 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgAZQim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 11:38:42 -0500
Received: by mail-ot1-f65.google.com with SMTP id g15so6208425otp.3
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 08:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0F5wxLrvjSi7b6WDenK8sorowC/ysc76b5NtDO0Qo78=;
        b=I0UZctLtO2QWvDGU9j3TuVNgZQXwgCAi9BdFVwN9FhOpS/oRjz9L4Eqn/w/3w14PLr
         zKmd23hSq6wBu6KlJm+q4/VWyydF7YAvgBRegmc24p9l0KhyAcws8HXTrFrTm59Zb3gV
         GdQmEgWRZLKPRzySlv1earPMQmQE99AFvgCvG54OJljTrzjB/A5+0u/RS35y8vXsl0/g
         FPA6Tiva6oqTu0/qjYRWmzkXsuMM75VA3lN/GNydJNNj7n3MfjAEd5dY8ttYQnd0FFrE
         arQmyffqAXcj0tPZ9pAPoo2cB42fg1OkdRSfTXAwQ+xefdm0QzbHfVc/6+3m152NR7RD
         pFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0F5wxLrvjSi7b6WDenK8sorowC/ysc76b5NtDO0Qo78=;
        b=cIUI1bt5zj/RIFW1OMT7iCzDSc6h9EhufC9tau9iv4CvrX0FBM42EEIBa8U+CHUUVA
         u1R6TlicIKcizjLQ7C5yorBBJU6EkQxEs5PGHj05ZAmATJC9h1yKb4Xo8oM9DJyAGuzF
         OWWyT5pCho0kHOxDP/TM5y3Ik1fURA4NNnugA50xJDf7+PbPUmTe4Bhz6eQve10Oarej
         F9tVJbeZEIgq+aOario/EBqrVF+3h0AaClPayMF0VyBJIu9Tg+eVCLXcRmUSVFPj2d0m
         EMwYs7mx/hf5aNAJRvKBo4g/5JcAReAjf4LfuSB+9DpMWs/lvixPbibaEZRtK+zGIQPP
         6CgQ==
X-Gm-Message-State: APjAAAUAewEAKegTgm22PKmB0XK1u3JdevmcRZIqyMhfrMAlJ0p5nXOc
        n80QJRLrklUt4V5Pv9XqIy4=
X-Google-Smtp-Source: APXvYqwUnX+N4hoj5gtEWxhEwHrEdOSyuSrKCGoxuZZ7oHqH32+W7GloO3tuRbxIL4dYm5BT+AZXsQ==
X-Received: by 2002:a9d:73ca:: with SMTP id m10mr10074369otk.312.1580056721020;
        Sun, 26 Jan 2020 08:38:41 -0800 (PST)
Received: from [172.16.171.105] ([208.139.204.134])
        by smtp.googlemail.com with ESMTPSA id u33sm4519298otb.49.2020.01.26.08.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 08:38:40 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
 <20200126134933.2514b2ab@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5290f2dd-ade6-ce0f-bf01-0872d4cfe14f@gmail.com>
Date:   Sun, 26 Jan 2020 09:38:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200126134933.2514b2ab@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 5:49 AM, Jesper Dangaard Brouer wrote:
>> This has
>> been discussed before as a need (e.g, Toke's reference above), and I am
>> trying to get this initial support done.
>>
>> I very much wanted to avoid copy-paste-modify for the entire XDP API for
>> this. For the most part XDP means ebpf at the NIC driver / hardware
>> level (obviously with the exception of generic mode). The goal is
>> tempered with the need for the verifier to reject rx entries in the
>> xdp_md context. Hence the reason for use of an attach_type - existing
>> infrastructure to test and reject the accesses.
>>
>> That said, Martin's comment throws a wrench in the goal: if the existing
>> code does not enforce expected_attach_type then that option can not be
>> used in which case I guess I have to go with a new program type
>> (BPF_PROG_TYPE_XDP_EGRESS) which takes a new context (xdp_egress_md),
>> has different return codes, etc.
> 
> Taking about return codes.  Does XDP the return codes make sense for
> this EGRESS hook? (if thinking about this being egress on the real NIC).
> 
> E.g. XDP_REDIRECT would have to be supported, which is interesting, but
> also have implications (like looping packets).
> 
> E.g. what is the semantics/action of XDP_TX return code?

This has been discussed. XDP_TX in the EGRESS path could arguably be
equal to XDP_PASS.

> 
> E.g. I'm considering adding a XDP_CONGESTED return code that can cause
> backpressure towards qdisc layer.
> 
> Also think about that if this EGRESS hook uses standard prog type for
> XDP (BPF_PROG_TYPE_XDP), then we need to convert xdp_frame to xdp_buff
> (and also convert SKBs to xdp_buff).

Why? What about the patch set requires that change to be done to have
support for EGRESS path?

> 
> Are we sure that reusing the same bpf prog type is the right choice?
> 

Martin's comment about existing checking on the expected attach type is
the only reason I have seen so far to not have the same program type.

Looking at the helpers for use in XDP programs do you believe any of
those should not be allowed with EGRESS programs? Do you have any reason
to think that existing XDP capabilities should be prohibited or
different for EGRESS? As mentioned earlier the attach type can be used
to have the verifier handle small context differences (and restrict
helpers if needed).
