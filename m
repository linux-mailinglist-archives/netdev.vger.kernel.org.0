Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3892B41F764
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355857AbhJAWXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhJAWXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:23:00 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A8CC061775;
        Fri,  1 Oct 2021 15:21:15 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id s64so20487162yba.11;
        Fri, 01 Oct 2021 15:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fseh6H5Kox/p/1VibRttqmZYOqZ4Hgs549m6AvvxN0g=;
        b=eOzjIMUAOzNgJ7pc5Jn7j9SNVgi192qayt8lwcJd2afgUgJv5NNEeAivlmUUNxO0dR
         +qdvVoR4p5nleU1bMvE/mjFUsqI+OKyc18qEDJdt/FTbLKRtlhunOFm5GYtQmGqdizF6
         LxXqBrfF3lJ28aFsFGhBDlqdin96KshR1zOSpZ9fqaRlYlpGj5X3LyxKIARLBzlYzr7b
         I4yoFv6Ry8ific3HfpW/OBLfs2k8H4gZQPQyLeKqj5OFoYRxnk6ukaxc1ZL+bkS6pWUR
         MLwSRGaxaMMFdu1AIyhKdCJb1kpmvOpMdP2+lcFCmQD80obZ4bBgCwYN1DZz9BGXKHn2
         AP+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fseh6H5Kox/p/1VibRttqmZYOqZ4Hgs549m6AvvxN0g=;
        b=yhLkU3VTy017kEHe043SwAZvWv4lNXdKj1A7S0qMqpwA/+qaaRVQwBbmx0dmIoqBXl
         +bR5RZr10rEa/Wha9b6tNfOrzt9YZfCGoAYGvcipHM4ofREokVjbY5mS/VGZB/B7lkjA
         TGkJ7nDQUyjlvl7dqVFRoYUIdseM30VX8dy9PbW7Nb1KAr0SfJwfj+FnQjF9fztUpB5Q
         NgjGyG7+IN2nzo0pSon5XyWsjGl1Dkkuvd1LSXSVR6MKiZmvCdHZ1hKMHarjRudVZsBW
         rK77mcNfUB7Ad44WbkZ+UnSEQDoGo7U98XIC9ihWBrDbWVJy0YPv2+EtmzlmqoC3ZnU9
         S4hg==
X-Gm-Message-State: AOAM533eS1jTkuEvZzSY3ERUOLxcmI0OoEk989WBk2UBZe9h4Kjgbb+P
        7Q/10PTPTzxV7ESPZ9bSFHbnKz1VyVJItpi6Yic=
X-Google-Smtp-Source: ABdhPJwuJQs2K9VmW2PURUIkB3Lky4LMdIoVzu97eBTzDQcx4kkFEa1QsMr676yLBtM3gvu4x6GMExDaJAOR5Z6d8HM=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr359108ybj.504.1633126875111;
 Fri, 01 Oct 2021 15:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210930091355.2794601-1-houtao1@huawei.com> <20210930091355.2794601-3-houtao1@huawei.com>
In-Reply-To: <20210930091355.2794601-3-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 15:21:04 -0700
Message-ID: <CAEf4Bzaf5qQOV7jA_U0+E3LhB0X57yJVL0ATqdr-Hui3Rz--=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: support detecting and attaching
 of writable tracepoint program
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 2:00 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Program on writable tracepoint is BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
> but its attachment is the same as BPF_PROG_TYPE_RAW_TRACEPOINT.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  tools/lib/bpf/libbpf.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7544d7d09160..80faa53dff35 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8005,6 +8005,8 @@ static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("tp/",                  TRACEPOINT, 0, SEC_NONE, attach_tp),
>         SEC_DEF("raw_tracepoint/",      RAW_TRACEPOINT, 0, SEC_NONE, attach_raw_tp),
>         SEC_DEF("raw_tp/",              RAW_TRACEPOINT, 0, SEC_NONE, attach_raw_tp),
> +       SEC_DEF("raw_tracepoint.w/",    RAW_TRACEPOINT_WRITABLE, 0, SEC_NONE, attach_raw_tp),
> +       SEC_DEF("raw_tp.w/",            RAW_TRACEPOINT_WRITABLE, 0, SEC_NONE, attach_raw_tp),
>         SEC_DEF("tp_btf/",              TRACING, BPF_TRACE_RAW_TP, SEC_ATTACH_BTF, attach_trace),
>         SEC_DEF("fentry/",              TRACING, BPF_TRACE_FENTRY, SEC_ATTACH_BTF, attach_trace),
>         SEC_DEF("fmod_ret/",            TRACING, BPF_MODIFY_RETURN, SEC_ATTACH_BTF, attach_trace),
> @@ -9762,12 +9764,21 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(const struct bpf_program *pr
>
>  static struct bpf_link *attach_raw_tp(const struct bpf_program *prog, long cookie)
>  {
> -       const char *tp_name;
> +       static const char *prefixes[] = {
> +               "raw_tp/",
> +               "raw_tracepoint/",
> +               "raw_tp.w/",
> +               "raw_tracepoint.w/",
> +       };
> +       size_t i;
> +       const char *tp_name = NULL;
>
> -       if (str_has_pfx(prog->sec_name, "raw_tp/"))
> -               tp_name = prog->sec_name + sizeof("raw_tp/") - 1;
> -       else
> -               tp_name = prog->sec_name + sizeof("raw_tracepoint/") - 1;
> +       for (i = 0; i < ARRAY_SIZE(prefixes); i++) {
> +               if (str_has_pfx(prog->sec_name, prefixes[i])) {
> +                       tp_name = prog->sec_name + strlen(prefixes[i]);
> +                       break;
> +               }
> +       }

Let's add if (!tp_name) check here for the future if we forget to
update this prefixes list. It's going to be a really unpleasant
SIGSEGV otherwise.

>
>         return bpf_program__attach_raw_tracepoint(prog, tp_name);
>  }
> --
> 2.29.2
>
