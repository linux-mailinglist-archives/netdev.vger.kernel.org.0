Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70DC1CD15
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 18:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfENQey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 12:34:54 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42580 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENQey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 12:34:54 -0400
Received: by mail-qk1-f195.google.com with SMTP id d4so10674909qkc.9;
        Tue, 14 May 2019 09:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/7gaeJYCOtWCIvoQvIfzhGeThP2BdCxa7jC4qIRZJ3o=;
        b=WH6E4Wpa1kEuiCBSbaE6kFm1HBAQjTOiifF6SDMisU5TpWs9CZ0mm7w1c7Q9cvC12h
         DBBN180bdTEKMLxO3TjqDaOmeRJnXCeVGF9UNJkLJU70YRHE8SXEs1whXkU9SviaxM9v
         hxcDs2ksJdNFilGX+noM4VhtZjvYbGq065/D4PXYm4gMngC3Ih4VLyCDKUfqaJCQJ8fh
         UYE4THMCS8dWaH4BEcwx8cDfo/Fdyx5tiJgyK+jf0/opt9IXjyvJ1pm70UOgHkaFNMm1
         2UrcNE3PMijywulOR36NL9miVQud3BG18dOdAjrgKkcoG6RwaMBMcMTsE/leuPvn4CQr
         1OEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/7gaeJYCOtWCIvoQvIfzhGeThP2BdCxa7jC4qIRZJ3o=;
        b=XJ4yFJTa+3xiVcxmLZQAJx15jQ3AyIiFcOJ4aZhKH5btf8OeA3sQS9IaqhR7r14JSD
         pB4KpTa0m6u1EG5bGcJYNrwJM8adTf4qBw3dOwICxooswCUkNqlUiDG03p6r3Tl4XKfz
         iC8MQi1VGb86DwEU/CX6pQrBgM4YflaPKLi3qBeZLV1FsHg1Cy5IlU6oRSk83J4ZjZsV
         WIiCHH7+YzjyeQ59EjBemJxpgP3OegrNOMGPy6DoA30L+XicM1oqN35Ee90/aGmnHro2
         9WvaGxa4kPnCsf+b9r5odh8ezLpUV+Z/11nW8AdFBCVst9//2gBj86TARreagL6YLr9q
         0sjg==
X-Gm-Message-State: APjAAAXYp3MCYI2T0jAOCgeMMfRRKvDlUhJhpN8pvrnb8x9ccHgxpqa8
        pgBuP/+6sET/aU56Sc/QJ0nKLmWcX713XvXzxYi5z6rlmXNh6g==
X-Google-Smtp-Source: APXvYqyUki6Uak7QQDo5UhLsZ7eRpE796uqD5LHnXOWUCIJuwHUt6x5EayBs3Uk73DcsvqO01YhmELEOa76cfBklSas=
X-Received: by 2002:a37:72c7:: with SMTP id n190mr27180656qkc.189.1557851693196;
 Tue, 14 May 2019 09:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1557789256.git.daniel@iogearbox.net> <505e5dfeea6ab7dd3719bb9863fc50e7595e06ed.1557789256.git.daniel@iogearbox.net>
 <CAEf4BzZc_8FfHKA0rEvgx8T0xRWQp-2scm1N+nwroXi5enDh_g@mail.gmail.com> <76dde419-7204-0aa0-3251-f52c2c15be85@iogearbox.net>
In-Reply-To: <76dde419-7204-0aa0-3251-f52c2c15be85@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 May 2019 09:34:41 -0700
Message-ID: <CAEf4BzZ_c3srGXfX5RvPPSoibeyiz0a6042sU0=Kx7XmZp3-Cg@mail.gmail.com>
Subject: Re: [PATCH bpf 1/3] bpf: add map_lookup_elem_sys_only for lookups
 from syscall side
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        bpf@vger.kernel.org, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 12:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 05/14/2019 07:04 AM, Andrii Nakryiko wrote:
> > On Mon, May 13, 2019 at 4:20 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> Add a callback map_lookup_elem_sys_only() that map implementations
> >> could use over map_lookup_elem() from system call side in case the
> >> map implementation needs to handle the latter differently than from
> >> the BPF data path. If map_lookup_elem_sys_only() is set, this will
> >> be preferred pick for map lookups out of user space. This hook is
> >
> > This is kind of surprising behavior  w/ preferred vs default lookup
> > code path. Why the desired behavior can't be achieved with an extra
> > flag, similar to BPF_F_LOCK? It seems like it will be more explicit,
> > more extensible and more generic approach, avoiding duplication of
> > lookup semantics.
>
> For lookup from syscall side, this is possible of course. Given the
> current situation breaks heuristic with any walks of the LRU map, I
> presume you are saying something like an opt-in flag such as
> BPF_F_MARK_USED would be more useful? I was thinking about something

To preserve existing semantics, it would be opt-out
BPF_F_DONT_MARK_USED, if you don't want to update LRU, so that
existing use cases don't break.

> like this initially, but then I couldn't come up with a concrete use
> case where it's needed/useful today for user space. Given that, my
> preference was to only add such flag wait until there is an actual
> need for it, and in any case, it is trivial to add it later on. Do
> you have a concrete need for it today that would justify such flag?

So my concern was with having two ops for lookup for maps
(map_lookup_elem() and map_lookup_elem_sys_only()) which for existing
use cases differ only in whether we are reordering LRU on lookup or
not, which felt like would be cleaner to solve with extending
ops->map_lookup_elem() to accept flags. But now I realize that there
are important implementation limitations preventing doing this cleanly
and efficiently, so I rescind my proposal.

>
> > E.g., for LRU map, with flag on lookup, one can decide whether lookup
> > from inside BPF program (not just from syscall side!) should modify
> > LRU ordering or not, simply by specifying extra flag. Am I missing
> > some complication that prevents us from doing it that way?
>
> For programs it's a bit tricky. The BPF call interface is ...
>
>   BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)
>
> ... meaning verifier does not care what argument 3 and beyond contains.
> From BPF context/pov, it could also be uninitialized register. This would
> mean, we'd need to add a BPF_CALL_3(bpf_map_lookup_elem2, ...) interface
> which programs would use instead (and to not break existing ones), or
> some other new helper call that gets a map value argument to unmark the
> element from LRU side. While all doable one way or another although bit
> hacky, we should probably clarify and understand the use case for it
> first, thus brings me back to the last question from above paragraph.

Yeah, if we wanted to expose this functionality from BPF side right
now, we'd have to add new helper w/ extra flags arg. As I mentioned
above, though, I assumed it wouldn't be too hard to make existing
BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)
translate to map->ops->map_lookup_elem(key, 0 /* flags */), filling in
default flags = 0 value, but apparently that's not that simple (and
will hurt performance).

>
> Thanks,
> Daniel
