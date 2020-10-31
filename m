Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4073D2A1881
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgJaPVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgJaPVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:21:47 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75000C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:21:47 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id u7so5035963vsq.11
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4W4oQhRIlWZIFSlIURKMXHUi44ZUwx3dAHZVQ86rrfE=;
        b=L0uh1LvKqpLiL52HsiQ4lrCXnVGadBFd37Z9PviB2uYHLh6T9pd1YCQHXYdA2HW7AY
         zrgLNSZhz3bt1n4ms0ICegXY9ZS87q13TGF+2g8o6a6rKUmgjSP/N9HEDmfNzHT5LIzr
         Dm+3mE61wzy6exwgy7FqslSoTTGqbLzu2AF1h+iOR+1/7bV+b74zwlqxE3W0Bnt+ukya
         049s59nMC0BZYnGv7L8loaVBXMYbcFKvzsr56Ha2hYD4yteWhW8MjAcgfY9mZFd9oGNA
         0PdWcELY2X4VCr4xUxBvsaXrR3by7Pu5oRAjR+yPBCOerXgJ4v9xJQqqnQZFmjWWo3Jr
         bWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4W4oQhRIlWZIFSlIURKMXHUi44ZUwx3dAHZVQ86rrfE=;
        b=Tq8IEndH8WpheD+a0jGfVf8OdJGjEoudNxJj++QZJ4Ro1ZVR2cpxPs5nhq5L/BaKvp
         kM2c4L1aGhsGAQS4TjAvPYA1ihghkx3kdBnbI4uYX9zwZrmOZ446jatbWWx/nGfsfMnJ
         SH1ThexHnGjHtTAl+JpvL0REx2GSj548rfV5TdqEU6IXrTZlHl3zEbqLH5mOoqijbEl1
         x7OTUVH1uSjaSGj1MnnxT6+jXJmR5flLZ2vJ0CPvxuZiYN/jSH2WTZxvbJakQhlZ7ab+
         SzrGu2EPj8/Ntr1VWPZXmc9zJK7weZthjRHqFBk4qnak3ohjh1MOqWTnVfITXntgj69I
         eskg==
X-Gm-Message-State: AOAM532NAMMXjvVycPIIsBusloJyvREovrgOSkbFXRv6a6j24G0TWJzy
        eTNV9a/IhWeJ3iU5BOGPqyDdx9reXSs=
X-Google-Smtp-Source: ABdhPJy+di0r9VDiRAzJhHeICUKkgF9r4fk2b8Ynk7OsD3wSVOvns9cQz0ZdZCqrkVNyCWmFBGC7Qg==
X-Received: by 2002:a67:8e4a:: with SMTP id q71mr11190095vsd.1.1604157706167;
        Sat, 31 Oct 2020 08:21:46 -0700 (PDT)
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com. [209.85.221.182])
        by smtp.gmail.com with ESMTPSA id s20sm1175881vkl.8.2020.10.31.08.21.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 08:21:45 -0700 (PDT)
Received: by mail-vk1-f182.google.com with SMTP id r17so2087090vkf.6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:21:45 -0700 (PDT)
X-Received: by 2002:a1f:c149:: with SMTP id r70mr10043246vkf.1.1604157704723;
 Sat, 31 Oct 2020 08:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <Mx3BWGop6fGORN6Cpo4mHIHz2b1bb0eLxeMG8vsijnk@cp3-web-020.plabs.ch>
 <CA+FuTSdiqaZJ3HQHuEEMwKioWGKvGwZ42Oi7FpRf0hqWdZ27pQ@mail.gmail.com> <TSRRse4RkO_XW4DtdTkz4NeZPwzHXaPOEFU9-J4VlpLbUzlBzuhW8HYfHCfFJ1Ro6FwztEO652tbnSGOE-MjfKez1NvVPM3v3ResWtbK5Rk=@pm.me>
In-Reply-To: <TSRRse4RkO_XW4DtdTkz4NeZPwzHXaPOEFU9-J4VlpLbUzlBzuhW8HYfHCfFJ1Ro6FwztEO652tbnSGOE-MjfKez1NvVPM3v3ResWtbK5Rk=@pm.me>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 31 Oct 2020 11:21:07 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeTtzX4G0ZivPFOtx3gdQ0FxxHqsQ3kT8swL0-ryaiaTA@mail.gmail.com>
Message-ID: <CA+FuTSeTtzX4G0ZivPFOtx3gdQ0FxxHqsQ3kT8swL0-ryaiaTA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: avoid unneeded UDP L4 and fraglist GSO resegmentation
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 6:31 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> On Saturday, 31 October 2020, 2:12, Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
>
> Hi Willem,
>
> > On Fri, Oct 30, 2020 at 2:33 PM Alexander Lobakin alobakin@pm.me wrote:
> >
> > > Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") added a support
> > > for fraglist UDP L4 and fraglist GSO not only for local traffic, but also
> > > for forwarding. This works well on simple setups, but when any logical
> > > netdev (e.g. VLAN) is present, kernel stack always performs software
> > > resegmentation which actually kills the performance.
> > > Despite the fact that no mainline drivers currently supports fraglist GSO,
> > > this should and can be easily fixed by adding UDP L4 and fraglist GSO to
> > > the list of GSO types that can be passed-through the logical interfaces
> > > (NETIF_F_GSO_SOFTWARE). After this change, no resegmentation occurs (if
> > > a particular driver supports and advertises this), and the performance
> > > goes on par with e.g. 1:1 forwarding.
> > > The only logical netdevs that seem to be unaffected to this are bridge
> > > interfaces, as their code uses full NETIF_F_GSO_MASK.
> > > Tested on MIPS32 R2 router board with a WIP NIC driver in VLAN NAT:
> > > 20 Mbps baseline, 1 Gbps / link speed with this patch.
> > >
> > > Signed-off-by: Alexander Lobakin alobakin@pm.me
> > >
> > > ------------------------------------------------
> > >
> > > include/linux/netdev_features.h | 4 ++--
> > > 1 file changed, 2 insertions(+), 2 deletions(-)
> > > diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> > > index 0b17c4322b09..934de56644e7 100644
> > > --- a/include/linux/netdev_features.h
> > > +++ b/include/linux/netdev_features.h
> > > @@ -207,8 +207,8 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
> > > NETIF_F_FSO)
> > > /* List of features with software fallbacks. */
> > > -#define NETIF_F_GSO_SOFTWARE (NETIF_F_ALL_TSO | \
> > >
> > > -                                  NETIF_F_GSO_SCTP)
> > >
> > >
> > >
> > > +#define NETIF_F_GSO_SOFTWARE (NETIF_F_ALL_TSO | NETIF_F_GSO_SCTP | \
> > >
> > > -                                  NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRAGLIST)
> > >
> > >
> >
> > What exactly do you mean by resegmenting?
>
> I mean pts 5-6 from the full path:
> 1. Our NIC driver advertises a support for fraglists, GSO UDP L4, GSO fraglists.

I see. This was the part I missed. The commit message mentions that no
mainline driver advertises h/w offload support. I had missed that
there may be non-mainline drivers that do ;)

Yes, then the use case is perfectly clear.

Great to see these features getting offload support.
