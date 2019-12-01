Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF3110E276
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 17:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLAQIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 11:08:52 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34609 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfLAQIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 11:08:52 -0500
Received: by mail-lj1-f193.google.com with SMTP id m6so29716950ljc.1
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 08:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HTD6aronNCdCD7qHhgAfdfCUPrJAiC2jwBZ5D7UvO0k=;
        b=rFcBhMhlzR8VDgss9t6DKBYaq1dgypqZ/EhzbO1SBVDtKcwJOQl73ikQBmzUd6Db56
         m5DttyKeznfh/MeumFXHBycoOXTlwl29l5eiYM0Q9LF63Ppp9p4YoDB7DF7XRkFQSd/d
         McIjoDN2eHXVxeUl4EwjUOfJNFZuTPgHAAdNydDy0Qkl28zcPjXkhkDDhT4P9UufJB4P
         GOXmRksA/K5h2eqpwKZsftQxDtMYBMV765TsQHr/nGgcv7CK5LXNJspTtHZEofJdZSZT
         loUMOeHfnVIwQvZVmlvExCHsu6GcWZRzsvtpOZ/Vk/0wr+cGA2tPh8y1AAnuH/yhXQZ5
         5Fkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HTD6aronNCdCD7qHhgAfdfCUPrJAiC2jwBZ5D7UvO0k=;
        b=ZqKUMSflNcLi5W8mWkQxOW2v5OkwOFB8cTOchK7BhktxrBulV3sEN6V7POYSaVeZU/
         /zW53sniF2vrj8xsPgZr5KVCXtPGLRQd3SoVigUSLpXaCi4INY/osCKQoaLqOX1V5V5w
         kBkOgLg/jfO8VtL316HmCfS+5CNn5tO7bT78Zv24ctuDdRa+w27LY7MBK5u7mGI5Sk2Z
         3jkic9jaPWQVDKLmD4Y6B4buYYBXT3WM7+T8JRufJ6TF6TJzjiPimQ43OuMKuwTM1Klm
         T0ISy7PKOdQKqbWdDKquMaE+pCuKGl8vT8xSMmROWoGbLFM8VD6s1A+n+V1nBsFIi8zj
         hOpA==
X-Gm-Message-State: APjAAAU+Uiqjc2mytHg0HNXI5pp17HxAMcomSron27GxIrq91nT9CMtv
        RhQBCVsDbu9C2VcVbVUqk5mxwyGk8D6ddy2r8ts9ghxG
X-Google-Smtp-Source: APXvYqxMqytW083+z0sarIh2yOF/0GmkjV/lHBeEPnEhk0nO4wQfdjw7AwKH2bRlB4vwfPYAepn4dCE1pxZrNnzUGfM=
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr696040ljk.201.1575216530153;
 Sun, 01 Dec 2019 08:08:50 -0800 (PST)
MIME-Version: 1.0
References: <20191130142400.3930-1-ap420073@gmail.com> <CAM_iQpWmwreeCuOVnTTucHcXkmLP-QRtzW22_g6QWM2-QoS5WA@mail.gmail.com>
 <CAM_iQpWYrFx-NbnHpHWmVaf7AoF3Zvi1s6i0Egsf7Ct064X0Xw@mail.gmail.com>
In-Reply-To: <CAM_iQpWYrFx-NbnHpHWmVaf7AoF3Zvi1s6i0Egsf7Ct064X0Xw@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 2 Dec 2019 01:08:38 +0900
Message-ID: <CAMArcTXO1Nd6g+3a=R83fFq=tWxbRdR25NAg92mrUUdYVkDsyw@mail.gmail.com>
Subject: Re: [net PATCH] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        treeze.taeung@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Dec 2019 at 06:04, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sat, Nov 30, 2019 at 10:35 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > Test commands:
> > >     ip netns add nst
> > >     ip link add v0 type veth peer name v1
> > >     ip link add v2 type veth peer name v3
> > >     ip link set v1 netns nst
> > >     ip link set v3 netns nst
> > >     ip link add hsr0 type hsr slave1 v0 slave2 v2
> > >     ip a a 192.168.100.1/24 dev hsr0
> > >     ip link set v0 up
> > >     ip link set v2 up
> > >     ip link set hsr0 up
> > >     ip netns exec nst ip link add hsr1 type hsr slave1 v1 slave2 v3
> > >     ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
> > >     ip netns exec nst ip link set v1 up
> > >     ip netns exec nst ip link set v3 up
> > >     ip netns exec nst ip link set hsr1 up
> > >     hping3 192.168.100.2 -2 --flood &
> > >     modprobe -rv hsr
> >
> > Looks like the master port got deleted without respecting RCU
> > readers, let me look into it.
>
>
> It seems hsr_del_port() gets called on module removal path too
> and we delete the master port before waiting for RCU readers
> there.

The path is this.
hsr_exit() -> unregister_netdevice_notifier() -> hsr_netdev_notify()
 -> hsr_del_port().

>
> Does the following patch help anything? It just moves the list_del_rcu()
> after synchronize_rcu() only for master port.
>

Thank you so much for providing the testing code.
I have tested this patch, but I could still see the same panic.

> diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
> index ee561297d8a7..c9638ee00d20 100644
> --- a/net/hsr/hsr_slave.c
> +++ b/net/hsr/hsr_slave.c
> @@ -174,9 +174,9 @@ void hsr_del_port(struct hsr_port *port)
>
>         hsr = port->hsr;
>         master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
> -       list_del_rcu(&port->port_list);
>
>         if (port != master) {
> +               list_del_rcu(&port->port_list);
>                 if (master) {
>                         netdev_update_features(master->dev);
>                         dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
> @@ -193,5 +193,7 @@ void hsr_del_port(struct hsr_port *port)
>
>         if (port != master)
>                 dev_put(port->dev);
> +       else
> +               list_del_rcu(&port->port_list);
>         kfree(port);
>  }
