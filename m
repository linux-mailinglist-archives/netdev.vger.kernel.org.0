Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED3D05A2B0
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfF1Rpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:45:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44406 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfF1Rpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:45:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id t7so3618103plr.11
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1Yi6cC2ImLjeEVWi1JuOhFeAoSHATbkcuixifmhPnYs=;
        b=gmStBag0+4nvAbPtCe7omnAMsNY5yRDJ46Fd0VT3GwqqtYBhTmOmlT36z6IV5gcsFi
         O5tih95sPdnyrQb1Tj3G9nwYm+6Yg4l8OPjWSrOgwQp1Mlxl2XH9BU4TD6MOD/AeAHn+
         sKLiAtr55tEFXSj/nNqnav3Wk7r3fc2vATiYWz8vajTyqFy9AJ5aWR/LkkmPZ3hOY9WZ
         qIAPllRyl0UG4CM5FLvffbhldn2/mkGFL0xFajIKnUMmvUbWN6lVWFL3bXKAedrWL/we
         xX8kDvHtdUxDZgZq4W1ouwal4adlYVg7dCKKCFSaxPe1OOegsZ7qJ7yeUBExp6ZZ2QOp
         SFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Yi6cC2ImLjeEVWi1JuOhFeAoSHATbkcuixifmhPnYs=;
        b=aGscXDQqdL5a6CGdpF69nmOsnQC9/624r9HJrKX6fAE/Dqn0/VxYs0Ul7tcj8VKVLR
         p1n9aldcoL1Q8RLvruZrfdzx8C3Q2B5t0NxdYZ8RaG1RJMKz8D3poRdSD2JAxAmiyNNe
         m4+yGSLo3pYVBv0WqfZzRXlcTjIuBKYHqMWFJ8waQRr0S1k29ron4bil+kMGp4uADm7O
         S3ADV9VpF6E4g+RV7zJ+l/A+fYSd6qfjso+aYgO8nFzGHdO5pgskWmh0drMdKtu/DMW1
         P9RxK/4GdU05shh+KVNACZRCjQT55pixISzQA7lBySSnQp1VTk0N0sDe2YDR99CWbCWl
         tH9w==
X-Gm-Message-State: APjAAAWuDTTCT3tb5E0J35MN2/hxxdUvnFOYYwAWSe9Zg5y6E9D5bEeq
        Ulxfreav1W4IVqLxs4uBLqwJGw==
X-Google-Smtp-Source: APXvYqzKUF44Ry6FOh3etKOYVZLNfuf2mRuyikS1fJ1T/SJAUN1UGJx48K2XiksAueoMZp2Ikw68Ow==
X-Received: by 2002:a17:902:86:: with SMTP id a6mr13159004pla.244.1561743935310;
        Fri, 28 Jun 2019 10:45:35 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s16sm2828387pfm.26.2019.06.28.10.45.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 10:45:34 -0700 (PDT)
Date:   Fri, 28 Jun 2019 10:45:33 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/9] libbpf: introduce concept of bpf_link
Message-ID: <20190628174533.GI4866@mini-arch>
References: <20190628055303.1249758-1-andriin@fb.com>
 <20190628055303.1249758-3-andriin@fb.com>
 <20190628160230.GG4866@mini-arch>
 <CAEf4BzbB6G5jTvS+K0+0zPXWLFmAePHU2RtALogWrh7h7OV03A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbB6G5jTvS+K0+0zPXWLFmAePHU2RtALogWrh7h7OV03A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28, Andrii Nakryiko wrote:
> On Fri, Jun 28, 2019 at 9:02 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 06/27, Andrii Nakryiko wrote:
> > > bpf_link is and abstraction of an association of a BPF program and one
> > > of many possible BPF attachment points (hooks). This allows to have
> > > uniform interface for detaching BPF programs regardless of the nature of
> > > link and how it was created. Details of creation and setting up of
> > > a specific bpf_link is handled by corresponding attachment methods
> > > (bpf_program__attach_xxx) added in subsequent commits. Once successfully
> > > created, bpf_link has to be eventually destroyed with
> > > bpf_link__destroy(), at which point BPF program is disassociated from
> > > a hook and all the relevant resources are freed.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c   | 17 +++++++++++++++++
> > >  tools/lib/bpf/libbpf.h   |  4 ++++
> > >  tools/lib/bpf/libbpf.map |  3 ++-
> > >  3 files changed, 23 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 6e6ebef11ba3..455795e6f8af 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -3941,6 +3941,23 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
> > >       return 0;
> > >  }
> > >
> > > +struct bpf_link {
> > Maybe call it bpf_attachment? You call the bpf_program__attach_to_blah
> > and you get an attachment?
> 
> I wanted to keep it as short as possible, bpf_attachment is way too
> long (it's also why as an alternative I've proposed bpf_assoc, not
> bpf_association, but bpf_attach isn't great shortening).
Why do you want to keep it short? We have far longer names than
bpf_attachment in libbpf. That shouldn't be a big concern.

> > > +     int (*destroy)(struct bpf_link *link);
> > > +};
> > > +
> > > +int bpf_link__destroy(struct bpf_link *link)
> > > +{
> > > +     int err;
> > > +
> > > +     if (!link)
> > > +             return 0;
> > > +
> > > +     err = link->destroy(link);
> > > +     free(link);
> > > +
> > > +     return err;
> > > +}
> > > +
> > >  enum bpf_perf_event_ret
> > >  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> > >                          void **copy_mem, size_t *copy_size,
> > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > index d639f47e3110..5082a5ebb0c2 100644
> > > --- a/tools/lib/bpf/libbpf.h
> > > +++ b/tools/lib/bpf/libbpf.h
> > > @@ -165,6 +165,10 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *path);
> > >  LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *path);
> > >  LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
> > >
> > > +struct bpf_link;
> > > +
> > > +LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> > > +
> > >  struct bpf_insn;
> > >
> > >  /*
> > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > index 2c6d835620d2..3cde850fc8da 100644
> > > --- a/tools/lib/bpf/libbpf.map
> > > +++ b/tools/lib/bpf/libbpf.map
> > > @@ -167,10 +167,11 @@ LIBBPF_0.0.3 {
> > >
> > >  LIBBPF_0.0.4 {
> > >       global:
> > > +             bpf_link__destroy;
> > > +             bpf_object__load_xattr;
> > >               btf_dump__dump_type;
> > >               btf_dump__free;
> > >               btf_dump__new;
> > >               btf__parse_elf;
> > > -             bpf_object__load_xattr;
> > >               libbpf_num_possible_cpus;
> > >  } LIBBPF_0.0.3;
> > > --
> > > 2.17.1
> > >
