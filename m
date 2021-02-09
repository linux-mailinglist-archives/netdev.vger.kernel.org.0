Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892933154C8
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhBIRNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhBIRNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 12:13:14 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28249C061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 09:12:34 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id a22so7625399ljp.10
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 09:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lDMSI3v7ltMIvBubdz7fHFJUzTUea6dzVTOKPGGvbQ8=;
        b=o6OBUPJRj9e+m1Y+DH+0WyghSD+J0B6L5/grMpSW510IA3IvHyPkrGExqAYudEYD6w
         2LMUyuuM+f7BC56gNChF4kUh2l8f5coMfNtYh+2jofomR0yQDlzZ9KrXG0KDePY3FL2p
         lx1xgg45KhZeBclQnJhAkN9Cxg/hIV7qveotmvyRrkRbEfe8iasVdg2hzwOvPieURpi8
         hUTx2JRmZq/6+WgUN/nuNMvdT170eVS5mUbe6aWhQo3IeYDCIUAPoHNdmoc8BH1joQSc
         IcePKUPbyOpMugeDU31lKSI0si/oJduEsDqqiStT8Yfg2HaROY3r3mf1ygW6Oh1X2UOC
         rsJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lDMSI3v7ltMIvBubdz7fHFJUzTUea6dzVTOKPGGvbQ8=;
        b=UqVRtic8XzrL8U4aqVzhgBdJajXr6AvmwQzyYUvLEDMKvUN7TNc+Xl3yUIG6yToauy
         3nbmx/eHQypDWgmAIlc2TzT7LvRqrpVINBd6j4IiCjfqaY5bUrgyhMBYS4YtqEMN0fUD
         vNSa0ToJ5lk5M6AotGDiGVXASlYnPSAwp9SroWAnP5lei68+ak+HN39QNFpsCFuQND4U
         rsR3CugcaDjDfLnRGQeWLlTUMaCxrNS6QNNhUCUanArL+Rach9TVfAcAEe02F0rkTRSU
         i2H0L1PRij0lYrBMkjunkoGW+c9Dz/PuyU5/liTE9sb64iMybc1uJFgBghuJ/NLNouUe
         MLSw==
X-Gm-Message-State: AOAM532/FbMI6M6ijIP3odGQPQU6KqR/HpxNkWTTwoqNzmbnGnXIyCTo
        zKzdaHiljFv9+jo5mYlB1UjuwCq21+Isitcc43AjTg==
X-Google-Smtp-Source: ABdhPJztUqRb7QgYbn/p3w90iPRbcIxstn4kQ+qoy2y/zyE3qgHNXuc4HN5Is+gjdpgEkd/75vAKTwDiY1FTMBAzQIk=
X-Received: by 2002:a2e:b0f3:: with SMTP id h19mr14365459ljl.233.1612890747452;
 Tue, 09 Feb 2021 09:12:27 -0800 (PST)
MIME-Version: 1.0
References: <20210209034416.GA1669105@ubuntu-m3-large-x86> <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86> <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <YCKwxNDkS9rdr43W@krava> <20210209163514.GA1226277@ubuntu-m3-large-x86>
 <CA+icZUWcyFLrFmW=btSFx_-5c-cUAYXhcjR+Jdog0-qV-bis7w@mail.gmail.com>
In-Reply-To: <CA+icZUWcyFLrFmW=btSFx_-5c-cUAYXhcjR+Jdog0-qV-bis7w@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 9 Feb 2021 09:12:12 -0800
Message-ID: <CAKwvOdkQixhz1LiMrFx=+zf5o29UHaUrGTz=TPEsigtGakDXBA@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 9:07 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> We should ask linux-kbuild/Masahiro to have an option to OVERRIDE:
> When scripts/link-vmlinux.sh fails all generated files like vmlinux get removed.
> For further debugging they should be kept.

I find it annoying, too.  But I usually just comment out the body of
cleanup() in scripts/link-vmlinux.sh.
-- 
Thanks,
~Nick Desaulniers
