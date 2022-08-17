Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801CF597776
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbiHQUIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241725AbiHQUIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:08:05 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D392A8302;
        Wed, 17 Aug 2022 13:07:57 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id b142so8513264iof.10;
        Wed, 17 Aug 2022 13:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=RPBe8i5t9YkFakRKumgcWRqJOP8cLatXe+PCl+sDINk=;
        b=Yqmtuq3oHwQ7GENInJRLA2NVz3QyU6Bi5/3j6LXsfNmoed7E0iRHgH9SXxVfAhP6Ja
         8MEwJJK/bAsZHhZtaSVFCrPO1tzlESZj8Siq4vfOonWmLfkeDj7O+I/1a+mAX/PT5L0L
         fT6WRnoI0B3cf72w5NqrGvas12QXiP2Zbf1u+WZ3mlGp6saj2D2UHQ8pudZDbk3hIiGm
         SU+38mlFlYnU5DwaJPYYKP9L6SQEk6FrT1ivx+bB1b9/bCemqTxvYQsafuQLnjpvQqZw
         mqahIx4ZuYCWO8OJPTJoKJgTljss0aYZV/11FtU4CnkqtTvmJ1ajtRW5393lcSZUs64u
         XTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=RPBe8i5t9YkFakRKumgcWRqJOP8cLatXe+PCl+sDINk=;
        b=DqJ1VluIRT0gxMEXp8RoMRSpLo2fVMywHCaeTmwfb4K8JPzDQjeKOte54pKJfXlp8z
         ZoaOQJn2YkMqN8SumbGi8Bkjc1PcvcMQ61VMgBhHbyXo1jcZ6Vc/Xwunj58sMQvyHl2L
         r9Pz7T+fZwo948yhw6US3dLP0bjaBXalpA0VsRskxX5MIhi4o1mwjchGbatw6oljq4Q7
         Jzhk+Ua3/NroyWUoNzji04RowywPYe8Rz8Fqp6BZaqIGy7qgb8bBAK9lV7+n/g1ihHY0
         rUEscvqC103DaCuJQmB0u5Y8ldIA5Hzh8n1mZXT2QxBSaiCr4wq2CKFwlt7ChJJLg5Jm
         PyEQ==
X-Gm-Message-State: ACgBeo358BGrC0bzMYU/QX+5ywhh6m8XIiJtgkHuSu0CaQolGW6p7OyG
        +0qf7/7hdphDj42PYqyOv+QFQxwc+OxNEYa5PL8=
X-Google-Smtp-Source: AA6agR5D/kwF9stJjFFWI6o/HfMzkp9F9fpq74Lp1raW33ZdL3BcDbxG5oEwa8Av42aaTNMuMUQUPgMe516EGipkNKQ=
X-Received: by 2002:a6b:2ac4:0:b0:688:3a14:2002 with SMTP id
 q187-20020a6b2ac4000000b006883a142002mr7225597ioq.62.1660766876361; Wed, 17
 Aug 2022 13:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660761470.git.dxu@dxuuu.xyz> <3268db8bc504f4118e1baee5e49f917f0e2767fa.1660761470.git.dxu@dxuuu.xyz>
In-Reply-To: <3268db8bc504f4118e1baee5e49f917f0e2767fa.1660761470.git.dxu@dxuuu.xyz>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 17 Aug 2022 22:07:20 +0200
Message-ID: <CAP01T74Sgn354dXGiFWFryu4vg+o8b9s9La1d9zEbC4LGvH4qg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/4] bpf: Remove duplicate PTR_TO_BTF_ID RO check
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 at 20:43, Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Since commit 27ae7997a661 ("bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS")
> there has existed bpf_verifier_ops:btf_struct_access. When
> btf_struct_access is _unset_ for a prog type, the verifier runs the
> default implementation, which is to enforce read only:
>
>         if (env->ops->btf_struct_access) {
>                 [...]
>         } else {
>                 if (atype != BPF_READ) {
>                         verbose(env, "only read is supported\n");
>                         return -EACCES;
>                 }
>
>                 [...]
>         }
>
> When btf_struct_access is _set_, the expectation is that
> btf_struct_access has full control over accesses, including if writes
> are allowed.
>
> Rather than carve out an exception for each prog type that may write to
> BTF ptrs, delete the redundant check and give full control to
> btf_struct_access.
>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
