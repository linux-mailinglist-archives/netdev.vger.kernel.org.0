Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743B6149636
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgAYPXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:23:35 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:33839 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYPXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 10:23:35 -0500
Received: by mail-lf1-f42.google.com with SMTP id l18so3203935lfc.1;
        Sat, 25 Jan 2020 07:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nqs08425RUN3uyEpWTzaksGv8utumJixkeluY86HgYI=;
        b=H4nwxo+nKidqIAWFRMpJ17p86ZPPu0eGk7Qps6fgrxt7lnRZYoTE4LuL+JXf2KZQBu
         3B/xQk/Ci0z0gegWmCITyzcnP+6jrIutPPykwXxvUEtIGZRYNMz/brmjN/xoSkJZpFDp
         /Tn+w24anZgNgDqYMXwXSv8Do59Ow9COWhzEVRj+Q5HPyS0ZoPTwWZ1VKIxPej6GJdjJ
         lYo79mP07YFMZ4YW22eWePJsDJYw9T+RErd3hI/pads3bHJYTL2DMFqoQwSL3zkZ6ETc
         wjP/oaPVYgmbUzI5qJskaLlXHtYi9oFIajEWHreoBEDm7dzxViwZ/S+rRsWHX1M3+vcX
         ejdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nqs08425RUN3uyEpWTzaksGv8utumJixkeluY86HgYI=;
        b=aScYR0HvJocqWqulkbAQ4uhpEzaMyg0WFgyYJRcpzBYxqwl9HRDuc7fm74Sj3QSq0R
         VgLZscdSNlmy+g4Iw6QYcZF3dmYoRYORTHfWFjuSFadsNXzDEfiu203By0wY7J69bVin
         rQSRL6ch5O+C/EP3UQDnSYAVpUNb2M+XAxJNCAszTnjbL/7H6z8W+MGqK/FtBFrfmqRN
         9fQBE+gVmpZ+9JwBq0oK7ZCXhQGG72U17vGH2j1aXjoq4+oMbsyZiGLKhDQpMhTFWAOu
         f8v2lcMIXKVYTlMGammaLOQEXqdCzchdUWOY40NqKxhOmQxkICyGm2uNflwOPEZeq6Qm
         DOSw==
X-Gm-Message-State: APjAAAXiH+Sp6oDHphSmpNAgnfMsf0WJoX2I0GH25UFRcCQVr3iYD3k0
        AyqQ4Yh/22TOMeS2xAHF/PUaTi9TY5ViqvySj6I=
X-Google-Smtp-Source: APXvYqxLt/1cWcxBYLBmxSo44hlhsCJ6/wTOviEGGreQ1cvaGNkX4YNTfkd27HgtbXjMGJd92P337mFIeIgiQk0Y4ZY=
X-Received: by 2002:a19:5013:: with SMTP id e19mr3989969lfb.8.1579965812962;
 Sat, 25 Jan 2020 07:23:32 -0800 (PST)
MIME-Version: 1.0
References: <20200123161508.915203-1-jolsa@kernel.org>
In-Reply-To: <20200123161508.915203-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 25 Jan 2020 07:23:21 -0800
Message-ID: <CAADnVQLBQ2t30BwqBb9wJc5rM5M9URvKk25HUBa94PuL8tYcDw@mail.gmail.com>
Subject: Re: [PATCHv4 0/3] bpf: trampoline fixes
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 8:15 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> sending 2 fixes to fix kernel support for loading
> trampoline programs in bcc/bpftrace and allow to
> unwind through trampoline/dispatcher.
>
> Original rfc post [1].
>
> Speedup output of perf bench while running klockstat.py
> on kprobes vs trampolines:
>
>     Without:
>             $ perf bench sched messaging -l 50000
>             ...
>                  Total time: 18.571 [sec]
>
>     With current kprobe tracing:
>             $ perf bench sched messaging -l 50000
>             ...
>                  Total time: 183.395 [sec]
>
>     With kfunc tracing:
>             $ perf bench sched messaging -l 50000
>             ...
>                  Total time: 39.773 [sec]
>
> v4 changes:
>   - rebased on latest bpf-next/master
>   - removed image tree mutex and use trampoline_mutex instead
>   - checking directly for string pointer in patch 1 [Alexei]
>   - skipped helpers patches, as they are no longer needed [Alexei]

Applied. Thanks
