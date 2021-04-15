Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339CF361616
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbhDOXWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbhDOXWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 19:22:51 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B56C061574;
        Thu, 15 Apr 2021 16:22:27 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 65so28052272ybc.4;
        Thu, 15 Apr 2021 16:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nu29gQa5rCWwaGP+3hOEc439kMWISL5dJFk/f8+ft7g=;
        b=TydsCjR3BVT0kNQAfMVhCEN7Uj3tQFuKd6rQKk/NQKevM62CQTIQvnSjm0hqpWHcWT
         IwikOxWsiew4ptw+vg88pRynDmY3oOVnBdAhdTAWMIzSVWbj+PI5fwRNjVdspaXW+I2V
         cGSebUs2fbIb3d4umMQHYTCEuvXYnqxZiZS9lOls7o0fYzBwDqXIo4qe52+nKSPg6y0C
         cjgZMRNP64+LHd47pfRFouYD18pMvEYnzu0RbExdqTEJEs10c/bkXwWwQT/8YXPG4qdx
         PnizRc/uqOxmk4K870F+bA7gdA78CL4aa5zgemKu/4+nrvZRPA7L1IMnN5OuP2EMphPy
         RTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nu29gQa5rCWwaGP+3hOEc439kMWISL5dJFk/f8+ft7g=;
        b=TzCBHaxadBGelHJainAadWrkw6uyeIQRfYgk9m2njFAkf85Q6Q0Z2T6NmNvIblalnn
         jmKl++HTTIU/KbvBgF2cQiZbkBtY4uLtarPz9hAVRT+yPhuCZp9mwstUFaVKosiA5U1L
         QBMnilcYmC57ZfKwpWluQOoE6ZltB/dxwh6LyPFCVV/vbxkUMQWXK2UF7f4pqfHUvytK
         E946cg0x+vVBm+wFJl08/jiGHJeugamGx1c73OAsRXzy0WTa2ACipDS/XnXw2Sn8Hb8J
         tEbwxkoAnR9pTpZ1Jlyk9ASCzUDlwvXbYtSTfBRD+sm+DfUYsKiYeE31SYJ2RYh40Nfm
         PESA==
X-Gm-Message-State: AOAM532eK7N9RJDDCUFLBHALlDTgcdtVj7XcUGaIF3N4vwjk8LQib61f
        e6+ynXQjvNXs7Uz362S2BVu6ok7yAzTllGEcOgY=
X-Google-Smtp-Source: ABdhPJyo8v9LrvabLYnSynbdvAhsQPxu1k+lCkoPL/VYyI/b4XY28/pdv1G1RVi1kaFhXbPCUn4RV10GX4qF+udRsEI=
X-Received: by 2002:a25:9942:: with SMTP id n2mr7972000ybo.230.1618528946554;
 Thu, 15 Apr 2021 16:22:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210414195147.1624932-1-jolsa@kernel.org> <20210414195147.1624932-2-jolsa@kernel.org>
In-Reply-To: <20210414195147.1624932-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Apr 2021 16:22:15 -0700
Message-ID: <CAEf4BzagYcy-UxbgXGC81B=K02-wUctvUSTFDySsR6B0cJdwaA@mail.gmail.com>
Subject: Re: [PATCHv5 bpf-next 1/7] bpf: Allow trampoline re-attach for
 tracing and lsm programs
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 5:44 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Currently we don't allow re-attaching of trampolines. Once
> it's detached, it can't be re-attach even when the program
> is still loaded.
>
> Adding the possibility to re-attach the loaded tracing and
> lsm programs.
>
> Fixing missing unlock with proper cleanup goto jump reported
> by Julia.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/syscall.c    | 23 +++++++++++++++++------
>  kernel/bpf/trampoline.c |  4 ++--
>  2 files changed, 19 insertions(+), 8 deletions(-)
>

[...]
