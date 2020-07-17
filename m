Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7EB224672
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 00:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgGQWnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 18:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgGQWnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 18:43:11 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9E4C0619D2;
        Fri, 17 Jul 2020 15:43:11 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a11so8684761ilk.0;
        Fri, 17 Jul 2020 15:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pl21wauD38yJ3NuJ/i83+NlmCTSuF0IOOGhkqkFh7Do=;
        b=FX5B3WP0n8hQ/R19hqZo+xjYpF6glFQkdMeL4IMVvjnpFQmbZYJcTBRV5NxV8E5k3z
         dI4mSuVvmcpnkHe1vLgk34iD2mlnbfflY9QvXN7CFwpQeZAbaaQ0jtex4ddFzPv/z8V3
         4/XaiU87QsOk30IpfytN1s/tzO5Q3JkE2zijh1h/O3siKT392mkQ7oRwvnB6YqNY7vv8
         29OcQBbh2aFdfrJcRKhNbRggToDUFBVSjVhYICxgiRJuCnQ4nvv7syUPdg9Swyaq4zRf
         +jXpTWZvcR+EPVxMMDvF0y0NR0VAIUsB45ck1JES4O/l88Qj6tv9s/ZDOFFAq5cd0od6
         IjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pl21wauD38yJ3NuJ/i83+NlmCTSuF0IOOGhkqkFh7Do=;
        b=IdHQ8xo/gsXIFbNqJT8O16Ok0w0Ac76nvcqWPZXNR98sZa7qVFjzHxCWR3zmY2C1eI
         4Gbbr4/Ku0nttFkfGYt9QKj4dhW/B/CTkGutzMGXfo7TV479NAiggMuPAkTF51uemf0h
         SyGyu2aA52fzFjnq1B2kyVZaJloLqvu1jDAQxIoDaIYOR51K+BdUPHcQUZ6RApjjXbpU
         aQMCHIn+uz+uAWOnANp9kQzXNoAUVwEFersIVF49J4wGwM0MQVET2ddV5AjsPeDRJvKI
         hUKgXv/ZMiz/hpN9wubH7r5GaX6MiskxADXfrMrdCRakSAWEXdylEkowL5FVZH2VNlDP
         LyvA==
X-Gm-Message-State: AOAM530WUBoGRiqcfrlMNA00NxEkQ8SLhg4slGRIYvZ5XfgssTus1V29
        Wlhb/QDJuylJcMd3HTPXTJ6kIp5MHW+R5eVoo5acA8xvOrU2gw==
X-Google-Smtp-Source: ABdhPJxwv/RkbhKnctnRKQNFXQwBsTmVJUvXssSWfmvKpu9776YGaVMmYqN0HBdovW4uQ+D0bs8LXQ/Mp+WhGRDZw8Y=
X-Received: by 2002:a05:6e02:1313:: with SMTP id g19mr11064962ilr.123.1595025790241;
 Fri, 17 Jul 2020 15:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200716052926.10933-1-Tony.Ambardar@gmail.com> <9560214f-6505-3810-710c-2216648d5bab@isovalent.com>
In-Reply-To: <9560214f-6505-3810-710c-2216648d5bab@isovalent.com>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Fri, 17 Jul 2020 15:43:00 -0700
Message-ID: <CAPGftE-xoqyYtm0PDZa=Eo=uERbDoMBUGm9P++z4L_O3Mdakug@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpftool: use only nftw for file tree parsing
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 at 02:14, Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-07-15 22:29 UTC-0700 ~ Tony Ambardar <tony.ambardar@gmail.com>
> > The bpftool sources include code to walk file trees, but use multiple
> > frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 and
> > is widely available, fts is not conformant and less common, especially on
> > non-glibc systems. The inconsistent framework usage hampers maintenance
> > and portability of bpftool, in particular for embedded systems.
> >
> > Standardize code usage by rewriting one fts-based function to use nftw.
> > Clean up related function warnings by using "const char *" arguments and
> > fixing an unsafe call to dirname().
> >
> > These changes help in building bpftool against musl for OpenWrt.
>
> Could you please add a line to the log about the reason for the path
> copy in open_obj_pinned()?

Good point, will do.

> >
> > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> > ---
> >
> > V2:
> > * use _GNU_SOURCE to pull in getpagesize(), getline(), nftw() definitions
> > * use "const char *" in open_obj_pinned() and open_obj_pinned_any()
> > * make dirname() safely act on a string copy
> >
> > ---
> >  tools/bpf/bpftool/common.c | 129 +++++++++++++++++++++----------------
> >  tools/bpf/bpftool/main.h   |   4 +-
> >  2 files changed, 76 insertions(+), 57 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> > index 29f4e7611ae8..7c2e52fc5784 100644
> > --- a/tools/bpf/bpftool/common.c
> > +++ b/tools/bpf/bpftool/common.c
> > @@ -1,10 +1,11 @@
> >  // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >  /* Copyright (C) 2017-2018 Netronome Systems, Inc. */
> >
> > +#define _GNU_SOURCE
> >  #include <ctype.h>
> >  #include <errno.h>
> >  #include <fcntl.h>
> > -#include <fts.h>
> > +#include <ftw.h>
> >  #include <libgen.h>
> >  #include <mntent.h>
> >  #include <stdbool.h>
> > @@ -160,24 +161,36 @@ int mount_tracefs(const char *target)
> >       return err;
> >  }
> >
> > -int open_obj_pinned(char *path, bool quiet)
> > +int open_obj_pinned(const char *path, bool quiet)
> >  {
> > -     int fd;
> > +     char *pname;
> > +     int fd = -1;
> > +
> > +     pname = strdup(path);
> > +     if (pname == NULL) {
>
> Simply "if (!pname) {"
>
> > +             if (!quiet)
> > +                     p_err("bpf obj get (%s): %s", path, strerror(errno));
>
> Please update the error message, this one was for a failure on
> bpf_obj_get().
>
> > +             goto out_ret;
> > +     }
> > +
>
> You're adding a second blank line here, please fix.
>
> >
> > -     fd = bpf_obj_get(path);
> > +     fd = bpf_obj_get(pname);
> >       if (fd < 0) {
> >               if (!quiet)
> > -                     p_err("bpf obj get (%s): %s", path,
> > -                           errno == EACCES && !is_bpffs(dirname(path)) ?
> > +                     p_err("bpf obj get (%s): %s", pname,
> > +                           errno == EACCES && !is_bpffs(dirname(pname)) ?
> >                           "directory not in bpf file system (bpffs)" :
> >                           strerror(errno));
> > -             return -1;
> > +             goto out_free;
> >       }
> >
> > +out_free:
> > +     free(pname);
> > +out_ret:
> >       return fd;
> >  }
> >
> > -int open_obj_pinned_any(char *path, enum bpf_obj_type exp_type)
> > +int open_obj_pinned_any(const char *path, enum bpf_obj_type exp_type)
> >  {
> >       enum bpf_obj_type type;
> >       int fd;
> > @@ -367,68 +380,74 @@ void print_hex_data_json(uint8_t *data, size_t len)
> >       jsonw_end_array(json_wtr);
> >  }
> >
> > -int build_pinned_obj_table(struct pinned_obj_table *tab,
> > -                        enum bpf_obj_type type)
> > +static struct pinned_obj_table *build_fn_table; /* params for nftw cb*/
> > +static enum bpf_obj_type build_fn_type;
>
> I would move the comments above the lines, since it applies to both of them.
>
> > +
> > +static int do_build_table_cb(const char *fpath, const struct stat *sb,
> > +                         int typeflag, struct FTW *ftwbuf)
>
> Please align the second line on the open parenthesis.
>
> >  {
> >       struct bpf_prog_info pinned_info = {};
>
> A few suggestions on this code, even though I realise you simply moved
> some parts. We can skip zero-initialising here (" = {}") because we
> memset() it below before using it anyway.
>
> >       struct pinned_obj *obj_node = NULL;
> >       __u32 len = sizeof(pinned_info);
> > -     struct mntent *mntent = NULL;
> >       enum bpf_obj_type objtype;
> > +     int fd, err = 0;
> > +
> > +     if (typeflag != FTW_F)
> > +             goto out_ret;
> > +     fd = open_obj_pinned(fpath, true);
> > +     if (fd < 0)
> > +             goto out_ret;
> > +
> > +     objtype = get_fd_type(fd);
> > +     if (objtype != build_fn_type)
> > +             goto out_close;
> > +
> > +     memset(&pinned_info, 0, sizeof(pinned_info));
> > +     if (bpf_obj_get_info_by_fd(fd, &pinned_info, &len)) {
> > +             p_err("can't get obj info: %s", strerror(errno));
>
> We are simply building a table here to show the paths where objects are
> pinned when listing progs/maps/etc., and I don't believe we want to
> print an error in that case. And with such a message I would expect the
> function to return and bpftool to stop, but again I don't believe this
> is necessary here and we can just go on listing objects, even if we fail
> to show their pinned paths.
>
> > +             goto out_close;
> > +     }
> > +
> > +     obj_node = malloc(sizeof(*obj_node));
> > +     if (!obj_node) {
> > +             p_err("mem alloc failed");
>
> Same here, let's not add an error message.

You're right. I just realized those aren't pre-existing messages; I
added them but then forgot.

> > +             err = -1;
> > +             goto out_close;
> > +     }
> > +
> > +     memset(obj_node, 0, sizeof(*obj_node));
>
> Instead of malloc() + memset(), we could simply use calloc().
>
> > +     obj_node->id = pinned_info.id;
> > +     obj_node->path = strdup(fpath);

I should check for failed allocation here too.

> > +     hash_add(build_fn_table->table, &obj_node->hash, obj_node->id);
> > +
> > +out_close:
> > +     close(fd);
> > +out_ret:
> > +     return err;
> > +}
> > +
> > +int build_pinned_obj_table(struct pinned_obj_table *tab,
> > +                        enum bpf_obj_type type)
> > +{
>
> The end looks good.
>
> Apart from the minor points mentioned above, the patch is good, copying
> the string in open_obj_pinned() looks like the right approach. It does
> compile (with no warnings) and works as intended on my machine :).

Glad to hear it! I'll update the patch based on your comments above
and resend shortly. Thanks again for the testing and feedback.

Regards,
Tony

> Thanks,
> Quentin
