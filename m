Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18A861702E
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 23:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiKBWDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 18:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKBWDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 18:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A729BFAEE
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 15:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667426518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/h1NzS6ot6mxhOc5ExhwNiZPmbJgWWq3+JgVe9logY=;
        b=hicNuySSuUBUKGiWIZIDWOKrP4U+eH57S60XxnAZB04cRWKSWlzpWMirW/V2qmwjdHbkAi
        aSuv/Jbsak/q283ohr1x5P16AzgaCupcLV050nDUP9TemDrjNapKqhAQqybkPtTUVrqn6Q
        cjUB9xCXrF/j/I5YS2VNym5Z2+8zgCc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-90-erh9Oqy_PD-75lYIbfufHw-1; Wed, 02 Nov 2022 18:01:57 -0400
X-MC-Unique: erh9Oqy_PD-75lYIbfufHw-1
Received: by mail-ej1-f69.google.com with SMTP id nc4-20020a1709071c0400b0078a5ceb571bso146246ejc.4
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 15:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z/h1NzS6ot6mxhOc5ExhwNiZPmbJgWWq3+JgVe9logY=;
        b=GPTHSpsM8+l4YbsDuUXg2MCfjZBnSHaP+gSC3+cck+SqWGtyhmVkH3xM6tqNbNEXTA
         DHM+aH5mf8B5y8RK7zAQaEfItTacwNe6AaDGzFy6Pu46Mj6i3Y8mgwnrC6bDovGt+cF5
         DhI7KXUD4qifRFc8AM78H5CerwyQcFWYII8aXGTgY5kYuDNeZTfD0xFxzOEcGx65ITQ7
         MkyLfdrs6J0Yus4lfvQNRkzPY9akD86YSeJFAtlxKChKy/mk1RHbB5klYGVTzyS5ayuo
         3s7nZ8n9GEJtNl8DtgZO5BTI5kGji7yF9G+nMnFhZRaWS8ynBHo+bs7MBuan08SUIfv5
         Q57w==
X-Gm-Message-State: ACrzQf3DpHtbGIY9HlSVsuG/Q7LZc2UnfHM5SUskWoE4zT6RXs8iYFxU
        u7ydhjlCvmCG80stR5zlST9Fra5+kaBiJDbzKke44zD9O17KQY1+VzDA2rBdAWjl8RsCyjeIlkG
        CpspjEArHVbnTb7tT
X-Received: by 2002:a17:906:5daa:b0:78d:fa76:f837 with SMTP id n10-20020a1709065daa00b0078dfa76f837mr25616096ejv.239.1667426516357;
        Wed, 02 Nov 2022 15:01:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5qQaSZVW+9q9BfbfoYkGuRWH1DgJlzww1WKYDW6mcW7HVFa0jy0DdPEEew6v+BEtaApbBBTA==
X-Received: by 2002:a17:906:5daa:b0:78d:fa76:f837 with SMTP id n10-20020a1709065daa00b0078dfa76f837mr25616047ejv.239.1667426515912;
        Wed, 02 Nov 2022 15:01:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m23-20020a170906849700b0079e11b8e891sm5802726ejx.125.2022.11.02.15.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 15:01:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1012C74B2D2; Wed,  2 Nov 2022 23:01:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
Cc:     brouer@redhat.com,
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
In-Reply-To: <48ba6e77-1695-50b3-b27f-e82750ee70bb@redhat.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch>
 <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch>
 <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk>
 <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev>
 <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
 <0c00ba33-f37b-dfe6-7980-45920ffa273b@linux.dev>
 <48ba6e77-1695-50b3-b27f-e82750ee70bb@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Nov 2022 23:01:55 +0100
Message-ID: <87iljx2ey4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <jbrouer@redhat.com> writes:

> On 01/11/2022 18.05, Martin KaFai Lau wrote:
>> On 10/31/22 6:59 PM, Stanislav Fomichev wrote:
>>> On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau=20
>>> <martin.lau@linux.dev> wrote:
>>>>
>>>> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
>>>>>> 2. AF_XDP programs won't be able to access the metadata without=20
>>>>>> using a
>>>>>> custom XDP program that calls the kfuncs and puts the data into the
>>>>>> metadata area. We could solve this with some code in libxdp,=20
>>>>>> though; if
>>>>>> this code can be made generic enough (so it just dumps the available
>>>>>> metadata functions from the running kernel at load time), it may be
>>>>>> possible to make it generic enough that it will be forward-compatible
>>>>>> with new versions of the kernel that add new fields, which should
>>>>>> alleviate Florian's concern about keeping things in sync.
>>>>>
>>>>> Good point. I had to convert to a custom program to use the kfuncs :-(
>>>>> But your suggestion sounds good; maybe libxdp can accept some extra
>>>>> info about at which offset the user would like to place the metadata
>>>>> and the library can generate the required bytecode?
>>>>>
>>>>>> 3. It will make it harder to consume the metadata when building=20
>>>>>> SKBs. I
>>>>>> think the CPUMAP and veth use cases are also quite important, and th=
at
>>>>>> we want metadata to be available for building SKBs in this path. May=
be
>>>>>> this can be resolved by having a convenient kfunc for this that can =
be
>>>>>> used for programs doing such redirects. E.g., you could just call
>>>>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>>>>>> would recursively expand into all the kfunc calls needed to extract=
=20
>>>>>> the
>>>>>> metadata supported by the SKB path?
>>>>>
>>>>> So this xdp_copy_metadata_for_skb will create a metadata layout that
>>>>
>>>> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
>>>> Not sure where is the best point to specify this prog though.=20=20
>>>> Somehow during
>>>> bpf_xdp_redirect_map?
>>>> or this prog belongs to the target cpumap and the xdp prog=20
>>>> redirecting to this
>>>> cpumap has to write the meta layout in a way that the cpumap is=20
>>>> expecting?
>>>
>>> We're probably interested in triggering it from the places where xdp
>>> frames can eventually be converted into skbs?
>>> So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW,
>>> anything that's not XDP_DROP / AF_XDP redirect).
>>> We can probably make it magically work, and can generate
>>> kernel-digestible metadata whenever data =3D=3D data_meta, but the
>>> question - should we?
>>> (need to make sure we won't regress any existing cases that are not
>>> relying on the metadata)
>>=20
>> Instead of having some kernel-digestible meta data, how about calling=20
>> another bpf prog to initialize the skb fields from the meta area after=20
>> __xdp_build_skb_from_frame() in the cpumap, so=20
>> run_xdp_set_skb_fileds_from_metadata() may be a better name.
>>=20
>
> I very much like this idea of calling another bpf prog to initialize the
> SKB fields from the meta area. (As a reminder, data need to come from
> meta area, because at this point the hardware RX-desc is out-of-scope).
> I'm onboard with xdp_copy_metadata_for_skb() populating the meta area.
>
> We could invoke this BPF-prog inside __xdp_build_skb_from_frame().
>
> We might need a new BPF_PROG_TYPE_XDP2SKB as this new BPF-prog
> run_xdp_set_skb_fields_from_metadata() would need both xdp_buff + SKB as
> context inputs. Right?  (Not sure, if this is acceptable with the BPF
> maintainers new rules)
>
>> The xdp_prog@rx sets the meta data and then redirect.=C2=A0 If the=20
>> xdp_prog@rx can also specify a xdp prog to initialize the skb fields=20
>> from the meta area, then there is no need to have a kfunc to enforce a=20
>> kernel-digestible layout.=C2=A0 Not sure what is a good way to specify t=
his=20
>> xdp_prog though...
>
> The challenge of running this (BPF_PROG_TYPE_XDP2SKB) BPF-prog inside
> __xdp_build_skb_from_frame() is that it need to know howto decode the
> meta area for every device driver or XDP-prog populating this (as veth
> and cpumap can get redirected packets from multiple device drivers).

If we have the helper to copy the data "out of" the drivers, why do we
need a second BPF program to copy data to the SKB?

I.e., the XDP program calls xdp_copy_metadata_for_skb(); this invokes
each of the kfuncs needed for the metadata used by SKBs, all of which
get unrolled. The helper takes the output of these metadata-extracting
kfuncs and stores it "somewhere". This "somewhere" could well be the
metadata area; but in any case, since it's hidden away inside a helper
(or kfunc) from the calling XDP program's PoV, the helper can just stash
all the data in a fixed format, which __xdp_build_skb_from_frame() can
then just read statically. We could even make this format match the
field layout of struct sk_buff, so all we have to do is memcpy a
contiguous chunk of memory when building the SKB.

> Sure, using a common function/helper/macro like
> xdp_copy_metadata_for_skb() could help reduce this multiplexing, but
> we want to have maximum flexibility to extend this without having to
> update the kernel, right.

The extension mechanism is in which kfuncs are available to XDP programs
to extract metadata. The kernel then just becomes another consumer of
those kfuncs, by way of the xdp_copy_metadata_for_skb(); but there could
also be other kfuncs added that are not used for skbs (even
vendor-specific ones if we want to allow that).

-Toke

