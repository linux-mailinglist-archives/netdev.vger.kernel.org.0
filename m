Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B47D1CA26A
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 06:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbgEHEsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 00:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgEHEsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 00:48:40 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28447C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 21:48:40 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g13so292402wrb.8
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 21:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XJPjpwZyTNmbhS680GP/cM4OxoQJiPQ/2WkBvmCJzSg=;
        b=cjFTDcHK2vfNsZtlcuXF6NOqnV/njwfc8t6CJSUauLXUtRoqL5jrUlO4p81Fbc/qoO
         17qm1EG5zgugvlxzE6pYxfXcByxo3/dx72jwUn+VybfDGuVCxTYNYLCZIxzL0eZ1SmJL
         57m8BRtclA5G1mHChul8geI01R52xM7KOdme3xpE8KiQoaWdKX0gPu8oGF8j14ZKkaIn
         oSEYxvxThPm1i34wVGEy32b+Cu1V2+B02MialNyx7EBYeh9LG1dW1myYjwysOtKiOCGg
         wLVFagmwiT6uKyHt8AJe4iNyrlG8QOai5Mwc3hdRVZ/jECDaoCtTYYKoYQKT44uHf8PL
         Lmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XJPjpwZyTNmbhS680GP/cM4OxoQJiPQ/2WkBvmCJzSg=;
        b=dM4IAL19q49QmitDsbGJzBR063UgBPEl6NWUis/S0G6lB9ZV1or8lRJPgEbr4oYlc8
         dBR921xzpMGTrsfmKGW5NlmhdpgFtRMQKl8HkO7nWPZS86BVlGyI3M6k6iCR/+1aOvh5
         SWcsZIIzYqVNW2uZls66U0AOk2qD6HeI1oIjQ7qRpKIG0IMP1KUpdvuk2l7oW7xaYsBO
         20NnNpcqyB/DAfZ+l/dLHvJnRx/CVubGCxuOgId2VS5/aabMA0zSuGmex3kQFQHDmj4U
         9KvW5TCnwBB8SRf9jsSZq6+oRMjQeUwLwpQQ2/70zm4uYgoLJ8qHytRpCWjMErYghsht
         KrBQ==
X-Gm-Message-State: AGi0PubwIQJ5Um/DkoW2fL8CjmDfqb1Em4sYZQuzG7QgVXcb0chBvIgH
        dr5JRT5EaJLV643Lbmpusu5GlObaCU75Lglwcf8=
X-Google-Smtp-Source: APiQypJoXgB7qSvcxH0Zg1Mm0JQQLTEyyWaa4QhJwYwh2LdM/j2p6KvzbKK2Nu0p0jvAXiTqoU1LuDXxdMA4tbVniu0=
X-Received: by 2002:adf:fccc:: with SMTP id f12mr584191wrs.267.1588913318832;
 Thu, 07 May 2020 21:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200508040728.24202-1-haokexin@gmail.com>
In-Reply-To: <20200508040728.24202-1-haokexin@gmail.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 8 May 2020 10:18:27 +0530
Message-ID: <CA+sq2CfMoOhrVz7tMkKiM3BwAgoyMj6i2RWz0JWwvpBMCO3Whg@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers
To:     Kevin Hao <haokexin@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 9:43 AM Kevin Hao <haokexin@gmail.com> wrote:
>
> In the current codes, the octeontx2 uses its own method to allocate
> the pool buffers, but there are some issues in this implementation.
> 1. We have to run the otx2_get_page() for each allocation cycle and
>    this is pretty error prone. As I can see there is no invocation
>    of the otx2_get_page() in otx2_pool_refill_task(), this will leave
>    the allocated pages have the wrong refcount and may be freed wrongly.

Thanks for pointing, will fix.

> 2. It wastes memory. For example, if we only receive one packet in a
>    NAPI RX cycle, and then allocate a 2K buffer with otx2_alloc_rbuf()
>    to refill the pool buffers and leave the remain area of the allocated
>    page wasted. On a kernel with 64K page, 62K area is wasted.
>
> IMHO it is really unnecessary to implement our own method for the
> buffers allocate, we can reuse the napi_alloc_frag() to simplify
> our code.
>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>

Have you measured performance with and without your patch ?
I didn't use napi_alloc_frag() as it's too costly, if in one NAPI
instance driver
receives 32 pkts, then 32 calls to napi_alloc_frag() and updates to page ref
count per fragment etc are costly. When traffic rate is less then it
may not matter
much.

Thanks,
Sunil.
