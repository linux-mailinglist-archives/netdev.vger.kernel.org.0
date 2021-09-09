Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88176405CDD
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 20:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbhIIS2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 14:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhIIS2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 14:28:41 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79678C061574;
        Thu,  9 Sep 2021 11:27:31 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id v10so5760398ybm.5;
        Thu, 09 Sep 2021 11:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5gwkxlK218lfeG6qVATnhYuhEfP0dKvd3mlZGqKDDVY=;
        b=LoNCBRUfiMx59gkzS9cNueEdWnhCKIzZqfiuRd4G1VyLnV3Pai6kUzD9WEsRwIpRzI
         0S5c82w6zcanlyK8nHZ6J71SUnSrGnQT42RAdXbMwYMuO7lavLm7Ev1mU+rcnuFNNLSL
         wmufgt/inW13dfZvcsjdolfM0FL6jLhKfx+m/w+NzJWsL14aQb3k8sG+7sV4dsfhN5Dq
         fZXLWuLhOTD17xljzm2U1Ei/xca7grW+PNig+8xkjdP9tpebbcQreqTny0jC/rAeqUTn
         RyUK/bDxjzjAF+G6jMFxAvww59Qz+UI5Xec03HjBL9OAV8LV9+DU/kmrVvJRJ0VmKazt
         sPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5gwkxlK218lfeG6qVATnhYuhEfP0dKvd3mlZGqKDDVY=;
        b=udc+gkVOeL1jvI4bwerY0ins4v88KZCyEl68NMn6nCyMcN2wC1oi53bGckoXURlEsF
         tqaYFRxDJdKO2jbCJ0qiChflGzEaJa0iEU22DEGmHfJsk9No2SVcmt0KWO7fjp3Z2EAe
         G865YRz4s0ztltx93/5ANk7Wdy/JMct8MZrcdugsVk8kkY5YxVBjJ0s9+e8vy/0Klxdj
         zVuvrnTDuRshtTvrB2iTvcs8+xq85CmbiLleZpPdox4xnA0kN0zG1zp4O7DzBd1Kk+6Y
         Z2Rvn5FZrUeLUM9R7LLPFSCngZXsioC7byacdmjfvKEMLpEd7bOBaZVcLi78TjWHP3wm
         425w==
X-Gm-Message-State: AOAM5300y2tS4AdYhprbOU90ejMNgGWVtZqVrbcOYAsAP7AMPaxoRC3W
        QM3kYzjp5j0IW8GXh+l1lxoJaDn7VLfoUebtQeA=
X-Google-Smtp-Source: ABdhPJwdbdh6PxPUGW2zL6LrBd/c6IBFjbviCBbCEFQeXZsGH/oyPFY1zjCXfOThc8qzFnOlU42zY89EavoZRsxzYCQ=
X-Received: by 2002:a25:8c4:: with SMTP id 187mr5633511ybi.369.1631212050257;
 Thu, 09 Sep 2021 11:27:30 -0700 (PDT)
MIME-Version: 1.0
References: <1e9ee1059ddb0ad7cd2c5f9eeaa26606f9d5fbbf.1631189197.git.daniel@iogearbox.net>
 <927d7018430735bf32eda96e66e3ad32ab7636d3.1631189197.git.daniel@iogearbox.net>
In-Reply-To: <927d7018430735bf32eda96e66e3ad32ab7636d3.1631189197.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Sep 2021 11:27:19 -0700
Message-ID: <CAEf4BzbrwNu0NJ4n7ShNyDooU=6f_zyPTc9Vf2ZyGZ5AGdVVhA@mail.gmail.com>
Subject: Re: [PATCH bpf 3/3] bpf, selftests: Add test case for mixed cgroup v1/v2
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        tj@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Martynas Pumputis <m@lambda.lt>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 5:13 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Minimal selftest which implements a small BPF policy program to the
> connect(2) hook which rejects TCP connection requests to port 60123
> with EPERM. This is being attached to a non-root cgroup v2 path. The
> test asserts that this works under cgroup v2-only and under a mixed
> cgroup v1/v2 environment where net_classid is set in the former case.
>
> Before fix:
>
>   # ./test_progs -t cgroup_v1v2
>   test_cgroup_v1v2:PASS:server_fd 0 nsec
>   test_cgroup_v1v2:PASS:client_fd 0 nsec
>   test_cgroup_v1v2:PASS:cgroup_fd 0 nsec
>   test_cgroup_v1v2:PASS:server_fd 0 nsec
>   run_test:PASS:skel_open 0 nsec
>   run_test:PASS:prog_attach 0 nsec
>   test_cgroup_v1v2:PASS:cgroup-v2-only 0 nsec
>   run_test:PASS:skel_open 0 nsec
>   run_test:PASS:prog_attach 0 nsec
>   run_test:PASS:join_classid 0 nsec
>   (network_helpers.c:219: errno: None) Unexpected success to connect to server
>   test_cgroup_v1v2:FAIL:cgroup-v1v2 unexpected error: -1 (errno 0)
>   #27 cgroup_v1v2:FAIL
>   Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>
> After fix:
>
>   # ./test_progs -t cgroup_v1v2
>   #27 cgroup_v1v2:OK
>   Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/testing/selftests/bpf/network_helpers.c | 27 +++++--
>  tools/testing/selftests/bpf/network_helpers.h |  1 +
>  .../selftests/bpf/prog_tests/cgroup_v1v2.c    | 79 +++++++++++++++++++
>  .../selftests/bpf/progs/connect4_dropper.c    | 26 ++++++
>  4 files changed, 127 insertions(+), 6 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_v1v2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/connect4_dropper.c
>

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

[...]
