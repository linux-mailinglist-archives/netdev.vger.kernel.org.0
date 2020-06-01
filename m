Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C31A1EB1AF
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgFAW0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728478AbgFAW0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:26:35 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445C0C061A0E;
        Mon,  1 Jun 2020 15:26:35 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id j12so2184835lfh.0;
        Mon, 01 Jun 2020 15:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nk/3gy4rhWFtZzEIg7CzzGWUKTHes4CV4dirJuIzOFs=;
        b=fyflDZygD8LsPhM3zh/m5Jh3IW/gjOsC+OEiqls/TRQ+N2OCJ8wTWB+/uSvEbJbgG7
         jSmieFkh3/ITbJsQ3CiqTPE08SrnO4h1rRdRniLjVm7pU0lkFx0RBsj3sl94YSnsk33I
         1j/4rdzV/4gXDlPPJLwsXZbkEIKKefLZXqcoYWZDtIfvQywBlzo2Q8WOgktfEuZQJHeu
         8ynL2l8qkQNA7NLPPJUC+hRZbEKRENL92WRYOp4oiR/VUxKtxMxjBYcSFxvD4GOHxCJ+
         E/5300IKSNvqYnRa8YcLUDRRf3l93UuL/K5HlHGi+MfR/a1pNediu9qug/jxMngq5hjN
         G+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nk/3gy4rhWFtZzEIg7CzzGWUKTHes4CV4dirJuIzOFs=;
        b=uH0OPmvMXpSptIIjpWoxi9OWYPi2A23FOBsLNyBidbS4+bt+cb8xUU8j/Y1Md3zlbS
         xJoxVVmveIN9APCldDgpB76mZbNizzTa4BUmJdHGBTfGYNJaV58MTGQR1ait9GZPSSIH
         dCviNb6233Gasqi2KOzsiqzXV2YVpxxwoEDBzK5+RwbueXG4MNWk35UHRhsLeSi6wV1R
         7JWi6ZCSC3XtBBqcPeiZ/HCG+s+mRuaDb3uJq2F962hydjtXguBMRaK/lVxT5Nk3C3K9
         H1UskzBQfc9+lg7MS5WItOFHuUk320L75ZDivlLSSrxJpgFLrV9Uei1iN21FIwFD1tbK
         YeOA==
X-Gm-Message-State: AOAM530IrZwahpLqE+z5W8MC5nzWY8m3m6fKaja/lf4b+qdfEKcXLTJt
        Q9un1IKI9tU0HfD17F9lH3vvMoK36tEGJG8gqemZwA==
X-Google-Smtp-Source: ABdhPJzW3iYTzGHJDV2pULPYHk3q1ZfeFzqWsr7cDruoEAtCV7G8lHF+8gCifK/n/n0jK9CTXa9WeXvXSe2beW6FsdU=
X-Received: by 2002:a19:48e:: with SMTP id 136mr12374796lfe.134.1591050393731;
 Mon, 01 Jun 2020 15:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200531082846.2117903-1-jakub@cloudflare.com>
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 15:26:22 -0700
Message-ID: <CAADnVQJhs4FMnHfSAgAAujAE70n98BA7YNvdd2eO4__FVe7CcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 00/12] Link-based program attachment to
 network namespaces
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 1:28 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> One of the pieces of feedback from recent review of BPF hooks for socket
> lookup [0] was that new program types should use bpf_link-based
> attachment.
>
> This series introduces new bpf_link type for attaching to network
> namespace. All link operations are supported. Errors returned from ops
> follow cgroup example. Patch 4 description goes into error semantics.
>
> The major change in v2 is a switch away from RCU to mutex-only
> synchronization. Andrii pointed out that it is not needed, and it makes
> sense to keep locking straightforward.
>
> Also, there were a couple of bugs in update_prog and fill_info initial
> implementation, one picked up by kbuild. Those are now fixed. Tests have
> been extended to cover them. Full changelog below.
>
> Series is organized as so:
>
> Patches 1-3 prepare a space in struct net to keep state for attached BPF
> programs, and massage the code in flow_dissector to make it attach type
> agnostic, to finally move it under kernel/bpf/.
>
> Patch 4, the most important one, introduces new bpf_link link type for
> attaching to network namespace.
>
> Patch 5 unifies the update error (ENOLINK) between BPF cgroup and netns.
>
> Patches 6-8 make libbpf and bpftool aware of the new link type.
>
> Patches 9-12 Add and extend tests to check that link low- and high-level
> API for operating on links to netns works as intended.
>
> Thanks to Alexei, Andrii, Lorenz, Marek, and Stanislav for feedback.
>
> -jkbs
>
> [0] https://lore.kernel.org/bpf/20200511185218.1422406-1-jakub@cloudflare.com/
>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Marek Majkowski <marek@cloudflare.com>
> Cc: Stanislav Fomichev <sdf@google.com>
>
> v1 -> v2:
>
> - Switch to mutex-only synchronization. Don't rely on RCU grace period
>   guarantee when accessing struct net from link release / update /
>   fill_info, and when accessing bpf_link from pernet pre_exit
>   callback. (Andrii)
> - Drop patch 1, no longer needed with mutex-only synchronization.
> - Don't leak uninitialized variable contents from fill_info callback
>   when link is in defunct state. (kbuild)
> - Make fill_info treat the link as defunct (i.e. no attached netns) when
>   struct net refcount is 0, but link has not been yet auto-detached.
> - Add missing BPF_LINK_TYPE define in bpf_types.h for new link type.
> - Fix link update_prog callback to update the prog that will run, and
>   not just the link itself.
> - Return EEXIST on prog attach when link already exists, and on link
>   create when prog is already attached directly. (Andrii)
> - Return EINVAL on prog detach when link is attached. (Andrii)
> - Fold __netns_bpf_link_attach into its only caller. (Stanislav)
> - Get rid of a wrapper around container_of() (Andrii)
> - Use rcu_dereference_protected instead of rcu_access_pointer on
>   update-side. (Stanislav)
> - Make return-on-success from netns_bpf_link_create less
>   confusing. (Andrii)
> - Adapt bpf_link for cgroup to return ENOLINK when updating a defunct
>   link. (Andrii, Alexei)
> - Order new exported symbols in libbpf.map alphabetically (Andrii)
> - Keep libbpf's "failed to attach link" warning message clear as to what
>   we failed to attach to (cgroup vs netns). (Andrii)
> - Extract helpers for printing link attach type. (bpftool, Andrii)
> - Switch flow_dissector tests to BPF skeleton and extend them to
>   exercise link-based flow dissector attachment. (Andrii)
> - Harden flow dissector attachment tests with prog query checks after
>   prog attach/detach, or link create/update/close.
> - Extend flow dissector tests to cover fill_info for defunct links.
> - Rebase onto recent bpf-next

I really like the set. Applied. Thanks!
