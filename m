Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB30C43AB7D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 06:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhJZE7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 00:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhJZE7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 00:59:12 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E08DC061745;
        Mon, 25 Oct 2021 21:56:49 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id y80so13716915ybe.12;
        Mon, 25 Oct 2021 21:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=griTNHXzQjHdArBVLlsF9I9olxrqMfs3Xv8jkO2EzNg=;
        b=FW+QFBbmVcrBu5dA5pByCcXBAwmn6Z2FZredL+fc+NqvSO8RAynG7WwmZjdGAa1UVN
         YpqrhsAjPLAN5887/YlsoH0eTrMYKqf7oFmf6OxZo37/o/oTXymU5PTWV5XpxpoogeAL
         FFG0VyUUQvWGNxQpRtHYzuuayk2JFRNHiIr/xKkC7DPv79ty0o8LsVVHj66RwfkT9elP
         Mokek/CgQd85UG5ZvBQSk/VokrunDqEYK8+ELUGj31H9PJRQd8Omru6nY+2OcAJ00HMQ
         Zp4n3cz2RTj0PFUUIasTJjdAI01jc6KuiNn2Q+FEiaDNkpeZFWL2DREbvNLbr5loineP
         knkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=griTNHXzQjHdArBVLlsF9I9olxrqMfs3Xv8jkO2EzNg=;
        b=jeB49GBpIc/Z30dKAxdMPMwhIWNAy0oQwkNSF6ABTX3ruO9VOzRGh3FrEBYDBK8Kec
         YOruAyZgG4mGBQ4D9H3pDMygrwyc4ampXJVtFAzx+Oj8o2WIoW4MzfSaxBpjRgx8+ffE
         tcft430zI1QHRzjYBUsXvjYlQGbJNVPJgHckYQi+rmu7BNQTxb3oPGb/FFH0ZYTD4wUM
         vOUwmGDVjFGlYWnUYksHgKjgAHp+yes8JgC4Na3KYyY8iK5aVzsH+t05sZFhZEsb3OYg
         HJ8dxKPyfkrJtGuQmbeRgNwZzl+yd7O5v00o882a3GHy26LIocu3wmJYSqSMsxh4Iwiq
         xjDw==
X-Gm-Message-State: AOAM533elQeE4ijPIrjxiAbxn834+4LW/uoS9N/a5qJssqYnjdVeFxAq
        bADVeJtx26y6fk5T2np8g5KqE/vUyxt3/WoHFh0=
X-Google-Smtp-Source: ABdhPJz2Gdg7iH6g40zq/N1HlAI+LQvObkDwVK+mBhr79yWZ8v+eK9a08+EQe6oTJCcx7Q7FjfTs7IjZ3zf3TIN3bnw=
X-Received: by 2002:a25:aa0f:: with SMTP id s15mr15397289ybi.51.1635224208584;
 Mon, 25 Oct 2021 21:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211023120452.212885-1-jolsa@kernel.org> <20211023120452.212885-2-jolsa@kernel.org>
In-Reply-To: <20211023120452.212885-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Oct 2021 21:56:37 -0700
Message-ID: <CAEf4BzZimh+OotN3gWR=E-eCGzxFYm7rM8jbgAMy7HRCYpKnNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] kbuild: Unify options for BTF generation for
 vmlinux and modules
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Using new PAHOLE_FLAGS variable to pass extra arguments to
> pahole for both vmlinux and modules BTF data generation.
>
> Adding new scripts/pahole-flags.sh script that detect and
> prints pahole options.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM. I suggest posting it separately from the BTF dedup hack.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  Makefile                  |  3 +++
>  scripts/Makefile.modfinal |  2 +-
>  scripts/link-vmlinux.sh   | 11 +----------
>  scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
>  4 files changed, 25 insertions(+), 11 deletions(-)
>  create mode 100755 scripts/pahole-flags.sh
>

[...]
