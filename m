Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CFE257B83
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 16:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgHaOwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 10:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgHaOwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 10:52:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5190BC061573;
        Mon, 31 Aug 2020 07:52:05 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o5so2344656wrn.13;
        Mon, 31 Aug 2020 07:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i1NZkDztc/ANb1Hw59OqfV/yps0w4yw+bNcJTCGH+i4=;
        b=Di2a9eIK50uM0R2hiAjT2TqNpmsMnxpMn53p/u3xV+yaclk6to3aPJ9l2ppzkf+FrI
         3VbNLqjgcgOnUwRZD5WCa4/CxHgFPoChq2FvtWJSoibt5oEoczn8wqlsBWsEhCMefggu
         HkIFe68VXBpaFKAzkLDoq3/Cy3V3/IIMNmtrmKmwdaft+SbM1C5wSYcEUX4fLUSC8rL0
         Z8Ok4Uyn1BGuKrAHZ6bHpT96QkEWqnQjBHrvM8hSb9lXINNlQ/7SfmspyarBjcBYyuf5
         LBNy4bmL9IoVSPzcIe6xIAFENnvFErS8rXuyJb71aZkJubvdqivN8QQ2kAMs5ubIo6iG
         nWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i1NZkDztc/ANb1Hw59OqfV/yps0w4yw+bNcJTCGH+i4=;
        b=ApaS7poQ2euiAYS5sC9u3fRQ4CC93WjpVtkizX9oCxS1ECBrIXNc0d+El99gD7elkQ
         IU9mt5yj38Nd/7qf5KdAIwcY3hX5vrCeAZ3KRJxzOa7GtkOsHtOxav+tva/dDwUjz1tx
         tYRAJbeeVVmQb840b0BNAlgVp0dpVRXEPvJ1/qexK+f2VDAqshwVgTY6byGy+0EGb5eo
         OCImqm3we4s1KoghSVy1wn4e+hTGOE8Un0GTI+Vp1oFVjKxjw7gIqP1dRsTSMjHDZO/R
         1sC+gEnPecakhH8TyWKxjL3GYSz4LJg4htRgtuOr+eXBEGXxMM8tVuTNkv4gIDeNOQTR
         5N4w==
X-Gm-Message-State: AOAM531AjfqiZ0NnnzZqqpIsY+FynfVX+Wb2P5bigWyNZikw6SwBVmk/
        ZXpiIwFyKPAEOJ3rITDhPzCi6zbpxNaySumyErQ=
X-Google-Smtp-Source: ABdhPJyXZhOxgG1XA4QkDaXzTeTCuUER+/ij06gTyE3xgh1xmXkP0tuJbrV5tIi6DtKFpuvSfXGgdNA3znlo45SWfcg=
X-Received: by 2002:adf:81c6:: with SMTP id 64mr1940077wra.176.1598885523700;
 Mon, 31 Aug 2020 07:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com> <20200827220114.69225-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20200827220114.69225-3-alexei.starovoitov@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 31 Aug 2020 16:51:52 +0200
Message-ID: <CAJ+HfNgsP+DhQ16N3N4VtXNbmyE8yhZU7XFBG6gPimm17196pg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, josef@toxicpanda.com,
        bpoirier@suse.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Aug 2020 at 00:02, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>

[...]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6f5a9f51cc03..3ebfdb7bd427 100644

[...]

>
> +/* non exhaustive list of sleepable bpf_lsm_*() functions */
> +BTF_SET_START(btf_sleepable_lsm_hooks)
> +#ifdef CONFIG_BPF_LSM
> +BTF_ID(func, bpf_lsm_file_mprotect)
> +BTF_ID(func, bpf_lsm_bprm_committed_creds)
> +#endif
> +BTF_SET_END(btf_sleepable_lsm_hooks)
> +

I'm getting:
  FAILED unresolved symbol btf_sleepable_lsm_hooks
when CONFIG_BPF_LSM is not set.

Adding a BTF_UNUSED_ID unconditionally to the set helps, but I'm on a
BTF limb here, so there might be a more correct/obvious workaround
here...

Bj=C3=B6rn
