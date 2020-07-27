Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8B222FBD2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgG0WFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgG0WFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:05:22 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61E6C061794;
        Mon, 27 Jul 2020 15:05:22 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e13so16848044qkg.5;
        Mon, 27 Jul 2020 15:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WuFdlm+CwCfC5jm4EAsuXY89WjDd91XAqsuAZzGK8mQ=;
        b=PAolxzQ2iUlCuHDBs8UfBB7KdiLqoIOCLPfykpyhW6G8pTLvwaf47IXSCLLLhbwA+r
         iTQLd2XrTqDzqT/MGnYqcllM1gjEzX83ZnQSOqcn8wpyb7519Lpd7K53T916HgJRu1o8
         pBs2pfSJikX/gZNpKGjcHPa13o2d8ivm9pFJV8ZtFeWqRe9dH+eXSD7bVhfnHUKxAaRc
         LM0nJXHqgzOx4YLYGtUCFIzag0H97fsliRyGf0qh/gBRSeFj+C7fyOChCsS1fWlrFkj6
         WZhGuwm1XGEsvw+Bdm1zqaUGXj+7AG517MPCcP0zvs61uuBjK0kziHXi/1DpjkPB7SZ9
         fuQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WuFdlm+CwCfC5jm4EAsuXY89WjDd91XAqsuAZzGK8mQ=;
        b=ZiEdKgNC2tz6TdCNZKNjEV/ILe4/vUa+6Lsxt4aAq8uPSW02/5jkEBV0/DCK72Hpj9
         D3Xe2RpftwrL4MDCCaXn7Qp/5pGWi9I8Y/iS5LZ43LM7AUIZCgbW3/QjmCHZX1ZX2rKq
         VEM/C2k2VC/tpw7UFbhqE50lNGfC3zK5+tBQJBhfiQpI0kv/lbUTRdSYs7G13O5O+nt1
         zJxLvGDjq0hiHhR7fzughdqFotHZEUMSwBOUNa4J/ePk7BNC2Ze/2cZNw7izuAPC0sse
         Fboqd3Wo29p9Oo9sl62AJ4SqwIaeUW4FJPpvme9rElJiTcyMPrzKKS0ssF/NUEydEBES
         0Vlw==
X-Gm-Message-State: AOAM530PiT4zjAgKc48tqDafB8W5vqTLeBqcAZUH0Itc0HpJFMTEMkdJ
        Yuvxkkcd486UHGXxG28GJtSgvNCiE+KtVsARgO4=
X-Google-Smtp-Source: ABdhPJyLba6B6ZS6EMcnNTr7/0bdvGuB1aK7l4LLL8zAo+CMqhBgfxT0JLGRKctvy+AsA7PIkIgqZhT2OQwfBDizkU8=
X-Received: by 2002:a37:afc3:: with SMTP id y186mr5804406qke.36.1595887521999;
 Mon, 27 Jul 2020 15:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-30-guro@fb.com>
In-Reply-To: <20200727184506.2279656-30-guro@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 15:05:11 -0700
Message-ID: <CAEf4BzZjbK4W1fmW07tMOJsRGCYNeBd6eqyFE_fSXAK6+0uHhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 29/35] bpf: libbpf: cleanup RLIMIT_MEMLOCK usage
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
>
> As bpf is not using memlock rlimit for memory accounting anymore,
> let's remove the related code from libbpf.
>
> Bpf operations can't fail because of exceeding the limit anymore.
>

They can't in the newest kernel, but libbpf will keep working and
supporting old kernels for a very long time now. So please don't
remove any of this.

But it would be nice to add a detection of whether kernel needs a
RLIMIT_MEMLOCK bump or not. Is there some simple and reliable way to
detect this from user-space?


> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 31 +------------------------------
>  tools/lib/bpf/libbpf.h |  5 -----
>  2 files changed, 1 insertion(+), 35 deletions(-)
>

[...]
