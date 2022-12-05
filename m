Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA0B643303
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 20:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiLETdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 14:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbiLETdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 14:33:17 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFCB27FFC
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:28:16 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id h7-20020a170902f54700b00189deebdb91so2245513plf.9
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 11:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t2eV37n1EV50KN4L5BF+kL5AM4qRwzFeAkejJliXYvE=;
        b=OXixcqr3xZZ9Hudft/Jy24A4UlcW/Yb6EPf+E30B+Y3SrNhoNoQK+pCDrL/PMBDL82
         IKcAOaMUGYH18Gh0odJqUTEELnNAropoi9gMTbXzIRbC6SljHGZd+rT95xqsGFvPic/v
         sTqJEV88g2wzK30Nz1wYLyY6DgGQm7B8iNTPT1bVcf6ZiPyuFIGsvVEKRmmfY1gdc5xm
         9MA2j56JA5130vszUlvLjOLBg1AOC0touX+NmNhzcvJ20NgsWpDoctpN+DZtaHkTWw+x
         l6O4Rzr7mT+phIJg/gOMUY7jYqiscVkkTUPHYdYGsO2cFfNeKeOJ/nb0kIBvUXlCC+kj
         Uwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t2eV37n1EV50KN4L5BF+kL5AM4qRwzFeAkejJliXYvE=;
        b=5Vk+vihHbNDTirJtimQK17qjXJHcFFMm668DuBUbgmhQezcmljJZC6vbNRaDKaLbdC
         8QkjqmdCHmOLRfkwQMue7nHv/mlcyWzrakAbo/XjwmYFCSweQqSi2tVG5bifHAoP0l6/
         FYJysEm0uOjkqq4/6HZKcMxCRrwTh9f+doInEnnFs8fEKwGLAmAy5F9shnBPeqIfhbVQ
         cYfPxEKmGc87mOaC/79pfzZcNec7P29n1OCG/gbmkXeQvNWsPbzideNlBmvD/1/8MG9I
         +ufFuaxhNRYk44GUVWr6my+i15I+FWVpvAXLL93bkrf6EG0Gtxm1LAPQRlzx6xXl1JkT
         O1SQ==
X-Gm-Message-State: ANoB5pmod+MnvyZH3LhUvoktSsqgJSnrZlKua2dBEdZFq0bfD0ZMOSpF
        J7VJTnXRub8iRLftHNUdZpODZEb3WyXHXA==
X-Google-Smtp-Source: AA0mqf5iSLEojI6ymm5KY4Cvy/sEXpzhv0X25vL6jTq1Tlafmy0Z146Re+y1UCBZXZ4Atx9lOXv0PbiZWzYBTQ==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a17:90a:c006:b0:219:158d:b19a with SMTP
 id p6-20020a17090ac00600b00219158db19amr51964448pjt.152.1670268496206; Mon,
 05 Dec 2022 11:28:16 -0800 (PST)
Date:   Mon, 5 Dec 2022 19:28:14 +0000
In-Reply-To: <Y4T43Tc54vlKjTN0@cmpxchg.org>
Mime-Version: 1.0
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org> <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com> <Y4T43Tc54vlKjTN0@cmpxchg.org>
Message-ID: <20221205192814.diiwtktsrgxzccw2@google.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
From:   Shakeel Butt <shakeelb@google.com>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Ivan Babrou <ivan@cloudflare.com>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 01:07:25PM -0500, Johannes Weiner wrote:
> 
[...]
> > With the patch applied I'm capped at ~120MB/s, which is a symptom of a
> > clamped window.
> > 
> > I can't find any sockets with memcg->socket_pressure = 1, but at the
> > same time I only see the following rcv_ssthresh assigned to sockets:
> 
> Hm, I don't see how socket accounting would alter the network behavior
> other than through socket_pressure=1.
> 

I think what is happening is that the tcp stack is calling
tcp_under_memory_pressure() and making decisions without going through
the memcg charge codepath which set or reset memcg->socket_pressure.
Most probably the socket is clamped due to memcg->socket_pressure and
then the kernel never tried to grow its buffers because
memcg->socket_pressure is still set and thus never tried the memcg
charge codepath which would have reset memcg->socket_pressure. (Maybe)
That is my guess but network experts CCed can correct me.

Anyways, I don't think the pressure mechanism which relies on successful
charging will work. I am brainstorming towards memory.high based network
throttling. Basically use penalty_jiffies (or something similar) to set
memcg->socket_pressure. However I want this to be opt-in as we do have
applications which prefer to be killed than be throttled. So, still
working on the fine details how this can be done without introducing a
rigid API.

