Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B4028A03E
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 13:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgJJLkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 07:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728942AbgJJKUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 06:20:02 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06461C0613E7;
        Sat, 10 Oct 2020 03:09:01 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id p13so11961871edi.7;
        Sat, 10 Oct 2020 03:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2u/FYiRZYg0jlbMYQJDVSfy4QaCXsq7tXWs5W7D5VoA=;
        b=M3Eumw0msG+svHWDgfMyn8t0lD/I/Ri7vS5SQmEPCz5fxCv2x1cHbxGWAc9APCShVr
         JyEN8UQu+DNlcMMaod7sN/1EIcWopAGAcixecB+9MVohiuBfN0qRvh7ywQ8TJcPwaZzs
         YGFtiR20V4L458PCs3BqVh0Zo5XXkZ8Q9J4pTSjxUZJTQQ9BMTRKHuDPsRrom5NwrwxX
         4ozR8TT4A8rcrGRioP+N7rchFL8txMPqP6idg9xAZbm+EUe04ItfXtXnf4IPYdMsaXru
         sSQRel37IqBfkJZJXjos6LZ9w222/F7KIcgJU8M7BvaM9mu8L4088Z5FRf41z3zIJEUF
         tOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2u/FYiRZYg0jlbMYQJDVSfy4QaCXsq7tXWs5W7D5VoA=;
        b=qjyEjiC2wbBDky7eH6HPH0Vp5pO3nCiXivnzUmDOHvM+YTFlm+n2obZrJ5yNCc2upu
         rAfUYam8/WlNe2DJc26uukTtIpjvpHmfU1ZTa3ScQzhmb8ia3X9Ow2DYG7jECCumLEVH
         rmhQqbKEU+hKor+/o59x1l7o827gOboc2EqcMBNcd5aJG7Sr13o9YZgSN70rp+So0g3c
         f+a8LsfhWMZa53RgzSTiZjh+Dq8PHnSjbhCx5Orm3az1OZg6ZnoHAiTF5N08CesQXKhc
         hKVBfufHN9HbsaFCafm2+P5ZtRzt3Ppm/19+cjhKGwag6VLUQI4Bwiziwtnp5NNi+HtM
         J6Ug==
X-Gm-Message-State: AOAM530cgZMiZXL+ZEvpO875JRX+/dP+YBF6In6wXhj+hH2Yo+RdonEl
        zPrCaolkKGwb1dYvY81seQSo6JByQ4IXNVme/qJg7j/0opAZ
X-Google-Smtp-Source: ABdhPJz8Qo4DZGrU8DHUc5b10nkKSIGd/ZuyqcqtpD0fWUdZgcaWDGoDt1qfQHQqyELaXkvm72rmue4ixWoMXVXM6Q8=
X-Received: by 2002:a50:cbc7:: with SMTP id l7mr3770872edi.148.1602324539440;
 Sat, 10 Oct 2020 03:08:59 -0700 (PDT)
MIME-Version: 1.0
References: <20201009160353.1529-1-danieltimlee@gmail.com> <20201009160353.1529-2-danieltimlee@gmail.com>
 <CAEf4BzYNF_BbwXM-HFFSk=ybJRdR=_P1OcVwxZ6dav6_b4BOWw@mail.gmail.com>
In-Reply-To: <CAEf4BzYNF_BbwXM-HFFSk=ybJRdR=_P1OcVwxZ6dav6_b4BOWw@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 10 Oct 2020 19:08:45 +0900
Message-ID: <CAEKGpzjcYCgOFCN2f4M-X-mnozTrcayp4jQVb6YB9cYE0M8F8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] samples: bpf: Refactor xdp_monitor with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 3:17 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 9:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > To avoid confusion caused by the increasing fragmentation of the BPF
> > Loader program, this commit would like to change to the libbpf loader
> > instead of using the bpf_load.
> >
> > Thanks to libbpf's bpf_link interface, managing the tracepoint BPF
> > program is much easier. bpf_program__attach_tracepoint manages the
> > enable of tracepoint event and attach of BPF programs to it with a
> > single interface bpf_link, so there is no need to manage event_fd and
> > prog_fd separately.
> >
> > This commit refactors xdp_monitor with using this libbpf API, and the
> > bpf_load is removed and migrated to libbpf.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/Makefile           |   2 +-
> >  samples/bpf/xdp_monitor_user.c | 144 ++++++++++++++++++++++++---------
> >  2 files changed, 108 insertions(+), 38 deletions(-)
> >
>
> [...]
>
> > +static int tp_cnt;
> > +static int map_cnt;
> >  static int verbose = 1;
> >  static bool debug = false;
> > +struct bpf_map *map_data[NUM_MAP] = { 0 };
> > +struct bpf_link *tp_links[NUM_TP] = { 0 };
>
> this syntax means "initialize *only the first element* to 0
> (explicitly) and the rest of elements to default (which is also 0)".
> So it's just misleading, use ` = {}`.
>

Thanks for the great review!

Come to think of it, it could be confusing as you mentioned. I will
remove the unnecessary initializer in the next patch and resend it.

> >
> >  static const struct option long_options[] = {
> >         {"help",        no_argument,            NULL, 'h' },
> > @@ -41,6 +65,15 @@ static const struct option long_options[] = {
> >         {0, 0, NULL,  0 }
> >  };
> >
> > +static void int_exit(int sig)
> > +{
> > +       /* Detach tracepoints */
> > +       while (tp_cnt)
> > +               bpf_link__destroy(tp_links[--tp_cnt]);
> > +
>
> see below about proper cleanup
>
> > +       exit(0);
> > +}
> > +
> >  /* C standard specifies two constants, EXIT_SUCCESS(0) and EXIT_FAILURE(1) */
> >  #define EXIT_FAIL_MEM  5
> >
>
> [...]
>
> >
> > -static void print_bpf_prog_info(void)
> > +static void print_bpf_prog_info(struct bpf_object *obj)
> >  {
> > -       int i;
> > +       struct bpf_program *prog;
> > +       struct bpf_map *map;
> > +       int i = 0;
> >
> >         /* Prog info */
> > -       printf("Loaded BPF prog have %d bpf program(s)\n", prog_cnt);
> > -       for (i = 0; i < prog_cnt; i++) {
> > -               printf(" - prog_fd[%d] = fd(%d)\n", i, prog_fd[i]);
> > +       printf("Loaded BPF prog have %d bpf program(s)\n", tp_cnt);
> > +       bpf_object__for_each_program(prog, obj) {
> > +               printf(" - prog_fd[%d] = fd(%d)\n", i++, bpf_program__fd(prog));
> >         }
> >
> > +       i = 0;
> >         /* Maps info */
> > -       printf("Loaded BPF prog have %d map(s)\n", map_data_count);
> > -       for (i = 0; i < map_data_count; i++) {
> > -               char *name = map_data[i].name;
> > -               int fd     = map_data[i].fd;
> > +       printf("Loaded BPF prog have %d map(s)\n", map_cnt);
> > +       bpf_object__for_each_map(map, obj) {
> > +               const char *name = bpf_map__name(map);
> > +               int fd           = bpf_map__fd(map);
> >
> > -               printf(" - map_data[%d] = fd(%d) name:%s\n", i, fd, name);
> > +               printf(" - map_data[%d] = fd(%d) name:%s\n", i++, fd, name);
>
> please move out increment into a separate statement, no need to
> confuse readers unnecessarily
>

I will fix it at the following patch.

> >         }
> >
> >         /* Event info */
> > -       printf("Searching for (max:%d) event file descriptor(s)\n", prog_cnt);
> > -       for (i = 0; i < prog_cnt; i++) {
> > -               if (event_fd[i] != -1)
> > -                       printf(" - event_fd[%d] = fd(%d)\n", i, event_fd[i]);
> > +       printf("Searching for (max:%d) event file descriptor(s)\n", tp_cnt);
> > +       for (i = 0; i < tp_cnt; i++) {
> > +               int fd = bpf_link__fd(tp_links[i]);
> > +
> > +               if (fd != -1)
> > +                       printf(" - event_fd[%d] = fd(%d)\n", i, fd);
> >         }
> >  }
> >
> >  int main(int argc, char **argv)
> >  {
>
> [...]
>
> > +       obj = bpf_object__open_file(filename, NULL);
> > +       if (libbpf_get_error(obj)) {
> > +               printf("ERROR: opening BPF object file failed\n");
> > +               obj = NULL;
> >                 return EXIT_FAILURE;
> >         }
> > -       if (!prog_fd[0]) {
> > -               printf("ERROR - load_bpf_file: %s\n", strerror(errno));
> > +
> > +       /* load BPF program */
> > +       if (bpf_object__load(obj)) {
>
> would be still good to call bpf_object__close(obj) here, this will
> avoid warnings about memory leaks, if you run this program under ASAN
>
> > +               printf("ERROR: loading BPF object file failed\n");
> >                 return EXIT_FAILURE;
> >         }
> >
> > +       for (type = 0; type < NUM_MAP; type++) {
> > +               map_data[type] =
> > +                       bpf_object__find_map_by_name(obj, map_type_strings[type]);
> > +
> > +               if (libbpf_get_error(map_data[type])) {
> > +                       printf("ERROR: finding a map in obj file failed\n");
>
> same about cleanup, goto into single cleanup place would be
> appropriate throughout this entire function, probably.
>

Jump to single cleanup will be much more intuitive.
I will update and send the next version of patch right away.

Thank you for your time and effort for the review.

Best,
Daniel

> > +                       return EXIT_FAILURE;
> > +               }
> > +               map_cnt++;
> > +       }
> > +
>
> [...]
