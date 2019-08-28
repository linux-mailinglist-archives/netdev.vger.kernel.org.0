Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C31F9FE5B
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 11:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfH1JV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 05:21:59 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:45348 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfH1JV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 05:21:58 -0400
Received: by mail-ua1-f68.google.com with SMTP id j6so583823uae.12;
        Wed, 28 Aug 2019 02:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zeW2EB44SqLEQGsY2YylFGSCLe2d8d3xyY+7YXzj+uQ=;
        b=hlrwu8/VWPKnAzvYARwUQCB8VjdMpH9Lspg7iRQW8aFjCIvAIhUAvszDuBzJfhC2td
         1vvgpOYxY7+z67ftLvVtHmTU0T0Y0Q3WqpOcRmhSlJ8p7MBH38IvmuT2/7HCWx11Eigy
         x8h7b7SJFQS9XgiSdL4ZuVq300g7MoG3DbKBFr7XIJQTbh2IlOyZBrLmF7r7YvA+WdWu
         BxQPqe36ZMIlSsf7NvWYw30y1K58nrMCX+Gp+sMkrDGYpW5iczkVMllyF05r3K/xSYNW
         x/5wZ4TUtg6+tUp5wj4hF+SR09RkhRjYgufcZ7+c6+0EJ0RKIkGwQHaUTmCxTbNY1FL0
         nIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zeW2EB44SqLEQGsY2YylFGSCLe2d8d3xyY+7YXzj+uQ=;
        b=gHeQea+b83rPRHwscbb5j9OSouHdZqExIcUFp0j32ywES3HptP5dq5sy8ImgDkXnyl
         fr+zQcRgxsY74zIghCjAUJSktXOGNtk+pVORBp8YNg7G0B0TdfqlYN1yEGHwklMtQeWq
         TJJ95qrrlP/X7Vs3042gVVYrbdf9OsVko4LPpf/Ah9M/9A6bbix0Xe66bSTSo9MO0zjR
         5zxry0ADVcUBrCg+BCJDW6qIFRaIobMBU+dJOUFR/LY9PIrOKP5zg+Ns5qhKqH7MOrx/
         HPeWVCZbLCfGVnp6IZYnSH/L8xhRy3mMmKCeb1JH9A4KODzJma55Fi3u4d5ygTY2XNH9
         W3kw==
X-Gm-Message-State: APjAAAXGV446e7c/RMvpqkSxiSfZIA6CmSakc7xyIbA+mNUfYPRoMo52
        2qhfJImGv8GouPiWRfZE899Q4sXvAVWnAjvbsg==
X-Google-Smtp-Source: APXvYqzCxk7EIboUwXdSq620XqQCoUQFnLvsEU4Ye7ehdepvLa4J+O5uXFRFQcXznzbD8jl5mMX0k7oO5Wsx72L/rkg=
X-Received: by 2002:ab0:702b:: with SMTP id u11mr1405270ual.0.1566984117577;
 Wed, 28 Aug 2019 02:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190730122534.30687-1-rdong.ge@gmail.com> <20190730123542.zrsrfvcy7t2n3d4g@breakpoint.cc>
 <nycvar.YFH.7.76.1908260955400.22383@n3.vanv.qr>
In-Reply-To: <nycvar.YFH.7.76.1908260955400.22383@n3.vanv.qr>
From:   Rundong Ge <rdong.ge@gmail.com>
Date:   Wed, 28 Aug 2019 17:21:46 +0800
Message-ID: <CAN1Lvyp=pmu4KYbwb9sHcPyc0WXjOfb-JZspizDn1S=Uiu3rbQ@mail.gmail.com>
Subject: Re: [PATCH] bridge:fragmented packets dropped by bridge
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> =E4=BA=8E2019=E5=B9=B48=E6=9C=8826=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:59=E5=86=99=E9=81=93=EF=BC=9A
>
>
> On Tuesday 2019-07-30 14:35, Florian Westphal wrote:
> >Rundong Ge <rdong.ge@gmail.com> wrote:
> >> Given following setup:
> >> -modprobe br_netfilter
> >> -echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
> >> -brctl addbr br0
> >> -brctl addif br0 enp2s0
> >> -brctl addif br0 enp3s0
> >> -brctl addif br0 enp6s0
> >> -ifconfig enp2s0 mtu 1300
> >> -ifconfig enp3s0 mtu 1500
> >> -ifconfig enp6s0 mtu 1500
> >> -ifconfig br0 up
> >>
> >>                  multi-port
> >> mtu1500 - mtu1500|bridge|1500 - mtu1500
> >>   A                  |            B
> >>                    mtu1300
> >
> >How can a bridge forward a frame from A/B to mtu1300?
>
> There might be a misunderstanding here judging from the shortness of this
> thread.
>
> I understood it such that the bridge ports (eth0,eth1) have MTU 1500, yet=
 br0
> (in essence the third bridge port if you so wish) itself has MTU 1300.
>
> Therefore, frame forwarding from eth0 to eth1 should succeed, since the
> 1300-byte MTU is only relevant if the bridge decides the packet needs to =
be
> locally delivered.

Under this setup when I do "ping B -l 2000" from A, the fragmented
packets will be dropped by bridge.
When the "/proc/sys/net/bridge/bridge-nf-call-iptables" is on, bridge
will do defragment at PREROUTING and re-fragment at POSTROUTING. At
the re-fragment bridge will check if the max frag size is larger than
the bridge's MTU in  br_nf_ip_fragment(), if it is true packets will
be dropped.
And this patch use the outdev's MTU instead of the bridge's MTU to do
the br_nf_ip_fragment.
