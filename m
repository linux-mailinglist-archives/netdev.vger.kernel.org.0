Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B457F54E062
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 13:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiFPL7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 07:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiFPL7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 07:59:40 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9B858E54
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 04:59:39 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id p129so1614639oig.3
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 04:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tKhLhAU1VwnhstyxXFD1uOF/c3hqPPQcj1y5Vx8V8sI=;
        b=FPNp7AlEq73YPzIn+VQs0w+sTCDNSZtdGNK6FPZOOnRz6tQLqIUmO8x3K13QLdj6Z5
         0p5nDdLps78jmHX/rEKQ7uQv7kMSIlNmcnauti/kss8KH/eL6uo7WLnbNJAAhDkzVC6k
         Z6eQ1ZtGu6YoTrh2Wwr5cHKM3Wu6Gjujtq4ikFRqAGxPQnwA5i0s6UxRT6KyBosqZXQC
         IOGwceh2lXzSbYZASloqNUkNauKwA2/slJXb0K+7SyIRe4MRHNOTrxBwCmX4YK79bueL
         rwm3FIwM0OINR1dWM8TM1rAUk4YIKvYzrj0kg5SwkVuIW2piinJhFupsSiIQA8wVodOg
         ekxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tKhLhAU1VwnhstyxXFD1uOF/c3hqPPQcj1y5Vx8V8sI=;
        b=L2SZAXeZgXChqeEIefEPEyI+22kn/3X/191FpjWqfjxog/yC6vEfEjcQ6sAEiRcJZZ
         X0oWgXC7i/du6WhTg3cM1yexdT6P8TUFMk6OSY288TxWxxcfUsqxe+1aFumNCpx7ywiQ
         FzEAjTyVoVLHSt+UgQm4YqzwAlWWaF9o71y3CWHlZL1x9jlsgaAmgw57p4poohx1UZB0
         mPr7dOW1Fz7vUV4vl4pU8dfodn7q3MFfbJ/n1dyna2llc9rZeodNJx6CwkdYXq7Bru/1
         lUDhwWm/Fpam2dy9yuzfF93nYA+mRHW6SDwz3IgEq7zu7GgtbFf43APdip9kvd8ogysR
         7mgw==
X-Gm-Message-State: AJIora/ygdflQzMSF5H1tXLgtFVTkjqaBJr1uKbqnjAHwiXT8SVQupOe
        CBV7fFdE9oTyjLcnjXYbyCo0thtjVe3h1ZjLWJiSkQ==
X-Google-Smtp-Source: AGRyM1t7lM8G2J40rKKfaP+sqAb2CfdR7uixK9NuYWauryhEjnCDAH/meWhs+RFb3oju1l6Qg41d5r4eVixvaBXv190=
X-Received: by 2002:a05:6808:10c1:b0:331:39ca:a500 with SMTP id
 s1-20020a05680810c100b0033139caa500mr2341417ois.137.1655380779203; Thu, 16
 Jun 2022 04:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220512112347.18717-1-andrew@daynix.com> <CACGkMEvH1yE0CZYdstAK32DkEucejNO+V7PEAZD_641+rp2aKA@mail.gmail.com>
 <CABcq3pFJcsoj+dDf6tirT_hfTB6rj9+f6KNFafwg+usqYwTdDA@mail.gmail.com>
 <CACGkMEtaigzuwy25rE-7N40TQGvXVmJVQivavmuwrCuw0Z=LUQ@mail.gmail.com> <CABcq3pFzzSHA3pqbKFEsLaFg7FkFZkdxs+N_ET_n_XLBaWVnHA@mail.gmail.com>
In-Reply-To: <CABcq3pFzzSHA3pqbKFEsLaFg7FkFZkdxs+N_ET_n_XLBaWVnHA@mail.gmail.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Thu, 16 Jun 2022 14:59:28 +0300
Message-ID: <CABcq3pHkqxunsaZ8qt=FicL1361D0EktxZhqib+MGDJ=DVB6FA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] TUN/VirtioNet USO features support.
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jason
Apparently, your patch should work.
For now, I have an issue where segmentation between two guests on one
host still occurs.
Neither previous "hack" nor your patch helps.
Now I'm looking what the issue may be.
If you have some suggestions on where may I look, it would be helpful, thanks!

On Thu, May 26, 2022 at 3:18 PM Andrew Melnichenko <andrew@daynix.com> wrote:
>
> I'll check it, thank you!
>
> On Thu, May 26, 2022 at 9:56 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Tue, May 24, 2022 at 7:07 PM Andrew Melnichenko <andrew@daynix.com> wrote:
> > >
> > > Hi all,
> > >
> > > The issue is that host segments packets between guests on the same host.
> > > Tests show that it happens because SKB_GSO_DODGY skb offload in
> > > virtio_net_hdr_from_skb().
> > > To do segmentation you need to remove SKB_GSO_DODGY or add SKB_GSO_PARTIAL
> > > The solution with DODGY/PARTIAL offload looks like a dirty hack, so
> > > for now, I've lived it as it is for further investigation.
> >
> > Ok, I managed to find the previous discussion. It looks to me the
> > reason is that __udp_gso_segment will segment dodgy packets
> > unconditionally.
> >
> > I wonder if the attached patch works? (compile test only).
> >
> > Thanks
> >
> > >
> > >
> > > On Tue, May 17, 2022 at 9:32 AM Jason Wang <jasowang@redhat.com> wrote:
> > > >
> > > > On Thu, May 12, 2022 at 7:33 PM Andrew Melnychenko <andrew@daynix.com> wrote:
> > > > >
> > > > > Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> > > > > Technically they enable NETIF_F_GSO_UDP_L4
> > > > > (and only if USO4 & USO6 are set simultaneously).
> > > > > It allows to transmission of large UDP packets.
> > > > >
> > > > > Different features USO4 and USO6 are required for qemu where Windows guests can
> > > > > enable disable USO receives for IPv4 and IPv6 separately.
> > > > > On the other side, Linux can't really differentiate USO4 and USO6, for now.
> > > > > For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> > > > > In the future, there would be a mechanism to control UDP_L4 GSO separately.
> > > > >
> > > > > Test it WIP Qemu https://github.com/daynix/qemu/tree/Dev_USOv2
> > > > >
> > > > > New types for VirtioNet already on mailing:
> > > > > https://lists.oasis-open.org/archives/virtio-comment/202110/msg00010.html
> > > > >
> > > > > Also, there is a known issue with transmitting packages between two guests.
> > > >
> > > > Could you explain this more? It looks like a bug. (Or any pointer to
> > > > the discussion)
> > > >
> > > > Thanks
> > > >
> > > > > Without hacks with skb's GSO - packages are still segmented on the host's postrouting.
> > > > >
> > > > > Andrew (5):
> > > > >   uapi/linux/if_tun.h: Added new offload types for USO4/6.
> > > > >   driver/net/tun: Added features for USO.
> > > > >   uapi/linux/virtio_net.h: Added USO types.
> > > > >   linux/virtio_net.h: Support USO offload in vnet header.
> > > > >   drivers/net/virtio_net.c: Added USO support.
> > > > >
> > > > >  drivers/net/tap.c               | 10 ++++++++--
> > > > >  drivers/net/tun.c               |  8 +++++++-
> > > > >  drivers/net/virtio_net.c        | 19 +++++++++++++++----
> > > > >  include/linux/virtio_net.h      |  9 +++++++++
> > > > >  include/uapi/linux/if_tun.h     |  2 ++
> > > > >  include/uapi/linux/virtio_net.h |  4 ++++
> > > > >  6 files changed, 45 insertions(+), 7 deletions(-)
> > > > >
> > > > > --
> > > > > 2.35.1
> > > > >
> > > >
> > >
