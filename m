Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770F931C285
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhBOThE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:37:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229802AbhBOThC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 14:37:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613417735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Px84X68T1yYL++hqo/VdqWtZ5Oe2mN1i1dSBWoxP2vU=;
        b=KPYXmI2eClPsdCYjL6I95k05k1OTHx60TSHOSp8gqpscVCOi8waC2AUNYZLgA/DlWX19N1
        eIINzE/X/tuts2GgEGj1EKYD23KPQbshqhOK+7I0CfHCN71YIlXE8oDFy8Ox31BYCHsjLY
        KHmXesO93mu88Bjno22Ebr6/Zvdb0L0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-n2nwj20WOKW1voqTIUK89Q-1; Mon, 15 Feb 2021 14:35:32 -0500
X-MC-Unique: n2nwj20WOKW1voqTIUK89Q-1
Received: by mail-ed1-f69.google.com with SMTP id d3so2566058edk.22
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 11:35:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Px84X68T1yYL++hqo/VdqWtZ5Oe2mN1i1dSBWoxP2vU=;
        b=C5mDqn0BD2ZIVElK+gsxpNIIKBRGbJQuqBNHhCxYNZm0PM6zFe/5Qc5/kEdHgcLJjS
         FAS2NCRd2ejCfcmi5P4pA9LZhvHJxWrlTlRjOGyJqgsiZNJV0cteDPcTiFBnuW9dAEaF
         5uxZSHsDs+VospWfn952UXKB2XzVHmyz+2YfcGjLlJU+Jnr2Pvm29tLZXnTptVB8+Quh
         PVnH6SVcI29GVIFCVPStCfJaAGFYBQcNEizjCYb/luWv3IhzavVk4h5uE6AMOCKwjNHo
         b++D5sZckTTU/5IfcKSMhwsmYHLqRQbtPZ3O0nx2hHiXWgc0p49xnh6HiahPmCm9ymOc
         Rksg==
X-Gm-Message-State: AOAM531QZemJN+NGE8Ay3q7DDqkwee/+BgYZVGDljRYdda7+45sAsDop
        2HUyXxmIUY6/rBAs0kjVaBPLU6r42lsQ5DqkvpfHTlQ8pyIqf0bQ+4Q+K+jCw++9zRlCbdaJzR0
        sKRa7nyRiY7xmZe/E
X-Received: by 2002:a05:6402:b2d:: with SMTP id bo13mr17214450edb.280.1613417730856;
        Mon, 15 Feb 2021 11:35:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5abSwRO5T8EChIyTrDeuoXq+n7TO62Zr3m7IHU3LXi5TMJU7H8pCYT1A5EtfHw0LhVbp89A==
X-Received: by 2002:a05:6402:b2d:: with SMTP id bo13mr17214437edb.280.1613417730618;
        Mon, 15 Feb 2021 11:35:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l4sm4372531edr.50.2021.02.15.11.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 11:35:30 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EE3EF1805FB; Mon, 15 Feb 2021 20:35:29 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
In-Reply-To: <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk> <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 15 Feb 2021 20:35:29 +0100
Message-ID: <875z2tcef2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-02-15 18:07, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>>=20
>>> Currently, if there are multiple xdpsock instances running on a single
>>> interface and in case one of the instances is terminated, the rest of
>>> them are left in an inoperable state due to the fact of unloaded XDP
>>> prog from interface.
>>>
>>> To address that, step away from setting bpf prog in favour of bpf_link.
>>> This means that refcounting of BPF resources will be done automatically
>>> by bpf_link itself.
>>>
>>> When setting up BPF resources during xsk socket creation, check whether
>>> bpf_link for a given ifindex already exists via set of calls to
>>> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
>>> and comparing the ifindexes from bpf_link and xsk socket.
>>=20
>> One consideration here is that bpf_link_get_fd_by_id() is a privileged
>> operation (privileged as in CAP_SYS_ADMIN), so this has the side effect
>> of making AF_XDP privileged as well. Is that the intention?
>>
>
> We're already using, e.g., bpf_map_get_fd_by_id() which has that
> as well. So we're assuming that for XDP setup already!

Ah, right, didn't realise that one is CAP_SYS_ADMIN as well; I
remembered this as being specific to the bpf_link operation.

>> Another is that the AF_XDP code is in the process of moving to libxdp
>> (see in-progress PR [0]), and this approach won't carry over as-is to
>> that model, because libxdp has to pin the bpf_link fds.
>>
>
> I was assuming there were two modes of operations for AF_XDP in libxdp.
> One which is with the multi-program support (which AFAIK is why the
> pinning is required), and one "like the current libbpf" one. For the
> latter Maciej's series would be a good fit, no?

We haven't added an explicit mode switch for now; libxdp will fall back
to regular interface attach if the kernel doesn't support the needed
features for multi-attach, but if it's possible to just have libxdp
transparently do the right thing I'd much prefer that. So we're still
exploring that (part of which is that Magnus has promised to run some
performance tests to see if there's a difference).

However, even if there's an explicit mode switch I'd like to avoid
different *semantics* between the two modes if possible, to keep the two
as compatible as possible. And since we can't currently do "auto-detach
on bpf_link fd close" when using multi-prog, introducing this now would
lead to just such a semantic difference. So my preference would be to do
it differently... :)

>> However, in libxdp we can solve the original problem in a different way,
>> and in fact I already suggested to Magnus that we should do this (see
>> [1]); so one way forward could be to address it during the merge in
>> libxdp? It should be possible to address the original issue (two
>> instances of xdpsock breaking each other when they exit), but
>> applications will still need to do an explicit unload operation before
>> exiting (i.e., the automatic detach on bpf_link fd closure will take
>> more work, and likely require extending the bpf_link kernel support)...
>>
>
> I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
> we're months ahead, then I'd really like to see this in libbpf until the
> merge. However, I'll leave that for Magnus/you to decide!

Well, as far as libxdp support goes, the PR I linked is pretty close to
being mergeable. One of the few outstanding issues is whether we should
solve just this issue before merging, actually :)

Not sure exactly which timeframe Andrii is envisioning for libbpf 1.0,
but last I heard he'll announce something next week.

> Bottom line; I'd *really* like bpf_link behavior (process scoped) for
> AF_XDP sooner than later! ;-)

Totally agree that we should solve the multi-process coexistence
problem! And as I said, I think we can do so in libxdp by using the same
synchronisation mechanism we use for setting up the multi-prog
dispatcher. So it doesn't *have* to hold things up :)

-Toke

