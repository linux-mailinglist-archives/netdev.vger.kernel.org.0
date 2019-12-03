Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BAD10FC2B
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 12:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfLCLGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 06:06:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37215 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725939AbfLCLF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 06:05:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575371158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g8wIj/+7Uu6mwDZD6eBwLAeeZ7c67O5dDCPoJ8FiFsw=;
        b=E49Ztgy2viSowEGCRyuE50UadZ0C6+mtuPytLegW3YGa8WXHN0/3IvAHUP+CNpQiMp6CRW
        ktwmYPj2I8mfCAZFfsMcZvxKE9KpegMeRdKb9PyhAw0mASPB1nmWKtjhXCmL3kUrO+ZzX8
        Flq9TUnpNLy+agT9BMz91YReH3ynk4o=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-3KE5f1rCPi2kwSdfwZstiA-1; Tue, 03 Dec 2019 06:05:57 -0500
Received: by mail-lf1-f70.google.com with SMTP id u14so831168lfg.3
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 03:05:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=V8CIWd+jImrTtfvsB6vFA+BEXkmrNtVLFpFsIB4E0cA=;
        b=iQrmYGPOSbOagPxFL+CCUdY9HonaabWtBULYxcRrAKgc8UCYfPR5KmJh6mB5IKVbEP
         fBnTfsKOBQxjSFfyTrUSrpx53E1/Ot8noJzkQYac2f1KJ6W0M6kcgUkfsZzRhGWFGYVM
         rcATg9bJZa0gMl896utDiB/iCeNQXM3Mt8EurD/FGJ3cV2qpg34qyAYJPrmVqECtaCsJ
         mUVRVajJG4Cauat+FheAzWhV8iy4EZuBJjptHbNDARarXZR+kXL+tVncE0uiYvuVr35B
         ldQuuzJfGJVszGQWN3rCS7UD4kkJ2kJ5pws00nZr+OKbO8sTiZQr8QfVPYdgBt9nJ6S9
         6osQ==
X-Gm-Message-State: APjAAAVNlKnju/jyNk8wHVlqu/PAEnm5kg4sW2VWg6MABjRtuHI7mi6L
        okIFPfRoKNCIwfHUycsJyp2pUHmHjQqsEAtaIsAS08QZ16KQy6coiYq72YIkIeJcDR95AY4kdeX
        Ym0rwvLFpaqICvCXP
X-Received: by 2002:a2e:9b52:: with SMTP id o18mr2105784ljj.205.1575371156270;
        Tue, 03 Dec 2019 03:05:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwo50fGFo8pv96BZQKak3qX0V58pQJksf6J0MKuQ+rJrI21+fktSHr9IwKuVoTh0bDQWQSTtQ==
X-Received: by 2002:a2e:9b52:: with SMTP id o18mr2105766ljj.205.1575371156018;
        Tue, 03 Dec 2019 03:05:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m13sm1108395lfo.40.2019.12.03.03.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 03:05:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C7B0618193A; Tue,  3 Dec 2019 12:05:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Better ways to validate map via BTF?
In-Reply-To: <CAEf4BzYg-eM-di=GZOEaTMpgbqjuByY-hXjWpnRyBGyy-AkQYA@mail.gmail.com>
References: <20191128170837.2236713b@carbon> <CAEf4BzY3jp=cw9N23dBJnEsMXys6ZtjW5LVHquq4kF9avaPKcg@mail.gmail.com> <87pnhbulxf.fsf@toke.dk> <CAEf4BzYg-eM-di=GZOEaTMpgbqjuByY-hXjWpnRyBGyy-AkQYA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 03 Dec 2019 12:05:52 +0100
Message-ID: <87o8wppt2n.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 3KE5f1rCPi2kwSdfwZstiA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Nov 29, 2019 at 12:27 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Thu, Nov 28, 2019 at 8:08 AM Jesper Dangaard Brouer
>> > <brouer@redhat.com> wrote:
>> >>
>> >> Hi Andrii,
>> >
>> >
>> > Hey, Jesper! Sorry for late reply, I'm on vacation for few days, so my
>> > availability is irregular at best :)
>> >
>> >>
>> >> Is there are better way to validate that a userspace BPF-program uses
>> >> the correct map via BTF?
>> >>
>> >> Below and in attached patch, I'm using bpf_obj_get_info_by_fd() to ge=
t
>> >> some map-info, and check info.value_size and info.max_entries match
>> >> what I expect.  What I really want, is to check that "map-value" have
>> >> same struct layout as:
>> >>
>> >>  struct config {
>> >>         __u32 action;
>> >>         int ifindex;
>> >>         __u32 options;
>> >>  };
>> >
>> > Well, there is no existing magical way to do this, but it is doable by
>> > comparing BTFs of two maps. It's not too hard to compare all the
>> > members of a struct, their names, sizes, types, etc (and do that
>> > recursively, if necessary), but it's a bunch of code requiring due
>> > diligence. Libbpf doesn't provide that in a ready-to-use form (it does
>> > implement equivalence checks between two type graphs for dedup, but
>> > it's quite coupled with and specific to BTF deduplication algorithm).
>> > Keep in mind, when Toke implemented map pinning support in libbpf, we
>> > decided to not check BTF for now, and just check key/value size,
>> > flags, type, max_elements, etc.
>>
>> Yeah. Probably a good idea to provide convenience functions for this in
>> libbpf (split out the existing code and make it more general?). Then we
>> can also use that for the test in the map pinning code :)
>
> As I said, type graph equivalence for btf_dedup() is very specific to
> dedup. It does deep (i.e., structs that are referenced by pointer only
> also have to match exactly) and strict (const, volatile, typedefs, all
> that matters **and** has to come in exactly the same order)
> equivalence checks. In addition, it does forward declaration
> resolution into concrete struct/union. So no, it can't be reused or
> generalized.
>
> It has to be a new code, but even then I'm hesitant to provide
> something "generic", because it's again not clear what the right
> semantics is for all the cases. E.g., should we ignore
> const/volatile/restrict? Or, if some typedef is used, which ultimately
> resolves to the same underlying type -- should we ignore such
> differences? Also, should we follow and check types that are
> referenced through pointers only? I think in different cases users
> might be want to be strict or more lenient about such cases, which
> suggests that we shouldn't have a generic API (at least yet, until we
> see 2, 3, 4, real-life use cases). And there are more potential
> differences in semantics without a clear answer of which one should be
> used. So we can code it up for map pinning case (after having a
> discussion of what two maps should be considered compatible), but I
> don't think we should go all the way to exposing it as an API.

My immediate thought is that we'd want the strict interpretation by
default; at least for maps. My reasoning being that I expect most people
will just define a struct in a C file somewhere for their map contents,
and want to ensure that the map matches this, which would mean that any
changes to the struct definition should break the match.

I'll go read the dedup code, and try to base a comparison function for
maps on this; then we can discuss from there. I'm fine with keeping it
internal to begin with, but I worry that if we don't (eventually) expose
something as an API, people are just going to go the
reuse-via-copy-paste route instead. But sure, let's spend some time
collecting more experience with this before committing to an API.

-Toke

