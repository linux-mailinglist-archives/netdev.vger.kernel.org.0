Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C09647AC9
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLIAaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiLIAaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:30:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC07C94191
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670545760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8OBtv2yIS04AYX7W/1P+gUfW6hywQvsnowxXELDSU8=;
        b=HtcitZVCwFRQxeHajAJYhU71UeHp/sJ0NexEpUGKSJ9dKjRYUSeSixRmU3uRCSBM0YtYmN
        qg/7udS5jGIhZ/YEOEzvv6lmuV/FFRZWntuGBmSdOwcN8fd+ShfhwvEi5U4mjYCpgM2eS9
        TkAYK7BEv1mTLIlMhaR0+z9efdMPPco=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-137-TZ32nos1NCOFcY8GZ27XIQ-1; Thu, 08 Dec 2022 19:29:19 -0500
X-MC-Unique: TZ32nos1NCOFcY8GZ27XIQ-1
Received: by mail-ed1-f72.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so401662edz.21
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 16:29:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U8OBtv2yIS04AYX7W/1P+gUfW6hywQvsnowxXELDSU8=;
        b=W06hDwWZ1jPI1y/uDzZvOte+6gjEt1hUReOPL2DZCrvNOgJ3XL1oOg2vpQ8JAlMDUL
         X8j16iAj7LlvEXanFfFvBscsrYBD/XqV9NeAc+KAgXOSE8LxqBkFnTtOiAUYoC7URVKt
         jSC+BKLifCLyHs5mWUbOuwd2VP5RJ7bdV3psKiHSfZmpig8FAMqARl6wKJqE4rcmVIDt
         G2pcoeY5EXS7zWBCW7kduB1o+7Qc+nqZO1dwYV4cErAtL3VZY4NZ7C8V4okEXhF/fXCk
         EbZdvne8QefB9E74SsD9RdwfE1QI71Kfi+n3pOB7nJiwytwPoxruIHvLmhNo4FZ3GM4t
         NZ+w==
X-Gm-Message-State: ANoB5plZTHpecca9Uyk+3I/kmiH3CMlSc8ss+HpDFvVm3PUAtOaC/6vN
        2dvXtZ4wfkF/Rh/B/dOkJUEs6ti2fVLdKr/mHlG0KmAh20sMLG7yYdtLGvfzsA+k1WtgXCUlAFK
        E6B5mOsEh9bLben6L
X-Received: by 2002:a17:906:b1c6:b0:78d:f455:b5d4 with SMTP id bv6-20020a170906b1c600b0078df455b5d4mr3296207ejb.20.1670545758519;
        Thu, 08 Dec 2022 16:29:18 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4CiSJlchin364iECYsvkMB+OkYb0iDARFbXm2MDItjFmcJFlFLVTWkkyiVuplDVnQSKpjTAA==
X-Received: by 2002:a17:906:b1c6:b0:78d:f455:b5d4 with SMTP id bv6-20020a170906b1c600b0078df455b5d4mr3296167ejb.20.1670545758084;
        Thu, 08 Dec 2022 16:29:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n11-20020a170906118b00b007be696512ecsm10123228eja.187.2022.12.08.16.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 16:29:17 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4C35982E9CE; Fri,  9 Dec 2022 01:29:16 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP
 metadata
In-Reply-To: <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-12-sdf@google.com> <875yellcx6.fsf@toke.dk>
 <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
 <87359pl9zy.fsf@toke.dk>
 <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Dec 2022 01:29:16 +0100
Message-ID: <87tu25ju77.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Dec 8, 2022 at 4:02 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>> > On Thu, Dec 8, 2022 at 2:59 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
>> >>
>> >> Stanislav Fomichev <sdf@google.com> writes:
>> >>
>> >> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> >
>> >> > Support RX hash and timestamp metadata kfuncs. We need to pass in t=
he cqe
>> >> > pointer to the mlx5e_skb_from* functions so it can be retrieved fro=
m the
>> >> > XDP ctx to do this.
>> >>
>> >> So I finally managed to get enough ducks in row to actually benchmark
>> >> this. With the caveat that I suddenly can't get the timestamp support=
 to
>> >> work (it was working in an earlier version, but now
>> >> timestamp_supported() just returns false). I'm not sure if this is an
>> >> issue with the enablement patch, or if I just haven't gotten the
>> >> hardware configured properly. I'll investigate some more, but figured
>> >> I'd post these results now:
>> >>
>> >> Baseline XDP_DROP:         25,678,262 pps / 38.94 ns/pkt
>> >> XDP_DROP + read metadata:  23,924,109 pps / 41.80 ns/pkt
>> >> Overhead:                   1,754,153 pps /  2.86 ns/pkt
>> >>
>> >> As per the above, this is with calling three kfuncs/pkt
>> >> (metadata_supported(), rx_hash_supported() and rx_hash()). So that's
>> >> ~0.95 ns per function call, which is a bit less, but not far off from
>> >> the ~1.2 ns that I'm used to. The tests where I accidentally called t=
he
>> >> default kfuncs cut off ~1.3 ns for one less kfunc call, so it's
>> >> definitely in that ballpark.
>> >>
>> >> I'm not doing anything with the data, just reading it into an on-stack
>> >> buffer, so this is the smallest possible delta from just getting the
>> >> data out of the driver. I did confirm that the call instructions are
>> >> still in the BPF program bytecode when it's dumped back out from the
>> >> kernel.
>> >>
>> >> -Toke
>> >>
>> >
>> > Oh, that's great, thanks for running the numbers! Will definitely
>> > reference them in v4!
>> > Presumably, we should be able to at least unroll most of the
>> > _supported callbacks if we want, they should be relatively easy; but
>> > the numbers look fine as is?
>>
>> Well, this is for one (and a half) piece of metadata. If we extrapolate
>> it adds up quickly. Say we add csum and vlan tags, say, and maybe
>> another callback to get the type of hash (l3/l4). Those would probably
>> be relevant for most packets in a fairly common setup. Extrapolating
>> from the ~1 ns/call figure, that's 8 ns/pkt, which is 20% of the
>> baseline of 39 ns.
>>
>> So in that sense I still think unrolling makes sense. At least for the
>> _supported() calls, as eating a whole function call just for that is
>> probably a bit much (which I think was also Jakub's point in a sibling
>> thread somewhere).
>
> imo the overhead is tiny enough that we can wait until
> generic 'kfunc inlining' infra is ready.
>
> We're planning to dual-compile some_kernel_file.c
> into native arch and into bpf arch.
> Then the verifier will automatically inline bpf asm
> of corresponding kfunc.

Is that "planning" or "actively working on"? Just trying to get a sense
of the time frames here, as this sounds neat, but also something that
could potentially require quite a bit of fiddling with the build system
to get to work? :)

-Toke

