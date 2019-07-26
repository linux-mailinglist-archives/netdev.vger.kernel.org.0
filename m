Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E8C77501
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 01:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfGZXge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 19:36:34 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40364 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfGZXgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 19:36:33 -0400
Received: by mail-lf1-f66.google.com with SMTP id b17so38198187lff.7;
        Fri, 26 Jul 2019 16:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ogHA1ZvWrLQpcRlO6ydUCOI+bPrM3cHOqFMdk63saTE=;
        b=F+tiFiCHhgge+HJInhlJxxzlt8Ue1KP2vBK2EV2EyhuLNJlZ4Ce0dahhyTXUA/vJyU
         GhJR24xCQXq20hqSSwaJmxxxsBr3fUDB54yjVw1sc9iukXtPZeAdyCGyWXMyNWyzRfW8
         yuuiQiNKBDlThoterSje9ouQoT/PZSZ6uOwA+0jsFsC2bAr5WqVCCY5EVW53kQ0GPkQ5
         t+q1Uf7EyUUIkPNZhG0D30omtzg9DaT/G91b6ttpzFkDFBUQFQRM9FgKyYhBr8iS8Boe
         8MUTK4TqEmLAqs5Xalg6bEaloXR1uw1Bcab+HtzMFE59sGoMHqvTqQEC2nGOdV2A8KXB
         yBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ogHA1ZvWrLQpcRlO6ydUCOI+bPrM3cHOqFMdk63saTE=;
        b=SMwpBqMRcvRXuSmzakWegIFhmfM2lHRhTHU5fO79yOPxn0l4pyK5bRB+XWUgr+4hlb
         2A+Gl7WHJL9SAFXvIhczqR4uRq43yYTCGpj6mh8xVkiitYPlX223SIy92l5mV5WhaBWq
         Awr7FIe4J+m5qSOa8ola0C/XjJDYYoyhxfaHIHDDAvaJQ+R5FTOfwWw7bqRtfpG0n0gl
         sfQY24b19fNxdD/2JXVhA6+7D2LxVJ8C+AnGZ331uezaJ2dP349Samx19kGXD5b3d/RS
         ouELu8q8dvI7vYWCYpWyMUTZGzWwxTW1HVUcr+4EhihvjQesNdUvV8EGJWj3Q5qbcgqf
         tuhA==
X-Gm-Message-State: APjAAAXVVF+Q2BJ0XXN1OfG/zCGM+li3+baht4VqDS1bho3feeWI+lp+
        5HT+8oIR47xcqhSB+oMVtgoUGguPiYSef8eT4y8=
X-Google-Smtp-Source: APXvYqy5uGg92HJxOavban+nljX1JC/YO3AvLNpT7UF+3/Z2/HnhWLNSosz9g+8htNo0SUMSp11A1XkBaO2klACGE98=
X-Received: by 2002:ac2:4152:: with SMTP id c18mr24887265lfi.144.1564184190975;
 Fri, 26 Jul 2019 16:36:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-3-brianvv@google.com>
 <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
 <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
 <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
 <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com>
 <20190725235432.lkptx3fafegnm2et@ast-mbp> <CABCgpaXE=dkBcJVqs95NZQTFuznA-q64kYPEcbvmYvAJ4wSp1A@mail.gmail.com>
 <CAADnVQJpp37fXLsu8ZnMFPoC0Uof3roz4gofX0QCewNkwtf-Xg@mail.gmail.com> <beb513cb-2d76-30d4-6500-2892c6566a7e@fb.com>
In-Reply-To: <beb513cb-2d76-30d4-6500-2892c6566a7e@fb.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Fri, 26 Jul 2019 16:36:19 -0700
Message-ID: <CABCgpaVB+iDGO132d9CTtC_GYiKJuuL6pe5_Krm3-THgvfMO=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 11:10 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/25/19 6:47 PM, Alexei Starovoitov wrote:
> > On Thu, Jul 25, 2019 at 6:24 PM Brian Vazquez <brianvv.kernel@gmail.com=
> wrote:
> >>
> >> On Thu, Jul 25, 2019 at 4:54 PM Alexei Starovoitov
> >> <alexei.starovoitov@gmail.com> wrote:
> >>>
> >>> On Thu, Jul 25, 2019 at 04:25:53PM -0700, Brian Vazquez wrote:
> >>>>>>> If prev_key is deleted before map_get_next_key(), we get the firs=
t key
> >>>>>>> again. This is pretty weird.
> >>>>>>
> >>>>>> Yes, I know. But note that the current scenario happens even for t=
he
> >>>>>> old interface (imagine you are walking a map from userspace and yo=
u
> >>>>>> tried get_next_key the prev_key was removed, you will start again =
from
> >>>>>> the beginning without noticing it).
> >>>>>> I tried to sent a patch in the past but I was missing some context=
:
> >>>>>> before NULL was used to get the very first_key the interface relie=
d in
> >>>>>> a random (non existent) key to retrieve the first_key in the map, =
and
> >>>>>> I was told what we still have to support that scenario.
> >>>>>
> >>>>> BPF_MAP_DUMP is slightly different, as you may return the first key
> >>>>> multiple times in the same call. Also, BPF_MAP_DUMP is new, so we
> >>>>> don't have to support legacy scenarios.
> >>>>>
> >>>>> Since BPF_MAP_DUMP keeps a list of elements. It is possible to try
> >>>>> to look up previous keys. Would something down this direction work?
> >>>>
> >>>> I've been thinking about it and I think first we need a way to detec=
t
> >>>> that since key was not present we got the first_key instead:
> >>>>
> >>>> - One solution I had in mind was to explicitly asked for the first k=
ey
> >>>> with map_get_next_key(map, NULL, first_key) and while walking the ma=
p
> >>>> check that map_get_next_key(map, prev_key, key) doesn't return the
> >>>> same key. This could be done using memcmp.
> >>>> - Discussing with Stan, he mentioned that another option is to suppo=
rt
> >>>> a flag in map_get_next_key to let it know that we want an error
> >>>> instead of the first_key.
> >>>>
> >>>> After detecting the problem we also need to define what we want to d=
o,
> >>>> here some options:
> >>>>
> >>>> a) Return the error to the caller
> >>>> b) Try with previous keys if any (which be limited to the keys that =
we
> >>>> have traversed so far in this dump call)
> >>>> c) continue with next entries in the map. array is easy just get the
> >>>> next valid key (starting on i+1), but hmap might be difficult since
> >>>> starting on the next bucket could potentially skip some keys that we=
re
> >>>> concurrently added to the same bucket where key used to be, and
> >>>> starting on the same bucket could lead us to return repeated element=
s.
> >>>>
> >>>> Or maybe we could support those 3 cases via flags and let the caller
> >>>> decide which one to use?
> >>>
> >>> this type of indecision is the reason why I wasn't excited about
> >>> batch dumping in the first place and gave 'soft yes' when Stan
> >>> mentioned it during lsf/mm/bpf uconf.
> >>> We probably shouldn't do it.
> >>> It feels this map_dump makes api more complex and doesn't really
> >>> give much benefit to the user other than large map dump becomes faste=
r.
> >>> I think we gotta solve this problem differently.
> >>
> >> Some users are working around the dumping problems with the existing
> >> api by creating a bpf_map_get_next_key_and_delete userspace function
> >> (see https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.bouncy=
bouncy.net_blog_bpf-5Fmap-5Fget-5Fnext-5Fkey-2Dpitfalls_&d=3DDwIBaQ&c=3D5VD=
0RTtNlTh3ycd41b3MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=3DXvNxqsDhRi62gzZ04HbLRTOF=
JX8X6mTuK7PZGn80akY&s=3D7q7beZxOJJ3Q0el8L0r-xDctedSpnEejJ6PVX1XYotQ&e=3D )
> >> which in my opinion is actually a good idea. The only problem with
> >> that is that calling bpf_map_get_next_key(fd, key, next_key) and then
> >> bpf_map_delete_elem(fd, key) from userspace is racing with kernel code
> >> and it might lose some information when deleting.
> >> We could then do map_dump_and_delete using that idea but in the kernel
> >> where we could better handle the racing condition. In that scenario
> >> even if we retrieve the same key it will contain different info ( the
> >> delta between old and new value). Would that work?
> >
> > you mean get_next+lookup+delete at once?
> > Sounds useful.
> > Yonghong has been thinking about batching api as well.
>
> In bcc, we have many instances like this:
>     getting all (key value) pairs, do some analysis and output,
>     delete all keys
>
> The implementation typically like
>     /* to get all (key, value) pairs */
>     while(bpf_get_next_key() =3D=3D 0)
>       bpf_map_lookup()
>     /* do analysis and output */
>     for (all keys)
>       bpf_map_delete()

If you do that in a map that is being modified while you are doing the
analysis and output, you will lose some new data by deleting the keys,
right?

> get_next+lookup+delete will be definitely useful.
> batching will be even better to save the number of syscalls.
>
> An alternative is to do batch get_next+lookup and batch delete
> to achieve similar goal as the above code.

What I mentioned above is what it makes me think that with the
deletion it'd be better if we perform these 3 operations at once:
get_next+lookup+delete in a jumbo/atomic command and batch them later?

>
> There is a minor difference between this approach
> and the above get_next+lookup+delete.
> During scanning the hash map, get_next+lookup may get less number
> of elements compared to get_next+lookup+delete as the latter
> may have more later-inserted hash elements after the operation
> start. But both are inaccurate, so probably the difference
> is minor.
>
> >
> > I think if we cannot figure out how to make a batch of two commands
> > get_next + lookup to work correctly then we need to identify/invent one
> > command and make batching more generic.
>
> not 100% sure. It will be hard to define what is "correctly".

I agree, it'll be hard to define what is the right behavior.

> For not changing map, looping of (get_next, lookup) and batch
> get_next+lookup should have the same results.

This is true for the api I'm presenting the only think that I was
missing was what to do for changing maps to avoid the weird scenario
(getting the first key due a concurrent deletion). And, in my opinion
the way to go should be what also Willem supported: return the err to
the caller and restart the dumping. I could do this with existing code
just by detecting that we do provide a prev_key and got the first_key
instead of the next_key or even implement a new function if you want
to.

> For constant changing loops, not sure how to define which one
> is correct. If users have concerns, they may need to just pick one
> which gives them more comfort.
>
> > Like make one jumbo/compound/atomic command to be get_next+lookup+delet=
e.
> > Define the semantics of this single compound command.
> > And then let batching to be a multiplier of such command.
> > In a sense that multiplier 1 or N should be have the same way.
> > No extra flags to alter the batching.
> > The high level description of the batch would be:
> > pls execute get_next,lookup,delete and repeat it N times.
> > or
> > pls execute get_next,lookup and repeat N times.

But any attempt to do get_next+lookup will have same problem with
deletions right?

I don't see how we could do it more consistent than what I'm
proposing. Let's just support one case: report an error if the
prev_key was not found instead of retrieving the first_key. Would that
work?

> > where each command action is defined to be composable.
> >
> > Just a rough idea.
> >
