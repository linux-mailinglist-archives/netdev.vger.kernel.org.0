Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261C075C83
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 03:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfGZBY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 21:24:29 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42352 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGZBY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 21:24:28 -0400
Received: by mail-lf1-f66.google.com with SMTP id s19so35895021lfb.9;
        Thu, 25 Jul 2019 18:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vTvW3XbCYgTeE8pWygrRyIgIzBcSDXdS++d8nqcWFaI=;
        b=irJ7wk40O2p8THkLaMmLB4N3DqHQwflkDSaXYoaHxWKIcd74rqCCYgHUOZASo4K447
         VatT2MvkxeDBeE4ZIhgXHULrprHr/fawvkUTSiYS3UeE8cpKe4RRn6g0kFnPYaURxkK4
         IUT1GbjePLqA5GPwSVxiPMmv91G5dAiK+rKN/A2mTsVnzadk7Ctlerg/DIaY1OEU+kg+
         7Zn8VieD9ITvpvNFBzZ/x3sP3WCyjjNE9orvoNadoIKL9Kon23JugiMfkuzr0CGTmFTz
         /a+cdc8ztlQXXELGsv7iRp9nOULifR4HSNPaC+yft+bfkUVXh9I+hE14nA3Y1FT3YEeO
         merg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vTvW3XbCYgTeE8pWygrRyIgIzBcSDXdS++d8nqcWFaI=;
        b=fTJK/nwN9JWUupvP8sxcW73sm000FQWF3mGbJFX/nMh+lMwOU/j0PD01p4PnKGjBW4
         idrO9/NW4ycPfgIm7Ain2qwIG/EGmrnAg2h2Otzw5JrdK4VRBNGXZEUEjpAJh1t6cSYi
         G4+PyBYu1GOGG1pqEIYsq4vdS+VdN3gp4xQoJEG8AMRJ3HDifojK1ff2eC2RVhcWGmXG
         QMumRsC8BOmTmaN/H5XdWh34LcrQ/gXkIvBPbVOcDIVnTKfKQezHPFslQkGk0I3p5/iH
         eXIUWIbUIw+RESubfgWm2zN5pLFmqvCjPeVAACMOE/XCy0LBg4fouuGF3ZpWmvhrj1xP
         PAtg==
X-Gm-Message-State: APjAAAW1PJ3brlGNqq77cREqpURcY3fasAcbnP0uR2PDZOWASldByt1C
        1UVqyGYjikcBJQ1MKBhIkg/JsfKzPwj2aOYHIxA=
X-Google-Smtp-Source: APXvYqw0x+VAo67CQrontp5Q8zI8+b84jKyrZTUTeaf/ufK14bUKOmdYsTSwCTZ90a3AOo9vfIPZDdp80bDWauepgXw=
X-Received: by 2002:ac2:4152:: with SMTP id c18mr21873691lfi.144.1564104265751;
 Thu, 25 Jul 2019 18:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-3-brianvv@google.com>
 <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
 <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
 <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
 <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com> <20190725235432.lkptx3fafegnm2et@ast-mbp>
In-Reply-To: <20190725235432.lkptx3fafegnm2et@ast-mbp>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Thu, 25 Jul 2019 18:24:14 -0700
Message-ID: <CABCgpaXE=dkBcJVqs95NZQTFuznA-q64kYPEcbvmYvAJ4wSp1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 4:54 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 25, 2019 at 04:25:53PM -0700, Brian Vazquez wrote:
> > > > > If prev_key is deleted before map_get_next_key(), we get the first key
> > > > > again. This is pretty weird.
> > > >
> > > > Yes, I know. But note that the current scenario happens even for the
> > > > old interface (imagine you are walking a map from userspace and you
> > > > tried get_next_key the prev_key was removed, you will start again from
> > > > the beginning without noticing it).
> > > > I tried to sent a patch in the past but I was missing some context:
> > > > before NULL was used to get the very first_key the interface relied in
> > > > a random (non existent) key to retrieve the first_key in the map, and
> > > > I was told what we still have to support that scenario.
> > >
> > > BPF_MAP_DUMP is slightly different, as you may return the first key
> > > multiple times in the same call. Also, BPF_MAP_DUMP is new, so we
> > > don't have to support legacy scenarios.
> > >
> > > Since BPF_MAP_DUMP keeps a list of elements. It is possible to try
> > > to look up previous keys. Would something down this direction work?
> >
> > I've been thinking about it and I think first we need a way to detect
> > that since key was not present we got the first_key instead:
> >
> > - One solution I had in mind was to explicitly asked for the first key
> > with map_get_next_key(map, NULL, first_key) and while walking the map
> > check that map_get_next_key(map, prev_key, key) doesn't return the
> > same key. This could be done using memcmp.
> > - Discussing with Stan, he mentioned that another option is to support
> > a flag in map_get_next_key to let it know that we want an error
> > instead of the first_key.
> >
> > After detecting the problem we also need to define what we want to do,
> > here some options:
> >
> > a) Return the error to the caller
> > b) Try with previous keys if any (which be limited to the keys that we
> > have traversed so far in this dump call)
> > c) continue with next entries in the map. array is easy just get the
> > next valid key (starting on i+1), but hmap might be difficult since
> > starting on the next bucket could potentially skip some keys that were
> > concurrently added to the same bucket where key used to be, and
> > starting on the same bucket could lead us to return repeated elements.
> >
> > Or maybe we could support those 3 cases via flags and let the caller
> > decide which one to use?
>
> this type of indecision is the reason why I wasn't excited about
> batch dumping in the first place and gave 'soft yes' when Stan
> mentioned it during lsf/mm/bpf uconf.
> We probably shouldn't do it.
> It feels this map_dump makes api more complex and doesn't really
> give much benefit to the user other than large map dump becomes faster.
> I think we gotta solve this problem differently.

Some users are working around the dumping problems with the existing
api by creating a bpf_map_get_next_key_and_delete userspace function
(see https://www.bouncybouncy.net/blog/bpf_map_get_next_key-pitfalls/)
which in my opinion is actually a good idea. The only problem with
that is that calling bpf_map_get_next_key(fd, key, next_key) and then
bpf_map_delete_elem(fd, key) from userspace is racing with kernel code
and it might lose some information when deleting.
We could then do map_dump_and_delete using that idea but in the kernel
where we could better handle the racing condition. In that scenario
even if we retrieve the same key it will contain different info ( the
delta between old and new value). Would that work?
