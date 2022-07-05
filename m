Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BAD5676DA
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiGESvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiGESvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 255E818E3C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 11:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657047081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YmfLpEVVGSG+pjCQN/YHVyTZmK3zwrrR8NYj3lNrRFU=;
        b=BAnc7pwvpwHlhSi9Ml7ogV9gbOsc2KfRpWYm0Jg7N57VUFTq7CR5eKcZEuHxq0lE1Oh0pe
        XT6oBBBZKjmcufqqWFvoqzFhZGSB8GMa2xbmzwbC/zHR31YuUTneTq6LHRqSyX3Xh3cJX0
        KUogwziDtkFnOpxSa1sfNtbkPx/Den8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-imSXt1KpP-OPZzbozqklXQ-1; Tue, 05 Jul 2022 14:51:20 -0400
X-MC-Unique: imSXt1KpP-OPZzbozqklXQ-1
Received: by mail-ej1-f69.google.com with SMTP id kv9-20020a17090778c900b007262b461ecdso3027912ejc.6
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 11:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YmfLpEVVGSG+pjCQN/YHVyTZmK3zwrrR8NYj3lNrRFU=;
        b=JYSOwVxg8iMMlTdj5VATtqSre6xvRk+4BXbaGAHUHrH151pca3RHvMGrCQIH5+us3B
         b4iS1Bia3IktQXx+RYlrVHfwxh0R5+TcMTO4KKR+JuFz49KiMqkvJq+TUuI0STUDlba0
         lip+qTW3CAMFgg0ZYSrBAHu5QTGWg+cCqs155BvYkBfsnR0dJazncDJ0WqmOG8ZPzrEs
         b1GsJ7lBZZp206wE/DgFBNqgGHJm83ux0lDb5jFZrldWMmvqwkrnF0Ci5tj+A1EV9jvv
         669vXeMfpdN6cv93gxpTvNNiYl0MlWmXZJ8O5x8u8y25tOCRVE0nawYwlnmxo+osP7zX
         kfkg==
X-Gm-Message-State: AJIora/Nl8fdr6EOzdIgmDt0SmvZ2JHoaICldLyqWN4/FmiyMBWsCU8E
        WgI/P8MiYcuz33hH3FJglOmHZyE/h97g5joSnD6BPkmXjRgsJp4JS5h7m5fc7csQB/aiEz8/BfF
        RjiAA7r41GSoy/XYb
X-Received: by 2002:a17:906:6a1b:b0:726:a3b8:bb5e with SMTP id qw27-20020a1709066a1b00b00726a3b8bb5emr35645044ejc.191.1657047077286;
        Tue, 05 Jul 2022 11:51:17 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tuqx03sboCWCDsIewDBylgT3nW9xMk0osOEEBGq+GyWDE3hYyiDxena0vDc5ZRbJRjG78k6A==
X-Received: by 2002:a17:906:6a1b:b0:726:a3b8:bb5e with SMTP id qw27-20020a1709066a1b00b00726a3b8bb5emr35644950ejc.191.1657047076174;
        Tue, 05 Jul 2022 11:51:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ku22-20020a170907789600b0072ae8fb13e6sm1158851ejc.126.2022.07.05.11.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 11:51:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C239B4AAD1D; Tue,  5 Jul 2022 20:51:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce
 and use Generic Hints/metadata
In-Reply-To: <20220705154120.22497-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
 <20220704154440.7567-1-alexandr.lobakin@intel.com>
 <87a69o94wz.fsf@toke.dk>
 <20220705154120.22497-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 05 Jul 2022 20:51:14 +0200
Message-ID: <87pmij75r1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

[... snipping a bit of context here ...]

>> >> Yeah, I'd agree this kind of configuration is something that can be
>> >> added later, and also it's sort of orthogonal to the consumption of the
>> >> metadata itself.
>> >> 
>> >> Also, tying this configuration into the loading of an XDP program is a
>> >> terrible interface: these are hardware configuration options, let's just
>> >> put them into ethtool or 'ip link' like any other piece of device
>> >> configuration.
>> >
>> > I don't believe it fits there, especially Ethtool. Ethtool is for
>> > hardware configuration, XDP/AF_XDP is 95% software stuff (apart from
>> > offload bits which is purely NFP's for now).
>> 
>> But XDP-hints is about consuming hardware features. When you're
>> configuring which metadata items you want, you're saying "please provide
>> me with these (hardware) features". So ethtool is an excellent place to
>> do that :)
>
> With Ethtool you configure the hardware, e.g. it won't strip VLAN
> tags if you disable rx-cvlan-stripping. With configuring metadata
> you only tell what you want to see there, don't you?

Ah, I think we may be getting closer to identifying the disconnect
between our way of thinking about this!

In my mind, there's no separate "configuration of the metadata" step.
You simply tell the hardware what features you want (say, "enable
timestamps and VLAN offload"), and the driver will then provide the
information related to these features in the metadata area
unconditionally. All XDP hints is about, then, is a way for the driver
to inform the rest of the system how that information is actually laid
out in the metadata area.

Having a separate configuration knob to tell the driver "please lay out
these particular bits of metadata this way" seems like a totally
unnecessary (and quite complicated) feature to have when we can just let
the driver decide and use CO-RE to consume it?

>> > I follow that way:
>> >
>> > 1) you pick a program you want to attach;
>> > 2) usually they are written for special needs and usecases;
>> > 3) so most likely that program will be tied with metadata/driver/etc
>> >    in some way;
>> > 4) so you want to enable Hints of a particular format primarily for
>> >    this program and usecase, same with threshold and everything
>> >    else.
>> >
>> > Pls explain how you see it, I might be wrong for sure.
>> 
>> As above: XDP hints is about giving XDP programs (and AF_XDP consumers)
>> access to metadata that is not currently available. Tying the lifetime
>> of that hardware configuration (i.e., which information to provide) to
>> the lifetime of an XDP program is not a good interface: for one thing,
>> how will it handle multiple programs? What about when XDP is not used at
>
> Multiple progs is stuff I didn't cover, but will do later (as you
> all say to me, "let's start with something simple" :)). Aaaand
> multiple XDP progs (I'm not talking about attaching progs in
> differeng modes) is not a kernel feature, rather a libpf feature,
> so I believe it should be handled there later...

Right, but even if we don't *implement* it straight away we still need
to take it into consideration in the design. And expecting libxdp to
arbitrate between different XDP programs' metadata formats sounds like a
royal PITA :)

>> all but you still want to configure the same features?
>
> What's the point of configuring metadata when there are no progs
> attached? To configure it once and not on every prog attach? I'm
> not saying I don't like it, just want to clarify.

See above: you turn on the features because you want the stack to
consume them.

> Maybe I need opinions from some more people, just to have an
> overview of how most of folks see it and would like to configure
> it. 'Cause I heard from at least one of the consumers that
> libpf API is a perfect place for Hints to him :)

Well, as a program author who wants to consume hints, you'd use
lib{bpf,xdp} APIs to do so (probably in the form of suitable CO-RE
macros)...

>> In addition, in every other case where we do dynamic data access (with
>> CO-RE) the BPF program is a consumer that modifies itself to access the
>> data provided by the kernel. I get that this is harder to achieve for
>> AF_XDP, but then let's solve that instead of making a totally
>> inconsistent interface for XDP.
>
> I also see CO-RE more fitting and convenient way to use them, but
> didn't manage to solve two things:
>
> 1) AF_XDP programs, so what to do with them? Prepare patches for
>    LLVM to make it able to do CO-RE on AF_XDP program load? Or
>    just hardcode them for particular usecases and NICs? What about
>    "general-purpose" programs?

You provide a library to read the fields. Jesper actually already
implemented this, did you look at his code?

https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interaction

It basically builds a lookup table at load-time using BTF information
from the kernel, keyed on BTF ID and field name, resolving them into
offsets. It's not quite the zero-overhead of CO-RE, but it's fairly
close and can be improved upon (CO-RE for userspace being one way of
doing that).

>    And if hardcode, what's the point then to do Generic Hints at
>    all? Then all it needs is making driver building some meta in
>    front of frames via on-off button and that's it? Why BTF ID in
>    the meta then if consumers will access meta hardcoded (via CO-RE
>    or literally hardcoded, doesn't matter)?

You're quite right, we could probably implement all the access to
existing (fixed) metadata without using any BTF at all - just define a
common struct and some flags to designate which fields are set. In my
mind, there are a couple of reasons for going the BTF route instead:

- We can leverage CO-RE to get close to optimal efficiency in field
  access.

and, more importantly:

- It's infinitely extensible. With the infrastructure in place to make
  it really easy to consume metadata described by BTF, we lower the bar
  for future innovation in hardware offloads. Both for just adding new
  fixed-function stuff to hardware, but especially for fully
  programmable hardware.

> 2) In-kernel metadata consumers? Also do CO-RE? Otherwise, with no
>    generic metadata structure they won't be able to benefit from
>    Hints. But I guess we still need to provide kernel with meta?
>    Or no?

In the short term, I think the "generic structure" approach is fine for
leveraging this in the stack. Both your and Jesper's series include
this, and I think that's totally fine. Longer term, if it turns out to
be useful to have something more dynamic for the stack consumption as
well, we could extend it to be CO-RE based as well (most likely by
having the stack load a "translator" BPF program or something along
those lines).

>> I'm as excited as you about the prospect of having totally programmable
>
> But I mostly care about current generation with no programmable
> Hints...

Well, see above; we should be able to support both :)

-Toke

