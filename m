Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5630D59F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhBCIxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbhBCIxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:53:30 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69469C0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 00:52:50 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id d3so6202057lfg.10
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Mcu6MHvf1hlPzj5u7R0Y68W+pP6MSLeAHc6zmrK1lE=;
        b=H0RELsY2Canz+0X9tK1JNgoNqCZQlLNaNkITuqaXIlCznsGvP1fVuqTdgPJqimvPXi
         3cJkx85/p5tGWgdXAyOJkmBtqgUYwQBubCkSFwCg1nKcOZpOsx9aNbR8J3/aebbAfcqe
         2VIFhZdChheZ3qQbItb+9R2qhBffrOUo1U4cYtKIJgwTzLAlumJ5CHEaALJXZlTP5nXX
         R8YW1RcFI98M3dG2a31TDxWYJ+GWd0/McZaWg6VJ81EfdodkGDKPKJrJmbVe7gDAc3o0
         +4TR/7L59jcnajJrCOiT+bX/xzXPnKmct4yWLpHqlA8h1XzgZ45zN3XGu0DGyj/9FeVt
         1LOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Mcu6MHvf1hlPzj5u7R0Y68W+pP6MSLeAHc6zmrK1lE=;
        b=snkL6d7JzfEevBHdDkxwwJoj00qMPTL5o4rKVs4mmC9jg2nJ0lHuWdjFR9f5u6ju0A
         NbW4JMKO/hwd8QpZuneDORW1KwR3RVNOc+lWZn9k7Hv6Yv7n9oaHLs2x/SE6+fmjUSFA
         7rYOAcqb1mxSHh0JzvfpG6SESjpsXkGOIrw6RYxGyDUePMJ8/URU2ytCxkI3M1+tI4zT
         1BNv/HkJljzHo12T31MzpW8V5e4clk4cfb4yDiPfhbOQGSA5vh8QLx5TDpvg/XCsXCq0
         aV2wXeE7cr4sA5sqI2x6yP8FBv1/O0F41ZKMnveCtgE+wIle22a9k0kRgFHImnAzoxi9
         ZgFw==
X-Gm-Message-State: AOAM530nTNyqGSJO/aPvEXJFuXfB+15GKnrS5Yq9xpx395sSwaY5fDsw
        3GPD7f6zIeF03oJtYDXClW/FZ9CRUih+DEfCij0=
X-Google-Smtp-Source: ABdhPJy34df5+QXDMiTRSPzx5BO8EpljdLpN5W8+Hsl2TFa6UJejgn3UTS0YR843OA/Z8otD0BLgOQBqovWqAs8BsdE=
X-Received: by 2002:a19:224d:: with SMTP id i74mr1158258lfi.597.1612342369000;
 Wed, 03 Feb 2021 00:52:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611637639.git.lucien.xin@gmail.com> <CADvbK_e-+tDucpUnRWQhQqpXSDTd_kbS_hLMkHwVNjWY5bnhuw@mail.gmail.com>
 <645990.1612339208@warthog.procyon.org.uk>
In-Reply-To: <645990.1612339208@warthog.procyon.org.uk>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 3 Feb 2021 16:52:37 +0800
Message-ID: <CADvbK_dJJjiQK+N0U04eWCU50DRbFLNqHSi7Apj==d3ygzkz6g@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 0/2] net: enable udp v6 sockets receiving v4
 packets with UDP GRO
To:     David Howells <dhowells@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 4:00 PM David Howells <dhowells@redhat.com> wrote:
>
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > I saw the state of this patchset is still new, should I repost it?
>
> It needs a fix in patch 2 (see my response to that patch).
>
Sorry, my mistake, I forgot to enable rxrpc when building kernel.
Will repost, Thank you.

BTW, I'm also thinking to use udp_sock_create(), the only problem I can
see is it may not do bind() in rxrpc_open_socket(), is that true? or we
can actually bind to some address when a local address is not supplied?
