Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4DE399806
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 04:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFCC3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 22:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCC3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 22:29:09 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80074C06174A;
        Wed,  2 Jun 2021 19:27:10 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id a2so6448360lfc.9;
        Wed, 02 Jun 2021 19:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BReYRbHXWvGepYMIo6MFKfcfxjtKBwb1nZu8ULNLHcc=;
        b=orB6wH41AvxddfTraIb3sZd93u7R5rnd/DKRY2foZZWeKvLJUw+YowIlWCMxyynSwX
         FohZVRdiKTZ92zW2P2Le/1762OCaepVZvnQ3QerOt4WlJhvKwZHEdnxMe3uw2WmRJnA+
         cZYqGyfnp6sDVK6s/10il61CGquRMDVcHOHvvhldBzeC92nRphG5m5s2w9JPnklNGogQ
         WDTFN7lHPm0+D7lPYA9NwEse1atxRxzqaU2aY7agpfbUKHaKlmzfGcenC+A1Bgo45Lqi
         jOy7jUG9ktGWWPi3iFMyMQYgHzsqQeuaCzbdMq0VpyzvFpnjaP8/SiEhouxakvB2e2GY
         BYQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BReYRbHXWvGepYMIo6MFKfcfxjtKBwb1nZu8ULNLHcc=;
        b=spiNp/IHmfp6V6ZGxiShe5AYvYDLyvyy9kQDkgot5ZIdZ54G/3WU13uEpbmEK7K6CS
         x6NY+YUg3gm18mghwRQZZ3gATnzx5bI/t7SlpM/fUALcC8F7zHW2nzpEGQKd5Q8ja01X
         SynxH0Vqsu/sWvABXnilBUW+tFnNFARtQoPLZFTAa9jd1Q3Nq+psLcOWz5j3uoYYvDgV
         yr+rT3GxSLo3qUelZf56j2pdmvVrMFM22XTf7V/8lYblJCuIFQ0yoLC0MqKqL7lSFcVN
         mYPoLySfDrQMsPrZFtrWnnhJFL0op/8x+PqS6XAKvbfwDrlBLlFpUSYWsmtAvFMgaK4e
         faiw==
X-Gm-Message-State: AOAM531Id6YxqyOUZn4g/2zs/H9iVEm9Nq+Ky+B/A9WHz0mkdkb4sAtZ
        /Hmmji1ZZc4e8HfQr0EiTz4Vxl3xR/DmS00C/AA=
X-Google-Smtp-Source: ABdhPJz+/mol60y7157Ls3YUkrtb37+vDz19gkQP11F5X3o4NCubMvUCX1DjMJ1HKeF15VRC/9pzclNBkaetPxsOkns=
X-Received: by 2002:a19:3f0a:: with SMTP id m10mr26429532lfa.477.1622687227206;
 Wed, 02 Jun 2021 19:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <CADxym3baupJJ7Q9otxtoQ-DH5e-J2isg-LZj2CsOqRPo70AL4A@mail.gmail.com>
 <e91baaba-e00a-4b16-0787-e9460dacfbb9@redhat.com>
In-Reply-To: <e91baaba-e00a-4b16-0787-e9460dacfbb9@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 3 Jun 2021 10:26:55 +0800
Message-ID: <CADxym3ZdyqJ7b_PqdcjbNhKWP7_nsPRQ9Q0TtFC6Qzr75ekK+g@mail.gmail.com>
Subject: Re: The value of FB_MTU eats two pages
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Maloy,

On Thu, Jun 3, 2021 at 3:50 AM Jon Maloy <jmaloy@redhat.com> wrote:

[...]
> Hi Dong,
> The value is based on empiric knowledge.
> When I determined it I made a small loop in a kernel driver where I
> allocated skbs (using tipc_buf_acquire) with an increasing size
> (incremented with 1 each iteration), and then printed out the
> corresponding truesize.
>
> That gave the value we are using now.
>
> Now, when re-running the test I get a different value, so something has
> obviously changed since then.
>
> [ 1622.158586] skb(513) =>> truesize 2304, prev skb(512) => prev
> truesize 1280
> [ 1622.162074] skb(1537) =>> truesize 4352, prev skb(1536) => prev
> truesize 2304
> [ 1622.165984] skb(3585) =>> truesize 8448, prev skb(3584) => prev
> truesize 4352
>
> As you can see, the optimal value now, for an x86_64 machine compiled
> with gcc, is 3584 bytes, not 3744.

I'm not sure if this is a perfect way to determine the value of FB_MTU.
If 'struct skb_shared_info' changes, this value seems should change,
too.

How about we make it this:

#define FB_MTU (PAGE_SIZE - \
         SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - \
         SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM + 3 + \
                 MAX_H_SIZ))

The value 'BUF_HEADROOM + BUF_TAILROOM + 3' come from 'tipc_buf_acquire()':

#ifdef CONFIG_TIPC_CRYPTO
    unsigned int buf_size = (BUF_HEADROOM + size + BUF_TAILROOM + 3) & ~3u;
#else
    unsigned int buf_size = (BUF_HEADROOM + size + 3) & ~3u;
#endif

Is it a good idea?

Thanks
Menglong Dong
