Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FDD62AF4D
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 00:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiKOXPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 18:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237902AbiKOXPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 18:15:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674ADE4B
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 15:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668554045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/HeSwBts+JSgnN4qNzSCdOMxQO+gGwYD3f5ouvjaYqA=;
        b=Vf7evLeftxjgjPox3HtzPEm9jo2z5PZBTrfiDBzW3oSih0/nW7n+SdECYIF68HT8bQDfmc
        JppR2wLe2ylPJxzBVxxGwWZOGlxhqa2GfpKQv+NEPr4Dw2sVZCft/K5t2WHtue2GiWcXav
        G80P6J35Cycj6x8UdiZ7s5VagHhnDs0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-197-OFdKpYnaMgalkR7o4YAkLA-1; Tue, 15 Nov 2022 18:14:04 -0500
X-MC-Unique: OFdKpYnaMgalkR7o4YAkLA-1
Received: by mail-ej1-f70.google.com with SMTP id hq18-20020a1709073f1200b007ade8dd3494so8252373ejc.2
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 15:14:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/HeSwBts+JSgnN4qNzSCdOMxQO+gGwYD3f5ouvjaYqA=;
        b=lhVOlO3nQRFxXum4co9S+gekSQIED/hQ65zD17PZFHF190hFZZJNW/6z1rj/jzs88V
         oghrTzvXnuPnyxPKICf2DCrKRg09QpZ4ST7RyQY4JXMemnrmVtBcg8dRwMwHEfRbI0cs
         Y1hYPy9YEC7VpbYB3O1N6fk3eggJAGhh23sCTk0+asdDo2kBjbADRBmHzJ6mBOfRndPu
         hmDJRib1wBsKRPOrQCyghqrPHno+D9rLtr6GUsNmVOJAjPbFPAL9mqqqcgpTNGOMWGnB
         /jAgHwym7hrJK65TwXUFu5vheIEDhwyI+B0iBi+oGlP3sqrtld/+pmQ0ppMPeuDEEgHg
         9G+Q==
X-Gm-Message-State: ANoB5pk8fwQ/pHPpu7sfr/tJNxgCe2EBaHW0DB5NxNjr/IkAoDwhMaV7
        VryXTu/rE+yLVzZTY+DcgHSq9yc4icdHbB2vgf0dHotC7sb5JW3qMbssIWFbZSiDeiSu1d4T9gj
        oKRneoxzoPj41dCHG
X-Received: by 2002:a05:6402:b50:b0:459:2b41:3922 with SMTP id bx16-20020a0564020b5000b004592b413922mr16560734edb.160.1668554042073;
        Tue, 15 Nov 2022 15:14:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7pl/gGMle47sfiL6lZ912AHH0UDHMN2Q/n0F8Q3WYCaLSOvQx4KjSEf3L5DPcBEHTJXR2z2A==
X-Received: by 2002:a05:6402:b50:b0:459:2b41:3922 with SMTP id bx16-20020a0564020b5000b004592b413922mr16560671edb.160.1668554041139;
        Tue, 15 Nov 2022 15:14:01 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y14-20020aa7ccce000000b0045b4b67156fsm6759985edt.45.2022.11.15.15.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 15:14:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7AE7E7A6D67; Wed, 16 Nov 2022 00:13:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 00/11] xdp: hints via kfuncs
In-Reply-To: <CAADnVQKs=2zJ3=3BQp=OfCre3s6zTffjKRK+kbnwpQqvxF9ygA@mail.gmail.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <87mt8si56i.fsf@toke.dk>
 <CAKH8qBszV6Ni_k8JYOxtAQ2j79qe5KVryAzDqtb1Ng8+TW=+7A@mail.gmail.com>
 <CAADnVQKs=2zJ3=3BQp=OfCre3s6zTffjKRK+kbnwpQqvxF9ygA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Nov 2022 00:13:59 +0100
Message-ID: <87zgcrdd54.fsf@toke.dk>
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

> On Tue, Nov 15, 2022 at 10:38 AM Stanislav Fomichev <sdf@google.com> wrot=
e:
>>
>> On Tue, Nov 15, 2022 at 7:54 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>> >
>> > Stanislav Fomichev <sdf@google.com> writes:
>> >
>> > > - drop __randomize_layout
>> > >
>> > >   Not sure it's possible to sanely expose it via UAPI. Because every
>> > >   .o potentially gets its own randomized layout, test_progs
>> > >   refuses to link.
>> >
>> > So this won't work if the struct is in a kernel-supplied UAPI header
>> > (which would include the __randomize_layout tag). But if it's *not* in=
 a
>> > UAPI header it should still be included in a stable form (i.e., without
>> > the randomize tag) in vmlinux.h, right? Which would be the point:
>> > consumers would be forced to read it from there and do CO-RE on it...
>>
>> So you're suggesting something like the following in the uapi header?
>>
>> #ifndef __KERNEL__
>> #define __randomize_layout
>> #endif
>>
>
> 1.
> __randomize_layout in uapi header makes no sense.

I agree, which is why I wanted it to be only in vmlinux.h...

> 2.
> It's supported by gcc plugin and afaik that plugin is broken
> vs debug info, so dwarf is broken, hence BTF is broken too,
> and CO-RE doesn't work on kernels compiled with that gcc plugin.

...however this one seems a deal breaker. Ah well, too bad, seemed like
a neat trick to enforce CO-RE :(

-Toke

