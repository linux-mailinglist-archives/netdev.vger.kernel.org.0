Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2997B1956BC
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 13:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgC0MGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 08:06:53 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52393 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbgC0MGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 08:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585310812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=niJY98Im+v+CB/6zJ9FmfYwfKSeHs73K9mFOslQzLCo=;
        b=dpIELnAVz63ohePAA3MPl9Z5F1YyVfcerKMeQSqVaTL87kbx/CEfF3VDmhN8NaIl/U/soU
        UbviktMv2BrXmEx/EMyoYpQNrHysIcZr7oB27QW4qkZlOEqCLOfV1joInZJGOew43iAMRx
        sXJ6fAHQ4KGRCeH0l62TVvEx/8bLVNM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-uey7YWJ-MtynPkNC-hoVtA-1; Fri, 27 Mar 2020 08:06:50 -0400
X-MC-Unique: uey7YWJ-MtynPkNC-hoVtA-1
Received: by mail-lf1-f72.google.com with SMTP id x22so3710403lfq.9
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 05:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=niJY98Im+v+CB/6zJ9FmfYwfKSeHs73K9mFOslQzLCo=;
        b=fM7qE6eoLhwbkXaVW3U/FOvyRV2ov4Cp2Fwuvj+CglcFC06OKwrA7OJTKH5nYYQNUe
         WDpIq0ksZ51cEZuyfvuNwgI3HXGZMBRhfUmGLHexyQ1ovl2JQyI32X1zZSh7du66g6YG
         dhJoP5mqdua7nqYFIzPRizLKHvSuXN/CiPUXOLqCBhYC4JBBOJzPNJQHfq/llccRgKAU
         GR+PnP8VLyrxxRBdcEG6NAnHmt8tlLlVk9wZ0U5DiEFXEb71Dr1RmQ4TYwmWBx0lEQBL
         KSIUBTW+Erui2fr3PotlbeY1ZlU72/gjAn6Srom5ecLWzYaV6M+GMxp+TSs8ZMXDkP++
         5YWQ==
X-Gm-Message-State: ANhLgQ0O8MLUDscv/so9cKrZV7PsEqmAnTIt2RRfHPhezWeWCLLu09C2
        2b5taSTiUlBayVVdskr32G7HuxxDCH3QSa0gqLPJ7DJB2O1A2nhCCnMIu/RSfil2R7yJUfkquzT
        khUKMbfvU9KTNDndI
X-Received: by 2002:a2e:b88b:: with SMTP id r11mr8286523ljp.116.1585310808870;
        Fri, 27 Mar 2020 05:06:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypIDALsSL5o8YMDHm5K5I/gs+G8XlttrB4MBGgtJ6qCAFs468o5dRrOi7mncvVOVKEecf33qdA==
X-Received: by 2002:a2e:b88b:: with SMTP id r11mr8286504ljp.116.1585310808614;
        Fri, 27 Mar 2020 05:06:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c23sm662517lfc.69.2020.03.27.05.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 05:06:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D3E7418158B; Fri, 27 Mar 2020 13:06:46 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
References: <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com> <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com> <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 27 Mar 2020 13:06:46 +0100
Message-ID: <87imiqm27d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Mar 26, 2020 at 01:35:13PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>>=20
>> Additionally, in the case where there is *not* a central management
>> daemon (i.e., what I'm implementing with libxdp), this would be the flow
>> implemented by the library without bpf_link:
>>=20
>> 1. Query kernel for current BPF prog loaded on $IFACE
>> 2. Sanity-check that this program is a dispatcher program installed by
>>    libxdp
>> 3. Create a new dispatcher program with whatever changes we want to do
>>    (such as adding another component program).
>> 4. Atomically replace the old program with the new one using the netlink
>>    API in this patch series.
>
> in this model what stops another application that is not using libdispatc=
her to
> nuke dispatcher program ?

Nothing. But nothing is stopping it from issuing 'ip link down' either -
an application with CAP_NET_ADMIN is implicitly trusted to be
well-behaved. This patch series is just adding the kernel primitive that
enables applications to be well-behaved. I consider it an API bug-fix.

>> Whereas with bpf_link, it would be:
>>=20
>> 1. Find the pinned bpf_link for $IFACE (e.g., load from
>>    /sys/fs/bpf/iface-links/$IFNAME).
>> 2. Query kernel for current BPF prog linked to $LINK
>> 3. Sanity-check that this program is a dispatcher program installed by
>>    libxdp
>> 4. Create a new dispatcher program with whatever changes we want to do
>>    (such as adding another component program).
>> 5. Atomically replace the old program with the new one using the
>>    LINK_UPDATE bpf() API.
>
> whereas here dispatcher program is only accessible to libdispatcher.
> Instance of bpffs needs to be known to libdispatcher only.
> That's the ownership I've been talking about.
>
> As discussed early we need a way for _human_ to nuke dispatcher program,
> but such api shouldn't be usable out of application/task.

As long as there is this kind of override in place, I'm not actually
fundamentally opposed to the concept of bpf_link for XDP, as an
additional mechanism. What I'm opposed to is using bpf_link as a reason
to block this series.

In fact, a way to implement the "human override" you mention, could be
to reuse the mechanism implemented in this series: If the EXPECTED_FD
passed via netlink is a bpf_link FD, that could be interpreted as an
override by the kernel.

-Toke

