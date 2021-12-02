Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B819465B09
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 01:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354638AbhLBAkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 19:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbhLBAkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 19:40:23 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C382DC061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 16:37:01 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id p37so52671204uae.8
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 16:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o514D1uhYEuhVflwqtCZuE/ZpMReL0NhA7xwmfYSlag=;
        b=g+P9kPgV2HDyvGog5C8JdvOkx1/LJz+d7iJwKg7PWMfXLR9Z7bHpmRzY7OJMrXBenc
         Vr2F24EkEgLGkEVm7aRxKWrJ8rPL1rIs/kFYEY5hYFJtUSMfVxXiqCUny+1WWQZI6ibt
         +WgPNeEmWWelHagVXeI9196nciM57pA38C96o/6nWdzLrSFN2YmROMtzlYexPtto9wb9
         1Ru9opswNpzj1Kxpl5/+qAew5CBARJzqdZpYVXuImRXTSa4Ds7gKUK7vBjS+K0z4L7H9
         6QDCOKruK47OiMPvpyJ+HW/tLvPVRv5RNLFpOf/gXkSGIC+izuC69LKv2bkmaUG/AqIo
         OgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o514D1uhYEuhVflwqtCZuE/ZpMReL0NhA7xwmfYSlag=;
        b=xzkFAFFM6af1kOBrvjSsDCxFH39kpfZbEsQUX7dA1vX9ZThmiMZ07aAlS2DTmEaq3u
         nwQsjSTa3HnPViWFg8ElXlieNPMr7tbTWxohdRJfFVGJSnnHxYUiyux6KlYW/H1Sc4Ts
         d9ab78ORdsfCYf/dm/c3JOA7kl9HFDnFdqQzQan22Db1QLWDGqINhoMIbdKMK69lbrEq
         x5957dUpB7ymhlPG4qmMyYcf9tJ0PvMc4QXSxEuPp87M1VRQTh6VdowopesTyDcRAtIX
         kDhlmNdewlQ84QdOrycgnlgiUnTMF1gr2ce8nQWBkj9akiso2YMPWyZfOvdqgzW20BvR
         jHsg==
X-Gm-Message-State: AOAM530ZiLqgg6YiRs86GjU62JFGhmfSg4sarf1blGT0I6uzVFemu3CU
        qnipGcZLoimfvbzCJc6WCx9g4mjpCdekHg==
X-Google-Smtp-Source: ABdhPJzGJ7Fa1zq0FGlODv1C9KDcFqafSvoWb3SMz6ChcrJxsCz02r3BM6HqdTHAd+H69KORhPwTfQ==
X-Received: by 2002:a05:6102:3a0c:: with SMTP id b12mr11548330vsu.48.1638405420980;
        Wed, 01 Dec 2021 16:37:00 -0800 (PST)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id c24sm445504vkn.30.2021.12.01.16.37.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 16:37:00 -0800 (PST)
Received: by mail-ua1-f48.google.com with SMTP id t13so52714910uad.9
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 16:37:00 -0800 (PST)
X-Received: by 2002:ab0:15a1:: with SMTP id i30mr12304408uae.122.1638405419938;
 Wed, 01 Dec 2021 16:36:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638282789.git.asml.silence@gmail.com> <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
 <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com> <d5a07e01-7fc3-2f73-a406-21246a252876@gmail.com>
In-Reply-To: <d5a07e01-7fc3-2f73-a406-21246a252876@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Dec 2021 19:36:22 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeP-W-ePV1EkWMmD4Ycsfq9viYdtyfDbUW3LXTc2q+BHQ@mail.gmail.com>
Message-ID: <CA+FuTSeP-W-ePV1EkWMmD4Ycsfq9viYdtyfDbUW3LXTc2q+BHQ@mail.gmail.com>
Subject: Re: [RFC 00/12] io_uring zerocopy send
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>> 1) we pass a bvec, so no page table walks.
> >>> 2) zerocopy_sg_from_iter() is just slow, adding a bvec optimised version
> >>>     still doing page get/put (see 4/12) slashed 4-5%.
> >>> 3) avoiding get_page/put_page in 5/12
> >>> 4) completion events are posted into io_uring's CQ, so no
> >>>     extra recvmsg for getting events
> >>> 5) no poll(2) in the code because of io_uring
> >>> 6) lot of time is spent in sock_omalloc()/free allocating ubuf_info.
> >>>     io_uring caches the structures reducing it to nearly zero-overhead.
> >>
> >> Nice set of complementary optimizations.
> >>
> >> We have looked at adding some of those as independent additions to
> >> msg_zerocopy before, such as long-term pinned regions. One issue with
> >> that is that the pages must remain until the request completes,
> >> regardless of whether the calling process is alive. So it cannot rely
> >> on a pinned range held by a process only.
> >>
> >> If feasible, it would be preferable if the optimizations can be added
> >> to msg_zerocopy directly, rather than adding a dependency on io_uring
> >> to make use of them. But not sure how feasible that is. For some, like
> >> 4 and 5, the answer is clearly it isn't.  6, it probably is?
>
> Forgot about 6), io_uring uses the fact that submissions are
> done under an per ring mutex, and completions are under a per
> ring spinlock, so there are two lists for them and no extra
> locking. Lists are spliced in a batched manner, so it's
> 1 spinlock per N (e.g. 32) cached ubuf_info's allocations.
>
> Any similar guarantees for sockets?

For datagrams it might matter, not sure if it would show up in a
profile. The current notification mechanism is quite a bit more
heavyweight than any form of fixed ubuf pool.

For TCP this matters less, as multiple sends are not needed and
completions are coalesced, because in order.
