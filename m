Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F73135D228
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbhDLUlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbhDLUlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 16:41:25 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4D9C061574;
        Mon, 12 Apr 2021 13:41:05 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d124so9929604pfa.13;
        Mon, 12 Apr 2021 13:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/V4IhN2Q/V5U4Tpj75AkP6BGAKxhjp8mRuYxyjG6j4=;
        b=dyhlIeYRHxVIOPSAOFAjDs8PxmPHHMjH7jfPK1ntxxCY4H50yQ8vIjKMtCKah/qYdH
         V5KhxBAeDrgXDMfcL51T7GJXIklGu6fnwAPgZfCNAIOLMX/6cyNP9spAKH35vU+rYXcB
         zwgDrl4YlKXPrO1ah3VSgcvvnDS06AKGXSoi80Plt5Uuq06ADSpMaHDfRVfU1Kq1rdk/
         53Qomj7MX5XpCc9AlasKZWW/HKs261+GF07M2nJL1ODcQAKN1GM/IgFTnRD8rd7noUyT
         7oOVg9orzYhSiWVUGF0mZRnV26RVKg35wXon2Q3CdYlH7UBQZwuuE0KgUsXGNxdWW5J4
         zhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/V4IhN2Q/V5U4Tpj75AkP6BGAKxhjp8mRuYxyjG6j4=;
        b=SykSbkPcbnhP0zoRYH9SmXvVnhFG6POal98yAiZipoFmtXem1ZE0mNjk8xg0yhEYFX
         AkYV5g562qXE+cZJzaieyg8kw7x/uxBfFq3/S1BhwFmG2V+MC6X4V/DSSi0DOgOXmSaS
         eea9kaXH48KlLjUDHctwjHvRJNFf6o9Aoi6aal/kqIwGxs511njCLyADHHL5w7342wro
         IhkzmhUeLMoD2zoW2W8NrTWiSTDgUI1w4bqCCtToZ7waEDDg+FhhBfrYaSqDXjqGZ6QK
         P9YltOtQKPX4BHKJ86jNhFKRvidjB/77zdgr6U4Da49UM27hiKzj9ANnMqzA7xHzlJIv
         ewmA==
X-Gm-Message-State: AOAM533eHXko6aZCl9VU3/+43j93tFuVoTgb1RCs3Vrp5CSXTn8sVFQm
        Ag/QMLPG+jTrngf/set2ZpXfLU6qes5xOAJay3M=
X-Google-Smtp-Source: ABdhPJzCgLMu4jfig2Fg9SKfOkgu/O84G2SO2bhJThWLan0BJBNcNUVRYuntE/0ULyYHnxmT5o7PuJDUB09tJiAyY+Y=
X-Received: by 2002:a62:5ac4:0:b029:22e:e8de:eaba with SMTP id
 o187-20020a625ac40000b029022ee8deeabamr26458316pfb.4.1618260065161; Mon, 12
 Apr 2021 13:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
 <20210409073046.GI3697@techsingularity.net> <CAJht_EPXS3wVoNyaD6edqLPKvDTG2vg4qxiGuWBgWpFsNhB-4g@mail.gmail.com>
 <20210409084436.GK3697@techsingularity.net> <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
 <87ab3d13-f95d-07c5-fc6a-fb33e32685e5@gmail.com> <CAJht_EOmcOdKGKnoUQDJD-=mnHOK0MKiV0+4Epty5H5DMED-qw@mail.gmail.com>
 <3c79924f-3603-b259-935a-2e913dc3afcd@gmail.com> <CAJht_EN_N=H8xwVkTT7WiwmdRTeD-L+tM3Z6hu86ebbT_JpBDw@mail.gmail.com>
In-Reply-To: <CAJht_EN_N=H8xwVkTT7WiwmdRTeD-L+tM3Z6hu86ebbT_JpBDw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 12 Apr 2021 13:40:54 -0700
Message-ID: <CAJht_EMd19EyOHjBEcsWdNBBx+2Mqknq7KavxW8vn=d+06oUQg@mail.gmail.com>
Subject: Re: Problem in pfmemalloc skb handling in net/core/dev.c
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Mel Gorman <mgorman@suse.de>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 12:12 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> This is exactly what I'm talking about. "skb_pfmemalloc_protocol"
> cannot guarantee pfmemalloc skbs are not delivered to unrelated
> protocols, because "__netif_receive_skb" will sometimes treat
> pfmemalloc skbs as normal skbs.

> I'm not sure if you understand what I'm saying. Please look at the
> code of "__netif_receive_skb" and see what will happen when
> "sk_memalloc_socks()" is false and "skb_pfmemalloc(skb)" is true.

Do you see the problem now? Just think what happens when
"skb_pfmemalloc(skb)" is true and "sk_memalloc_socks()" has just
changed to "false", and whether in this case "skb_pfmemalloc_protocol"
still takes any effect.
