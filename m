Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7705502E7
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 07:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiFRFbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 01:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiFRFbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 01:31:15 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0D06006B;
        Fri, 17 Jun 2022 22:31:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fu3so12118501ejc.7;
        Fri, 17 Jun 2022 22:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCv5ZFaf8lE9/RCZn/mnFHKDQpvJJAzq648WOUNKZXI=;
        b=JPWBm5MbnBHiAlK92Qz+JGFp5rZR9xLLsktGh2cLPQzh1z2pDSCcsl8HmRwzoSX4Er
         ku5BauTtY8t+KA0QnhHlDvB0stpBeVXZbWithupIrhLXvfV9lt3J9BVpu5oZ9mbMErIP
         g0y4xrJUbfZBw5tZJxLQANa05UP84bmbnB0B5gCf/iy88mr+VxhV6hAuHOW9go+sDCpM
         yJ3kYB/vZR5LkTHVy84XLAqqYmZ84GRG+IFuxOgtEOP+zExtCcrZeDfT5nhP/bwYSvXY
         AUM9YIJJxPNTQfGa8Zs1mkYirOhvpoQHjBxOvxKV0oIX5uldpbDkacPWLSiLx+gGR4fo
         fSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCv5ZFaf8lE9/RCZn/mnFHKDQpvJJAzq648WOUNKZXI=;
        b=W8lPJmtKmj8iZPiF0GrRxZ6NMNZfL3i3Ads2LUuwF66w05PZo4UXQ+eO6nCL28uyGn
         mKO5JY1Ejl3uLoPU4iBOFLIB0NsIgAiimvswrHW52aKkET64/DoeHuX6e+fRwZV3n0yQ
         UxSlNFBEe6DD1nDSa4naaCwnVpskkax02vScQFjiL4u9IEeiSZPG4mbcEUeJGCTc2RWw
         4uW5uSvyt1CP25ZqnIR1KRjx5A2hgzxItIXihL5rJM0zc96GeGf+gUoZ3EJnH+x5f09o
         9e50LMOON9L8qnR8tzgQcnvXp1h3cBaEQ9hT1U7NQSRelk022QSJQvyqUjNGxeeLJO7a
         6Exg==
X-Gm-Message-State: AJIora+xmoQkajuhEbMpa4mCeJa6xkriuiXpx5SP5hcNKWEkXISls3bO
        uf3CxJDFGQdwSLxDxTJtzjTngOIu8WjUbWUo11Y=
X-Google-Smtp-Source: AGRyM1vUpaYmfj3lsw1euFr0QccAb41puW7mGJoFiawl2lyvmjfbIq2tygHMXkGTYV2RawH9eMUSaGL15etZ4C6O6bE=
X-Received: by 2002:a17:906:649b:b0:711:fde7:be43 with SMTP id
 e27-20020a170906649b00b00711fde7be43mr12454129ejm.294.1655530272557; Fri, 17
 Jun 2022 22:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220614084930.43276-1-nashuiliang@gmail.com> <62ad50fa9d42d_24b34208d6@john.notmuch>
In-Reply-To: <62ad50fa9d42d_24b34208d6@john.notmuch>
From:   chuang <nashuiliang@gmail.com>
Date:   Sat, 18 Jun 2022 13:31:01 +0800
Message-ID: <CACueBy7NqRszA3tCOvLhfi1OraUrL_GD9YZ9XOPNHzbR1=+z7g@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Remove kprobe_event on failed kprobe_open_legacy
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jingren Zhou <zhoujingren@didiglobal.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
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

Hi John,

On Sat, Jun 18, 2022 at 12:13 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Chuang W wrote:
> > In a scenario where livepatch and aggrprobe coexist, the creating
> > kprobe_event using tracefs API will succeed, a trace event (e.g.
> > /debugfs/tracing/events/kprobe/XX) will exist, but perf_event_open()
> > will return an error.
>
> This seems a bit strange from API side. I'm not really familiar with
> livepatch, but I guess this is UAPI now so fixing add_kprobe_event_legacy
> to fail is not an option?
>

The legacy kprobe API (i.e. tracefs API) has two steps:

1) register_kprobe
$ echo 'p:mykprobe XXX' > /sys/kernel/debug/tracing/kprobe_events
This will create a trace event of mykprobe and register a disable
kprobe that waits to be activated.

2) enable_kprobe
2.1) using syscall perf_event_open
as the following code, perf_event_kprobe_open_legacy (file:
tools/lib/bpf/libbpf.c):
---
attr.type = PERF_TYPE_TRACEPOINT;
pfd = syscall(__NR_perf_event_open, &attr,
              pid < 0 ? -1 : pid, /* pid */
              pid == -1 ? 0 : -1, /* cpu */
              -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC);
---
In the implementation code of perf_event_open, enable_kprobe() will be executed.
2.2) using shell
$ echo 1 > /sys/kernel/debug/tracing/events/kprobes/mykprobe/enable
As with perf_event_open, enable_kprobe() will also be executed.

When using the same function XXX, kprobe and livepatch cannot coexist,
that is, step 2) will return an error (ref: arm_kprobe_ftrace()),
however, step 1) is ok!
However, the new kprobe API (i.e. perf kprobe API) aggregates
register_kprobe and enable_kprobe, internally fixes the issue on
failed enable_kprobe.
But above all, for the legacy kprobe API, I think it should remove
kprobe_event on failed add_kprobe_event_legacy() in
perf_event_kprobe_open_legacy (file: tools/lib/bpf/libbpf.c).
