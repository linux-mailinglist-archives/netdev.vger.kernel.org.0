Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9682940A2FF
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 04:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbhINCCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 22:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbhINCCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 22:02:52 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB98C061760;
        Mon, 13 Sep 2021 19:01:36 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id m26so10682271pff.3;
        Mon, 13 Sep 2021 19:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CHO7jG1ANjcxZUFLXB4BV+Q4y1YvEtbhn3e34/bBo8g=;
        b=jFFyEkq4JJ4Wd7JGuLpK5/Rsda352v3C2JYiuA61k8UjsqQENVsv+MdtqU5HNr9xa/
         79Tpa2lccNGZg6AL8i69dRaYWSUzter7AE2DjZ1sEbJgh43Qwj61D1OPU5izuB2ncwkw
         ecjM91SApJ5tP03l6KjGcgFCO+iNyHcQ04oMqzosU1L1SewJlKIwJztcbx7ZYOt9gFqq
         Y7c5RO+lbKzA/1W1hm9JsOgb50TDJiJPNBeyj69jyNcpN6t1f/K0IUnD/sUvy60thwKJ
         VGfgl4rGZZJ3GVF1Sz2P8v2xobvEIt3rkxUSlz/kwrvF0FZ7NRoHHVGd+PRIIncs0Vvu
         2tFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CHO7jG1ANjcxZUFLXB4BV+Q4y1YvEtbhn3e34/bBo8g=;
        b=zkanoO4zhsQftgPR2nip73Fi8gNCCABZQ7ZSlGEtdd0evzuPdEOgNsjJNNFuahvNhY
         6iBYJlcYSa/haOXHumxryKmZ9df5FQL1nF4DkW33722C+Drddj52Y2yMBNtd6OA/JAIC
         64vXIiFo/uI9zLA3v6SSFMZuZDGXMhxb/FOxDBj0OW1Yx8SSE/4VUOZBKO34kMXA3VYQ
         Un9kUTFyXPXGzMq4FWLzhx0X+9bmeOQkt0YKlcfDltjlICBq62GgBREezmY9QnmHXlt6
         ebVnqQ1cgUGSso/UszUC5DL9l2aFahnvfY4wf0vasrM9dylvMJ+1UN9+tbpzhxHZJpCx
         GJmQ==
X-Gm-Message-State: AOAM532adJTs0jFPeGpDy6AfTWdJeod0O9krGmN2gRl9Jgk5FEwJ8mE3
        LnamOfYk+kWwBJNK37pFmM755vYbL+ek7/RxWzc=
X-Google-Smtp-Source: ABdhPJyoJXNiUhznwiW34Xf5jyEKtYHuO+0B0RIkyCnoFM5U0HU6oSPV/LhpKFHHsEUg4NM69JfaXbxfVtZXLRulVc4=
X-Received: by 2002:a62:b515:0:b0:438:42ab:2742 with SMTP id
 y21-20020a62b515000000b0043842ab2742mr2284175pfe.77.1631584895596; Mon, 13
 Sep 2021 19:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210913230759.2313-1-daniel@iogearbox.net>
In-Reply-To: <20210913230759.2313-1-daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Sep 2021 19:01:24 -0700
Message-ID: <CAADnVQKHcpmUp8eDzmJ2ktdtYg8ChnqK44W0_MrAQ95Y9VXVqQ@mail.gmail.com>
Subject: Re: [PATCH bpf v4 1/3] bpf, cgroups: Fix cgroup v2 fallback on v1/v2
 mixed mode
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Martynas Pumputis <m@lambda.lt>,
        Andrii Nakryiko <andrii@kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 4:08 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Fix cgroup v1 interference when non-root cgroup v2 BPF programs are used.
> Back in the days, commit bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
> embedded per-socket cgroup information into sock->sk_cgrp_data and in order
> to save 8 bytes in struct sock made both mutually exclusive, that is, when
> cgroup v1 socket tagging (e.g. net_cls/net_prio) is used, then cgroup v2
> falls back to the root cgroup in sock_cgroup_ptr() (&cgrp_dfl_root.cgrp).
>
> The assumption made was "there is no reason to mix the two and this is in line
> with how legacy and v2 compatibility is handled" as stated in bd1060a1d671.
> However, with Kubernetes more widely supporting cgroups v2 as well nowadays,
> this assumption no longer holds, and the possibility of the v1/v2 mixed mode
> with the v2 root fallback being hit becomes a real security issue.
>
> Many of the cgroup v2 BPF programs are also used for policy enforcement, just
> to pick _one_ example, that is, to programmatically deny socket related system
> calls like connect(2) or bind(2). A v2 root fallback would implicitly cause
> a policy bypass for the affected Pods.
>
> In production environments, we have recently seen this case due to various
> circumstances: i) a different 3rd party agent and/or ii) a container runtime
> such as [0] in the user's environment configuring legacy cgroup v1 net_cls
> tags, which triggered implicitly mentioned root fallback. Another case is
> Kubernetes projects like kind [1] which create Kubernetes nodes in a container
> and also add cgroup namespaces to the mix, meaning programs which are attached
> to the cgroup v2 root of the cgroup namespace get attached to a non-root
> cgroup v2 path from init namespace point of view. And the latter's root is
> out of reach for agents on a kind Kubernetes node to configure. Meaning, any
> entity on the node setting cgroup v1 net_cls tag will trigger the bypass
> despite cgroup v2 BPF programs attached to the namespace root.
>
> Generally, this mutual exclusiveness does not hold anymore in today's user
> environments and makes cgroup v2 usage from BPF side fragile and unreliable.
> This fix adds proper struct cgroup pointer for the cgroup v2 case to struct
> sock_cgroup_data in order to address these issues; this implicitly also fixes
> the tradeoffs being made back then with regards to races and refcount leaks
> as stated in bd1060a1d671, and removes the fallback, so that cgroup v2 BPF
> programs always operate as expected.
>
>   [0] https://github.com/nestybox/sysbox/
>   [1] https://kind.sigs.k8s.io/
>
> Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Stanislav Fomichev <sdf@google.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Martynas Pumputis <m@lambda.lt>

Applied. Thanks!
