Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DD66483EC
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiLIOjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiLIOip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:38:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902771B1F4
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 06:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670596670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kU+z23dnqt2NuNhcLN5cEmJinJB43iazq7wqR0qgf8g=;
        b=CKT7O57etUp+12M2DU5I3jwN06Z4vtCIOU85MI1OG7s4l7R2xRadsIPovoEKK0hklgzt5E
        8XGj2GCKS6o++nrVWXP+4DxzeoKpiMeXjZnQuCcj4dVw4iq9fRZpngHAjvFiKzlqdjsPiy
        b0CPzJ7s2zfe0gUFUY/WEbLeoA0Q4vM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-549-r71dp5l4NFy4Y2P1IOdZwQ-1; Fri, 09 Dec 2022 09:37:49 -0500
X-MC-Unique: r71dp5l4NFy4Y2P1IOdZwQ-1
Received: by mail-ed1-f72.google.com with SMTP id z4-20020a05640240c400b0046c51875c17so1496566edb.1
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 06:37:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kU+z23dnqt2NuNhcLN5cEmJinJB43iazq7wqR0qgf8g=;
        b=SmTfek9Jo5cByvSP4z8RqR9gn40qZSddaMxMffRLJH7pUMwDBaijK2Nwoj1Zdm4L8o
         5aYhg2rENsIh1Q4uBZRajhli6nX1ngoTYBY5SiPkwaG4A0FwnSspD88sCwV/q9dYOR6c
         qL9SApsc88jAFvOB/6vOcb5zv5QRy0AlkXaXQn2kMZuB68OGCFTgfSWf+2sHDuMIsIap
         pPJXj++aYJgMNMpSsgZbUxGP5ifnKriziES+EfYbIUQqvyBM9yF2cI3NL5H3e1xgyrC1
         A/eb+xCHNJiXVWTCil9stKCEMZsX7YMDWGylpj3QG5s5Zthj8winS9SPd8Dt+ejJwGdj
         9GUA==
X-Gm-Message-State: ANoB5pl+iXbPpcwHEaK6qI4eauUyL7cyBNYwrsgj74YydzUPTI7TEWDa
        U+Zp/JWpZ6XuYQM+Ufm5rZMXIdU6SyqMlq4R8mMwe2to622/fmy8o0Y8B/bS7STVR1SzCi9iTCR
        QCJl3hiLMWCbFm6K4
X-Received: by 2002:a17:907:b607:b0:7ae:f042:de0a with SMTP id vl7-20020a170907b60700b007aef042de0amr5623168ejc.48.1670596667623;
        Fri, 09 Dec 2022 06:37:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Gymtho0UD4hvufqXRvIZHEVz0hyXMmhci5jsiyXEsDmdMOjQPWfEeLfqcovjq4coVOyjB4A==
X-Received: by 2002:a17:907:b607:b0:7ae:f042:de0a with SMTP id vl7-20020a170907b60700b007aef042de0amr5623025ejc.48.1670596665435;
        Fri, 09 Dec 2022 06:37:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p13-20020a17090653cd00b007b27fc3a1ffsm610673ejo.121.2022.12.09.06.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 06:37:35 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2CA4C82EB3A; Fri,  9 Dec 2022 15:37:34 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Cc:     brouer@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP
 metadata
In-Reply-To: <66fa1861-30dd-6d00-ed14-0cf4a6b39f3c@redhat.com>
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-12-sdf@google.com> <875yellcx6.fsf@toke.dk>
 <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
 <87359pl9zy.fsf@toke.dk>
 <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
 <87tu25ju77.fsf@toke.dk>
 <CAADnVQ+MyE280Q-7iw2Y-P6qGs4xcDML-tUrXEv_EQTmeESVaQ@mail.gmail.com>
 <87o7sdjt20.fsf@toke.dk>
 <CAKH8qBswBu7QAWySWOYK4X41mwpdBj0z=6A9WBHjVYQFq9Pzjw@mail.gmail.com>
 <Y5LGlgpxpzSu701h@x130> <66fa1861-30dd-6d00-ed14-0cf4a6b39f3c@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Dec 2022 15:37:34 +0100
Message-ID: <87fsdok5ht.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <jbrouer@redhat.com> writes:

>> hash/timestap/csum is per packet .. vlan as well depending how you look at
>> it..
>
> True, we cannot cache this as it is *per packet* info.
>
>> Sorry I haven't been following the progress of xdp meta data, but why did
>> we drop the idea of btf and driver copying metdata in front of the xdp
>> frame ?
>> 
>
> It took me some time to understand this new approach, and why it makes
> sense.  This is my understanding of the design direction change:
>
> This approach gives more control to the XDP BPF-prog to pick and choose
> which XDP hints are relevant for the specific use-case.  BPF-prog can
> also skip storing hints anywhere and just read+react on value (that e.g.
> comes from RX-desc).
>
> For the use-cases redirect, AF_XDP, chained BPF-progs, XDP-to-TC,
> SKB-creation, we *do* need to store hints somewhere, as RX-desc will be
> out-of-scope.  I this patchset hand-waves and says BPF-prog can just
> manually store this in a prog custom layout in metadata area.  I'm not
> super happy with ignoring/hand-waving all these use-case, but I
> hope/think we later can extend this some more structure to support these
> use-cases better (with this patchset as a foundation).

I don't think this approach "hand-waves" the need to store the metadata,
it just declares it out of scope :)

Which makes sense, because "accessing the metadata" and "storing it for
later use" are two different problems, where the second one build on top
of the first one. I.e., once we have a way to access the data, we can
build upon that to have a way to store it somewhere.

> I actually like this kfunc design, because the BPF-prog's get an
> intuitive API, and on driver side we can hide the details of howto
> extract the HW hints.

+1

>> hopefully future HW generations will do that for free ..
>
> True.  I think it is worth repeating, that the approach of storing HW
> hints in metadata area (in-front of packet data) was to allow future HW
> generations to write this.  Thus, eliminating the 6 ns (that I showed it
> cost), and then it would be up-to XDP BPF-prog to pick and choose which
> to read, like this patchset already offers.
>
> This patchset isn't incompatible with future HW generations doing this,
> as the kfunc would hide the details and point to this area instead of
> the RX-desc.  While we get the "store for free" from hardware, I do
> worry that reading this memory area (which will part of DMA area) is
> going to be slower than reading from RX-desc.

Agreed (choked on the "isn't incompatible" double negative at first). If
the hardware stores the data next to the packet data, the kfuncs can
just read them from there. If it turns out that we can even make the
layout for some fields the same across drivers, we could even have the
generic kfunc implementations just read this area (which also nicely
solves the "storage" problem).

-Toke

