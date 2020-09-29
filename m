Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E924027D577
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgI2SI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgI2SI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 14:08:56 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A172BC061755;
        Tue, 29 Sep 2020 11:08:56 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id f70so4289364ybg.13;
        Tue, 29 Sep 2020 11:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r/5FPvYhuqZfk0XDpMFDxw6A2OzBlYL9CLRDtRf2rhA=;
        b=rQt81c37keZPYHPBj0XiuhFgBpT/oSKiHgjr27BUzSAAsBGLYz8FCNFvmGT+NesLNK
         EuBJWXFBdEqCFj3/LT2ucgtNyTJOB5xYr2jrkBMPT+y1Tyg795YrmWHnGijDo6LqX4E3
         7ocId4WZG/ItlxhnPaldTGwhQLh9oNCTKyQ3Ns3tDxGk2BA+DwM08ZJMsn4+I2SgDWSm
         pZKp7wBHYzW1kPqvqqTeOFn/0BC2MC+VFmaAqAG2wBmTQzBx+S/vobuD3h1XjOeVglfM
         9prYNoLXrs0Wo782JU4Np3qVFrjmwGs8iy/IqwG+8XTqAAG7Pg3ipH6+Sn2fGSiMLStQ
         ScNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r/5FPvYhuqZfk0XDpMFDxw6A2OzBlYL9CLRDtRf2rhA=;
        b=GZK1GxJz4uTjVAOjvRePI4025AwxFh3/hILLdj07F9h3gW/TVKDGKCjbGtSsgJFRH9
         vOSlwImCVxGGM5Rp1rOVjgiDSWpQ5UgWYq6XcS/Y4/v9soVx4izgZzNDqv+E1dqvInn5
         0IJH48DAX4wBY6h7Xq4inRZdLErBDHvlNSfHHLvzDDWABnUzsu/bI8ttd1QpSZUAdgQ9
         aCVOCbXoMsT2ASz+M80iUXO1KyHaKV8h2DVtT8i72Ud9JoORNsajoZ+jlK7Hbd5zpXoO
         nmCc+TteV2i9yOGB8CcKqBO5DZGjzT0hJyetXRNSTcqH0VP0adKEvdIhKlEOzL1ky/Q+
         CHXw==
X-Gm-Message-State: AOAM532EtfQD6RYyVnxe/FJ5t+ApYdjMs/G8Dp/js6tSH3+KrOEZr4/x
        zjHcSZTHlNvMl9vFEymJFHjhtDbKJan7HorqRW8=
X-Google-Smtp-Source: ABdhPJxXB8fyxXE0wD9bPvz7K3AGTX1TCgre6QBJIWtahFJJwMpSLoHoCb03keT3HRyhgkoc+tPQDxBsi4XhqKJtNEo=
X-Received: by 2002:a25:2d41:: with SMTP id s1mr7585585ybe.459.1601402935930;
 Tue, 29 Sep 2020 11:08:55 -0700 (PDT)
MIME-Version: 1.0
References: <1601379151-21449-1-git-send-email-alan.maguire@oracle.com> <1601379151-21449-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1601379151-21449-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Sep 2020 11:08:45 -0700
Message-ID: <CAEf4Bzbj9ox+9jzf0ANjoMcygFN5k4dT=_28MPBFj5TEYKCb7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: ensure snprintf_btf/bpf_iter
 tests compatibility with old vmlinux.h
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 5:26 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Andrii reports that bpf selftests relying on "struct btf_ptr" and BTF_F_*
> values will not build as vmlinux.h for older kernels will not include
> "struct btf_ptr" or the BTF_F_* enum values.  Undefine and redefine
> them to work around this.
>
> Fixes: b72091bd4ee4 ("selftests/bpf: Add test for bpf_seq_printf_btf helper")
> Fixes: 076a95f5aff2 ("selftests/bpf: Add bpf_snprintf_btf helper tests")
> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

That works, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/progs/bpf_iter.h       | 23 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/btf_ptr.h        | 27 ++++++++++++++++++++++
>  .../selftests/bpf/progs/netif_receive_skb.c        |  2 +-
>  3 files changed, 51 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/btf_ptr.h
>

[...]
