Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAD47AA22
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfG3NuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:50:18 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:41184 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfG3NuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 09:50:18 -0400
Received: by mail-ua1-f65.google.com with SMTP id 34so25465464uar.8;
        Tue, 30 Jul 2019 06:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4+QxDKECEbt2nsi9n15vlp6tEfk79Z3ydNqFgvycDug=;
        b=lbbXElZcWDWcO7idRfKRT150JkbaE34ZAm5/7WQDWq5VmH58byLnlTttxLjULzGnHi
         juIjzfAjttSH+39RkV37/FitX0rPvUZjgqNlP8vrm00v0kNql78LyEheKW1AkIAmz4Hr
         etUy5fge2yzDyv/fLs3IIaWr4M7LBfGOQVr8BtCESNX+Do6SoDJ2tS0KgeYravub+ozp
         yHOS4INVM3CYGw8okECC5dy8I41Sk1AAsWaLM2PXz3FctBuH69ARB5Ddof1scefU7Gy3
         TODHQ18+YhCJHQC2eSWwGl8MvutnGGuJaIIW9IOdwVbIQkc2oZQz5ap0aAEhFV5qTgRj
         CuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4+QxDKECEbt2nsi9n15vlp6tEfk79Z3ydNqFgvycDug=;
        b=bCkG3t0qhhGwo5nOfK7XhY3XEnWBObuO5n/TsGojmBZDy4REDTO5o0rQxEsXOmKrbF
         cU7swAePAy/LRxb/cTYyRVbKqyyfwDtHNQzeSr/+xC/F+emFKB0K5B/vfAuC+pRRFxjA
         zCPglN+1zb5734xB/OUJbxFzbmX0He2Klbmp0nL9s9m4q21THsnyuomn6Mk23rii5lLG
         WvadAX3CEz209ZSBhTxsmwRr64bMtyMkXn8S8qT31mSsnXdOssFyN85QaTGxLFFu/U0Z
         Dote48J2WDj07hXUH0I0vItolS2kKHpUppPqlX1Uf3G8e8PDLm+4+d+paNOqvQjkU5DW
         qzGg==
X-Gm-Message-State: APjAAAXpBFZaWtvtAJNqgnpNhgqxV259JzQPxApWoMQ3G4yHn38Z7ymE
        Mu1/tsWDo5Kc346pLsDcealx6zusn3yVe5rsaw==
X-Google-Smtp-Source: APXvYqwkEJHqOLjuHTIoafDnOdIKrNbWPnbKSBkEO5P9hTVRtqu55CQkZC42IGzFpiT946+GSGCaYc2eG93E6sWtO0s=
X-Received: by 2002:a9f:25e9:: with SMTP id 96mr57807432uaf.95.1564494616946;
 Tue, 30 Jul 2019 06:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190730122534.30687-1-rdong.ge@gmail.com> <20190730123542.zrsrfvcy7t2n3d4g@breakpoint.cc>
In-Reply-To: <20190730123542.zrsrfvcy7t2n3d4g@breakpoint.cc>
From:   Rundong Ge <rdong.ge@gmail.com>
Date:   Tue, 30 Jul 2019 21:50:05 +0800
Message-ID: <CAN1LvyqtbzycEggoCXaBu3Zf_jebTWLBXm3js6+r60274a61Tg@mail.gmail.com>
Subject: Re: [PATCH] bridge:fragmented packets dropped by bridge
To:     Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, nikolay@cumulusnetworks.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> How can a bridge forward a frame from A/B to mtu1300?
It is free for user to set different MTU for bridge ports. In our case
only tcp traffic between A/B and mtu 1300, and mss negotiation can
make packets less than 1300.

> What happens without netfilter or non-fragmented packets?
Without br_netfilter it works fine, there is no defragmentation and
refragmentation, fragmented packets will egress directly.

Florian Westphal <fw@strlen.de> =E4=BA=8E2019=E5=B9=B47=E6=9C=8830=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=888:35=E5=86=99=E9=81=93=EF=BC=9A
>
> Rundong Ge <rdong.ge@gmail.com> wrote:
> > Given following setup:
> > -modprobe br_netfilter
> > -echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
> > -brctl addbr br0
> > -brctl addif br0 enp2s0
> > -brctl addif br0 enp3s0
> > -brctl addif br0 enp6s0
> > -ifconfig enp2s0 mtu 1300
> > -ifconfig enp3s0 mtu 1500
> > -ifconfig enp6s0 mtu 1500
> > -ifconfig br0 up
> >
> >                  multi-port
> > mtu1500 - mtu1500|bridge|1500 - mtu1500
> >   A                  |            B
> >                    mtu1300
>
> How can a bridge forward a frame from A/B to mtu1300?
>
> > With netfilter defragmentation/conntrack enabled, fragmented
> > packets from A will be defragmented in prerouting, and refragmented
> > at postrouting.
>
> Yes, but I don't see how that relates to the problem at hand.
>
> > But in this scenario the bridge found the frag_max_size(1500) is
> > larger than the dst mtu stored in the fake_rtable whitch is
> > always equal to the bridge's mtu 1300, then packets will be dopped.
>
> What happens without netfilter or non-fragmented packets?
>
> > This modifies ip_skb_dst_mtu to use the out dev's mtu instead
> > of bridge's mtu in bridge refragment.
>
> It seems quite a hack?  The above setup should use a router, not a bridge=
.
