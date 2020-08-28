Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B4E255EF3
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 18:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgH1Qol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 12:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728203AbgH1Qoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 12:44:34 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB89C061232
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 09:44:33 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id w25so2004487ljo.12
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 09:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UzpPi8yXbLMuzZSSY1LpudtamO507TJJwiMVPeY80DE=;
        b=hHayFTVAP6eh4eo+w96Oa1ZAIXRFKK+O8XvGFl7M7dsA/Sfgl+TIdTnwip76YxquFb
         MUgTLABcXm228lJFA+6PfABognH5JhCINUZ4/AV1oFyEVllbBqx6bZUMFpPQMbMG854O
         uBbhuWVF8lM4SKRAu8D54grAOXevhjo09f77L+QDqC+9f4UGc/pT8JdJMAcS6b9Uft6i
         UBi00xHyjclUtNjsHg83xovHNctWTuceI4QpQKcnCuX0neMqc7kVyRpy99rQ1W8kw5kC
         YrpihI9fczOPvfkaWFuOpvsw1esRu4o8kmdQSn/QJo1TOO9BYzegeWQ5dDCpmFHqFrBH
         478w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UzpPi8yXbLMuzZSSY1LpudtamO507TJJwiMVPeY80DE=;
        b=K9wVMnxKEvvpGgQ51+7/6ZMkTGV39XCkJ+T4DWAOZVGEK89QRqFuZabB9uB7/PQGnC
         IlBKrQOzGWkHu2263eyQTmoTrpn3iCCBdis1z9P7dbDB0w2f5MeIWVEqoRQrmjIURhnG
         0NWSfoeTmUsymvy1bBvfHzGDVwHgTOTTdPu3Eo02rbhhncujvWrkl2LDA5C4Ae7FREDU
         uV7PtwLkBWISnvgABcNqlIwarTZoKe7bedCl/Te2sf0SeEFD2dM3MKFGAF9bSMxbsr5n
         0nDbsGCTt48z0XK90EX8uxTgn5nFEUEoxAL3mHnbhrPzcExcgiZuN5o4q1/WM3Zs5i7Z
         Fw6Q==
X-Gm-Message-State: AOAM530BNj1YoU6bo7vPkVQXFfq9V1bfBWRdLFgHDShjk66SbpXnIjMC
        PdhpXVjP8gy7eBGUsdykb3SQDizLp1Lm4woflrJjQg==
X-Google-Smtp-Source: ABdhPJzWm18EUoriLV8GpLXZeBfpnJJ0335T25V0TWtCl4zXTizNjuHaws4CrJw0LNy//Kma1xGNubrLqXxkoP4jWBk=
X-Received: by 2002:a2e:9d8e:: with SMTP id c14mr1334390ljj.332.1598633070579;
 Fri, 28 Aug 2020 09:44:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200821150134.2581465-1-guro@fb.com> <20200821150134.2581465-9-guro@fb.com>
In-Reply-To: <20200821150134.2581465-9-guro@fb.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Fri, 28 Aug 2020 09:44:19 -0700
Message-ID: <CALvZod75xBLmf6FigcdNsruyWjMhZ3eaZWggWYuzS5jwFVgW6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 08/30] bpf: refine memcg-based memory
 accounting for hashtab maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 8:23 AM Roman Gushchin <guro@fb.com> wrote:
>
> Include percpu objects and the size of map metadata into the
> accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
