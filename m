Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C7C22F630
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgG0RIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbgG0RIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:08:23 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAFBC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:08:23 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id m200so4965828ybf.10
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/vDGS9zTe92lE9oiGpxXAh9jznhWHryOBVpOpXfea24=;
        b=l50NcuBk1P0SHQh2ms6eOcespZ3vhEyjXQ6hoFMSau2JoM7R5TzyWu8u9i7zJTZKgB
         aB0yfF0eAmREUSkiS1RK5afzc6cjEhOwhQDWEVwMd9WvJ1b+nz7W6FWh2YTV9t3twGim
         AfHe93ApFgQ9kbNJG1CRpsXZg5C1x+OIzpeAJA1jL9797xxNeRUvwzxDy1/X1MqIGhCQ
         NIzlzg0yqdezeXOudZVE9Nxy8wg7HbgucXaI0NltCHSbd0K+TXYEFmeHBd3ytuCDB2f4
         rw6lZiqEmWYrsrEp3xs8sKCYEyHtWMpFxlCd7hbYZrO9drFx2hqBAGmCZ0wgfd70d0lx
         6VDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/vDGS9zTe92lE9oiGpxXAh9jznhWHryOBVpOpXfea24=;
        b=jHq8PvBs7yZFfHi5I9UmQIodnXvUA+zbIbaxbTnWi1UF0NIZLmjpaGQkrWBsv/GQCt
         z5qIC+5pwiKVUx9qL9fuJGLALD+0JHnUQ2b5ebCxRp6exkJgmj/wgfh9tR7uqSeKHaH1
         bqU8Nlgr0QyIdRhMkEDOkj5bDEHFXe/SQ8BjrJ3zRuhYQ8N93jVzT/42xxD4jpmYhkOf
         dPQKnAV8p8jLCMctwFuMdjuQ+OFD2T9a/Zf58P1gGULPHZ7sN7Gb4El7RuymCj6ppFkn
         X4JxdbzMziRtGNICS20BVX86WrsbGeUwc+op+xbZeVIW6F3yyrvQe7LObNL7oPM+MbR7
         UDAQ==
X-Gm-Message-State: AOAM5329/fQJlF/GdxztgA2HIyf2gVY5ohjrwQXc/7WcJ+9qWbOIQOR6
        YFWtu7qwvFk/sao0n1VxkFQ00Z+X3DwOngeCTfFo3w==
X-Google-Smtp-Source: ABdhPJwiZWHbQmf9XkevoCcj1gkCxvse3H0i6xtb5TW+YjXQZAQ8yWgMdNXmbx05qRORk3/Tp5RBFYogmibO8gBhJWI=
X-Received: by 2002:a25:a121:: with SMTP id z30mr37278633ybh.408.1595869702412;
 Mon, 27 Jul 2020 10:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-9-jonathan.lemon@gmail.com> <CANn89i+AZ9PnRssWpiE5zj41V1=85Jcy80Rtbp7mLjp73Y71Pw@mail.gmail.com>
 <20200727165904.twsfhafflw2ws4t4@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200727165904.twsfhafflw2ws4t4@bsd-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jul 2020 10:08:10 -0700
Message-ID: <CANn89iJBLrmvtTmyBAwErejCEMdt6gLNNRX1XZ1oMorAWrbp4g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 08/21] skbuff: add a zc_netgpu bitflag
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        borisp@mellanox.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 10:01 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> On Mon, Jul 27, 2020 at 08:24:55AM -0700, Eric Dumazet wrote:
> > On Mon, Jul 27, 2020 at 12:20 AM Jonathan Lemon
> > <jonathan.lemon@gmail.com> wrote:
> > >
> > > This could likely be moved elsewhere.  The presence of the flag on
> > > the skb indicates that one of the fragments may contain zerocopy
> > > RX data, where the data is not accessible to the cpu.
> >
> > Why do we need yet another flag in skb exactly ?
> >
> > Please define what means "data not accessible to the cpu" ?
> >
> > This kind of change is a red flag for me.
>
> The architecture this is targeting is a ML cluster, where a 200Gbps NIC
> is attached to a PCIe switch which also has a GPU card attached.  There
> are several of these, and the link(s) to the host cpu (which has another
> NIC attached) can't handle the incoming traffic.
>
> So what we're doing here is transferring the data directly from the NIC
> to the GPU via DMA.  The host never sees the data, but can control it
> indirectly via the handles returned to userspace.
>

This seems to need a page/memory attribute or something.

skb should not have this knowledge, unless you are planning to make
sure that everything accessing skb data is going to test this new flag
and fail if it is set ?


> I'm not sure that a flag on the skb is the right location for this -
> perhaps moving it into skb_shared() instead would be better?
> --
> Jonathan
