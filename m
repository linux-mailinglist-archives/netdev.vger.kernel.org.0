Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DFC5571C7
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiFWEkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245747AbiFWEDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:03:21 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBA53ED0D;
        Wed, 22 Jun 2022 21:03:19 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ay16so19021317ejb.6;
        Wed, 22 Jun 2022 21:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p9alu82XUp6uZJtIQvNoA6NypyCiXgcxiqkWkzEr1Zo=;
        b=Fagtrm/XTZLabpzvqPXdymcY9K3hY67eW+BnLM7Dwzpapd80AOWgR9PWqOxK+AYtSn
         04fcR3YfOkqHL7ySLvakHZUc4KSzGqKcKzktj+VcTjK3okZ8jEE6YnNwtWcbKhuYhJmp
         EsmXm+Y3zJkOWo3O/DFLeIzavfoDqdQEZcnL7+Hnvw+WAdYmrW+7ii2kTBESh8LkYbab
         efrRfbtrB/kMlFuoi7mfajUrKsrH46bvvTr+nEyvs8OkeyMjFIyWlfrpEJZL9NhdT1Z2
         VWzDk6ptr/PCP4zmlCUrD6ELuEHKhmYpCj7YPbbTSH/Rw83OvhWCZm0f648MdtfLvLqA
         oqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p9alu82XUp6uZJtIQvNoA6NypyCiXgcxiqkWkzEr1Zo=;
        b=Dmtdd2TwwD86ZIZflGm4ae4v2m7n8fEmG4hRfjFVLKGIP/g4NgZz2QBLGFlJURjULT
         KvZmhoL6etnypeKfyw3sIgt1Yzu0/4OQ4gj+Lb4EO8VV4K//CoTR3XiSXe0JbS7405ZR
         Gg5pzOv9oaYAAhe0TO5+Y7s6VkcZX+XqMpxGLrA/h4By+A5tJ6oZqLk62TLe5A28NtMH
         VLieG/rMzDseppARIqvWKzFFOipaeGqwEhiKDDD+lC7dFRYTL+F2c/dnReYnz5D/vPp8
         UwasgtbKJKSEmH2SpwstBhA/fnWRNpm5cbShXXYw2QAsgLFM4+G53q4itpxlrQZjEpnx
         ks0g==
X-Gm-Message-State: AJIora/hGFxjXiuDr9zx1zjb2NBOdP/Y27GRPo02KYgHBr880v5TWsJe
        QjqF9v5hUQiSEWZzNN2mzVG6aWW0hU5vZsZRQp4=
X-Google-Smtp-Source: AGRyM1ta1CjY0G8QOk5sXGWqbULWoob+XD2P/kZ3PpOlHzCV7ET+r/mnpgI74/SyU9Tqul9fAzH++de36O113+xB81U=
X-Received: by 2002:a17:906:3f51:b0:712:3945:8c0d with SMTP id
 f17-20020a1709063f5100b0071239458c0dmr6182429ejj.302.1655956998418; Wed, 22
 Jun 2022 21:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220621073233.53776-1-nashuiliang@gmail.com>
In-Reply-To: <20220621073233.53776-1-nashuiliang@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Jun 2022 21:03:07 -0700
Message-ID: <CAEf4BzZmZjF62GzwQ2D7Sarhfha+Uc1g+TKPszZJ60jTMb0dbA@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Cleanup the kprobe_event on failed add_kprobe_event_legacy()
To:     Chuang W <nashuiliang@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jingren Zhou <zhoujingren@didiglobal.com>
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

On Tue, Jun 21, 2022 at 12:32 AM Chuang W <nashuiliang@gmail.com> wrote:
>
> Before the 0bc11ed5ab60 commit ("kprobes: Allow kprobes coexist with
> livepatch"), in a scenario where livepatch and kprobe coexist on the
> same function entry, the creation of kprobe_event using
> add_kprobe_event_legacy() will be successful, at the same time as a
> trace event (e.g. /debugfs/tracing/events/kprobe/XX) will exist, but
> perf_event_open() will return an error because both livepatch and kprobe
> use FTRACE_OPS_FL_IPMODIFY.
>
> With this patch, whenever an error is returned after
> add_kprobe_event_legacy(), this ensures that the created kprobe_event is
> cleaned.
>
> Signed-off-by: Chuang W <nashuiliang@gmail.com>
> Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
> ---

This part is good, but I think there are few error paths in
bpf_program__attach_kprobe_opts() itself that would need to call
remove_kprobe_event_legacy() explicitly as well, no?

>  tools/lib/bpf/libbpf.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 0781fae58a06..d0a36350e22a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10809,10 +10809,11 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
>         }
>         type = determine_kprobe_perf_type_legacy(probe_name, retprobe);
>         if (type < 0) {
> +               err = type;
>                 pr_warn("failed to determine legacy kprobe event id for '%s+0x%zx': %s\n",
>                         kfunc_name, offset,
> -                       libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> -               return type;
> +                       libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               goto clear_kprobe_event;
>         }
>         attr.size = sizeof(attr);
>         attr.config = type;
> @@ -10826,9 +10827,14 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
>                 err = -errno;
>                 pr_warn("legacy kprobe perf_event_open() failed: %s\n",
>                         libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> -               return err;
> +               goto clear_kprobe_event;
>         }
>         return pfd;
> +
> +clear_kprobe_event:
> +       /* Clear the newly added kprobe_event */
> +       remove_kprobe_event_legacy(probe_name, retprobe);
> +       return err;
>  }
>
>  struct bpf_link *
> --
> 2.34.1
>
