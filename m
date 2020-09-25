Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175CA2792C8
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgIYU5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:57:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbgIYU5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:57:17 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601067436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EiL2XllvQB2LfKSShysemCAoHS0xuIwlKbztT1dTxBk=;
        b=ZfJ+igNU1ISS1PR+pSjRI5eCs+3PxzoHvKC7aTPzHOsJxuLLqNTyfLUTFIo6W9HJK9qm8v
        Yq3tnuoI0YTtvjf8NZRF/7qlRqupIouzgzb3eh5KR43iExHlw2Cp4H4n2+zM2jOHU8LEMA
        oRzAIzF9/yeIFIUnOteJ+KC8OwcD2VQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-3QK2u0BpPdag9YrkqGp1jw-1; Fri, 25 Sep 2020 16:57:14 -0400
X-MC-Unique: 3QK2u0BpPdag9YrkqGp1jw-1
Received: by mail-wm1-f71.google.com with SMTP id w3so97188wmg.4
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 13:57:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=EiL2XllvQB2LfKSShysemCAoHS0xuIwlKbztT1dTxBk=;
        b=bjR5CPflsz6oaxTXrg/irdbBw0tc0C9BjhvsjxYQmvygJBkPioh7xe08lgF5PxrsPW
         RJBjj+hC/WEIJ9d2RRVbcNkrF4MvYVexaoOd58I8VD06/aO4Ynnzz61Y6YQKFtAOcO5o
         cO/C9YWQKHPuhwqpfOY/ukcRSr7OIKhYJN4b4A/vOwuuSF1ORN5vjs5kHozaJ6wMubDn
         Wv61pCcBWprAy4LhNT2V0oVJpyqVJC0KvezoVDZBbxzMEktAPtV3Bw90ZQbLSiCeMCdK
         WTHCRItMc6hk2WgHiunmr1oHFNe8GH1fnM8kezNTYzaCpeRY3wRniwbwVsq1avn2Ftoz
         v+hg==
X-Gm-Message-State: AOAM530RGmq5r2K24ouUJb7Xy+Pualf/NQC4BaSZFQKoIhyint61h6uo
        yMuyQqvfWtpx15z3/5THerUUgzQllblI22pPcQ+rv+h3KqQo1FRZwD8HGom1KdpP8JiKXujPWWw
        vd9obQazaWTqOVmv2
X-Received: by 2002:adf:dbc3:: with SMTP id e3mr6376744wrj.1.1601067433547;
        Fri, 25 Sep 2020 13:57:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZfFA8ey5Qyk+yQKrYbWllg18SZYqXB51nWXG9iuDFjMRWMmI/xMmHWanoHvg+YD5hac8VxA==
X-Received: by 2002:adf:dbc3:: with SMTP id e3mr6376726wrj.1.1601067433293;
        Fri, 25 Sep 2020 13:57:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 92sm4524389wra.19.2020.09.25.13.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 13:57:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2E8FC183C5B; Fri, 25 Sep 2020 22:57:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
In-Reply-To: <CAADnVQLMBKAYsbS4PO87yVrPWJEf9H3qzpsL-p+gFQpcomDw2w@mail.gmail.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk>
 <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
 <87tuvmbztw.fsf@toke.dk>
 <CAADnVQLMBKAYsbS4PO87yVrPWJEf9H3qzpsL-p+gFQpcomDw2w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 25 Sep 2020 22:57:12 +0200
Message-ID: <878scx60d3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Sep 24, 2020 at 3:00 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> >> +    struct mutex tgt_mutex; /* protects tgt_* pointers below, *after=
* prog becomes visible */
>> >> +    struct bpf_prog *tgt_prog;
>> >> +    struct bpf_trampoline *tgt_trampoline;
>> >>      bool verifier_zext; /* Zero extensions has been inserted by veri=
fier. */
>> >>      bool offload_requested;
>> >>      bool attach_btf_trace; /* true if attaching to BTF-enabled raw t=
p */
>> > ...
>> >>  struct bpf_tracing_link {
>> >>      struct bpf_link link;
>> >>      enum bpf_attach_type attach_type;
>> >> +    struct bpf_trampoline *trampoline;
>> >> +    struct bpf_prog *tgt_prog;
>> >
>> > imo it's confusing to have 'tgt_prog' to mean two different things.
>> > In prog->aux->tgt_prog it means target prog to attach to in the future.
>> > Whereas here it means the existing prog that was used to attached to.
>> > They kinda both 'target progs' but would be good to disambiguate.
>> > May be keep it as 'tgt_prog' here and
>> > rename to 'dest_prog' and 'dest_trampoline' in prog->aux ?
>>
>> I started changing this as you suggested, but I think it actually makes
>> the code weirder. We'll end up with a lot of 'tgt_prog =3D
>> prog->aux->dest_prog' assignments in the verifier, unless we also rename
>> all of the local variables, which I think is just code churn for very
>> little gain (the existing 'target' meaning is quite clear, I think).
>
> you mean "churn" just for this patch. that's fine.
> But it will make names more accurate for everyone reading it afterwards.
> Hence I prefer distinct and specific names where possible.
>
>> I also think it's quite natural that the target moves; I mean, it's
>> literally the same pointer being re-assigned from prog->aux to the link.
>> We could rename the link member to 'attached_tgt_prog' or something like
>> that, but I'm not sure it helps (and I don't see much of a problem in
>> the first place).
>
> 'attached_tgt_prog' will not be the correct name.
> There is 'prog' inside the link already. That's 'attached' prog.
> Not this one. This one is the 'attached_to' prog.
> But such name would be too long.
> imo calling it 'dest_prog' in aux is shorter and more obvious.

Meh, don't really see how it helps ('destination' and 'target' are
literally synonyms). But I don't care enough to bikeshed about it
either, so I'll just do a search/replace...

-Toke

