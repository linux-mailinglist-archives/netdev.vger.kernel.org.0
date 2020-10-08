Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CCE287B09
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbgJHRd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729179AbgJHRd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 13:33:56 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122D5C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 10:33:55 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id o17so1523724ioh.9
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 10:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iaeoc6Z+j37l5fM3/LyJnM1wsdflxCQu9r5PHg7l2V8=;
        b=PPpppjTaYufAXFGB4G5C3WnHczN9a0elI/v2I77ce7Wxk2yalWhX4SmYIqEAe5TUxw
         +I7KHdt5zDInMGzvbIXNtqI8Ezh4dvfkn/C4c1gIqAMgKpqGwXRfvP4qvkNYBO+rN3a1
         sA2GEKcio/GaVqs0aRtr9Jnt99la06etOqyOALHjCNxCPZ9+cDlB//j5OGoiYBb+sI4v
         YmnLhXo9pWa2+dkC3KVkO7S9xWd8RTEpvDSrc9eSOKkSQ/LcEujn1awLNd11SKMyzApA
         pNkgeoChKz+q2zqdq/2IYQrMeRo1uKJNGW3DNgoVibHLgf+VQMjSRFD6qkyhXS8tYRGp
         erFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iaeoc6Z+j37l5fM3/LyJnM1wsdflxCQu9r5PHg7l2V8=;
        b=ULS/x5atcAvf47HLWPggSEpj0GTBbliJ9AYRsBq139AUM1NAyJlRifTwX+nmrikUxQ
         MRRevyLveBbjDXXT32TuLmj5gXtrhSImqwWU9uA0zvxcaOlZEGXm/uhTzPPKQ8ZPOGWM
         bcQfM5ZsLeoq+51+vrRji3cSroLjGi0Yow9mrbprXmAS+NNoeyt8qydJ07FLwh9jNp9I
         9CWzLvGoWDZPUyKUAeedtz5z8KQqFDnb4I9BEnu9fC9ZJwmsP+9VeWNBOBoqZOHJb60i
         9F+zlVt9Rfl0FGja/VNgAo/5HyRdQMQPrK1kk56y+29DGwBApfG1Vno+r6XGJSBpUORa
         tOGA==
X-Gm-Message-State: AOAM5320Bd2gT3JcWI1h4mQkKgjHOHbcRsZhZc9NleGdvk83PG0NIVyM
        Iz9u+7ZEleiC2+g7cvZ//qD0kZh2mPI3i0CvZif2WomlNopIsg==
X-Google-Smtp-Source: ABdhPJxskURl0Ygx8QqzgR3khSNO6Kg+BZ+gtfwC6gRTCkfZOFwbnaEZuhkJyPY1th5SufLEJC1Nph0sXChA0zT82qs=
X-Received: by 2002:a6b:b446:: with SMTP id d67mr2723243iof.134.1602178434104;
 Thu, 08 Oct 2020 10:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com> <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
In-Reply-To: <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Oct 2020 10:33:43 -0700
Message-ID: <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>, Xie He <xie.he.0141@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 4:49 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Oct 7, 2020 at 9:22 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> > conditionally. When it is set, it assumes the outer IP header is
> > already created before ipgre_xmit().
> >
> > This is not true when we send packets through a raw packet socket,
> > where L2 headers are supposed to be constructed by user. Packet
> > socket calls dev_validate_header() to validate the header. But
> > GRE tunnel does not set dev->hard_header_len, so that check can
> > be simply bypassed, therefore uninit memory could be passed down
> > to ipgre_xmit().
>
> If dev->hard_header_len is zero, the packet socket will not reserve
> room for the link layer header, so skb->data points to network_header.
> But I don't see any uninitialized packet data?

The uninit data is allocated by packet_alloc_skb(), if dev->hard_header_len
is 0 and 'len' is anything between [0, tunnel->hlen + sizeof(struct iphdr)),
dev_validate_header() still returns true obviously but only 'len'
bytes are copied
from user-space by skb_copy_datagram_from_iter(). Therefore, those bytes
within range (len, tunnel->hlen + sizeof(struct iphdr)] are uninitialized.

Thanks.
