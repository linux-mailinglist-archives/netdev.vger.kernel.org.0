Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E281A78EA
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 12:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438745AbgDNK4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 06:56:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26586 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438364AbgDNKcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 06:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586860331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=puRZHsouOsa+kXRm9Yn+iQV/J7KVw+zCVFM/OzxJ0Iw=;
        b=Yt8POqM6RsBFMjW976mhyKK8+ckJajgr4ITgAcIPbJjcYp/A0IwK/ECTWO4X4fk8Ny+VKq
        AtQ7Qom+AgZHKFTyiyj66QKoREFiKsQ9yvuRQDOvSAh0oW/Hixyep6UQD4uMdwQzABXaKZ
        sx71BZGAzseKUNiUc1jWGW4edBZ4048=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-gnMtWXpvOlm68yjcBk8J5A-1; Tue, 14 Apr 2020 06:32:09 -0400
X-MC-Unique: gnMtWXpvOlm68yjcBk8J5A-1
Received: by mail-lj1-f197.google.com with SMTP id o13so2136110ljj.3
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 03:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=puRZHsouOsa+kXRm9Yn+iQV/J7KVw+zCVFM/OzxJ0Iw=;
        b=LPsH3vKDw526B2dI2DeHChGwov5kL8uhhEKow49BUnEU6dfOtk4YVw4cvOR4fk+Nrd
         epJh7TeW4ftI40z9MxcexxksBlvtKalUtXGIDew+yoECUVxwOp2KVbfp+0bELUWaI6Io
         9bcMZFJBGw0oxPrSr5e9BG5LP+9JvSOK4GeHQ1IG+VOhZPGYd1RF+SzMAUsncAnByKi3
         I3x4T/ogSO45fpI76qGaGpRhTJdIYTdiNFkWMSB9q70q141QK9YInqm5MzU26tUgO2IM
         6drNwE8osffq+6MRzWt8e3lkZlj0jhkDFqoCstfFXaFPxphk5cppHuHwR3Of4YBoJS1w
         6zhA==
X-Gm-Message-State: AGi0PuZOCaHA1DjQsbFgHzytytTjYXcYY/T0F00yCKcNmwqsPaDkOsYH
        /LlgSoK1R2B/PWNVSnDa7qsnZEKDUNqpzJvpMRRxeKmxVswaOLCSGzp/o+XuXNxRR2uum04xRt4
        OfR5ArLdnSz6KMN6C
X-Received: by 2002:a2e:884d:: with SMTP id z13mr13832027ljj.158.1586860327527;
        Tue, 14 Apr 2020 03:32:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypLQHW4saFb1NraTKoPsxOqixD5mRrBsjSvfBmThywmMh1KVqoHU+D5sm9B8VhTNk/SIgfK2Kw==
X-Received: by 2002:a2e:884d:: with SMTP id z13mr13832014ljj.158.1586860327243;
        Tue, 14 Apr 2020 03:32:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b21sm8930304ljj.46.2020.04.14.03.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 03:32:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B9016181586; Tue, 14 Apr 2020 12:32:04 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 4/8] bpf: support GET_FD_BY_ID and GET_NEXT_ID for bpf_link
In-Reply-To: <CAEf4BzbXCsHCJ6Tet0i5g=pKB_uYqvgiaBNuY-NMdZm8rdZN5g@mail.gmail.com>
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-5-andriin@fb.com> <87pnckc0fr.fsf@toke.dk> <CAEf4BzYrW43EW_Uneqo4B6TLY4V9fKXJxWj+-gbq-7X0j7y86g@mail.gmail.com> <877dyq80x8.fsf@toke.dk> <CAEf4BzaiRYMc4QMjz8bEn1bgiSXZvW_e2N48-kTR4Fqgog2fBg@mail.gmail.com> <87tv1t65cr.fsf@toke.dk> <CAEf4BzbXCsHCJ6Tet0i5g=pKB_uYqvgiaBNuY-NMdZm8rdZN5g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Apr 2020 12:32:04 +0200
Message-ID: <87mu7enysb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>> > After that, one can pin bpf_link temporarily and re-open it as
>> > writable one, provided CAP_DAC_OVERRIDE capability is present. All
>> > that works already, because pinned bpf_link is just a file, so one can
>> > do fchmod on it and all that will go through normal file access
>> > permission check code path.
>>
>> Ah, I did not know that was possible - I was assuming that bpffs was
>> doing something special to prevent that. But if not, great!
>>
>> > Unfortunately, just re-opening same FD as writable (which would
>> > be possible if fcntl(fd, F_SETFL, S_IRUSR
>> >  S_IWUSR) was supported on Linux) without pinning is not possible.
>> > Opening link from /proc/<pid>/fd/<link-fd> doesn't seem to work
>> > either, because backing inode is not BPF FS inode. I'm not sure, but
>> > maybe we can support the latter eventually. But either way, I think
>> > given this is to be used for manual troubleshooting, going through few
>> > extra hoops to force-detach bpf_link is actually a good thing.
>>
>> Hmm, I disagree that deliberately making users jump through hoops is a
>> good thing. Smells an awful lot like security through obscurity to me;
>> and we all know how well that works anyway...
>
> Depends on who users are? bpftool can implement this as one of
> `bpftool link` sub-commands and allow human operators to force-detach
> bpf_link, if necessary.

Yeah, I would expect this to be the common way this would be used: built
into tools.

> I think applications shouldn't do this (programmatically) at all,
> which is why I think it's actually good that it's harder and not
> obvious, this will make developer think again before implementing
> this, hopefully. For me it's about discouraging bad practice.

I guess I just don't share your optimism that making people jump through
hoops will actually discourage them :)

If people know what they are doing it should be enough to document it as
discouraged. And if they don't, they are perfectly capable of finding
and copy-pasting the sequence of hoop-jumps required to achieve what
they want, probably with more bugs added along the way.

So in the end I think that all you're really achieving is annoying
people who do have a legitimate reason to override the behaviour (which
includes yourself as a bpftool developer :)). That's what I meant by the
'security through obscurity' comment.

-Toke

