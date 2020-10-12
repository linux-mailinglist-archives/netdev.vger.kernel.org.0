Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBDE28BD33
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 18:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390344AbgJLQF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 12:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389068AbgJLQFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 12:05:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDB9C0613D1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 09:05:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so13884825pfc.7
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 09:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8I5XKTgq/Z0bLvn2YmKFNFJu3bvFZkBI41VZpa4KwVY=;
        b=ZjmvDvxLIavsomBf4sUVGuCczLwUrYqvKoVsenBx5ZDRysgwBdTa+1a1hCLp4Qv/HB
         k4Wxd5SxpANhGENEB9lk+phhkrybxUbtpj3DlcrL1Q7YuRIsYIHnjAlD+kfS0fSxfR8y
         9WfbcrXwfavgTijWwW63FTK24YGHQMz+hktTJfj+1mgQCNXDExJDfFVLF00EwSS8Frz9
         P3dg0bc4S4XIpcPWsub1WMZmrlYxkqIYdJNiHh9PUyVvS7Uuvo7U99bT7Pxc2Oq9qcDg
         7BQxc8sXd+fJ3+GfRaJ16RG40eODbhCHJET4XmpCc9mchniOFbFOF9DU45Mv5RnpltPa
         ZS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8I5XKTgq/Z0bLvn2YmKFNFJu3bvFZkBI41VZpa4KwVY=;
        b=qy/XqbcAuvuwPOd1p396ar6+8kmfxeNPCm1TcHg5Tz2N4MyFglrwZO0mO6TTA6d1w2
         tT64VsrwJvWbxRu+j7i2Jk7Y0r0343zBVmkMGW4jQTK90Xld3CiXCNs9r3l6m5mSSJcl
         WuFCNAo4mo7zrAv/XA1cnzPfqU4BOJ268oiOFSdAJh+lHGjJ3DlpXt4Pno4u6hxQlXfs
         t+xfZvBS5ht+ae3g1nj87MGWukRnkAi+QJhuPWJaqY2G9z+vdBfge0bNMeGvD4rcWDSF
         IzLO5YtsNCM3wP4PzWzUcpD+5ZDcC7AW/aNLKgeCB862fLACUo4+YZXr2VgVc3uQmicz
         HdNA==
X-Gm-Message-State: AOAM5332c9nMXiSGQ+JFwhwBRNsXTIm7hqVUpN2RHEHZzF8afVOpZf2h
        n7yKAlfpQ/lNKgoVCV6hMf52ZChsMcPI2PZrPyT1xg==
X-Google-Smtp-Source: ABdhPJzYe2rIzqJSmeOTfqVuMkQYjy2B4w6VyJ48z1edXwESV0BcGlpJn5MlnRrH/2xTVtTap322A3yoOEsV6GS4dck=
X-Received: by 2002:a17:90a:890f:: with SMTP id u15mr20954335pjn.147.1602518720947;
 Mon, 12 Oct 2020 09:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201010104521.67262-1-songmuchun@bytedance.com> <20201012135823.GA188876@cmpxchg.org>
In-Reply-To: <20201012135823.GA188876@cmpxchg.org>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 13 Oct 2020 00:04:44 +0800
Message-ID: <CAMZfGtXE1DaDXSOWObaJDTxUH2zB2hjfKoX38Y2oKgNaDkyoCA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: localize
 mem_cgroup_sockets_enabled() check
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, laoar.shao@gmail.com,
        Chris Down <chris@chrisdown.name>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, jakub@cloudflare.com,
        linmiaohe@huawei.com, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 9:59 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Sat, Oct 10, 2020 at 06:45:21PM +0800, Muchun Song wrote:
> > Move the mem_cgroup_sockets_enabled() checks into memcg socket charge
> > or uncharge functions, so the users don't have to explicitly check that
> > condition.
> >
> > This is purely code cleanup patch without any functional change. But
> > move the sk_memcg member of the sock structure to the CONFIG_MEMCG
> > scope.
> >
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  include/linux/memcontrol.h      | 78 ++++++++++++++++++++++++++-------
> >  include/net/sock.h              |  5 ++-
> >  include/net/tcp.h               |  3 +-
> >  mm/memcontrol.c                 | 43 +++++++++++++-----
> >  net/core/sock.c                 | 15 +++----
> >  net/ipv4/inet_connection_sock.c |  6 +--
> >  net/ipv4/tcp_output.c           |  3 +-
> >  7 files changed, 111 insertions(+), 42 deletions(-)
>
> Hm, this is almost 3 times as much code.
>
> The sk_memcg saving on !CONFIG_MEMCG is somewhat nice, but it's not
> clear how many users would benefit here. And it adds ifdefs in code.

The 'ifdefs in code' means the initialization of sk_memcg in the sk_clone_lock?
If yes, we can add a new inline initialization function to avoid this.

>
> Also memcg code now has to know about struct sock.

Without this patch, the memcg code also has to know about struct sock.
You can see the code of  mem_cgroup_sk_alloc and mem_cgroup_sk_free.

Thanks.

>
> I'm not quite sure that this is an overall improvement.



-- 
Yours,
Muchun
