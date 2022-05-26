Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408B9534F03
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346349AbiEZMTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiEZMS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:18:58 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51A6D413D
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 05:18:57 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id q8so1847995oif.13
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 05:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLSM/8kDcZbA7YFN+80uNCo9mIc7oVDwUzACPp0MJzI=;
        b=Jba9/oQ7EhCHTPj4e0T8+acAsjK8wPnCpG4E6PD7PWPG2bxQif45eY0QFnYuUayP+S
         U/h1UhF6NgQOcPS1uxcFKj1iZuY3VGP3NI+VS/ev6tYJn4rhbkbTw/IN8JLZnsymcx1Q
         uf6gVIJirlDFBCaW2j/E0dbSlEVG6lpzYvSQrJvLPW0YAUV8tUUD4o88ILfCK7Awa3Jb
         nOULVPFGhjNVsVGhEKhEqXmXcFj4J7zhTsgJAWRuPEwv1Y96HYDu7XH/lA/piToAGQ+T
         XT7NYVwZB5+e82qAevvHL78OCwHp7JbysHEF/UdHldojNWVjw0zzUbsGTXNhhPCQgVyh
         /SAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLSM/8kDcZbA7YFN+80uNCo9mIc7oVDwUzACPp0MJzI=;
        b=A95/mqN9EkTfD/1dh9Ngx1aB/F/J8FItUNdaRGJ9iTaHrdfQmaP0kb35kCb+OFyawi
         5hDqV+rRugK+6p8iKSGpHMRlkPc8TgUyB/RHYUiZ0pguTzY1gX7zJ3XIDZAOgUqzrgol
         OykQ2jyrBmoPWysc/I7fwsGzuucMkU2krPXlltbGdG/OK/zcuKc3F5mfy/iZdWWKYQA3
         BcIQBxP0hApnJPAA5zdtcEB+IxHT4yyOoL7hE2v27oXEyRf+EPCV2RUq7IiALQjAynMN
         ee8SQsNCUIQKagdbExCalOjVepdbG0nt+2Soj0rHeQcbssQTb+iPRkwrmd5JkdwTIYj9
         RT0Q==
X-Gm-Message-State: AOAM5332yYnApKD+ZxR2AIke9FSziMkxfZVIeijng+yAexkdk+4CX9A5
        JnhxmfORYm6MipoRX7fWBS9rjJ08+trU/FjM12hYoQ==
X-Google-Smtp-Source: ABdhPJzrXVXApvXvTSd22hQ/EiuENto3oqBsg0ZuGXiH/dOnFKMyE6jnsagaDy+iwlBZZEnqZNGSFSznwbUC3IlCDw4=
X-Received: by 2002:aca:c182:0:b0:2ef:8fd4:7523 with SMTP id
 r124-20020acac182000000b002ef8fd47523mr987974oif.148.1653567537021; Thu, 26
 May 2022 05:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220512112347.18717-1-andrew@daynix.com> <CACGkMEvH1yE0CZYdstAK32DkEucejNO+V7PEAZD_641+rp2aKA@mail.gmail.com>
 <CABcq3pFJcsoj+dDf6tirT_hfTB6rj9+f6KNFafwg+usqYwTdDA@mail.gmail.com> <CACGkMEtaigzuwy25rE-7N40TQGvXVmJVQivavmuwrCuw0Z=LUQ@mail.gmail.com>
In-Reply-To: <CACGkMEtaigzuwy25rE-7N40TQGvXVmJVQivavmuwrCuw0Z=LUQ@mail.gmail.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Thu, 26 May 2022 15:18:46 +0300
Message-ID: <CABcq3pFzzSHA3pqbKFEsLaFg7FkFZkdxs+N_ET_n_XLBaWVnHA@mail.gmail.com>
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

I'll check it, thank you!

On Thu, May 26, 2022 at 9:56 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Tue, May 24, 2022 at 7:07 PM Andrew Melnichenko <andrew@daynix.com> wrote:
> >
> > Hi all,
> >
> > The issue is that host segments packets between guests on the same host.
> > Tests show that it happens because SKB_GSO_DODGY skb offload in
> > virtio_net_hdr_from_skb().
> > To do segmentation you need to remove SKB_GSO_DODGY or add SKB_GSO_PARTIAL
> > The solution with DODGY/PARTIAL offload looks like a dirty hack, so
> > for now, I've lived it as it is for further investigation.
>
> Ok, I managed to find the previous discussion. It looks to me the
> reason is that __udp_gso_segment will segment dodgy packets
> unconditionally.
>
> I wonder if the attached patch works? (compile test only).
>
> Thanks
>
> >
> >
> > On Tue, May 17, 2022 at 9:32 AM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > > On Thu, May 12, 2022 at 7:33 PM Andrew Melnychenko <andrew@daynix.com> wrote:
> > > >
> > > > Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> > > > Technically they enable NETIF_F_GSO_UDP_L4
> > > > (and only if USO4 & USO6 are set simultaneously).
> > > > It allows to transmission of large UDP packets.
> > > >
> > > > Different features USO4 and USO6 are required for qemu where Windows guests can
> > > > enable disable USO receives for IPv4 and IPv6 separately.
> > > > On the other side, Linux can't really differentiate USO4 and USO6, for now.
> > > > For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> > > > In the future, there would be a mechanism to control UDP_L4 GSO separately.
> > > >
> > > > Test it WIP Qemu https://github.com/daynix/qemu/tree/Dev_USOv2
> > > >
> > > > New types for VirtioNet already on mailing:
> > > > https://lists.oasis-open.org/archives/virtio-comment/202110/msg00010.html
> > > >
> > > > Also, there is a known issue with transmitting packages between two guests.
> > >
> > > Could you explain this more? It looks like a bug. (Or any pointer to
> > > the discussion)
> > >
> > > Thanks
> > >
> > > > Without hacks with skb's GSO - packages are still segmented on the host's postrouting.
> > > >
> > > > Andrew (5):
> > > >   uapi/linux/if_tun.h: Added new offload types for USO4/6.
> > > >   driver/net/tun: Added features for USO.
> > > >   uapi/linux/virtio_net.h: Added USO types.
> > > >   linux/virtio_net.h: Support USO offload in vnet header.
> > > >   drivers/net/virtio_net.c: Added USO support.
> > > >
> > > >  drivers/net/tap.c               | 10 ++++++++--
> > > >  drivers/net/tun.c               |  8 +++++++-
> > > >  drivers/net/virtio_net.c        | 19 +++++++++++++++----
> > > >  include/linux/virtio_net.h      |  9 +++++++++
> > > >  include/uapi/linux/if_tun.h     |  2 ++
> > > >  include/uapi/linux/virtio_net.h |  4 ++++
> > > >  6 files changed, 45 insertions(+), 7 deletions(-)
> > > >
> > > > --
> > > > 2.35.1
> > > >
> > >
> >
