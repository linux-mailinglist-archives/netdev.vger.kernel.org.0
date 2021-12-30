Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D273481877
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhL3CUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbhL3CUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:20:24 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F8FC061574;
        Wed, 29 Dec 2021 18:20:23 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id x15so92767564edv.1;
        Wed, 29 Dec 2021 18:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hiEx9cUv2eMNzaWLRDEcUcL8OSIJpA5IG99OfRArXu8=;
        b=V4gKDpUZcyC/9VpK0cwWVTupek56v/K05xfnKOzQ+bD96Q1su291S1gbk7U2XUaKPS
         jcoJqPY9ztT7BjtKG/1kkWeeVKt4X7mVAl1oClBNv9cGT+hoMIZmqwlrI/FKQi10rYWe
         aRf0EKL2Fd+FvmrSe5OPh1UtisAcwu012fo+dXg58gmrCLYE6k7C0EbTBVXGJ7NhJAls
         2X90GegTqcYKCiu+Oik7/71sUwVg9fnYlCxocYeR+nTqIbCdWWspx1htE+D2x036fPN4
         aV47ZJYP4eN6czTwGGZv08GcyzwFyvg8ubzYDYyMCXwfmouHZXdHT7Hn5jp99pRUq0MY
         IB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hiEx9cUv2eMNzaWLRDEcUcL8OSIJpA5IG99OfRArXu8=;
        b=fofOcE33ZkTGDZp1yAL3CFCyBRSt84bEH+drKHuIl/sOpHVSFu514gfvZZ9kiKfnIr
         b0WWRF4Cia4/0cnqSignS1RLGGRdrGN+Ux1Y5lH3JB4tplNvVk4r26HPx4fQO/MT23V6
         th7/ZDvIbtH/XxaRXrwxivfXj3Aux2zw0dvtutPSEeFt4jxHNTzdZqeuMN+m5YCRjKlN
         QvuN4atkC+KYLKDN7tF/M78NVXsI4IFzJZ3OeM/IzzuOc3701RNwQ2b33vG7SI/JdW7K
         ouZdN1eQaEm451+PfpceWIUU2aCQxabEvqtuL2JbQW12GHWo8BrsbeBp0QBPlRDdg6eZ
         zfbA==
X-Gm-Message-State: AOAM532MMNx5CVxGqZk1TWZv4v9UNC99Qdj7FWfwOKrOMYvTxf8R6Bo4
        YCby+UrD/bSDpTOYaM+BptB6GVYxKYLcwmUWtRk=
X-Google-Smtp-Source: ABdhPJzEF0vetISaVS8USQar00SVVZb5xFxrEJyCn6tK2L1VaY/y08YFNOb4wOogYVHqHp8aZj9qBz852zOuCjM7/6Y=
X-Received: by 2002:a17:907:2da3:: with SMTP id gt35mr23678763ejc.704.1640830822347;
 Wed, 29 Dec 2021 18:20:22 -0800 (PST)
MIME-Version: 1.0
References: <20211227062035.3224982-1-imagedong@tencent.com> <20211229130927.2370f098@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211229130927.2370f098@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 30 Dec 2021 10:17:12 +0800
Message-ID: <CADxym3ZJPG8HxEXt6vTEeegCtZZRKjGWGJ_3rWjrzNijKBa-uQ@mail.gmail.com>
Subject: Re: [PATCH] net: bpf: handle return value of BPF_CGROUP_RUN_PROG_INET4_POST_BIND()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 5:09 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 27 Dec 2021 14:20:35 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > The return value of BPF_CGROUP_RUN_PROG_INET4_POST_BIND() in
> > __inet_bind() is not handled properly. While the return value
> > is non-zero, it will set inet_saddr and inet_rcv_saddr to 0 and
> > exit:
> >
> >       err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
> >       if (err) {
> >               inet->inet_saddr = inet->inet_rcv_saddr = 0;
> >               goto out_release_sock;
> >       }
> >
> > Let's take UDP for example and see what will happen. For UDP
> > socket, it will be added to 'udp_prot.h.udp_table->hash' and
> > 'udp_prot.h.udp_table->hash2' after the sk->sk_prot->get_port()
> > called success. If 'inet->inet_rcv_saddr' is specified here,
> > then 'sk' will be in the 'hslot2' of 'hash2' that it don't belong
> > to (because inet_saddr is changed to 0), and UDP packet received
> > will not be passed to this sock. If 'inet->inet_rcv_saddr' is not
> > specified here, the sock will work fine, as it can receive packet
> > properly, which is wired, as the 'bind()' is already failed.
> >
> > I'm not sure what should do here, maybe we should unhash the sock
> > for UDP? Therefor, user can try to bind another port?
>
> Enumarating the L4 unwind paths in L3 code seems like a fairly clear
> layering violation. A new callback to undo ->sk_prot->get_port() may
> be better.

Yeah, it seems there isn't an easier way to solve this problem, a new
callback is needed.

>
> Does IPv6 no need as similar change?
>

IPv6 nedd change too. This patch is just to get some suggestions :/

> You need to provide a selftest to validate the expected behavior.

I'll add it.

Thanks!
Menglong Dong

>
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 04067b249bf3..9e5710f40a39 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -530,7 +530,14 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
> >               if (!(flags & BIND_FROM_BPF)) {
> >                       err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
> >                       if (err) {
> > +                             if (sk->sk_prot == &udp_prot)
> > +                                     sk->sk_prot->unhash(sk);
> > +                             else if (sk->sk_prot == &tcp_prot)
> > +                                     inet_put_port(sk);
> > +
> >                               inet->inet_saddr = inet->inet_rcv_saddr = 0;
> > +                             err = -EPERM;
> > +
> >                               goto out_release_sock;
> >                       }
> >               }
>
