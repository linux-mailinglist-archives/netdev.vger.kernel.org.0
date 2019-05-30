Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E64304FF
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfE3Wwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:52:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37111 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfE3Www (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:52:52 -0400
Received: by mail-io1-f66.google.com with SMTP id e5so6573514iok.4;
        Thu, 30 May 2019 15:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WqRv1eYw87mitTUNX+jAkK8xXVXgILIBliBYFvqQpD4=;
        b=I8iFh+NzZRRRmN4wFokO7NUD8Nl70epcfUqFJXm0ax32zPrw0fbtQOXpjJ+ASVFPop
         rcyFRKUAtpL1Qn/JL0/w3QO8aZWmlwtrrmoHAP8P+PcK+8o71mx1iAlsmbb6rkw5Twie
         Q9ebWpONgW+g62jc7oJYbYF5+i/5BHNbKv886LuIw2DA/cuMmYoWGv0hDlZw76TzLUM0
         qFN/dK79vIwfYGjca79Bjkf1SfES+/eyyyERts9sYN7PoCbhV0gzMaIE4EzPo9JoZm8c
         jrQa2yJqVtZHH83foz663BibaVn9KLPy96H7Y1/6xB2mgQRaPEdJzb74o6qO1r8D7Mmm
         zVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WqRv1eYw87mitTUNX+jAkK8xXVXgILIBliBYFvqQpD4=;
        b=NjmnMyiXTeKZzV5WH99kny2sNVsnvnRq4nIsnk25Fkkvyk7nR/7me4mqdk2Vmp5SXo
         Hue6hm/UvPAtyaZqPpD6FhgIWOdDKa/CjKaOigRljuJX6oQCrhbcKtLZTdCbhWhuV7uc
         4G0j/XCqRwstegWxwpd8KLxbM8OUaDM2DughpCH/jw3Y1wy73rKbv+VFtyBqc4H76DDD
         bzqilDVl7x8VKQs3+77vZsyH64z9Zr7SgEddG05JeA6SG055smkzNv6azpXhpb1gL01Z
         8XzRd3fdGd109kv31KjVUIFW66zhABxqSjAp6OMgc2PLokFzGzMkxh6GKo12+DmyFQTD
         9RwA==
X-Gm-Message-State: APjAAAXoeYzEUFtx3I/xQOhC6Gh5fcLhPkFf1zLtB+UmPWrG1RgUW63z
        ShMWDigcIYzL+pI+7yFcAiz55BjK7tszN58Naag=
X-Google-Smtp-Source: APXvYqw21dbtGqaaBiNIsp5/5TmlV3uYnegrqAHgYw+u67wKWL83EtBiw3w4VYHNeNegwbc0gky4NnkC9v56bjEY488=
X-Received: by 2002:a5e:8b41:: with SMTP id z1mr164559iom.42.1559256770970;
 Thu, 30 May 2019 15:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <e070e241-fb65-a5b0-3155-7380a9203bcf@molgen.mpg.de>
 <8627ea1e-8e51-c425-97f6-aeb57176e11a@gmail.com> <eb730f01-0c6d-0589-36cc-7193d64c1ee8@molgen.mpg.de>
 <CANn89i+VvwMaHy2Br-0CcC3gPQ+PmG3Urpn4KpqL0P7XBykmcw@mail.gmail.com> <20190529093548.3df7ee73@hermes.lan>
In-Reply-To: <20190529093548.3df7ee73@hermes.lan>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 30 May 2019 15:52:40 -0700
Message-ID: <CAKgT0UdWmu3GjeMd9jmA=5FGQ=5cLnFb51arf+zkX7omc-G1fg@mail.gmail.com>
Subject: Re: Driver has suspect GRO implementation, TCP performance may be compromised.
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 9:38 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Wed, 29 May 2019 09:00:54 -0700
> Eric Dumazet <edumazet@google.com> wrote:
>
> > On Wed, May 29, 2019 at 7:49 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> > >
> > > Dear Eric,
> > >
> > >
> > > Thank you for the quick reply.
> > >
> > > On 05/28/19 19:18, Eric Dumazet wrote:
> > > > On 5/28/19 8:42 AM, Paul Menzel wrote:
> > >
> > > >> Occasionally, Linux outputs the message below on the workstation Dell
> > > >> OptiPlex 5040 MT.
> > > >>
> > > >>     TCP: net00: Driver has suspect GRO implementation, TCP performance may be compromised.
> > > >>
> > > >> Linux 4.14.55 and Linux 5.2-rc2 show the message, and the WWW also
> > > >> gives some hits [1][2].
> > > >>
> > > >> ```
> > > >> $ sudo ethtool -i net00
> > > >> driver: e1000e
> > > >> version: 3.2.6-k
> > > >> firmware-version: 0.8-4
> > > >> expansion-rom-version:
> > > >> bus-info: 0000:00:1f.6
> > > >> supports-statistics: yes
> > > >> supports-test: yes
> > > >> supports-eeprom-access: yes
> > > >> supports-register-dump: yes
> > > >> supports-priv-flags: no
> > > >> ```
> > > >>
> > > >> Can the driver e1000e be improved?
> > > >>
> > > >> Any idea, what triggers this, as I do not see it every boot? Download
> > > >> of big files?
> > > >>
> > > > Maybe the driver/NIC can receive frames bigger than MTU, although this would be strange.
> > > >
> > > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > > index c61edd023b352123e2a77465782e0d32689e96b0..cb0194f66125bcba427e6e7e3cacf0c93040ef61 100644
> > > > --- a/net/ipv4/tcp_input.c
> > > > +++ b/net/ipv4/tcp_input.c
> > > > @@ -150,8 +150,10 @@ static void tcp_gro_dev_warn(struct sock *sk, const struct sk_buff *skb,
> > > >                 rcu_read_lock();
> > > >                 dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
> > > >                 if (!dev || len >= dev->mtu)
> > > > -                       pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised.\n",
> > > > -                               dev ? dev->name : "Unknown driver");
> > > > +                       pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised."
> > > > +                               " len %u mtu %u\n",
> > > > +                               dev ? dev->name : "Unknown driver",
> > > > +                               len, dev ? dev->mtu : 0);
> > > >                 rcu_read_unlock();
> > > >         }
> > > >  }
> > >
> > > I applied your patch on commit 9fb67d643 (Merge tag 'pinctrl-v5.2-2' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl):
> > >
> > >      [ 5507.291769] TCP: net00: Driver has suspect GRO implementation, TCP performance may be compromised. len 1856 mtu 1500
> >
> >
> > The 'GRO' in the warning can be probably ignored, since this NIC does
> > not implement its own GRO.
> >
> > You can confirm this with this debug patch:
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c
> > b/drivers/net/ethernet/intel/e1000e/netdev.c
> > index 0e09bede42a2bd2c912366a68863a52a22def8ee..014a43ce77e09664bda0568dd118064b006acd67
> > 100644
> > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> > @@ -561,6 +561,9 @@ static void e1000_receive_skb(struct e1000_adapter *adapter,
> >         if (staterr & E1000_RXD_STAT_VP)
> >                 __vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tag);
> >
> > +       if (skb->len > netdev->mtu)
> > +               pr_err_ratelimited("received packet bigger (%u) than
> > MTU (%u)\n",
> > +                                  skb->len, netdev->mtu);
> >         napi_gro_receive(&adapter->napi, skb);
> >  }
>
> I think e1000 is one of those devices that only has receive limit as power of 2.
> Therefore frames up to 2K can be received.
>
> There always some confusion in Linux about whether MTU is transmit only or devices
> have to enforce it on receive.

Actually I think there are some parts that don't have any receive
limits that are supported by the e1000 part. What ends up happening is
that we only drop the packet if it spans more than one buffer if I
recall correctly, and buffer size is determined by MTU.

I always thought MTU only applied to transmit since it is kind of in
the name. As a result I am pretty sure igb and ixgbe will be able to
trigger this warning under certain circumstances as well. Also what
about the case where someone sets the MTU to less than 1500? I think
most NICs probably don't update their limits in such a case and
wouldn't it also trigger a similar error?
