Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204FA1A2B0A
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgDHVVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 17:21:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45626 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727749AbgDHVVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:21:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586380908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zjdVKSaKUFVN3gQUYjode6bFrQibAh5czANpuUwH5nM=;
        b=Z0Ia+hZKGENZE4dKWybaBoabs95llc1JVDDBgdUa+8GLTg0wrQ1ggQet+BkUuUHFxKpunq
        10H0vyi6l26eSgc9K3DSX6z06nosgrL9uzKfPSuB6IN73h9L9xW4qnaFuFCp2/IM5BYOOd
        KrHmNGgpR453pWidczgsftT09fgLpoM=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-0mOecZYJOUaqMa6vPsHETA-1; Wed, 08 Apr 2020 17:21:47 -0400
X-MC-Unique: 0mOecZYJOUaqMa6vPsHETA-1
Received: by mail-lj1-f200.google.com with SMTP id v22so2302152ljj.10
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 14:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zjdVKSaKUFVN3gQUYjode6bFrQibAh5czANpuUwH5nM=;
        b=OTbLyttrvUrrDRq5kwdn/NW96pGMFYZ0XXpmaNcsnYQxjW+uc3XX6l7POsa96h2Zie
         Idxtd8zcTAKzlDK/ENcU3QCvLE6k280WDpjdXNjB/6xO+1MFGhet6NvFXzNdEwjxfhdS
         1sKr9yn1/VOkysYF2/a5q66gOJReGzQ/929zQGFQUKdOChHvS17AqsqH4s8pZdHZgrjE
         m/oQrvICCsfSpwie5MZezLAQVGTbxSNYkXxXQ1d6ncf7r3XcDO9hmv1BaZCutDMW0KJC
         V1euHltG1ouv2/pSGQt40SY1IDP01XLRvPZmQj5xpvxSCAZUZY5QkygyD2D4u4P1PzbM
         bO/g==
X-Gm-Message-State: AGi0PuYYDfi5TEzMIvYjDfiPPyLyTHklN1+hecGU9jm9IUlILB2yv/l6
        pVhow8XCF/a+Goy3NgJmzzqd5EoFh8EYTIh48lG4fyeBZpDOhHG4y86Kms/dmIqzZ65YBDDVezm
        pl0Vsb5GreFJDYu+k
X-Received: by 2002:a2e:974d:: with SMTP id f13mr696449ljj.178.1586380905575;
        Wed, 08 Apr 2020 14:21:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypLO0G4XVJnWM99J9TSjjrOwqcuVAUbfX7gGqC4VxjGNfeUs2cPxoj/0UOwqIDGwkaRxfvIQGw==
X-Received: by 2002:a2e:974d:: with SMTP id f13mr696436ljj.178.1586380905320;
        Wed, 08 Apr 2020 14:21:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n13sm15959641lfk.78.2020.04.08.14.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 14:21:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A9CDC1804E7; Wed,  8 Apr 2020 23:21:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 4/8] bpf: support GET_FD_BY_ID and GET_NEXT_ID for bpf_link
In-Reply-To: <CAEf4BzaiRYMc4QMjz8bEn1bgiSXZvW_e2N48-kTR4Fqgog2fBg@mail.gmail.com>
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-5-andriin@fb.com> <87pnckc0fr.fsf@toke.dk> <CAEf4BzYrW43EW_Uneqo4B6TLY4V9fKXJxWj+-gbq-7X0j7y86g@mail.gmail.com> <877dyq80x8.fsf@toke.dk> <CAEf4BzaiRYMc4QMjz8bEn1bgiSXZvW_e2N48-kTR4Fqgog2fBg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 08 Apr 2020 23:21:40 +0200
Message-ID: <87tv1t65cr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Apr 8, 2020 at 8:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Mon, Apr 6, 2020 at 4:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andriin@fb.com> writes:
>> >>
>> >> > Add support to look up bpf_link by ID and iterate over all existing=
 bpf_links
>> >> > in the system. GET_FD_BY_ID code handles not-yet-ready bpf_link by =
checking
>> >> > that its ID hasn't been set to non-zero value yet. Setting bpf_link=
's ID is
>> >> > done as the very last step in finalizing bpf_link, together with in=
stalling
>> >> > FD. This approach allows users of bpf_link in kernel code to not wo=
rry about
>> >> > races between user-space and kernel code that hasn't finished attac=
hing and
>> >> > initializing bpf_link.
>> >> >
>> >> > Further, it's critical that BPF_LINK_GET_FD_BY_ID only ever allows =
to create
>> >> > bpf_link FD that's O_RDONLY. This is to protect processes owning bp=
f_link and
>> >> > thus allowed to perform modifications on them (like LINK_UPDATE), f=
rom other
>> >> > processes that got bpf_link ID from GET_NEXT_ID API. In the latter =
case, only
>> >> > querying bpf_link information (implemented later in the series) wil=
l be
>> >> > allowed.
>> >>
>> >> I must admit I remain sceptical about this model of restricting access
>> >> without any of the regular override mechanisms (for instance, enforci=
ng
>> >> read-only mode regardless of CAP_DAC_OVERRIDE in this series). Since =
you
>> >> keep saying there would be 'some' override mechanism, I think it would
>> >> be helpful if you could just include that so we can see the full
>> >> mechanism in context.
>> >
>> > I wasn't aware of CAP_DAC_OVERRIDE, thanks for bringing this up.
>> >
>> > One way to go about this is to allow creating writable bpf_link for
>> > GET_FD_BY_ID if CAP_DAC_OVERRIDE is set. Then we can allow LINK_DETACH
>> > operation on writable links, same as we do with LINK_UPDATE here.
>> > LINK_DETACH will do the same as cgroup bpf_link auto-detachment on
>> > cgroup dying: it will detach bpf_link, but will leave it alive until
>> > last FD is closed.
>>
>> Yup, I think this would be a reasonable way to implement the override
>> mechanism - it would ensure 'full root' users (like a root shell) can
>> remove attachments, while still preventing applications from doing so by
>> limiting their capabilities.
>
> So I did some experiments and I think I want to keep GET_FD_BY_ID for
> bpf_link to return only read-only bpf_links.

Why, exactly? (also, see below)

> After that, one can pin bpf_link temporarily and re-open it as
> writable one, provided CAP_DAC_OVERRIDE capability is present. All
> that works already, because pinned bpf_link is just a file, so one can
> do fchmod on it and all that will go through normal file access
> permission check code path.

Ah, I did not know that was possible - I was assuming that bpffs was
doing something special to prevent that. But if not, great!

> Unfortunately, just re-opening same FD as writable (which would
> be possible if fcntl(fd, F_SETFL, S_IRUSR
>  S_IWUSR) was supported on Linux) without pinning is not possible.
> Opening link from /proc/<pid>/fd/<link-fd> doesn't seem to work
> either, because backing inode is not BPF FS inode. I'm not sure, but
> maybe we can support the latter eventually. But either way, I think
> given this is to be used for manual troubleshooting, going through few
> extra hoops to force-detach bpf_link is actually a good thing.

Hmm, I disagree that deliberately making users jump through hoops is a
good thing. Smells an awful lot like security through obscurity to me;
and we all know how well that works anyway...

>> Extending on the concept of RO/RW bpf_link attachments, maybe it should
>> even be possible for an application to choose which mode it wants to pin
>> its fd in? With the same capability being able to override it of
>> course...
>
> Isn't that what patch #2 is doing?...

Ah yes, so it is! I guess I skipped over that a bit too fast ;)

> There are few bugs in the implementation currently, but it will work
> in the final version.

Cool.

>> > We need to consider, though, if CAP_DAC_OVERRIDE is something that can
>> > be disabled for majority of real-life applications to prevent them
>> > from doing this. If every realistic application has/needs
>> > CAP_DAC_OVERRIDE, then that's essentially just saying that anyone can
>> > get writable bpf_link and do anything with it.
>>
>> I poked around a bit, and looking at the sandboxing configurations
>> shipped with various daemons in their systemd unit files, it appears
>> that the main case where daemons are granted CAP_DAC_OVERRIDE is if they
>> have to be able to read /etc/shadow (which is installed as chmod 0). If
>> this is really the case, that would indicate it's not a widely needed
>> capability; but I wouldn't exactly say that I've done a comprehensive
>> survey, so probably a good idea for you to check your users as well :)
>
> Right, it might not be possible to drop it for all applications right
> away, but at least CAP_DAC_OVERRIDE is not CAP_SYS_ADMIN, which is
> absolutely necessary to work with BPF.

Yeah, I do hope that we'll eventually get CAP_BPF...

-Toke

