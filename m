Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436115321B0
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 05:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiEXDp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 23:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbiEXDp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 23:45:27 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB0B6338F;
        Mon, 23 May 2022 20:45:26 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id q203so17285193iod.0;
        Mon, 23 May 2022 20:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ysIS0Tt0K4W8AV65ouRIRmYl1i3pZ2R4+xXfnJStB8=;
        b=EGZdwTIuuISC0Kp4FbhAKOQXJCOSgj8PP60JTQKkDR5we0D5Y+Wr/H+WODB8wJ26O+
         vkSj6bf04ugwgmYNKLasn/s8ZZm7SD2bNpRpGIDq7LSg/4ipN2+JS7p1S2dngaCYxx6l
         6jiQNIXnc/QtjqB25oVC8ZMjMLPoWnfzFQ1bDUkiXjR5PcilYDYl3ypMBifOET/sd8UU
         oocxgnRKsEQZOhPCAK87M7h0Qy4dWkxaH+cNsKPbUwmnY5d9MdQGOMMul3nwpfqjt3Y/
         zPjV9C8x5GCxPaOhAOaN/O1YK6JX3dRgx0lwi9uKWyfUswwG4hSFbjJ/ANWVoY6+9J+P
         D2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ysIS0Tt0K4W8AV65ouRIRmYl1i3pZ2R4+xXfnJStB8=;
        b=NuPHjbZtaZaSUNRDTSDmc39ceS06yyHNduemOlVXsheP0JIGGviCIolS3AhhpOqaHV
         EVVfAJ/E+FQgUe9Q1oIx9uQK3hmJVDuS2HPFlr9qAMWZ+07XAu0d9SRVLpb91Vs+4xf4
         GN2FMHYHShRZ7SKoivMz8/ZWrowUQp+s8dRfnlUpr0IDUoWH9Yibjr4yTPB33wtmJApG
         75jNeSVIht/m8mlzngbmz1fOWtQMUDJcslmtO1uAYrZvGfsxfqGK1iX1lL9r74ofhw72
         ApuVXatdMj4H8rT/zXrcOHxAijSK3PJ6Id0Gh+UaEkemFqXe1BHw8X6jtS/j8u2XF2Em
         vX3w==
X-Gm-Message-State: AOAM530a5Bb1unITRu0hV/chwkAznGUTnWgoZqIZ7PEUSiRUBd21HMiB
        ohXnCoKQ3dk5tSkxnkyjGZxfuzUZnQXyUsx3oBF7L2T4
X-Google-Smtp-Source: ABdhPJyRbVnp8bYqnN1zbCsf/QHPrbv08dnr8m7UschXfuyLgilCW3AQfU5fT8ssyDfzkELGiLPvQ5Ed0ibHxYmNF10=
X-Received: by 2002:a05:6638:33a1:b0:32b:8e2b:f9ba with SMTP id
 h33-20020a05663833a100b0032b8e2bf9bamr12852683jav.93.1653363925762; Mon, 23
 May 2022 20:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-8-sdf@google.com>
 <CAEf4BzaYx9EdabuxjLsN4HKTcq+EfwRzpAYdY-D+74YOTpr4Yg@mail.gmail.com> <CAKH8qBs7YE26=ecmn6xdjTC-5-NFMP_-=qkuKtRUDjzeqMTWcg@mail.gmail.com>
In-Reply-To: <CAKH8qBs7YE26=ecmn6xdjTC-5-NFMP_-=qkuKtRUDjzeqMTWcg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 20:45:13 -0700
Message-ID: <CAEf4BzZrykLnBc_uqfjDbh_a=6VZnMKz5+UQWiORXkiJqNFoBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 07/11] libbpf: implement bpf_prog_query_opts
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 7:15 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Mon, May 23, 2022 at 4:22 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, May 18, 2022 at 3:55 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Implement bpf_prog_query_opts as a more expendable version of
> > > bpf_prog_query. Expose new prog_attach_flags and attach_btf_func_id as
> > > well:
> > >
> > > * prog_attach_flags is a per-program attach_type; relevant only for
> > >   lsm cgroup program which might have different attach_flags
> > >   per attach_btf_id
> > > * attach_btf_func_id is a new field expose for prog_query which
> > >   specifies real btf function id for lsm cgroup attachments
> > >
> >
> > just thoughts aloud... Shouldn't bpf_prog_query() also return link_id
> > if the attachment was done with LINK_CREATE? And then attach flags
> > could actually be fetched through corresponding struct bpf_link_info.
> > That is, bpf_prog_query() returns a list of link_ids, and whatever
> > link-specific information can be fetched by querying individual links.
> > Seems more logical (and useful overall) to extend struct bpf_link_info
> > (you can get it more generically from bpftool, by querying fdinfo,
> > etc).
>
> Note that I haven't removed non-link-based APIs because they are easy
> to support. That might be an argument in favor of dropping them.
> Regarding the implementation: I'm not sure there is an easy way, in
> the kernel, to find all links associated with a given bpf_prog?

Nope, kernel doesn't keep track of this explicitly, in general. If you
were building a tool for something like that you'd probably use
bpf_link iterator program which we recently added. But in this case
kernel knows links that are attached to cgroups (they are in
prog_item->link if it's not NULL), so you shouldn't need any extra
information.

>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  tools/include/uapi/linux/bpf.h |  5 ++++
> > >  tools/lib/bpf/bpf.c            | 42 +++++++++++++++++++++++++++-------
> > >  tools/lib/bpf/bpf.h            | 15 ++++++++++++
> > >  tools/lib/bpf/libbpf.map       |  1 +
> > >  4 files changed, 55 insertions(+), 8 deletions(-)
> > >
> >
> > [...]
> >
> > >         ret = sys_bpf(BPF_PROG_QUERY, &attr, sizeof(attr));
> > >
> > > -       if (attach_flags)
> > > -               *attach_flags = attr.query.attach_flags;
> > > -       *prog_cnt = attr.query.prog_cnt;
> > > +       if (OPTS_HAS(opts, prog_cnt))
> > > +               opts->prog_cnt = attr.query.prog_cnt;
> >
> > just use OPTS_SET() instead of OPTS_HAS check
>
> Ah, definitely, for some reason I thought that these are "output"
> arguments and OPT_SET won't work for them.
>
> > > +       if (OPTS_HAS(opts, attach_flags))
> > > +               opts->attach_flags = attr.query.attach_flags;
> > >
> > >         return libbpf_err_errno(ret);
> > >  }
> > >
> >
> > [...]
> >
> > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > index 6b36f46ab5d8..24f7a5147bf2 100644
> > > --- a/tools/lib/bpf/libbpf.map
> > > +++ b/tools/lib/bpf/libbpf.map
> > > @@ -452,6 +452,7 @@ LIBBPF_0.8.0 {
> > >                 bpf_map_delete_elem_flags;
> > >                 bpf_object__destroy_subskeleton;
> > >                 bpf_object__open_subskeleton;
> > > +               bpf_prog_query_opts;
> >
> > please put it into LIBBPF_1.0.0 section, 0.8 is closed now
>
> Definitely, will pull new changes and put them into proper place.
>
> Thank you for your review!
