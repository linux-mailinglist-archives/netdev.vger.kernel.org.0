Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA215294E
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 11:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgBEKhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 05:37:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27101 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727234AbgBEKhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 05:37:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580899072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XJMxmKv/7NFy8a5uAJ1R6xwJxnA8R5SW1BrLj1tXa2s=;
        b=MwqwDvxY6l55ws4pnp0YUDcYMyl8NBcaHKEL4mwCP5u1KsYuHeVF/1JjlG0OhJdZcL9B2g
        xh3/nQsEPhz1N8gfcHQr6y+ZoqXXUIB5z9zbCIoS863N6nb4jak4HYRzblaAM1DA1Ylb63
        TBY3FRTGbnU/bZwfxcM7Fg81cm7ivbU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-Hjk9ZnCXMwa8jhHB6LSlIw-1; Wed, 05 Feb 2020 05:37:49 -0500
X-MC-Unique: Hjk9ZnCXMwa8jhHB6LSlIw-1
Received: by mail-lj1-f198.google.com with SMTP id d14so180684ljg.17
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 02:37:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XJMxmKv/7NFy8a5uAJ1R6xwJxnA8R5SW1BrLj1tXa2s=;
        b=I5NQI6aywg2xS5iw2YK7ufUWWVOD4YlZNNxEtbKch9r9TNJAeC1DOLfBl73Xqsyw/0
         SvXBjyauptxK//nlC4ZqBG7p9OGUzQONcY3GoofCfPKH6e1CNXomWAwFA1KKoHB2kOFL
         GUvDGWgZdrnlCF8oODDbLdQkX1Nt1DUTTLrUNc4b2OrBuI6qUeXgS1JOe1ndtrj/Jy/a
         0iKkRi8RxNBd7JtPmzE+ZSeOibR4WZygTippelHZBVuvPfT3UXywJe0WPb/bjKblY7n5
         Xysz1XIg4J+1WlSYr92TP5mcuw5mBvukySiCPFMUR2rsv5hQx61kdRQPqfC1Qbfe5b94
         jfcw==
X-Gm-Message-State: APjAAAVHPRt1s5Ii1VsRdmbCY7PJfGjQlMU2ICxc2qtQZFZleK32z6vQ
        RiWSnjbUKVBAZeNTuewKMm64eQVipfpS91V+2iHmLdu10k/wultoFeXlOiJFcFaY8FEcfKMvIwE
        /pWoqvXrsPF+HstSJ
X-Received: by 2002:ac2:5c4a:: with SMTP id s10mr17114526lfp.88.1580899068299;
        Wed, 05 Feb 2020 02:37:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGQ+MAW2nIcH05LZAor6Ff7MX5If5Gs68OzCOwxTnrnXXD/DVILU2bBb6oCjmDQy+/ADH1pQ==
X-Received: by 2002:ac2:5c4a:: with SMTP id s10mr17114519lfp.88.1580899068050;
        Wed, 05 Feb 2020 02:37:48 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q24sm11977807lfm.78.2020.02.05.02.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 02:37:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 025DB1802D4; Wed,  5 Feb 2020 11:37:44 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
In-Reply-To: <d5434db9-1899-776d-c4cd-918e2418175d@gmail.com>
References: <20190820114706.18546-1-toke@redhat.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net>
 <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk>
 <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk>
 <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
 <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com>
 <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
 <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com>
 <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com>
 <87h80669o6.fsf@toke.dk>
 <CAEf4BzYGp95MKjBxNay2w=9RhFAEUCrZ8_y1pqzdG-fUyY63=w@mail.gmail.com>
 <8736bqf9dw.fsf@toke.dk>
 <CAEf4BzbNZQmDD3Ob+m6yJK2CzNb9=3F2bYfxOUyn7uOp0bhXZA@mail.gmail.com>
 <87tv46dnj6.fsf@toke.dk> <2ab65028-c200-f8f8-b57d-904cb8a7c00c@gmail.com>
 <87r1zadlpx.fsf@toke.dk> <d5434db9-1899-776d-c4cd-918e2418175d@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 05 Feb 2020 11:37:44 +0100
Message-ID: <87imkle2vb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 2/4/20 3:35 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>>> Most likely, making iproute2 use libbpf statically is going to be
>>> challenging and I am not sure it is the right thing to do (unless the
>>> user is building a static version of iproute2 commands).
>>=20
>> Linking dynamically would imply a new dependency. I'm not necessarily
>> against that, but would it be acceptable from your PoV? And if so,
>> should we keep the current internal BPF code for when libbpf is not
>> available, or would it be acceptable to not be able to load BPF programs
>> if libbpf is not present (similar to how the libelf dependency works
>> today)?
>
> iproute2 recently gained the libmnl dependency for extack. Seems like
> libbpf falls into the similar category.
>
>>=20
>>> 2. git submodules can be a PITA to deal with (e.g., jumping between
>>> branches and versions), so there needs to be a good reason for it.
>>=20
>> Yes, totally with you on that. Another option could be to just copy the
>> files into the iproute2 tree, and update them the same way the kernel
>> headers are? Or maybe doing fancy things like this:
>> https://github.com/apenwarr/git-subtrac
>
> kernel uapi is a totally different reason to import the headers. bpf
> functionality is an add-on.
>
> I would like to see iproute2 work with libbpf. Given libbpf's current
> status and availability across OS'es that is going to be a challenge for
> a lot of OS'es which is why I suggested the HAVE_LIBBPF check falls back
> to existing code if libbpf is not installed.

Sure, can do.

-Toke

