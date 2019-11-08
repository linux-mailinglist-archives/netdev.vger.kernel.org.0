Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1025CF5BC0
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfKHXSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:18:01 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45718 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKHXSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:18:01 -0500
Received: by mail-pl1-f195.google.com with SMTP id y24so4833838plr.12;
        Fri, 08 Nov 2019 15:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=8LY+kAKStYocm9qGGdC5//bUkJulONkZ9dj6afcXb3I=;
        b=KaY2TysAPkma6bWHz/86sPTgLV84bhnvW3ihpCFR4bBkC4mzc+nCBxcPeDxw+y+96K
         Xxl8aaTyejGCALO6Egdu8s54hgL9nBX6x9oLL7GgnfQ6yKNBW5mQ8XiB48lfiFPQX8nn
         T66Fkr3QO7/+TH4epcoK1DQIhJU2NcQqP82pmdxlcojWz86QPGHqmZIt82rtZwgWRG+S
         8OYEMY/vwNu3yzP1J8YGgqyCrMrOlDWb8a9/tZYZETESVtY19LBuLgmbpfEmuis4/hXX
         mFI2IkFNMbym9FUBvLjwvWqoBjdFok5rCfPaEcxYvertvAf4NjuKBP+LAoiLsj6FexZq
         Mf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=8LY+kAKStYocm9qGGdC5//bUkJulONkZ9dj6afcXb3I=;
        b=k/CVo9HSsc7KiQYLpTV/By08BGM23ZcnSZw7wCeSnyPfPxIv9P09ulWm+TYEn29MbF
         8qP0IVtTO9vA40EsYOCXxcfvpHIVhV8rKSBNco0NclV8Vh3rSNJF71eZWxpmPdzcETRg
         tIQ75GZ2yEmf6kcibCid9p9qK+FYRIsiDdeySPPgcOo5i/k7RjtzMEZyTXVH3Erb6hLM
         2+Kp70j6NgCAGvz7Hud+WnK71m7ZjuAwDfJ6nkIPofOB6j8+XA7JAIbyuVWUfikJEhj7
         dJS3N8wHfwKAwTX31zV+oEfdgqUzs0B42ID4ZjgcvuywuOjGdQR2PX07Bo96nw2Nm4bi
         Z+hg==
X-Gm-Message-State: APjAAAVjAuaf2xierN9mrYUS8wvTI55+q3JPhNl8SsTU90eUgMSe6OSM
        V8sEcsCW5rTEoQyvJiPkNgE=
X-Google-Smtp-Source: APXvYqykHzVji+GQh1+cXWeDUkOWqMPcBv6zPaBwOXLMxoDXu4yfo2gGlI/1nILC4iReCAfHqkk0HA==
X-Received: by 2002:a17:902:8c92:: with SMTP id t18mr12975965plo.76.1573255080721;
        Fri, 08 Nov 2019 15:18:00 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:f248])
        by smtp.gmail.com with ESMTPSA id b200sm7263691pfb.86.2019.11.08.15.17.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 15:17:59 -0800 (PST)
Date:   Fri, 8 Nov 2019 15:17:58 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/6] libbpf: Propagate EPERM to caller on
 program load
Message-ID: <20191108231757.7egzqebli6gcplfq@ast-mbp.dhcp.thefacebook.com>
References: <157324878503.910124.12936814523952521484.stgit@toke.dk>
 <157324878850.910124.10106029353677591175.stgit@toke.dk>
 <CAEf4BzZxcvhZG-FHF+0iqia72q3YA0dCgsgFchibiW7dkFQm2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzZxcvhZG-FHF+0iqia72q3YA0dCgsgFchibiW7dkFQm2A@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 02:50:43PM -0800, Andrii Nakryiko wrote:
> On Fri, Nov 8, 2019 at 1:33 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >
> > From: Toke Høiland-Jørgensen <toke@redhat.com>
> >
> > When loading an eBPF program, libbpf overrides the return code for EPERM
> > errors instead of returning it to the caller. This makes it hard to figure
> > out what went wrong on load.
> >
> > In particular, EPERM is returned when the system rlimit is too low to lock
> > the memory required for the BPF program. Previously, this was somewhat
> > obscured because the rlimit error would be hit on map creation (which does
> > return it correctly). However, since maps can now be reused, object load
> > can proceed all the way to loading programs without hitting the error;
> > propagating it even in this case makes it possible for the caller to react
> > appropriately (and, e.g., attempt to raise the rlimit before retrying).
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > ---
> >  tools/lib/bpf/libbpf.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index cea61b2ec9d3..582c0fd16697 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -3721,7 +3721,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> >                 free(log_buf);
> >                 goto retry_load;
> >         }
> > -       ret = -LIBBPF_ERRNO__LOAD;
> > +       ret = (errno == EPERM) ? -errno : -LIBBPF_ERRNO__LOAD;

ouch. so libbpf was supressing all errnos for loading and that was a commit
from 2015. No wonder it's hard to debug. I grepped every where I could and it
doesn't look like anyone is using this code. There are other codes that can
come from sys_bpf(prog_load). Not sure why such decision was made back then. I
guess noone was really paying attention. I think we better propagate all codes.
I don't see why EPERM should be special.

