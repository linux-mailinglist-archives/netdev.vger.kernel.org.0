Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF54481F62
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241770AbhL3TI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbhL3TI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 14:08:26 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E895C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 11:08:25 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id x4so24487406ljc.6
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 11:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kgyj97ctTErwJCIhgzUX8EMyaDF/bLUdCmbEuAYlHjw=;
        b=YOZVOBHDDpfH3Ql5u1ocW3n2/vJn9YZp1eV0ovKa0V9oHZEI4tHDNs5y3oqOeRyYLB
         uhnnc1xa7T/vkBCfrT26Kw5tter/RZgpklftKQ2G/60d+OvlMPJnDW9APlJzmOKHwKU1
         /yamItDqCuyQ0HpIcSy2xYO8EVL9rVcrw1yOWj8N8IffziJ8mVAdX/e8AKwBGLunsly4
         YFpEdTZEZIcfafjeNPCPssBDelxxIrw4qI0pc6PtHVJdUTqfKBsJLPlUnC8ko5hhqeMB
         vJB8dEryxS3tfVB+qYDZX8erLuN9Vaebet1OIINCgn7RSLNWAmkZzMWzStggjp3N0KFg
         6WkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kgyj97ctTErwJCIhgzUX8EMyaDF/bLUdCmbEuAYlHjw=;
        b=Cx216/S5ZIOo2iTBdqU4b6K76WDcz28l0BNvbPHrqO+cd1qvZEhNu/EBXtceIgrcnP
         8S8A56RhfwjSKTuLL5WcLrIArQkqWdhCWfbhgg9y9gINyhuxiOY6c0sC6UhhElfBiq0t
         t6QXbyzE1uRar9IrgnwRhlYPQKaKRFyTtM6tq6utOuZscpyTanblVMnSdEYmoob0zDRx
         0F6meIBrvbFzOsj4vjyF42cqwmqDa7JsVJQ9sPljuELcUelgcnyGR8dl29Cwsg9KF4n8
         aCIhK/xNsf/BjOGJTwuJUhMrRG6PjavL+D4UTsVaC1gjR14QkxdgTY7EJQ11bbGEXvAz
         7i0A==
X-Gm-Message-State: AOAM5311EFHKcBAfE1A1o9wwIcmAwAsS/i6plHpzngZk5ks+lVas0TT8
        Wf+rn4+3AahSbasSJWsk6QAEnYO52hACSabmOdV5jA==
X-Google-Smtp-Source: ABdhPJwRuz90LSenncg3Ir0RuESemN0QoyVzJiasaGluR94kNn7uQB+PloeHXS2750u1IXJBq7bTmvMkM0LB6KJDmp8=
X-Received: by 2002:a2e:8854:: with SMTP id z20mr20464394ljj.202.1640891303360;
 Thu, 30 Dec 2021 11:08:23 -0800 (PST)
MIME-Version: 1.0
References: <00000000000049f33f05d4535526@google.com> <Yc1zbYqVO/6b6Uhf@dhcp22.suse.cz>
In-Reply-To: <Yc1zbYqVO/6b6Uhf@dhcp22.suse.cz>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 30 Dec 2021 11:08:12 -0800
Message-ID: <CALvZod6S+zLw=mRw6F7g4+WSnCVaj+jHs7rjAoyDfFK92wq9jw@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in mod_memcg_page_state
To:     Michal Hocko <mhocko@suse.com>
Cc:     syzbot <syzbot+864849a13d44b22de04d@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        changbin.du@intel.com, Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        hkallweit1@gmail.com, John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        yajun.deng@linux.dev, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 12:53 AM Michal Hocko <mhocko@suse.com> wrote:
[...]
>
> This might have something to do with http://lkml.kernel.org/r/20211222052457.1960701-1-shakeelb@google.com
> which has added the accounting which is blowing up. The problem happens
> when a memcg is retrieved from the allocated page. This should be NULL
> as the reported commit doesn't really add any __GFP_ACCOUNT user AFAICS.
> Anyway vm_area_alloc_pages can fail the allocation if the current
> context has fatal signals pending. array->pages array is allocated with
> __GFP_ZERO so the failed allocation should have kept the pages[0] NULL.
> I haven't followed the page->memcg path to double check whether that
> could lead to 0xdffffc0000000001 in the end.
>
> I believe we need something like
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 9bf838817a47..d2e392cac909 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2627,7 +2627,8 @@ static void __vunmap(const void *addr, int deallocate_pages)
>                 unsigned int page_order = vm_area_page_order(area);
>                 int i;
>
> -               mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
> +               if (area->pages[0])
> +                       mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
>                                      -area->nr_pages);
>
>                 for (i = 0; i < area->nr_pages; i += 1U << page_order) {
> @@ -2968,7 +2969,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>                 page_order, nr_small_pages, area->pages);
>
>         atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
> -       mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC, area->nr_pages);
> +       if (area->pages[0])
> +               mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC, area->nr_pages);
>
>         /*
>          * If not enough pages were obtained to accomplish an
>
> Or to account each page separately so that we do not have to rely on
> pages[0].
>

Thanks Michal for the CC. I will add these checks in the next version
(or convert to account each page separately based on discussion on the
other thread).

Shakeel
