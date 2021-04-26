Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46AF36B815
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbhDZRbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbhDZRbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:31:01 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96749C061574;
        Mon, 26 Apr 2021 10:30:18 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id p126so12220794yba.1;
        Mon, 26 Apr 2021 10:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9n5D+hkZbPK/ZfxCHGcNZZEvdwn5L+KRHD+/WAxIMv8=;
        b=CFAQ3b+LMMMHBc8iZ4UvT8VEdjYsh/A1tf/GEMjy3CPTuSYrUq7m04cY+iTkwywWBs
         FcuvGvpZtPlZ9lLE80aBOdTS2raODrOAEjY6t/PTRg2Air5rBFRPidCX9Ft5ijcnVVK/
         5tcmggSJ9azxx+Ux3mVDAryQiKoWut2bOa2QnyQSGgTWPoAoakN7dWlbKusd0kNQaTbZ
         d82dIWV5c1X9BOsn/qlK6nz/fcCutX+bg1tXPuWVk0PO4sCmzkd5aiE/Y1BO59DDjpzh
         pPQ6fmACNrFKaJDCUiBCpkfIa43j5s1RuYfzBBRRAyOmGCxP2dixGte+n/fLw+Jp0XeU
         CzCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9n5D+hkZbPK/ZfxCHGcNZZEvdwn5L+KRHD+/WAxIMv8=;
        b=XDVSjzO+/LMdg+yUOseo6L3sE1YFfNa7qYYG+J1BQBIha8LOlMLpIMRNKYSCZFnLFh
         2bfu+uYDOAEcsQg8d06WDV5Cl0HNTcRAj7JmM0cM8NyzscHBaAvbhPqTF2ysrec9Mb0O
         Eqmh590p8/MU8/ad33Skf4SyGZaQhbwLftNzW72oU03kzcEqHj4iIpfAXyas+u+Z+ahw
         H0k9MQ5xKeSAMVLVrsD9Tf0H9Uzd+sy0Ctj3RndC3EVkQSLiDhbDdBQ/6FmNXaTb509o
         BErraFOBEecbEN279MaNIE04FVU466QGII9lb+HThFdOBRVITK/FDCAGUMeqQlJGotmY
         aoFw==
X-Gm-Message-State: AOAM530QGV3r1jT8R0zZ4J01IhwUBgURIiH2VqJ1lEdlQ2Bc9QLsUzfJ
        ytb45+KcQI3mUMSKKk+eK7DChLGzwE4X4hCnl0Q=
X-Google-Smtp-Source: ABdhPJwXEXZBjbw5/kM8aApP1oKL1UR2gc+ngK0d1dtWZO7HaZAEzyb+6bm42d+VeQotr695BJ2XuFe3Lfpc5tc+Hbg=
X-Received: by 2002:a25:2441:: with SMTP id k62mr25720356ybk.347.1619458217892;
 Mon, 26 Apr 2021 10:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com> <20210423002646.35043-14-alexei.starovoitov@gmail.com>
In-Reply-To: <20210423002646.35043-14-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 10:30:07 -0700
Message-ID: <CAEf4BzYzGHejVpQdi7Z_ztHiFte1H9OhXJzuv22kV1Lrn+fLWg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 13/16] libbpf: Add bpf_object pointer to kernel_supports().
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Add a pointer to 'struct bpf_object' to kernel_supports() helper.
> It will be used in the next patch.
> No functional changes.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 52 +++++++++++++++++++++---------------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
>

[...]
