Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A7128AAB6
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 23:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbgJKV0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 17:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387413AbgJKV0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 17:26:20 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC495C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:26:20 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id x185so8116200vsb.1
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SZUNdurckM9B/t8SxFM3zWAKD0fttYQsyiO55yfZxkg=;
        b=lJhko81lJxGr581CSXUCKZYPNqjGck+4SyOYjGrZcWnfK1aLH8wVZwdleiVAnp9gNV
         7XnwU7PrSJroZ1sNTfUJ40d37Nu6MzGFv7g24Bz/CRRlN571OO7BQVExYXokd3E5zQA0
         uh/wBnC1NU6iCMZrLnFPO5mSAcg6BrpZD6xITEfHp3EOB9NyvstHtJR9gyhyjjoqrMpi
         H4pufZJU4huN+h8sCTDYtPLxGc5fu0PFZN/xBQhQxtPh7+MIM7UZRdE0M3sEgKFpF1u7
         RGWn4KTR42yfcAgNuVwBCBCdkxRg/m0rxWvCJJZU4HqTk05Q6M2bP7hEr5x7KNPjAzPX
         3rDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SZUNdurckM9B/t8SxFM3zWAKD0fttYQsyiO55yfZxkg=;
        b=AMK0Fmj8yK1PE8YwefkqbCXKQbqx385uBosc5PFMfGttH1YgniOazbKLrVbjogHgno
         vzU+dB2lNg4kdlMXniAlcKLvnA0X4VtllhJUpumLtq596GtZUU9fNhDFtc/zNMNTfFRC
         x+eGR9c0dqA1LW/Bnfk2NCyNBzOzyYW19hTh9/9vTj8KBThQnVOmhu+N/d2opsu4/ucY
         mlhmo7pP95F+bIReJWZfEkRHSSvRguXmPdJimQtWrxyf7WemGtD3DqWTVjitDrMRRksN
         +hXBFSN79LXdnxfq4BXqSOi2YSbRS8RtJMw0etjigN7eSQ9diGbSbBei6VH86rc/jMfj
         j5tw==
X-Gm-Message-State: AOAM531jUr5Q5UaXatZrCbTk0Th0XNWfQH10yadxvPiG39Zef4mIiZzT
        cPOf/QER1hb5+J+c18vuD8EnaxHDGZ0=
X-Google-Smtp-Source: ABdhPJy4PXbjD+nihGGTbUSdn7uQJNFYNejoRY64yYoZ2N8tWN1lICe1NdiN0LqqWaN0qVA6BJwx+g==
X-Received: by 2002:a05:6102:3014:: with SMTP id s20mr1441700vsa.27.1602451579535;
        Sun, 11 Oct 2020 14:26:19 -0700 (PDT)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id h10sm1958579vke.46.2020.10.11.14.26.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 14:26:18 -0700 (PDT)
Received: by mail-ua1-f54.google.com with SMTP id d18so4877939uae.0
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:26:18 -0700 (PDT)
X-Received: by 2002:ab0:6156:: with SMTP id w22mr2014070uan.122.1602451577938;
 Sun, 11 Oct 2020 14:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com> <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
In-Reply-To: <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 11 Oct 2020 17:25:41 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdWd0mG7W3Cb2PaAVceV5C0DkYkmGtqKiP6+cD_f3k-zA@mail.gmail.com>
Message-ID: <CA+FuTSdWd0mG7W3Cb2PaAVceV5C0DkYkmGtqKiP6+cD_f3k-zA@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        Xie He <xie.he.0141@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 5:00 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Oct 11, 2020 at 3:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
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
> > to ipgre_xmit(). Similar for dev->needed_headroom.
> >
> > dev->hard_header_len is supposed to be the length of the header
> > created by dev->header_ops->create(), so it should be used whenever
> > header_ops is set, and dev->needed_headroom should be used when it
> > is not set.
> >
> > Reported-and-tested-by: syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
> > Cc: Xie He <xie.he.0141@gmail.com>
> > Cc: William Tu <u9012063@gmail.com>
> > Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>


> I agree that then swapping dev->needed_headroom for
> dev->hard_header_len at init is then a good approach.
>
> Underlying functions like ip_tunnel_xmit can modify needed_headroom at
> runtime, not sure how that affects runtime changes in
> ipgre_link_update:

Never mind, the patch only selects between needed_headroom or
hard_header_link at ipgre_tunnel_init.

> > @@ -987,10 +991,14 @@ static int ipgre_tunnel_init(struct net_device *dev)
> >                                 return -EINVAL;
> >                         dev->flags = IFF_BROADCAST;
> >                         dev->header_ops = &ipgre_header_ops;
> > +                       dev->hard_header_len = tunnel->hlen + sizeof(*iph);
> > +                       dev->needed_headroom = 0;
>
> here and below, perhaps more descriptive of what is being done, something like:
>
> /* If device has header_ops.create, then headers are part of hard_header_len */
> swap(dev->needed_headroom, dev->hard_header_len)

Arguably nitpicking. Otherwise, patch looks great to me, thanks, so

Acked-by: Willem de Bruijn <willemb@google.com>
