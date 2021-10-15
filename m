Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE55342F503
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 16:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhJOOTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 10:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbhJOOTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 10:19:35 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEADC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 07:17:28 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id y26so42526863lfa.11
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 07:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NNBNetlXiKA/5wOmeUNGAiY3ozuqgab3m7QPlttlB08=;
        b=CkPGlgl27sU2jSGBCoEIwfYUgGG9z5FzoqDhlFLSg61p58QeVXqcCoiZJf5G4SpakK
         VYuZz7j8aL5DftQ1TUAa4QaMcjxBD25M7+7dFFZCvvYwgqW7fJDMd1iw83z6xXqLlfi4
         DkpPZfPzLe1KM9+pNjKBOILQN8UQA/WIq4wL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NNBNetlXiKA/5wOmeUNGAiY3ozuqgab3m7QPlttlB08=;
        b=ae02F06p0f+4U/Lf7/CMElJaq6oQ26CbuuJd4kZjB+WUCcBuYFwYvmyyhmPBKZK+am
         fd2LlZ4q51n3SpedzOKDHnl60EpfS2vHwu5m94oQqX0qFl0AOKLAuueGEPvhb7FD/21t
         OfeLOQ+tEL+dpkxdpzELjek2KuzCDx3YyewRZE7zShy4dbm0yLW/jQFCdgg+ULkqJE9j
         NGQgeeMX0+oRkB7qAIQCAaXkXGJvSnSbu3/cqTUhzx4S9vBdcoPNwWkaGzI0qIJ3Npii
         sKe/nl6YDwfZD72bsBVLwLBSnStZtJSCApBvJ2gLPl3dOQoMjwTNJXYSkW4wSo2kRdlp
         CgXQ==
X-Gm-Message-State: AOAM533tfpW0iOaumLn+vyLgJ9/Ooc+PfA16xaS9cseELcmW/MxBtNho
        su1LK4ZQ8oClySA7IRcJ5n8jd09KDwTgsBvgxO6Lcw==
X-Google-Smtp-Source: ABdhPJxC2+JyudW+dRKjr4gncthcJMBkAZznViO+/7S3dZxYXWMvX/Wnq0PXw79vvK7l5bPCnyJAPWJjRdC//U6T9ko=
X-Received: by 2002:a05:6512:38a8:: with SMTP id o8mr11424441lft.102.1634307447034;
 Fri, 15 Oct 2021 07:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211015112336.1973229-1-markpash@cloudflare.com>
In-Reply-To: <20211015112336.1973229-1-markpash@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 15 Oct 2021 15:17:16 +0100
Message-ID: <CACAyw99T4bUoXp7kAftuOMBW4YVLfAosJvVSKwpoBXVgH4sAVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Get ifindex in BPF_SK_LOOKUP prog type
To:     Mark Pashmfouroush <markpash@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Oct 2021 at 12:24, Mark Pashmfouroush
<markpash@cloudflare.com> wrote:
>
> BPF_SK_LOOKUP users may want to have access to the ifindex of the skb
> which triggered the socket lookup. This may be useful for selectively
> applying programmable socket lookup logic to packets that arrive on a
> specific interface, or excluding packets from an interface.

For the series:

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
