Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D413B1C0A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 16:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhFWOKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 10:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhFWOKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 10:10:09 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E45C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 07:07:50 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id c23so5400221qkc.10
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 07:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DvEEcehVIqrpDQCs5Fwn8D1TCXy9xAshEF6XtFGFnm4=;
        b=mS762KEToHvBwcHlkC9TTwjtiUJX4w0DcsW04Ns5V7QO90iNY65FdhImDxhvDVekFT
         aFSq4b1GF8LRJdg8EPy7JnQj/cW09Isa+VWlXoYKDRBjlbUyr4/a69lTnxUSWlkowVF/
         5JjIdIpi5Riy6FPbnhkiTh/Zn7Q3C1YrplfbbOdLThaPyzsRNDRngh1Q2K/KLsMZXE/s
         ixTkc14rRf70cOHrfx7e+PxGLuuytj8wH1gBuBxsnvLq0OtgXpYPnUC4QUmZ2dom3SaA
         C+1UFVvELPVYMtZFng4UEm04KRLJsEquzIiCEYAMREE487aEyh5Uf+PfzEDG/34gr4ai
         z2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DvEEcehVIqrpDQCs5Fwn8D1TCXy9xAshEF6XtFGFnm4=;
        b=m9/XG1iUk9rlXnSalMF4jMzQ0oDOcdKw16mfEvs5/QpirTMh/AX5f87VGwkbtVcI1S
         5RcDPDrCATJOWkHP74rytSW54Flb74wexSYIHHPm1hU3f+WxcdmgItFuzKUOnvsry0U8
         lCKc4zIgd0g+F2J1nnauHEawNVpYu59N7zNvACWIn2Uff2F8rjk4t6ds0oFFLe0fU6BK
         TIcKOjcHnye+r675k/SwHXS7wk0NICjkIFZHdY20v3eaj6lTydNK+N/nj+/isloVBI7V
         r9HLTRsx4TewN5lhtrciYZCuvYIer+E15qt9wgfoVsmZszSn3W29v9w3PsUGAuRuXBmL
         lpZg==
X-Gm-Message-State: AOAM53385XHXs2u9Wj3jEy4IObX7zxCGfU5/i0VnqZyIII1OLVvRE4d0
        kAKasngG9bDYZy9s7SLknqyBuvsKD1e5f00+CiWydA==
X-Google-Smtp-Source: ABdhPJw7pGN3xweYEGxf+UJlJ6RNg2fJO0L33V1AGELMCcrMdDMQg5lc8l+dBd03nnrgzvP4jiysoLPZZhe3yglli1c=
X-Received: by 2002:a25:8081:: with SMTP id n1mr12536929ybk.253.1624457269364;
 Wed, 23 Jun 2021 07:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210623135646.1632083-1-m@lambda.lt>
In-Reply-To: <20210623135646.1632083-1-m@lambda.lt>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 23 Jun 2021 16:07:38 +0200
Message-ID: <CANn89iJK1HNBjJgtB=vORh=79z2_VEkSCK75-UxqDq2eBLdf7w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: retrieve netns cookie via getsocketopt
To:     Martynas Pumputis <m@lambda.lt>
Cc:     netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 3:55 PM Martynas Pumputis <m@lambda.lt> wrote:
>
> It's getting more common to run nested container environments for
> testing cloud software. One of such examples is Kind [1] which runs a
> Kubernetes cluster in Docker containers on a single host. Each container
> acts as a Kubernetes node, and thus can run any Pod (aka container)
> inside the former. This approach simplifies testing a lot, as it
> eliminates complicated VM setups.
>
> Unfortunately, such a setup breaks some functionality when cgroupv2 BPF
> programs are used for load-balancing. The load-balancer BPF program
> needs to detect whether a request originates from the host netns or a
> container netns in order to allow some access, e.g. to a service via a
> loopback IP address. Typically, the programs detect this by comparing
> netns cookies with the one of the init ns via a call to
> bpf_get_netns_cookie(NULL). However, in nested environments the latter
> cannot be used given the Kubernetes node's netns is outside the init ns.
> To fix this, we need to pass the Kubernetes node netns cookie to the
> program in a different way: by extending getsockopt() with a
> SO_NETNS_COOKIE option, the orchestrator which runs in the Kubernetes
> node netns can retrieve the cookie and pass it to the program instead.
>
> Thus, this is following up on Eric's commit 3d368ab87cf6 ("net:
> initialize net->net_cookie at netns setup") to allow retrieval via
> SO_NETNS_COOKIE.  This is also in line in how we retrieve socket cookie
> via SO_COOKIE.
>
>   [1] https://kind.sigs.k8s.io/
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Martynas Pumputis <m@lambda.lt>
> Cc: Eric Dumazet <edumazet@google.com>
> ---

This looks fine, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
