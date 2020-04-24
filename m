Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9023E1B7BA0
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 18:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgDXQah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 12:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgDXQah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 12:30:37 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF750C09B046;
        Fri, 24 Apr 2020 09:30:36 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b188so9158079qkd.9;
        Fri, 24 Apr 2020 09:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ZzasQ9UBNOPLs/Sla+yggbicACrTDAqurRFiQ25jz4=;
        b=ngkxfrtKDN13LuOlSwuy3rzVbQ0TuCjeG+j1ackauirq1HZDPgGmPlJrdxs8MNMqvV
         0JaTaWTUFT8HiKvaZR9TynZ2TSuU/6O/ZPIS+0lEeozCiMzhwTNFPbiBGR7+hsnI1ftE
         9dxLJe4+ZTD4Sv7qMstYiy3+gtBfEbWXBu9g31sR0/ENtuHYMPkxesIjcC6hL1hpGxvJ
         x1fQYG34zJr2Mi+J+UgK+C/fpy6ruZxZ9g4HCGNQ4F48/8JAmKe/YlIbsMMdv5pgOoes
         hEpd2g7x9+JI87fah22hSNYKjClnyEglAXmnSB0benZcQ0KOINCNxUwW+oltqXnVXUwD
         grLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ZzasQ9UBNOPLs/Sla+yggbicACrTDAqurRFiQ25jz4=;
        b=bEbPNRlfhtU0ALkKCwtpems++4wQAvQIRC/FmTgWk2cehPrb826BYxEg1O6hjoyKQk
         GV8gyrkr9vpz/vwsddAXs0u8zD3lyRNMHIcEHiW410jlecmS3uOB/DiuT1jHBEbefw1q
         tVjzrXhuVvyUoI5XL1fDufw0TcQA5/bjkngd1J14Q6r7xCTrqgcEb68VxG67myHTp+Zf
         CyT5jcG2xT/iET85Uv/gSjghPriiuJfRLamjYs/wLRh4v66rvqFgxKfpC7P3yTrMg+90
         +pQt4wjTkyu9C9g0kT/kRo6JAH8M+W8Rjwk32juGXISgtE+461pd4sN/ScfpzP/j3k8x
         89Jg==
X-Gm-Message-State: AGi0Puau6F2wCpaxNThL7GSwYI1Wxz5ab4mOyhc+fkbG6bZipjZbHAO5
        Bj4w2OWqllQRf2E3AXgNHASw5MMHq0AYsJCme20=
X-Google-Smtp-Source: APiQypKIudXTxINpyQ4bmsjLB0wKylpG7dzXzCxrR4LfWCwvvsJ8RBRw9EJbTJ0c0kqYj22/GNH/C6pSNhBL6Ui3Weo=
X-Received: by 2002:a37:787:: with SMTP id 129mr9680337qkh.92.1587745836056;
 Fri, 24 Apr 2020 09:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200424053505.4111226-1-andriin@fb.com> <20200424053505.4111226-9-andriin@fb.com>
 <3a5f1d73-f9f5-a640-6f15-d5202549d467@isovalent.com>
In-Reply-To: <3a5f1d73-f9f5-a640-6f15-d5202549d467@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Apr 2020 09:30:24 -0700
Message-ID: <CAEf4BzaxiB3osUqSm0LV6CKZDRgk7gLF8HfpUc9PyDsCWxhjJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/10] bpftool: add bpf_link show and pin support
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 3:32 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-04-23 22:35 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> > Add `bpftool link show` and `bpftool link pin` commands.
> >
> > Example plain output for `link show` (with showing pinned paths):
> >
> > [vmuser@archvm bpf]$ sudo ~/local/linux/tools/bpf/bpftool/bpftool -f link
> > 1: tracing  prog 12
> >         prog_type tracing  attach_type fentry
> >         pinned /sys/fs/bpf/my_test_link
> >         pinned /sys/fs/bpf/my_test_link2
> > 2: tracing  prog 13
> >         prog_type tracing  attach_type fentry
> > 3: tracing  prog 14
> >         prog_type tracing  attach_type fentry
> > 4: tracing  prog 15
> >         prog_type tracing  attach_type fentry
> > 5: tracing  prog 16
> >         prog_type tracing  attach_type fentry
> > 6: tracing  prog 17
> >         prog_type tracing  attach_type fentry
> > 7: raw_tracepoint  prog 21
> >         tp 'sys_enter'
> > 8: cgroup  prog 25
> >         cgroup_id 584  attach_type egress
> > 9: cgroup  prog 25
> >         cgroup_id 599  attach_type egress
> > 10: cgroup  prog 25
> >         cgroup_id 614  attach_type egress
> > 11: cgroup  prog 25
> >         cgroup_id 629  attach_type egress
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/common.c |   2 +
> >  tools/bpf/bpftool/link.c   | 402 +++++++++++++++++++++++++++++++++++++
> >  tools/bpf/bpftool/main.c   |   6 +-
> >  tools/bpf/bpftool/main.h   |   5 +
> >  4 files changed, 414 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/bpf/bpftool/link.c
> >
> > diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> > index f2223dbdfb0a..c47bdc65de8e 100644
> > --- a/tools/bpf/bpftool/common.c
> > +++ b/tools/bpf/bpftool/common.c
> > @@ -262,6 +262,8 @@ int get_fd_type(int fd)
> >               return BPF_OBJ_MAP;
> >       else if (strstr(buf, "bpf-prog"))
> >               return BPF_OBJ_PROG;
> > +     else if (strstr(buf, "bpf-link"))
> > +             return BPF_OBJ_LINK;
> >
> >       return BPF_OBJ_UNKNOWN;
> >  }
> > diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> > new file mode 100644
> > index 000000000000..d5dcf9e46536
> > --- /dev/null
> > +++ b/tools/bpf/bpftool/link.c
>
> [...]
>
> > +
> > +static int link_parse_fd(int *argc, char ***argv)
> > +{
> > +     int *fds = NULL;
> > +     int nb_fds, fd;
> > +
> > +     fds = malloc(sizeof(int));
> > +     if (!fds) {
> > +             p_err("mem alloc failed");
> > +             return -1;
> > +     }
> > +     nb_fds = link_parse_fds(argc, argv, &fds);
> > +     if (nb_fds != 1) {
> > +             if (nb_fds > 1) {
> > +                     p_err("several links match this handle");
>
> Can this ever happen? "bpftool prog show" has this because "name" or
> "tag" can match multiple programs. But "id" and "pinned" for link should
> not, as far as I understand.

No, it shouldn't. I'll keep only link_parse_fd and will always return
singe fd, thanks.

>
> > +                     while (nb_fds--)
> > +                             close(fds[nb_fds]);
> > +             }
> > +             fd = -1;
> > +             goto exit_free;
> > +     }
> > +
> > +     fd = fds[0];
> > +exit_free:
> > +     free(fds);
> > +     return fd;
> > +}
> > +
> > +static void
> > +show_link_header_json(struct bpf_link_info *info, json_writer_t *wtr)
> > +{
> > +     jsonw_uint_field(wtr, "id", info->id);
> > +     if (info->type < ARRAY_SIZE(link_type_name))
> > +             jsonw_string_field(wtr, "type", link_type_name[info->type]);
> > +     else
> > +             jsonw_uint_field(wtr, "type", info->type);
> > +
> > +     jsonw_uint_field(json_wtr, "prog_id", info->prog_id);
> > +}
> > +
> > +static int get_prog_info(int prog_id, struct bpf_prog_info *info)
> > +{
> > +     __u32 len = sizeof(*info);
> > +     int err, prog_fd;
> > +
> > +     prog_fd = bpf_prog_get_fd_by_id(prog_id);
> > +     if (prog_fd < 0)
> > +             return prog_fd;
> > +
> > +     memset(info, 0, sizeof(*info));
> > +     err = bpf_obj_get_info_by_fd(prog_fd, info, &len);
> > +     if (err) {
> > +             p_err("can't get prog info: %s", strerror(errno));
> > +             close(prog_fd);
> > +             return err;
>
> Nit: you could "return err;" at the end of the function, and remove the
> "close()" and "return" from this if block.

yep

>
> > +     }
> > +
> > +     close(prog_fd);
> > +     return 0;
> > +}
> > +
>
> [...]
>
> > +
> > +static int do_show_subset(int argc, char **argv)
> > +{
> > +     int *fds = NULL;
> > +     int nb_fds, i;
> > +     int err = -1;
> > +
> > +     fds = malloc(sizeof(int));
> > +     if (!fds) {
> > +             p_err("mem alloc failed");
> > +             return -1;
> > +     }
> > +     nb_fds = link_parse_fds(&argc, &argv, &fds);
> > +     if (nb_fds < 1)
> > +             goto exit_free;
> > +
> > +     if (json_output && nb_fds > 1)
> > +             jsonw_start_array(json_wtr);    /* root array */
> > +     for (i = 0; i < nb_fds; i++) {
> > +             err = do_show_link(fds[i]);
> > +             if (err) {
> > +                     for (; i + 1 < nb_fds; i++)
> > +                             close(fds[i]);
> > +                     break;
> > +             }
> > +     }
> > +     if (json_output && nb_fds > 1)
> > +             jsonw_end_array(json_wtr);      /* root array */
> > +
> > +exit_free:
> > +     free(fds);
> > +     return err;
> > +}
> > +
> > +static int do_show(int argc, char **argv)
> > +{
> > +     __u32 id = 0;
> > +     int err;
> > +     int fd;
> > +
> > +     if (show_pinned)
> > +             build_pinned_obj_table(&link_table, BPF_OBJ_LINK);
> > +
> > +     if (argc == 2)
> > +             return do_show_subset(argc, argv);
>
> I understand the "_subset" aspect was taken from prog.c. But it was
> added there (ec2025095cf6) because "bpftool prog show <name|tag>" can
> match several programs, and the array with fds would be reallocated as
> required while parsing names/tags.
>
> I do not think that by restricting the selection on "id" or "pinned",
> you can get more than one link at a time. So we can probably avoid
> juggling with fd arrays for link_parse_fd() / link_parse_fds() and show
> just the single relevant link.

yep, I did quite mechanical conversion of progs code to links, I'll do
another pass with this in mind. Thanks for review!
