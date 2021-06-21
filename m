Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC993AF5CB
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhFUTHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbhFUTHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 15:07:18 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CBAC061574;
        Mon, 21 Jun 2021 12:05:02 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i1so4909635lfe.6;
        Mon, 21 Jun 2021 12:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iMUzOrcOG3tdgHxs2HmPtt+/y5jqdKzawVgcKyiIepI=;
        b=Lh32j56ifmSklJcK4qz0WGcjtkeiuXBuADUAdNNk3neWxuJ48fZ687Sc2J5KZKUbmA
         8rW7XSZwxpKVc/cUWogeK0YOmgdiQl4RsAY6hMIp938/PF0A4HCrba+YPW06gnzQ83to
         8A90Uu6S1pNhzwMDXPwv/+4UUd+aVe1BFdYwcbGDrFNtt35OYt/dNjrHN0NxmTdLgUDP
         lVzXnmGaI5sgaPNiZZSSqJbKnq9SWF9n4g8al3TYDo3xVs82Dv2P2d1uPmttfQdi1NDh
         /IDexi2n2FlUsujg6pJ7gk8DSf/FXKIXP36+UR84Dej6xjQuwIZNjxw3Hmy6wFdYqZH4
         KshA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iMUzOrcOG3tdgHxs2HmPtt+/y5jqdKzawVgcKyiIepI=;
        b=kUCf4btuqZ4Ohz3CYhKwrQkaZjMKYpoRzbIDNqqv0w/FsNA2oF6okIVKA62XHYl4es
         +5QcKjZgYFvrbV+gvXmLRPWC7D13IyP7iVF+DI5ZGOtCqfLL6IhFzHjXCjUaq7O4YGxf
         l0JVwNKjWUAgaVpprK3SNW4OvW0XppNZ4UQ/qH3u5bowhq4FlJCSqqZSjQnpcz/wenFE
         KlyIv6Hs/EZ6HdyPtnZTUHTBRtJuC4Dn6abHlfmu1DhVp5oM/ji67Y99nwk+ZgZOmOjI
         LUSBGNEk4g/mV4QrEdUgUQZdc3yGb1+cMdOUZWVCk3IpRUwA0cbggIyepQYtp+jyyh2H
         QlCQ==
X-Gm-Message-State: AOAM5309XZy2MdRLldSQsF81dtbJ4O/VsU7EQDk5FMwHBgjdQDvTRKPB
        djJJpiZwvD1zHmlHEDuB6sY=
X-Google-Smtp-Source: ABdhPJz9oTSoGJAhFPoAG5FraEJi6qloYSNa6yEkMQA+chs/22nNp4OXU0yeSlbx6eAhUplK9+eNmg==
X-Received: by 2002:ac2:499d:: with SMTP id f29mr10743025lfl.602.1624302300409;
        Mon, 21 Jun 2021 12:05:00 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id w8sm641420lfq.27.2021.06.21.12.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 12:05:00 -0700 (PDT)
Date:   Mon, 21 Jun 2021 22:04:54 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Guvenc Gulce <guvenc@linux.ibm.com>
Cc:     syzbot <syzbot+5dda108b672b54141857@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, kadlec@netfilter.org, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Subject: Re: [syzbot] general protection fault in smc_tx_sendmsg
Message-ID: <20210621220454.1c4a61d2@gmail.com>
In-Reply-To: <c8fd3740-8233-2b14-1fc9-57ecebc31ad8@linux.ibm.com>
References: <000000000000d154d905c53ad34d@google.com>
        <20210621175603.40ac6eaa@gmail.com>
        <c8fd3740-8233-2b14-1fc9-57ecebc31ad8@linux.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Jun 2021 19:18:56 +0200
Guvenc Gulce <guvenc@linux.ibm.com> wrote:

>=20
>=20
> On 21/06/2021 16:56, Pavel Skripkin wrote:
> > On Sun, 20 Jun 2021 16:22:16 -0700
> > syzbot <syzbot+5dda108b672b54141857@syzkaller.appspotmail.com>
> > wrote:
> >
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    0c337952 Merge tag
> >> 'wireless-drivers-next-2021-06-16' of g.. git tree:       net-next
> >> console output:
> >> https://syzkaller.appspot.com/x/log.txt?x=3D1621de10300000 kernel
> >> config:  https://syzkaller.appspot.com/x/.config?x=3Da6380da8984033f1
> >> dashboard link:
> >> https://syzkaller.appspot.com/bug?extid=3D5dda108b672b54141857 syz
> >> repro:
> >> https://syzkaller.appspot.com/x/repro.syz?x=3D121d2d20300000 C
> >> reproducer:
> >> https://syzkaller.appspot.com/x/repro.c?x=3D100bd768300000
> >>
> >> The issue was bisected to:
> >>
> >> commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
> >> Author: Florian Westphal <fw@strlen.de>
> >> Date:   Wed Apr 21 07:51:08 2021 +0000
> >>
> >>      netfilter: arp_tables: pass table pointer via nf_hook_ops
> >>
> > I think, bisection is wrong this time :)
> >
> > It should be e0e4b8fa533858532f1b9ea9c6a4660d09beb37a ("net/smc:
> > Add SMC statistics support")
> >
> >
> > Some debug results:
> >
> > syzkaller repro just opens the socket and calls sendmsg. Ftrace log:
> >
> >
> >   0)               |  smc_create() {
> >   0)               |    smc_sock_alloc() {
> >   0) + 88.493 us   |      smc_hash_sk();
> >   0) ! 131.487 us  |    }
> >   0) ! 189.912 us  |  }
> >   0)               |  smc_sendmsg() {
> >   0)   2.808 us    |    smc_tx_sendmsg();
> >   0) ! 148.484 us  |  }
> >
> >
> > That means, that smc_buf_create() wasn't called at all, so we need
> > to check sndbuf_desc before dereferencing
> >
> > Something like this should work
> >
> > diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> > index 075c4f4b4..e24071b12 100644
> > --- a/net/smc/smc_tx.c
> > +++ b/net/smc/smc_tx.c
> > @@ -154,7 +154,7 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct
> > msghdr *msg, size_t len) goto out_err;
> >   	}
> >  =20
> > -	if (len > conn->sndbuf_desc->len)
> > +	if (conn->sndbuf_desc && len > conn->sndbuf_desc->len)
> >   		SMC_STAT_RMB_TX_SIZE_SMALL(smc, !conn->lnk);
> >  =20
> >   	if (len > conn->peer_rmbe_size)
> >
> >
> > Thoughts?
> >
> >
> > +CC Guvenc Gulce
> >
> >
> > With regards,
> > Pavel Skripkin
>=20
> Thanks for analyzing the cause. Your approach would work but I would
> prefer that we check the state of the socket before doing the
> statistics relevant if check. This will ensure that smc_buf_create()
> was already called. I am testing the fix at the moment which would
> look like the following:
>=20

This sounds better. I knew, that my approach will just "silence" the
bug, that's why I CCed you for better approach :)

> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 075c4f4b41cf..289025cd545a 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -154,6 +154,9 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct
> msghdr *msg, size_t len) goto out_err;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sk->sk_state =3D=3D SMC_INIT)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return -ENOTCONN;
> +
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (len > conn->sndbuf_desc->=
len)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 SMC_STAT_RMB_TX_SIZE_SMALL(smc, !conn->lnk);
>=20
>=20




With regards,
Pavel Skripkin
