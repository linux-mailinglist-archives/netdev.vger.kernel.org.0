Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB0135B0C9
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 01:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhDJXeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 19:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbhDJXeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 19:34:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC2EC06138A
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 16:33:59 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id c15so201526wro.13
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 16:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SPQP1AlG80lVtzcKmLeMBKgBFLwPTctBeZqtIKnIfNo=;
        b=mgIsBwkSdnPp1ECywVFveIPdAGLy5eDNUtti1/GRTQI5lIDSCteZFdlqioFtrWpUvC
         3CZrD1twAvjt/dnImbvGgUSKEcE6ui3refwNdedP0EqKDEADmgXwol55VZyIhYeRwsqb
         8SP+xLZqA2NHExfmJ7j8CjbAM/Ym04YzTwU3Qpi8y5J3d1oKsRNRkzG3LeIPl5qHR7Yp
         /S2x5qr4rQCnYypxooKgIWvs3dgqzxuBqFL18u8NaioIdE2qEUC6QQNTsyqd7Tc6yUdF
         vsGQkFpfiI6GsAGUmJa3YiH7U+08HHYWz+RkczJvTQoQi9EbxQbtBZFf2QKvY63AE5ps
         QNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SPQP1AlG80lVtzcKmLeMBKgBFLwPTctBeZqtIKnIfNo=;
        b=fdN+QQLR99HgkR7yml02v1hdgrq/OVTqPpEYPPJTIUdQonSGG7r9XSl2HjVwJal+3S
         q0Sjs9WNdCflLe3NZYvsVXsXzIsIriZ1i5ojaiWX3x/MvAJ3w5bOsoLvewz+yiJKDN5u
         lxWwr+REm6TilCg7CGy8pDlfM00xxf2LukRyw63wth+aad3Zd3lDGba66cki1zxh5cq3
         u+puMY/T1kU0eY8f+05fdcCYjT8GPwiPro0QIVygXXWwi9TJD3JYjcnlJ1Ll6E2UyalS
         7ftFdr9rfhG914c/rBLGibdbmhTHcbgpHgpEzg9gwouH5zEyTLvGd8YOGMMUfwgFlYXC
         bffA==
X-Gm-Message-State: AOAM5316SMSLJLtITeo0Ol+e6d4J4KFT7wWd57pEnRSxw/B4BeZsJyIM
        1RRBBDay9brZDkR/xQbLWzNOGQ==
X-Google-Smtp-Source: ABdhPJwDvHW5deUPUee2///ZQ7WTP2K5nhuT39hRK/6meJuM9hO9hsOQ3TMuTSJ2bCPKtGoUJRl1Sw==
X-Received: by 2002:a5d:4c52:: with SMTP id n18mr24883949wrt.210.1618097637967;
        Sat, 10 Apr 2021 16:33:57 -0700 (PDT)
Received: from KernelVM (2.0.5.1.1.6.3.8.5.c.c.3.f.b.d.3.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16:0:3dbf:3cc5:8361:1502])
        by smtp.gmail.com with ESMTPSA id s13sm10886016wrv.80.2021.04.10.16.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 16:33:57 -0700 (PDT)
Date:   Sun, 11 Apr 2021 00:33:55 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        linmiaohe <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Marco Elver <elver@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Al Viro <viro@zeniv.linux.org.uk>, vladimir.oltean@nxp.com,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: core: sk_buff: zero-fill skb->data in __alloc_skb
 function
Message-ID: <YHI143tR7iSCpV6x@KernelVM>
References: <20210410095149.3708143-1-phil@philpotter.co.uk>
 <CANn89iJdoaC9P_Nd=BrXVRyMS43YOg-DX=VciDO89mH_JPVRTg@mail.gmail.com>
 <CANn89iK4HuKv4AgY5PPWGEEihNEFxGhhqpBp7zv-FfCcJyboDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iK4HuKv4AgY5PPWGEEihNEFxGhhqpBp7zv-FfCcJyboDg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 10, 2021 at 01:00:34PM +0200, Eric Dumazet wrote:
> On Sat, Apr 10, 2021 at 12:12 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Sat, Apr 10, 2021 at 11:51 AM Phillip Potter <phil@philpotter.co.uk> wrote:
> > >
> > > Zero-fill skb->data in __alloc_skb function of net/core/skbuff.c,
> > > up to start of struct skb_shared_info bytes. Fixes a KMSAN-found
> > > uninit-value bug reported by syzbot at:
> > > https://syzkaller.appspot.com/bug?id=abe95dc3e3e9667fc23b8d81f29ecad95c6f106f
> > >
> > > Reported-by: syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com
> > > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > > ---
> > >  net/core/skbuff.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 785daff48030..9ac26cdb5417 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -215,6 +215,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> > >          * to allow max possible filling before reallocation.
> > >          */
> > >         size = SKB_WITH_OVERHEAD(ksize(data));
> > > +       memset(data, 0, size);
> > >         prefetchw(data + size);
> >
> >
> > Certainly not.
> >
> > There is a difference between kmalloc() and kzalloc()
> >
> > Here you are basically silencing KMSAN and make it useless.
> >
> > Please fix the real issue, or stop using KMSAN if it bothers you.
> 
> My understanding of the KMSAN bug (when I released it months ago) was
> that it was triggered by some invalid assumptions in geneve_xmit()
> 
> The syzbot repro sends a packet with a very small size (Ethernet
> header only) and no IP/IPv6 header
> 
> Fix for ipv4 part (sorry, not much time during week end to test all this)
> 
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index e3b2375ac5eb55f544bbc1f309886cc9be189fd1..0a72779bc74bc50c20c34c05b2c525cca829f33c
> 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -892,6 +892,9 @@ static int geneve_xmit_skb(struct sk_buff *skb,
> struct net_device *dev,
>         __be16 sport;
>         int err;
> 
> +       if (!pskb_network_may_pull(skb, sizeof(struct iphdr))
> +               return -EINVAL;
> +
>         sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
>         rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
>                               geneve->cfg.info.key.tp_dst, sport);

Dear Eric,

Thank you for your help/feedback. I have crafted a patch using your code
above and the equivalent check for geneve6_xmit_skb, and this works for
me on my local KMSAN build. I am also running it through syzbot to check
there as well. I will send out with appropriate attribution assuming all
is OK on the testing front.

Regards,
Phil
