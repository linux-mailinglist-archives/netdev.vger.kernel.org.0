Return-Path: <netdev+bounces-9426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AEE8728E39
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 913B41C21068
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E7215C8;
	Fri,  9 Jun 2023 02:58:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443861373
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:58:07 +0000 (UTC)
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BE630E7;
	Thu,  8 Jun 2023 19:57:56 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b1c910ee19so13121681fa.3;
        Thu, 08 Jun 2023 19:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686279474; x=1688871474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HToRMbjEfF32G7y+HBABiwU4xsZoxeB+rbGn180KkfA=;
        b=npHUK0dQnm6aZtwRH6KBaLl+d7YxBcw2KXCR/byWvMFDiH1fK7N5OK/G2OAgWO6YQl
         1+yhhso2hEA10T1PZkXZPdQpdKSSSYOLzpTut3GfDa7M1NPxAwuZ3PFutz2D1dz4aQyp
         hSqWo6qKf7+0l+7YqJ9qJOLPddf9ApfV6/sle6ll6QkloaNTNKXpUMedQunO4358GN2B
         /wO+3KYd5DiatNBWF6a4qLLjOCnF/f5W6230Lc7VGCL9egAk2CwCTLmcBulJjH1s8YIG
         x+EOomKUfQY0o44UuDuADJMoloKMaUYFoHIbWx1Bd63TvN9iOJtzmDeEDdKntUVE1zxq
         ZwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686279474; x=1688871474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HToRMbjEfF32G7y+HBABiwU4xsZoxeB+rbGn180KkfA=;
        b=ZMY6A+QKjmHiSVxSoPYVPVSgmUtkTkyIwYPT2aHypCw27w98BoZJzAerQK1HTQKKqJ
         2Os234EcF06rt76Vt0KjBiUcWr6r/ZrQswgLQv7oqlJDymWHJeV+XzikGyhx30IXOBMQ
         ZWqnVcbzxqJ2ttPwoIMBw4wp1a9QoeGBq57JwXjPlSnv3Qz4gVH1X2R7+eTeC5rbeAs2
         gO/ZYL4V0b1wxxBo5cd/draLHTrUN3/W5VuBkdmCYPxUZYJ75oXUBgUVPpQBGKHSoVTE
         J5s8v7MmJ3AyC/mWJu3Cg2U2k6G4OtqalbXWhasui6uZMJdwdtoaqHfjcLT5JPXILJuk
         a9og==
X-Gm-Message-State: AC+VfDwnZNPAESCeFdWz2V6gLCG6Z9O96nMuZGIztcVE/xfXmdT3GZBM
	T8NziaZYK1T8nYRdWAVOFKcT+OXgAL2QoS1MhzE=
X-Google-Smtp-Source: ACHHUZ6mV/JegtYg9a3OYHsptX2yAK8VkaQyaSEzAVuedgfTQQ+JvySAn8sfOZl7ffewkdbPg5Ue2moQTeGlsIbdAAU=
X-Received: by 2002:a2e:9d90:0:b0:2b1:e829:a959 with SMTP id
 c16-20020a2e9d90000000b002b1e829a959mr229874ljj.5.1686279473827; Thu, 08 Jun
 2023 19:57:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-2-liangchen.linux@gmail.com> <20230528021708-mutt-send-email-mst@kernel.org>
 <CAKhg4tKzW6akbKLvg1UFpey+Lkiic3hBWh87jyg-a8ASchPvMA@mail.gmail.com>
 <20230529055439-mutt-send-email-mst@kernel.org> <CAKhg4t+64E5oisgwpJvt5zwcAzKpLoNhN-cMutRuiC9D-Z7C5A@mail.gmail.com>
 <CAKhg4tKpBFgGaEq743dvYJxZFavDSyOdqbvc7mE4+_sqeSpgQQ@mail.gmail.com>
 <20230607161724-mutt-send-email-mst@kernel.org> <CACGkMEsTuHShqiruqTA9DOHvSg41s1OyqAhpP+uOwTTq61mzTw@mail.gmail.com>
In-Reply-To: <CACGkMEsTuHShqiruqTA9DOHvSg41s1OyqAhpP+uOwTTq61mzTw@mail.gmail.com>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Fri, 9 Jun 2023 10:57:40 +0800
Message-ID: <CAKhg4tJ-=R6Us5hqDOLG2evnvjcFmhunVO1aXtFAvEe3qzH+EQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] virtio_net: Add page_pool support to improve performance
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xuanzhuo@linux.alibaba.com, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 8:38=E2=80=AFAM Jason Wang <jasowang@redhat.com> wro=
te:
>
> On Thu, Jun 8, 2023 at 4:17=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com=
> wrote:
> >
> > On Wed, Jun 07, 2023 at 05:08:59PM +0800, Liang Chen wrote:
> > > On Tue, May 30, 2023 at 9:19=E2=80=AFAM Liang Chen <liangchen.linux@g=
mail.com> wrote:
> > > >
> > > > On Mon, May 29, 2023 at 5:55=E2=80=AFPM Michael S. Tsirkin <mst@red=
hat.com> wrote:
> > > > >
> > > > > On Mon, May 29, 2023 at 03:27:56PM +0800, Liang Chen wrote:
> > > > > > On Sun, May 28, 2023 at 2:20=E2=80=AFPM Michael S. Tsirkin <mst=
@redhat.com> wrote:
> > > > > > >
> > > > > > > On Fri, May 26, 2023 at 01:46:18PM +0800, Liang Chen wrote:
> > > > > > > > The implementation at the moment uses one page per packet i=
n both the
> > > > > > > > normal and XDP path. In addition, introducing a module para=
meter to enable
> > > > > > > > or disable the usage of page pool (disabled by default).
> > > > > > > >
> > > > > > > > In single-core vm testing environments, it gives a modest p=
erformance gain
> > > > > > > > in the normal path.
> > > > > > > >   Upstream codebase: 47.5 Gbits/sec
> > > > > > > >   Upstream codebase + page_pool support: 50.2 Gbits/sec
> > > > > > > >
> > > > > > > > In multi-core vm testing environments, The most significant=
 performance
> > > > > > > > gain is observed in XDP cpumap:
> > > > > > > >   Upstream codebase: 1.38 Gbits/sec
> > > > > > > >   Upstream codebase + page_pool support: 9.74 Gbits/sec
> > > > > > > >
> > > > > > > > With this foundation, we can further integrate page pool fr=
agmentation and
> > > > > > > > DMA map/unmap support.
> > > > > > > >
> > > > > > > > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > > > > > >
> > > > > > > Why off by default?
> > > > > > > I am guessing it sometimes has performance costs too?
> > > > > > >
> > > > > > >
> > > > > > > What happens if we use page pool for big mode too?
> > > > > > > The less modes we have the better...
> > > > > > >
> > > > > > >
> > > > > >
> > > > > > Sure, now I believe it makes sense to enable it by default. Whe=
n the
> > > > > > packet size is very small, it reduces the likelihood of skb
> > > > > > coalescing. But such cases are rare.
> > > > >
> > > > > small packets are rare? These workloads are easy to create actual=
ly.
> > > > > Pls try and include benchmark with small packet size.
> > > > >
> > > >
> > > > Sure, Thanks!
> > >
> > > Before going ahead and posting v2 patch, I would like to hear more
> > > advice for the cases of small packets. I have done more performance
> > > benchmark with small packets since then. Here is a list of iperf
> > > output,
> > >
> > > With PP and PP fragmenting:
> > > 256K:   [  5] 505.00-510.00 sec  1.34 GBytes  2.31 Gbits/sec    0    =
144 KBytes
> > > 1K:       [  5]  30.00-35.00  sec  4.63 GBytes  7.95 Gbits/sec    0
> > > 223 KBytes
> > > 2K:       [  5]  65.00-70.00  sec  8.33 GBytes  14.3 Gbits/sec    0
> > > 324 KBytes
> > > 4K:       [  5]  30.00-35.00  sec  13.3 GBytes  22.8 Gbits/sec    0
> > > 1.08 MBytes
> > > 8K:       [  5]  50.00-55.00  sec  18.9 GBytes  32.4 Gbits/sec    0
> > > 744 KBytes
> > > 16K:     [  5]  25.00-30.00  sec  24.6 GBytes  42.3 Gbits/sec    0   =
 963 KBytes
> > > 32K:     [  5]  45.00-50.00  sec  29.8 GBytes  51.2 Gbits/sec    0   =
1.25 MBytes
> > > 64K:     [  5]  35.00-40.00  sec  34.0 GBytes  58.4 Gbits/sec    0   =
1.70 MBytes
> > > 128K:   [  5]  45.00-50.00  sec  36.7 GBytes  63.1 Gbits/sec    0   4=
.26 MBytes
> > > 256K:   [  5]  30.00-35.00  sec  40.0 GBytes  68.8 Gbits/sec    0   3=
.20 MBytes
>
> Note that virtio-net driver is lacking things like BQL and others, so
> it might suffer from buffer bloat for TCP performance. Would you mind
> to measure with e.g using testpmd on the vhost to see the rx PPS?
>

No problem. Before we proceed to measure with testpmd, could you
please take a look at the PPS measurements we obtained previously and
see if they are sufficient? Though we will only utilize page pool for
xdp on v2.

netperf -H 192.168.124.197 -p 4444 -t UDP_STREAM -l 0 -- -m $((1))

with page pool:
1.
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:       enp8s0 655092.27      0.35  27508.77      0.03
0.00      0.00      0.00      0.00
2.
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:       enp8s0 654749.87      0.63  27494.42      0.05
0.00      0.00      0.00      0.00
3.
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:       enp8s0 654230.40      0.10  27472.57      0.01
0.00      0.00      0.00      0.00
4.
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:       enp8s0 656661.33      0.15  27574.65      0.01
0.00      0.00      0.00      0.00


without page pool:
1.
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:       enp8s0 646515.20      0.47  27148.60      0.04
0.00      0.00      0.00      0.00
2.
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:       enp8s0 653874.13      0.18  27457.61      0.02
0.00      0.00      0.00      0.00
3.
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:       enp8s0 647246.93      0.15  27179.32      0.01
0.00      0.00      0.00      0.00
4.
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:       enp8s0 650625.07      0.27  27321.18      0.02
0.00      0.00      0.00      0.00


(655092+654749+654230+656661)/(646515+653874+647246+650625) =3D
1.00864886500966031113
On average it gives around 0.8% increase in PPS, and this figure can
be reproduced consistently.

> > >
> > > Without PP:
> > > 256:     [  5] 680.00-685.00 sec  1.57 GBytes  2.69 Gbits/sec    0   =
 359 KBytes
> > > 1K:      [  5]  75.00-80.00  sec  5.47 GBytes  9.40 Gbits/sec    0   =
 730 KBytes
> > > 2K:      [  5]  65.00-70.00  sec  9.46 GBytes  16.2 Gbits/sec    0   =
1.99 MBytes
> > > 4K:      [  5]  30.00-35.00  sec  14.5 GBytes  25.0 Gbits/sec    0   =
1.20 MBytes
> > > 8K:      [  5]  45.00-50.00  sec  19.9 GBytes  34.1 Gbits/sec    0   =
1.72 MBytes
> > > 16K:    [  5]   5.00-10.00  sec  23.8 GBytes  40.9 Gbits/sec    0   2=
.90 MBytes
> > > 32K:    [  5]  15.00-20.00  sec  28.0 GBytes  48.1 Gbits/sec    0   3=
.03 MBytes
> > > 64K:    [  5]  60.00-65.00  sec  31.8 GBytes  54.6 Gbits/sec    0   3=
.05 MBytes
> > > 128K:  [  5]  45.00-50.00  sec  33.0 GBytes  56.6 Gbits/sec    1   3.=
03 MBytes
> > > 256K:  [  5]  25.00-30.00  sec  34.7 GBytes  59.6 Gbits/sec    0   3.=
11 MBytes
> > >
> > >
> > > The major factor contributing to the performance drop is the reductio=
n
> > > of skb coalescing. Additionally, without the page pool, small packets
> > > can still benefit from the allocation of 8 continuous pages by
> > > breaking them down into smaller pieces. This effectively reduces the
> > > frequency of page allocation from the buddy system. For instance, the
> > > arrival of 32 1K packets only triggers one alloc_page call. Therefore=
,
> > > the benefits of using a page pool are limited in such cases.
>
> I wonder if we can improve page pool in this case anyhow.
>

We would like to make the effort to enhance skb coalecsing to be more
friendly with page pool buffers. But that involves modifications to
some core data structure of mm.


> > In fact,
> > > without page pool fragmenting enabled, it can even hinder performance
> > > from this perspective.
> > >
> > > Upon further consideration, I tend to believe making page pool the
> > > default option may not be appropriate. As you pointed out, we cannot
> > > simply ignore the performance impact on small packets. Any comments o=
n
> > > this will be much appreciated.
> > >
> > >
> > > Thanks,
> > > Liang
> >
> >
> > So, let's only use page pool for XDP then?
>
> +1
>
> We can start from this.
>
> Thanks
>
> >
> > >
> > > > > > The usage of page pool for big mode is being evaluated now. Tha=
nks!
> > > > > >
> > > > > > > > ---
> > > > > > > >  drivers/net/virtio_net.c | 188 +++++++++++++++++++++++++++=
+++---------
> > > > > > > >  1 file changed, 146 insertions(+), 42 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_=
net.c
> > > > > > > > index c5dca0d92e64..99c0ca0c1781 100644
> > > > > > > > --- a/drivers/net/virtio_net.c
> > > > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > > > @@ -31,6 +31,9 @@ module_param(csum, bool, 0444);
> > > > > > > >  module_param(gso, bool, 0444);
> > > > > > > >  module_param(napi_tx, bool, 0644);
> > > > > > > >
> > > > > > > > +static bool page_pool_enabled;
> > > > > > > > +module_param(page_pool_enabled, bool, 0400);
> > > > > > > > +
> > > > > > > >  /* FIXME: MTU in config. */
> > > > > > > >  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_L=
EN)
> > > > > > > >  #define GOOD_COPY_LEN        128
> > > > > > > > @@ -159,6 +162,9 @@ struct receive_queue {
> > > > > > > >       /* Chain pages by the private ptr. */
> > > > > > > >       struct page *pages;
> > > > > > > >
> > > > > > > > +     /* Page pool */
> > > > > > > > +     struct page_pool *page_pool;
> > > > > > > > +
> > > > > > > >       /* Average packet length for mergeable receive buffer=
s. */
> > > > > > > >       struct ewma_pkt_len mrg_avg_pkt_len;
> > > > > > > >
> > > > > > > > @@ -459,6 +465,14 @@ static struct sk_buff *virtnet_build_s=
kb(void *buf, unsigned int buflen,
> > > > > > > >       return skb;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +static void virtnet_put_page(struct receive_queue *rq, str=
uct page *page)
> > > > > > > > +{
> > > > > > > > +     if (rq->page_pool)
> > > > > > > > +             page_pool_put_full_page(rq->page_pool, page, =
true);
> > > > > > > > +     else
> > > > > > > > +             put_page(page);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > >  /* Called from bottom half context */
> > > > > > > >  static struct sk_buff *page_to_skb(struct virtnet_info *vi=
,
> > > > > > > >                                  struct receive_queue *rq,
> > > > > > > > @@ -555,7 +569,7 @@ static struct sk_buff *page_to_skb(stru=
ct virtnet_info *vi,
> > > > > > > >       hdr =3D skb_vnet_hdr(skb);
> > > > > > > >       memcpy(hdr, hdr_p, hdr_len);
> > > > > > > >       if (page_to_free)
> > > > > > > > -             put_page(page_to_free);
> > > > > > > > +             virtnet_put_page(rq, page_to_free);
> > > > > > > >
> > > > > > > >       return skb;
> > > > > > > >  }
> > > > > > > > @@ -802,7 +816,7 @@ static int virtnet_xdp_xmit(struct net_=
device *dev,
> > > > > > > >       return ret;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > -static void put_xdp_frags(struct xdp_buff *xdp)
> > > > > > > > +static void put_xdp_frags(struct xdp_buff *xdp, struct rec=
eive_queue *rq)
> > > > > > > >  {
> > > > > > > >       struct skb_shared_info *shinfo;
> > > > > > > >       struct page *xdp_page;
> > > > > > > > @@ -812,7 +826,7 @@ static void put_xdp_frags(struct xdp_bu=
ff *xdp)
> > > > > > > >               shinfo =3D xdp_get_shared_info_from_buff(xdp)=
;
> > > > > > > >               for (i =3D 0; i < shinfo->nr_frags; i++) {
> > > > > > > >                       xdp_page =3D skb_frag_page(&shinfo->f=
rags[i]);
> > > > > > > > -                     put_page(xdp_page);
> > > > > > > > +                     virtnet_put_page(rq, xdp_page);
> > > > > > > >               }
> > > > > > > >       }
> > > > > > > >  }
> > > > > > > > @@ -903,7 +917,11 @@ static struct page *xdp_linearize_page=
(struct receive_queue *rq,
> > > > > > > >       if (page_off + *len + tailroom > PAGE_SIZE)
> > > > > > > >               return NULL;
> > > > > > > >
> > > > > > > > -     page =3D alloc_page(GFP_ATOMIC);
> > > > > > > > +     if (rq->page_pool)
> > > > > > > > +             page =3D page_pool_dev_alloc_pages(rq->page_p=
ool);
> > > > > > > > +     else
> > > > > > > > +             page =3D alloc_page(GFP_ATOMIC);
> > > > > > > > +
> > > > > > > >       if (!page)
> > > > > > > >               return NULL;
> > > > > > > >
> > > > > > > > @@ -926,21 +944,24 @@ static struct page *xdp_linearize_pag=
e(struct receive_queue *rq,
> > > > > > > >                * is sending packet larger than the MTU.
> > > > > > > >                */
> > > > > > > >               if ((page_off + buflen + tailroom) > PAGE_SIZ=
E) {
> > > > > > > > -                     put_page(p);
> > > > > > > > +                     virtnet_put_page(rq, p);
> > > > > > > >                       goto err_buf;
> > > > > > > >               }
> > > > > > > >
> > > > > > > >               memcpy(page_address(page) + page_off,
> > > > > > > >                      page_address(p) + off, buflen);
> > > > > > > >               page_off +=3D buflen;
> > > > > > > > -             put_page(p);
> > > > > > > > +             virtnet_put_page(rq, p);
> > > > > > > >       }
> > > > > > > >
> > > > > > > >       /* Headroom does not contribute to packet length */
> > > > > > > >       *len =3D page_off - VIRTIO_XDP_HEADROOM;
> > > > > > > >       return page;
> > > > > > > >  err_buf:
> > > > > > > > -     __free_pages(page, 0);
> > > > > > > > +     if (rq->page_pool)
> > > > > > > > +             page_pool_put_full_page(rq->page_pool, page, =
true);
> > > > > > > > +     else
> > > > > > > > +             __free_pages(page, 0);
> > > > > > > >       return NULL;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > @@ -1144,7 +1165,7 @@ static void mergeable_buf_free(struct=
 receive_queue *rq, int num_buf,
> > > > > > > >               }
> > > > > > > >               stats->bytes +=3D len;
> > > > > > > >               page =3D virt_to_head_page(buf);
> > > > > > > > -             put_page(page);
> > > > > > > > +             virtnet_put_page(rq, page);
> > > > > > > >       }
> > > > > > > >  }
> > > > > > > >
> > > > > > > > @@ -1264,7 +1285,7 @@ static int virtnet_build_xdp_buff_mrg=
(struct net_device *dev,
> > > > > > > >               cur_frag_size =3D truesize;
> > > > > > > >               xdp_frags_truesz +=3D cur_frag_size;
> > > > > > > >               if (unlikely(len > truesize - room || cur_fra=
g_size > PAGE_SIZE)) {
> > > > > > > > -                     put_page(page);
> > > > > > > > +                     virtnet_put_page(rq, page);
> > > > > > > >                       pr_debug("%s: rx error: len %u exceed=
s truesize %lu\n",
> > > > > > > >                                dev->name, len, (unsigned lo=
ng)(truesize - room));
> > > > > > > >                       dev->stats.rx_length_errors++;
> > > > > > > > @@ -1283,7 +1304,7 @@ static int virtnet_build_xdp_buff_mrg=
(struct net_device *dev,
> > > > > > > >       return 0;
> > > > > > > >
> > > > > > > >  err:
> > > > > > > > -     put_xdp_frags(xdp);
> > > > > > > > +     put_xdp_frags(xdp, rq);
> > > > > > > >       return -EINVAL;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > @@ -1344,7 +1365,10 @@ static void *mergeable_xdp_get_buf(s=
truct virtnet_info *vi,
> > > > > > > >               if (*len + xdp_room > PAGE_SIZE)
> > > > > > > >                       return NULL;
> > > > > > > >
> > > > > > > > -             xdp_page =3D alloc_page(GFP_ATOMIC);
> > > > > > > > +             if (rq->page_pool)
> > > > > > > > +                     xdp_page =3D page_pool_dev_alloc_page=
s(rq->page_pool);
> > > > > > > > +             else
> > > > > > > > +                     xdp_page =3D alloc_page(GFP_ATOMIC);
> > > > > > > >               if (!xdp_page)
> > > > > > > >                       return NULL;
> > > > > > > >
> > > > > > > > @@ -1354,7 +1378,7 @@ static void *mergeable_xdp_get_buf(st=
ruct virtnet_info *vi,
> > > > > > > >
> > > > > > > >       *frame_sz =3D PAGE_SIZE;
> > > > > > > >
> > > > > > > > -     put_page(*page);
> > > > > > > > +     virtnet_put_page(rq, *page);
> > > > > > > >
> > > > > > > >       *page =3D xdp_page;
> > > > > > > >
> > > > > > > > @@ -1400,6 +1424,8 @@ static struct sk_buff *receive_mergea=
ble_xdp(struct net_device *dev,
> > > > > > > >               head_skb =3D build_skb_from_xdp_buff(dev, vi,=
 &xdp, xdp_frags_truesz);
> > > > > > > >               if (unlikely(!head_skb))
> > > > > > > >                       break;
> > > > > > > > +             if (rq->page_pool)
> > > > > > > > +                     skb_mark_for_recycle(head_skb);
> > > > > > > >               return head_skb;
> > > > > > > >
> > > > > > > >       case XDP_TX:
> > > > > > > > @@ -1410,10 +1436,10 @@ static struct sk_buff *receive_merg=
eable_xdp(struct net_device *dev,
> > > > > > > >               break;
> > > > > > > >       }
> > > > > > > >
> > > > > > > > -     put_xdp_frags(&xdp);
> > > > > > > > +     put_xdp_frags(&xdp, rq);
> > > > > > > >
> > > > > > > >  err_xdp:
> > > > > > > > -     put_page(page);
> > > > > > > > +     virtnet_put_page(rq, page);
> > > > > > > >       mergeable_buf_free(rq, num_buf, dev, stats);
> > > > > > > >
> > > > > > > >       stats->xdp_drops++;
> > > > > > > > @@ -1467,6 +1493,9 @@ static struct sk_buff *receive_mergea=
ble(struct net_device *dev,
> > > > > > > >       head_skb =3D page_to_skb(vi, rq, page, offset, len, t=
ruesize, headroom);
> > > > > > > >       curr_skb =3D head_skb;
> > > > > > > >
> > > > > > > > +     if (rq->page_pool)
> > > > > > > > +             skb_mark_for_recycle(curr_skb);
> > > > > > > > +
> > > > > > > >       if (unlikely(!curr_skb))
> > > > > > > >               goto err_skb;
> > > > > > > >       while (--num_buf) {
> > > > > > > > @@ -1509,6 +1538,8 @@ static struct sk_buff *receive_mergea=
ble(struct net_device *dev,
> > > > > > > >                       curr_skb =3D nskb;
> > > > > > > >                       head_skb->truesize +=3D nskb->truesiz=
e;
> > > > > > > >                       num_skb_frags =3D 0;
> > > > > > > > +                     if (rq->page_pool)
> > > > > > > > +                             skb_mark_for_recycle(curr_skb=
);
> > > > > > > >               }
> > > > > > > >               if (curr_skb !=3D head_skb) {
> > > > > > > >                       head_skb->data_len +=3D len;
> > > > > > > > @@ -1517,7 +1548,7 @@ static struct sk_buff *receive_mergea=
ble(struct net_device *dev,
> > > > > > > >               }
> > > > > > > >               offset =3D buf - page_address(page);
> > > > > > > >               if (skb_can_coalesce(curr_skb, num_skb_frags,=
 page, offset)) {
> > > > > > > > -                     put_page(page);
> > > > > > > > +                     virtnet_put_page(rq, page);
> > > > > > > >                       skb_coalesce_rx_frag(curr_skb, num_sk=
b_frags - 1,
> > > > > > > >                                            len, truesize);
> > > > > > > >               } else {
> > > > > > > > @@ -1530,7 +1561,7 @@ static struct sk_buff *receive_mergea=
ble(struct net_device *dev,
> > > > > > > >       return head_skb;
> > > > > > > >
> > > > > > > >  err_skb:
> > > > > > > > -     put_page(page);
> > > > > > > > +     virtnet_put_page(rq, page);
> > > > > > > >       mergeable_buf_free(rq, num_buf, dev, stats);
> > > > > > > >
> > > > > > > >  err_buf:
> > > > > > > > @@ -1737,31 +1768,40 @@ static int add_recvbuf_mergeable(st=
ruct virtnet_info *vi,
> > > > > > > >        * disabled GSO for XDP, it won't be a big issue.
> > > > > > > >        */
> > > > > > > >       len =3D get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_le=
n, room);
> > > > > > > > -     if (unlikely(!skb_page_frag_refill(len + room, alloc_=
frag, gfp)))
> > > > > > > > -             return -ENOMEM;
> > > > > > > > +     if (rq->page_pool) {
> > > > > > > > +             struct page *page;
> > > > > > > >
> > > > > > > > -     buf =3D (char *)page_address(alloc_frag->page) + allo=
c_frag->offset;
> > > > > > > > -     buf +=3D headroom; /* advance address leaving hole at=
 front of pkt */
> > > > > > > > -     get_page(alloc_frag->page);
> > > > > > > > -     alloc_frag->offset +=3D len + room;
> > > > > > > > -     hole =3D alloc_frag->size - alloc_frag->offset;
> > > > > > > > -     if (hole < len + room) {
> > > > > > > > -             /* To avoid internal fragmentation, if there =
is very likely not
> > > > > > > > -              * enough space for another buffer, add the r=
emaining space to
> > > > > > > > -              * the current buffer.
> > > > > > > > -              * XDP core assumes that frame_size of xdp_bu=
ff and the length
> > > > > > > > -              * of the frag are PAGE_SIZE, so we disable t=
he hole mechanism.
> > > > > > > > -              */
> > > > > > > > -             if (!headroom)
> > > > > > > > -                     len +=3D hole;
> > > > > > > > -             alloc_frag->offset +=3D hole;
> > > > > > > > -     }
> > > > > > > > +             page =3D page_pool_dev_alloc_pages(rq->page_p=
ool);
> > > > > > > > +             if (unlikely(!page))
> > > > > > > > +                     return -ENOMEM;
> > > > > > > > +             buf =3D (char *)page_address(page);
> > > > > > > > +             buf +=3D headroom; /* advance address leaving=
 hole at front of pkt */
> > > > > > > > +     } else {
> > > > > > > > +             if (unlikely(!skb_page_frag_refill(len + room=
, alloc_frag, gfp)))
> > > > > > > > +                     return -ENOMEM;
> > > > > > > >
> > > > > > > > +             buf =3D (char *)page_address(alloc_frag->page=
) + alloc_frag->offset;
> > > > > > > > +             buf +=3D headroom; /* advance address leaving=
 hole at front of pkt */
> > > > > > > > +             get_page(alloc_frag->page);
> > > > > > > > +             alloc_frag->offset +=3D len + room;
> > > > > > > > +             hole =3D alloc_frag->size - alloc_frag->offse=
t;
> > > > > > > > +             if (hole < len + room) {
> > > > > > > > +                     /* To avoid internal fragmentation, i=
f there is very likely not
> > > > > > > > +                      * enough space for another buffer, a=
dd the remaining space to
> > > > > > > > +                      * the current buffer.
> > > > > > > > +                      * XDP core assumes that frame_size o=
f xdp_buff and the length
> > > > > > > > +                      * of the frag are PAGE_SIZE, so we d=
isable the hole mechanism.
> > > > > > > > +                      */
> > > > > > > > +                     if (!headroom)
> > > > > > > > +                             len +=3D hole;
> > > > > > > > +                     alloc_frag->offset +=3D hole;
> > > > > > > > +             }
> > > > > > > > +     }
> > > > > > > >       sg_init_one(rq->sg, buf, len);
> > > > > > > >       ctx =3D mergeable_len_to_ctx(len + room, headroom);
> > > > > > > >       err =3D virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, bu=
f, ctx, gfp);
> > > > > > > >       if (err < 0)
> > > > > > > > -             put_page(virt_to_head_page(buf));
> > > > > > > > +             virtnet_put_page(rq, virt_to_head_page(buf));
> > > > > > > >
> > > > > > > >       return err;
> > > > > > > >  }
> > > > > > > > @@ -1994,8 +2034,15 @@ static int virtnet_enable_queue_pair=
(struct virtnet_info *vi, int qp_index)
> > > > > > > >       if (err < 0)
> > > > > > > >               return err;
> > > > > > > >
> > > > > > > > -     err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].=
xdp_rxq,
> > > > > > > > -                                      MEM_TYPE_PAGE_SHARED=
, NULL);
> > > > > > > > +     if (vi->rq[qp_index].page_pool)
> > > > > > > > +             err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp=
_index].xdp_rxq,
> > > > > > > > +                                              MEM_TYPE_PAG=
E_POOL,
> > > > > > > > +                                              vi->rq[qp_in=
dex].page_pool);
> > > > > > > > +     else
> > > > > > > > +             err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp=
_index].xdp_rxq,
> > > > > > > > +                                              MEM_TYPE_PAG=
E_SHARED,
> > > > > > > > +                                              NULL);
> > > > > > > > +
> > > > > > > >       if (err < 0)
> > > > > > > >               goto err_xdp_reg_mem_model;
> > > > > > > >
> > > > > > > > @@ -2951,6 +2998,7 @@ static void virtnet_get_strings(struc=
t net_device *dev, u32 stringset, u8 *data)
> > > > > > > >                               ethtool_sprintf(&p, "tx_queue=
_%u_%s", i,
> > > > > > > >                                               virtnet_sq_st=
ats_desc[j].desc);
> > > > > > > >               }
> > > > > > > > +             page_pool_ethtool_stats_get_strings(p);
> > > > > > > >               break;
> > > > > > > >       }
> > > > > > > >  }
> > > > > > > > @@ -2962,12 +3010,30 @@ static int virtnet_get_sset_count(s=
truct net_device *dev, int sset)
> > > > > > > >       switch (sset) {
> > > > > > > >       case ETH_SS_STATS:
> > > > > > > >               return vi->curr_queue_pairs * (VIRTNET_RQ_STA=
TS_LEN +
> > > > > > > > -                                            VIRTNET_SQ_STA=
TS_LEN);
> > > > > > > > +                                            VIRTNET_SQ_STA=
TS_LEN +
> > > > > > > > +                                             (page_pool_en=
abled && vi->mergeable_rx_bufs ?
> > > > > > > > +                                              page_pool_et=
htool_stats_get_count() : 0));
> > > > > > > >       default:
> > > > > > > >               return -EOPNOTSUPP;
> > > > > > > >       }
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +static void virtnet_get_page_pool_stats(struct net_device =
*dev, u64 *data)
> > > > > > > > +{
> > > > > > > > +#ifdef CONFIG_PAGE_POOL_STATS
> > > > > > > > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > > > > > > > +     struct page_pool_stats pp_stats =3D {};
> > > > > > > > +     int i;
> > > > > > > > +
> > > > > > > > +     for (i =3D 0; i < vi->curr_queue_pairs; i++) {
> > > > > > > > +             if (!vi->rq[i].page_pool)
> > > > > > > > +                     continue;
> > > > > > > > +             page_pool_get_stats(vi->rq[i].page_pool, &pp_=
stats);
> > > > > > > > +     }
> > > > > > > > +     page_pool_ethtool_stats_get(data, &pp_stats);
> > > > > > > > +#endif /* CONFIG_PAGE_POOL_STATS */
> > > > > > > > +}
> > > > > > > > +
> > > > > > > >  static void virtnet_get_ethtool_stats(struct net_device *d=
ev,
> > > > > > > >                                     struct ethtool_stats *s=
tats, u64 *data)
> > > > > > > >  {
> > > > > > > > @@ -3003,6 +3069,8 @@ static void virtnet_get_ethtool_stats=
(struct net_device *dev,
> > > > > > > >               } while (u64_stats_fetch_retry(&sq->stats.syn=
cp, start));
> > > > > > > >               idx +=3D VIRTNET_SQ_STATS_LEN;
> > > > > > > >       }
> > > > > > > > +
> > > > > > > > +     virtnet_get_page_pool_stats(dev, &data[idx]);
> > > > > > > >  }
> > > > > > > >
> > > > > > > >  static void virtnet_get_channels(struct net_device *dev,
> > > > > > > > @@ -3623,6 +3691,8 @@ static void virtnet_free_queues(struc=
t virtnet_info *vi)
> > > > > > > >       for (i =3D 0; i < vi->max_queue_pairs; i++) {
> > > > > > > >               __netif_napi_del(&vi->rq[i].napi);
> > > > > > > >               __netif_napi_del(&vi->sq[i].napi);
> > > > > > > > +             if (vi->rq[i].page_pool)
> > > > > > > > +                     page_pool_destroy(vi->rq[i].page_pool=
);
> > > > > > > >       }
> > > > > > > >
> > > > > > > >       /* We called __netif_napi_del(),
> > > > > > > > @@ -3679,12 +3749,19 @@ static void virtnet_rq_free_unused_=
buf(struct virtqueue *vq, void *buf)
> > > > > > > >       struct virtnet_info *vi =3D vq->vdev->priv;
> > > > > > > >       int i =3D vq2rxq(vq);
> > > > > > > >
> > > > > > > > -     if (vi->mergeable_rx_bufs)
> > > > > > > > -             put_page(virt_to_head_page(buf));
> > > > > > > > -     else if (vi->big_packets)
> > > > > > > > +     if (vi->mergeable_rx_bufs) {
> > > > > > > > +             if (vi->rq[i].page_pool) {
> > > > > > > > +                     page_pool_put_full_page(vi->rq[i].pag=
e_pool,
> > > > > > > > +                                             virt_to_head_=
page(buf),
> > > > > > > > +                                             true);
> > > > > > > > +             } else {
> > > > > > > > +                     put_page(virt_to_head_page(buf));
> > > > > > > > +             }
> > > > > > > > +     } else if (vi->big_packets) {
> > > > > > > >               give_pages(&vi->rq[i], buf);
> > > > > > > > -     else
> > > > > > > > +     } else {
> > > > > > > >               put_page(virt_to_head_page(buf));
> > > > > > > > +     }
> > > > > > > >  }
> > > > > > > >
> > > > > > > >  static void free_unused_bufs(struct virtnet_info *vi)
> > > > > > > > @@ -3718,6 +3795,26 @@ static void virtnet_del_vqs(struct v=
irtnet_info *vi)
> > > > > > > >       virtnet_free_queues(vi);
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +static void virtnet_alloc_page_pool(struct receive_queue *=
rq)
> > > > > > > > +{
> > > > > > > > +     struct virtio_device *vdev =3D rq->vq->vdev;
> > > > > > > > +
> > > > > > > > +     struct page_pool_params pp_params =3D {
> > > > > > > > +             .order =3D 0,
> > > > > > > > +             .pool_size =3D rq->vq->num_max,
> > > > > > > > +             .nid =3D dev_to_node(vdev->dev.parent),
> > > > > > > > +             .dev =3D vdev->dev.parent,
> > > > > > > > +             .offset =3D 0,
> > > > > > > > +     };
> > > > > > > > +
> > > > > > > > +     rq->page_pool =3D page_pool_create(&pp_params);
> > > > > > > > +     if (IS_ERR(rq->page_pool)) {
> > > > > > > > +             dev_warn(&vdev->dev, "page pool creation fail=
ed: %ld\n",
> > > > > > > > +                      PTR_ERR(rq->page_pool));
> > > > > > > > +             rq->page_pool =3D NULL;
> > > > > > > > +     }
> > > > > > > > +}
> > > > > > > > +
> > > > > > > >  /* How large should a single buffer be so a queue full of =
these can fit at
> > > > > > > >   * least one full packet?
> > > > > > > >   * Logic below assumes the mergeable buffer header is used=
.
> > > > > > > > @@ -3801,6 +3898,13 @@ static int virtnet_find_vqs(struct v=
irtnet_info *vi)
> > > > > > > >               vi->rq[i].vq =3D vqs[rxq2vq(i)];
> > > > > > > >               vi->rq[i].min_buf_len =3D mergeable_min_buf_l=
en(vi, vi->rq[i].vq);
> > > > > > > >               vi->sq[i].vq =3D vqs[txq2vq(i)];
> > > > > > > > +
> > > > > > > > +             if (page_pool_enabled && vi->mergeable_rx_buf=
s)
> > > > > > > > +                     virtnet_alloc_page_pool(&vi->rq[i]);
> > > > > > > > +             else
> > > > > > > > +                     dev_warn(&vi->vdev->dev,
> > > > > > > > +                              "page pool only support merg=
eable mode\n");
> > > > > > > > +
> > > > > > > >       }
> > > > > > > >
> > > > > > > >       /* run here: ret =3D=3D 0. */
> > > > > > > > --
> > > > > > > > 2.31.1
> > > > > > >
> > > > >
> >
>

