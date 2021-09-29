Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EE741C458
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343610AbhI2MMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:12:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343547AbhI2MMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:12:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632917436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JGJx9+GEcsh8Sa0EqH93j5CL1Tgfyu1Cp7NkHrUPcaA=;
        b=MroQVX7nSsmFxgSx0tqMRDhN1lvqgyX0WOScLBmcm1Z1tOSpdyOmUX2jVLqNd0LZYH1RNb
        PIcyEK2jOOguzWnO2HuVblUXp+eaDEm6rtse5hNntB2tVEYFWnEuGgTIYpBNl4/e+1VBXk
        +xiKxm1ADC/Ky38lp0RWSEIHmp+1jeE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-SQi5S7RgOiC0APsUM3iqow-1; Wed, 29 Sep 2021 08:10:26 -0400
X-MC-Unique: SQi5S7RgOiC0APsUM3iqow-1
Received: by mail-ed1-f71.google.com with SMTP id h6-20020a50c386000000b003da01adc065so2181717edf.7
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 05:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JGJx9+GEcsh8Sa0EqH93j5CL1Tgfyu1Cp7NkHrUPcaA=;
        b=A0dDQtkjx1XkV54yoQyTIFJBvUU8MrCfZT3Cr5IN5bJMLogFEG8nQPZ6GIQL4mNZaq
         5d9iPWV3BdpRZyehgd5K3zO4/xsJfdywFyR9BsP2D+RcyoDPDPI2UARfXHYHhxM8vcYp
         zS2EXZZyJ82iiATyqXDudUgsfMr0e9409ZXvTcgDKNGcu5lEcl93ICC2bXdwZOLD9A2d
         ppjGOaHRQaMMAtiS2MIdhiKrGKmUyzSBExOJtvejPjWkj4OUr2IL6XZq6pfOBD66qZQx
         sfKpWSvlhzU1R3C24cM3sMReZNjx3W0e5ejoht6Lp2EeLnjZlkAN8aarDUaJ/i4YMOox
         alTQ==
X-Gm-Message-State: AOAM530K1REYnjNHtw1I7amJrvRAGL6NFUfaQcBXlQ1EMM2EM9v7xaKI
        dE/F0Ny5HyCEXMELGMyWiyncYw5NnrVgHfzweEOxdqp5AGU176U/yc0dfncIMTPVVb1O8SBatav
        XI1LoNDG1uAZQms0U
X-Received: by 2002:a17:907:2cf6:: with SMTP id hz22mr5322761ejc.134.1632917424099;
        Wed, 29 Sep 2021 05:10:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPpDqTSeWGsUWByRJQs1K9NQSC40m5aQgUPc34G0IljFHUpy9DJBBHPPjCVfl2Bz6Lzwxc9g==
X-Received: by 2002:a17:907:2cf6:: with SMTP id hz22mr5322550ejc.134.1632917421987;
        Wed, 29 Sep 2021 05:10:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o3sm1305946eji.108.2021.09.29.05.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 05:10:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7E9B218034F; Wed, 29 Sep 2021 14:10:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
In-Reply-To: <CACAyw9-8t8RpJgJUTd7u6bOLnJ1xQsgK7z37QrL9T1FUaJ7WNQ@mail.gmail.com>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACAyw9-8t8RpJgJUTd7u6bOLnJ1xQsgK7z37QrL9T1FUaJ7WNQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 29 Sep 2021 14:10:20 +0200
Message-ID: <87v92jinv7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer <lmb@cloudflare.com> writes:

> On Thu, 16 Sept 2021 at 18:47, Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> Won't applications end up building something like skb_header_pointer()
>> based on bpf_xdp_adjust_data(), anyway? In which case why don't we
>> provide them what they need?
>>
>> say:
>>
>> void *xdp_mb_pointer(struct xdp_buff *xdp_md, u32 flags,
>>                      u32 offset, u32 len, void *stack_buf)
>>
>> flags and offset can be squashed into one u64 as needed. Helper returns
>> pointer to packet data, either real one or stack_buf. Verifier has to
>> be taught that the return value is NULL or a pointer which is safe with
>> offsets up to @len.
>>
>> If the reason for access is write we'd also need:
>>
>> void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags,
>>                            u32 offset, u32 len, void *stack_buf)
>
> Yes! This would be so much better than bpf_skb_load/store_bytes(),
> especially if we can use it for both XDP and skb contexts as stated
> elsewhere in this thread.

Alright. Let's see if we can go this route, then :)

-Toke

