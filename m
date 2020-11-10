Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2202AE285
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbgKJWHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731759AbgKJWG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:06:57 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A002C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:06:57 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id z3so111803pfb.10
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qPQ341XlioetJkwvUmegnpo5yieLqIlhYMF1JNCPQv8=;
        b=v+5eq4VYAXz/UfcP/wGSntYsg1su3KfQmSwgHMV9Q0fCSbYVVLnOFQhD/nLYWBBZWj
         VMStzDGMizpFtL1V9NSxj3ObtqvQsSH4aOtVKT1ZbgbrHIlQyV1D6dhVO7CwXiUUypSi
         mOXCxsmyn6s3zKnFtO72FSp8s1DDlDu+mTMdahSatCAwi32RA0o7/pYKGrIBBSwJeiYM
         ltqz7cA3Azqt2C8Lzfd82JgQ5BAUtonbiD8ElnNQxQdJt/zhPUFHNRS98keIXLA5ZEdl
         6sCAQ9+9gZArl37nnSPGbCLclc6YpHtCyA6nXsBLOg+DQEoSSw+kQIqdt2alYJ25E1ku
         A1Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qPQ341XlioetJkwvUmegnpo5yieLqIlhYMF1JNCPQv8=;
        b=VxURb7e0UZoZ871TGNrhnBjQ9Yu7K8s7Pz96G+rppdEkvlSPG7PaVLOX0v+6ZBl7dX
         zMCJW7YzUZLXOvBwKGZLqxOzjrr9Q6ceOnMYLsmwo5MToFv+efVUjU6ALs7Mz/1hPPNm
         ukuYIZcg6hdjvRxYWt6yNBr/a6ir4bOOb7uWXutA1Y6G1tG1gq/d7xqzLiIGUatvnxcV
         chG4B8HkIYxfVdQYpbf+WZYFBrESIj7dGbOwsmO6/MZsStmIbP8C2+WZE4EPCuYyL2/n
         z/n35echuRxrXGibCJrOBjgmyFQw+znJMESNvNfJFlsYvJQ2rvi3E2u3NnTnt1KHf43q
         CkoQ==
X-Gm-Message-State: AOAM530yq/jlNdyayFpJ116KE7o1kc2KOWXei77wF+ME//1Vgp1DcSLh
        C+IOJODsq1SguxPrCtqgVMZAvzHFPm5+h3Gbqp0eKQ==
X-Google-Smtp-Source: ABdhPJxp+2Xlwg1fWGZr/1Vant6rBWaWS0JhbrDM+RUjGv2zuz2AR8kD5o4UH+G5f3lDUNAwWer/gu6XsYJX4r8uyRw=
X-Received: by 2002:a62:870c:0:b029:18b:d345:70f3 with SMTP id
 i12-20020a62870c0000b029018bd34570f3mr16322041pfe.30.1605046016802; Tue, 10
 Nov 2020 14:06:56 -0800 (PST)
MIME-Version: 1.0
References: <20201107075550.2244055-1-ndesaulniers@google.com>
 <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
 <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com> <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
In-Reply-To: <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 10 Nov 2020 14:06:45 -0800
Message-ID: <CAKwvOdku3o0nHhPppPOJzFXa3j1j_4r5ix3kbkduxY3YSpj9wg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
To:     Joe Perches <joe@perches.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
>
> > Yeah, we could go through and remove %h and %hh to solve this, too, right?
>
> Yup.
>
> I think one of the checkpatch improvement mentees is adding
> some suggestion and I hope an automated fix mechanism for that.
>
> https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/

SGTM, please try to remember to CC me (or CBL) if you do any such
treewide change so that I can remove -Wno-format from
scripts/Makefile.extrawarn for Clang afterwards, and maybe help review
it, too.
-- 
Thanks,
~Nick Desaulniers
