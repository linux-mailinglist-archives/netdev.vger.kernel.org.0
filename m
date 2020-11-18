Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12D02B7463
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgKRCwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgKRCwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 21:52:42 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C3BC0613D4;
        Tue, 17 Nov 2020 18:52:41 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id x17so265112ybr.8;
        Tue, 17 Nov 2020 18:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SjrGYc5Ndjj6nsLD1eKS/w+aJSqMDah243ks049chjo=;
        b=if68CQLVqWxGxvG6RStF5PBp4I0vqJViEbSerf4+bETPhuk8pn7L1Hf/J1Yx1OFHZJ
         pD+tIl9MN3OQCJtkcPgGTSMrlXw6tM61v4OM5fTaiGPAu02l+S7zhEr25AJvv1pKYpY/
         HqYm8zxA+78+giGhez0RvpTLcxJxJy8A4K2GoL7df0QxzXMsd395O3ttId9ii9lCpNIB
         hGdkk7G0zJXtMgCIy5XE7CCqjDqeqM9P/tmV3GlOz+bBttu5a2Lrtb/ygs/p0kn57H7n
         cC/Lp0D/zySDK3+5ukGeGJbU4W6uq086vQLbc1glG6VW1U0dDRF6JAlFshLZ2vuIVo+g
         1HSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SjrGYc5Ndjj6nsLD1eKS/w+aJSqMDah243ks049chjo=;
        b=HbwzOTjzVLB/httzkaHZ/U+tS6vj/1YXaT4FNpkH9ZBlhiaBgELcWdc06iENDdJV+w
         iqUXAg62oIwEqOmtvZHX3chtFZ5XusfSJ3tkvjR5QGJXJOtoSG2AcpS9IGexcswFrz/y
         3H/s+OFk5EBjn/OEflUnWu1L0p/fY25IofF/4vZXQF89jmou1IDWW4WdRHxjQVODFGuu
         VkyKF2ZdgFfRbx38oX4TuKwvcVz9H7angOHnVf2MtI9/OSQrRHCmmzJjH3tSzBURNVAn
         FWURiX6LOfMCyzX6eNhLYHS2/Rh/v+4hiKimbRgdFeXJsFJjm5mP02dMuDKPaDMzcX/5
         PiCQ==
X-Gm-Message-State: AOAM532RM3te25f4uoO/PLL4+xFTsOkbwv0YcH+r7LzWEskPsEy+fIM+
        085c2r7lYc0WY2BUoNrekfQHGX+up1TEBnwzAio=
X-Google-Smtp-Source: ABdhPJzVAU4YiipKY+4bEZIAi7gkda2dDET+ruYaSVAkdBOEOiwXereVxV8Ajzs/0oMRjAjoyM3U1mx0JDPidS2nIj4=
X-Received: by 2002:a25:df82:: with SMTP id w124mr4010868ybg.347.1605667960351;
 Tue, 17 Nov 2020 18:52:40 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com> <20201117145644.1166255-6-danieltimlee@gmail.com>
In-Reply-To: <20201117145644.1166255-6-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 18:52:29 -0800
Message-ID: <CAEf4BzZBjVw4ptGZE8V9SM4htW_Nf_TjXkUKEHjF9bxgO43DQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/9] samples: bpf: refactor ibumad program with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> This commit refactors the existing ibumad program with libbpf bpf
> loader. Attach/detach of Tracepoint bpf programs has been managed
> with the generic bpf_program__attach() and bpf_link__destroy() from
> the libbpf.
>
> Also, instead of using the previous BPF MAP definition, this commit
> refactors ibumad MAP definition with the new BTF-defined MAP format.
>
> To verify that this bpf program works without an infiniband device,
> try loading ib_umad kernel module and test the program as follows:
>
>     # modprobe ib_umad
>     # ./ibumad
>
> Moreover, TRACE_HELPERS has been removed from the Makefile since it is
> not used on this program.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile      |  2 +-
>  samples/bpf/ibumad_kern.c | 26 +++++++--------
>  samples/bpf/ibumad_user.c | 66 ++++++++++++++++++++++++++++++---------
>  3 files changed, 65 insertions(+), 29 deletions(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 36b261c7afc7..bfa595379493 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -109,7 +109,7 @@ xsk_fwd-objs := xsk_fwd.o
>  xdp_fwd-objs := xdp_fwd_user.o
>  task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
>  xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
> -ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
> +ibumad-objs := ibumad_user.o
>  hbm-objs := hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
>
>  # Tell kbuild to always build the programs
> diff --git a/samples/bpf/ibumad_kern.c b/samples/bpf/ibumad_kern.c
> index 3a91b4c1989a..26dcd4dde946 100644
> --- a/samples/bpf/ibumad_kern.c
> +++ b/samples/bpf/ibumad_kern.c
> @@ -16,19 +16,19 @@
>  #include <bpf/bpf_helpers.h>
>
>
> -struct bpf_map_def SEC("maps") read_count = {
> -       .type        = BPF_MAP_TYPE_ARRAY,
> -       .key_size    = sizeof(u32), /* class; u32 required */
> -       .value_size  = sizeof(u64), /* count of mads read */
> -       .max_entries = 256, /* Room for all Classes */
> -};
> -
> -struct bpf_map_def SEC("maps") write_count = {
> -       .type        = BPF_MAP_TYPE_ARRAY,
> -       .key_size    = sizeof(u32), /* class; u32 required */
> -       .value_size  = sizeof(u64), /* count of mads written */
> -       .max_entries = 256, /* Room for all Classes */
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __type(key, u32); /* class; u32 required */
> +       __type(value, u64); /* count of mads read */
> +       __uint(max_entries, 256); /* Room for all Classes */
> +} read_count SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __type(key, u32); /* class; u32 required */
> +       __type(value, u64); /* count of mads written */
> +       __uint(max_entries, 256); /* Room for all Classes */
> +} write_count SEC(".maps");
>
>  #undef DEBUG
>  #ifndef DEBUG
> diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
> index fa06eef31a84..66a06272f242 100644
> --- a/samples/bpf/ibumad_user.c
> +++ b/samples/bpf/ibumad_user.c
> @@ -23,10 +23,15 @@
>  #include <getopt.h>
>  #include <net/if.h>
>
> -#include "bpf_load.h"
> +#include <bpf/bpf.h>
>  #include "bpf_util.h"
>  #include <bpf/libbpf.h>
>
> +struct bpf_link *tp_links[3] = {};
> +struct bpf_object *obj;

statics and you can drop = {} part.

> +static int map_fd[2];
> +static int tp_cnt;
> +
>  static void dump_counts(int fd)
>  {
>         __u32 key;
> @@ -53,6 +58,11 @@ static void dump_all_counts(void)
>  static void dump_exit(int sig)
>  {
>         dump_all_counts();
> +       /* Detach tracepoints */
> +       while (tp_cnt)
> +               bpf_link__destroy(tp_links[--tp_cnt]);
> +
> +       bpf_object__close(obj);
>         exit(0);
>  }
>
> @@ -73,19 +83,11 @@ static void usage(char *cmd)
>
>  int main(int argc, char **argv)
>  {
> +       struct bpf_program *prog;
>         unsigned long delay = 5;
> +       char filename[256];
>         int longindex = 0;
>         int opt;
> -       char bpf_file[256];
> -
> -       /* Create the eBPF kernel code path name.
> -        * This follows the pattern of all of the other bpf samples
> -        */
> -       snprintf(bpf_file, sizeof(bpf_file), "%s_kern.o", argv[0]);
> -
> -       /* Do one final dump when exiting */
> -       signal(SIGINT, dump_exit);
> -       signal(SIGTERM, dump_exit);
>
>         while ((opt = getopt_long(argc, argv, "hd:rSw",
>                                   long_options, &longindex)) != -1) {
> @@ -107,10 +109,38 @@ int main(int argc, char **argv)
>                 }
>         }
>
> -       if (load_bpf_file(bpf_file)) {
> -               fprintf(stderr, "ERROR: failed to load eBPF from file : %s\n",
> -                       bpf_file);
> -               return 1;
> +       /* Do one final dump when exiting */
> +       signal(SIGINT, dump_exit);
> +       signal(SIGTERM, dump_exit);
> +
> +       snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> +       obj = bpf_object__open_file(filename, NULL);
> +       if (libbpf_get_error(obj)) {
> +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> +               return 0;

not really a success, no?

> +       }
> +
> +       /* load BPF program */
> +       if (bpf_object__load(obj)) {
> +               fprintf(stderr, "ERROR: loading BPF object file failed\n");
> +               goto cleanup;
> +       }
> +
> +       map_fd[0] = bpf_object__find_map_fd_by_name(obj, "read_count");
> +       map_fd[1] = bpf_object__find_map_fd_by_name(obj, "write_count");
> +       if (map_fd[0] < 0 || map_fd[1] < 0) {
> +               fprintf(stderr, "ERROR: finding a map in obj file failed\n");
> +               goto cleanup;
> +       }
> +
> +       bpf_object__for_each_program(prog, obj) {
> +               tp_links[tp_cnt] = bpf_program__attach(prog);
> +               if (libbpf_get_error(tp_links[tp_cnt])) {
> +                       fprintf(stderr, "ERROR: bpf_program__attach failed\n");
> +                       tp_links[tp_cnt] = NULL;
> +                       goto cleanup;
> +               }
> +               tp_cnt++;
>         }

This cries for the BPF skeleton... But one step at a time :)

>
>         while (1) {
> @@ -118,5 +148,11 @@ int main(int argc, char **argv)
>                 dump_all_counts();
>         }
>
> +cleanup:
> +       /* Detach tracepoints */
> +       while (tp_cnt)
> +               bpf_link__destroy(tp_links[--tp_cnt]);
> +
> +       bpf_object__close(obj);
>         return 0;

same, in a lot of cases it's not a success, probably need int err
variable somewhere.

>  }
> --
> 2.25.1
>
