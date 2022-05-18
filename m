Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAA952C7F1
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiERXvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiERXvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:51:10 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1C4443C3;
        Wed, 18 May 2022 16:51:10 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id h85so4085910iof.12;
        Wed, 18 May 2022 16:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eZMy8FDicN73C5tBewEMmRPhbsoqs/BvzITBNIcg4lI=;
        b=bV2eHwNLaIIZcJFPpOhwoDKvUVHSKNvsV3qUcXiyyqVoT8vgw1YA11pOl7Bef67Id9
         8IO6ageKx63UxY6rCNMgWsGjAznrDkga9bVN/S8kwLW996syy6yrDkcE0kQeacQxi/kO
         4cGJ92W2Rj5SiytU3ldGj84lom/BNkwQNvAjR2WoFYz43iD+icaNfwoFdBwNjEuw+fBA
         zRsz9UN0GGB0Ha4Mve0m1k6fyEZBA9G1L4TH3XZkQVcMaYEpTapirL4uHeBj2EnESxAM
         Rjpj1dX0ucmssHN5zAkytrdqtkN6GYmfjZHvfYJmbjtG1iDlkjZI764iUeEYarO5a9Mf
         lTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eZMy8FDicN73C5tBewEMmRPhbsoqs/BvzITBNIcg4lI=;
        b=nyudBD4Q+FeYV30HNveB0aVwDOdUPZN0EckwfwNA7C5+XQsfNeBzXI38QaghFxozVh
         lyNKlfGyTu6NI79jqkSj9zV+kEVjAfq0+IseYSM6uE+oVrtfitS1eryA2Ydvx3H+XqJd
         PcOYAUXzzOwFrB7GbScGWvFTrdiJi+6AsMX4a3O9KhxUEDg1nliK8MnETuMfvFimVql8
         zWCqp9qsg6BXILfrSQvRCZzlX+dJ9FQ6IGkifEcS/PhP2ndojw5wyn3PfNvjeRaSCcnT
         KlxmBP/Wer1QUMuoYwco63qczWPfO7V4UadErkY/NEUPQf7DGs+Pdp3SOYeHaBUp9smv
         KSHg==
X-Gm-Message-State: AOAM532shANTwKZuFAlng0h7F76i/PMpNUKcOmqjKz3bUjKy7hlvx3OB
        QkQnSt8IlInP2XO0spAD0k8EBZ94JyNJ/zIksbTKUvUE
X-Google-Smtp-Source: ABdhPJz7ng3xuusKTxdtSpX9mM929lMyQ9CPvg13/lfQd4CkqrUJZ2b2BA5I+eMO0wcjxqx/5T37CPMTNoDE+0KAbX0=
X-Received: by 2002:a05:6638:450a:b0:32e:1bd1:735f with SMTP id
 bs10-20020a056638450a00b0032e1bd1735fmr1129586jab.145.1652917869480; Wed, 18
 May 2022 16:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652772731.git.esyr@redhat.com> <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
In-Reply-To: <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 16:50:58 -0700
Message-ID: <CAEf4BzYNa0F21ydMLvmeGZWzvO_o5Fh0Af0zwWGNxMh6emQTSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in kprobe_multi.addrs
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Tue, May 17, 2022 at 12:37 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> With the interface as defined, it is impossible to pass 64-bit kernel
> addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
> which severly limits the useability of the interface, change the ABI
> to accept an array of u64 values instead of (kernel? user?) longs.
> Interestingly, the rest of the libbpf infrastructure uses 64-bit values
> for kallsyms addresses already, so this patch also eliminates
> the sym_addr cast in tools/lib/bpf/libbpf.c:resolve_kprobe_multi_cb().
>
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Fixes: 5117c26e877352bc ("libbpf: Add bpf_link_create support for multi kprobes")
> Fixes: ddc6b04989eb0993 ("libbpf: Add bpf_program__attach_kprobe_multi_opts function")
> Fixes: f7a11eeccb111854 ("selftests/bpf: Add kprobe_multi attach test")
> Fixes: 9271a0c7ae7a9147 ("selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts")
> Fixes: 2c6401c966ae1fbe ("selftests/bpf: Add kprobe_multi bpf_cookie test")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>  kernel/trace/bpf_trace.c                           | 25 ++++++++++++++++++----

kernel changes should go into a separate patch (and seems like they
logically fit together with patch #3, no?)

>  tools/lib/bpf/bpf.h                                |  2 +-
>  tools/lib/bpf/libbpf.c                             |  8 +++----
>  tools/lib/bpf/libbpf.h                             |  2 +-
>  .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  2 +-
>  .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  8 +++----
>  6 files changed, 32 insertions(+), 15 deletions(-)
>

[...]
