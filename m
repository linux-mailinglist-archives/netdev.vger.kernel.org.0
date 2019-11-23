Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2061080E7
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 23:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKWWeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 17:34:08 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32844 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWWeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 17:34:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id t5so11440884ljk.0;
        Sat, 23 Nov 2019 14:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eOe6/mRvm2L/t7NITJg4X6UO/dFe/C8CCS3uftqkLug=;
        b=rtcwGul3NHOGud3LxEFpp/+cMXfIw11O3t9iIiBL+S7YQRXAvK+j3FrcRqWs4WXZqg
         Ou1aI2WyMVxnIzVScykIZMqjg9lgwMKawuW3cwEfubz2VG2PfFZSpoIWVjG5togHXeH6
         WIwqHzvOoKpoARECk2D+5iZvvj72zFjLolP0oo7hHHIrTC/RCzQAqql060V9r2HeK8qD
         scsYboiH7uiEatxFvuq9cD+uMr0k57H7rBRB30YKlhw/TKQMTTZjOCHWOdAxGg/aj1rm
         zu77sbcsaaJdRCE/nN0LwHULmv/4KfzP00wiy9gXZpTqe11UOx92fELCQKQxp6MazW1g
         q6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eOe6/mRvm2L/t7NITJg4X6UO/dFe/C8CCS3uftqkLug=;
        b=lwz76LRcpcic7Ip67B9riHeyVu6SJQEVGHF/j4z3dDsymd9NIna7Pc4UoHP4p82dKO
         3w3YcJNwCVU3kOxDaeoLwjyru6CuQRJUpuJHfDx0xWZLIQkr8wOoKyIdt3TSedn48OQy
         Cy9UKYFas6zg88oqr7YP6RgXIWjuiR7fJV6WL6LcxkUi2TfqjVQVRpdAEAS9et7W9Y4Q
         cQdO0UxOTX5TCoQrnHoXslcMhEfG9ZNyAzA+rvJd6sriVpOaavjlHkFi+uZQQCD9E5cI
         +cPeaMC95SPb9/SuGx5TJlaqHvZB1i+s0xHtE0WCDqPXImvywdc5no/2uAHSS6Fvz4Jy
         E3mA==
X-Gm-Message-State: APjAAAV8I1FaMEw9a/K0MggoXxCffo2hTrnrnU0ccqpd3uiWEc04e2ty
        xg2QFxrJDC98I0vS0ieA8clU/biaKmA8q5Xff6M=
X-Google-Smtp-Source: APXvYqxoUhZ2sJ5vur4emU042PrwB0nGZF61rZ08Tk2FwObMMHdl/I8Rxlf8UZEXipAZUl0WsSdWBQUXlqc23UkzT38=
X-Received: by 2002:a2e:b4da:: with SMTP id r26mr15689023ljm.153.1574548432985;
 Sat, 23 Nov 2019 14:33:52 -0800 (PST)
MIME-Version: 1.0
References: <20191122013636.1041-1-jcfaracco@gmail.com> <20191122052506-mutt-send-email-mst@kernel.org>
 <CAENf94KX1XR4_KXz9KLZQ09Ngeaq2qzYY5OE68xJMXMu13SuEg@mail.gmail.com> <20191122080233-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191122080233-mutt-send-email-mst@kernel.org>
From:   Julio Faracco <jcfaracco@gmail.com>
Date:   Sat, 23 Nov 2019 20:33:40 -0200
Message-ID: <CAENf94L7zU6JoM+19F+__b6W4mpe5Na=ayd+eYe4aZ+EBABmiA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] drivers: net: virtio_net: Implement a
 dev_watchdog handler
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Daiane Mendes <dnmendes76@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em sex., 22 de nov. de 2019 =C3=A0s 11:53, Michael S. Tsirkin
<mst@redhat.com> escreveu:
>
> On Fri, Nov 22, 2019 at 09:59:58AM -0300, Julio Faracco wrote:
> > Hi Michael,
> >
> > Em sex., 22 de nov. de 2019 =C3=A0s 07:31, Michael S. Tsirkin
> > <mst@redhat.com> escreveu:
> > >
> > > On Thu, Nov 21, 2019 at 10:36:36PM -0300, Julio Faracco wrote:
> > > > Driver virtio_net is not handling error events for TX provided by
> > > > dev_watchdog. This event is reached when transmission queue is havi=
ng
> > > > problems to transmit packets. This could happen for any reason. To
> > > > enable it, driver should have .ndo_tx_timeout implemented.
> > > >
> > > > This commit brings back virtnet_reset method to recover TX queues f=
rom a
> > > > error state. That function is called by schedule_work method and it=
 puts
> > > > the reset function into work queue.
> > > >
> > > > As the error cause is unknown at this moment, it would be better to
> > > > reset all queues.
> > > >
> > > > Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
> > > > Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
> > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > > v1-v2: Tag `net-next` was included to indentify where patch would b=
e
> > > > applied.
> > > > ---
> > > >  drivers/net/virtio_net.c | 95 ++++++++++++++++++++++++++++++++++++=
+++-
> > > >  1 file changed, 94 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 4d7d5434cc5d..31890d77eaf2 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -75,6 +75,7 @@ struct virtnet_sq_stats {
> > > >       u64 xdp_tx;
> > > >       u64 xdp_tx_drops;
> > > >       u64 kicks;
> > > > +     u64 tx_timeouts;
> > > >  };
> > > >
> > > >  struct virtnet_rq_stats {
> > > > @@ -98,6 +99,7 @@ static const struct virtnet_stat_desc virtnet_sq_=
stats_desc[] =3D {
> > > >       { "xdp_tx",             VIRTNET_SQ_STAT(xdp_tx) },
> > > >       { "xdp_tx_drops",       VIRTNET_SQ_STAT(xdp_tx_drops) },
> > > >       { "kicks",              VIRTNET_SQ_STAT(kicks) },
> > > > +     { "tx_timeouts",        VIRTNET_SQ_STAT(tx_timeouts) },
> > > >  };
> > > >
> > > >  static const struct virtnet_stat_desc virtnet_rq_stats_desc[] =3D =
{
> > > > @@ -211,6 +213,9 @@ struct virtnet_info {
> > > >       /* Work struct for config space updates */
> > > >       struct work_struct config_work;
> > > >
> > > > +     /* Work struct for resetting the virtio-net driver. */
> > > > +     struct work_struct reset_work;
> > > > +
> > > >       /* Does the affinity hint is set for virtqueues? */
> > > >       bool affinity_hint_set;
> > > >
> > > > @@ -1721,7 +1726,7 @@ static void virtnet_stats(struct net_device *=
dev,
> > > >       int i;
> > > >
> > > >       for (i =3D 0; i < vi->max_queue_pairs; i++) {
> > > > -             u64 tpackets, tbytes, rpackets, rbytes, rdrops;
> > > > +             u64 tpackets, tbytes, terrors, rpackets, rbytes, rdro=
ps;
> > > >               struct receive_queue *rq =3D &vi->rq[i];
> > > >               struct send_queue *sq =3D &vi->sq[i];
> > > >
> > > > @@ -1729,6 +1734,7 @@ static void virtnet_stats(struct net_device *=
dev,
> > > >                       start =3D u64_stats_fetch_begin_irq(&sq->stat=
s.syncp);
> > > >                       tpackets =3D sq->stats.packets;
> > > >                       tbytes   =3D sq->stats.bytes;
> > > > +                     terrors  =3D sq->stats.tx_timeouts;
> > > >               } while (u64_stats_fetch_retry_irq(&sq->stats.syncp, =
start));
> > > >
> > > >               do {
> > > > @@ -1743,6 +1749,7 @@ static void virtnet_stats(struct net_device *=
dev,
> > > >               tot->rx_bytes   +=3D rbytes;
> > > >               tot->tx_bytes   +=3D tbytes;
> > > >               tot->rx_dropped +=3D rdrops;
> > > > +             tot->tx_errors  +=3D terrors;
> > > >       }
> > > >
> > > >       tot->tx_dropped =3D dev->stats.tx_dropped;
> > > > @@ -2578,6 +2585,33 @@ static int virtnet_set_features(struct net_d=
evice *dev,
> > > >       return 0;
> > > >  }
> > > >
> > > > +static void virtnet_tx_timeout(struct net_device *dev)
> > > > +{
> > > > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > > > +     u32 i;
> > > > +
> > > > +     netdev_warn(dev, "TX timeout stats:\n");
> > > > +     /* find the stopped queue the same way dev_watchdog() does */
> > > > +     for (i =3D 0; i < vi->curr_queue_pairs; i++) {
> > > > +             struct send_queue *sq =3D &vi->sq[i];
> > > > +
> > > > +             if (!netif_xmit_stopped(netdev_get_tx_queue(dev, i)))=
 {
> > > > +                     netdev_warn(dev, " Available send queue: %d, =
sq: %s, vq: %d, name: %s\n",
> > > > +                                 i, sq->name, sq->vq->index, sq->v=
q->name);
> > >
> > > What does this mean?
> > >
> > > > +                     continue;
> > > > +             }
> > > > +
> > > > +             u64_stats_update_begin(&sq->stats.syncp);
> > > > +             sq->stats.tx_timeouts++;
> > > > +             u64_stats_update_end(&sq->stats.syncp);
> > > > +
> > > > +             netdev_warn(dev, " Unavailable send queue: %d, sq: %s=
, vq: %d, name: %s\n",
> > > > +                         i, sq->name, sq->vq->index, sq->vq->name)=
;
> > > > +     }
> > >
> > > Can we make the warning less cryptic?
> > > I wonder why don't we get the sq from timeout directly?
> > > Would seem cleaner.
> >
> > I need your help with debbuging information. What kind of field shoud
> > it notify when a TX timeout occurs?
>
> I am just saying this: why don't we add a "txqueue" parameter
> to ndo_tx_timeout? It's not hard - just need to be careful to fix
> all callers. I got the list of files and functions by grepping
> for ndo_tx_timeout. The massaged it with the following script.
>
>
>
>
> #/usr/bin/perl
>
> use strict;
> use warnings;
>
> our $^I =3D '.bak';
>
> my @work =3D (
> ["arch/m68k/emu/nfeth.c", "nfeth_tx_timeout"],
> ["arch/um/drivers/net_kern.c", "uml_net_tx_timeout"],
> ["arch/um/drivers/vector_kern.c", "vector_net_tx_timeout"],
> ["arch/xtensa/platforms/iss/network.c", "iss_net_tx_timeout"],
> ["drivers/char/pcmcia/synclink_cs.c", "hdlcdev_tx_timeout"],
> ["drivers/infiniband/ulp/ipoib/ipoib_main.c", "ipoib_timeout"],
> ["drivers/infiniband/ulp/ipoib/ipoib_main.c", "ipoib_timeout"],
> ["drivers/message/fusion/mptlan.c", "mpt_lan_tx_timeout"],
> ["drivers/misc/sgi-xp/xpnet.c", "xpnet_dev_tx_timeout"],
> ["drivers/net/appletalk/cops.c", "cops_timeout"],
> ["drivers/net/arcnet/arcnet.c", "arcnet_timeout"],
> ["drivers/net/arcnet/com20020.c", "arcnet_timeout"],
> ["drivers/net/ethernet/3com/3c509.c", "el3_tx_timeout"],
> ["drivers/net/ethernet/3com/3c515.c", "corkscrew_timeout"],
> ["drivers/net/ethernet/3com/3c574_cs.c", "el3_tx_timeout"],
> ["drivers/net/ethernet/3com/3c589_cs.c", "el3_tx_timeout"],
> ["drivers/net/ethernet/3com/3c59x.c", "vortex_tx_timeout"],
> ["drivers/net/ethernet/3com/3c59x.c", "vortex_tx_timeout"],
> ["drivers/net/ethernet/3com/typhoon.c", "typhoon_tx_timeout"],
> ["drivers/net/ethernet/8390/8390.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/8390p.c", "eip_tx_timeout"],
> ["drivers/net/ethernet/8390/ax88796.c", "ax_ei_tx_timeout"],
> ["drivers/net/ethernet/8390/axnet_cs.c", "axnet_tx_timeout"],
> ["drivers/net/ethernet/8390/etherh.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/8390/hydra.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/8390/mac8390.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/8390/mcf8390.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/8390/ne2k-pci.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/pcnet_cs.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/smc-ultra.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/wd.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/zorro8390.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/adaptec/starfire.c", "tx_timeout"],
> ["drivers/net/ethernet/agere/et131x.c", "et131x_tx_timeout"],
> ["drivers/net/ethernet/allwinner/sun4i-emac.c", "emac_timeout"],
> ["drivers/net/ethernet/alteon/acenic.c", "ace_watchdog"],
> ["drivers/net/ethernet/amazon/ena/ena_netdev.c", "ena_tx_timeout"],
> ["drivers/net/ethernet/amd/a2065.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/am79c961a.c", "am79c961_timeout"],
> ["drivers/net/ethernet/amd/amd8111e.c", "amd8111e_tx_timeout"],
> ["drivers/net/ethernet/amd/ariadne.c", "ariadne_tx_timeout"],
> ["drivers/net/ethernet/amd/atarilance.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/au1000_eth.c", "au1000_tx_timeout"],
> ["drivers/net/ethernet/amd/declance.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/lance.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/mvme147.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/ni65.c", "ni65_timeout"],
> ["drivers/net/ethernet/amd/nmclan_cs.c", "mace_tx_timeout"],
> ["drivers/net/ethernet/amd/pcnet32.c", "pcnet32_tx_timeout"],
> ["drivers/net/ethernet/amd/sunlance.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/xgbe/xgbe-drv.c", "xgbe_tx_timeout"],
> ["drivers/net/ethernet/apm/xgene-v2/main.c", "xge_timeout"],
> ["drivers/net/ethernet/apm/xgene/xgene_enet_main.c", "xgene_enet_timeout"=
],
> ["drivers/net/ethernet/apple/macmace.c", "mace_tx_timeout"],
> ["drivers/net/ethernet/atheros/ag71xx.c", "ag71xx_tx_timeout"],
> ["drivers/net/ethernet/atheros/alx/main.c", "alx_tx_timeout"],
> ["drivers/net/ethernet/atheros/atl1c/atl1c_main.c", "atl1c_tx_timeout"],
> ["drivers/net/ethernet/atheros/atl1e/atl1e_main.c", "atl1e_tx_timeout"],
> ["drivers/net/ethernet/atheros/atlx/atl1.c", "atlx_tx_timeout"],
> ["drivers/net/ethernet/atheros/atlx/atl2.c", "atl2_tx_timeout"],
> ["drivers/net/ethernet/broadcom/b44.c", "b44_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bcmsysport.c", "bcm_sysport_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bnx2.c", "bnx2_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c", "bnx2x_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bnxt/bnxt.c", "bnxt_tx_timeout"],
> ["drivers/net/ethernet/broadcom/genet/bcmgenet.c", "bcmgenet_timeout"],
> ["drivers/net/ethernet/broadcom/sb1250-mac.c", "sbmac_tx_timeout"],
> ["drivers/net/ethernet/broadcom/tg3.c", "tg3_tx_timeout"],
> ["drivers/net/ethernet/calxeda/xgmac.c", "xgmac_tx_timeout"],
> ["drivers/net/ethernet/cavium/liquidio/lio_main.c", "liquidio_tx_timeout"=
],
> ["drivers/net/ethernet/cavium/liquidio/lio_vf_main.c", "liquidio_tx_timeo=
ut"],
> ["drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c", "lio_vf_rep_tx_time=
out"],
> ["drivers/net/ethernet/cavium/thunder/nicvf_main.c", "nicvf_tx_timeout"],
> ["drivers/net/ethernet/cirrus/cs89x0.c", "net_timeout"],
> ["drivers/net/ethernet/cisco/enic/enic_main.c", "enic_tx_timeout"],
> ["drivers/net/ethernet/cisco/enic/enic_main.c", "enic_tx_timeout"],
> ["drivers/net/ethernet/cortina/gemini.c", "gmac_tx_timeout"],
> ["drivers/net/ethernet/davicom/dm9000.c", "dm9000_timeout"],
> ["drivers/net/ethernet/dec/tulip/de2104x.c", "de_tx_timeout"],
> ["drivers/net/ethernet/dec/tulip/tulip_core.c", "tulip_tx_timeout"],
> ["drivers/net/ethernet/dec/tulip/winbond-840.c", "tx_timeout"],
> ["drivers/net/ethernet/dlink/dl2k.c", "rio_tx_timeout"],
> ["drivers/net/ethernet/dlink/sundance.c", "tx_timeout"],
> ["drivers/net/ethernet/emulex/benet/be_main.c", "be_tx_timeout"],
> ["drivers/net/ethernet/ethoc.c", "ethoc_tx_timeout"],
> ["drivers/net/ethernet/faraday/ftgmac100.c", "ftgmac100_tx_timeout"],
> ["drivers/net/ethernet/fealnx.c", "fealnx_tx_timeout"],
> ["drivers/net/ethernet/freescale/dpaa/dpaa_eth.c", "dpaa_tx_timeout"],
> ["drivers/net/ethernet/freescale/fec_main.c", "fec_timeout"],
> ["drivers/net/ethernet/freescale/fec_mpc52xx.c", "mpc52xx_fec_tx_timeout"=
],
> ["drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c", "fs_timeout"],
> ["drivers/net/ethernet/freescale/gianfar.c", "gfar_timeout"],
> ["drivers/net/ethernet/freescale/ucc_geth.c", "ucc_geth_timeout"],
> ["drivers/net/ethernet/fujitsu/fmvj18x_cs.c", "fjn_tx_timeout"],
> ["drivers/net/ethernet/google/gve/gve_main.c", "gve_tx_timeout"],
> ["drivers/net/ethernet/hisilicon/hip04_eth.c", "hip04_timeout"],
> ["drivers/net/ethernet/hisilicon/hix5hd2_gmac.c", "hix5hd2_net_timeout"],
> ["drivers/net/ethernet/hisilicon/hns/hns_enet.c", "hns_nic_net_timeout"],
> ["drivers/net/ethernet/hisilicon/hns3/hns3_enet.c", "hns3_nic_net_timeout=
"],
> ["drivers/net/ethernet/huawei/hinic/hinic_main.c", "hinic_tx_timeout"],
> ["drivers/net/ethernet/i825xx/82596.c", "i596_tx_timeout"],
> ["drivers/net/ethernet/i825xx/ether1.c", "ether1_timeout"],
> ["drivers/net/ethernet/i825xx/lib82596.c", "i596_tx_timeout"],
> ["drivers/net/ethernet/i825xx/sun3_82586.c", "sun3_82586_timeout"],
> ["drivers/net/ethernet/ibm/ehea/ehea_main.c", "ehea_tx_watchdog"],
> ["drivers/net/ethernet/ibm/emac/core.c", "emac_tx_timeout"],
> ["drivers/net/ethernet/ibm/emac/core.c", "emac_tx_timeout"],
> ["drivers/net/ethernet/ibm/ibmvnic.c", "ibmvnic_tx_timeout"],
> ["drivers/net/ethernet/intel/e100.c", "e100_tx_timeout"],
> ["drivers/net/ethernet/intel/e1000/e1000_main.c", "e1000_tx_timeout"],
> ["drivers/net/ethernet/intel/e1000e/netdev.c", "e1000_tx_timeout"],
> ["drivers/net/ethernet/intel/fm10k/fm10k_netdev.c", "fm10k_tx_timeout"],
> ["drivers/net/ethernet/intel/i40e/i40e_main.c", "i40e_tx_timeout"],
> ["drivers/net/ethernet/intel/iavf/iavf_main.c", "iavf_tx_timeout"],
> ["drivers/net/ethernet/intel/ice/ice_main.c", "ice_tx_timeout"],
> ["drivers/net/ethernet/intel/ice/ice_main.c", "ice_tx_timeout"],
> ["drivers/net/ethernet/intel/igb/igb_main.c", "igb_tx_timeout"],
> ["drivers/net/ethernet/intel/igbvf/netdev.c", "igbvf_tx_timeout"],
> ["drivers/net/ethernet/intel/ixgb/ixgb_main.c", "ixgb_tx_timeout"],
> ["drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c", "adapter->netdev->ne=
tdev_ops->ndo_tx_timeout(adapter->netdev);"],
> ["drivers/net/ethernet/intel/ixgbe/ixgbe_main.c", "ixgbe_tx_timeout"],
> ["drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c", "ixgbevf_tx_timeout=
"],
> ["drivers/net/ethernet/jme.c", "jme_tx_timeout"],
> ["drivers/net/ethernet/korina.c", "korina_tx_timeout"],
> ["drivers/net/ethernet/lantiq_etop.c", "ltq_etop_tx_timeout"],
> ["drivers/net/ethernet/marvell/mv643xx_eth.c", "mv643xx_eth_tx_timeout"],
> ["drivers/net/ethernet/marvell/pxa168_eth.c", "pxa168_eth_tx_timeout"],
> ["drivers/net/ethernet/marvell/skge.c", "skge_tx_timeout"],
> ["drivers/net/ethernet/marvell/sky2.c", "sky2_tx_timeout"],
> ["drivers/net/ethernet/marvell/sky2.c", "sky2_tx_timeout"],
> ["drivers/net/ethernet/mediatek/mtk_eth_soc.c", "mtk_tx_timeout"],
> ["drivers/net/ethernet/mellanox/mlx4/en_netdev.c", "mlx4_en_tx_timeout"],
> ["drivers/net/ethernet/mellanox/mlx4/en_netdev.c", "mlx4_en_tx_timeout"],
> ["drivers/net/ethernet/mellanox/mlx5/core/en_main.c", "mlx5e_tx_timeout"]=
,
> ["drivers/net/ethernet/micrel/ks8842.c", "ks8842_tx_timeout"],
> ["drivers/net/ethernet/micrel/ksz884x.c", "netdev_tx_timeout"],
> ["drivers/net/ethernet/microchip/enc28j60.c", "enc28j60_tx_timeout"],
> ["drivers/net/ethernet/microchip/encx24j600.c", "encx24j600_tx_timeout"],
> ["drivers/net/ethernet/natsemi/jazzsonic.c", "sonic_tx_timeout"],
> ["drivers/net/ethernet/natsemi/macsonic.c", "sonic_tx_timeout"],
> ["drivers/net/ethernet/natsemi/natsemi.c", "ns_tx_timeout"],
> ["drivers/net/ethernet/natsemi/ns83820.c", "ns83820_tx_timeout"],
> ["drivers/net/ethernet/natsemi/xtsonic.c", "sonic_tx_timeout"],
> ["drivers/net/ethernet/neterion/s2io.c", "s2io_tx_watchdog"],
> ["drivers/net/ethernet/neterion/vxge/vxge-main.c", "vxge_tx_watchdog"],
> ["drivers/net/ethernet/netronome/nfp/nfp_net_common.c", "nfp_net_tx_timeo=
ut"],
> ["drivers/net/ethernet/nvidia/forcedeth.c", "nv_tx_timeout"],
> ["drivers/net/ethernet/nvidia/forcedeth.c", "nv_tx_timeout"],
> ["drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c", "pch_gbe_tx_time=
out"],
> ["drivers/net/ethernet/packetengines/hamachi.c", "hamachi_tx_timeout"],
> ["drivers/net/ethernet/packetengines/yellowfin.c", "yellowfin_tx_timeout"=
],
> ["drivers/net/ethernet/pensando/ionic/ionic_lif.c", "ionic_tx_timeout"],
> ["drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c", "netxen_tx_timeo=
ut"],
> ["drivers/net/ethernet/qlogic/qla3xxx.c", "ql3xxx_tx_timeout"],
> ["drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c", "qlcnic_tx_timeout"]=
,
> ["drivers/net/ethernet/qualcomm/emac/emac.c", "emac_tx_timeout"],
> ["drivers/net/ethernet/qualcomm/qca_spi.c", "qcaspi_netdev_tx_timeout"],
> ["drivers/net/ethernet/qualcomm/qca_uart.c", "qcauart_netdev_tx_timeout"]=
,
> ["drivers/net/ethernet/rdc/r6040.c", "r6040_tx_timeout"],
> ["drivers/net/ethernet/realtek/8139cp.c", "cp_tx_timeout"],
> ["drivers/net/ethernet/realtek/8139too.c", "rtl8139_tx_timeout"],
> ["drivers/net/ethernet/realtek/atp.c", "tx_timeout"],
> ["drivers/net/ethernet/realtek/r8169_main.c", "rtl8169_tx_timeout"],
> ["drivers/net/ethernet/renesas/ravb_main.c", "ravb_tx_timeout"],
> ["drivers/net/ethernet/renesas/sh_eth.c", "sh_eth_tx_timeout"],
> ["drivers/net/ethernet/renesas/sh_eth.c", "sh_eth_tx_timeout"],
> ["drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c", "sxgbe_tx_timeout"],
> ["drivers/net/ethernet/seeq/ether3.c", "ether3_timeout"],
> ["drivers/net/ethernet/seeq/sgiseeq.c", "timeout"],
> ["drivers/net/ethernet/sfc/efx.c", "efx_watchdog"],
> ["drivers/net/ethernet/sfc/falcon/efx.c", "ef4_watchdog"],
> ["drivers/net/ethernet/sgi/ioc3-eth.c", "ioc3_timeout"],
> ["drivers/net/ethernet/sgi/meth.c", "meth_tx_timeout"],
> ["drivers/net/ethernet/silan/sc92031.c", "sc92031_tx_timeout"],
> ["drivers/net/ethernet/sis/sis190.c", "sis190_tx_timeout"],
> ["drivers/net/ethernet/sis/sis900.c", "sis900_tx_timeout"],
> ["drivers/net/ethernet/smsc/epic100.c", "epic_tx_timeout"],
> ["drivers/net/ethernet/smsc/smc911x.c", "smc911x_timeout"],
> ["drivers/net/ethernet/smsc/smc9194.c", "smc_timeout"],
> ["drivers/net/ethernet/smsc/smc91c92_cs.c", "smc_tx_timeout"],
> ["drivers/net/ethernet/smsc/smc91x.c", "smc_timeout"],
> ["drivers/net/ethernet/stmicro/stmmac/stmmac_main.c", "stmmac_tx_timeout"=
],
> ["drivers/net/ethernet/sun/cassini.c", "cas_tx_timeout"],
> ["drivers/net/ethernet/sun/ldmvsw.c", "sunvnet_tx_timeout_common"],
> ["drivers/net/ethernet/sun/niu.c", "niu_tx_timeout"],
> ["drivers/net/ethernet/sun/sunbmac.c", "bigmac_tx_timeout"],
> ["drivers/net/ethernet/sun/sungem.c", "gem_tx_timeout"],
> ["drivers/net/ethernet/sun/sunhme.c", "happy_meal_tx_timeout"],
> ["drivers/net/ethernet/sun/sunqe.c", "qe_tx_timeout"],
> ["drivers/net/ethernet/sun/sunvnet.c", "sunvnet_tx_timeout_common"],
> ["drivers/net/ethernet/synopsys/dwc-xlgmac-net.c", "xlgmac_tx_timeout"],
> ["drivers/net/ethernet/ti/cpmac.c", "cpmac_tx_timeout"],
> ["drivers/net/ethernet/ti/cpsw.c", "cpsw_ndo_tx_timeout"],
> ["drivers/net/ethernet/ti/davinci_emac.c", "emac_dev_tx_timeout"],
> ["drivers/net/ethernet/ti/netcp_core.c", "netcp_ndo_tx_timeout"],
> ["drivers/net/ethernet/ti/tlan.c", "tlan_tx_timeout"],
> ["drivers/net/ethernet/toshiba/ps3_gelic_net.c", "gelic_net_tx_timeout"],
> ["drivers/net/ethernet/toshiba/ps3_gelic_wireless.c", "gelic_net_tx_timeo=
ut"],
> ["drivers/net/ethernet/toshiba/spider_net.c", "spider_net_tx_timeout"],
> ["drivers/net/ethernet/toshiba/tc35815.c", "tc35815_tx_timeout"],
> ["drivers/net/ethernet/via/via-rhine.c", "rhine_tx_timeout"],
> ["drivers/net/ethernet/wiznet/w5100.c", "w5100_tx_timeout"],
> ["drivers/net/ethernet/wiznet/w5300.c", "w5300_tx_timeout"],
> ["drivers/net/ethernet/xilinx/xilinx_emaclite.c", "xemaclite_tx_timeout"]=
,
> ["drivers/net/ethernet/xircom/xirc2ps_cs.c", "xirc_tx_timeout"],
> ["drivers/net/fjes/fjes_main.c", "fjes_tx_retry"],
> ["drivers/net/slip/slip.c", "sl_tx_timeout"],
> ["drivers/net/usb/aqc111.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/asix_devices.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/asix_devices.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/asix_devices.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/ax88172a.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/ax88179_178a.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/catc.c", "catc_tx_timeout"],
> ["drivers/net/usb/cdc_mbim.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/cdc_ncm.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/dm9601.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/hso.c", "hso_net_tx_timeout"],
> ["drivers/net/usb/int51x1.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/ipheth.c", "ipheth_tx_timeout"],
> ["drivers/net/usb/kaweth.c", "kaweth_tx_timeout"],
> ["drivers/net/usb/lan78xx.c", "lan78xx_tx_timeout"],
> ["drivers/net/usb/mcs7830.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/pegasus.c", "pegasus_tx_timeout"],
> ["drivers/net/usb/qmi_wwan.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/r8152.c", "rtl8152_tx_timeout"],
> ["drivers/net/usb/rndis_host.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/rtl8150.c", "rtl8150_tx_timeout"],
> ["drivers/net/usb/sierra_net.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/smsc75xx.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/smsc95xx.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/sr9700.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/sr9800.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/usbnet.c", "usbnet_tx_timeout"],
> ["drivers/net/vmxnet3/vmxnet3_drv.c", "vmxnet3_tx_timeout"],
> ["drivers/net/wan/cosa.c", "cosa_net_timeout"],
> ["drivers/net/wan/farsync.c", "fst_tx_timeout"],
> ["drivers/net/wan/fsl_ucc_hdlc.c", "uhdlc_tx_timeout"],
> ["drivers/net/wan/lmc/lmc_main.c", "lmc_driver_timeout"],
> ["drivers/net/wan/x25_asy.c", "x25_asy_timeout"],
> ["drivers/net/wimax/i2400m/netdev.c", "i2400m_tx_timeout"],
> ["drivers/net/wireless/intel/ipw2x00/ipw2100.c", "ipw2100_tx_timeout"],
> ["drivers/net/wireless/intersil/hostap/hostap_main.c", "prism2_tx_timeout=
"],
> ["drivers/net/wireless/intersil/hostap/hostap_main.c", "prism2_tx_timeout=
"],
> ["drivers/net/wireless/intersil/hostap/hostap_main.c", "prism2_tx_timeout=
"],
> ["drivers/net/wireless/intersil/orinoco/main.c", "orinoco_tx_timeout"],
> ["drivers/net/wireless/intersil/orinoco/orinoco_usb.c", "orinoco_tx_timeo=
ut"],
> ["drivers/net/wireless/intersil/prism54/islpci_dev.c", "islpci_eth_tx_tim=
eout"],
> ["drivers/net/wireless/marvell/mwifiex/main.c", "mwifiex_tx_timeout"],
> ["drivers/net/wireless/quantenna/qtnfmac/core.c", "qtnf_netdev_tx_timeout=
"],
> ["drivers/net/wireless/rndis_wlan.c", "usbnet_tx_timeout"],
> ["drivers/net/wireless/wl3501_cs.c", "wl3501_tx_timeout"],
> ["drivers/net/wireless/zydas/zd1201.c", "zd1201_tx_timeout"],
> ["drivers/s390/net/qeth_l2_main.c", "qeth_tx_timeout"],
> ["drivers/s390/net/qeth_l2_main.c", "qeth_tx_timeout"],
> ["drivers/s390/net/qeth_l3_main.c", "qeth_tx_timeout"],
> ["drivers/s390/net/qeth_l3_main.c", "qeth_tx_timeout"],
> ["drivers/staging/ks7010/ks_wlan_net.c", "ks_wlan_tx_timeout"],
> ["drivers/staging/qlge/qlge_main.c", "qlge_tx_timeout"],
> ["drivers/staging/rtl8192e/rtl8192e/rtl_core.c", "_rtl92e_tx_timeout"],
> ["drivers/staging/rtl8192u/r8192U_core.c", "tx_timeout"],
> ["drivers/staging/unisys/visornic/visornic_main.c", "visornic_xmit_timeou=
t"],
> ["drivers/staging/wlan-ng/p80211netdev.c", "p80211knetdev_tx_timeout"],
> ["drivers/tty/n_gsm.c", "gsm_mux_net_tx_timeout"],
> ["drivers/tty/synclink.c", "hdlcdev_tx_timeout"],
> ["drivers/tty/synclink_gt.c", "hdlcdev_tx_timeout"],
> ["drivers/tty/synclinkmp.c", "hdlcdev_tx_timeout"],
> ["net/atm/lec.c", "lec_tx_timeout"],
> ["net/bluetooth/bnep/netdev.c", "bnep_net_timeout"]
> );
>
> for my $p (@work) {
>         my @pair =3D @$p;
>         my $file =3D $pair[0];
>         my $func =3D $pair[1];
>         print STDERR $file , ": ", $func,"\n";
>         our @ARGV =3D ($file);
>         while (<ARGV>) {
>                 if (m/($func\(struct\s+net_device\s+\*[A-Za-z_][A-Za-z-0-=
9]*)(\))/) {
>                         print STDERR "found $1+$2 in $file\n";
>                 }
>                 if (s/($func\(struct\s+net_device\s+\*[A-Za-z_][A-Za-z-0-=
9]*)(\))/$1, int txqueue$2/) {
>                         print STDERR "$func found in $file\n";
>                 }
>                 print;
>         }
> }
>
> Result is at the bottom. If you like this approach, feel free to
> include as the 1st patch in your series.
>
> > Or we can keep the default WARN_ONCE, but we need a minimum method impl=
emented.
> > We cannot get timeout directly because it needs to be implemented to
> > get it directly.
> > Net core scheduler checks if this handler was implemented to throw a
> > TX timeout. See:
> >
> >     void __netdev_watchdog_up(struct net_device *dev)
> >     {
> >            if (dev->netdev_ops->ndo_tx_timeout) {
> >                    if (dev->watchdog_timeo <=3D 0)
> >                         dev->watchdog_timeo =3D 5*HZ;
> >                    if (!mod_timer(&dev->watchdog_timer,
> >                                   round_jiffies(jiffies + dev->watchdog=
_timeo)))
> >                            dev_hold(dev);
> >            }
> >     }
> >
> > >
> > > > +
> > > > +     schedule_work(&vi->reset_work);
> > > > +}
> > > > +
> > > >  static const struct net_device_ops virtnet_netdev =3D {
> > > >       .ndo_open            =3D virtnet_open,
> > > >       .ndo_stop            =3D virtnet_close,
> > > > @@ -2593,6 +2627,7 @@ static const struct net_device_ops virtnet_ne=
tdev =3D {
> > > >       .ndo_features_check     =3D passthru_features_check,
> > > >       .ndo_get_phys_port_name =3D virtnet_get_phys_port_name,
> > > >       .ndo_set_features       =3D virtnet_set_features,
> > > > +     .ndo_tx_timeout         =3D virtnet_tx_timeout,
> > > >  };
> > > >
> > > >  static void virtnet_config_changed_work(struct work_struct *work)
> > > > @@ -2982,6 +3017,62 @@ static int virtnet_validate(struct virtio_de=
vice *vdev)
> > > >       return 0;
> > > >  }
> > > >
> > > > +static void _remove_vq_common(struct virtnet_info *vi)
> > > > +{
> > > > +     vi->vdev->config->reset(vi->vdev);
> > > > +
> > > > +     /* Free unused buffers in both send and recv, if any. */
> > > > +     free_unused_bufs(vi);
> > > > +
> > > > +     _free_receive_bufs(vi);
> > > > +
> > > > +     free_receive_page_frags(vi);
> > > > +
> > > > +     virtnet_del_vqs(vi);
> > > > +}
> > > > +
> > > > +static int _virtnet_reset(struct virtnet_info *vi)
> > > > +{
> > > > +     struct virtio_device *vdev =3D vi->vdev;
> > > > +     int ret;
> > > > +
> > > > +     virtio_config_disable(vdev);
> > > > +     vdev->failed =3D vdev->config->get_status(vdev) & VIRTIO_CONF=
IG_S_FAILED;
> > > > +
> > > > +     virtnet_freeze_down(vdev);
> > > > +     _remove_vq_common(vi);
> > > > +
> > > > +     virtio_add_status(vdev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> > > > +     virtio_add_status(vdev, VIRTIO_CONFIG_S_DRIVER);
> > > > +
> > > > +     ret =3D virtio_finalize_features(vdev);
> > > > +     if (ret)
> > > > +             goto err;
> > > > +
> > > > +     ret =3D virtnet_restore_up(vdev);
> > > > +     if (ret)
> > > > +             goto err;
> > > > +
> > > > +     ret =3D _virtnet_set_queues(vi, vi->curr_queue_pairs);
> > > > +     if (ret)
> > > > +             goto err;
> > > > +
> > > > +     virtio_add_status(vdev, VIRTIO_CONFIG_S_DRIVER_OK);
> > > > +     virtio_config_enable(vdev);
> > >
> > >
> > > Is this enough? E.g. all RX mode programming has been lost.
> >
> > IMHO virtio net has a nice performance. You can take days to see a TX t=
imeout.
> > If it is happening frequently, there is something wrong with device.
>
> It is rather easy if you attach a debugger to qemu though ;)
>
> > So, again, IMHO I don't think it would be too problematic.
> >
> > >
> > >
> > >
> > > > +     return 0;
> > > > +err:
> > > > +     virtio_add_status(vdev, VIRTIO_CONFIG_S_FAILED);
> > > > +     return ret;
> > > > +}
> > > > +
> > > > +static void virtnet_reset(struct work_struct *work)
> > > > +{
> > > > +     struct virtnet_info *vi =3D
> > > > +             container_of(work, struct virtnet_info, reset_work);
> > > > +
> > > > +     _virtnet_reset(vi);
> > > > +}
> > > > +
> > > >  static int virtnet_probe(struct virtio_device *vdev)
> > > >  {
> > > >       int i, err =3D -ENOMEM;
> > > > @@ -3011,6 +3102,7 @@ static int virtnet_probe(struct virtio_device=
 *vdev)
> > > >       dev->netdev_ops =3D &virtnet_netdev;
> > > >       dev->features =3D NETIF_F_HIGHDMA;
> > > >
> > > > +     dev->watchdog_timeo =3D 5 * HZ;
> > > >       dev->ethtool_ops =3D &virtnet_ethtool_ops;
> > > >       SET_NETDEV_DEV(dev, &vdev->dev);
> > > >
> > >
> > > Is there a way to make this tuneable from ethtool?
> >
> > Yes and no.
> > You can do that obviously, but it is not a common field to tun. If you
> > compare with other drivers.
>
> Maybe we should just add a field specifying the timeout from the host.
> I'll ponder this over the weekend.
>
> > >
> > > > @@ -3068,6 +3160,7 @@ static int virtnet_probe(struct virtio_device=
 *vdev)
> > > >       vdev->priv =3D vi;
> > > >
> > > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > > > +     INIT_WORK(&vi->reset_work, virtnet_reset);
> > > >
> > > >       /* If we can receive ANY GSO packets, we must allocate large =
ones. */
> > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > > --
> > > > 2.17.1
>
> --->
>
> netdev: pass the stuck queue to the timeout handler
>
> This allows incrementing the correct timeout statistic without any mess.
> Down the road, devices can learn to reset just the specific queue.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> Warning: untested.
>

Question...
Wouldn't be better to create a module parameter instead change the
function scope?
I'm asking it because how many modules would effectively take advantage of =
it?

>
> diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
> index a4ebd2445eda..8e06e7407854 100644
> --- a/arch/m68k/emu/nfeth.c
> +++ b/arch/m68k/emu/nfeth.c
> @@ -167,7 +167,7 @@ static int nfeth_xmit(struct sk_buff *skb, struct net=
_device *dev)
>         return 0;
>  }
>
> -static void nfeth_tx_timeout(struct net_device *dev)
> +static void nfeth_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         dev->stats.tx_errors++;
>         netif_wake_queue(dev);
> diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
> index 327b728f7244..81f0b3b5a212 100644
> --- a/arch/um/drivers/net_kern.c
> +++ b/arch/um/drivers/net_kern.c
> @@ -247,7 +247,7 @@ static void uml_net_set_multicast_list(struct net_dev=
ice *dev)
>         return;
>  }
>
> -static void uml_net_tx_timeout(struct net_device *dev)
> +static void uml_net_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         netif_trans_update(dev);
>         netif_wake_queue(dev);
> diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.=
c
> index 769ffbd9e9a6..5bbe08be15a1 100644
> --- a/arch/um/drivers/vector_kern.c
> +++ b/arch/um/drivers/vector_kern.c
> @@ -1298,7 +1298,7 @@ static void vector_net_set_multicast_list(struct ne=
t_device *dev)
>         return;
>  }
>
> -static void vector_net_tx_timeout(struct net_device *dev)
> +static void vector_net_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct vector_private *vp =3D netdev_priv(dev);
>
> diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/=
iss/network.c
> index fa9f3893b002..2f55536fcf56 100644
> --- a/arch/xtensa/platforms/iss/network.c
> +++ b/arch/xtensa/platforms/iss/network.c
> @@ -455,7 +455,7 @@ static void iss_net_set_multicast_list(struct net_dev=
ice *dev)
>  {
>  }
>
> -static void iss_net_tx_timeout(struct net_device *dev)
> +static void iss_net_tx_timeout(struct net_device *dev, int txqueue)
>  {
>  }
>
> diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/sync=
link_cs.c
> index 82f9a6a814ae..bd07fa968266 100644
> --- a/drivers/char/pcmcia/synclink_cs.c
> +++ b/drivers/char/pcmcia/synclink_cs.c
> @@ -4169,7 +4169,7 @@ static int hdlcdev_ioctl(struct net_device *dev, st=
ruct ifreq *ifr, int cmd)
>   *
>   * dev  pointer to network device structure
>   */
> -static void hdlcdev_tx_timeout(struct net_device *dev)
> +static void hdlcdev_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         MGSLPC_INFO *info =3D dev_to_port(dev);
>         unsigned long flags;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_main.c
> index ac0583ff280d..7287b87265a2 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1182,7 +1182,7 @@ static netdev_tx_t ipoib_start_xmit(struct sk_buff =
*skb, struct net_device *dev)
>         return NETDEV_TX_OK;
>  }
>
> -static void ipoib_timeout(struct net_device *dev)
> +static void ipoib_timeout(struct net_device *dev, int txqueue)
>  {
>         struct ipoib_dev_priv *priv =3D ipoib_priv(dev);
>
> diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mpt=
lan.c
> index ebc00d47abf5..f3244bd6f27f 100644
> --- a/drivers/message/fusion/mptlan.c
> +++ b/drivers/message/fusion/mptlan.c
> @@ -552,7 +552,7 @@ mpt_lan_close(struct net_device *dev)
>  /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/
>  /* Tx timeout handler. */
>  static void
> -mpt_lan_tx_timeout(struct net_device *dev)
> +mpt_lan_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct mpt_lan_priv *priv =3D netdev_priv(dev);
>         MPT_ADAPTER *mpt_dev =3D priv->mpt_dev;
> diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
> index f7d610a22347..cf760a5ba26b 100644
> --- a/drivers/misc/sgi-xp/xpnet.c
> +++ b/drivers/misc/sgi-xp/xpnet.c
> @@ -496,7 +496,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff *skb, struct=
 net_device *dev)
>   * Deal with transmit timeouts coming from the network layer.
>   */
>  static void
> -xpnet_dev_tx_timeout(struct net_device *dev)
> +xpnet_dev_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         dev->stats.tx_errors++;
>  }
> diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
> index b3c63d2f16aa..f6f05e0f78ed 100644
> --- a/drivers/net/appletalk/cops.c
> +++ b/drivers/net/appletalk/cops.c
> @@ -189,7 +189,7 @@ static int  cops_nodeid (struct net_device *dev, int =
nodeid);
>
>  static irqreturn_t cops_interrupt (int irq, void *dev_id);
>  static void cops_poll(struct timer_list *t);
> -static void cops_timeout(struct net_device *dev);
> +static void cops_timeout(struct net_device *dev, int txqueue);
>  static void cops_rx (struct net_device *dev);
>  static netdev_tx_t  cops_send_packet (struct sk_buff *skb,
>                                             struct net_device *dev);
> @@ -844,7 +844,7 @@ static void cops_rx(struct net_device *dev)
>          netif_rx(skb);
>  }
>
> -static void cops_timeout(struct net_device *dev)
> +static void cops_timeout(struct net_device *dev, int txqueue)
>  {
>          struct cops_local *lp =3D netdev_priv(dev);
>          int ioaddr =3D dev->base_addr;
> diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
> index 553776cc1d29..af09684cb7cb 100644
> --- a/drivers/net/arcnet/arcnet.c
> +++ b/drivers/net/arcnet/arcnet.c
> @@ -763,7 +763,7 @@ static int go_tx(struct net_device *dev)
>  }
>
>  /* Called by the kernel when transmit times out */
> -void arcnet_timeout(struct net_device *dev)
> +void arcnet_timeout(struct net_device *dev, int txqueue)
>  {
>         unsigned long flags;
>         struct arcnet_local *lp =3D netdev_priv(dev);
> diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3co=
m/3c515.c
> index b15752267c8d..818fa6c4e541 100644
> --- a/drivers/net/ethernet/3com/3c515.c
> +++ b/drivers/net/ethernet/3com/3c515.c
> @@ -371,7 +371,7 @@ static void corkscrew_timer(struct timer_list *t);
>  static netdev_tx_t corkscrew_start_xmit(struct sk_buff *skb,
>                                         struct net_device *dev);
>  static int corkscrew_rx(struct net_device *dev);
> -static void corkscrew_timeout(struct net_device *dev);
> +static void corkscrew_timeout(struct net_device *dev, int txqueue);
>  static int boomerang_rx(struct net_device *dev);
>  static irqreturn_t corkscrew_interrupt(int irq, void *dev_id);
>  static int corkscrew_close(struct net_device *dev);
> @@ -961,7 +961,7 @@ static void corkscrew_timer(struct timer_list *t)
>  #endif                         /* AUTOMEDIA */
>  }
>
> -static void corkscrew_timeout(struct net_device *dev)
> +static void corkscrew_timeout(struct net_device *dev, int txqueue)
>  {
>         int i;
>         struct corkscrew_private *vp =3D netdev_priv(dev);
> diff --git a/drivers/net/ethernet/3com/3c574_cs.c b/drivers/net/ethernet/=
3com/3c574_cs.c
> index 3044a6f35f04..501555116658 100644
> --- a/drivers/net/ethernet/3com/3c574_cs.c
> +++ b/drivers/net/ethernet/3com/3c574_cs.c
> @@ -234,7 +234,7 @@ static void update_stats(struct net_device *dev);
>  static struct net_device_stats *el3_get_stats(struct net_device *dev);
>  static int el3_rx(struct net_device *dev, int worklimit);
>  static int el3_close(struct net_device *dev);
> -static void el3_tx_timeout(struct net_device *dev);
> +static void el3_tx_timeout(struct net_device *dev, int txqueue);
>  static int el3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
>  static void set_rx_mode(struct net_device *dev);
>  static void set_multicast_list(struct net_device *dev);
> @@ -690,7 +690,7 @@ static int el3_open(struct net_device *dev)
>         return 0;
>  }
>
> -static void el3_tx_timeout(struct net_device *dev)
> +static void el3_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         unsigned int ioaddr =3D dev->base_addr;
>
> diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/=
3com/3c589_cs.c
> index 2b2695311bda..0192d77d41d9 100644
> --- a/drivers/net/ethernet/3com/3c589_cs.c
> +++ b/drivers/net/ethernet/3com/3c589_cs.c
> @@ -173,7 +173,7 @@ static void update_stats(struct net_device *dev);
>  static struct net_device_stats *el3_get_stats(struct net_device *dev);
>  static int el3_rx(struct net_device *dev);
>  static int el3_close(struct net_device *dev);
> -static void el3_tx_timeout(struct net_device *dev);
> +static void el3_tx_timeout(struct net_device *dev, int txqueue);
>  static void set_rx_mode(struct net_device *dev);
>  static void set_multicast_list(struct net_device *dev);
>  static const struct ethtool_ops netdev_ethtool_ops;
> @@ -526,7 +526,7 @@ static int el3_open(struct net_device *dev)
>         return 0;
>  }
>
> -static void el3_tx_timeout(struct net_device *dev)
> +static void el3_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         unsigned int ioaddr =3D dev->base_addr;
>
> diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3co=
m/3c59x.c
> index 8785c2ff3825..fbfac5766ec1 100644
> --- a/drivers/net/ethernet/3com/3c59x.c
> +++ b/drivers/net/ethernet/3com/3c59x.c
> @@ -776,7 +776,7 @@ static void set_rx_mode(struct net_device *dev);
>  #ifdef CONFIG_PCI
>  static int vortex_ioctl(struct net_device *dev, struct ifreq *rq, int cm=
d);
>  #endif
> -static void vortex_tx_timeout(struct net_device *dev);
> +static void vortex_tx_timeout(struct net_device *dev, int txqueue);
>  static void acpi_set_WOL(struct net_device *dev);
>  static const struct ethtool_ops vortex_ethtool_ops;
>  static void set_8021q_mode(struct net_device *dev, int enable);
> @@ -1877,7 +1877,7 @@ vortex_timer(struct timer_list *t)
>                 iowrite16(FakeIntr, ioaddr + EL3_CMD);
>  }
>
> -static void vortex_tx_timeout(struct net_device *dev)
> +static void vortex_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct vortex_private *vp =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D vp->ioaddr;
> diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3=
com/typhoon.c
> index be823c186517..44955d3d5367 100644
> --- a/drivers/net/ethernet/3com/typhoon.c
> +++ b/drivers/net/ethernet/3com/typhoon.c
> @@ -2013,7 +2013,7 @@ typhoon_stop_runtime(struct typhoon *tp, int wait_t=
ype)
>  }
>
>  static void
> -typhoon_tx_timeout(struct net_device *dev)
> +typhoon_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct typhoon *tp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390=
/8390.c
> index 78f3e532c600..ef4ecb3a3e31 100644
> --- a/drivers/net/ethernet/8390/8390.c
> +++ b/drivers/net/ethernet/8390/8390.c
> @@ -36,7 +36,7 @@ void ei_set_multicast_list(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(ei_set_multicast_list);
>
> -void ei_tx_timeout(struct net_device *dev)
> +void ei_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         __ei_tx_timeout(dev);
>  }
> diff --git a/drivers/net/ethernet/8390/8390p.c b/drivers/net/ethernet/839=
0/8390p.c
> index 6cf36992a2c6..ecedf62b23a3 100644
> --- a/drivers/net/ethernet/8390/8390p.c
> +++ b/drivers/net/ethernet/8390/8390p.c
> @@ -41,7 +41,7 @@ void eip_set_multicast_list(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(eip_set_multicast_list);
>
> -void eip_tx_timeout(struct net_device *dev)
> +void eip_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         __ei_tx_timeout(dev);
>  }
> diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/=
8390/axnet_cs.c
> index 0b6bbf63f7ca..7b77c9c5141a 100644
> --- a/drivers/net/ethernet/8390/axnet_cs.c
> +++ b/drivers/net/ethernet/8390/axnet_cs.c
> @@ -83,7 +83,7 @@ static netdev_tx_t axnet_start_xmit(struct sk_buff *skb=
,
>                                           struct net_device *dev);
>  static struct net_device_stats *get_stats(struct net_device *dev);
>  static void set_multicast_list(struct net_device *dev);
> -static void axnet_tx_timeout(struct net_device *dev);
> +static void axnet_tx_timeout(struct net_device *dev, int txqueue);
>  static irqreturn_t ei_irq_wrapper(int irq, void *dev_id);
>  static void ei_watchdog(struct timer_list *t);
>  static void axnet_reset_8390(struct net_device *dev);
> @@ -903,7 +903,7 @@ static int ax_close(struct net_device *dev)
>   * completed (or failed) - i.e. never posted a Tx related interrupt.
>   */
>
> -static void axnet_tx_timeout(struct net_device *dev)
> +static void axnet_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         long e8390_base =3D dev->base_addr;
>         struct ei_device *ei_local =3D netdev_priv(dev);
> diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethern=
et/adaptec/starfire.c
> index 816540e6beac..d92d8fc16904 100644
> --- a/drivers/net/ethernet/adaptec/starfire.c
> +++ b/drivers/net/ethernet/adaptec/starfire.c
> @@ -576,7 +576,7 @@ static int  mdio_read(struct net_device *dev, int phy=
_id, int location);
>  static void    mdio_write(struct net_device *dev, int phy_id, int locati=
on, int value);
>  static int     netdev_open(struct net_device *dev);
>  static void    check_duplex(struct net_device *dev);
> -static void    tx_timeout(struct net_device *dev);
> +static void    tx_timeout(struct net_device *dev, int txqueue);
>  static void    init_ring(struct net_device *dev);
>  static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)=
;
>  static irqreturn_t intr_handler(int irq, void *dev_instance);
> @@ -1105,7 +1105,7 @@ static void check_duplex(struct net_device *dev)
>  }
>
>
> -static void tx_timeout(struct net_device *dev)
> +static void tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct netdev_private *np =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D np->base;
> diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/a=
gere/et131x.c
> index 174344c450af..0bf3eb4a505b 100644
> --- a/drivers/net/ethernet/agere/et131x.c
> +++ b/drivers/net/ethernet/agere/et131x.c
> @@ -3811,7 +3811,7 @@ static netdev_tx_t et131x_tx(struct sk_buff *skb, s=
truct net_device *netdev)
>   * specified by the 'tx_timeo" element in the net_device structure (see
>   * et131x_alloc_device() to see how this value is set).
>   */
> -static void et131x_tx_timeout(struct net_device *netdev)
> +static void et131x_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct et131x_adapter *adapter =3D netdev_priv(netdev);
>         struct tx_ring *tx_ring =3D &adapter->tx_ring;
> diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/et=
hernet/allwinner/sun4i-emac.c
> index 0537df06a9b5..c463889d0f56 100644
> --- a/drivers/net/ethernet/allwinner/sun4i-emac.c
> +++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
> @@ -407,7 +407,7 @@ static void emac_init_device(struct net_device *dev)
>  }
>
>  /* Our watchdog timed out. Called by the networking layer */
> -static void emac_timeout(struct net_device *dev)
> +static void emac_timeout(struct net_device *dev, int txqueue)
>  {
>         struct emac_board_info *db =3D netdev_priv(dev);
>         unsigned long flags;
> diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/=
alteon/acenic.c
> index 46b4207d3266..4b5047370b4a 100644
> --- a/drivers/net/ethernet/alteon/acenic.c
> +++ b/drivers/net/ethernet/alteon/acenic.c
> @@ -437,7 +437,7 @@ static const struct ethtool_ops ace_ethtool_ops =3D {
>         .set_link_ksettings =3D ace_set_link_ksettings,
>  };
>
> -static void ace_watchdog(struct net_device *dev);
> +static void ace_watchdog(struct net_device *dev, int txqueue);
>
>  static const struct net_device_ops ace_netdev_ops =3D {
>         .ndo_open               =3D ace_open,
> @@ -1542,7 +1542,7 @@ static void ace_set_rxtx_parms(struct net_device *d=
ev, int jumbo)
>  }
>
>
> -static void ace_watchdog(struct net_device *data)
> +static void ace_watchdog(struct net_device *data, int txqueue)
>  {
>         struct net_device *dev =3D data;
>         struct ace_private *ap =3D netdev_priv(dev);
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/e=
thernet/amazon/ena/ena_netdev.c
> index c487d2a7d6dd..a1fa9f6f4949 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -78,7 +78,7 @@ static void check_for_admin_com_state(struct ena_adapte=
r *adapter);
>  static void ena_destroy_device(struct ena_adapter *adapter, bool gracefu=
l);
>  static int ena_restore_device(struct ena_adapter *adapter);
>
> -static void ena_tx_timeout(struct net_device *dev)
> +static void ena_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct ena_adapter *adapter =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/=
a2065.c
> index 212fe72a190b..6b4d49519fb7 100644
> --- a/drivers/net/ethernet/amd/a2065.c
> +++ b/drivers/net/ethernet/amd/a2065.c
> @@ -522,7 +522,7 @@ static inline int lance_reset(struct net_device *dev)
>         return status;
>  }
>
> -static void lance_tx_timeout(struct net_device *dev)
> +static void lance_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct lance_private *lp =3D netdev_priv(dev);
>         volatile struct lance_regs *ll =3D lp->ll;
> diff --git a/drivers/net/ethernet/amd/am79c961a.c b/drivers/net/ethernet/=
amd/am79c961a.c
> index 0842da492a64..0a34d94c5ab5 100644
> --- a/drivers/net/ethernet/amd/am79c961a.c
> +++ b/drivers/net/ethernet/amd/am79c961a.c
> @@ -422,7 +422,7 @@ static void am79c961_setmulticastlist (struct net_dev=
ice *dev)
>         spin_unlock_irqrestore(&priv->chip_lock, flags);
>  }
>
> -static void am79c961_timeout(struct net_device *dev)
> +static void am79c961_timeout(struct net_device *dev, int txqueue)
>  {
>         printk(KERN_WARNING "%s: transmit timed out, network cable proble=
m?\n",
>                 dev->name);
> diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/a=
md/amd8111e.c
> index 573e88fc8ede..dda342d8e3b4 100644
> --- a/drivers/net/ethernet/amd/amd8111e.c
> +++ b/drivers/net/ethernet/amd/amd8111e.c
> @@ -1569,7 +1569,7 @@ static int amd8111e_enable_link_change(struct amd81=
11e_priv *lp)
>   * failed or the interface is locked up. This function will reinitialize
>   * the hardware.
>   */
> -static void amd8111e_tx_timeout(struct net_device *dev)
> +static void amd8111e_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct amd8111e_priv *lp =3D netdev_priv(dev);
>         int err;
> diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/am=
d/ariadne.c
> index 4b6a5cb85dd2..8f1a67c2fced 100644
> --- a/drivers/net/ethernet/amd/ariadne.c
> +++ b/drivers/net/ethernet/amd/ariadne.c
> @@ -530,7 +530,7 @@ static inline void ariadne_reset(struct net_device *d=
ev)
>         netif_start_queue(dev);
>  }
>
> -static void ariadne_tx_timeout(struct net_device *dev)
> +static void ariadne_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         volatile struct Am79C960 *lance =3D (struct Am79C960 *)dev->base_=
addr;
>
> diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet=
/amd/au1000_eth.c
> index 1793950f0582..18d22dd7933c 100644
> --- a/drivers/net/ethernet/amd/au1000_eth.c
> +++ b/drivers/net/ethernet/amd/au1000_eth.c
> @@ -1014,7 +1014,7 @@ static netdev_tx_t au1000_tx(struct sk_buff *skb, s=
truct net_device *dev)
>   * The Tx ring has been full longer than the watchdog timeout
>   * value. The transmitter must be hung?
>   */
> -static void au1000_tx_timeout(struct net_device *dev)
> +static void au1000_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         netdev_err(dev, "au1000_tx_timeout: dev=3D%p\n", dev);
>         au1000_reset_mac(dev);
> diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/a=
md/declance.c
> index dac4a2fcad6a..2c1986f183c3 100644
> --- a/drivers/net/ethernet/amd/declance.c
> +++ b/drivers/net/ethernet/amd/declance.c
> @@ -884,7 +884,7 @@ static inline int lance_reset(struct net_device *dev)
>         return status;
>  }
>
> -static void lance_tx_timeout(struct net_device *dev)
> +static void lance_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct lance_private *lp =3D netdev_priv(dev);
>         volatile struct lance_regs *ll =3D lp->ll;
> diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/n=
i65.c
> index c6c2a54c1121..f60e33364eb7 100644
> --- a/drivers/net/ethernet/amd/ni65.c
> +++ b/drivers/net/ethernet/amd/ni65.c
> @@ -254,7 +254,7 @@ static int  ni65_lance_reinit(struct net_device *dev)=
;
>  static void ni65_init_lance(struct priv *p,unsigned char*,int,int);
>  static netdev_tx_t ni65_send_packet(struct sk_buff *skb,
>                                     struct net_device *dev);
> -static void  ni65_timeout(struct net_device *dev);
> +static void  ni65_timeout(struct net_device *dev, int txqueue);
>  static int  ni65_close(struct net_device *dev);
>  static int  ni65_alloc_buffer(struct net_device *dev);
>  static void ni65_free_buffer(struct priv *p);
> @@ -1133,7 +1133,7 @@ static void ni65_recv_intr(struct net_device *dev,i=
nt csr0)
>   * kick xmitter ..
>   */
>
> -static void ni65_timeout(struct net_device *dev)
> +static void ni65_timeout(struct net_device *dev, int txqueue)
>  {
>         int i;
>         struct priv *p =3D dev->ml_priv;
> diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/=
amd/nmclan_cs.c
> index 9c152d85840d..8b92f4689ae2 100644
> --- a/drivers/net/ethernet/amd/nmclan_cs.c
> +++ b/drivers/net/ethernet/amd/nmclan_cs.c
> @@ -407,7 +407,7 @@ static int mace_open(struct net_device *dev);
>  static int mace_close(struct net_device *dev);
>  static netdev_tx_t mace_start_xmit(struct sk_buff *skb,
>                                          struct net_device *dev);
> -static void mace_tx_timeout(struct net_device *dev);
> +static void mace_tx_timeout(struct net_device *dev, int txqueue);
>  static irqreturn_t mace_interrupt(int irq, void *dev_id);
>  static struct net_device_stats *mace_get_stats(struct net_device *dev);
>  static int mace_rx(struct net_device *dev, unsigned char RxCnt);
> @@ -837,7 +837,7 @@ mace_start_xmit
>         failed, put skb back into a list."
>  ------------------------------------------------------------------------=
---- */
>
> -static void mace_tx_timeout(struct net_device *dev)
> +static void mace_tx_timeout(struct net_device *dev, int txqueue)
>  {
>    mace_private *lp =3D netdev_priv(dev);
>    struct pcmcia_device *link =3D lp->p_dev;
> diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/am=
d/pcnet32.c
> index f5ad12c10934..29f70450dfe2 100644
> --- a/drivers/net/ethernet/amd/pcnet32.c
> +++ b/drivers/net/ethernet/amd/pcnet32.c
> @@ -314,7 +314,7 @@ static int pcnet32_open(struct net_device *);
>  static int pcnet32_init_ring(struct net_device *);
>  static netdev_tx_t pcnet32_start_xmit(struct sk_buff *,
>                                       struct net_device *);
> -static void pcnet32_tx_timeout(struct net_device *dev);
> +static void pcnet32_tx_timeout(struct net_device *dev, int txqueue);
>  static irqreturn_t pcnet32_interrupt(int, void *);
>  static int pcnet32_close(struct net_device *);
>  static struct net_device_stats *pcnet32_get_stats(struct net_device *);
> @@ -2455,7 +2455,7 @@ static void pcnet32_restart(struct net_device *dev,=
 unsigned int csr0_bits)
>         lp->a->write_csr(ioaddr, CSR0, csr0_bits);
>  }
>
> -static void pcnet32_tx_timeout(struct net_device *dev)
> +static void pcnet32_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct pcnet32_private *lp =3D netdev_priv(dev);
>         unsigned long ioaddr =3D dev->base_addr, flags;
> diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/a=
md/sunlance.c
> index ebcbf8ca4829..46bdaf1a4057 100644
> --- a/drivers/net/ethernet/amd/sunlance.c
> +++ b/drivers/net/ethernet/amd/sunlance.c
> @@ -1097,7 +1097,7 @@ static void lance_piozero(void __iomem *dest, int l=
en)
>                 sbus_writeb(0, piobuf);
>  }
>
> -static void lance_tx_timeout(struct net_device *dev)
> +static void lance_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct lance_private *lp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ether=
net/amd/xgbe/xgbe-drv.c
> index 98f8f2033154..813bd2c40930 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> @@ -2152,7 +2152,7 @@ static int xgbe_change_mtu(struct net_device *netde=
v, int mtu)
>         return 0;
>  }
>
> -static void xgbe_tx_timeout(struct net_device *netdev)
> +static void xgbe_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct xgbe_prv_data *pdata =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ether=
net/apm/xgene-v2/main.c
> index 02b4f3af02b5..d503cfbf1e7b 100644
> --- a/drivers/net/ethernet/apm/xgene-v2/main.c
> +++ b/drivers/net/ethernet/apm/xgene-v2/main.c
> @@ -575,7 +575,7 @@ static void xge_free_pending_skb(struct net_device *n=
dev)
>         }
>  }
>
> -static void xge_timeout(struct net_device *ndev)
> +static void xge_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct xge_pdata *pdata =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/n=
et/ethernet/apm/xgene/xgene_enet_main.c
> index d8612131c55e..577c851a6c24 100644
> --- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> +++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> @@ -859,7 +859,7 @@ static int xgene_enet_napi(struct napi_struct *napi, =
const int budget)
>         return processed;
>  }
>
> -static void xgene_enet_timeout(struct net_device *ndev)
> +static void xgene_enet_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct xgene_enet_pdata *pdata =3D netdev_priv(ndev);
>         struct netdev_queue *txq;
> diff --git a/drivers/net/ethernet/apple/macmace.c b/drivers/net/ethernet/=
apple/macmace.c
> index 8d03578d5e8c..21c9639d57e9 100644
> --- a/drivers/net/ethernet/apple/macmace.c
> +++ b/drivers/net/ethernet/apple/macmace.c
> @@ -91,7 +91,7 @@ static int mace_set_address(struct net_device *dev, voi=
d *addr);
>  static void mace_reset(struct net_device *dev);
>  static irqreturn_t mace_interrupt(int irq, void *dev_id);
>  static irqreturn_t mace_dma_intr(int irq, void *dev_id);
> -static void mace_tx_timeout(struct net_device *dev);
> +static void mace_tx_timeout(struct net_device *dev, int txqueue);
>  static void __mace_set_address(struct net_device *dev, void *addr);
>
>  /*
> @@ -600,7 +600,7 @@ static irqreturn_t mace_interrupt(int irq, void *dev_=
id)
>         return IRQ_HANDLED;
>  }
>
> -static void mace_tx_timeout(struct net_device *dev)
> +static void mace_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct mace_data *mp =3D netdev_priv(dev);
>         volatile struct mace *mb =3D mp->mace;
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet=
/atheros/ag71xx.c
> index 1b1a09095c0d..cdebe41ab087 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -1409,7 +1409,7 @@ static void ag71xx_oom_timer_handler(struct timer_l=
ist *t)
>         napi_schedule(&ag->napi);
>  }
>
> -static void ag71xx_tx_timeout(struct net_device *ndev)
> +static void ag71xx_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct ag71xx *ag =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethern=
et/atheros/alx/main.c
> index d4bbcdfd691a..69f778ad5fbc 100644
> --- a/drivers/net/ethernet/atheros/alx/main.c
> +++ b/drivers/net/ethernet/atheros/alx/main.c
> @@ -1553,7 +1553,7 @@ static netdev_tx_t alx_start_xmit(struct sk_buff *s=
kb,
>         return alx_start_xmit_ring(skb, alx_tx_queue_mapping(alx, skb));
>  }
>
> -static void alx_tx_timeout(struct net_device *dev)
> +static void alx_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct alx_priv *alx =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/ne=
t/ethernet/atheros/atl1c/atl1c_main.c
> index 2b239ecea05f..9407fc9d5982 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -350,7 +350,7 @@ static void atl1c_del_timer(struct atl1c_adapter *ada=
pter)
>   * atl1c_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   */
> -static void atl1c_tx_timeout(struct net_device *netdev)
> +static void atl1c_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct atl1c_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/ne=
t/ethernet/atheros/atl1e/atl1e_main.c
> index 4f7b65825c15..8ec444522209 100644
> --- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
> +++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
> @@ -251,7 +251,7 @@ static void atl1e_cancel_work(struct atl1e_adapter *a=
dapter)
>   * atl1e_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   */
> -static void atl1e_tx_timeout(struct net_device *netdev)
> +static void atl1e_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct atl1e_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ether=
net/atheros/atlx/atl2.c
> index 3aba38322717..5939feb4e4d4 100644
> --- a/drivers/net/ethernet/atheros/atlx/atl2.c
> +++ b/drivers/net/ethernet/atheros/atlx/atl2.c
> @@ -1001,7 +1001,7 @@ static int atl2_ioctl(struct net_device *netdev, st=
ruct ifreq *ifr, int cmd)
>   * atl2_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   */
> -static void atl2_tx_timeout(struct net_device *netdev)
> +static void atl2_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct atl2_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/b=
roadcom/b44.c
> index 97ab0dd25552..f185f28b243f 100644
> --- a/drivers/net/ethernet/broadcom/b44.c
> +++ b/drivers/net/ethernet/broadcom/b44.c
> @@ -951,7 +951,7 @@ static irqreturn_t b44_interrupt(int irq, void *dev_i=
d)
>         return IRQ_RETVAL(handled);
>  }
>
> -static void b44_tx_timeout(struct net_device *dev)
> +static void b44_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct b44 *bp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/eth=
ernet/broadcom/bcmsysport.c
> index a977a459bd20..e27443bde3ad 100644
> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> @@ -1354,7 +1354,7 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff =
*skb,
>         return ret;
>  }
>
> -static void bcm_sysport_tx_timeout(struct net_device *dev)
> +static void bcm_sysport_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         netdev_warn(dev, "transmit timeout!\n");
>
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/=
broadcom/bnx2.c
> index fbc196b480b6..e5dfd06e10a5 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -6575,7 +6575,7 @@ bnx2_dump_state(struct bnx2 *bp)
>  }
>
>  static void
> -bnx2_tx_timeout(struct net_device *dev)
> +bnx2_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct bnx2 *bp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethe=
rnet/broadcom/bnxt/bnxt.c
> index 04ec909e06df..1747ba059f2b 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -9936,7 +9936,7 @@ static void bnxt_reset_task(struct bnxt *bp, bool s=
ilent)
>         }
>  }
>
> -static void bnxt_tx_timeout(struct net_device *dev)
> +static void bnxt_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct bnxt *bp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net=
/ethernet/broadcom/genet/bcmgenet.c
> index 1de51811fcb4..cd47b97771e3 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3053,7 +3053,7 @@ static void bcmgenet_dump_tx_queue(struct bcmgenet_=
tx_ring *ring)
>                   ring->cb_ptr, ring->end_ptr);
>  }
>
> -static void bcmgenet_timeout(struct net_device *dev)
> +static void bcmgenet_timeout(struct net_device *dev, int txqueue)
>  {
>         struct bcmgenet_priv *priv =3D netdev_priv(dev);
>         u32 int0_enable =3D 0;
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/b=
roadcom/tg3.c
> index ca3aa1250dd1..4927d369a832 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -7645,7 +7645,7 @@ static void tg3_poll_controller(struct net_device *=
dev)
>  }
>  #endif
>
> -static void tg3_tx_timeout(struct net_device *dev)
> +static void tg3_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct tg3 *tp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/=
calxeda/xgmac.c
> index f96a42af1014..1d0f3ff8bd72 100644
> --- a/drivers/net/ethernet/calxeda/xgmac.c
> +++ b/drivers/net/ethernet/calxeda/xgmac.c
> @@ -1251,7 +1251,7 @@ static int xgmac_poll(struct napi_struct *napi, int=
 budget)
>   *   netdev structure and arrange for the device to be reset to a sane s=
tate
>   *   in order to transmit a new packet.
>   */
> -static void xgmac_tx_timeout(struct net_device *dev)
> +static void xgmac_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct xgmac_priv *priv =3D netdev_priv(dev);
>         schedule_work(&priv->tx_timeout_work);
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/ne=
t/ethernet/cavium/liquidio/lio_main.c
> index 7f3b2e3b0868..acfd7bd6107b 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> @@ -2562,7 +2562,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *sk=
b, struct net_device *netdev)
>  /** \brief Network device Tx timeout
>   * @param netdev    pointer to network device
>   */
> -static void liquidio_tx_timeout(struct net_device *netdev)
> +static void liquidio_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct lio *lio;
>
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers=
/net/ethernet/cavium/liquidio/lio_vf_main.c
> index 370d76822ee0..b07890054f64 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
> @@ -1628,7 +1628,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *sk=
b, struct net_device *netdev)
>  /** \brief Network device Tx timeout
>   * @param netdev    pointer to network device
>   */
> -static void liquidio_tx_timeout(struct net_device *netdev)
> +static void liquidio_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct lio *lio;
>
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/=
net/ethernet/cavium/liquidio/lio_vf_rep.c
> index f3f2e71431ac..13ea6f00585f 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
> @@ -31,7 +31,7 @@ static int lio_vf_rep_open(struct net_device *ndev);
>  static int lio_vf_rep_stop(struct net_device *ndev);
>  static netdev_tx_t lio_vf_rep_pkt_xmit(struct sk_buff *skb,
>                                        struct net_device *ndev);
> -static void lio_vf_rep_tx_timeout(struct net_device *netdev);
> +static void lio_vf_rep_tx_timeout(struct net_device *netdev, int txqueue=
);
>  static int lio_vf_rep_phys_port_name(struct net_device *dev,
>                                      char *buf, size_t len);
>  static void lio_vf_rep_get_stats64(struct net_device *dev,
> @@ -172,7 +172,7 @@ lio_vf_rep_stop(struct net_device *ndev)
>  }
>
>  static void
> -lio_vf_rep_tx_timeout(struct net_device *ndev)
> +lio_vf_rep_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         netif_trans_update(ndev);
>
> diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/n=
et/ethernet/cavium/thunder/nicvf_main.c
> index 40a44dcb3d9b..b5c30350b964 100644
> --- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> +++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> @@ -1741,7 +1741,7 @@ static void nicvf_get_stats64(struct net_device *ne=
tdev,
>
>  }
>
> -static void nicvf_tx_timeout(struct net_device *dev)
> +static void nicvf_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct nicvf *nic =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/=
cirrus/cs89x0.c
> index c9aebcde403a..c69ff644c5c0 100644
> --- a/drivers/net/ethernet/cirrus/cs89x0.c
> +++ b/drivers/net/ethernet/cirrus/cs89x0.c
> @@ -1128,7 +1128,7 @@ net_get_stats(struct net_device *dev)
>         return &dev->stats;
>  }
>
> -static void net_timeout(struct net_device *dev)
> +static void net_timeout(struct net_device *dev, int txqueue)
>  {
>         /* If we get here, some higher level has decided we are broken.
>            There should really be a "kick me" function call instead. */
> diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/et=
hernet/cisco/enic/enic_main.c
> index acb2856936d2..c501b0673432 100644
> --- a/drivers/net/ethernet/cisco/enic/enic_main.c
> +++ b/drivers/net/ethernet/cisco/enic/enic_main.c
> @@ -1095,7 +1095,7 @@ static void enic_set_rx_mode(struct net_device *net=
dev)
>  }
>
>  /* netif_tx_lock held, BHs disabled */
> -static void enic_tx_timeout(struct net_device *netdev)
> +static void enic_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct enic *enic =3D netdev_priv(netdev);
>         schedule_work(&enic->tx_hang_reset);
> diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet=
/cortina/gemini.c
> index a8f4c69252ff..82e5dbe9d5af 100644
> --- a/drivers/net/ethernet/cortina/gemini.c
> +++ b/drivers/net/ethernet/cortina/gemini.c
> @@ -1296,7 +1296,7 @@ static int gmac_start_xmit(struct sk_buff *skb, str=
uct net_device *netdev)
>         return NETDEV_TX_OK;
>  }
>
> -static void gmac_tx_timeout(struct net_device *netdev)
> +static void gmac_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         netdev_err(netdev, "Tx timeout\n");
>         gmac_dump_dma_state(netdev);
> diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet=
/davicom/dm9000.c
> index cce90b5925d9..b8243b0d0880 100644
> --- a/drivers/net/ethernet/davicom/dm9000.c
> +++ b/drivers/net/ethernet/davicom/dm9000.c
> @@ -964,7 +964,7 @@ dm9000_init_dm9000(struct net_device *dev)
>  }
>
>  /* Our watchdog timed out. Called by the networking layer */
> -static void dm9000_timeout(struct net_device *dev)
> +static void dm9000_timeout(struct net_device *dev, int txqueue)
>  {
>         struct board_info *db =3D netdev_priv(dev);
>         u8 reg_save;
> diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/et=
hernet/dec/tulip/tulip_core.c
> index 3e3e08698876..2ccab53eb3b3 100644
> --- a/drivers/net/ethernet/dec/tulip/tulip_core.c
> +++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
> @@ -255,7 +255,7 @@ MODULE_DEVICE_TABLE(pci, tulip_pci_tbl);
>  const char tulip_media_cap[32] =3D
>  {0,0,0,16,  3,19,16,24,  27,4,7,5, 0,20,23,20,  28,31,0,0, };
>
> -static void tulip_tx_timeout(struct net_device *dev);
> +static void tulip_tx_timeout(struct net_device *dev, int txqueue);
>  static void tulip_init_ring(struct net_device *dev);
>  static void tulip_free_ring(struct net_device *dev);
>  static netdev_tx_t tulip_start_xmit(struct sk_buff *skb,
> @@ -534,7 +534,7 @@ tulip_open(struct net_device *dev)
>  }
>
>
> -static void tulip_tx_timeout(struct net_device *dev)
> +static void tulip_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct tulip_private *tp =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D tp->base_addr;
> diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/e=
thernet/dec/tulip/winbond-840.c
> index 70cb2d689c2c..04907f702696 100644
> --- a/drivers/net/ethernet/dec/tulip/winbond-840.c
> +++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
> @@ -331,7 +331,7 @@ static void netdev_timer(struct timer_list *t);
>  static void init_rxtx_rings(struct net_device *dev);
>  static void free_rxtx_rings(struct netdev_private *np);
>  static void init_registers(struct net_device *dev);
> -static void tx_timeout(struct net_device *dev);
> +static void tx_timeout(struct net_device *dev, int txqueue);
>  static int alloc_ringdesc(struct net_device *dev);
>  static void free_ringdesc(struct netdev_private *np);
>  static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)=
;
> @@ -921,7 +921,7 @@ static void init_registers(struct net_device *dev)
>         iowrite32(0, ioaddr + RxStartDemand);
>  }
>
> -static void tx_timeout(struct net_device *dev)
> +static void tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct netdev_private *np =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D np->base_addr;
> diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet=
/dlink/sundance.c
> index 4a37a69764ce..d83aabda7ea7 100644
> --- a/drivers/net/ethernet/dlink/sundance.c
> +++ b/drivers/net/ethernet/dlink/sundance.c
> @@ -432,7 +432,7 @@ static int  mdio_wait_link(struct net_device *dev, in=
t wait);
>  static int  netdev_open(struct net_device *dev);
>  static void check_duplex(struct net_device *dev);
>  static void netdev_timer(struct timer_list *t);
> -static void tx_timeout(struct net_device *dev);
> +static void tx_timeout(struct net_device *dev, int txqueue);
>  static void init_ring(struct net_device *dev);
>  static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)=
;
>  static int reset_tx (struct net_device *dev);
> @@ -969,7 +969,7 @@ static void netdev_timer(struct timer_list *t)
>         add_timer(&np->timer);
>  }
>
> -static void tx_timeout(struct net_device *dev)
> +static void tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct netdev_private *np =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D np->base;
> diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/et=
hernet/emulex/benet/be_main.c
> index 39eb7d525043..dc79b3996536 100644
> --- a/drivers/net/ethernet/emulex/benet/be_main.c
> +++ b/drivers/net/ethernet/emulex/benet/be_main.c
> @@ -1417,7 +1417,7 @@ static netdev_tx_t be_xmit(struct sk_buff *skb, str=
uct net_device *netdev)
>         return NETDEV_TX_OK;
>  }
>
> -static void be_tx_timeout(struct net_device *netdev)
> +static void be_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct be_adapter *adapter =3D netdev_priv(netdev);
>         struct device *dev =3D &adapter->pdev->dev;
> diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
> index ea4f17f5cce7..6ed903b9a756 100644
> --- a/drivers/net/ethernet/ethoc.c
> +++ b/drivers/net/ethernet/ethoc.c
> @@ -869,7 +869,7 @@ static int ethoc_change_mtu(struct net_device *dev, i=
nt new_mtu)
>         return -ENOSYS;
>  }
>
> -static void ethoc_tx_timeout(struct net_device *dev)
> +static void ethoc_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct ethoc *priv =3D netdev_priv(dev);
>         u32 pending =3D ethoc_read(priv, INT_SOURCE);
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ether=
net/faraday/ftgmac100.c
> index 96e9565f1e08..7117b3670306 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1542,7 +1542,7 @@ static int ftgmac100_do_ioctl(struct net_device *ne=
tdev, struct ifreq *ifr, int
>         return phy_mii_ioctl(netdev->phydev, ifr, cmd);
>  }
>
> -static void ftgmac100_tx_timeout(struct net_device *netdev)
> +static void ftgmac100_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct ftgmac100 *priv =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.=
c
> index c24fd56a2c71..e1fa818c0930 100644
> --- a/drivers/net/ethernet/fealnx.c
> +++ b/drivers/net/ethernet/fealnx.c
> @@ -428,7 +428,7 @@ static void getlinktype(struct net_device *dev);
>  static void getlinkstatus(struct net_device *dev);
>  static void netdev_timer(struct timer_list *t);
>  static void reset_timer(struct timer_list *t);
> -static void fealnx_tx_timeout(struct net_device *dev);
> +static void fealnx_tx_timeout(struct net_device *dev, int txqueue);
>  static void init_ring(struct net_device *dev);
>  static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)=
;
>  static irqreturn_t intr_handler(int irq, void *dev_instance);
> @@ -1191,7 +1191,7 @@ static void reset_timer(struct timer_list *t)
>  }
>
>
> -static void fealnx_tx_timeout(struct net_device *dev)
> +static void fealnx_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct netdev_private *np =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D np->mem;
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethe=
rnet/freescale/fec_main.c
> index a9c386b63581..f89e1b7c3440 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1141,7 +1141,7 @@ fec_stop(struct net_device *ndev)
>
>
>  static void
> -fec_timeout(struct net_device *ndev)
> +fec_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/e=
thernet/freescale/fec_mpc52xx.c
> index 30cdb246d020..cce5658c4789 100644
> --- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
> +++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
> @@ -84,7 +84,7 @@ static int debug =3D -1;        /* the above default */
>  module_param(debug, int, 0);
>  MODULE_PARM_DESC(debug, "debugging messages level");
>
> -static void mpc52xx_fec_tx_timeout(struct net_device *dev)
> +static void mpc52xx_fec_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct mpc52xx_fec_priv *priv =3D netdev_priv(dev);
>         unsigned long flags;
> diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/driv=
ers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> index 3981c06f082f..985607b96c5b 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> @@ -641,7 +641,7 @@ static void fs_timeout_work(struct work_struct *work)
>                 netif_wake_queue(dev);
>  }
>
> -static void fs_timeout(struct net_device *dev)
> +static void fs_timeout(struct net_device *dev, int txqueue)
>  {
>         struct fs_enet_private *fep =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ether=
net/freescale/gianfar.c
> index 51ad86417cb1..10d21b333ab2 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -2092,7 +2092,7 @@ static void gfar_reset_task(struct work_struct *wor=
k)
>         reset_gfar(priv->ndev);
>  }
>
> -static void gfar_timeout(struct net_device *dev)
> +static void gfar_timeout(struct net_device *dev, int txqueue)
>  {
>         struct gfar_private *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethe=
rnet/freescale/ucc_geth.c
> index f839fa94ebdd..d3b2b317628a 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -3545,7 +3545,7 @@ static void ucc_geth_timeout_work(struct work_struc=
t *work)
>   * ucc_geth_timeout gets called when a packet has not been
>   * transmitted after a set amount of time.
>   */
> -static void ucc_geth_timeout(struct net_device *dev)
> +static void ucc_geth_timeout(struct net_device *dev, int txqueue)
>  {
>         struct ucc_geth_private *ugeth =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethe=
rnet/fujitsu/fmvj18x_cs.c
> index 1eca0fdb9933..ce4f9ab63774 100644
> --- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
> +++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
> @@ -93,7 +93,7 @@ static irqreturn_t fjn_interrupt(int irq, void *dev_id)=
;
>  static void fjn_rx(struct net_device *dev);
>  static void fjn_reset(struct net_device *dev);
>  static void set_rx_mode(struct net_device *dev);
> -static void fjn_tx_timeout(struct net_device *dev);
> +static void fjn_tx_timeout(struct net_device *dev, int txqueue);
>  static const struct ethtool_ops netdev_ethtool_ops;
>
>  /*
> @@ -774,7 +774,7 @@ static irqreturn_t fjn_interrupt(int dummy, void *dev=
_id)
>
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
>
> -static void fjn_tx_timeout(struct net_device *dev)
> +static void fjn_tx_timeout(struct net_device *dev, int txqueue)
>  {
>      struct local_info *lp =3D netdev_priv(dev);
>      unsigned int ioaddr =3D dev->base_addr;
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/eth=
ernet/google/gve/gve_main.c
> index aca95f64bde8..8324c44cae4b 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -844,7 +844,7 @@ static void gve_turnup(struct gve_priv *priv)
>         gve_set_napi_enabled(priv);
>  }
>
> -static void gve_tx_timeout(struct net_device *dev)
> +static void gve_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct gve_priv *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/eth=
ernet/hisilicon/hip04_eth.c
> index 4606a7e4a6d1..15f748346091 100644
> --- a/drivers/net/ethernet/hisilicon/hip04_eth.c
> +++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
> @@ -779,7 +779,7 @@ static int hip04_mac_stop(struct net_device *ndev)
>         return 0;
>  }
>
> -static void hip04_timeout(struct net_device *ndev)
> +static void hip04_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct hip04_priv *priv =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/=
ethernet/hisilicon/hix5hd2_gmac.c
> index c41b19c760f8..29878a6a2efa 100644
> --- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
> +++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
> @@ -893,7 +893,7 @@ static void hix5hd2_tx_timeout_task(struct work_struc=
t *work)
>         hix5hd2_net_open(priv->netdev);
>  }
>
> -static void hix5hd2_net_timeout(struct net_device *dev)
> +static void hix5hd2_net_timeout(struct net_device *dev, int txqueue)
>  {
>         struct hix5hd2_priv *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/=
ethernet/hisilicon/hns/hns_enet.c
> index 14ab20491fd0..a5afac22b226 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> @@ -1485,7 +1485,7 @@ static int hns_nic_net_stop(struct net_device *ndev=
)
>
>  static void hns_tx_timeout_reset(struct hns_nic_priv *priv);
>  #define HNS_TX_TIMEO_LIMIT (40 * HZ)
> -static void hns_nic_net_timeout(struct net_device *ndev)
> +static void hns_nic_net_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct hns_nic_priv *priv =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/ne=
t/ethernet/hisilicon/hns3/hns3_enet.c
> index 616cad0faa21..4d602e8d54ac 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -1764,7 +1764,7 @@ static bool hns3_get_tx_timeo_queue_info(struct net=
_device *ndev)
>         return true;
>  }
>
> -static void hns3_nic_net_timeout(struct net_device *ndev)
> +static void hns3_nic_net_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct hns3_nic_priv *priv =3D netdev_priv(ndev);
>         struct hnae3_handle *h =3D priv->ae_handle;
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net=
/ethernet/huawei/hinic/hinic_main.c
> index 2411ad270c98..f76fb413a216 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -766,7 +766,7 @@ static void hinic_set_rx_mode(struct net_device *netd=
ev)
>         queue_work(nic_dev->workq, &rx_mode_work->work);
>  }
>
> -static void hinic_tx_timeout(struct net_device *netdev)
> +static void hinic_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct hinic_dev *nic_dev =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/=
i825xx/ether1.c
> index bb3b8adbe4f0..6e92424a0851 100644
> --- a/drivers/net/ethernet/i825xx/ether1.c
> +++ b/drivers/net/ethernet/i825xx/ether1.c
> @@ -66,7 +66,7 @@ static netdev_tx_t ether1_sendpacket(struct sk_buff *sk=
b,
>  static irqreturn_t ether1_interrupt(int irq, void *dev_id);
>  static int ether1_close(struct net_device *dev);
>  static void ether1_setmulticastlist(struct net_device *dev);
> -static void ether1_timeout(struct net_device *dev);
> +static void ether1_timeout(struct net_device *dev, int txqueue);
>
>  /* ---------------------------------------------------------------------=
---- */
>
> @@ -650,7 +650,7 @@ ether1_open (struct net_device *dev)
>  }
>
>  static void
> -ether1_timeout(struct net_device *dev)
> +ether1_timeout(struct net_device *dev, int txqueue)
>  {
>         printk(KERN_WARNING "%s: transmit timeout, network cable problem?=
\n",
>                 dev->name);
> diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ether=
net/i825xx/sun3_82586.c
> index 1a86184d44c0..b4a1ff04b3ba 100644
> --- a/drivers/net/ethernet/i825xx/sun3_82586.c
> +++ b/drivers/net/ethernet/i825xx/sun3_82586.c
> @@ -125,7 +125,7 @@ static netdev_tx_t     sun3_82586_send_packet(struct =
sk_buff *,
>                                               struct net_device *);
>  static struct  net_device_stats *sun3_82586_get_stats(struct net_device =
*dev);
>  static void    set_multicast_list(struct net_device *dev);
> -static void    sun3_82586_timeout(struct net_device *dev);
> +static void    sun3_82586_timeout(struct net_device *dev, int txqueue);
>  #if 0
>  static void    sun3_82586_dump(struct net_device *,void *);
>  #endif
> @@ -965,7 +965,7 @@ static void startrecv586(struct net_device *dev)
>         WAIT_4_SCB_CMD_RUC();   /* wait for accept cmd. (no timeout!!) */
>  }
>
> -static void sun3_82586_timeout(struct net_device *dev)
> +static void sun3_82586_timeout(struct net_device *dev, int txqueue)
>  {
>         struct priv *p =3D netdev_priv(dev);
>  #ifndef NO_NOPCOMMANDS
> diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethe=
rnet/ibm/ehea/ehea_main.c
> index 13e30eba5349..1ace5a3cf313 100644
> --- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
> +++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> @@ -2786,7 +2786,7 @@ static void ehea_rereg_mrs(void)
>         return;
>  }
>
> -static void ehea_tx_watchdog(struct net_device *dev)
> +static void ehea_tx_watchdog(struct net_device *dev, int txqueue)
>  {
>         struct ehea_port *port =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/=
ibm/emac/core.c
> index 9e43c9ace9c2..477468a029f4 100644
> --- a/drivers/net/ethernet/ibm/emac/core.c
> +++ b/drivers/net/ethernet/ibm/emac/core.c
> @@ -776,7 +776,7 @@ static void emac_reset_work(struct work_struct *work)
>         mutex_unlock(&dev->link_lock);
>  }
>
> -static void emac_tx_timeout(struct net_device *ndev)
> +static void emac_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct emac_instance *dev =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ib=
m/ibmvnic.c
> index f59d9a8e35e2..649e7f5fca74 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2189,7 +2189,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *ad=
apter,
>         return -ret;
>  }
>
> -static void ibmvnic_tx_timeout(struct net_device *dev)
> +static void ibmvnic_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct ibmvnic_adapter *adapter =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/int=
el/e100.c
> index a65d5a9ba7db..7ab17e4efb8f 100644
> --- a/drivers/net/ethernet/intel/e100.c
> +++ b/drivers/net/ethernet/intel/e100.c
> @@ -2316,7 +2316,7 @@ static void e100_down(struct nic *nic)
>         e100_rx_clean_list(nic);
>  }
>
> -static void e100_tx_timeout(struct net_device *netdev)
> +static void e100_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct nic *nic =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/=
ethernet/intel/e1000/e1000_main.c
> index 86493fea56e4..6db01416e0e3 100644
> --- a/drivers/net/ethernet/intel/e1000/e1000_main.c
> +++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
> @@ -134,7 +134,7 @@ static int e1000_mii_ioctl(struct net_device *netdev,=
 struct ifreq *ifr,
>                            int cmd);
>  static void e1000_enter_82542_rst(struct e1000_adapter *adapter);
>  static void e1000_leave_82542_rst(struct e1000_adapter *adapter);
> -static void e1000_tx_timeout(struct net_device *dev);
> +static void e1000_tx_timeout(struct net_device *dev, int txqueue);
>  static void e1000_reset_task(struct work_struct *work);
>  static void e1000_smartspeed(struct e1000_adapter *adapter);
>  static int e1000_82547_fifo_workaround(struct e1000_adapter *adapter,
> @@ -3488,7 +3488,7 @@ static void e1000_dump(struct e1000_adapter *adapte=
r)
>   * e1000_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void e1000_tx_timeout(struct net_device *netdev)
> +static void e1000_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct e1000_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/eth=
ernet/intel/e1000e/netdev.c
> index d7d56e42a6aa..e1d20842ebc4 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5926,7 +5926,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff =
*skb,
>   * e1000_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void e1000_tx_timeout(struct net_device *netdev)
> +static void e1000_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct e1000_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/ne=
t/ethernet/intel/fm10k/fm10k_netdev.c
> index 09f7a246e134..8801fe7aef36 100644
> --- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> +++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> @@ -697,7 +697,7 @@ static netdev_tx_t fm10k_xmit_frame(struct sk_buff *s=
kb, struct net_device *dev)
>   * fm10k_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void fm10k_tx_timeout(struct net_device *netdev)
> +static void fm10k_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct fm10k_intfc *interface =3D netdev_priv(netdev);
>         bool real_tx_hang =3D false;
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/et=
hernet/intel/i40e/i40e_main.c
> index 6031223eafab..a22c13849159 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -301,7 +301,7 @@ void i40e_service_event_schedule(struct i40e_pf *pf)
>   * device is munged, not just the one netdev port, so go for the full
>   * reset.
>   **/
> -static void i40e_tx_timeout(struct net_device *netdev)
> +static void i40e_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct i40e_netdev_priv *np =3D netdev_priv(netdev);
>         struct i40e_vsi *vsi =3D np->vsi;
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/et=
hernet/intel/iavf/iavf_main.c
> index 821987da5698..6c2197400c14 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -159,7 +159,7 @@ void iavf_schedule_reset(struct iavf_adapter *adapter=
)
>   * iavf_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void iavf_tx_timeout(struct net_device *netdev)
> +static void iavf_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct iavf_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethe=
rnet/intel/ice/ice_main.c
> index 214cd6eca405..713d41cf1f85 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -4627,7 +4627,7 @@ ice_bridge_setlink(struct net_device *dev, struct n=
lmsghdr *nlh,
>   * ice_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   */
> -static void ice_tx_timeout(struct net_device *netdev)
> +static void ice_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct ice_netdev_priv *np =3D netdev_priv(netdev);
>         struct ice_ring *tx_ring =3D NULL;
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethe=
rnet/intel/igb/igb_main.c
> index ed7e667d7eb2..40a4072e4ab6 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -6173,7 +6173,7 @@ static netdev_tx_t igb_xmit_frame(struct sk_buff *s=
kb,
>   *  igb_tx_timeout - Respond to a Tx Hang
>   *  @netdev: network interface device structure
>   **/
> -static void igb_tx_timeout(struct net_device *netdev)
> +static void igb_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct igb_adapter *adapter =3D netdev_priv(netdev);
>         struct e1000_hw *hw =3D &adapter->hw;
> diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethe=
rnet/intel/igbvf/netdev.c
> index 0f2b68f4bb0f..d3a909fe2d62 100644
> --- a/drivers/net/ethernet/intel/igbvf/netdev.c
> +++ b/drivers/net/ethernet/intel/igbvf/netdev.c
> @@ -2375,7 +2375,7 @@ static netdev_tx_t igbvf_xmit_frame(struct sk_buff =
*skb,
>   * igbvf_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void igbvf_tx_timeout(struct net_device *netdev)
> +static void igbvf_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct igbvf_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/et=
hernet/intel/ixgb/ixgb_main.c
> index 0940a0da16f2..28465fc76dda 100644
> --- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
> +++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
> @@ -70,7 +70,7 @@ static int ixgb_clean(struct napi_struct *, int);
>  static bool ixgb_clean_rx_irq(struct ixgb_adapter *, int *, int);
>  static void ixgb_alloc_rx_buffers(struct ixgb_adapter *, int);
>
> -static void ixgb_tx_timeout(struct net_device *dev);
> +static void ixgb_tx_timeout(struct net_device *dev, int txqueue);
>  static void ixgb_tx_timeout_task(struct work_struct *work);
>
>  static void ixgb_vlan_strip_enable(struct ixgb_adapter *adapter);
> @@ -1538,7 +1538,7 @@ ixgb_xmit_frame(struct sk_buff *skb, struct net_dev=
ice *netdev)
>   **/
>
>  static void
> -ixgb_tx_timeout(struct net_device *netdev)
> +ixgb_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct ixgb_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c b/drivers/n=
et/ethernet/intel/ixgbe/ixgbe_debugfs.c
> index 171cdc552961..4f4155d47478 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
> @@ -166,7 +166,7 @@ static ssize_t ixgbe_dbg_netdev_ops_write(struct file=
 *filp,
>         ixgbe_dbg_netdev_ops_buf[len] =3D '\0';
>
>         if (strncmp(ixgbe_dbg_netdev_ops_buf, "tx_timeout", 10) =3D=3D 0)=
 {
> -               adapter->netdev->netdev_ops->ndo_tx_timeout(adapter->netd=
ev);
> +               adapter->netdev->netdev_ops->ndo_tx_timeout(adapter->netd=
ev, -1);
>                 e_dev_info("tx_timeout called\n");
>         } else {
>                 e_dev_info("Unknown command: %s\n", ixgbe_dbg_netdev_ops_=
buf);
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/=
ethernet/intel/ixgbe/ixgbe_main.c
> index 91b3780ddb04..06746ac6487d 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -6158,7 +6158,7 @@ static void ixgbe_set_eee_capable(struct ixgbe_adap=
ter *adapter)
>   * ixgbe_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void ixgbe_tx_timeout(struct net_device *netdev)
> +static void ixgbe_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct ixgbe_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/=
net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index 076f2da36f27..3f3c668ba878 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -250,7 +250,7 @@ static void ixgbevf_tx_timeout_reset(struct ixgbevf_a=
dapter *adapter)
>   * ixgbevf_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void ixgbevf_tx_timeout(struct net_device *netdev)
> +static void ixgbevf_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct ixgbevf_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
> index 25aa400e2e3c..bc674a162861 100644
> --- a/drivers/net/ethernet/jme.c
> +++ b/drivers/net/ethernet/jme.c
> @@ -2337,7 +2337,7 @@ jme_change_mtu(struct net_device *netdev, int new_m=
tu)
>  }
>
>  static void
> -jme_tx_timeout(struct net_device *netdev)
> +jme_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct jme_adapter *jme =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.=
c
> index ae195f8adff5..6ab1d4177f92 100644
> --- a/drivers/net/ethernet/korina.c
> +++ b/drivers/net/ethernet/korina.c
> @@ -917,7 +917,7 @@ static void korina_restart_task(struct work_struct *w=
ork)
>         enable_irq(lp->rx_irq);
>  }
>
> -static void korina_tx_timeout(struct net_device *dev)
> +static void korina_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct korina_private *lp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/la=
ntiq_etop.c
> index 6e73ffe6f928..6b01c225864c 100644
> --- a/drivers/net/ethernet/lantiq_etop.c
> +++ b/drivers/net/ethernet/lantiq_etop.c
> @@ -594,7 +594,7 @@ ltq_etop_init(struct net_device *dev)
>  }
>
>  static void
> -ltq_etop_tx_timeout(struct net_device *dev)
> +ltq_etop_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         int err;
>
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/eth=
ernet/marvell/mv643xx_eth.c
> index 82ea55ae5053..c01170cb4031 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -2590,7 +2590,7 @@ static void tx_timeout_task(struct work_struct *ugl=
y)
>         }
>  }
>
> -static void mv643xx_eth_tx_timeout(struct net_device *dev)
> +static void mv643xx_eth_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct mv643xx_eth_private *mp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethe=
rnet/marvell/pxa168_eth.c
> index 51b77c2de400..c8259d591f16 100644
> --- a/drivers/net/ethernet/marvell/pxa168_eth.c
> +++ b/drivers/net/ethernet/marvell/pxa168_eth.c
> @@ -742,7 +742,7 @@ static int txq_reclaim(struct net_device *dev, int fo=
rce)
>         return released;
>  }
>
> -static void pxa168_eth_tx_timeout(struct net_device *dev)
> +static void pxa168_eth_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct pxa168_eth_private *pep =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/m=
arvell/skge.c
> index 095f6c71b4fa..afc5bf211c84 100644
> --- a/drivers/net/ethernet/marvell/skge.c
> +++ b/drivers/net/ethernet/marvell/skge.c
> @@ -2884,7 +2884,7 @@ static void skge_tx_clean(struct net_device *dev)
>         skge->tx_ring.to_clean =3D e;
>  }
>
> -static void skge_tx_timeout(struct net_device *dev)
> +static void skge_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct skge_port *skge =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/m=
arvell/sky2.c
> index 5f56ee83e3b1..370c945f3d0b 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -2358,7 +2358,7 @@ static void sky2_qlink_intr(struct sky2_hw *hw)
>  /* Transmit timeout is only called if we are running, carrier is up
>   * and tx queue is full (stopped).
>   */
> -static void sky2_tx_timeout(struct net_device *dev)
> +static void sky2_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct sky2_port *sky2 =3D netdev_priv(dev);
>         struct sky2_hw *hw =3D sky2->hw;
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/et=
hernet/mediatek/mtk_eth_soc.c
> index 703adb96429e..798c641f12ad 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2083,7 +2083,7 @@ static void mtk_dma_free(struct mtk_eth *eth)
>         kfree(eth->scratch_head);
>  }
>
> -static void mtk_tx_timeout(struct net_device *dev)
> +static void mtk_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct mtk_mac *mac =3D netdev_priv(dev);
>         struct mtk_eth *eth =3D mac->hw;
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net=
/ethernet/mellanox/mlx4/en_netdev.c
> index 40ec5acf79c0..b1f981311384 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> @@ -1354,7 +1354,7 @@ static void mlx4_en_delete_rss_steer_rules(struct m=
lx4_en_priv *priv)
>         }
>  }
>
> -static void mlx4_en_tx_timeout(struct net_device *dev)
> +static void mlx4_en_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct mlx4_en_priv *priv =3D netdev_priv(dev);
>         struct mlx4_en_dev *mdev =3D priv->mdev;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index 772bfdbdeb9c..f5221c6c68ab 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4337,7 +4337,7 @@ static void mlx5e_tx_timeout_work(struct work_struc=
t *work)
>         rtnl_unlock();
>  }
>
> -static void mlx5e_tx_timeout(struct net_device *dev)
> +static void mlx5e_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct mlx5e_priv *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/=
micrel/ks8842.c
> index da329ca115cc..5d15b583b6ef 100644
> --- a/drivers/net/ethernet/micrel/ks8842.c
> +++ b/drivers/net/ethernet/micrel/ks8842.c
> @@ -1103,7 +1103,7 @@ static void ks8842_tx_timeout_work(struct work_stru=
ct *work)
>                 __ks8842_start_new_rx_dma(netdev);
>  }
>
> -static void ks8842_tx_timeout(struct net_device *netdev)
> +static void ks8842_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct ks8842_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet=
/micrel/ksz884x.c
> index e102e1560ac7..c71880722281 100644
> --- a/drivers/net/ethernet/micrel/ksz884x.c
> +++ b/drivers/net/ethernet/micrel/ksz884x.c
> @@ -4896,7 +4896,7 @@ static netdev_tx_t netdev_tx(struct sk_buff *skb, s=
truct net_device *dev)
>   * triggered to free up resources so that the transmit routine can conti=
nue
>   * sending out packets.  The hardware is reset to correct the problem.
>   */
> -static void netdev_tx_timeout(struct net_device *dev)
> +static void netdev_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         static unsigned long last_reset;
>
> diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethe=
rnet/microchip/enc28j60.c
> index 0567e4f387a5..c8c33c3f76fe 100644
> --- a/drivers/net/ethernet/microchip/enc28j60.c
> +++ b/drivers/net/ethernet/microchip/enc28j60.c
> @@ -1325,7 +1325,7 @@ static irqreturn_t enc28j60_irq(int irq, void *dev_=
id)
>         return IRQ_HANDLED;
>  }
>
> -static void enc28j60_tx_timeout(struct net_device *ndev)
> +static void enc28j60_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct enc28j60_net *priv =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/et=
hernet/microchip/encx24j600.c
> index 52c41d11f565..b9569502a6ae 100644
> --- a/drivers/net/ethernet/microchip/encx24j600.c
> +++ b/drivers/net/ethernet/microchip/encx24j600.c
> @@ -892,7 +892,7 @@ static netdev_tx_t encx24j600_tx(struct sk_buff *skb,=
 struct net_device *dev)
>  }
>
>  /* Deal with a transmit timeout */
> -static void encx24j600_tx_timeout(struct net_device *dev)
> +static void encx24j600_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct encx24j600_priv *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/etherne=
t/natsemi/natsemi.c
> index 1a2634cbbb69..8fb1ee47a99d 100644
> --- a/drivers/net/ethernet/natsemi/natsemi.c
> +++ b/drivers/net/ethernet/natsemi/natsemi.c
> @@ -612,7 +612,7 @@ static void undo_cable_magic(struct net_device *dev);
>  static void check_link(struct net_device *dev);
>  static void netdev_timer(struct timer_list *t);
>  static void dump_ring(struct net_device *dev);
> -static void ns_tx_timeout(struct net_device *dev);
> +static void ns_tx_timeout(struct net_device *dev, int txqueue);
>  static int alloc_ring(struct net_device *dev);
>  static void refill_rx(struct net_device *dev);
>  static void init_ring(struct net_device *dev);
> @@ -1881,7 +1881,7 @@ static void dump_ring(struct net_device *dev)
>         }
>  }
>
> -static void ns_tx_timeout(struct net_device *dev)
> +static void ns_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct netdev_private *np =3D netdev_priv(dev);
>         void __iomem * ioaddr =3D ns_ioaddr(dev);
> diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/etherne=
t/natsemi/ns83820.c
> index 6af9a7eee114..3d9fd24c30e6 100644
> --- a/drivers/net/ethernet/natsemi/ns83820.c
> +++ b/drivers/net/ethernet/natsemi/ns83820.c
> @@ -1549,7 +1549,7 @@ static int ns83820_stop(struct net_device *ndev)
>         return 0;
>  }
>
> -static void ns83820_tx_timeout(struct net_device *ndev)
> +static void ns83820_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct ns83820 *dev =3D PRIV(ndev);
>          u32 tx_done_idx;
> diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/=
neterion/s2io.c
> index e0b2bf327905..e5e70154cfd3 100644
> --- a/drivers/net/ethernet/neterion/s2io.c
> +++ b/drivers/net/ethernet/neterion/s2io.c
> @@ -7238,7 +7238,7 @@ static void s2io_restart_nic(struct work_struct *wo=
rk)
>   *  void
>   */
>
> -static void s2io_tx_watchdog(struct net_device *dev)
> +static void s2io_tx_watchdog(struct net_device *dev, int txqueue)
>  {
>         struct s2io_nic *sp =3D netdev_priv(dev);
>         struct swStat *swstats =3D &sp->mac_control.stats_info->sw_stat;
> diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net=
/ethernet/neterion/vxge/vxge-main.c
> index 1d334f2e0a56..4649b321be92 100644
> --- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
> +++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
> @@ -3273,7 +3273,7 @@ static int vxge_ioctl(struct net_device *dev, struc=
t ifreq *rq, int cmd)
>   * This function is triggered if the Tx Queue is stopped
>   * for a pre-defined amount of time when the Interface is still up.
>   */
> -static void vxge_tx_watchdog(struct net_device *dev)
> +static void vxge_tx_watchdog(struct net_device *dev, int txqueue)
>  {
>         struct vxgedev *vdev;
>
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/driver=
s/net/ethernet/netronome/nfp/nfp_net_common.c
> index 61aabffc8888..80ba02485c59 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -1320,7 +1320,7 @@ nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct=
 nfp_net_tx_ring *tx_ring)
>         netdev_tx_reset_queue(nd_q);
>  }
>
> -static void nfp_net_tx_timeout(struct net_device *netdev)
> +static void nfp_net_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct nfp_net *nn =3D netdev_priv(netdev);
>         int i;
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethern=
et/nvidia/forcedeth.c
> index 05d2b478c99b..f937ddb0182f 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -2700,7 +2700,7 @@ static int nv_tx_done_optimized(struct net_device *=
dev, int limit)
>   * nv_tx_timeout: dev->tx_timeout function
>   * Called with netif_tx_lock held.
>   */
> -static void nv_tx_timeout(struct net_device *dev)
> +static void nv_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct fe_priv *np =3D netdev_priv(dev);
>         u8 __iomem *base =3D get_hwbase(dev);
> diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drive=
rs/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> index 18e6d87c607b..37aec58f3bf4 100644
> --- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> +++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> @@ -2271,7 +2271,7 @@ static int pch_gbe_ioctl(struct net_device *netdev,=
 struct ifreq *ifr, int cmd)
>   * pch_gbe_tx_timeout - Respond to a Tx Hang
>   * @netdev:   Network interface device structure
>   */
> -static void pch_gbe_tx_timeout(struct net_device *netdev)
> +static void pch_gbe_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct pch_gbe_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/packetengines/hamachi.c b/drivers/net/e=
thernet/packetengines/hamachi.c
> index eee883a2aa8d..1034a136e164 100644
> --- a/drivers/net/ethernet/packetengines/hamachi.c
> +++ b/drivers/net/ethernet/packetengines/hamachi.c
> @@ -548,7 +548,7 @@ static void mdio_write(struct net_device *dev, int ph=
y_id, int location, int val
>  static int hamachi_open(struct net_device *dev);
>  static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cm=
d);
>  static void hamachi_timer(struct timer_list *t);
> -static void hamachi_tx_timeout(struct net_device *dev);
> +static void hamachi_tx_timeout(struct net_device *dev, int txqueue);
>  static void hamachi_init_ring(struct net_device *dev);
>  static netdev_tx_t hamachi_start_xmit(struct sk_buff *skb,
>                                       struct net_device *dev);
> @@ -1042,7 +1042,7 @@ static void hamachi_timer(struct timer_list *t)
>         add_timer(&hmp->timer);
>  }
>
> -static void hamachi_tx_timeout(struct net_device *dev)
> +static void hamachi_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         int i;
>         struct hamachi_private *hmp =3D netdev_priv(dev);
> diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net=
/ethernet/packetengines/yellowfin.c
> index 5113ee647090..80a38b744ae5 100644
> --- a/drivers/net/ethernet/packetengines/yellowfin.c
> +++ b/drivers/net/ethernet/packetengines/yellowfin.c
> @@ -344,7 +344,7 @@ static void mdio_write(void __iomem *ioaddr, int phy_=
id, int location, int value
>  static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cm=
d);
>  static int yellowfin_open(struct net_device *dev);
>  static void yellowfin_timer(struct timer_list *t);
> -static void yellowfin_tx_timeout(struct net_device *dev);
> +static void yellowfin_tx_timeout(struct net_device *dev, int txqueue);
>  static int yellowfin_init_ring(struct net_device *dev);
>  static netdev_tx_t yellowfin_start_xmit(struct sk_buff *skb,
>                                         struct net_device *dev);
> @@ -677,7 +677,7 @@ static void yellowfin_timer(struct timer_list *t)
>         add_timer(&yp->timer);
>  }
>
> -static void yellowfin_tx_timeout(struct net_device *dev)
> +static void yellowfin_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct yellowfin_private *yp =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D yp->base;
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/ne=
t/ethernet/pensando/ionic/ionic_lif.c
> index 20faa8d24c9f..a3bd9982b11d 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1268,7 +1268,7 @@ static void ionic_tx_timeout_work(struct work_struc=
t *ws)
>         rtnl_unlock();
>  }
>
> -static void ionic_tx_timeout(struct net_device *netdev)
> +static void ionic_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct ionic_lif *lif =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drive=
rs/net/ethernet/qlogic/netxen/netxen_nic_main.c
> index c692a41e4548..979cb80db554 100644
> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> @@ -49,7 +49,7 @@ static int netxen_nic_open(struct net_device *netdev);
>  static int netxen_nic_close(struct net_device *netdev);
>  static netdev_tx_t netxen_nic_xmit_frame(struct sk_buff *,
>                                                struct net_device *);
> -static void netxen_tx_timeout(struct net_device *netdev);
> +static void netxen_tx_timeout(struct net_device *netdev, int txqueue);
>  static void netxen_tx_timeout_task(struct work_struct *work);
>  static void netxen_fw_poll_work(struct work_struct *work);
>  static void netxen_schedule_work(struct netxen_adapter *adapter,
> @@ -2222,7 +2222,7 @@ static void netxen_nic_handle_phy_intr(struct netxe=
n_adapter *adapter)
>         netxen_advert_link_change(adapter, linkup);
>  }
>
> -static void netxen_tx_timeout(struct net_device *netdev)
> +static void netxen_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct netxen_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet=
/qlogic/qla3xxx.c
> index b4b8ba00ee01..3351f6f39a9f 100644
> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
> @@ -3602,7 +3602,7 @@ static int ql3xxx_set_mac_address(struct net_device=
 *ndev, void *p)
>         return 0;
>  }
>
> -static void ql3xxx_tx_timeout(struct net_device *ndev)
> +static void ql3xxx_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct ql3_adapter *qdev =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/n=
et/ethernet/qlogic/qlcnic/qlcnic_main.c
> index c07438db30ba..5e90ad915b73 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> @@ -56,7 +56,7 @@ static int qlcnic_probe(struct pci_dev *pdev, const str=
uct pci_device_id *ent);
>  static void qlcnic_remove(struct pci_dev *pdev);
>  static int qlcnic_open(struct net_device *netdev);
>  static int qlcnic_close(struct net_device *netdev);
> -static void qlcnic_tx_timeout(struct net_device *netdev);
> +static void qlcnic_tx_timeout(struct net_device *netdev, int txqueue);
>  static void qlcnic_attach_work(struct work_struct *work);
>  static void qlcnic_fwinit_work(struct work_struct *work);
>
> @@ -3068,7 +3068,7 @@ static void qlcnic_dump_rings(struct qlcnic_adapter=
 *adapter)
>
>  }
>
> -static void qlcnic_tx_timeout(struct net_device *netdev)
> +static void qlcnic_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct qlcnic_adapter *adapter =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethe=
rnet/qualcomm/emac/emac.c
> index c84ab052ef26..03e87c272c60 100644
> --- a/drivers/net/ethernet/qualcomm/emac/emac.c
> +++ b/drivers/net/ethernet/qualcomm/emac/emac.c
> @@ -282,7 +282,7 @@ static int emac_close(struct net_device *netdev)
>  }
>
>  /* Respond to a TX hang */
> -static void emac_tx_timeout(struct net_device *netdev)
> +static void emac_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct emac_adapter *adpt =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethern=
et/qualcomm/qca_spi.c
> index 5ecf61df78bd..7d752c92e2af 100644
> --- a/drivers/net/ethernet/qualcomm/qca_spi.c
> +++ b/drivers/net/ethernet/qualcomm/qca_spi.c
> @@ -786,7 +786,7 @@ qcaspi_netdev_xmit(struct sk_buff *skb, struct net_de=
vice *dev)
>  }
>
>  static void
> -qcaspi_netdev_tx_timeout(struct net_device *dev)
> +qcaspi_netdev_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct qcaspi *qca =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ether=
net/qualcomm/qca_uart.c
> index 0981068504fa..fea9861a3b96 100644
> --- a/drivers/net/ethernet/qualcomm/qca_uart.c
> +++ b/drivers/net/ethernet/qualcomm/qca_uart.c
> @@ -248,7 +248,7 @@ qcauart_netdev_xmit(struct sk_buff *skb, struct net_d=
evice *dev)
>         return NETDEV_TX_OK;
>  }
>
> -static void qcauart_netdev_tx_timeout(struct net_device *dev)
> +static void qcauart_netdev_tx_timeout(struct net_device *dev, int txqueu=
e)
>  {
>         struct qcauart *qca =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/=
r6040.c
> index 274e5b4bc4ac..c1a7aa38fbdf 100644
> --- a/drivers/net/ethernet/rdc/r6040.c
> +++ b/drivers/net/ethernet/rdc/r6040.c
> @@ -410,7 +410,7 @@ static void r6040_init_mac_regs(struct net_device *de=
v)
>         iowrite16(TM2TX, ioaddr + MTPR);
>  }
>
> -static void r6040_tx_timeout(struct net_device *dev)
> +static void r6040_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct r6040_private *priv =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D priv->base;
> diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet=
/realtek/8139cp.c
> index 4f910c4f67b0..26c2d0bcca14 100644
> --- a/drivers/net/ethernet/realtek/8139cp.c
> +++ b/drivers/net/ethernet/realtek/8139cp.c
> @@ -1235,7 +1235,7 @@ static int cp_close (struct net_device *dev)
>         return 0;
>  }
>
> -static void cp_tx_timeout(struct net_device *dev)
> +static void cp_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct cp_private *cp =3D netdev_priv(dev);
>         unsigned long flags;
> diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/re=
altek/atp.c
> index 58e0ca9093d3..f5c50926d10c 100644
> --- a/drivers/net/ethernet/realtek/atp.c
> +++ b/drivers/net/ethernet/realtek/atp.c
> @@ -204,7 +204,7 @@ static void net_rx(struct net_device *dev);
>  static void read_block(long ioaddr, int length, unsigned char *buffer, i=
nt data_mode);
>  static int net_close(struct net_device *dev);
>  static void set_rx_mode(struct net_device *dev);
> -static void tx_timeout(struct net_device *dev);
> +static void tx_timeout(struct net_device *dev, int txqueue);
>
>
>  /* A list of all installed ATP devices, for removing the driver module. =
*/
> @@ -533,7 +533,7 @@ static void write_packet(long ioaddr, int length, uns=
igned char *packet, int pad
>      outb(Ctrl_HNibWrite | Ctrl_SelData | Ctrl_IRQEN, ioaddr + PAR_CONTRO=
L);
>  }
>
> -static void tx_timeout(struct net_device *dev)
> +static void tx_timeout(struct net_device *dev, int txqueue)
>  {
>         long ioaddr =3D dev->base_addr;
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethe=
rnet/realtek/r8169_main.c
> index c4e961ea44d5..1c719790aa14 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5662,7 +5662,7 @@ static void rtl_reset_work(struct rtl8169_private *=
tp)
>         netif_wake_queue(dev);
>  }
>
> -static void rtl8169_tx_timeout(struct net_device *dev)
> +static void rtl8169_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct rtl8169_private *tp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ether=
net/renesas/ravb_main.c
> index 3f165c137236..9e1022a90a74 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1425,7 +1425,7 @@ static int ravb_open(struct net_device *ndev)
>  }
>
>  /* Timeout function for Ethernet AVB */
> -static void ravb_tx_timeout(struct net_device *ndev)
> +static void ravb_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct ravb_private *priv =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet=
/renesas/sh_eth.c
> index 7ba35a0bdb29..b208fa4c1016 100644
> --- a/drivers/net/ethernet/renesas/sh_eth.c
> +++ b/drivers/net/ethernet/renesas/sh_eth.c
> @@ -2478,7 +2478,7 @@ static int sh_eth_open(struct net_device *ndev)
>  }
>
>  /* Timeout function */
> -static void sh_eth_tx_timeout(struct net_device *ndev)
> +static void sh_eth_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct sh_eth_private *mdp =3D netdev_priv(ndev);
>         struct sh_eth_rxdesc *rxdesc;
> diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/ne=
t/ethernet/samsung/sxgbe/sxgbe_main.c
> index c56fcbb37066..03a82cbf4b40 100644
> --- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
> +++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
> @@ -1572,7 +1572,7 @@ static int sxgbe_poll(struct napi_struct *napi, int=
 budget)
>   *   netdev structure and arrange for the device to be reset to a sane s=
tate
>   *   in order to transmit a new packet.
>   */
> -static void sxgbe_tx_timeout(struct net_device *dev)
> +static void sxgbe_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct sxgbe_priv_data *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/se=
eq/ether3.c
> index 632a7c85964d..5ddf459ae7cd 100644
> --- a/drivers/net/ethernet/seeq/ether3.c
> +++ b/drivers/net/ethernet/seeq/ether3.c
> @@ -79,7 +79,7 @@ static netdev_tx_t    ether3_sendpacket(struct sk_buff =
*skb,
>  static irqreturn_t ether3_interrupt (int irq, void *dev_id);
>  static int     ether3_close (struct net_device *dev);
>  static void    ether3_setmulticastlist (struct net_device *dev);
> -static void    ether3_timeout(struct net_device *dev);
> +static void    ether3_timeout(struct net_device *dev, int txqueue);
>
>  #define BUS_16         2
>  #define BUS_8          1
> @@ -450,7 +450,7 @@ static void ether3_setmulticastlist(struct net_device=
 *dev)
>         ether3_outw(priv(dev)->regs.config1 | CFG1_LOCBUFMEM, REG_CONFIG1=
);
>  }
>
> -static void ether3_timeout(struct net_device *dev)
> +static void ether3_timeout(struct net_device *dev, int txqueue)
>  {
>         unsigned long flags;
>
> diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/s=
eeq/sgiseeq.c
> index 276c7cae7cee..90a10a853678 100644
> --- a/drivers/net/ethernet/seeq/sgiseeq.c
> +++ b/drivers/net/ethernet/seeq/sgiseeq.c
> @@ -645,7 +645,7 @@ sgiseeq_start_xmit(struct sk_buff *skb, struct net_de=
vice *dev)
>         return NETDEV_TX_OK;
>  }
>
> -static void timeout(struct net_device *dev)
> +static void timeout(struct net_device *dev, int txqueue)
>  {
>         printk(KERN_NOTICE "%s: transmit timed out, resetting\n", dev->na=
me);
>         sgiseeq_reset(dev);
> diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/s=
gi/ioc3-eth.c
> index deb636d653f3..60d638e705af 100644
> --- a/drivers/net/ethernet/sgi/ioc3-eth.c
> +++ b/drivers/net/ethernet/sgi/ioc3-eth.c
> @@ -113,7 +113,7 @@ struct ioc3_private {
>  static int ioc3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)=
;
>  static void ioc3_set_multicast_list(struct net_device *dev);
>  static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_devic=
e *dev);
> -static void ioc3_timeout(struct net_device *dev);
> +static void ioc3_timeout(struct net_device *dev, int txqueue);
>  static inline unsigned int ioc3_hash(const unsigned char *addr);
>  static void ioc3_start(struct ioc3_private *ip);
>  static inline void ioc3_stop(struct ioc3_private *ip);
> @@ -1493,7 +1493,7 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *=
skb, struct net_device *dev)
>         return NETDEV_TX_OK;
>  }
>
> -static void ioc3_timeout(struct net_device *dev)
> +static void ioc3_timeout(struct net_device *dev, int txqueue)
>  {
>         struct ioc3_private *ip =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/sgi/meth.c b/drivers/net/ethernet/sgi/m=
eth.c
> index 539bc5db989c..49a122cfef48 100644
> --- a/drivers/net/ethernet/sgi/meth.c
> +++ b/drivers/net/ethernet/sgi/meth.c
> @@ -90,7 +90,7 @@ struct meth_private {
>         spinlock_t meth_lock;
>  };
>
> -static void meth_tx_timeout(struct net_device *dev);
> +static void meth_tx_timeout(struct net_device *dev, int txqueue);
>  static irqreturn_t meth_interrupt(int irq, void *dev_id);
>
>  /* global, initialized in ip32-setup.c */
> @@ -727,7 +727,7 @@ static netdev_tx_t meth_tx(struct sk_buff *skb, struc=
t net_device *dev)
>  /*
>   * Deal with a transmit timeout.
>   */
> -static void meth_tx_timeout(struct net_device *dev)
> +static void meth_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct meth_private *priv =3D netdev_priv(dev);
>         unsigned long flags;
> diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/=
silan/sc92031.c
> index c7641a236eb8..88c4844b6caa 100644
> --- a/drivers/net/ethernet/silan/sc92031.c
> +++ b/drivers/net/ethernet/silan/sc92031.c
> @@ -1078,7 +1078,7 @@ static void sc92031_set_multicast_list(struct net_d=
evice *dev)
>         spin_unlock_bh(&priv->lock);
>  }
>
> -static void sc92031_tx_timeout(struct net_device *dev)
> +static void sc92031_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct sc92031_priv *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis=
/sis190.c
> index 5b351beb78cb..70cb98506e77 100644
> --- a/drivers/net/ethernet/sis/sis190.c
> +++ b/drivers/net/ethernet/sis/sis190.c
> @@ -1538,7 +1538,7 @@ static struct net_device *sis190_init_board(struct =
pci_dev *pdev)
>         goto out;
>  }
>
> -static void sis190_tx_timeout(struct net_device *dev)
> +static void sis190_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct sis190_private *tp =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D tp->mmio_addr;
> diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/s=
msc/epic100.c
> index be47d864f8b9..1a6a344e8301 100644
> --- a/drivers/net/ethernet/smsc/epic100.c
> +++ b/drivers/net/ethernet/smsc/epic100.c
> @@ -291,7 +291,7 @@ static int mdio_read(struct net_device *dev, int phy_=
id, int location);
>  static void mdio_write(struct net_device *dev, int phy_id, int loc, int =
val);
>  static void epic_restart(struct net_device *dev);
>  static void epic_timer(struct timer_list *t);
> -static void epic_tx_timeout(struct net_device *dev);
> +static void epic_tx_timeout(struct net_device *dev, int txqueue);
>  static void epic_init_ring(struct net_device *dev);
>  static netdev_tx_t epic_start_xmit(struct sk_buff *skb,
>                                    struct net_device *dev);
> @@ -861,7 +861,7 @@ static void epic_timer(struct timer_list *t)
>         add_timer(&ep->timer);
>  }
>
> -static void epic_tx_timeout(struct net_device *dev)
> +static void epic_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct epic_private *ep =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D ep->ioaddr;
> diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/s=
msc/smc911x.c
> index 8d88e4083456..f2fce068be39 100644
> --- a/drivers/net/ethernet/smsc/smc911x.c
> +++ b/drivers/net/ethernet/smsc/smc911x.c
> @@ -1245,7 +1245,7 @@ static void smc911x_poll_controller(struct net_devi=
ce *dev)
>  #endif
>
>  /* Our watchdog timed out. Called by the networking layer */
> -static void smc911x_timeout(struct net_device *dev)
> +static void smc911x_timeout(struct net_device *dev, int txqueue)
>  {
>         struct smc911x_local *lp =3D netdev_priv(dev);
>         int status, mask;
> diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/s=
msc/smc9194.c
> index d3bb2ba51f40..887e42031361 100644
> --- a/drivers/net/ethernet/smsc/smc9194.c
> +++ b/drivers/net/ethernet/smsc/smc9194.c
> @@ -216,7 +216,7 @@ static int smc_open(struct net_device *dev);
>  /*
>   . Our watchdog timed out. Called by the networking layer
>  */
> -static void smc_timeout(struct net_device *dev);
> +static void smc_timeout(struct net_device *dev, int txqueue);
>
>  /*
>   . This is called by the kernel in response to 'ifconfig ethX down'.  It
> @@ -1094,7 +1094,7 @@ static int smc_open(struct net_device *dev)
>   .--------------------------------------------------------
>  */
>
> -static void smc_timeout(struct net_device *dev)
> +static void smc_timeout(struct net_device *dev, int txqueue)
>  {
>         /* If we get here, some higher level has decided we are broken.
>            There should really be a "kick me" function call instead. */
> diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethern=
et/smsc/smc91c92_cs.c
> index a55f430f6a7b..3c0f964cb6cc 100644
> --- a/drivers/net/ethernet/smsc/smc91c92_cs.c
> +++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
> @@ -271,7 +271,7 @@ static void smc91c92_release(struct pcmcia_device *li=
nk);
>  static int smc_open(struct net_device *dev);
>  static int smc_close(struct net_device *dev);
>  static int smc_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
> -static void smc_tx_timeout(struct net_device *dev);
> +static void smc_tx_timeout(struct net_device *dev, int txqueue);
>  static netdev_tx_t smc_start_xmit(struct sk_buff *skb,
>                                         struct net_device *dev);
>  static irqreturn_t smc_interrupt(int irq, void *dev_id);
> @@ -1178,7 +1178,7 @@ static void smc_hardware_send_packet(struct net_dev=
ice * dev)
>
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
>
> -static void smc_tx_timeout(struct net_device *dev)
> +static void smc_tx_timeout(struct net_device *dev, int txqueue)
>  {
>      struct smc_private *smc =3D netdev_priv(dev);
>      unsigned int ioaddr =3D dev->base_addr;
> diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/sm=
sc/smc91x.c
> index 3a6761131f4c..d65061a4b1c5 100644
> --- a/drivers/net/ethernet/smsc/smc91x.c
> +++ b/drivers/net/ethernet/smsc/smc91x.c
> @@ -1321,7 +1321,7 @@ static void smc_poll_controller(struct net_device *=
dev)
>  #endif
>
>  /* Our watchdog timed out. Called by the networking layer */
> -static void smc_timeout(struct net_device *dev)
> +static void smc_timeout(struct net_device *dev, int txqueue)
>  {
>         struct smc_local *lp =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D lp->base;
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index f826365c979d..5055d70fc648 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -3712,7 +3712,7 @@ static int stmmac_napi_poll_tx(struct napi_struct *=
napi, int budget)
>   *   netdev structure and arrange for the device to be reset to a sane s=
tate
>   *   in order to transmit a new packet.
>   */
> -static void stmmac_tx_timeout(struct net_device *dev)
> +static void stmmac_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct stmmac_priv *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/su=
n/cassini.c
> index c91876f8c536..f83649240e6b 100644
> --- a/drivers/net/ethernet/sun/cassini.c
> +++ b/drivers/net/ethernet/sun/cassini.c
> @@ -2666,7 +2666,7 @@ static void cas_netpoll(struct net_device *dev)
>  }
>  #endif
>
> -static void cas_tx_timeout(struct net_device *dev)
> +static void cas_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct cas *cp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/ni=
u.c
> index f5fd1f3c07cc..8975d0b277af 100644
> --- a/drivers/net/ethernet/sun/niu.c
> +++ b/drivers/net/ethernet/sun/niu.c
> @@ -6517,7 +6517,7 @@ static void niu_reset_task(struct work_struct *work=
)
>         spin_unlock_irqrestore(&np->lock, flags);
>  }
>
> -static void niu_tx_timeout(struct net_device *dev)
> +static void niu_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct niu *np =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/su=
n/sunbmac.c
> index e9b757b03b56..968b71b10a0d 100644
> --- a/drivers/net/ethernet/sun/sunbmac.c
> +++ b/drivers/net/ethernet/sun/sunbmac.c
> @@ -941,7 +941,7 @@ static int bigmac_close(struct net_device *dev)
>         return 0;
>  }
>
> -static void bigmac_tx_timeout(struct net_device *dev)
> +static void bigmac_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct bigmac *bp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun=
/sungem.c
> index 3e7631160384..da1499473f3b 100644
> --- a/drivers/net/ethernet/sun/sungem.c
> +++ b/drivers/net/ethernet/sun/sungem.c
> @@ -970,7 +970,7 @@ static void gem_poll_controller(struct net_device *de=
v)
>  }
>  #endif
>
> -static void gem_tx_timeout(struct net_device *dev)
> +static void gem_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct gem *gp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun=
/sunhme.c
> index d007dfeba5c3..74e9bf5e4a93 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2246,7 +2246,7 @@ static int happy_meal_close(struct net_device *dev)
>  #define SXD(x)
>  #endif
>
> -static void happy_meal_tx_timeout(struct net_device *dev)
> +static void happy_meal_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct happy_meal *hp =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/sun/sunqe.c b/drivers/net/ethernet/sun/=
sunqe.c
> index 1468fa0a54e9..6704a6b2029d 100644
> --- a/drivers/net/ethernet/sun/sunqe.c
> +++ b/drivers/net/ethernet/sun/sunqe.c
> @@ -544,7 +544,7 @@ static void qe_tx_reclaim(struct sunqe *qep)
>         qep->tx_old =3D elem;
>  }
>
> -static void qe_tx_timeout(struct net_device *dev)
> +static void qe_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct sunqe *qep =3D netdev_priv(dev);
>         int tx_full;
> diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net=
/ethernet/synopsys/dwc-xlgmac-net.c
> index a1f5a1e61040..5709ce0ace6a 100644
> --- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
> +++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
> @@ -689,7 +689,7 @@ static int xlgmac_close(struct net_device *netdev)
>         return 0;
>  }
>
> -static void xlgmac_tx_timeout(struct net_device *netdev)
> +static void xlgmac_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct xlgmac_pdata *pdata =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cp=
mac.c
> index 3a655a4dc10e..0b90a7ee565a 100644
> --- a/drivers/net/ethernet/ti/cpmac.c
> +++ b/drivers/net/ethernet/ti/cpmac.c
> @@ -797,7 +797,7 @@ static irqreturn_t cpmac_irq(int irq, void *dev_id)
>         return IRQ_HANDLED;
>  }
>
> -static void cpmac_tx_timeout(struct net_device *dev)
> +static void cpmac_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct cpmac_priv *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cps=
w.c
> index f298d714efd6..fe085525e8e4 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -2035,7 +2035,7 @@ static int cpsw_ndo_ioctl(struct net_device *dev, s=
truct ifreq *req, int cmd)
>         return phy_mii_ioctl(cpsw->slaves[slave_no].phy, req, cmd);
>  }
>
> -static void cpsw_ndo_tx_timeout(struct net_device *ndev)
> +static void cpsw_ndo_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct cpsw_priv *priv =3D netdev_priv(ndev);
>         struct cpsw_common *cpsw =3D priv->cpsw;
> diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/etherne=
t/ti/davinci_emac.c
> index ae27be85e363..ea0927082539 100644
> --- a/drivers/net/ethernet/ti/davinci_emac.c
> +++ b/drivers/net/ethernet/ti/davinci_emac.c
> @@ -983,7 +983,7 @@ static int emac_dev_xmit(struct sk_buff *skb, struct =
net_device *ndev)
>   * error and re-initialize the TX channel for hardware operation
>   *
>   */
> -static void emac_dev_tx_timeout(struct net_device *ndev)
> +static void emac_dev_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct emac_priv *priv =3D netdev_priv(ndev);
>         struct device *emac_dev =3D &ndev->dev;
> diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/=
ti/netcp_core.c
> index 1b2702f74455..41da2a2ba5fc 100644
> --- a/drivers/net/ethernet/ti/netcp_core.c
> +++ b/drivers/net/ethernet/ti/netcp_core.c
> @@ -1811,7 +1811,7 @@ static int netcp_ndo_ioctl(struct net_device *ndev,
>         return (ret =3D=3D 0) ? 0 : err;
>  }
>
> -static void netcp_ndo_tx_timeout(struct net_device *ndev)
> +static void netcp_ndo_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct netcp_intf *netcp =3D netdev_priv(ndev);
>         unsigned int descs =3D knav_pool_count(netcp->tx_pool);
> diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tla=
n.c
> index 78f0f2d59e22..5f186cf5077e 100644
> --- a/drivers/net/ethernet/ti/tlan.c
> +++ b/drivers/net/ethernet/ti/tlan.c
> @@ -161,7 +161,7 @@ static void tlan_set_multicast_list(struct net_device=
 *);
>  static int     tlan_ioctl(struct net_device *dev, struct ifreq *rq, int =
cmd);
>  static int      tlan_probe1(struct pci_dev *pdev, long ioaddr,
>                             int irq, int rev, const struct pci_device_id =
*ent);
> -static void    tlan_tx_timeout(struct net_device *dev);
> +static void    tlan_tx_timeout(struct net_device *dev, int txqueue);
>  static void    tlan_tx_timeout_work(struct work_struct *work);
>  static int     tlan_init_one(struct pci_dev *pdev,
>                               const struct pci_device_id *ent);
> @@ -997,7 +997,7 @@ static int tlan_ioctl(struct net_device *dev, struct =
ifreq *rq, int cmd)
>   *
>   **************************************************************/
>
> -static void tlan_tx_timeout(struct net_device *dev)
> +static void tlan_tx_timeout(struct net_device *dev, int txqueue)
>  {
>
>         TLAN_DBG(TLAN_DEBUG_GNRL, "%s: Transmit timed out.\n", dev->name)=
;
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.c
> index 9d9f8acb7ee3..558e93532158 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -1405,7 +1405,7 @@ static void gelic_net_tx_timeout_task(struct work_s=
truct *work)
>   *
>   * called, if tx hangs. Schedules a task that resets the interface
>   */
> -void gelic_net_tx_timeout(struct net_device *netdev)
> +void gelic_net_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct gelic_card *card;
>
> diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethe=
rnet/toshiba/spider_net.c
> index 538e70810d3d..12355225f556 100644
> --- a/drivers/net/ethernet/toshiba/spider_net.c
> +++ b/drivers/net/ethernet/toshiba/spider_net.c
> @@ -2180,7 +2180,7 @@ spider_net_tx_timeout_task(struct work_struct *work=
)
>   * called, if tx hangs. Schedules a task that resets the interface
>   */
>  static void
> -spider_net_tx_timeout(struct net_device *netdev)
> +spider_net_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct spider_net_card *card;
>
> diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/etherne=
t/toshiba/tc35815.c
> index 12466a72cefc..85758ac93f04 100644
> --- a/drivers/net/ethernet/toshiba/tc35815.c
> +++ b/drivers/net/ethernet/toshiba/tc35815.c
> @@ -483,7 +483,7 @@ static void tc35815_txdone(struct net_device *dev);
>  static int     tc35815_close(struct net_device *dev);
>  static struct  net_device_stats *tc35815_get_stats(struct net_device *de=
v);
>  static void    tc35815_set_multicast_list(struct net_device *dev);
> -static void    tc35815_tx_timeout(struct net_device *dev);
> +static void    tc35815_tx_timeout(struct net_device *dev, int txqueue);
>  static int     tc35815_ioctl(struct net_device *dev, struct ifreq *rq, i=
nt cmd);
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  static void    tc35815_poll_controller(struct net_device *dev);
> @@ -1189,7 +1189,7 @@ static void tc35815_schedule_restart(struct net_dev=
ice *dev)
>         spin_unlock_irqrestore(&lp->lock, flags);
>  }
>
> -static void tc35815_tx_timeout(struct net_device *dev)
> +static void tc35815_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct tc35815_regs __iomem *tr =3D
>                 (struct tc35815_regs __iomem *)dev->base_addr;
> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/=
via/via-rhine.c
> index ed12dbd156f0..0cfa5a8383f4 100644
> --- a/drivers/net/ethernet/via/via-rhine.c
> +++ b/drivers/net/ethernet/via/via-rhine.c
> @@ -506,7 +506,7 @@ static void mdio_write(struct net_device *dev, int ph=
y_id, int location, int val
>  static int  rhine_open(struct net_device *dev);
>  static void rhine_reset_task(struct work_struct *work);
>  static void rhine_slow_event_task(struct work_struct *work);
> -static void rhine_tx_timeout(struct net_device *dev);
> +static void rhine_tx_timeout(struct net_device *dev, int txqueue);
>  static netdev_tx_t rhine_start_tx(struct sk_buff *skb,
>                                   struct net_device *dev);
>  static irqreturn_t rhine_interrupt(int irq, void *dev_instance);
> @@ -1761,7 +1761,7 @@ static void rhine_reset_task(struct work_struct *wo=
rk)
>         mutex_unlock(&rp->task_lock);
>  }
>
> -static void rhine_tx_timeout(struct net_device *dev)
> +static void rhine_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct rhine_private *rp =3D netdev_priv(dev);
>         void __iomem *ioaddr =3D rp->base;
> diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/w=
iznet/w5100.c
> index bede1ff289c5..86dafa2acd65 100644
> --- a/drivers/net/ethernet/wiznet/w5100.c
> +++ b/drivers/net/ethernet/wiznet/w5100.c
> @@ -790,7 +790,7 @@ static void w5100_restart_work(struct work_struct *wo=
rk)
>         w5100_restart(priv->ndev);
>  }
>
> -static void w5100_tx_timeout(struct net_device *ndev)
> +static void w5100_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct w5100_priv *priv =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/w=
iznet/w5300.c
> index 6ba2747779ce..ad4fca8996f0 100644
> --- a/drivers/net/ethernet/wiznet/w5300.c
> +++ b/drivers/net/ethernet/wiznet/w5300.c
> @@ -341,7 +341,7 @@ static void w5300_get_regs(struct net_device *ndev,
>         }
>  }
>
> -static void w5300_tx_timeout(struct net_device *ndev)
> +static void w5300_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct w5300_priv *priv =3D netdev_priv(ndev);
>
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/=
ethernet/xilinx/xilinx_emaclite.c
> index 0de52e70abcc..ee318fdb5838 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -521,7 +521,7 @@ static int xemaclite_set_mac_address(struct net_devic=
e *dev, void *address)
>   *
>   * This function is called when Tx time out occurs for Emaclite device.
>   */
> -static void xemaclite_tx_timeout(struct net_device *dev)
> +static void xemaclite_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct net_local *lp =3D netdev_priv(dev);
>         unsigned long flags;
> diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ether=
net/xircom/xirc2ps_cs.c
> index fd5288ff53b5..8ee766492f4b 100644
> --- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
> +++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
> @@ -288,7 +288,7 @@ struct local_info {
>   */
>  static netdev_tx_t do_start_xmit(struct sk_buff *skb,
>                                        struct net_device *dev);
> -static void xirc_tx_timeout(struct net_device *dev);
> +static void xirc_tx_timeout(struct net_device *dev, int txqueue);
>  static void xirc2ps_tx_timeout_task(struct work_struct *work);
>  static void set_addresses(struct net_device *dev);
>  static void set_multicast_list(struct net_device *dev);
> @@ -1203,7 +1203,7 @@ xirc2ps_tx_timeout_task(struct work_struct *work)
>  }
>
>  static void
> -xirc_tx_timeout(struct net_device *dev)
> +xirc_tx_timeout(struct net_device *dev, int txqueue)
>  {
>      struct local_info *lp =3D netdev_priv(dev);
>      dev->stats.tx_errors++;
> diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
> index b517c1af9de0..5c69eec2ee3b 100644
> --- a/drivers/net/fjes/fjes_main.c
> +++ b/drivers/net/fjes/fjes_main.c
> @@ -792,7 +792,7 @@ fjes_xmit_frame(struct sk_buff *skb, struct net_devic=
e *netdev)
>         return ret;
>  }
>
> -static void fjes_tx_retry(struct net_device *netdev)
> +static void fjes_tx_retry(struct net_device *netdev, int txqueue)
>  {
>         struct netdev_queue *queue =3D netdev_get_tx_queue(netdev, 0);
>
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index 4d479e3c817d..4e0d9817b191 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -457,7 +457,7 @@ static void slip_write_wakeup(struct tty_struct *tty)
>         schedule_work(&sl->tx_work);
>  }
>
> -static void sl_tx_timeout(struct net_device *dev)
> +static void sl_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct slip *sl =3D netdev_priv(dev);
>
> diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
> index 1e58702c737f..2984737d1195 100644
> --- a/drivers/net/usb/catc.c
> +++ b/drivers/net/usb/catc.c
> @@ -447,7 +447,7 @@ static netdev_tx_t catc_start_xmit(struct sk_buff *sk=
b,
>         return NETDEV_TX_OK;
>  }
>
> -static void catc_tx_timeout(struct net_device *netdev)
> +static void catc_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct catc *catc =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 74849da031fa..c97521931605 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -820,7 +820,7 @@ static const struct ethtool_ops ops =3D {
>  };
>
>  /* called when a packet did not ack after watchdogtimeout */
> -static void hso_net_tx_timeout(struct net_device *net)
> +static void hso_net_tx_timeout(struct net_device *net, int txqueue)
>  {
>         struct hso_net *odev =3D netdev_priv(net);
>
> diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
> index 8c01fbf68a89..232aebd5eecc 100644
> --- a/drivers/net/usb/ipheth.c
> +++ b/drivers/net/usb/ipheth.c
> @@ -400,7 +400,7 @@ static int ipheth_tx(struct sk_buff *skb, struct net_=
device *net)
>         return NETDEV_TX_OK;
>  }
>
> -static void ipheth_tx_timeout(struct net_device *net)
> +static void ipheth_tx_timeout(struct net_device *net, int txqueue)
>  {
>         struct ipheth_device *dev =3D netdev_priv(net);
>
> diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
> index 8e210ba4a313..b7a92aaccb50 100644
> --- a/drivers/net/usb/kaweth.c
> +++ b/drivers/net/usb/kaweth.c
> @@ -894,7 +894,7 @@ static void kaweth_async_set_rx_mode(struct kaweth_de=
vice *kaweth)
>  /****************************************************************
>   *     kaweth_tx_timeout
>   ****************************************************************/
> -static void kaweth_tx_timeout(struct net_device *net)
> +static void kaweth_tx_timeout(struct net_device *net, int txqueue)
>  {
>         struct kaweth_device *kaweth =3D netdev_priv(net);
>
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index f24a1b0b801f..791b3dac505e 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -3662,7 +3662,7 @@ static void lan78xx_disconnect(struct usb_interface=
 *intf)
>         usb_put_dev(udev);
>  }
>
> -static void lan78xx_tx_timeout(struct net_device *net)
> +static void lan78xx_tx_timeout(struct net_device *net, int txqueue)
>  {
>         struct lan78xx_net *dev =3D netdev_priv(net);
>
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index f7d117d80cfb..19b0cf77c5cb 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -693,7 +693,7 @@ static void intr_callback(struct urb *urb)
>                           "can't resubmit interrupt urb, %d\n", res);
>  }
>
> -static void pegasus_tx_timeout(struct net_device *net)
> +static void pegasus_tx_timeout(struct net_device *net, int txqueue)
>  {
>         pegasus_t *pegasus =3D netdev_priv(net);
>         netif_warn(pegasus, timer, net, "tx timeout\n");
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index d4a95b50bda6..d980700e99e7 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -2306,7 +2306,7 @@ static void rtl_drop_queued_tx(struct r8152 *tp)
>         }
>  }
>
> -static void rtl8152_tx_timeout(struct net_device *netdev)
> +static void rtl8152_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct r8152 *tp =3D netdev_priv(netdev);
>
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> index 13e51ccf0214..8e97b760ebf0 100644
> --- a/drivers/net/usb/rtl8150.c
> +++ b/drivers/net/usb/rtl8150.c
> @@ -655,7 +655,7 @@ static void disable_net_traffic(rtl8150_t * dev)
>         set_registers(dev, CR, 1, &cr);
>  }
>
> -static void rtl8150_tx_timeout(struct net_device *netdev)
> +static void rtl8150_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         rtl8150_t *dev =3D netdev_priv(netdev);
>         dev_warn(&netdev->dev, "Tx timeout.\n");
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxn=
et3_drv.c
> index 216acf37ca7c..09cba1a9fa67 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -3198,7 +3198,7 @@ vmxnet3_free_intr_resources(struct vmxnet3_adapter =
*adapter)
>
>
>  static void
> -vmxnet3_tx_timeout(struct net_device *netdev)
> +vmxnet3_tx_timeout(struct net_device *netdev, int txqueue)
>  {
>         struct vmxnet3_adapter *adapter =3D netdev_priv(netdev);
>         adapter->tx_timeout_count++;
> diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
> index af539151d663..7ed7518f5f9e 100644
> --- a/drivers/net/wan/cosa.c
> +++ b/drivers/net/wan/cosa.c
> @@ -268,7 +268,7 @@ static int cosa_net_attach(struct net_device *dev, un=
signed short encoding,
>                            unsigned short parity);
>  static int cosa_net_open(struct net_device *d);
>  static int cosa_net_close(struct net_device *d);
> -static void cosa_net_timeout(struct net_device *d);
> +static void cosa_net_timeout(struct net_device *d, int txqueue);
>  static netdev_tx_t cosa_net_tx(struct sk_buff *skb, struct net_device *d=
);
>  static char *cosa_net_setup_rx(struct channel_data *channel, int size);
>  static int cosa_net_rx_done(struct channel_data *channel);
> @@ -670,7 +670,7 @@ static netdev_tx_t cosa_net_tx(struct sk_buff *skb,
>         return NETDEV_TX_OK;
>  }
>
> -static void cosa_net_timeout(struct net_device *dev)
> +static void cosa_net_timeout(struct net_device *dev, int txqueue)
>  {
>         struct channel_data *chan =3D dev_to_chan(dev);
>
> diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
> index 1901ec7948d8..b050a4b89ce1 100644
> --- a/drivers/net/wan/farsync.c
> +++ b/drivers/net/wan/farsync.c
> @@ -2239,7 +2239,7 @@ fst_attach(struct net_device *dev, unsigned short e=
ncoding, unsigned short parit
>  }
>
>  static void
> -fst_tx_timeout(struct net_device *dev)
> +fst_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct fst_port_info *port;
>         struct fst_card_info *card;
> diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdl=
c.c
> index ca0f3be2b6bf..53f0686b9d3a 100644
> --- a/drivers/net/wan/fsl_ucc_hdlc.c
> +++ b/drivers/net/wan/fsl_ucc_hdlc.c
> @@ -1039,7 +1039,7 @@ static const struct dev_pm_ops uhdlc_pm_ops =3D {
>  #define HDLC_PM_OPS NULL
>
>  #endif
> -static void uhdlc_tx_timeout(struct net_device *ndev)
> +static void uhdlc_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         netdev_err(ndev, "%s\n", __func__);
>  }
> diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_mai=
n.c
> index 0e6a51525d91..72799b8a2163 100644
> --- a/drivers/net/wan/lmc/lmc_main.c
> +++ b/drivers/net/wan/lmc/lmc_main.c
> @@ -99,7 +99,7 @@ static int lmc_ifdown(struct net_device * const);
>  static void lmc_watchdog(struct timer_list *t);
>  static void lmc_reset(lmc_softc_t * const sc);
>  static void lmc_dec_reset(lmc_softc_t * const sc);
> -static void lmc_driver_timeout(struct net_device *dev);
> +static void lmc_driver_timeout(struct net_device *dev, int txqueue);
>
>  /*
>   * linux reserves 16 device specific IOCTLs.  We call them
> @@ -2044,7 +2044,7 @@ static void lmc_initcsrs(lmc_softc_t * const sc, lm=
c_csrptr_t csr_base, /*fold00
>      lmc_trace(sc->lmc_device, "lmc_initcsrs out");
>  }
>
> -static void lmc_driver_timeout(struct net_device *dev)
> +static void lmc_driver_timeout(struct net_device *dev, int txqueue)
>  {
>      lmc_softc_t *sc =3D dev_to_sc(dev);
>      u32 csr6;
> diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
> index 914be5847386..ce300f94a6e6 100644
> --- a/drivers/net/wan/x25_asy.c
> +++ b/drivers/net/wan/x25_asy.c
> @@ -276,7 +276,7 @@ static void x25_asy_write_wakeup(struct tty_struct *t=
ty)
>         sl->xhead +=3D actual;
>  }
>
> -static void x25_asy_timeout(struct net_device *dev)
> +static void x25_asy_timeout(struct net_device *dev, int txqueue)
>  {
>         struct x25_asy *sl =3D netdev_priv(dev);
>
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/w=
ireless/intel/ipw2x00/ipw2100.c
> index 8dfbaff2d1fe..ab4026f26167 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> @@ -5834,7 +5834,7 @@ static int ipw2100_close(struct net_device *dev)
>  /*
>   * TODO:  Fix this function... its just wrong
>   */
> -static void ipw2100_tx_timeout(struct net_device *dev)
> +static void ipw2100_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct ipw2100_priv *priv =3D libipw_priv(dev);
>
> diff --git a/drivers/net/wireless/intersil/hostap/hostap_main.c b/drivers=
/net/wireless/intersil/hostap/hostap_main.c
> index 05466281afb6..9061f971ce9d 100644
> --- a/drivers/net/wireless/intersil/hostap/hostap_main.c
> +++ b/drivers/net/wireless/intersil/hostap/hostap_main.c
> @@ -761,7 +761,7 @@ static void hostap_set_multicast_list(struct net_devi=
ce *dev)
>  }
>
>
> -static void prism2_tx_timeout(struct net_device *dev)
> +static void prism2_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct hostap_interface *iface;
>         local_info_t *local;
> diff --git a/drivers/net/wireless/intersil/orinoco/main.c b/drivers/net/w=
ireless/intersil/orinoco/main.c
> index 28dac36d7c4c..a240fa3b3429 100644
> --- a/drivers/net/wireless/intersil/orinoco/main.c
> +++ b/drivers/net/wireless/intersil/orinoco/main.c
> @@ -647,7 +647,7 @@ static void __orinoco_ev_txexc(struct net_device *dev=
, struct hermes *hw)
>         netif_wake_queue(dev);
>  }
>
> -void orinoco_tx_timeout(struct net_device *dev)
> +void orinoco_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct orinoco_private *priv =3D ndev_priv(dev);
>         struct net_device_stats *stats =3D &dev->stats;
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wi=
reless/marvell/mwifiex/main.c
> index a9657ae6d782..c65be42da0c6 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1019,7 +1019,7 @@ static void mwifiex_set_multicast_list(struct net_d=
evice *dev)
>   * CFG802.11 network device handler for transmission timeout.
>   */
>  static void
> -mwifiex_tx_timeout(struct net_device *dev)
> +mwifiex_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct mwifiex_private *priv =3D mwifiex_netdev_get_priv(dev);
>
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/=
wireless/quantenna/qtnfmac/core.c
> index 8d699cc03d26..d3e6e5a4b067 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/core.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
> @@ -148,7 +148,7 @@ static void qtnf_netdev_get_stats64(struct net_device=
 *ndev,
>
>  /* Netdev handler for transmission timeout.
>   */
> -static void qtnf_netdev_tx_timeout(struct net_device *ndev)
> +static void qtnf_netdev_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct qtnf_vif *vif =3D qtnf_netdev_get_priv(ndev);
>         struct qtnf_wmac *mac;
> diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl35=
01_cs.c
> index 007bf6803293..ba23bced13e1 100644
> --- a/drivers/net/wireless/wl3501_cs.c
> +++ b/drivers/net/wireless/wl3501_cs.c
> @@ -1285,7 +1285,7 @@ static int wl3501_reset(struct net_device *dev)
>         return rc;
>  }
>
> -static void wl3501_tx_timeout(struct net_device *dev)
> +static void wl3501_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct net_device_stats *stats =3D &dev->stats;
>         int rc;
> diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/z=
ydas/zd1201.c
> index 0db7362bedb4..010f2112dc2e 100644
> --- a/drivers/net/wireless/zydas/zd1201.c
> +++ b/drivers/net/wireless/zydas/zd1201.c
> @@ -830,7 +830,7 @@ static netdev_tx_t zd1201_hard_start_xmit(struct sk_b=
uff *skb,
>         return NETDEV_TX_OK;
>  }
>
> -static void zd1201_tx_timeout(struct net_device *dev)
> +static void zd1201_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct zd1201 *zd =3D netdev_priv(dev);
>
> diff --git a/drivers/staging/ks7010/ks_wlan_net.c b/drivers/staging/ks701=
0/ks_wlan_net.c
> index 3cffc8be6656..ea6cad62b552 100644
> --- a/drivers/staging/ks7010/ks_wlan_net.c
> +++ b/drivers/staging/ks7010/ks_wlan_net.c
> @@ -45,7 +45,7 @@ struct wep_key {
>   *     function prototypes
>   */
>  static int ks_wlan_open(struct net_device *dev);
> -static void ks_wlan_tx_timeout(struct net_device *dev);
> +static void ks_wlan_tx_timeout(struct net_device *dev, int txqueue);
>  static int ks_wlan_start_xmit(struct sk_buff *skb, struct net_device *de=
v);
>  static int ks_wlan_close(struct net_device *dev);
>  static void ks_wlan_set_rx_mode(struct net_device *dev);
> @@ -2498,7 +2498,7 @@ int ks_wlan_set_mac_address(struct net_device *dev,=
 void *addr)
>  }
>
>  static
> -void ks_wlan_tx_timeout(struct net_device *dev)
> +void ks_wlan_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct ks_wlan_private *priv =3D netdev_priv(dev);
>
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge=
_main.c
> index 6cae33072496..d1be1f9c2aac 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -4436,7 +4436,7 @@ static int qlge_set_mac_address(struct net_device *=
ndev, void *p)
>         return status;
>  }
>
> -static void qlge_tx_timeout(struct net_device *ndev)
> +static void qlge_tx_timeout(struct net_device *ndev, int txqueue)
>  {
>         struct ql_adapter *qdev =3D netdev_priv(ndev);
>         ql_queue_asic_error(qdev);
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/stagi=
ng/rtl8192e/rtl8192e/rtl_core.c
> index f932cb15e4e5..f9479962030b 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
> @@ -267,7 +267,7 @@ static short _rtl92e_check_nic_enough_desc(struct net=
_device *dev, int prio)
>         return 0;
>  }
>
> -static void _rtl92e_tx_timeout(struct net_device *dev)
> +static void _rtl92e_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct r8192_priv *priv =3D rtllib_priv(dev);
>
> diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl=
8192u/r8192U_core.c
> index 2821411878ce..387bb04bf9ac 100644
> --- a/drivers/staging/rtl8192u/r8192U_core.c
> +++ b/drivers/staging/rtl8192u/r8192U_core.c
> @@ -654,7 +654,7 @@ short check_nic_enough_desc(struct net_device *dev, i=
nt queue_index)
>         return (used < MAX_TX_URB);
>  }
>
> -static void tx_timeout(struct net_device *dev)
> +static void tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct r8192_priv *priv =3D ieee80211_priv(dev);
>
> diff --git a/drivers/staging/unisys/visornic/visornic_main.c b/drivers/st=
aging/unisys/visornic/visornic_main.c
> index 1d1440d43002..42e5d760e33d 100644
> --- a/drivers/staging/unisys/visornic/visornic_main.c
> +++ b/drivers/staging/unisys/visornic/visornic_main.c
> @@ -1078,7 +1078,7 @@ static void visornic_set_multi(struct net_device *n=
etdev)
>   * Queue the work and return. Make sure we have not already been informe=
d that
>   * the IO Partition is gone; if so, we will have already timed-out the x=
mits.
>   */
> -static void visornic_xmit_timeout(struct net_device *netdev)
> +static void visornic_xmit_timeout(struct net_device *netdev, int txqueue=
)
>  {
>         struct visornic_devdata *devdata =3D netdev_priv(netdev);
>         unsigned long flags;
> diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wla=
n-ng/p80211netdev.c
> index a70fb84f38f1..65e6b619a1b3 100644
> --- a/drivers/staging/wlan-ng/p80211netdev.c
> +++ b/drivers/staging/wlan-ng/p80211netdev.c
> @@ -101,7 +101,7 @@ static void p80211knetdev_set_multicast_list(struct n=
et_device *dev);
>  static int p80211knetdev_do_ioctl(struct net_device *dev, struct ifreq *=
ifr,
>                                   int cmd);
>  static int p80211knetdev_set_mac_address(struct net_device *dev, void *a=
ddr);
> -static void p80211knetdev_tx_timeout(struct net_device *netdev);
> +static void p80211knetdev_tx_timeout(struct net_device *netdev, int txqu=
eue);
>  static int p80211_rx_typedrop(struct wlandevice *wlandev, u16 fc);
>
>  int wlan_watchdog =3D 5000;
> @@ -1074,7 +1074,7 @@ static int p80211_rx_typedrop(struct wlandevice *wl=
andev, u16 fc)
>         return drop;
>  }
>
> -static void p80211knetdev_tx_timeout(struct net_device *netdev)
> +static void p80211knetdev_tx_timeout(struct net_device *netdev, int txqu=
eue)
>  {
>         struct wlandevice *wlandev =3D netdev->ml_priv;
>
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 36a3eb4ad4c5..973387ee9a25 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -2704,7 +2704,7 @@ static netdev_tx_t gsm_mux_net_start_xmit(struct sk=
_buff *skb,
>  }
>
>  /* called when a packet did not ack after watchdogtimeout */
> -static void gsm_mux_net_tx_timeout(struct net_device *net)
> +static void gsm_mux_net_tx_timeout(struct net_device *net, int txqueue)
>  {
>         /* Tell syslog we are hosed. */
>         dev_dbg(&net->dev, "Tx timed out.\n");
> diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
> index 84f26e43b229..6d529d04b407 100644
> --- a/drivers/tty/synclink.c
> +++ b/drivers/tty/synclink.c
> @@ -7837,7 +7837,7 @@ static int hdlcdev_ioctl(struct net_device *dev, st=
ruct ifreq *ifr, int cmd)
>   *
>   * dev  pointer to network device structure
>   */
> -static void hdlcdev_tx_timeout(struct net_device *dev)
> +static void hdlcdev_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct mgsl_struct *info =3D dev_to_port(dev);
>         unsigned long flags;
> diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
> index e8a9047de451..c2aeb3fb45c6 100644
> --- a/drivers/tty/synclink_gt.c
> +++ b/drivers/tty/synclink_gt.c
> @@ -1682,7 +1682,7 @@ static int hdlcdev_ioctl(struct net_device *dev, st=
ruct ifreq *ifr, int cmd)
>   *
>   * dev  pointer to network device structure
>   */
> -static void hdlcdev_tx_timeout(struct net_device *dev)
> +static void hdlcdev_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         struct slgt_info *info =3D dev_to_port(dev);
>         unsigned long flags;
> diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
> index fcb91bf7a15b..f634263278e1 100644
> --- a/drivers/tty/synclinkmp.c
> +++ b/drivers/tty/synclinkmp.c
> @@ -1807,7 +1807,7 @@ static int hdlcdev_ioctl(struct net_device *dev, st=
ruct ifreq *ifr, int cmd)
>   *
>   * dev  pointer to network device structure
>   */
> -static void hdlcdev_tx_timeout(struct net_device *dev)
> +static void hdlcdev_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         SLMP_INFO *info =3D dev_to_port(dev);
>         unsigned long flags;
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index c20f190b4c18..de71595fa29e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1004,7 +1004,7 @@ struct tlsdev_ops;
>   *     Called when a user wants to change the Maximum Transfer Unit
>   *     of a device.
>   *
> - * void (*ndo_tx_timeout)(struct net_device *dev);
> + * void (*ndo_tx_timeout)(struct net_device *dev, int txqueue);
>   *     Callback used when the transmitter has not made any progress
>   *     for dev->watchdog ticks.
>   *
> @@ -1271,7 +1271,8 @@ struct net_device_ops {
>                                                   int new_mtu);
>         int                     (*ndo_neigh_setup)(struct net_device *dev=
,
>                                                    struct neigh_parms *);
> -       void                    (*ndo_tx_timeout) (struct net_device *dev=
);
> +       void                    (*ndo_tx_timeout) (struct net_device *dev=
,
> +                                                  int txqueue);
>
>         void                    (*ndo_get_stats64)(struct net_device *dev=
,
>                                                    struct rtnl_link_stats=
64 *storage);
> diff --git a/net/atm/lec.c b/net/atm/lec.c
> index 5a77c235a212..c74dfde1e711 100644
> --- a/net/atm/lec.c
> +++ b/net/atm/lec.c
> @@ -194,7 +194,7 @@ lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
>         dev->stats.tx_bytes +=3D skb->len;
>  }
>
> -static void lec_tx_timeout(struct net_device *dev)
> +static void lec_tx_timeout(struct net_device *dev, int txqueue)
>  {
>         pr_info("%s\n", dev->name);
>         netif_trans_update(dev);
> diff --git a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
> index 1d4d7d415730..a9085d15c490 100644
> --- a/net/bluetooth/bnep/netdev.c
> +++ b/net/bluetooth/bnep/netdev.c
> @@ -112,7 +112,7 @@ static int bnep_net_set_mac_addr(struct net_device *d=
ev, void *arg)
>         return 0;
>  }
>
> -static void bnep_net_timeout(struct net_device *dev)
> +static void bnep_net_timeout(struct net_device *dev, int txqueue)
>  {
>         BT_DBG("net_timeout");
>         netif_wake_queue(dev);
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 8769b4b8807d..794b656b48c7 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -446,7 +446,7 @@ static void dev_watchdog(struct timer_list *t)
>                                 trace_net_dev_xmit_timeout(dev, i);
>                                 WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: =
%s (%s): transmit queue %u timed out\n",
>                                        dev->name, netdev_drivername(dev),=
 i);
> -                               dev->netdev_ops->ndo_tx_timeout(dev);
> +                               dev->netdev_ops->ndo_tx_timeout(dev, i);
>                         }
>                         if (!mod_timer(&dev->watchdog_timer,
>                                        round_jiffies(jiffies +
>
