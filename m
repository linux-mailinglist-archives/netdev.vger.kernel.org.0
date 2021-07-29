Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F713DAFB4
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 01:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhG2XIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 19:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhG2XIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 19:08:38 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282D7C061765;
        Thu, 29 Jul 2021 16:08:34 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id j77so10851359ybj.3;
        Thu, 29 Jul 2021 16:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OpGJywmBQN1vSXsTZJu4lRgLbPWeyylOKnTw/mPweSU=;
        b=pw9PDwuuj2ULyst/CbdAxef421IzQBtd2sNnjJSg0mZL3Z7JLVJI2vvl5r274ScQNm
         W9ZxbhKarkOf133YutNNG6TnRuQho7OPPj6OJ90DOVE0i/NyiQK/AV6uerib5sDqMlv3
         mgAPthsFUncY/eKyYRVPPw4kxfvg2bzdrkCedMt0dtMtaRK/uQtRXbkss12+1m483DMs
         TdRO3OlaLGHkVKqsgQsEttw2YW+acvhM6jCk6evuSZ/U5dWbL1F1BBVXDpUIVrJu5GE0
         2LU3GOouxmR2yd6zKFcnmEgAjEqSYM2jBmdaJI8ydgLV29oGWeWfaX3QtZr8t2gDA71L
         YLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OpGJywmBQN1vSXsTZJu4lRgLbPWeyylOKnTw/mPweSU=;
        b=OP6rFZsNpBaFuKWWf0wBBHWbAJJiItwkePC8dvMbAFLDT862u7p7cEAe/E6mD9phVj
         rCt2Ua0ZQ0e+xMAMLyo1eUGNrMVD+HAIeK8/dGCF8YSRNIX7N9VnroooTS0fTBxWxol0
         +rIXAlnbY35zTScCkYcSoogezkYMzTM9SbecN08SXcz1WjGvozxXlXBFGzOccHkrGH+L
         CGdRktPkN/EfNg+GOanOWpygUjPyzLEPwuj5tF6FHYP04WohthR6W+8yqT7I5sqC4aIn
         KVPMFSov+jBVGIxgsgfsHssQM/Wbqv4D+7EAwP9FXfPFCF1B9aphJ3PTeKc/pqJvV+Fw
         jsPg==
X-Gm-Message-State: AOAM531LwnfF3BQg89B+nvpcPsL3oYuJT2zBTfbftsAexZYEBUPiC5iz
        SoVxbXg1mUGShTBRrpeLCm/jDDDysurcuskbTTI=
X-Google-Smtp-Source: ABdhPJwrI7ifqXpMgVoO0jxmjk/nk7N+HNsvvOz9npd+c/XZRuUfsCNRuP2sE+mSxhRBgGoSwD1w9b84AHemAJafPdQ=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr9524409ybf.425.1627600113388;
 Thu, 29 Jul 2021 16:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210728151419.501183-1-sdf@google.com>
In-Reply-To: <20210728151419.501183-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Jul 2021 16:08:22 -0700
Message-ID: <CAEf4BzZBcG=CDVrMVb4i6x90MvpPDOXhkoZ3rHUpx3+FMUE6NQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: move netcnt test under test_progs
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 8:14 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Rewrite to skel and ASSERT macros as well while we are at it.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Thanks! Bonus points for skeleton and ASSERT_XXX! ;)

In addition to Yonghong's comments, a few more below. Missed assert()s
require a new revision, unfortunately.

>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../testing/selftests/bpf/prog_tests/netcnt.c |  93 +++++++++++
>  tools/testing/selftests/bpf/test_netcnt.c     | 148 ------------------

Usually there is .gitignore clean up as well.

>  3 files changed, 94 insertions(+), 150 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/netcnt.c
>  delete mode 100644 tools/testing/selftests/bpf/test_netcnt.c
>

[...]

> +
> +       skel->links.bpf_nextcnt =
> +               bpf_program__attach_cgroup(skel->progs.bpf_nextcnt, cg_fd);
> +       if (!ASSERT_OK_PTR(skel->links.bpf_nextcnt,
> +                          "attach_cgroup(bpf_nextcnt)"))
> +               goto err;
> +
> +       if (system("which ping6 &>/dev/null") == 0)

see 4cda0c82a34b ("selftests/bpf: Use ping6 only if available in
tc_redirect"), we should probably add some system() + ping -6/ping6
wrapper into network_helpers.c and use that in at least all
test_progs' tests.

> +               assert(!system("ping6 ::1 -c 10000 -f -q > /dev/null"));
> +       else
> +               assert(!system("ping -6 ::1 -c 10000 -f -q > /dev/null"));

no assert() please

> +
> +       map_fd = bpf_map__fd(skel->maps.netcnt);
> +       if (!ASSERT_GE(map_fd, 0, "bpf_map__fd(netcnt)"))
> +               goto err;
> +
> +       percpu_map_fd = bpf_map__fd(skel->maps.percpu_netcnt);
> +       if (!ASSERT_GE(percpu_map_fd, 0, "bpf_map__fd(percpu_netcnt)"))
> +               goto err;
> +
> +       if (!ASSERT_OK(bpf_map_get_next_key(map_fd, NULL, &key),
> +                      "bpf_map_get_next_key"))

it's ok to use all 100 characters if that helps keeps simple function
invocations on the single line, so don't hesitate to do that

> +               goto err;
> +
> +       if (!ASSERT_OK(bpf_map_lookup_elem(map_fd, &key, &netcnt),
> +                      "bpf_map_lookup_elem(netcnt)"))
> +               goto err;
> +
> +       if (!ASSERT_OK(bpf_map_lookup_elem(percpu_map_fd, &key,
> +                                          &percpu_netcnt[0]),
> +                      "bpf_map_lookup_elem(percpu_netcnt)"))
> +               goto err;
> +

[...]
