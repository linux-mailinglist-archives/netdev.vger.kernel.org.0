Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D91F28B968
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390741AbgJLOAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390071AbgJLN76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:59:58 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1184EC0613D1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:59:58 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id a9so13600677qto.11
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LiRTK1pn0r+YX72HhN94UTqVGuwvK727gErKq+9p5co=;
        b=kdD+EQ/dal5vV717URB/8INdiZStUkziLF+UP1/oTSbkc1xgOTizbXO5c7UxoZEPEW
         ciXRZScy5HT82Nv+OD2jUtLvQ9ZQUcBf5lQFSVG840aSBl/RscDr0IFlx4mq7nv7MQ35
         qKKeS7bNKo7We6dmI+xlw49U9Yldi1thKV+okEC746kq4DMa7X461pF8ef+CffG9QZHZ
         P4KVdg4bG0zObRLP2mgNLOg61igdJOJIBA0f9nLPUnjww4ZBDnQ2ZQq2sYhk6myWpyxs
         kMjev9XtTo/GbPHtFljwhoUpLw1Rj5mPbkW6NIMYdXRlfoGwcEQJYFL0k3Ft/+QUy2a5
         zMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LiRTK1pn0r+YX72HhN94UTqVGuwvK727gErKq+9p5co=;
        b=a5QaN8jFCXcNe/86DvyJgGvrEAkIODEbmltQHyoCy16gmMfX9ayOJl2ubFZvW7mdfW
         AMGv/FWe3ONHDsHBU/710VhFK23psh2LLbS0uXloCHSdisBigV3KhUIXxe2AUOovuBh6
         S2ep4LaiPbGRa5ziNUAUbh1qtcFvATzVcCj3AudkOphhsOxI4NRu1c1Mdz4sMulCG//s
         Y0QGTwYXdgPyIJXMmJMaX6oqypkHgBzfjGbRei5nAUk/a/FUqpmzLSX4SStE7ObVIYep
         VuyJvIqOfXyxKQLArELDlPwiOG2ObT9dsNksHbFjV11o8t1IYbV1ije/hr7HU+oUVB7Y
         gZ1w==
X-Gm-Message-State: AOAM5336yDP96j/uEJOw56Vt9N/3gV2w+H4R0guioK1csrI/mBAdPCUz
        RVo9KbQXLE72KIMxvEr0fH4FAA==
X-Google-Smtp-Source: ABdhPJxAX5eynIShuux1RfN6TNFMLHG9rFliYB7ohOz/eT70FOqxANA48CGA9a+dB8RWZqnIBpu8UQ==
X-Received: by 2002:ac8:5b8d:: with SMTP id a13mr9846698qta.209.1602511197075;
        Mon, 12 Oct 2020 06:59:57 -0700 (PDT)
Received: from localhost (pool-96-232-200-60.nycmny.fios.verizon.net. [96.232.200.60])
        by smtp.gmail.com with ESMTPSA id r16sm6844790qkm.1.2020.10.12.06.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:59:56 -0700 (PDT)
Date:   Mon, 12 Oct 2020 09:58:23 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shakeelb@google.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name,
        daniel@iogearbox.net, kafai@fb.com, ast@kernel.org,
        jakub@cloudflare.com, linmiaohe@huawei.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: memcontrol: localize mem_cgroup_sockets_enabled()
 check
Message-ID: <20201012135823.GA188876@cmpxchg.org>
References: <20201010104521.67262-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010104521.67262-1-songmuchun@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 06:45:21PM +0800, Muchun Song wrote:
> Move the mem_cgroup_sockets_enabled() checks into memcg socket charge
> or uncharge functions, so the users don't have to explicitly check that
> condition.
> 
> This is purely code cleanup patch without any functional change. But
> move the sk_memcg member of the sock structure to the CONFIG_MEMCG
> scope.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  include/linux/memcontrol.h      | 78 ++++++++++++++++++++++++++-------
>  include/net/sock.h              |  5 ++-
>  include/net/tcp.h               |  3 +-
>  mm/memcontrol.c                 | 43 +++++++++++++-----
>  net/core/sock.c                 | 15 +++----
>  net/ipv4/inet_connection_sock.c |  6 +--
>  net/ipv4/tcp_output.c           |  3 +-
>  7 files changed, 111 insertions(+), 42 deletions(-)

Hm, this is almost 3 times as much code.

The sk_memcg saving on !CONFIG_MEMCG is somewhat nice, but it's not
clear how many users would benefit here. And it adds ifdefs in code.

Also memcg code now has to know about struct sock.

I'm not quite sure that this is an overall improvement.
