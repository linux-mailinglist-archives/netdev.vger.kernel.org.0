Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BD85FE2EA
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 21:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiJMTr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 15:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJMTrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 15:47:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA8B18B4B1;
        Thu, 13 Oct 2022 12:47:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w18so6124120ejq.11;
        Thu, 13 Oct 2022 12:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6pqoki37Jq/v/v0yGu6lDbXT2HjCHjHDBLAGhTwQPUY=;
        b=gJH+tXWlpCxu2t9WDfup3OOXnDY31epVMOS13GBHkaNbTzClzXNS8H/tClvMYQvHBS
         7Zmi1O264AAl7ahr8JzTwtAcO2ZKuYpJcBDNEqJisnLY++9muXRsuI2lGazWPGms/DIa
         dUBoUkPlxn+ZjeUhXCIh0NLP2cIqK6k9QD3u5Fx8otlIsu8AQN46wivsKZhcehBG9PE8
         jBwqi+4RYrEUSb3cj/sPEEkeJB5NsEF2pNd+T8JC198RmrtK9TjbuSLcZtDwwzLPK2vx
         vZ0QV2bu4vI0Yo9jrCGnS8IJBdwQf25AsaINIfdWF9DAHnaqAiUmyvvC5qJl5ZiXoBp9
         s/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6pqoki37Jq/v/v0yGu6lDbXT2HjCHjHDBLAGhTwQPUY=;
        b=Pxx46o+pSgbJFQvJn2Kuo9g4icDzbS2VXfu7XXcKDGkV6HPspI9AfrWWU8k8mpXTuG
         RDBAzS8R8yej1illhnx6I48V/6urMDOTUWD/a3yBUuxHcMaHwUxL1pfa3p4j7fUGCOwx
         Kn+LjdAkPjxslO2TqxopE6HWqYXVD/mniHiSVGAvBUuppkZBgEhYAJdrj3VrFB31x2Q8
         LsUvfTlWJ0RJk0sB36FCcXml3AkGwtpg8QTekHKoIOJ2du8QK/kAUezNH/udvGJCG1rP
         hrNndom/zG8fiu+bTXUvHRX+dXve3shPcJ+sY1NIoylJlyYpMdVteQ42Oq8fGV/I+/BQ
         9UKg==
X-Gm-Message-State: ACrzQf3YYCmos+xHSQS/u6QP3kZQrwK37VwGqFM/M/61Oab2NRWhsj2v
        YAQBd7aTQwS8j11g/rzm5L3DVGs+zrpU4acrXIc=
X-Google-Smtp-Source: AMsMyM49ZL/IRLYiBP2cjHrCi0tZ598HwWHVQz/TSdv8f/2rdxDUnk0B/6QXkvxx4ubZmhXDJwetbVXA4rt1No9xp2A=
X-Received: by 2002:a17:906:99c5:b0:73d:70c5:1a4f with SMTP id
 s5-20020a17090699c500b0073d70c51a4fmr994662ejn.302.1665690470849; Thu, 13 Oct
 2022 12:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <1665399601-29668-1-git-send-email-wangyufen@huawei.com> <1665399601-29668-2-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1665399601-29668-2-git-send-email-wangyufen@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Oct 2022 12:47:38 -0700
Message-ID: <CAEf4BzYzUKUg=V6Bir7s1AKuZF-=HFsjuWBTjTqO8fganjWVDg@mail.gmail.com>
Subject: Re: [bpf-next v8 1/3] bpftool: Add autoattach for bpf prog load|loadall
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     quentin@isovalent.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 3:40 AM Wang Yufen <wangyufen@huawei.com> wrote:
>
> Add autoattach optional to support one-step load-attach-pin_link.
>
> For example,
>    $ bpftool prog loadall test.o /sys/fs/bpf/test autoattach
>
>    $ bpftool link
>    26: tracing  name test1  tag f0da7d0058c00236  gpl
>         loaded_at 2022-09-09T21:39:49+0800  uid 0
>         xlated 88B  jited 55B  memlock 4096B  map_ids 3
>         btf_id 55
>    28: kprobe  name test3  tag 002ef1bef0723833  gpl
>         loaded_at 2022-09-09T21:39:49+0800  uid 0
>         xlated 88B  jited 56B  memlock 4096B  map_ids 3
>         btf_id 55
>    57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
>         loaded_at 2022-09-09T21:41:32+0800  uid 0
>         xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
>         btf_id 82
>
>    $ bpftool link
>    1: tracing  prog 26
>         prog_type tracing  attach_type trace_fentry
>    3: perf_event  prog 28
>    10: perf_event  prog 57
>
> The autoattach optional can support tracepoints, k(ret)probes,
> u(ret)probes.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  tools/bpf/bpftool/prog.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 76 insertions(+), 2 deletions(-)
>
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index c81362a..8f3afce 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1453,6 +1453,69 @@ static int do_run(int argc, char **argv)
>         return ret;
>  }
>
> +static int
> +auto_attach_program(struct bpf_program *prog, const char *path)
> +{
> +       struct bpf_link *link;
> +       int err;
> +
> +       link = bpf_program__attach(prog);
> +       if (!link) {
> +               p_info("Program %s does not support autoattach, falling back to pinning",
> +                      bpf_program__name(prog));
> +               return bpf_obj_pin(bpf_program__fd(prog), path);
> +       }
> +       err = bpf_link__pin(link, path);
> +       if (err) {
> +               bpf_link__destroy(link);
> +               return err;
> +       }

leaking link here, destroy it unconditionally. If pinning succeeded,
you don't need to hold link's FD open anymore.

> +       return 0;
> +}
> +
> +static int pathname_concat(const char *path, const char *name, char *buf)

why you didn't do the same as in libbpf? Pass buffer size explicitly
instead of assuming PATH_MAX

> +{
> +       int len;
> +
> +       len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
> +       if (len < 0)
> +               return -EINVAL;
> +       if (len >= PATH_MAX)
> +               return -ENAMETOOLONG;
> +
> +       return 0;
> +}
> +
> +static int
> +auto_attach_programs(struct bpf_object *obj, const char *path)
> +{
> +       struct bpf_program *prog;
> +       char buf[PATH_MAX];
> +       int err;
> +
> +       bpf_object__for_each_program(prog, obj) {
> +               err = pathname_concat(path, bpf_program__name(prog), buf);
> +               if (err)
> +                       goto err_unpin_programs;
> +
> +               err = auto_attach_program(prog, buf);
> +               if (err)
> +                       goto err_unpin_programs;
> +       }
> +
> +       return 0;
> +
> +err_unpin_programs:
> +       while ((prog = bpf_object__prev_program(obj, prog))) {
> +               if (pathname_concat(path, bpf_program__name(prog), buf))
> +                       continue;
> +
> +               bpf_program__unpin(prog, buf);
> +       }
> +
> +       return err;
> +}
> +
>  static int load_with_options(int argc, char **argv, bool first_prog_only)
>  {
>         enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
> @@ -1464,6 +1527,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>         struct bpf_program *prog = NULL, *pos;
>         unsigned int old_map_fds = 0;
>         const char *pinmaps = NULL;
> +       bool auto_attach = false;
>         struct bpf_object *obj;
>         struct bpf_map *map;
>         const char *pinfile;
> @@ -1583,6 +1647,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>                                 goto err_free_reuse_maps;
>
>                         pinmaps = GET_ARG();
> +               } else if (is_prefix(*argv, "autoattach")) {
> +                       auto_attach = true;
> +                       NEXT_ARG();
>                 } else {
>                         p_err("expected no more arguments, 'type', 'map' or 'dev', got: '%s'?",
>                               *argv);
> @@ -1692,14 +1759,20 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>                         goto err_close_obj;
>                 }
>
> -               err = bpf_obj_pin(bpf_program__fd(prog), pinfile);
> +               if (auto_attach)
> +                       err = auto_attach_program(prog, pinfile);
> +               else
> +                       err = bpf_obj_pin(bpf_program__fd(prog), pinfile);
>                 if (err) {
>                         p_err("failed to pin program %s",
>                               bpf_program__section_name(prog));
>                         goto err_close_obj;
>                 }
>         } else {
> -               err = bpf_object__pin_programs(obj, pinfile);
> +               if (auto_attach)
> +                       err = auto_attach_programs(obj, pinfile);
> +               else
> +                       err = bpf_object__pin_programs(obj, pinfile);
>                 if (err) {
>                         p_err("failed to pin all programs");
>                         goto err_close_obj;
> @@ -2338,6 +2411,7 @@ static int do_help(int argc, char **argv)
>                 "                         [type TYPE] [dev NAME] \\\n"
>                 "                         [map { idx IDX | name NAME } MAP]\\\n"
>                 "                         [pinmaps MAP_DIR]\n"
> +               "                         [autoattach]\n"
>                 "       %1$s %2$s attach PROG ATTACH_TYPE [MAP]\n"
>                 "       %1$s %2$s detach PROG ATTACH_TYPE [MAP]\n"
>                 "       %1$s %2$s run PROG \\\n"
> --
> 1.8.3.1
>
