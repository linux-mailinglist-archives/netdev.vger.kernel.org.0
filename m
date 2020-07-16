Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12ED9222C25
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgGPTry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgGPTrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:47:52 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D444EC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 12:47:51 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id z63so6703759qkb.8
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 12:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/PR6zgztlqaH91DO7+Z9FLMEGs2AS8POAd5VJ4SX1ek=;
        b=W+clyADfM2hCzGSQbYrPtwBZqVszcPBuZQgvaVq+58bNEcFDYoK5giEBEeI65KMIrW
         GK+rwJxW6b6NGkvNmmPUrnr5BBdBkZfBMh4nRWUc9+ZrbP2Mf42CNs4itABi9u4EkVCJ
         vgABfWqHS5UrbZsQM6zYyOc9zzbFbLS9Y1f8AUpDKJaeEnzjmfEvxw99G6pQhn3WV7AZ
         6teBGmnh4ifip3+R/DLZtKBgPWWjtUA1EdzdMEa5DNvJThkXCazDV8a3smM8zqCtLR3M
         2hyfPXgigP1HI/51Dj/5VfOlnTAAHCkGtRGff3p7x3+rBu4cTDcGPW93axv18RTqRmmC
         UzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/PR6zgztlqaH91DO7+Z9FLMEGs2AS8POAd5VJ4SX1ek=;
        b=aEmXnrH3Zwmpuv9W9gaG7hXpWdbvOkYNvbH2cc+fAzj4LUBdbezj4qJXsNHlWiGwmh
         A/tlzCKowI5LWygyF0Qydz0/HNSzzVU9kc7s6rAJPW3jm4ENfPB/ouuuKVX+h6Vy7bNQ
         8cKK1qvyK4MIWf2vatTzPxfKiMONFy9x7PXQQAx0SD57i97mqEcKUzpeBO0p+S2bT7pP
         0OKiyuU2yvifZ4OwB7HzN/LAGVRy59RUNg2/S8MOE4RrhW405N8FhNzTAOgy9aseDwO9
         nnSOYOfdGzRm0UMJeX1fVvlwuXtWJKS+zHTjZKbsnYnPSKHUtoT1AI4duyqyjg66eZCH
         3nnw==
X-Gm-Message-State: AOAM532Xe+smTYWoS3DB1PR/A8vLLgYd6nB+p4v80eXecwUQvsdP8+kd
        FtoD+VsDUzoYV/DMHF5akLBxYRySn2fzgchDHcwYQldoKZ8=
X-Google-Smtp-Source: ABdhPJymikPS4TFlaWOYYknSMlupIXrgsPAlfLh4fuV/IiUn/+DZuluLgA7lCI0Sq77/2s8FnI4ipeg7cpU1qqrHzBo=
X-Received: by 2002:ac8:346c:: with SMTP id v41mr7027577qtb.262.1594928869129;
 Thu, 16 Jul 2020 12:47:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
 <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
 <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA85sZu09Z4gydJ8rAO_Ey0zqx-8Lg28=fBJ=FxFnp6cetNd3g@mail.gmail.com>
 <CAA85sZtjCW2Yg+tXPgYyoFA5BKAVZC8kVKG=6SiR64c8ur8UcQ@mail.gmail.com>
 <20200715144017.47d06941@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA85sZvnytPzpia_ROnkmJoZC8n4vUsrwTQh2UBs6u6g2Fgqxw@mail.gmail.com>
 <CAKgT0UdwsmE=ygE2KObzM0z-0KgrPcr59JZzVk41F6-iqsSL+Q@mail.gmail.com>
 <CAA85sZturDN7uOHMDhUnntM43PHjop=TNDb4qvEA2L=jdRa1MA@mail.gmail.com>
 <CAKgT0Uf42EhnM+zPSb-oL1R8hmo0vEdssGztptbkWKoHXS7ygw@mail.gmail.com>
 <CAA85sZtHNkocj840i0ohMVekh0B4byuojU02UunK_bR+LB1WiQ@mail.gmail.com> <CAKgT0UdDjabvShwDv0qiume=Q2RKGkm3JhPMZ+f8v5yO37ZLxA@mail.gmail.com>
In-Reply-To: <CAKgT0UdDjabvShwDv0qiume=Q2RKGkm3JhPMZ+f8v5yO37ZLxA@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Thu, 16 Jul 2020 21:47:37 +0200
Message-ID: <CAA85sZt6B+rG8pUfRoNVOH=VqHn=rT-+2kHpFDzW+eBwvODxJA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] NAT performance issue 944mbit -> ~40mbit
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, tried to respond via the phone, used the webbrowser version but
still html mails... :/

On Thu, Jul 16, 2020 at 5:18 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
> On Wed, Jul 15, 2020 at 5:00 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > On Thu, Jul 16, 2020 at 1:42 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > > On Wed, Jul 15, 2020 at 3:51 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > > > On Thu, Jul 16, 2020 at 12:32 AM Alexander Duyck
> > > > <alexander.duyck@gmail.com> wrote:
> > > > > On Wed, Jul 15, 2020 at 3:00 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > > > > > On Wed, Jul 15, 2020 at 11:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > > > On Wed, 15 Jul 2020 23:12:23 +0200 Ian Kumlien wrote:
> > > > > > > > On Wed, Jul 15, 2020 at 11:02 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > > > > > > > > On Wed, Jul 15, 2020 at 10:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > > > > > > On Wed, 15 Jul 2020 22:05:58 +0200 Ian Kumlien wrote:
> > > > > > > > > > > After a  lot of debugging it turns out that the bug is in igb...
> > > > > > > > > > >
> > > > > > > > > > > driver: igb
> > > > > > > > > > > version: 5.6.0-k
> > > > > > > > > > > firmware-version:  0. 6-1
> > > > > > > > > > >
> > > > > > > > > > > 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network
> > > > > > > > > > > Connection (rev 03)
> > > > > > > > > >
> > > > > > > > > > Unclear to me what you're actually reporting. Is this a regression
> > > > > > > > > > after a kernel upgrade? Compared to no NAT?
> > > > > > > > >
> > > > > > > > > It only happens on "internet links"
> > > > > > > > >
> > > > > > > > > Lets say that A is client with ibg driver, B is a firewall running NAT
> > > > > > > > > with ixgbe drivers, C is another local node with igb and
> > > > > > > > > D is a remote node with a bridge backed by a bnx2 interface.
> > > > > > > > >
> > > > > > > > > A -> B -> C is ok (B and C is on the same switch)
> > > > > > > > >
> > > > > > > > > A -> B -> D -- 32-40mbit
> > > > > > > > >
> > > > > > > > > B -> D 944 mbit
> > > > > > > > > C -> D 944 mbit
> > > > > > > > >
> > > > > > > > > A' -> D ~933 mbit (A with realtek nic -- also link is not idle atm)
> > > > > > > >
> > > > > > > > This should of course be A' -> B -> D
> > > > > > > >
> > > > > > > > Sorry, I've been scratching my head for about a week...
> > > > > > >
> > > > > > > Hm, only thing that comes to mind if A' works reliably and A doesn't is
> > > > > > > that A has somehow broken TCP offloads. Could you try disabling things
> > > > > > > via ethtool -K and see if those settings make a difference?
> > > > > >
> > > > > > It's a bit hard since it works like this, turned tso off:
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > > > > [  5]   0.00-1.00   sec   108 MBytes   902 Mbits/sec    0    783 KBytes
> > > > > > [  5]   1.00-2.00   sec   110 MBytes   923 Mbits/sec   31    812 KBytes
> > > > > > [  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec   92    772 KBytes
> > > > > > [  5]   3.00-4.00   sec   110 MBytes   923 Mbits/sec    0    834 KBytes
> > > > > > [  5]   4.00-5.00   sec   111 MBytes   933 Mbits/sec   60    823 KBytes
> > > > > > [  5]   5.00-6.00   sec   110 MBytes   923 Mbits/sec   31    789 KBytes
> > > > > > [  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec    0    786 KBytes
> > > > > > [  5]   7.00-8.00   sec   110 MBytes   923 Mbits/sec    0    761 KBytes
> > > > > > [  5]   8.00-9.00   sec   110 MBytes   923 Mbits/sec    0    772 KBytes
> > > > > > [  5]   9.00-10.00  sec   109 MBytes   912 Mbits/sec    0    868 KBytes
> > > > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > > > [  5]   0.00-10.00  sec  1.07 GBytes   923 Mbits/sec  214             sender
> > > > > > [  5]   0.00-10.00  sec  1.07 GBytes   920 Mbits/sec                  receiver
> > > > > >
> > > > > > Continued running tests:
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > > > > [  5]   0.00-1.00   sec  5.82 MBytes  48.8 Mbits/sec    0   82.0 KBytes
> > > > > > [  5]   1.00-2.00   sec  4.97 MBytes  41.7 Mbits/sec    0    130 KBytes
> > > > > > [  5]   2.00-3.00   sec  5.28 MBytes  44.3 Mbits/sec    0   99.0 KBytes
> > > > > > [  5]   3.00-4.00   sec  5.28 MBytes  44.3 Mbits/sec    0    105 KBytes
> > > > > > [  5]   4.00-5.00   sec  5.28 MBytes  44.3 Mbits/sec    0    122 KBytes
> > > > > > [  5]   5.00-6.00   sec  5.28 MBytes  44.3 Mbits/sec    0   82.0 KBytes
> > > > > > [  5]   6.00-7.00   sec  5.28 MBytes  44.3 Mbits/sec    0   79.2 KBytes
> > > > > > [  5]   7.00-8.00   sec  5.28 MBytes  44.3 Mbits/sec    0    110 KBytes
> > > > > > [  5]   8.00-9.00   sec  5.28 MBytes  44.3 Mbits/sec    0    156 KBytes
> > > > > > [  5]   9.00-10.00  sec  5.28 MBytes  44.3 Mbits/sec    0   87.7 KBytes
> > > > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > > > [  5]   0.00-10.00  sec  53.0 MBytes  44.5 Mbits/sec    0             sender
> > > > > > [  5]   0.00-10.00  sec  52.5 MBytes  44.1 Mbits/sec                  receiver
> > > > > >
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > > > > [  5]   0.00-1.00   sec  7.08 MBytes  59.4 Mbits/sec    0    156 KBytes
> > > > > > [  5]   1.00-2.00   sec  5.97 MBytes  50.0 Mbits/sec    0    110 KBytes
> > > > > > [  5]   2.00-3.00   sec  4.97 MBytes  41.7 Mbits/sec    0    124 KBytes
> > > > > > [  5]   3.00-4.00   sec  5.47 MBytes  45.9 Mbits/sec    0   96.2 KBytes
> > > > > > [  5]   4.00-5.00   sec  5.47 MBytes  45.9 Mbits/sec    0    158 KBytes
> > > > > > [  5]   5.00-6.00   sec  4.97 MBytes  41.7 Mbits/sec    0   70.7 KBytes
> > > > > > [  5]   6.00-7.00   sec  5.47 MBytes  45.9 Mbits/sec    0    113 KBytes
> > > > > > [  5]   7.00-8.00   sec  5.47 MBytes  45.9 Mbits/sec    0   96.2 KBytes
> > > > > > [  5]   8.00-9.00   sec  4.97 MBytes  41.7 Mbits/sec    0   84.8 KBytes
> > > > > > [  5]   9.00-10.00  sec  5.47 MBytes  45.9 Mbits/sec    0    116 KBytes
> > > > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > > > [  5]   0.00-10.00  sec  55.3 MBytes  46.4 Mbits/sec    0             sender
> > > > > > [  5]   0.00-10.00  sec  53.9 MBytes  45.2 Mbits/sec                  receiver
> > > > > >
> > > > > > And the low bandwidth continues with:
> > > > > > ethtool -k enp3s0 |grep ": on"
> > > > > > rx-vlan-offload: on
> > > > > > tx-vlan-offload: on [requested off]
> > > > > > highdma: on [fixed]
> > > > > > rx-vlan-filter: on [fixed]
> > > > > > tx-gre-segmentation: on
> > > > > > tx-gre-csum-segmentation: on
> > > > > > tx-ipxip4-segmentation: on
> > > > > > tx-ipxip6-segmentation: on
> > > > > > tx-udp_tnl-segmentation: on
> > > > > > tx-udp_tnl-csum-segmentation: on
> > > > > > tx-gso-partial: on
> > > > > > tx-udp-segmentation: on
> > > > > > hw-tc-offload: on
> > > > > >
> > > > > > Can't quite find how to turn those off since they aren't listed in
> > > > > > ethtool (since the text is not what you use to enable/disable)
> > > > >
> > > > > To disable them you would just repeat the same string in the display
> > > > > string. So it should just be "ethtool -K enp3s0 tx-gso-partial off"
> > > > > and that would turn off a large chunk of them as all the encapsulated
> > > > > support requires gso partial support.
> > > >
> > > >  ethtool -k enp3s0 |grep ": on"
> > > > highdma: on [fixed]
> > > > rx-vlan-filter: on [fixed]
> > > > ---
> > > > And then back to back:
> > > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > > [  5]   0.00-1.00   sec  4.91 MBytes  41.2 Mbits/sec    0   45.2 KBytes
> > > > [  5]   1.00-2.00   sec  4.47 MBytes  37.5 Mbits/sec    0   52.3 KBytes
> > > > [  5]   2.00-3.00   sec  4.47 MBytes  37.5 Mbits/sec    0   42.4 KBytes
> > > > [  5]   3.00-4.00   sec  4.47 MBytes  37.5 Mbits/sec    0    141 KBytes
> > > > [  5]   4.00-5.00   sec   111 MBytes   928 Mbits/sec   63    764 KBytes
> > > > [  5]   5.00-6.00   sec  86.2 MBytes   724 Mbits/sec    0    744 KBytes
> > > > [  5]   6.00-7.00   sec  98.8 MBytes   828 Mbits/sec   61    769 KBytes
> > > > [  5]   7.00-8.00   sec   110 MBytes   923 Mbits/sec    0    749 KBytes
> > > > [  5]   8.00-9.00   sec   110 MBytes   923 Mbits/sec    0    741 KBytes
> > > > [  5]   9.00-10.00  sec   110 MBytes   923 Mbits/sec   31    761 KBytes
> > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > [  5]   0.00-10.00  sec   644 MBytes   540 Mbits/sec  155             sender
> > > > [  5]   0.00-10.01  sec   641 MBytes   537 Mbits/sec                  receiver
> > > >
> > > > and we're back at the not working bit:
> > > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > > [  5]   0.00-1.00   sec  4.84 MBytes  40.6 Mbits/sec    0   42.4 KBytes
> > > > [  5]   1.00-2.00   sec  4.60 MBytes  38.6 Mbits/sec    0   42.4 KBytes
> > > > [  5]   2.00-3.00   sec  4.23 MBytes  35.4 Mbits/sec    0   42.4 KBytes
> > > > [  5]   3.00-4.00   sec  4.47 MBytes  37.5 Mbits/sec    0   67.9 KBytes
> > > > [  5]   4.00-5.00   sec  4.47 MBytes  37.5 Mbits/sec    0   42.4 KBytes
> > > > [  5]   5.00-6.00   sec  4.23 MBytes  35.4 Mbits/sec    0   42.4 KBytes
> > > > [  5]   6.00-7.00   sec  4.23 MBytes  35.4 Mbits/sec    0   42.4 KBytes
> > > > [  5]   7.00-8.00   sec  4.47 MBytes  37.5 Mbits/sec    0   67.9 KBytes
> > > > [  5]   8.00-9.00   sec  4.47 MBytes  37.5 Mbits/sec    0   53.7 KBytes
> > > > [  5]   9.00-10.00  sec  4.47 MBytes  37.5 Mbits/sec    0   79.2 KBytes
> > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > [  5]   0.00-10.00  sec  44.5 MBytes  37.3 Mbits/sec    0             sender
> > > > [  5]   0.00-10.00  sec  43.9 MBytes  36.8 Mbits/sec                  receiver
> > > >
> > > > > > I was hoping that you'd have a clue of something that might introduce
> > > > > > a regression - ie specific patches to try to revert
> > > > > >
> > > > > > Btw, the same issue applies to udp as werll
> > > > > >
> > > > > > [ ID] Interval           Transfer     Bitrate         Total Datagrams
> > > > > > [  5]   0.00-1.00   sec  6.77 MBytes  56.8 Mbits/sec  4900
> > > > > > [  5]   1.00-2.00   sec  4.27 MBytes  35.8 Mbits/sec  3089
> > > > > > [  5]   2.00-3.00   sec  4.20 MBytes  35.2 Mbits/sec  3041
> > > > > > [  5]   3.00-4.00   sec  4.30 MBytes  36.1 Mbits/sec  3116
> > > > > > [  5]   4.00-5.00   sec  4.24 MBytes  35.6 Mbits/sec  3070
> > > > > > [  5]   5.00-6.00   sec  4.21 MBytes  35.3 Mbits/sec  3047
> > > > > > [  5]   6.00-7.00   sec  4.29 MBytes  36.0 Mbits/sec  3110
> > > > > > [  5]   7.00-8.00   sec  4.28 MBytes  35.9 Mbits/sec  3097
> > > > > > [  5]   8.00-9.00   sec  4.25 MBytes  35.6 Mbits/sec  3075
> > > > > > [  5]   9.00-10.00  sec  4.20 MBytes  35.2 Mbits/sec  3039
> > > > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > > > [ ID] Interval           Transfer     Bitrate         Jitter
> > > > > > Lost/Total Datagrams
> > > > > > [  5]   0.00-10.00  sec  45.0 MBytes  37.7 Mbits/sec  0.000 ms
> > > > > > 0/32584 (0%)  sender
> > > > > > [  5]   0.00-10.00  sec  45.0 MBytes  37.7 Mbits/sec  0.037 ms
> > > > > > 0/32573 (0%)  receiver
> > > > > >
> > > > > > vs:
> > > > > >
> > > > > > [ ID] Interval           Transfer     Bitrate         Total Datagrams
> > > > > > [  5]   0.00-1.00   sec   114 MBytes   954 Mbits/sec  82342
> > > > > > [  5]   1.00-2.00   sec   114 MBytes   955 Mbits/sec  82439
> > > > > > [  5]   2.00-3.00   sec   114 MBytes   956 Mbits/sec  82507
> > > > > > [  5]   3.00-4.00   sec   114 MBytes   955 Mbits/sec  82432
> > > > > > [  5]   4.00-5.00   sec   114 MBytes   956 Mbits/sec  82535
> > > > > > [  5]   5.00-6.00   sec   114 MBytes   953 Mbits/sec  82240
> > > > > > [  5]   6.00-7.00   sec   114 MBytes   956 Mbits/sec  82512
> > > > > > [  5]   7.00-8.00   sec   114 MBytes   956 Mbits/sec  82503
> > > > > > [  5]   8.00-9.00   sec   114 MBytes   956 Mbits/sec  82532
> > > > > > [  5]   9.00-10.00  sec   114 MBytes   956 Mbits/sec  82488
> > > > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > > > [ ID] Interval           Transfer     Bitrate         Jitter
> > > > > > Lost/Total Datagrams
> > > > > > [  5]   0.00-10.00  sec  1.11 GBytes   955 Mbits/sec  0.000 ms
> > > > > > 0/824530 (0%)  sender
> > > > > > [  5]   0.00-10.01  sec  1.11 GBytes   949 Mbits/sec  0.014 ms
> > > > > > 4756/824530 (0.58%)  receiver
> > > > >
> > > > > The fact that it is impacting UDP seems odd. I wonder if we don't have
> > > > > a qdisc somewhere that is misbehaving and throttling the Tx. Either
> > > > > that or I wonder if we are getting spammed with flow control frames.
> > > >
> > > > it sometimes works, it looks like the cwindow just isn't increased -
> > > > that's where i started...
> > > >
> > > > Example:
> > > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > > [  5]   0.00-1.00   sec  4.86 MBytes  40.8 Mbits/sec    0   50.9 KBytes
> > > > [  5]   1.00-2.00   sec  4.66 MBytes  39.1 Mbits/sec    0   65.0 KBytes
> > > > [  5]   2.00-3.00   sec  4.29 MBytes  36.0 Mbits/sec    0   42.4 KBytes
> > > > [  5]   3.00-4.00   sec  4.66 MBytes  39.1 Mbits/sec    0   42.4 KBytes
> > > > [  5]   4.00-5.00   sec  23.1 MBytes   194 Mbits/sec    0   1.07 MBytes
> > > > [  5]   5.00-6.00   sec   110 MBytes   923 Mbits/sec    0    761 KBytes
> > > > [  5]   6.00-7.00   sec  98.8 MBytes   828 Mbits/sec   60    806 KBytes
> > > > [  5]   7.00-8.00   sec  82.5 MBytes   692 Mbits/sec    0    812 KBytes
> > > > [  5]   8.00-9.00   sec   110 MBytes   923 Mbits/sec   92    761 KBytes
> > > > [  5]   9.00-10.00  sec   111 MBytes   933 Mbits/sec    0    755 KBytes
> > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > [  5]   0.00-10.00  sec   554 MBytes   465 Mbits/sec  152             sender
> > > > [  5]   0.00-10.00  sec   550 MBytes   461 Mbits/sec                  receiver
> > > >
> > > > > It would be useful to include the output of just calling "ethtool
> > > > > enp3s0" on the interface to verify the speed, "ethtool -a enp3s0" to
> > > > > verify flow control settings, and "ethtool -S enp3s0 | grep -v :\ 0"
> > > > > to output the statistics and dump anything that isn't zero.
> > > >
> > > > ethtool enp3s0
> > > > Settings for enp3s0:
> > > > Supported ports: [ TP ]
> > > > Supported link modes:   10baseT/Half 10baseT/Full
> > > >                         100baseT/Half 100baseT/Full
> > > >                         1000baseT/Full
> > > > Supported pause frame use: Symmetric
> > > > Supports auto-negotiation: Yes
> > > > Supported FEC modes: Not reported
> > > > Advertised link modes:  10baseT/Half 10baseT/Full
> > > >                         100baseT/Half 100baseT/Full
> > > >                         1000baseT/Full
> > > > Advertised pause frame use: Symmetric
> > > > Advertised auto-negotiation: Yes
> > > > Advertised FEC modes: Not reported
> > > > Speed: 1000Mb/s
> > > > Duplex: Full
> > > > Auto-negotiation: on
> > > > Port: Twisted Pair
> > > > PHYAD: 1
> > > > Transceiver: internal
> > > > MDI-X: off (auto)
> > > > Supports Wake-on: pumbg
> > > > Wake-on: g
> > > >         Current message level: 0x00000007 (7)
> > > >                                drv probe link
> > > > Link detected: yes
> > > > ---
> > > > ethtool -a enp3s0
> > > > Pause parameters for enp3s0:
> > > > Autonegotiate: on
> > > > RX: on
> > > > TX: off
> > > > ---
> > > > ethtool -S enp3s0 |grep  -v :\ 0
> > > > NIC statistics:
> > > >      rx_packets: 15920618
> > > >      tx_packets: 17846725
> > > >      rx_bytes: 15676264423
> > > >      tx_bytes: 19925010639
> > > >      rx_broadcast: 119553
> > > >      tx_broadcast: 497
> > > >      rx_multicast: 330193
> > > >      tx_multicast: 18190
> > > >      multicast: 330193
> > > >      rx_missed_errors: 270102
> > > >      rx_long_length_errors: 6
> > > >      tx_tcp_seg_good: 1342561
> > > >      rx_long_byte_count: 15676264423
> > > >      rx_errors: 6
> > > >      rx_length_errors: 6
> > > >      rx_fifo_errors: 270102
> > > >      tx_queue_0_packets: 7651168
> > > >      tx_queue_0_bytes: 7823281566
> > > >      tx_queue_0_restart: 4920
> > > >      tx_queue_1_packets: 10195557
> > > >      tx_queue_1_bytes: 12027522118
> > > >      tx_queue_1_restart: 12718
> > > >      rx_queue_0_packets: 15920618
> > > >      rx_queue_0_bytes: 15612581951
> > > >      rx_queue_0_csum_err: 76
> > > > (I've only run two runs since i reenabled the interface)
> > >
> > > So I am seeing three things here.
> > >
> > > The rx_long_length_errors are usually due to an MTU mismatch. Do you
> > > have something on the network that is using jumbo frames, or is the
> > > MTU on the NIC set to something smaller than what is supported on the
> > > network?
> >
> > I'm using jumbo frames on the local network, internet side is the
> > normal 1500 bytes mtu though
> >
> > > You are getting rx_missed_errors, that would seem to imply that the
> > > DMA is not able to keep up. We may want to try disabling the L1 to see
> > > if we get any boost from doing that.
> >
> > It used to work, I don't do benchmarks all the time and sometimes the first
> > benchmarks turn out fine... so it's hard to say when this started happening...
> >
> > It could also be related to a bios upgrade, but I'm pretty sure I did
> > successful benchmarks after that...
> >
> > How do I disable the l1? just echo 0 >
> > /sys/bus/pci/drivers/igb/0000\:03\:00.0/link/l1_aspm ?
> >
> > > The last bit is that queue 0 is seeing packets with bad checksums. You
> > > might want to run some tests and see where the bad checksums are
> > > coming from. If they are being detected from a specific NIC such as
> > > the ixgbe in your example it might point to some sort of checksum
> > > error being created as a result of the NAT translation.
> >
> > But that should also affect A' and the A -> B -> C case, which it doesn't...
> >
> > It only seems to happen with higher rtt (6 hops, sub 3 ms in this case
> > but still high enough somehow)
> >
> > > > ---
> > > >
> > > > > > lspci -s 03:00.0  -vvv
> > > > > > 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network
> > > > > > Connection (rev 03)
> > > > > > Subsystem: ASUSTeK Computer Inc. I211 Gigabit Network Connection
> > > > > > Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > > > > Stepping- SERR- FastB2B- DisINTx+
> > > > > > Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > > > > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > > > > > Latency: 0
> > > > > > Interrupt: pin A routed to IRQ 57
> > > > > > IOMMU group: 20
> > > > > > Region 0: Memory at fc900000 (32-bit, non-prefetchable) [size=128K]
> > > > > > Region 2: I/O ports at e000 [size=32]
> > > > > > Region 3: Memory at fc920000 (32-bit, non-prefetchable) [size=16K]
> > > > > > Capabilities: [40] Power Management version 3
> > > > > > Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> > > > > > Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
> > > > > > Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
> > > > > > Address: 0000000000000000  Data: 0000
> > > > > > Masking: 00000000  Pending: 00000000
> > > > > > Capabilities: [70] MSI-X: Enable+ Count=5 Masked-
> > > > > > Vector table: BAR=3 offset=00000000
> > > > > > PBA: BAR=3 offset=00002000
> > > > > > Capabilities: [a0] Express (v2) Endpoint, MSI 00
> > > > > > DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
> > > > > > ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
> > > > > > DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
> > > > > > RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
> > > > > > MaxPayload 128 bytes, MaxReadReq 512 bytes
> > > > > > DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
> > > > > > LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> > > > > > L0s <2us, L1 <16us
> > > > > > ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
> > > > > > LnkCtl: ASPM L1 Enabled; RCB 64 bytes, Disabled- CommClk+
> > > > > > ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > > > > > LnkSta: Speed 2.5GT/s (ok), Width x1 (ok)
> > > > > > TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> > > > >
> > > > > PCIe wise the connection is going to be pretty tight in terms of
> > > > > bandwidth. It looks like we have 2.5GT/s with only a single lane of
> > > > > PCIe. In addition we are running with ASPM enabled so that means that
> > > > > if we don't have enough traffic we are shutting off the one PCIe lane
> > > > > we have so if we are getting bursty traffic that can get ugly.
> > > >
> > > > Humm... is there a way to force disable ASPM in sysfs?
> > >
> > > Actually the easiest way to do this is to just use setpci.
> > >
> > > You should be able to dump the word containing the setting via:
> > > # setpci -s 3:00.0 0xB0.w
> > > 0042
> > > # setpci -s 3:00.0 0xB0.w=0040
> > >
> > > Basically what you do is clear the lower 3 bits of the value so in
> > > this case that means replacing the 2 with a 0 based on the output of
> > > the first command.
> >
> > Well... I'll be damned... I used to force enable ASPM... this must be
> > related to the change in PCIe bus ASPM
> > Perhaps disable ASPM if there is only one link?
>
> Is there any specific reason why you are enabling ASPM? Is this system
> a laptop where you are trying to conserve power when on battery? If
> not disabling it probably won't hurt things too much since the power
> consumption for a 2.5GT/s link operating in a width of one shouldn't
> bee too high. Otherwise you are likely going to end up paying the
> price for getting the interface out of L1 when the traffic goes idle
> so you are going to see flows that get bursty paying a heavy penalty
> when they start dropping packets.

Ah, you misunderstand, I used to do this and everything worked - now
Linux enables ASPM by default on all pcie controllers,
so imho this should be a quirk, if there is only one lane, don't do
ASPM due to latency and timing issues...

> It is also possible this could be something that changed with the
> physical PCIe link. Basically L1 works by powering down the link when
> idle, and then powering it back up when there is activity. The problem
> is bringing it back up can sometimes be a challenge when the physical
> link starts to go faulty. I know I have seen that in some cases it can
> even result in the device falling off of the PCIe bus if the link
> training fails.

It works fine without ASPM (and the machine is pretty new)

I suspect we hit some timing race with aggressive ASPM (assumed as
such since it works on local links but doesn't on ~3 ms Links)

> > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > [  5]   0.00-1.00   sec   113 MBytes   950 Mbits/sec   31    710 KBytes
> > [  5]   1.00-2.00   sec   110 MBytes   923 Mbits/sec  135    626 KBytes
> > [  5]   2.00-3.00   sec   112 MBytes   944 Mbits/sec   18    713 KBytes
> > [  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec    0    798 KBytes
> > [  5]   4.00-5.00   sec   111 MBytes   933 Mbits/sec    0    721 KBytes
> > [  5]   5.00-6.00   sec   112 MBytes   944 Mbits/sec   31    800 KBytes
> > [  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec    0    730 KBytes
> > [  5]   7.00-8.00   sec   111 MBytes   933 Mbits/sec   19    730 KBytes
> > [  5]   8.00-9.00   sec   111 MBytes   933 Mbits/sec    0    701 KBytes
> > [  5]   9.00-10.00  sec   112 MBytes   944 Mbits/sec   12    701 KBytes
> > - - - - - - - - - - - - - - - - - - - - - - - - -
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  1.09 GBytes   937 Mbits/sec  246             sender
> > [  5]   0.00-10.01  sec  1.09 GBytes   933 Mbits/sec                  receiver
> >
> > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > [  5]   0.00-1.00   sec   114 MBytes   956 Mbits/sec    0    749 KBytes
> > [  5]   1.00-2.00   sec   111 MBytes   933 Mbits/sec   30    766 KBytes
> > [  5]   2.00-3.00   sec   112 MBytes   944 Mbits/sec    7    749 KBytes
> > [  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec   11    707 KBytes
> > [  5]   4.00-5.00   sec   111 MBytes   933 Mbits/sec    2    699 KBytes
> > [  5]   5.00-6.00   sec   111 MBytes   933 Mbits/sec    8    699 KBytes
> > [  5]   6.00-7.00   sec   112 MBytes   944 Mbits/sec    1    953 KBytes
> > [  5]   7.00-8.00   sec   111 MBytes   933 Mbits/sec    0    701 KBytes
> > [  5]   8.00-9.00   sec   111 MBytes   933 Mbits/sec   26    707 KBytes
> > [  5]   9.00-10.00  sec   112 MBytes   944 Mbits/sec    2   1.07 MBytes
> > - - - - - - - - - - - - - - - - - - - - - - - - -
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  1.09 GBytes   939 Mbits/sec   87             sender
> > [  5]   0.00-10.00  sec  1.09 GBytes   934 Mbits/sec                  receiver
> >
> > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > [  5]   0.00-1.00   sec   114 MBytes   953 Mbits/sec   16    908 KBytes
> > [  5]   1.00-2.00   sec   112 MBytes   944 Mbits/sec    0    693 KBytes
> > [  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec    0    713 KBytes
> > [  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec    0    687 KBytes
> > [  5]   4.00-5.00   sec   112 MBytes   944 Mbits/sec   15    687 KBytes
> > [  5]   5.00-6.00   sec   111 MBytes   933 Mbits/sec    2    888 KBytes
> > [  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec   17    696 KBytes
> > [  5]   7.00-8.00   sec   111 MBytes   933 Mbits/sec    0    758 KBytes
> > [  5]   8.00-9.00   sec   111 MBytes   933 Mbits/sec   31    749 KBytes
> > [  5]   9.00-10.00  sec   112 MBytes   944 Mbits/sec    0    792 KBytes
> > - - - - - - - - - - - - - - - - - - - - - - - - -
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  1.09 GBytes   938 Mbits/sec   81             sender
> > [  5]   0.00-10.00  sec  1.09 GBytes   934 Mbits/sec                  receiver
> >
> > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > [  5]   0.00-1.00   sec   114 MBytes   956 Mbits/sec    0    747 KBytes
> > [  5]   1.00-2.00   sec   111 MBytes   933 Mbits/sec    0    744 KBytes
> > [  5]   2.00-3.00   sec   112 MBytes   944 Mbits/sec   12   1.18 MBytes
> > [  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec    2    699 KBytes
> > [  5]   4.00-5.00   sec   111 MBytes   933 Mbits/sec   28    699 KBytes
> > [  5]   5.00-6.00   sec   112 MBytes   944 Mbits/sec    0    684 KBytes
> > [  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec    0    741 KBytes
> > [  5]   7.00-8.00   sec   111 MBytes   933 Mbits/sec    3    687 KBytes
> > [  5]   8.00-9.00   sec   111 MBytes   933 Mbits/sec   22    699 KBytes
> > [  5]   9.00-10.00  sec   111 MBytes   933 Mbits/sec   11    707 KBytes
> > - - - - - - - - - - - - - - - - - - - - - - - - -
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  1.09 GBytes   938 Mbits/sec   78             sender
> > [  5]   0.00-10.01  sec  1.09 GBytes   934 Mbits/sec                  receiver
> > ---
> >
> > ethtool -S enp3s0 |grep -v ": 0"
> > NIC statistics:
> >      rx_packets: 16303520
> >      tx_packets: 21602840
> >      rx_bytes: 15711958157
> >      tx_bytes: 25599009212
> >      rx_broadcast: 122212
> >      tx_broadcast: 530
> >      rx_multicast: 333489
> >      tx_multicast: 18446
> >      multicast: 333489
> >      rx_missed_errors: 270143
> >      rx_long_length_errors: 6
> >      tx_tcp_seg_good: 1342561
> >      rx_long_byte_count: 15711958157
> >      rx_errors: 6
> >      rx_length_errors: 6
> >      rx_fifo_errors: 270143
> >      tx_queue_0_packets: 8963830
> >      tx_queue_0_bytes: 9803196683
> >      tx_queue_0_restart: 4920
> >      tx_queue_1_packets: 12639010
> >      tx_queue_1_bytes: 15706576814
> >      tx_queue_1_restart: 12718
> >      rx_queue_0_packets: 16303520
> >      rx_queue_0_bytes: 15646744077
> >      rx_queue_0_csum_err: 76
>
> Okay, so this result still has the same length and checksum errors,
> were you resetting the system/statistics between runs?

Ah, no.... Will reset and do more tests when I'm back home

Am I blind or is this part missing from ethtools man page?
