Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B509C395F05
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhEaOGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:06:47 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:7004 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbhEaOEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 10:04:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622469782; x=1654005782;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aOLRh1nZ8qZ4yWi4WFrdL0SqA6I+bc8OYXSH743isV4=;
  b=RF74oivFBO+8TcQwD/JmYZIsl31S5CnNJKsiCfrKp/q/+hJNxQ5pTArM
   BdtjAWy+sBE9VzEMwwXoYHCME6/45+wthbp7n2ZeIDslYppM/CW727MMT
   Fz4ff8fXmY45ltV4lY7SXILN0W3ZZc35nP4Ropbne42GjF2HCj+93TnB8
   FogKf+rT6GXuk3nyvOMNMfKBOO7bBwwZSPq7fdI1/cigAkqv3HNV216os
   3dThxKV3qMK0NRdK6q6r2rAfZIo9ss6nUswuUsW75HeUFXbCSnqojitZN
   Pr0Oqx2nYTWFm4As7SaIx+kk6A72TsmWsVENQnzchrqCc9ShdX1QuKUJp
   g==;
IronPort-SDR: L0agBqlugw/Gm3todf9i0+72kN5ygBPWH10PzC463dzXZ1yH3mW900QuF4EogyIatbu+8Lx8T9
 9lrRKFC7GvF17uxfOxcPDXK5jti/cAWWKPVdJGeRcfcoJyzEzvtlS+el2aH5WmSkPCcxMwlr2k
 kSHfIGokvLFJsJN8mnrAuZtqgiNj+vgWo04oV3tH6S6UBKj77OZE/BHAX8aqeDiLX6L3RHHAfq
 mLyoTg8ZV//QPxYfvZKH1CeO7ncub46nZ2cMqdXLlJUieDEHNkyWUSxU/R5Tm08BTPaLzNCKgO
 R1E=
X-IronPort-AV: E=Sophos;i="5.83,237,1616482800"; 
   d="scan'208";a="122982447"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 May 2021 07:02:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 07:02:57 -0700
Received: from [10.205.21.35] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 31 May 2021 07:02:54 -0700
Message-ID: <5719f0fad28e453e0398048ebcfbc421b85a9647.camel@microchip.com>
Subject: Re: [PATCH net-next v2 03/10] net: sparx5: add hostmode with
 phylink support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Mon, 31 May 2021 16:02:54 +0200
In-Reply-To: <20210530141502.561920a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210528123419.1142290-1-steen.hegelund@microchip.com>
         <20210528123419.1142290-4-steen.hegelund@microchip.com>
         <20210530141502.561920a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thanks for your review.

On Sun, 2021-05-30 at 14:15 -0700, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 28 May 2021 14:34:12 +0200 Steen Hegelund wrote:
> > This patch adds netdevs and phylink support for the ports in the switch.
> > It also adds register based injection and extraction for these ports.
> > 
> > Frame DMA support for injection and extraction will be added in a later
> > series.
> 
> > +struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
> > +{
> > +     struct sparx5_port *spx5_port;
> > +     struct net_device *ndev;
> > +     u64 val;
> > +
> > +     ndev = devm_alloc_etherdev(sparx5->dev, sizeof(struct sparx5_port));
> > +     if (!ndev)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     SET_NETDEV_DEV(ndev, sparx5->dev);
> > +     spx5_port = netdev_priv(ndev);
> > +     spx5_port->ndev = ndev;
> > +     spx5_port->sparx5 = sparx5;
> > +     spx5_port->portno = portno;
> > +     sparx5_set_port_ifh(spx5_port->ifh, portno);
> > +
> > +     ndev->netdev_ops = &sparx5_port_netdev_ops;
> > +     ndev->features |= NETIF_F_LLTX; /* software tx */
> 
> Is your transmission method really lockless? How does
> simultaneous Tx from two CPUs work?

Hmm, no that is a mistake.  I can also see that NETIF_F_LLTX is not recommended, so I will remove
that.
> 
> > +     val = ether_addr_to_u64(sparx5->base_mac) + portno + 1;
> > +     u64_to_ether_addr(val, ndev->dev_addr);
> > +
> > +     return ndev;
> > +}
> 
> > +static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
> > +{
> > +     bool eof_flag = false, pruned_flag = false, abort_flag = false;
> > +     struct net_device *netdev;
> > +     struct sparx5_port *port;
> > +     struct frame_info fi;
> > +     int i, byte_cnt = 0;
> > +     struct sk_buff *skb;
> > +     u32 ifh[IFH_LEN];
> > +     u32 *rxbuf;
> > +
> > +     /* Get IFH */
> > +     for (i = 0; i < IFH_LEN; i++)
> > +             ifh[i] = spx5_rd(sparx5, QS_XTR_RD(grp));
> > +
> > +     /* Decode IFH (whats needed) */
> > +     sparx5_ifh_parse(ifh, &fi);
> > +
> > +     /* Map to port netdev */
> > +     port = fi.src_port < SPX5_PORTS ?
> > +             sparx5->ports[fi.src_port] : NULL;
> > +     if (!port || !port->ndev) {
> > +             dev_err(sparx5->dev, "Data on inactive port %d\n", fi.src_port);
> > +             sparx5_xtr_flush(sparx5, grp);
> > +             return;
> 
> You should probably increment appropriate counter for each error
> condition.

At this first check I do not have the netdev, so it will not be possible to update any counters, but
below I can use rx_dropped.  Is that what you mean?

> 
> > +     }
> > +
> > +     /* Have netdev, get skb */
> > +     netdev = port->ndev;
> > +     skb = netdev_alloc_skb(netdev, netdev->mtu + ETH_HLEN);
> > +     if (!skb) {
> > +             sparx5_xtr_flush(sparx5, grp);
> > +             dev_err(sparx5->dev, "No skb allocated\n");
> > +             return;
> > +     }
> > +     rxbuf = (u32 *)skb->data;
> > +
> > +     /* Now, pull frame data */
> > +     while (!eof_flag) {
> > +             u32 val = spx5_rd(sparx5, QS_XTR_RD(grp));
> > +             u32 cmp = val;
> > +
> > +             if (byte_swap)
> > +                     cmp = ntohl((__force __be32)val);
> > +
> > +             switch (cmp) {
> > +             case XTR_NOT_READY:
> > +                     break;
> > +             case XTR_ABORT:
> > +                     /* No accompanying data */
> > +                     abort_flag = true;
> > +                     eof_flag = true;
> > +                     break;
> > +             case XTR_EOF_0:
> > +             case XTR_EOF_1:
> > +             case XTR_EOF_2:
> > +             case XTR_EOF_3:
> > +                     /* This assumes STATUS_WORD_POS == 1, Status
> > +                      * just after last data
> > +                      */
> > +                     byte_cnt -= (4 - XTR_VALID_BYTES(val));
> > +                     eof_flag = true;
> > +                     break;
> > +             case XTR_PRUNED:
> > +                     /* But get the last 4 bytes as well */
> > +                     eof_flag = true;
> > +                     pruned_flag = true;
> > +                     fallthrough;
> > +             case XTR_ESCAPE:
> > +                     *rxbuf = spx5_rd(sparx5, QS_XTR_RD(grp));
> > +                     byte_cnt += 4;
> > +                     rxbuf++;
> > +                     break;
> > +             default:
> > +                     *rxbuf = val;
> > +                     byte_cnt += 4;
> > +                     rxbuf++;
> > +             }
> > +     }
> > +
> > +     if (abort_flag || pruned_flag || !eof_flag) {
> > +             netdev_err(netdev, "Discarded frame: abort:%d pruned:%d eof:%d\n",
> > +                        abort_flag, pruned_flag, eof_flag);
> > +             kfree_skb(skb);
> > +             return;
> > +     }
> > +
> > +#if defined(CONFIG_DEBUG_KERNEL) /* TODO: Remove before upstreaming */
> > +     if (!netif_oper_up(netdev)) {
> > +             netdev_err(netdev, "Discarded frame: Interface not up\n");
> > +             kfree_skb(skb);
> > +             return;
> > +     }
> > +#endif
> > +
> > +     /* Finish up skb */
> > +     skb_put(skb, byte_cnt - ETH_FCS_LEN);
> > +     eth_skb_pad(skb);
> > +     skb->protocol = eth_type_trans(skb, netdev);
> > +     netif_rx(skb);
> > +     netdev->stats.rx_bytes += skb->len;
> > +     netdev->stats.rx_packets++;
> 
> Does the Rx really need to happen in an interrupt context?
> Did you consider using NAPI or a tasklet?

This register base injection and extraction is just preliminary.  I have the next series waiting
with support for Frame DMA'ing and there I use NAPI, so if possible I would like to leave this as it
is, since it only a stopgap.

> 
> > +}
> > +
> > +static int sparx5_inject(struct sparx5 *sparx5,
> > +                      u32 *ifh,
> > +                      struct sk_buff *skb)
> > +{
> > +     int grp = INJ_QUEUE;
> > +     u32 val, w, count;
> > +     u8 *buf;
> > +
> > +     val = spx5_rd(sparx5, QS_INJ_STATUS);
> > +     if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp))) {
> > +             pr_err("Injection: Queue not ready: 0x%lx\n",
> > +                    QS_INJ_STATUS_FIFO_RDY_GET(val));
> 
> non-rate-limited errors on the datapath are a bad idea
> 
> > +             return -EBUSY;

I will change that to ratelimited prints.

> 
> What do you expect to happen at this point? Kernel can retry sending
> for ever, is there a way for the driver to find out that the fifo is
> no longer busy to stop/start the software queuing appropriately?

Hmm.  I am not too familiar with the netdev queuing, but would this be a way forward?

1) In sparx5_inject: After injecting a frame then test for HW queue readiness and watermark levels,
and if there is a problem then call netif_queue_stop

2) Add an implementation of ndo_tx_timeout where the HW queue and Watermark level is checked and if
all is OK, then do a netif_wake_queue.

3) But if the HW queue and/or Watermark level is still not OK - then probably something went
seriously wrong, or the wait was to short.  Will the ndo_tx_timeout be called again or is this a
one-off?

If the ndo_tx_timeout call is a one-off the driver would need to reset the HW queue system or even
deeper down...

> 
> > +     }
> > +
> > +     if (QS_INJ_STATUS_WMARK_REACHED_GET(val) & BIT(grp)) {
> > +             pr_err("Injection: Watermark reached: 0x%lx\n",
> > +                    QS_INJ_STATUS_WMARK_REACHED_GET(val));
> > +             return -EBUSY;
> 
> ditto

Yes.

> 
> > +     }
> > +
> > +     /* Indicate SOF */
> > +     spx5_wr(QS_INJ_CTRL_SOF_SET(1) |
> > +             QS_INJ_CTRL_GAP_SIZE_SET(1),
> > +             sparx5, QS_INJ_CTRL(grp));
> > +
> > +     // Write the IFH to the chip.
> 
> Why the mix of comment styles?

A mistake - I will update that.

> 
> > +     for (w = 0; w < IFH_LEN; w++)
> > +             spx5_wr(ifh[w], sparx5, QS_INJ_WR(grp));
> > +
> > +     /* Write words, round up */
> > +     count = ((skb->len + 3) / 4);
> 
> DIV_ROUND_UP()

I will use that instead.

> 
> > +     buf = skb->data;
> > +     for (w = 0; w < count; w++, buf += 4) {
> > +             val = get_unaligned((const u32 *)buf);
> > +             spx5_wr(val, sparx5, QS_INJ_WR(grp));
> > +     }
> > +
> > +     /* Add padding */
> > +     while (w < (60 / 4)) {
> > +             spx5_wr(0, sparx5, QS_INJ_WR(grp));
> > +             w++;
> > +     }
> > +
> > +     /* Indicate EOF and valid bytes in last word */
> > +     spx5_wr(QS_INJ_CTRL_GAP_SIZE_SET(1) |
> > +             QS_INJ_CTRL_VLD_BYTES_SET(skb->len < 60 ? 0 : skb->len % 4) |
> > +             QS_INJ_CTRL_EOF_SET(1),
> > +             sparx5, QS_INJ_CTRL(grp));
> > +
> > +     /* Add dummy CRC */
> > +     spx5_wr(0, sparx5, QS_INJ_WR(grp));
> > +     w++;
> > +
> > +     return NETDEV_TX_OK;
> > +}


