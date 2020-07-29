Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4408D231BB2
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgG2I5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2I5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:57:24 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3DAC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:57:23 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id r19so24149877ljn.12
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=HJ8+zYD3bs4pqtCvGKcax5bNzzsJHKop3reao1BJkN4=;
        b=Z6fDlWE51ldGySvarHMCC6+uPer7n1UtqYxQlJE+C95Hqhex43fAaqwYPVmICPiknJ
         /m4bRedvXo5nbVi1vwk0xbn/HicGFNDSfEww3WBvScxgQrJ2l5v5e+OuV+tgIL7zoAJm
         74JLsoQbtpIJg9wYGLO3Adi8dGFZKNDKu3Y88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=HJ8+zYD3bs4pqtCvGKcax5bNzzsJHKop3reao1BJkN4=;
        b=RqqdiCrnOVpBht19XS7Yjco+/HtzGaTqnGLByPA62Ka1/U//VXgWDm4iCC1tw4Uhzy
         u3lZF6yjvflxko5N54lIHbP+/84+I8TbB3fH1WL5KlfEkg/jpUMC+uWqDqDP+5TebDxD
         Hmxsnkt3Z4KZQWB/gxSSxfL96AcfQueBxki3HZqfKOp7tDLUe2xQGl35GX+0ILVGPB/9
         bvLAWvPsjZk7Su5F/NyNbWYjOKs0YTyL8j+zUXOBVH+S5W7WVgVHPzzW1/6NI8/15jk+
         whaHXO++IqZnd/pNmHi6EkpHeMeBYMEyx3Sh/MuIMIjrBO4rxC61xRSr5I3JlpAq4wm4
         cItg==
X-Gm-Message-State: AOAM533TAaxLNwo62IIhJEfRjMTfqSdu8R/b5Q5yZ6XiAfLEa3ngZWXf
        RWoroFr1h/rmTNC7GZ4oUs0A7Q==
X-Google-Smtp-Source: ABdhPJzbWvg2bw0pnhEF8NeG+bvvG7WogBjX2YSk6HCKFVj7J3VWmPfFIEhMQzpOY8z12QQvYW94sg==
X-Received: by 2002:a2e:8191:: with SMTP id e17mr13445217ljg.339.1596013041555;
        Wed, 29 Jul 2020 01:57:21 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j1sm269388ljb.35.2020.07.29.01.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 01:57:20 -0700 (PDT)
References: <20200717103536.397595-1-jakub@cloudflare.com> <20200717103536.397595-16-jakub@cloudflare.com> <CAEf4BzZHf7838t88Ed3Gzp32UFMq2o2zryL3=hjAL4mELzUC+w@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v5 15/15] selftests/bpf: Tests for BPF_SK_LOOKUP attach point
In-reply-to: <CAEf4BzZHf7838t88Ed3Gzp32UFMq2o2zryL3=hjAL4mELzUC+w@mail.gmail.com>
Date:   Wed, 29 Jul 2020 10:57:19 +0200
Message-ID: <87lfj2wvf4.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,

On Tue, Jul 28, 2020 at 10:13 PM CEST, Andrii Nakryiko wrote:

[...]

> We are getting this failure in Travis CI when syncing libbpf [0]:
>
> ```
> ip: either "local" is duplicate, or "nodad" is garbage
>
> switch_netns:PASS:unshare 0 nsec
>
> switch_netns:FAIL:system failed
>
> (/home/travis/build/libbpf/libbpf/travis-ci/vmtest/bpf-next/tools/testing/selftests/bpf/prog_tests/sk_lookup.c:1310:
> errno: No such file or directory) system(ip -6 addr add dev lo
> fd00::1/128 nodad)
>
> #73 sk_lookup:FAIL
> ```
>
>
> Can you please help fix it so that it works in a Travis CI environment
> as well? For now I disabled sk_lookup selftests altogether. You can
> try to repro it locally by forking https://github.com/libbpf/libbpf
> and enabling Travis CI for your account. See [1] for the PR that
> disabled sk_lookup.
>
>
>   [0] https://travis-ci.com/github/libbpf/libbpf/jobs/365878309#L5408
>   [1] https://github.com/libbpf/libbpf/pull/182/commits/78368c2eaed8b0681381fc34d6016c9b5a443be8
>
>
> Thanks for your help!

"nodad is garbage" message smells like old iproute2. I will take a look.

Thanks for letting me know.
