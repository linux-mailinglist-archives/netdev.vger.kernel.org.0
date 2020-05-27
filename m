Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268B41E4C28
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388523AbgE0Rkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387564AbgE0Rkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:40:39 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E02C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:40:39 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id x6so7495361qts.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hcV5y/448NucPuCFDD5s80WvaLV/+L6Y6aWTXNhPJ6M=;
        b=b/bZTy4vE6/uduslr+Kb3ocuKQlHq2Is7+CEKiiImtdISm09h2fkkq3jav+Epoghrh
         CyJhRCA46mxHpds7YnkQN1lDiSMhiLqgtP3Emm9kOmNy7/+mFmc9NqgRgKQytUf7cnhZ
         UlrHefwWqeVWjBylxOyItGC1PkIvI1bPCNYRq37R+AymTtgUtxwVjPGiZbNnS6dWFM+V
         Zxs2bkr/E6NvLQGVKwukbRAETdxS0Sb5xLd5+buVJ4S9JEL44/2ZkIEn3JmNYlAbqJhk
         Wbyr9g0z5kFhtxLAin1PFmuFN11TZx19x9PsvS5VlJjZf1WZFcT05y5Vs/VzeB00lSty
         t1Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hcV5y/448NucPuCFDD5s80WvaLV/+L6Y6aWTXNhPJ6M=;
        b=q+2YviuozqKil4fZJ57vayWjVOWeRH0VFK/8X+FPxxFcKQIppM+H0YReiWvSIeYlxr
         v69CEIEFMiZXiNPVjzh1maf8iCyaIfbTIYKV8nKYb57apEz5Om8uRrjxSJ0EukIBCJMY
         jmjgObu1QtcCf99GQ1viFUzBfCFk6Uz9O+a02ba6Pt6CrVmrvuLIQ6Ua3Vy42oGnmDm6
         gYQ2TdOPRldSTl9IGtbwpTNAkh8SIIYBY66CoQvGlhzRbajbc9MQjSwntkBwoYKcM/dH
         LEMuljdIw/IJcoRLr6PRuMeAdiioKOoYenZ3YQaELFGgcPKnoWS83KhpqfVURafaPlE1
         g+fg==
X-Gm-Message-State: AOAM532m1cEqRC/Nw8OiwRvmFuPUXj1s321qOR+Q2CBPzJVi7BEJSSYv
        0KON4J3QbpaU7/qr1s9pksNsZ6Q=
X-Google-Smtp-Source: ABdhPJwBJ98QhfL2t1UhVy+T83POjlR8Ywppmx99tCxRxf3pJkEqt367bijcpIXOQwtoKw/hHQzoBOA=
X-Received: by 2002:a0c:f445:: with SMTP id h5mr24198190qvm.151.1590601238703;
 Wed, 27 May 2020 10:40:38 -0700 (PDT)
Date:   Wed, 27 May 2020 10:40:36 -0700
In-Reply-To: <20200527170840.1768178-4-jakub@cloudflare.com>
Message-Id: <20200527174036.GF49942@google.com>
Mime-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-4-jakub@cloudflare.com>
Subject: Re: [PATCH bpf-next 3/8] net: Introduce netns_bpf for BPF programs
 attached to netns
From:   sdf@google.com
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/27, Jakub Sitnicki wrote:
> In order to:

>   (1) attach more than one BPF program type to netns, or
>   (2) support attaching BPF programs to netns with bpf_link, or
>   (3) support multi-prog attach points for netns

> we will need to keep more state per netns than a single pointer like we
> have now for BPF flow dissector program.

> Prepare for the above by extracting netns_bpf that is part of struct net,
> for storing all state related to BPF programs attached to netns.

> Turn flow dissector callbacks for querying/attaching/detaching a program
> into generic ones that operate on netns_bpf. Next patch will move the
> generic callbacks into their own module.

> This is similar to how it is organized for cgroup with cgroup_bpf.

> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>   include/linux/bpf-netns.h   | 56 ++++++++++++++++++++++
>   include/linux/skbuff.h      | 26 ----------
>   include/net/net_namespace.h |  4 +-
>   include/net/netns/bpf.h     | 17 +++++++
>   kernel/bpf/syscall.c        |  7 +--
>   net/core/flow_dissector.c   | 96 ++++++++++++++++++++++++-------------
>   6 files changed, 143 insertions(+), 63 deletions(-)
>   create mode 100644 include/linux/bpf-netns.h
>   create mode 100644 include/net/netns/bpf.h

> diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
> new file mode 100644
> index 000000000000..f3aec3d79824
> --- /dev/null
> +++ b/include/linux/bpf-netns.h
> @@ -0,0 +1,56 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _BPF_NETNS_H
> +#define _BPF_NETNS_H
> +
> +#include <linux/mutex.h>
> +#include <uapi/linux/bpf.h>
> +
> +enum netns_bpf_attach_type {
> +	NETNS_BPF_INVALID = -1,
> +	NETNS_BPF_FLOW_DISSECTOR = 0,
> +	MAX_NETNS_BPF_ATTACH_TYPE
> +};
> +
> +static inline enum netns_bpf_attach_type
> +to_netns_bpf_attach_type(enum bpf_attach_type attach_type)
> +{
> +	switch (attach_type) {
> +	case BPF_FLOW_DISSECTOR:
> +		return NETNS_BPF_FLOW_DISSECTOR;
> +	default:
> +		return NETNS_BPF_INVALID;
> +	}
> +}
> +
> +/* Protects updates to netns_bpf */
> +extern struct mutex netns_bpf_mutex;
I wonder whether it's a good time to make this mutex per-netns, WDYT?

The only problem I see is that it might complicate the global
mode of flow dissector where we go over every ns to make sure no
progs are attached. That will be racy with per-ns mutex unless
we do something about it...
