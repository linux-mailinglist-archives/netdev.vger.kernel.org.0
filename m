Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA61D9A6D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgESOxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:53:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23515 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728832AbgESOxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589899984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4KHqZxzkduLRLgwTYKbRBHAxvGCJMcXVpbPZ897Wegw=;
        b=dcJUJkkHHHnkeXv0sB1oaHESUgH1xcj4nId+wS9laylzKSpgOJoxVsAcE5A4WonjZ34ojN
        GjfsjFtnpljUN+OChc2gPJkGKv8F2vb9Tu2ZnLq4MMnUaS0PQhH3SsM67kgkxrI1gevUMg
        HkGEu8ZLz0rMTPc8Lb1CaRDPbHWFkrw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-5kIdky74PcWJ8pb-OhOZUA-1; Tue, 19 May 2020 10:53:03 -0400
X-MC-Unique: 5kIdky74PcWJ8pb-OhOZUA-1
Received: by mail-lf1-f72.google.com with SMTP id t11so5367624lfe.3
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 07:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4KHqZxzkduLRLgwTYKbRBHAxvGCJMcXVpbPZ897Wegw=;
        b=hQ+gNvFY5UkuKFFtQtVoXXjfjtklzJiB4tr1sP4yz6E0Zx9O/mhBEdXdurKyFuFZ46
         TahBokNVL7tW0/3SU9LKxv+rfaX1q2IASXgDcanizjIIUJASAPAnc/ALV0U4SkIhdype
         P3xmT9bNY/wcXYJ7hQ//dT6V/aLz/j7pFhqE3LOFuMxxQQ8a0zhxkFio4YWByIY+fBut
         PP0J7QapEj6xmYac7rbC6b9AZWKtOgE9r5s5l5l6B2KxnUqH+dy9g1EFcaROldAsn+Ft
         SEGmJUDANziATic/IMjQdz1NwDs55ztXwVUd3aiqu/qaaCL9VjSIR9LjR1yiWMQFhD+H
         pkEg==
X-Gm-Message-State: AOAM532P8AxOu+KMB4FsJP7mMEAvovu58AyAKHzlqP2krgJEpuc2Ha2n
        GB/HjtmV/holEdrV5XLJyRBhDQiRcoa36iJ/3v7IHpJlQ1YNMR1s00NYfL4usLfVFvok/vqwxco
        JcF4mKj8gRTWF0gn1
X-Received: by 2002:a2e:9a52:: with SMTP id k18mr9680879ljj.112.1589899965778;
        Tue, 19 May 2020 07:52:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNjcm1l6CsewLAUxWRbAPYLc9pw4cShBWH2+GDvuLUA1OSDTjNRC2YbyPqJFnSVjt+D7CLMw==
X-Received: by 2002:a2e:9a52:: with SMTP id k18mr9680858ljj.112.1589899965537;
        Tue, 19 May 2020 07:52:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j9sm9679309lfe.24.2020.05.19.07.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 07:52:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E9447181510; Tue, 19 May 2020 16:52:42 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
In-Reply-To: <d705cf50-b5b3-8778-16fe-3a29b9eb1e85@iogearbox.net>
References: <20200513014607.40418-1-dsahern@kernel.org> <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com> <87lflppq38.fsf@toke.dk> <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com> <87h7wdnmwi.fsf@toke.dk> <dcdfe5ab-138f-bf10-4c69-9dee1c863cb8@iogearbox.net> <3d599bee-4fae-821d-b0df-5c162e81dd01@gmail.com> <d705cf50-b5b3-8778-16fe-3a29b9eb1e85@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 19 May 2020 16:52:42 +0200
Message-ID: <87lflom0xx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 5/19/20 2:02 AM, David Ahern wrote:
>> On 5/18/20 3:06 PM, Daniel Borkmann wrote:
>>> So given we neither call this hook on the skb path, nor XDP_TX nor
>>> AF_XDP's TX
>>> path, I was wondering also wrt the discussion with John if it makes
>>> sense to
>>> make this hook a property of the devmap _itself_, for example, to have a
>>> default
>>> BPF prog upon devmap creation or a dev-specific override that is passed
>>> on map
>>> update along with the dev. At least this would make it very clear where
>>> this is
>>> logically tied to and triggered from, and if needed (?) would provide
>>> potentially
>>> more flexibility on specifiying BPF progs to be called while also
>>> solving your
>>> use-case.
>> 
>> You lost me on the 'property of the devmap.' The programs need to be per
>> netdevice, and devmap is an array of devices. Can you elaborate?
>
> I meant that the dev{map,hash} would get extended in a way where the
> __dev_map_update_elem() receives an (ifindex, BPF prog fd) tuple from
> user space and holds the program's ref as long as it is in the map slot.
> Then, upon redirect to the given device in the devmap, we'd execute the
> prog as well in order to also allow for XDP_DROP policy in there. Upon
> map update when we drop the dev from the map slot, we also release the
> reference to the associated BPF prog. What I mean to say wrt 'property
> of the devmap' is that this program is _only_ used in combination with
> redirection to devmap, so given we are not solving all the other egress
> cases for reasons mentioned, it would make sense to tie it logically to
> the devmap which would also make it clear from a user perspective _when_
> the prog is expected to run.

I would be totally on board with this. Also makes sense for the
multicast map type, if you want to fix up the packet after the redirect,
just stick the fixer-upper program into the map along with the ifindex.

-Toke

