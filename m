Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383E72F5C4D
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbhANITL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbhANITK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 03:19:10 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40121C061575;
        Thu, 14 Jan 2021 00:18:29 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id j21so1176467oou.11;
        Thu, 14 Jan 2021 00:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=NHaQY/wmwAwLkfB4yy4sQ75SvpYFbzsgZx1Fsxl84Hg=;
        b=vdDZc77Jg+/5XvROl+Gbz7HpV2mbj/YksZN3+H1Zgx4TAvU73ypj2CadPXhsSG66+6
         W8GDAXblSSZ5KXPvY8wLQlFeUm7F1uVM/EcpPR0G/qWYsiejB1EnwbZvJCVw7ZCVo30E
         2rdoNfe54zzL2EMop2ToZ/qEAspDkgYoxWIi/e0bCZygXlEaotAwMBYZ4JPaULg92Lyo
         lL5GGN3kWF0z8ixNl+1dCInhV4CUrX5gUNO5rbCYvFHX5sgvgFgrstg8AQZqIv7IHJeA
         Mgh5fPNfsn/66Ch5YyftIdbUXmDxIVkwHzhTOXkqiSO3MC8KHKBEiPtC3S4AjUYMb58q
         qhmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=NHaQY/wmwAwLkfB4yy4sQ75SvpYFbzsgZx1Fsxl84Hg=;
        b=USCMF4wqJ47V+RGkoowbexGK/Kw48k8V0gYfuHJ+lokKr0XM+V3rn/z5swmTuYTf8O
         fJsgbGA9Z4ze8qHLXhhI3+chT5BL4l0hcz055rIlGoenL///RERmTuut2Q9HAbeSfa6d
         NrGDnrEF+4ctuaGXGxXSyIM9entrpD4xsHHo5LFau3GgSDhSqrRj4aIKWJ8O9m7/hZDL
         T0S+otU0O4L/cWPQu/2kJ0cw2rDAtFpA65+b+UYLVid7hyjR71PEMOQkBOC6hgJMkKSB
         zjPYXMVVEMx2tBcXstCRlY5AsKdUa5iBebd5f+ThIntQDoQzYBLduKrpIsCH77LtyqZc
         VqLg==
X-Gm-Message-State: AOAM5313zKmru3KagWna5aTpruDZBbF7UJqqkLlxLYlI8DLFhnyStdaW
        2ZutwF5GsEKvCy6sn1B86To=
X-Google-Smtp-Source: ABdhPJw4brqQW8VG4gVoAYKR7bDZHsYe0qHhQ/7MHUgELdYTq6umLrn0Y8MoOrP0+xQ3DXW77gt2+w==
X-Received: by 2002:a4a:9c01:: with SMTP id y1mr3966442ooj.15.1610612308700;
        Thu, 14 Jan 2021 00:18:28 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id k3sm965330oor.19.2021.01.14.00.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 00:18:28 -0800 (PST)
Date:   Thu, 14 Jan 2021 00:18:20 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Message-ID: <5ffffe4ca10bd_1eeef208f5@john-XPS-13-9370.notmuch>
In-Reply-To: <161047350559.4003084.17398867215317668954.stgit@firesoul>
References: <161047346644.4003084.2653117664787086168.stgit@firesoul>
 <161047350559.4003084.17398867215317668954.stgit@firesoul>
Subject: RE: [PATCH bpf-next V11 1/7] bpf: Remove MTU check in
 __bpf_skb_max_len
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> Multiple BPF-helpers that can manipulate/increase the size of the SKB uses
> __bpf_skb_max_len() as the max-length. This function limit size against
> the current net_device MTU (skb->dev->mtu).
> 
> When a BPF-prog grow the packet size, then it should not be limited to the
> MTU. The MTU is a transmit limitation, and software receiving this packet
> should be allowed to increase the size. Further more, current MTU check in
> __bpf_skb_max_len uses the MTU from ingress/current net_device, which in
> case of redirects uses the wrong net_device.
> 
> This patch keeps a sanity max limit of SKB_MAX_ALLOC (16KiB). The real limit
> is elsewhere in the system. Jesper's testing[1] showed it was not possible
> to exceed 8KiB when expanding the SKB size via BPF-helper. The limiting
> factor is the define KMALLOC_MAX_CACHE_SIZE which is 8192 for
> SLUB-allocator (CONFIG_SLUB) in-case PAGE_SIZE is 4096. This define is
> in-effect due to this being called from softirq context see code
> __gfp_pfmemalloc_flags() and __do_kmalloc_node(). Jakub's testing showed
> that frames above 16KiB can cause NICs to reset (but not crash). Keep this
> sanity limit at this level as memory layer can differ based on kernel
> config.
> 
> [1] https://github.com/xdp-project/bpf-examples/tree/master/MTU-tests
> 
> V3: replace __bpf_skb_max_len() with define and use IPv6 max MTU size.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
