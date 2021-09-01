Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D906C3FDF4A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 18:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243053AbhIAQD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 12:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhIAQDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 12:03:25 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00687C061760
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 09:02:28 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id f4so6094509ybr.5
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 09:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0K3Oyq5eTmkdoN2xYNtCvvot7voY0qHtA/Ba90V0kts=;
        b=HjiiGKx103VY/SJhoVDzvuGUO+raoSLhUeJaASZftY6NXzdlXoRkXi3MImBbpnVgML
         JxiKhvCKwVniNSh+THyacwEE3b23wLiKY7bE9HNCnOS0XooBAEjrhyJw8nYIANVDvUR3
         OKP3uMPr/kVONQixycUYirMvycX2cOg8lgDh3r4p/R/7tIm2rxyZdiRTqOyg/ArnR2PA
         gFtvIk8teUELlNqja7STeXCBhsisCYVcH1qXEDek18GtIt187x8Lnpojlr6jiwq5/RJ2
         us3dQ+L3AkhpM8wjgDxqz9e+5g4PS0OR2LwfFXM1ZJBzkPvQ0rHYIn9Xy2+Jn6Mu6ijq
         l2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0K3Oyq5eTmkdoN2xYNtCvvot7voY0qHtA/Ba90V0kts=;
        b=f8g0bpNJ1r5+dFYJGrE9Tgg/KHGIOYxCEPPG5CqwyAj5jA8IkPDdFoH12xKhpKY5iH
         kXqZhIgGBKlG7Fz9IxVGeuFCTRMLA87qVxUqKs9nPX4VboUSnksbU9bg+NHKJs4k5gUw
         MpdF7kmrNiare6x/dquWGBGsn4aBrTG6EpDtG0JDeCKGQQFA7LQTP9/QFdl6XEb74xwG
         WG4dtllkZwU3P4rcQE2JemiaVIkiYpyd1vsIkiq09KbqDJ3kiMCNOq2+NLYasB05MwBN
         LvBD6ZuiElEsOv+k1pqyivOf0FghBd38Z/1dm+sjNXkWK0DLwBH0M0JgJKJ5wX3qs1ti
         /uzA==
X-Gm-Message-State: AOAM532PbW9K59iABWfnkOgEafSh6it/E69MZNwZM/l03bRKpjmeevow
        X1vEp5Aujdd2AVFUeVJGsoEszxWxdNTQLeX9L29uqQ==
X-Google-Smtp-Source: ABdhPJzKeORwXLC+ic8sTU3fSxHjhp9H+f/v8Ki8LzInVyMdQYglGhw9+1JThSy0dN1uo8r8jBQoxxMwMCeIeNozQdo=
X-Received: by 2002:a25:6994:: with SMTP id e142mr277447ybc.364.1630512147758;
 Wed, 01 Sep 2021 09:02:27 -0700 (PDT)
MIME-Version: 1.0
References: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com>
 <9c9ef2228dfcb950b5c75382bd421c6169e547a0.camel@redhat.com>
 <CANn89iJFeM=DgcQpDbaE38uhxTEL6REMWPnVFt7Am7Nuf4wpMw@mail.gmail.com>
 <CANn89iKbgtb84Lb4UOxUCb_WGrfB6ZoD=bVH2O06-Mm6FBmwpg@mail.gmail.com>
 <c40a178110ee705b2be32272b9b3e512a40a4cae.camel@redhat.com> <59ad13bb312805bb1d183c5817d5f7b6fd6a90dd.camel@redhat.com>
In-Reply-To: <59ad13bb312805bb1d183c5817d5f7b6fd6a90dd.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Sep 2021 09:02:16 -0700
Message-ID: <CANn89iJ-Vx9V2_N6PRysNuK0W7TshMNo_crYtnEzrw=crF6OOg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 9:01 AM Paolo Abeni <pabeni@redhat.com> wrote:
>

>
> I think the easiest way and the one with less code duplication will
> require accessing the tcp_mark_push() and skb_entail() helpers from the
> MPTCP code, making them not static and exposing them e.g. in net/tcp.h.
> Would that be acceptable or should I look for other options?
>

I think this is fine, really.
