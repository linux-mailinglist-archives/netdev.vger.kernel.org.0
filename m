Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3BE2635F4
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgIIS0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbgIIS0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:26:37 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC2FC061573;
        Wed,  9 Sep 2020 11:26:36 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m5so2119459lfp.7;
        Wed, 09 Sep 2020 11:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DkXW3bAWkEMNK4osivbtLHdGrz1wTgQmGCpwVwjmD4M=;
        b=Mg95Mwh9nzAHQp8EKUovrLhNfqCEGq9IfhJtPKM+hwKfjL4BuUjH+dYnbnksApRC3S
         qtiXU5AWfG9g2IoqPPlVfwrMzP+7BXp6i4+X71HylE8zVtrXF1ZBbnuomaYQMZmIH8Lw
         Bi6NQ/TI+x0/ufN92/PaSihBp+ztYW7qq+BWFHzVx50dEkKU1B26Cg4MTnNuJ8r0qm9L
         ehZgIy2sifiCK0T6Vlg74Xvqm0nW3SI2XCA83Ff+kKhkrMveZ60CMmfZO9WUHbllaReN
         dtNPwvWrVJujUkGDcgWjJkaAfxf3FQ4B0WtBojjt0z9FzAJN5PqDH3oT726btw/NJec9
         CNgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DkXW3bAWkEMNK4osivbtLHdGrz1wTgQmGCpwVwjmD4M=;
        b=QZfgWqmMlc47FbILahR3urEZU67e8YaX1GdsN5eUJCTrGOQdCw/dn0iY7WWTzsgMAo
         IBreUR0eTv+FyyZypLket4aLxK+4RNhjSVG4FbsYDJbQO9zv/a3p836n14XRxIenJAll
         YMHw508JOVjagWAvUKR4r2Jf/5V1luxWll9feeW4rGLzIPCTRRmX+4xv8Zoalhxif2Zw
         VI6oz8BOOPF4T+lUWPLku8NMoec+rjdpGQOY3LBetx66hj4w3LhovI9ECyro7VjQcThF
         zHxBqLNXyZCs1t5tqIr6ztxtTvvzISbVy+qrQXkBcsz9WW+RK5P11NeHZ9tpDsofiaap
         6wEA==
X-Gm-Message-State: AOAM532rE0tyebRFSMmaPpkd1OWNgFkfFBt7u/CZZ0MHJuspIE0+KDOa
        0PeBC5FOSVSML1YC8ImgJ0HhSCniZ6+WDxolKZ0=
X-Google-Smtp-Source: ABdhPJzP/cdDxnfvmLu7GMPAUegdLlzVZW3uZQWe1EtkhQGWH2IbF9BxXIkQEEWXwNTAzflXVcZ4BY66LXi7dvZQVfE=
X-Received: by 2002:a05:6512:2101:: with SMTP id q1mr2388005lfr.157.1599675992929;
 Wed, 09 Sep 2020 11:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200909171542.3673449-1-yhs@fb.com> <CAEf4Bza_1Q1Ym513JN4aDEunC49BaBHigJBKmj6N6snbChfwzA@mail.gmail.com>
In-Reply-To: <CAEf4Bza_1Q1Ym513JN4aDEunC49BaBHigJBKmj6N6snbChfwzA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Sep 2020 11:26:21 -0700
Message-ID: <CAADnVQLsRmY2oXY58H_TpQLxNztw6vm0MY9sxr5a+Wt5FFMrEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] selftests/bpf: fix test_sysctl_loop{1,2}
 failure due to clang change
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 11:18 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Sep 9, 2020 at 10:16 AM Yonghong Song <yhs@fb.com> wrote:
> >
> > Andrii reported that with latest clang, when building selftests, we have
> > error likes:
> >   error: progs/test_sysctl_loop1.c:23:16: in function sysctl_tcp_mem i32 (%struct.bpf_sysctl*):
> >   Looks like the BPF stack limit of 512 bytes is exceeded.
> >   Please move large on stack variables into BPF per-cpu array map.
> >
> > Reported-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
>
> LGTM.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
