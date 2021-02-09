Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162C4315517
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhBIR2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbhBIR1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 12:27:37 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C92C06174A;
        Tue,  9 Feb 2021 09:26:57 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id e7so16791738ile.7;
        Tue, 09 Feb 2021 09:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=6PvAm3QwxGsDZsZoQTDksRmElDwRMDjBuqTV7b5B5Ok=;
        b=ftAMCLwOoSzTEDjFYM/0rR1EcV7zCOs2YhFXINQ8ov2HlUIHJHzRJ12Q8ArUtOWTCs
         3iAE79P7jFUI4Mp82wxYvB0JT/0jrmSzivqseYGRvO202zA4+AWxMU2dl3DG9XTEeEFr
         VL0t6sC9EMtvojD1KLwjZTg6zqlC99/sSa0BPNlniU1OFXGKuLxhY5hxDFy+wqV/kIx3
         Vrtwe1Inpe+wnK/8e0t36wL3ZxQQGy3mvcTkmrLPLvIB7Ti06nYeNyqhAtGpR4V1BFTQ
         /PsnmmRBlTWlqeLL5ugbnoxPVDHAvyn4EXVswVZ4zQrypM7CibqZYA/oEZqLyjC9kLfn
         8k5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=6PvAm3QwxGsDZsZoQTDksRmElDwRMDjBuqTV7b5B5Ok=;
        b=sitSk3mX+FnfxYwQ3wAZVSyn6xtpHR1TsMSWmSX97GA/h52oWuFu7MfOd4Br5ZKHEu
         JWmE0jSdz3SNPcRCl3INN40R3oSMhBRTLQTEYKMZLx94kflhu5LbmFh+VNzjdlxL3AQY
         9A9juQkFCxGW3SLFNH5Eq277G1biMWQq1S7842lMRb/S5F0ODgGB87Q8dphqDexMkBlT
         v3kdaPHUMTHP7oYTgoxrJZlxlP3mpm3Kq7nbACGSn24T5++4p7VzMjRRWCfnJKjB7D6k
         L2kFOMYhFrxHwT1yRDA9A25EdRslJieX9xq4x/0do1abyU8eReSSMJqeiCKuXa4jhhtF
         2MMw==
X-Gm-Message-State: AOAM531yPhIn2cBG6Wm8cIJ8RF9eyMuozOU5gkRNP17GFA73acgK2sCY
        uDW8oJ+GQj4dGFK9LQbjHij0p/ipuCAggpwYS2M=
X-Google-Smtp-Source: ABdhPJzjFsxd1Jx8D6WSw4iGNU9YPRHP9lt6r1niteZtOcIDIFklLcUOTDt0j5dQeVnCrmVzpiBf9elr6/gIRDOA7u4=
X-Received: by 2002:a92:d8c5:: with SMTP id l5mr7983976ilo.209.1612891616488;
 Tue, 09 Feb 2021 09:26:56 -0800 (PST)
MIME-Version: 1.0
References: <20210209034416.GA1669105@ubuntu-m3-large-x86> <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86> <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <YCKwxNDkS9rdr43W@krava> <20210209163514.GA1226277@ubuntu-m3-large-x86>
 <CA+icZUWcyFLrFmW=btSFx_-5c-cUAYXhcjR+Jdog0-qV-bis7w@mail.gmail.com> <CAKwvOdkQixhz1LiMrFx=+zf5o29UHaUrGTz=TPEsigtGakDXBA@mail.gmail.com>
In-Reply-To: <CAKwvOdkQixhz1LiMrFx=+zf5o29UHaUrGTz=TPEsigtGakDXBA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 9 Feb 2021 18:26:45 +0100
Message-ID: <CA+icZUW1tyGK8tYnhhhODR4n6-8ozmqHyJ9V3HZGj0xEqV=7Fg@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Nick Desaulniers <ndesaulniers@google.com>
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

On Tue, Feb 9, 2021 at 6:12 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Tue, Feb 9, 2021 at 9:07 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > We should ask linux-kbuild/Masahiro to have an option to OVERRIDE:
> > When scripts/link-vmlinux.sh fails all generated files like vmlinux get removed.
> > For further debugging they should be kept.
>
> I find it annoying, too.  But I usually just comment out the body of
> cleanup() in scripts/link-vmlinux.sh.
>

That's fine with me.

- Sedat -
