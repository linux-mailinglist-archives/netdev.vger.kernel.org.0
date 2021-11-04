Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82E5444CFE
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 02:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhKDBeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhKDBeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 21:34:17 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7E8C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 18:31:39 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w1so15904884edd.10
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 18:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=inuB0cA+b6rMJZ9fCUrhBQXGivicIyoQjs+DljlV4SM=;
        b=HmqMAvD4lAkiG8eEQrSfWb2EG+9ESWc5x8n2gz03amTS8Nu3/jQrUbOylOIvIHWuwR
         A31XOC8hExeaDSYDRxIPDI2skmBZYWxku5huJNEYkg2K9FhrxAYIDEPalbp15fEu+Tul
         L5JtsX0xbhdcZO8zbVRMC3UBVQhJk3Hpp3ZXmP95MjV3IWJ6C7GZZJOqdsa8rfU4mnLS
         XGa5cg0Y5jgYKFibvObVM1sr0SmFM+0h24TdlDDp4k/A3MQ9AiOFsfJcRftyqx3QuK0k
         QSSs182nUqaJnXsC2riIZR41e91iPyxRAo1TwmuyMGI9IX6DmUrLYghRMOkJiD19yj2E
         Nvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=inuB0cA+b6rMJZ9fCUrhBQXGivicIyoQjs+DljlV4SM=;
        b=c3u30D3RchyRH4uaheHcpwMEo/LlX7Sg8Xj9bLe0YPBD+soI8fTosUwH7jblQj8VHQ
         a224OGE1Qw9CfRhHxC1V3IcUgDLKJOr9KBtPm+DjcWZUFgrz91MhjHXvGMCCptPtp5vo
         OlYIq+x3bXPAlusIe1Yq2+AAZtaKFPe4Iz31UcCN+b8zJKIn6hyKnztlPNOU8WVtQQmO
         0t8tggBeMJHCcY59uCFCZfE6nwtH9BhfXujhtEltIJYmny39rK3roXRlzS+RtAoxzKsz
         Fj5gkzRGndjHM87YbEXqt2qaZ3Mx+TwWt4Akpa7hBEeANGFFWTrQ+bGWnoiVr+kUYBBT
         gEjQ==
X-Gm-Message-State: AOAM533S3/CNMgoMXm+lVzZ0B/4/DpIj4IOn71k/YELwPJd7pqWkjQYW
        Q+9rkbCfwutv+ehJKrHQ0ya8lkmH9S26KYAQr7JiGAyKxydGijW6
X-Google-Smtp-Source: ABdhPJz7jKb9ue9eLcldQRzjXuZNVjvjNNK7JD9dMPpMYQdbBXeehpiM4Qwj+UR7X9Gi6/VvRXmHZxOaxg2eC4a0ePc=
X-Received: by 2002:aa7:c941:: with SMTP id h1mr67006973edt.128.1635989497833;
 Wed, 03 Nov 2021 18:31:37 -0700 (PDT)
MIME-Version: 1.0
References: <20211029015431.32516-1-xiangxia.m.yue@gmail.com>
 <9deda78a-a9a2-6b0b-634d-07c5b77282a8@iogearbox.net> <CAMDZJNWOvRgaWE38WfBOmKuWyaysNB6OYaQNQeLNNJPw1AVDWQ@mail.gmail.com>
In-Reply-To: <CAMDZJNWOvRgaWE38WfBOmKuWyaysNB6OYaQNQeLNNJPw1AVDWQ@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 4 Nov 2021 09:31:01 +0800
Message-ID: <CAMDZJNUvdk+hLvciYdOAsdpCzRG=j-7HrR5sDv0agTS+ehVkeQ@mail.gmail.com>
Subject: Re: [PATCH] net: core: set skb useful vars in __bpf_tx_skb
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 9:58 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Tue, Nov 2, 2021 at 5:46 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 10/29/21 3:54 AM, xiangxia.m.yue@gmail.com wrote:
> > [...]
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 4bace37a6a44..2dbff0944768 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -2107,9 +2107,19 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
> > >               return -ENETDOWN;
> > >       }
> > >
> > > -     skb->dev = dev;
> > > +     /* The target netdevice (e.g. ifb) may use the:
> > > +      * - skb_iif
> > > +      * - redirected
> > > +      * - from_ingress
> > > +      */
> > > +     skb->skb_iif = skb->dev->ifindex;
> >
> > This doesn't look right to me to set it unconditionally in tx path, isn't ifb_ri_tasklet()
> > setting skb->skb_iif in this case (or __netif_receive_skb_core() in main rx path)?
> Hi
> the act_mirred set the skb->skb_iif, redirected and from_ingress. and
> __netif_receive_skb_core also set skb->skb_iif.
> so we can use the act_mirred to ifb in ingress or egress path.
> For ingress, when we use the bpf_redirct to ifb, we should set
> redirected, and from_ingress.
> For egress, when we use the bpf_redirct to ifb, we should skb_iif ,
> set redirected, and from_ingress.
Hi Daniel,
because we don't know bpf_redirct invoked in tx path, or rx path.
can we set the  skb->skb_iif unconditionally in bpf_redirct? any thoughts?

> > Also, I would suggest to add a proper BPF selftest which outlines the issue you're solving
> > in here.
> Ok, thanks.
> > > +#ifdef CONFIG_NET_CLS_ACT
> > > +     skb_set_redirected(skb, skb->tc_at_ingress);
> > > +#else
> > >       skb->tstamp = 0;
> > > +#endif
> > >
> > > +     skb->dev = dev;
> > >       dev_xmit_recursion_inc();
> > >       ret = dev_queue_xmit(skb);
> > >       dev_xmit_recursion_dec();
> > >
> >
>
>
> --
> Best regards, Tonghao



-- 
Best regards, Tonghao
