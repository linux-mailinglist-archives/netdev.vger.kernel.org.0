Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE093EF255
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhHQS5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbhHQS5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 14:57:47 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2C5C061764;
        Tue, 17 Aug 2021 11:57:13 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id z5so253779ybj.2;
        Tue, 17 Aug 2021 11:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qqGEA6MndaB0p4eKxUV0Iv+ZKsY1XUAaezZQYJCg3PA=;
        b=fQEEOUoQK8ohP37XutZvh16fKejcIzLl0KucFT/FuE4p9oZ9CZiOE5qzo0sApfevmW
         trSjkTw6ttgUHhBnXyzCyd/WGiM7kfiGBYXS8IFjVbmgHADtQI5IPufP8/ABs/oVz+Zc
         9CYB06H9lDhyCAncG7ieRkAgUx5YjHHbZeh3O/0vbWn3WJNjD1g598Zo/TQiy2oFCoFK
         NqQlpxSLKhitp8I7DYH9kNkE8pSX9lCKRBFlbCoS785KdFbt9PK62l6KjqtQLoPsjhhV
         P7eC9w844+3d1iqBASNApEWETb+OrECXVOBSlfgnrfXnLzURs2I/I+uhXkQRHO5m6qY4
         l+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qqGEA6MndaB0p4eKxUV0Iv+ZKsY1XUAaezZQYJCg3PA=;
        b=jM71NtbQ5rjdN94GnXtKCe27Z9TPIFgCSHJo9h336wSJL7r4z2OAjMqRaNXIQp5uUz
         yXtoR2VivM4zRSGciTQjStE9oOjtdl8sUGS1hCmqaVkVDtuNIYz8mVzz+4exHyfgJXxi
         2sCoHymfSOEyJQ0/z9mbUReB5Xiw3vnBNggJv8b6s8PilWWUOi1P0QVu5bXboDLwJ1PZ
         s21FEO+hrILc/5KAOoam2qSsGFfLHvgimVGf18GcA7csO1Dhl/Td6CF0M9lvJFSbmgia
         +RvlDrTzAxvBRtm4owgBV9Y9WS5lKWR9F3R+M/vChvayFiymDk0zE/PtYVPygcz3QcsR
         umZg==
X-Gm-Message-State: AOAM5334jESh6Ya1KcQV40+FDVqmuchmRK5WEIsdRswc16rJF+ox/iZA
        QnUhryRRpNWuUsF1tcxHnhQI2a/1ZCsTwlbCI5g=
X-Google-Smtp-Source: ABdhPJz7UKl07X/7jPYyxGlrX1lCVDBjaup+e1ccMKel0eNmOcGaoruZx05gxcDdOfVWmybMdLZlRtBnUycacNaWbjE=
X-Received: by 2002:a25:d691:: with SMTP id n139mr6464105ybg.27.1629226633097;
 Tue, 17 Aug 2021 11:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <342670fc-948a-a76e-5a47-b3d44e3e3926@canonical.com>
In-Reply-To: <342670fc-948a-a76e-5a47-b3d44e3e3926@canonical.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Aug 2021 11:57:02 -0700
Message-ID: <CAEf4BzYP6OU23D33d6dzgpYyXqSGrQUpenrJStyYFB3L7S93ew@mail.gmail.com>
Subject: Re: bpf: Implement minimal BPF perf link
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 10:36 AM Colin Ian King
<colin.king@canonical.com> wrote:
>
> Hi,
>
> Static analysis with Coverity on linux-next has detected a potential
> issue with the following commit:
>
> commit b89fbfbb854c9afc3047e8273cc3a694650b802e
> Author: Andrii Nakryiko <andrii@kernel.org>
> Date:   Sun Aug 15 00:05:57 2021 -0700
>
>     bpf: Implement minimal BPF perf link
>
> The analysis is as follows:
>
> 2936 static int bpf_perf_link_attach(const union bpf_attr *attr, struct
> bpf_prog *prog)
> 2937 {
>
>     1. var_decl: Declaring variable link_primer without initializer.
>
> 2938        struct bpf_link_primer link_primer;
> 2939        struct bpf_perf_link *link;
> 2940        struct perf_event *event;
> 2941        struct file *perf_file;
> 2942        int err;
> 2943
>
>     2. Condition attr->link_create.flags, taking false branch.
>
> 2944        if (attr->link_create.flags)
> 2945                return -EINVAL;
> 2946
> 2947        perf_file = perf_event_get(attr->link_create.target_fd);
>
>     3. Condition IS_ERR(perf_file), taking false branch.
>
> 2948        if (IS_ERR(perf_file))
> 2949                return PTR_ERR(perf_file);
> 2950
> 2951        link = kzalloc(sizeof(*link), GFP_USER);
>
>     4. Condition !link, taking false branch.
>
> 2952        if (!link) {
> 2953                err = -ENOMEM;
> 2954                goto out_put_file;
> 2955        }
> 2956        bpf_link_init(&link->link, BPF_LINK_TYPE_PERF_EVENT,
> &bpf_perf_link_lops, prog);
> 2957        link->perf_file = perf_file;
> 2958
> 2959        err = bpf_link_prime(&link->link, &link_primer);
>
>     5. Condition err, taking false branch.
>
> 2960        if (err) {
> 2961                kfree(link);
> 2962                goto out_put_file;
> 2963        }
> 2964
> 2965        event = perf_file->private_data;
> 2966        err = perf_event_set_bpf_prog(event, prog,
> attr->link_create.perf_event.bpf_cookie);
>
>     6. Condition err, taking true branch.
> 2967        if (err) {
>     7. uninit_use_in_call: Using uninitialized value link_primer.fd when
> calling bpf_link_cleanup.
>     8. uninit_use_in_call: Using uninitialized value link_primer.file
> when calling bpf_link_cleanup.
>     9. uninit_use_in_call: Using uninitialized value link_primer.id when
> calling bpf_link_cleanup.
>
>    Uninitialized pointer read (UNINIT)
>    10. uninit_use_in_call: Using uninitialized value link_primer.link
> when calling bpf_link_cleanup.
>
> 2968                bpf_link_cleanup(&link_primer);
> 2969                goto out_put_file;
> 2970        }
> 2971        /* perf_event_set_bpf_prog() doesn't take its own refcnt on
> prog */
> 2972        bpf_prog_inc(prog);
>
> I'm not 100% sure if these are false-positives, but I thought I should
> report the issues as potentially there is a pointer access on an
> uninitialized pointer on line 2968.

Look at bpf_link_prime() implementation. If it succeeds, link_primer
is fully initialized. We use this pattern in many places, this is the
first time someone reports any potential issues with it. It's a bit
strange that Coverity doesn't recognize such a typical output
parameter initialization pattern, tbh. Maybe the global nature of
bpf_link_prime() throws it off (it assumes it can be "overridden"
during linking?) But I double-checked everything twice, all seems to
be good. Zero-initializing link_primer would be a total waste.

>
> Colin
