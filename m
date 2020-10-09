Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC2D2890A9
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390113AbgJISRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731198AbgJISRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:17:22 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C817CC0613D2;
        Fri,  9 Oct 2020 11:17:21 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a2so7943339ybj.2;
        Fri, 09 Oct 2020 11:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2A4GHZUQvsEFe8vZOiAopDAq7iEcT1h3rDJD6CjEonM=;
        b=mHKcfraJKbOFTypRjQObWnL60qTX77sT6K03hjOSjXvikvL+0tF4TygJTSwupt9xNR
         llow8z0lQft9M3+6xWlQe+FLrJVd+S8m57fTShIAvpbu5sja8Ui4sZFF8wpdgjaWL0Mt
         lp7eevJgKlSwUw3S4ZZtFoTcNMFqA7qaTLEFJyz9RzIaIh2FaaR0oHOYy6tza9n9FknP
         gR14YITlYvq/o+82gZKA6IrWdlxGkrvr9z+5fy4CVhlJbwbNBpphrma7kA2yV2c9jPnR
         IozIOcPEblOx34u5/Zf/nxMgYFt1lOrI8SMOfgZ0iOjM4Le+ORAIv5Id+NSGqFlgbmPh
         Pydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2A4GHZUQvsEFe8vZOiAopDAq7iEcT1h3rDJD6CjEonM=;
        b=RfeebjwtCMMlN/mv4WBDeedvluSL898H7KBUeuhOOnyiK0ic4mxv0nVeok1hFYH0sD
         b4Plp6YzA3Udqp21GkKribdrlGDxz03Ia1iVqWvETZqGUzghmqm3Sbs2eozto4HfOF4/
         c2JSRrtjr4qsTErijeXNlalsLFq4LRmWRODXxsT9WNnKFCM30/JwGh9mhFbZLqRSnP+b
         UBLA6WklEladHD6yY7HOal5yMrc7nck3kyLO+EP1ddLSa8fG0wYfTxTnZ/Skq4ZZgWfY
         13TqTlJ2cPUtVipF8i1a85H1BmHs8BDgh0WuMjjBosoLgNDzBhz8YTWI8imY+j0bOpvn
         ViqQ==
X-Gm-Message-State: AOAM532/kcx7N9MiTQWyDiTMXVBoG59fXnFM7kKNYZ7k8MoY1GefQZSG
        VG5twbyE0Uf3B4IrqUcL3gqAKx2GC6i9v9yRcn0=
X-Google-Smtp-Source: ABdhPJwFVWrSiYClcqO0bEh/a5pa12z9aQC9nUVJWsP63dLTmkpQ+HLIsh71KW+xitqlV3hnMRYmz5uLKctpD5SqaPU=
X-Received: by 2002:a25:cbc4:: with SMTP id b187mr20003460ybg.260.1602267440914;
 Fri, 09 Oct 2020 11:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201009160353.1529-1-danieltimlee@gmail.com> <20201009160353.1529-2-danieltimlee@gmail.com>
In-Reply-To: <20201009160353.1529-2-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Oct 2020 11:17:10 -0700
Message-ID: <CAEf4BzYNF_BbwXM-HFFSk=ybJRdR=_P1OcVwxZ6dav6_b4BOWw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] samples: bpf: Refactor xdp_monitor with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
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

On Fri, Oct 9, 2020 at 9:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> To avoid confusion caused by the increasing fragmentation of the BPF
> Loader program, this commit would like to change to the libbpf loader
> instead of using the bpf_load.
>
> Thanks to libbpf's bpf_link interface, managing the tracepoint BPF
> program is much easier. bpf_program__attach_tracepoint manages the
> enable of tracepoint event and attach of BPF programs to it with a
> single interface bpf_link, so there is no need to manage event_fd and
> prog_fd separately.
>
> This commit refactors xdp_monitor with using this libbpf API, and the
> bpf_load is removed and migrated to libbpf.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile           |   2 +-
>  samples/bpf/xdp_monitor_user.c | 144 ++++++++++++++++++++++++---------
>  2 files changed, 108 insertions(+), 38 deletions(-)
>

[...]

> +static int tp_cnt;
> +static int map_cnt;
>  static int verbose = 1;
>  static bool debug = false;
> +struct bpf_map *map_data[NUM_MAP] = { 0 };
> +struct bpf_link *tp_links[NUM_TP] = { 0 };

this syntax means "initialize *only the first element* to 0
(explicitly) and the rest of elements to default (which is also 0)".
So it's just misleading, use ` = {}`.

>
>  static const struct option long_options[] = {
>         {"help",        no_argument,            NULL, 'h' },
> @@ -41,6 +65,15 @@ static const struct option long_options[] = {
>         {0, 0, NULL,  0 }
>  };
>
> +static void int_exit(int sig)
> +{
> +       /* Detach tracepoints */
> +       while (tp_cnt)
> +               bpf_link__destroy(tp_links[--tp_cnt]);
> +

see below about proper cleanup

> +       exit(0);
> +}
> +
>  /* C standard specifies two constants, EXIT_SUCCESS(0) and EXIT_FAILURE(1) */
>  #define EXIT_FAIL_MEM  5
>

[...]

>
> -static void print_bpf_prog_info(void)
> +static void print_bpf_prog_info(struct bpf_object *obj)
>  {
> -       int i;
> +       struct bpf_program *prog;
> +       struct bpf_map *map;
> +       int i = 0;
>
>         /* Prog info */
> -       printf("Loaded BPF prog have %d bpf program(s)\n", prog_cnt);
> -       for (i = 0; i < prog_cnt; i++) {
> -               printf(" - prog_fd[%d] = fd(%d)\n", i, prog_fd[i]);
> +       printf("Loaded BPF prog have %d bpf program(s)\n", tp_cnt);
> +       bpf_object__for_each_program(prog, obj) {
> +               printf(" - prog_fd[%d] = fd(%d)\n", i++, bpf_program__fd(prog));
>         }
>
> +       i = 0;
>         /* Maps info */
> -       printf("Loaded BPF prog have %d map(s)\n", map_data_count);
> -       for (i = 0; i < map_data_count; i++) {
> -               char *name = map_data[i].name;
> -               int fd     = map_data[i].fd;
> +       printf("Loaded BPF prog have %d map(s)\n", map_cnt);
> +       bpf_object__for_each_map(map, obj) {
> +               const char *name = bpf_map__name(map);
> +               int fd           = bpf_map__fd(map);
>
> -               printf(" - map_data[%d] = fd(%d) name:%s\n", i, fd, name);
> +               printf(" - map_data[%d] = fd(%d) name:%s\n", i++, fd, name);

please move out increment into a separate statement, no need to
confuse readers unnecessarily

>         }
>
>         /* Event info */
> -       printf("Searching for (max:%d) event file descriptor(s)\n", prog_cnt);
> -       for (i = 0; i < prog_cnt; i++) {
> -               if (event_fd[i] != -1)
> -                       printf(" - event_fd[%d] = fd(%d)\n", i, event_fd[i]);
> +       printf("Searching for (max:%d) event file descriptor(s)\n", tp_cnt);
> +       for (i = 0; i < tp_cnt; i++) {
> +               int fd = bpf_link__fd(tp_links[i]);
> +
> +               if (fd != -1)
> +                       printf(" - event_fd[%d] = fd(%d)\n", i, fd);
>         }
>  }
>
>  int main(int argc, char **argv)
>  {

[...]

> +       obj = bpf_object__open_file(filename, NULL);
> +       if (libbpf_get_error(obj)) {
> +               printf("ERROR: opening BPF object file failed\n");
> +               obj = NULL;
>                 return EXIT_FAILURE;
>         }
> -       if (!prog_fd[0]) {
> -               printf("ERROR - load_bpf_file: %s\n", strerror(errno));
> +
> +       /* load BPF program */
> +       if (bpf_object__load(obj)) {

would be still good to call bpf_object__close(obj) here, this will
avoid warnings about memory leaks, if you run this program under ASAN

> +               printf("ERROR: loading BPF object file failed\n");
>                 return EXIT_FAILURE;
>         }
>
> +       for (type = 0; type < NUM_MAP; type++) {
> +               map_data[type] =
> +                       bpf_object__find_map_by_name(obj, map_type_strings[type]);
> +
> +               if (libbpf_get_error(map_data[type])) {
> +                       printf("ERROR: finding a map in obj file failed\n");

same about cleanup, goto into single cleanup place would be
appropriate throughout this entire function, probably.

> +                       return EXIT_FAILURE;
> +               }
> +               map_cnt++;
> +       }
> +

[...]
