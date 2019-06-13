Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5319644BB4
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 21:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfFMTHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 15:07:38 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37352 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfFMTHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 15:07:38 -0400
Received: by mail-oi1-f196.google.com with SMTP id t76so170625oih.4;
        Thu, 13 Jun 2019 12:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gVMzjQLQqpf/QZtbz+QWdOL32d3AtsR0Mk6m6bcVxhQ=;
        b=oeDYYEnQD8BtRsIpw+UxvqdqjdOMmpi5OKZg2EWOiM77g1i/l9yeqSb9fQEav6Bpa3
         +A7ie7n+seZpkDZK+YCOS3lT+BhYVflmKL/IYQbkpg5kdUekiW1kSYxm1pxSwbzMI3/Q
         WwNvvtwHNzJPK5z6kYGAQKnH1X3XUrFiyAb1U9dP7DmvAu6+UmOweaQzzB1FJWymCcih
         5/+ZYECskmztALMGrsFnYQn9AA9fRdqXmisilQqd8uLJYSqLYj6vTjbVV8HTMGFLEQ5t
         lF4QDDFEV+zRmGjxoTVhPylms34sc/Azog/7IL7EGnobpzSQndcbus5sYwa4BCNvWnP2
         z2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gVMzjQLQqpf/QZtbz+QWdOL32d3AtsR0Mk6m6bcVxhQ=;
        b=emnXRyW/Aj/I0B03BDJjb7TetEjs/RJ1JvyX0kSNPJZMz4rDa8Dj5JziYdyTKzVWjn
         aElI0UAyjLNWjwzLHc91CwsCym+YPnJH4QRHpGJYVZ+7kEUuPwAmE2RR6snqMy6oHs3j
         SdiUzNFslRshNwSn+ukK+chMwrChBSd58AkdDqWj6wHfwdGC2XOZjL4pngjXkQaiKLaV
         jukN3ZkqnWukU7foqky8U3svbar7fPhxp6Nt8JtFYcNQeJGjGWcOdcEDhH/fYwGCq0Pk
         pJoNGjZfuft6ZTky9z1k6b1huuSddmA6N1OtTA7zpfCqwve6Jn7ymYsYAoJdRfXhBjFA
         U71Q==
X-Gm-Message-State: APjAAAX668UqphiE5oz18tBNLoVSIxLmIy+yLgVXuueWvYYb8wuKZWaM
        Mj2VInNFlCIr8gVgAf/rFoAnR9HBrEUmDbvgViw=
X-Google-Smtp-Source: APXvYqy7vf8KcrIRKPQuYh0e3GDnawVO2IByKOIxBiJs/qCE03bNbJljPJ1izbCdDJlEfQW8Yf9YVdKaFWMGG7JEe1c=
X-Received: by 2002:aca:cdd3:: with SMTP id d202mr3819686oig.115.1560452857649;
 Thu, 13 Jun 2019 12:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
 <1560411450-29121-3-git-send-email-magnus.karlsson@intel.com> <20190613120411.35ef3c52@cakuba.netronome.com>
In-Reply-To: <20190613120411.35ef3c52@cakuba.netronome.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 13 Jun 2019 21:07:26 +0200
Message-ID: <CAJ8uoz0jXyVt8OPOq+B8L7gEm8bbd8cE5vdf3-KAhaVK871k8w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] xsk: add support for need_wakeup flag in
 AF_XDP rings
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, Ye Xiaolong <xiaolong.ye@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        kevin.laatz@intel.com, ilias.apalodimas@linaro.org,
        Kiran <kiran.patil@intel.com>, axboe@kernel.dk,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 9:05 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 13 Jun 2019 09:37:26 +0200, Magnus Karlsson wrote:
> >
> > -     if (!dev->netdev_ops->ndo_bpf ||
> > -         !dev->netdev_ops->ndo_xsk_async_xmit) {
> > +     if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
> >               err = -EOPNOTSUPP;
> >               goto err_unreg_umem;
> >       }
>
> > @@ -198,7 +258,8 @@ static int xsk_zc_xmit(struct sock *sk)
> >       struct xdp_sock *xs = xdp_sk(sk);
> >       struct net_device *dev = xs->dev;
> >
> > -     return dev->netdev_ops->ndo_xsk_async_xmit(dev, xs->queue_id);
> > +     return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> > +                                            XDP_WAKEUP_TX);
> >  }
> >
> >  static void xsk_destruct_skb(struct sk_buff *skb)
>
> Those two look like they should be in the previous patch?  Won't it
> break build?

You are correct. That should have been in patch 1. Will fix that in the v2.

Thanks: Magnus
