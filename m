Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE53439EA14
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 01:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhFGXZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFGXZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 19:25:50 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D39C061574;
        Mon,  7 Jun 2021 16:23:49 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id s107so27459510ybi.3;
        Mon, 07 Jun 2021 16:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jxr0vjKn7qfPZb3yaeP6MX3qvKr/mzAbi08IaFkQSyw=;
        b=My7PwKaTCZI3MfWNLMJN3k5lB8IRQO/jtEbX1Lxw+mDC0C03o209wD27VgUnjUC0T0
         BjDT/OLZVaRUCVAbaxrnEilEy3cagvYSEkMaGQ96WJT3wGE/LQyJK77iWYr+jyfigJgs
         w9KVvjBRlSdNdDLiMjHN/jJ+icodvA7P+i/vAfigH0Hncka09H8H4Mm08ncH1YzjVpG2
         6ICyT9dyGI2aVcjJhTtHUyvPgeAWahHQ2INhsabQ8CrXS4kZ3/PLAfVUUsktnTnjrJ4d
         hmuqIwZLR/wNLzsK92PKVS5FmJZHkJMfelIRLMkSAfKFQ6cOMawjxcl2+BRK0GVusoCB
         o2Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jxr0vjKn7qfPZb3yaeP6MX3qvKr/mzAbi08IaFkQSyw=;
        b=eDHm0WLCVXBbkur+840vGVujG3W+9JN+y2ND23/82ZF0Bh8VifDoOLbUA1/z3vcpDv
         djUneVmJCfT+jcshvv6fj2IhMUHtEHuL9dO65kTrJAsCllZkiAMU5sEse8ghTMdyPoRp
         x2j0QBlCD6I2KyVigNTSh8/7jkQgh3BhwXnC4gns/wmkiLTwlb6VgKYZBwOt6dAMZZc/
         IXgcng1UK+iZrYSPTKcyn69BBjQBl37kRyLOaur006BuZDNpogI3J0HANXdpoQNIwz51
         u6iaSJQtR5tqAtDIc2Zva5iGFPfp3bsPdf65w4CagQQtKEtwlpEi7OaWKuaA75fO9TBm
         ZZ+w==
X-Gm-Message-State: AOAM53302W/FnQxLDY6iKSD8M4QBwzukma65x7XGRSUJOpzz4/VcOlzu
        cKvFrDWzuQEuUREoaQMXyb7p7TWx9elfRRguoNE=
X-Google-Smtp-Source: ABdhPJysDNkozHrwDFHCQqH/vwUAhNnBcizmvUj0yeehOV0GSz41nP9yJtegEDjr17CXcKvqSzSTDrbRiSiC32S42jU=
X-Received: by 2002:a25:1455:: with SMTP id 82mr27308496ybu.403.1623108228782;
 Mon, 07 Jun 2021 16:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com> <20210604063116.234316-4-memxor@gmail.com>
In-Reply-To: <20210604063116.234316-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Jun 2021 16:23:37 -0700
Message-ID: <CAEf4Bza2X7+begzQVkKoURSx7v+RHTxrAFaoNUSRc-Kyr5DWfQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/7] net: sched: add bpf_link API for bpf classifier
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 11:32 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This commit introduces a bpf_link based kernel API for creating tc
> filters and using the cls_bpf classifier. Only a subset of what netlink
> API offers is supported, things like TCA_BPF_POLICE, TCA_RATE and
> embedded actions are unsupported.
>
> The kernel API and the libbpf wrapper added in a subsequent patch are
> more opinionated and mirror the semantics of low level netlink based
> TC-BPF API, i.e. always setting direct action mode, always setting
> protocol to ETH_P_ALL, and only exposing handle and priority as the
> variables the user can control. We add an additional gen_flags parameter
> though to allow for offloading use cases. It would be trivial to extend
> the current API to support specifying other attributes in the future,
> but for now I'm sticking how we want to push usage.
>
> The semantics around bpf_link support are as follows:
>
> A user can create a classifier attached to a filter using the bpf_link
> API, after which changing it and deleting it only happens through the
> bpf_link API. It is not possible to bind the bpf_link to existing
> filter, and any such attempt will fail with EEXIST. Hence EEXIST can be
> returned in two cases, when existing bpf_link owned filter exists, or
> existing netlink owned filter exists.
>
> Removing bpf_link owned filter from netlink returns EPERM, denoting that
> netlink is locked out from filter manipulation when bpf_link is
> involved.
>
> Whenever a filter is detached due to chain removal, or qdisc tear down,
> or net_device shutdown, the bpf_link becomes automatically detached.
>
> In this way, the netlink API and bpf_link creation path are exclusive
> and don't stomp over one another. Filters created using bpf_link API
> cannot be replaced by netlink API, and filters created by netlink API are
> never replaced by bpf_link. Netfilter also cannot detach bpf_link filters=
.
>
> We serialize all changes dover rtnl_lock as cls_bpf API doesn't support t=
he
> unlocked classifier API.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>.
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpf_types.h |   3 +
>  include/net/pkt_cls.h     |  13 ++
>  include/net/sch_generic.h |   6 +-
>  include/uapi/linux/bpf.h  |  15 +++
>  kernel/bpf/syscall.c      |  10 +-
>  net/sched/cls_api.c       | 139 ++++++++++++++++++++-
>  net/sched/cls_bpf.c       | 250 +++++++++++++++++++++++++++++++++++++-
>  7 files changed, 430 insertions(+), 6 deletions(-)
>

[...]

> @@ -1447,6 +1449,12 @@ union bpf_attr {
>                                 __aligned_u64   iter_info;      /* extra =
bpf_iter_link_info */
>                                 __u32           iter_info_len;  /* iter_i=
nfo length */
>                         };
> +                       struct { /* used by BPF_TC */
> +                               __u32 parent;
> +                               __u32 handle;
> +                               __u32 gen_flags;

There is already link_create.flags that's totally up to a specific
type of bpf_link. E.g., cgroup bpf_link doesn't accept any flags,
while xdp bpf_link uses it for passing XDP-specific flags. Is there a
need to have both gen_flags and flags for TC link?

> +                               __u16 priority;

No strong preference, but we typically try to not have unnecessary
padding in UAPI bpf_attr, so I wonder if using __u32 for this would
make sense?

> +                       } tc;
>                 };
>         } link_create;
>
> @@ -5519,6 +5527,13 @@ struct bpf_link_info {
>                 struct {
>                         __u32 ifindex;
>                 } xdp;
> +               struct {
> +                       __u32 ifindex;
> +                       __u32 parent;
> +                       __u32 handle;
> +                       __u32 gen_flags;
> +                       __u16 priority;
> +               } tc;
>         };
>  } __attribute__((aligned(8)));
>

[...]
