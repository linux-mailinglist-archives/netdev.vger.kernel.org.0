Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027BA33CC91
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 05:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbhCPEaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 00:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhCPE3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 00:29:50 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D78C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 21:29:50 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id z8so18875790ljm.12
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 21:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zzhDPqLig+/Zw9qmQx4u8x639EaQw4NkATkHqrVPa8=;
        b=bqOgR2ygnLQuRVD06CKj/ojYEyQPqN2mj140AA8RMfI0Vgdf5feZXBlzco50UxnYGj
         oz1mRBKDJh6BIn7QDi3dOeOGXKxhOUjLq4SKwMp9V0URMK1qEOYem4FIqLZdCEMg1SDk
         PQgWTWfQV4jzFgG4cMKL7ZEZG+oAhhVNTQa0WavQ4F3TrE+0RyHHBT5muwCHpm48nrmA
         f6ICyig6uJWhZxGmiWjgvlu47UYKGrmaEhKj6U0po4wNfyw7HsjU41NBTO6pQarA//vj
         XHn4IU3dw2YBXpy8bBwpqbOWtB44DLNCQxpdSOtfW99iMMdFEAJUvYtZO75DwB9RwiTd
         8t8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zzhDPqLig+/Zw9qmQx4u8x639EaQw4NkATkHqrVPa8=;
        b=d9vnMeoR2XAH/ipe83/eAGplXIIYkR3P8F7BhLPEDLynd9eMxZjvWoVLC4lkjxMi8B
         ay/B0C3vA2JLg0MAwGPo3u1jp22OSZC0tsUmzOyuuVLulCBcHzuRbN5GANWZfdHNYIQS
         5oFTzMIV30Rfu/UKeInFn2NYuyNrDmlhE7aYB3L5Lf/MsEf6ofU/gCv8CsZWHxNrD8hb
         gekee2ghbYLeZgzQsAvKg0QdPXI9Hr93tvL0ybgLIiv0sbZzFIuu77gDjuAZxu5hZVVa
         AmbcYIWZj24Fjf0jOHrdeXmJ+mUz0inCiS4vXEHVOBfM/7vv6/GUyiSOSaNL9F0lQDtU
         UKog==
X-Gm-Message-State: AOAM531eBXQ5LJ/xFLznB4yY3v8SQGhCgjJmQ1ijJ2NOIY1bS1RxfbGt
        0DAWaugwGZMqTFFCVe7JW97TEuRwXQ4pvWLsG7pOgwOqR2uQkw==
X-Google-Smtp-Source: ABdhPJxE/9OXY+BATVh6jHpB/W+8fFtp8mihEtkF4sbk+eO5Tos1LV39X6fVYgzO+Dr290vJgbfvvukclx2H/wCEOBQ=
X-Received: by 2002:a2e:9195:: with SMTP id f21mr1358078ljg.160.1615868988607;
 Mon, 15 Mar 2021 21:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com> <CAOFY-A1L8c626HZYSWm6ZKFO9mqBdBszv6obX4-1_LmDBQ6Z4A@mail.gmail.com>
In-Reply-To: <CAOFY-A1L8c626HZYSWm6ZKFO9mqBdBszv6obX4-1_LmDBQ6Z4A@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 15 Mar 2021 21:29:37 -0700
Message-ID: <CALvZod7hgtdrN_KXD_5JdB2vzJzTc8tVz_5YFN53-xZjpHLLRw@mail.gmail.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
To:     Arjun Roy <arjunroy@google.com>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 9:20 PM Arjun Roy <arjunroy@google.com> wrote:
>
[...]
> >
>
> Apologies for the spam - looks like I forgot to rebase the first time
> I sent this out.
>
> Actually, on a related note, it's not 100% clear to me whether this
> patch (which in its current form, applies to net-next) should instead
> be based on the mm branch - but the most recent (clean) checkout of mm
> fails to build for me so net-next for now.
>

It is due to "mm: page-writeback: simplify memcg handling in
test_clear_page_writeback()" patch in the mm tree. You would need to
reintroduce the lock_page_memcg() which returns the memcg and make
__unlock_page_memcg() non-static.
