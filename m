Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F072CCCE6
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgLCCzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgLCCzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 21:55:39 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A24C061A4D;
        Wed,  2 Dec 2020 18:54:59 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id u19so550686lfr.7;
        Wed, 02 Dec 2020 18:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dd5jcZ3oN6nUA0AzCxuEUhXY3oArZGfneGe61iHNKCk=;
        b=p0NbHKpET7bJ46d00bRrLX6JtATMfRM1z1ULVYd3qkkrWfAl6OccKIVcFlJn8H5AT4
         bYqCEpavljJCulBxGyeHWRjNFWynmskZBB/bYLr0Vk9Hd/Om3VvygIPIUxrK79emwGJQ
         URuFawvDubEOnY6fBuTnQaBPtvgo6ssQSSYEKs2DzEDHeaPiEUKXaCEUMbSI/4qQ/xLb
         SSM3zjuWYYmcTlE0Jgw37PpidobZSwS2cG8lZxkrnMAEhYimkfQRAQ9jDnO3m08PHyzm
         EkwIypk9vs11fq3KSqCpp+CL3MlF9Lnd7ycoSVKnjjaK/e/q0Nc4HsrgG141EqUYACfW
         k3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dd5jcZ3oN6nUA0AzCxuEUhXY3oArZGfneGe61iHNKCk=;
        b=OZJY8cDO0YYhDyqpUQDsm7Kzd0YEF5E0JS/nXpWszuIJGidnK/yFcmV3kImIZa3o19
         VyC1Urk1Wq0PFLOfgBNQPyB75a+BKH8ufaYdHJsKcY9+RazO1P8F1UKc0SZaQn6UKic4
         93GlrOZa61QQNntNO/26yj14P6FA2Rj8IjtAEYyjQYc3v9uBV8pUadUnIXNbR7kZjrXG
         tUn321JVXvif1zcOWAkTv7GbS63bo1vaMNYntINDzRQbfl/iT38ONn07izik2H6hvOxV
         YtZveDBYvRpvpnJ4nF7Ytk8r2j9NjMkgrh64QRi27Gac/FNcSXgDR+JBmJtYZoAwTMK4
         0asQ==
X-Gm-Message-State: AOAM532P3j+zXX/dysOyyEUc13/FbaCwamZlpdYXuUtBIhQAi/qWAiHj
        HwXss4+IAsQKmbugDxKEsHuyl/5FVUZC/OctXfg=
X-Google-Smtp-Source: ABdhPJztbEPrSr+1MMuVD1akFGR77xCipHpKdbOhyw4y3xpE+e4w1OglzAIV4fKukIOdnPyRVJ44BXXdPr5hXfuxDic=
X-Received: by 2002:ac2:431a:: with SMTP id l26mr469141lfh.196.1606964097754;
 Wed, 02 Dec 2020 18:54:57 -0800 (PST)
MIME-Version: 1.0
References: <20201201215900.3569844-1-guro@fb.com>
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 2 Dec 2020 18:54:46 -0800
Message-ID: <CAADnVQJThW0_5jJ=0ejjc3jh+w9_qzctqfZ-GvJrNQcKiaGYEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 00/34] bpf: switch to memcg-based memory accounting
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 1:59 PM Roman Gushchin <guro@fb.com> wrote:
>
> 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
>    a function to "explain" this case for users.
...
> v9:
>   - always charge the saved memory cgroup, by Daniel, Toke and Alexei
>   - added bpf_map_kzalloc()
>   - rebase and minor fixes

This looks great. Applied.
Please follow up with a change to libbpf's pr_perm_msg().
That helpful warning should stay for old kernels, but it would be
misleading for new kernels.
libbpf probably needs a feature check to make this warning conditional.

Thanks!
