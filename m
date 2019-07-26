Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE44575CA2
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 03:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfGZBrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 21:47:25 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44876 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfGZBrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 21:47:25 -0400
Received: by mail-lj1-f195.google.com with SMTP id k18so49835264ljc.11;
        Thu, 25 Jul 2019 18:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i4kgqVwGr2NMhL7cTz04RMzXH758uQCY3o4QbRXJrTk=;
        b=VYYvEH+wVqR2jSBjKMASqwc3Gws9Pcs8Zh1oqf2qXduDJsVZtx7RNSnH0w6dzL5Aqu
         jbZCKJLUw3jPgjLxUuofsY5L5JfMydo4MST1L8mhqQhIXHMbdnWEub20zZABDe+Ael1B
         jG4qBLQCNZKXQF0xSLzQkhhsFpeg10znLelHrVEvji1UFTravBC4U0PN/XXcSnqwnoka
         RGndg8MZCdzAiEMarADO2Uwu4GyUdgoBJ9u+XA9jwZ9W3Ggdsq82LJyt+R9X8bcq1Psi
         s9z3oHD8e97pVyaZyUKpwOCX/9afT+CAy1xbN1XraCrAvQSnKK1WsL8Yk6EnljsyB4nl
         VErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i4kgqVwGr2NMhL7cTz04RMzXH758uQCY3o4QbRXJrTk=;
        b=SAKFwfkT89uzBXQkB1AD63cH+UgqC6zwe92OLhgIFSMjEUXpJhcpyoFFsHM7VUjJ7k
         ivQho5m2EXc0Vfd87Az6CWI4kgaz0RYCM4JV+6GgDk5w0g+jgoyFazPpWqsVd/SsIRg2
         PYP5IuiIYZnmENJIxIVHYbUUharvxHVG+wV51VGCVoUgHLJBk+BqZ7JCG8ffuBaY4na/
         z1tzXFR62TZUVzMLTz0s3+031iIDUJQHd4g9NOtJty37g9vu8TBK31NtGWJxK1i5+Q4b
         ayXzJm/RVFRQsiZrR4JyvwwbPXLAy3OtDFIRihAMg+k5v2ZkOrTur9oGgYaYBcLqDEz0
         AMMg==
X-Gm-Message-State: APjAAAWXHHYkRYNpzuh2jIYoHx1IjSR4bUsZ7TU5V1xb3cNDLtcD5bIr
        JqCr1jZfEUmY6L6dxE9auS3puVcDnO3oyBTtXbo=
X-Google-Smtp-Source: APXvYqzJ+OkV/ZRYH14QvVsLVocYMrfkFT1nRqVzFnWjujllxpWGGj8kyMhKGda54Pj5kWy6mbZZ0ZJ++d8jmExtlUU=
X-Received: by 2002:a2e:93cc:: with SMTP id p12mr48725340ljh.11.1564105641916;
 Thu, 25 Jul 2019 18:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-3-brianvv@google.com>
 <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
 <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
 <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
 <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com>
 <20190725235432.lkptx3fafegnm2et@ast-mbp> <CABCgpaXE=dkBcJVqs95NZQTFuznA-q64kYPEcbvmYvAJ4wSp1A@mail.gmail.com>
In-Reply-To: <CABCgpaXE=dkBcJVqs95NZQTFuznA-q64kYPEcbvmYvAJ4wSp1A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 25 Jul 2019 18:47:10 -0700
Message-ID: <CAADnVQJpp37fXLsu8ZnMFPoC0Uof3roz4gofX0QCewNkwtf-Xg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Brian Vazquez <brianvv.kernel@gmail.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 6:24 PM Brian Vazquez <brianvv.kernel@gmail.com> wrote:
>
> On Thu, Jul 25, 2019 at 4:54 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jul 25, 2019 at 04:25:53PM -0700, Brian Vazquez wrote:
> > > > > > If prev_key is deleted before map_get_next_key(), we get the first key
> > > > > > again. This is pretty weird.
> > > > >
> > > > > Yes, I know. But note that the current scenario happens even for the
> > > > > old interface (imagine you are walking a map from userspace and you
> > > > > tried get_next_key the prev_key was removed, you will start again from
> > > > > the beginning without noticing it).
> > > > > I tried to sent a patch in the past but I was missing some context:
> > > > > before NULL was used to get the very first_key the interface relied in
> > > > > a random (non existent) key to retrieve the first_key in the map, and
> > > > > I was told what we still have to support that scenario.
> > > >
> > > > BPF_MAP_DUMP is slightly different, as you may return the first key
> > > > multiple times in the same call. Also, BPF_MAP_DUMP is new, so we
> > > > don't have to support legacy scenarios.
> > > >
> > > > Since BPF_MAP_DUMP keeps a list of elements. It is possible to try
> > > > to look up previous keys. Would something down this direction work?
> > >
> > > I've been thinking about it and I think first we need a way to detect
> > > that since key was not present we got the first_key instead:
> > >
> > > - One solution I had in mind was to explicitly asked for the first key
> > > with map_get_next_key(map, NULL, first_key) and while walking the map
> > > check that map_get_next_key(map, prev_key, key) doesn't return the
> > > same key. This could be done using memcmp.
> > > - Discussing with Stan, he mentioned that another option is to support
> > > a flag in map_get_next_key to let it know that we want an error
> > > instead of the first_key.
> > >
> > > After detecting the problem we also need to define what we want to do,
> > > here some options:
> > >
> > > a) Return the error to the caller
> > > b) Try with previous keys if any (which be limited to the keys that we
> > > have traversed so far in this dump call)
> > > c) continue with next entries in the map. array is easy just get the
> > > next valid key (starting on i+1), but hmap might be difficult since
> > > starting on the next bucket could potentially skip some keys that were
> > > concurrently added to the same bucket where key used to be, and
> > > starting on the same bucket could lead us to return repeated elements.
> > >
> > > Or maybe we could support those 3 cases via flags and let the caller
> > > decide which one to use?
> >
> > this type of indecision is the reason why I wasn't excited about
> > batch dumping in the first place and gave 'soft yes' when Stan
> > mentioned it during lsf/mm/bpf uconf.
> > We probably shouldn't do it.
> > It feels this map_dump makes api more complex and doesn't really
> > give much benefit to the user other than large map dump becomes faster.
> > I think we gotta solve this problem differently.
>
> Some users are working around the dumping problems with the existing
> api by creating a bpf_map_get_next_key_and_delete userspace function
> (see https://www.bouncybouncy.net/blog/bpf_map_get_next_key-pitfalls/)
> which in my opinion is actually a good idea. The only problem with
> that is that calling bpf_map_get_next_key(fd, key, next_key) and then
> bpf_map_delete_elem(fd, key) from userspace is racing with kernel code
> and it might lose some information when deleting.
> We could then do map_dump_and_delete using that idea but in the kernel
> where we could better handle the racing condition. In that scenario
> even if we retrieve the same key it will contain different info ( the
> delta between old and new value). Would that work?

you mean get_next+lookup+delete at once?
Sounds useful.
Yonghong has been thinking about batching api as well.

I think if we cannot figure out how to make a batch of two commands
get_next + lookup to work correctly then we need to identify/invent one
command and make batching more generic.
Like make one jumbo/compound/atomic command to be get_next+lookup+delete.
Define the semantics of this single compound command.
And then let batching to be a multiplier of such command.
In a sense that multiplier 1 or N should be have the same way.
No extra flags to alter the batching.
The high level description of the batch would be:
pls execute get_next,lookup,delete and repeat it N times.
or
pls execute get_next,lookup and repeat N times.
where each command action is defined to be composable.

Just a rough idea.
