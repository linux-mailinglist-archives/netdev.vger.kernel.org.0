Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3460B1A98CC
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 11:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895464AbgDOJ0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 05:26:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36992 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2895484AbgDOJ0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 05:26:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586942796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YILbIg5RMxm+GOxX8SMepjWj1MDSqzjfSprlUdY6PO8=;
        b=F2fiiwQcj2JnQTEXDfcMZmQJro5sXauodbd7+kJIIzPYBR1h33Abje+E0bdRfZmsqG9J99
        5dG88uatIsW8lfLfScnv6d2yQtp51AvNG07niJiynIvO7FGxGiLRWUS8a8GVt+0dUn4Dy9
        oXQ/LFy/b1U2t8VYsECgRp46WZpalA8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-z3gIXEUgMMK5w4MTPbbEGw-1; Wed, 15 Apr 2020 05:26:35 -0400
X-MC-Unique: z3gIXEUgMMK5w4MTPbbEGw-1
Received: by mail-lf1-f69.google.com with SMTP id b22so1139275lfa.18
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 02:26:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YILbIg5RMxm+GOxX8SMepjWj1MDSqzjfSprlUdY6PO8=;
        b=sBVgWPjWYWzZpIA0lFaEqSz430vZ9VcRsBGRLzqyVK2TkzcnqkIx7BFXmme/KgFCdP
         BZ1XS2FqqLnEYKeVbdcqVDDjbaDO9R8pUcN2DZnrPr1QZKa5AjWUnXFrFUaOHjbXe5hh
         pVwsPcRN6EKp6hsUIMbyA5cRl+XHdNKF8/LgGMeEJE4Qa8DfiersGMTVU/4hPpgtivPp
         ogz7dYW5ULLlH2pklfSs9QKJWFWMYN/5bdWcu2b9HZ4lYTN9YrRi+Pngc1N5o5TjJZ2+
         lSzEZ7yn69gNW6sOtV8LVZBiWuiUdU7fFYD+FDw8rNwVrkm6swmUsna/qCCL6DKZOIYl
         9u4w==
X-Gm-Message-State: AGi0Puacj2C6hK8EHuu4Ue8AoEjmcd7QDRlxNDeWz4Q0sg6HIp4nidjn
        tgU6E0ROzjmo/rdFJsZOsM9MBuX8FR44wa76xaYr8WRNHHMG18AGHIwL/uW6A+LU6mGGW7+F0nl
        qSSxnDxNnH8altLKP
X-Received: by 2002:ac2:5474:: with SMTP id e20mr2482179lfn.200.1586942786877;
        Wed, 15 Apr 2020 02:26:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypIpC4iSUH+DcwQIev20tlT2aEnv9dtLJppj3zSzwoV2zNQAhYweBM4Q9VakGs3CSMTHp2mXbA==
X-Received: by 2002:ac2:5474:: with SMTP id e20mr2482149lfn.200.1586942786458;
        Wed, 15 Apr 2020 02:26:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id h14sm12735825lfm.60.2020.04.15.02.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 02:26:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C4872181586; Wed, 15 Apr 2020 11:26:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 4/8] bpf: support GET_FD_BY_ID and GET_NEXT_ID for bpf_link
In-Reply-To: <CAEf4BzZtJo5dKMX_ys_2rN+bx6QqDGz9DAEVFod6Ys9Rs93VgA@mail.gmail.com>
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-5-andriin@fb.com> <87pnckc0fr.fsf@toke.dk> <CAEf4BzYrW43EW_Uneqo4B6TLY4V9fKXJxWj+-gbq-7X0j7y86g@mail.gmail.com> <877dyq80x8.fsf@toke.dk> <CAEf4BzaiRYMc4QMjz8bEn1bgiSXZvW_e2N48-kTR4Fqgog2fBg@mail.gmail.com> <87tv1t65cr.fsf@toke.dk> <CAEf4BzbXCsHCJ6Tet0i5g=pKB_uYqvgiaBNuY-NMdZm8rdZN5g@mail.gmail.com> <87mu7enysb.fsf@toke.dk> <CAEf4BzZtJo5dKMX_ys_2rN+bx6QqDGz9DAEVFod6Ys9Rs93VgA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 15 Apr 2020 11:26:23 +0200
Message-ID: <87pnc9m75s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Apr 14, 2020 at 3:32 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> >> > After that, one can pin bpf_link temporarily and re-open it as
>> >> > writable one, provided CAP_DAC_OVERRIDE capability is present. All
>> >> > that works already, because pinned bpf_link is just a file, so one =
can
>> >> > do fchmod on it and all that will go through normal file access
>> >> > permission check code path.
>> >>
>> >> Ah, I did not know that was possible - I was assuming that bpffs was
>> >> doing something special to prevent that. But if not, great!
>> >>
>> >> > Unfortunately, just re-opening same FD as writable (which would
>> >> > be possible if fcntl(fd, F_SETFL, S_IRUSR
>> >> >  S_IWUSR) was supported on Linux) without pinning is not possible.
>> >> > Opening link from /proc/<pid>/fd/<link-fd> doesn't seem to work
>> >> > either, because backing inode is not BPF FS inode. I'm not sure, but
>> >> > maybe we can support the latter eventually. But either way, I think
>> >> > given this is to be used for manual troubleshooting, going through =
few
>> >> > extra hoops to force-detach bpf_link is actually a good thing.
>> >>
>> >> Hmm, I disagree that deliberately making users jump through hoops is a
>> >> good thing. Smells an awful lot like security through obscurity to me;
>> >> and we all know how well that works anyway...
>> >
>> > Depends on who users are? bpftool can implement this as one of
>> > `bpftool link` sub-commands and allow human operators to force-detach
>> > bpf_link, if necessary.
>>
>> Yeah, I would expect this to be the common way this would be used: built
>> into tools.
>>
>> > I think applications shouldn't do this (programmatically) at all,
>> > which is why I think it's actually good that it's harder and not
>> > obvious, this will make developer think again before implementing
>> > this, hopefully. For me it's about discouraging bad practice.
>>
>> I guess I just don't share your optimism that making people jump through
>> hoops will actually discourage them :)
>
> I understand. I just don't see why would anyone have to implement this
> at all and especially would think it's a good idea to begin with?
>
>>
>> If people know what they are doing it should be enough to document it as
>> discouraged. And if they don't, they are perfectly capable of finding
>> and copy-pasting the sequence of hoop-jumps required to achieve what
>> they want, probably with more bugs added along the way.
>>
>> So in the end I think that all you're really achieving is annoying
>> people who do have a legitimate reason to override the behaviour (which
>> includes yourself as a bpftool developer :)). That's what I meant by the
>> 'security through obscurity' comment.
>
> Can I please get a list of real examples of legitimate reasons to
> override this behavior?

Primarily, I expect that this would be built into admin tools (like
bpftool as you suggested). I just don't see why such tools should be
made to do the whole pin/reopen dance (which, BTW, adds an implicit
dependency on having a mounted bpffs) when we could just add a
capability check directly in bpf_link_get_fd_by_id()?

-Toke

