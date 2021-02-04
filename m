Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4787730F759
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbhBDQMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbhBDQMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 11:12:12 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA515C061788
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 08:11:32 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id j5so3719709iog.11
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 08:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4O+Q1wjW6HU9wmvbkJehqwCGuTHXLn6iBYjKhoZV+c0=;
        b=il8r/YMHiyr4qkePS28wVHypYFX6d4+6h6Er8JEW4hb4DytQHWHMNBDJvdoqZINzyB
         crMvkl8XxrNq3S/5xUWVpkXeBVgmQTIRc5aVnV5PglXzwoLoTh12qbfjJvE29G4CyEhQ
         /WuWwBSRm3PnIDw78gjM+QIxMgAKn1UMnS57qthlL0lG57WoenucCuSXJwgajnK6tN9/
         E7r4jTL8uwGNzygzI6OgvoU/zojX5cs1+Qgvx853bXf/Lw3HxNbB+3LRoGNaz2c61v8x
         I1rnkGkg7GfgJ63Y+PzTTfR7uGCsxrvMGupqUIIWSrXCITMFetdB2Pd/zVb6ZeEKoWSs
         UQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4O+Q1wjW6HU9wmvbkJehqwCGuTHXLn6iBYjKhoZV+c0=;
        b=mdiS0O38VBXhvtDEpMnrwJgJg32Gji6hvi6zQvRmZ8FC3/RPgR4o558mcYJVRlMrNB
         y98mXWnOAV1UqRaWb1qffGr3GbaUpl3ji+0rbhFm/kxTnDnOcNRcoXr9suwWULES03ry
         t9R14ZqSuz73ZzdD1eYC4Nh9SMz7baqCYItn6xfKfv4DvUwTbTGOvPB2rC/Lr93ruxHV
         Zp9QAClG2uQW6IM9gVZQAUKo50oHeh/6MM67ZWNihgxDnLT6yBa6sftOPgPjGgOsiJbh
         6eNXvZZ+17kr/YzoNSA7lVwJVD39td1olNnZwN5rwDVxzEXmTBoQjUMkPM7H5zc9WPFW
         uI9A==
X-Gm-Message-State: AOAM530RqOpprY6BvYewO4OFhWs2QmjxG5TO6S1D/QnnhY1fMFC+KREj
        kJyjEzD5ieEIbIXiv7mMVkSvIEZsUYCs54bhWM4=
X-Google-Smtp-Source: ABdhPJx3CUvwgTBp2pUq7kM/AsyvLxdQyIPPKPSlkjOrXnZ0k+1HRLng2on9YsvrvXe9Hr5MlP4QVo+0xiGVcXWVcL0=
X-Received: by 2002:a05:6638:204b:: with SMTP id t11mr229898jaj.87.1612455091992;
 Thu, 04 Feb 2021 08:11:31 -0800 (PST)
MIME-Version: 1.0
References: <20210204105638.1584-1-haokexin@gmail.com> <20210204105638.1584-2-haokexin@gmail.com>
In-Reply-To: <20210204105638.1584-2-haokexin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 4 Feb 2021 08:11:21 -0800
Message-ID: <CAKgT0UffcP_op+=oYL2xBMWeOqy3G7xpqLxsoK0hMws0OFGdmw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/4] mm: page_frag: Introduce page_frag_alloc_align()
To:     Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 3:06 AM Kevin Hao <haokexin@gmail.com> wrote:
>
> In the current implementation of page_frag_alloc(), it doesn't have
> any align guarantee for the returned buffer address. But for some
> hardwares they do require the DMA buffer to be aligned correctly,
> so we would have to use some workarounds like below if the buffers
> allocated by the page_frag_alloc() are used by these hardwares for
> DMA.
>     buf = page_frag_alloc(really_needed_size + align);
>     buf = PTR_ALIGN(buf, align);
>
> These codes seems ugly and would waste a lot of memories if the buffers
> are used in a network driver for the TX/RX. So introduce
> page_frag_alloc_align() to make sure that an aligned buffer address is
> returned.
>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> v3: Use align mask as suggested by Alexander.
>
>  include/linux/gfp.h | 12 ++++++++++--
>  mm/page_alloc.c     |  8 +++++---
>  2 files changed, 15 insertions(+), 5 deletions(-)

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
