Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090E81C36CA
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 12:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgEDKXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 06:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726351AbgEDKXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 06:23:47 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF7AC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 03:23:46 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id k8so13436260ejv.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 03:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QKIehFHWwvSGI5j1A6FtkuGdpgXvVnZnjyFdcNCcJF8=;
        b=qr8TqGXlb4D2tb0+ne2Da+ZeWmUcoSEUNp75Arx2DUbi1MCd3GWLF4rCWrPThPEsDx
         uATvXfH+QXaCMXKePq4rSWqmBojLlTX07fGXIGiZfDLnP+/l+caHSZMW5gj6wtgBrIO8
         XQvIVysTazIOE/YszOyPGzsa+8HelrXAZw7fHyNfECF1h0pKIOcc8fvpw43AYCAbGMAL
         iILxiWDnpqjfRGXdfeC+nYildxd34pOnkSUxWUypydxTzuDcIiN88MxhTepk4r0YwNkA
         Syo0uLe4P2Pj2ERM6A1tZ2KXpRdsoSpaSti9bwur4qNQYPE3/jhp0fCmXG4zQ0wYyGQq
         Nssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QKIehFHWwvSGI5j1A6FtkuGdpgXvVnZnjyFdcNCcJF8=;
        b=ZPZxkDI5GnMhOtZki74JVpXUqHKEtDx/+RwoIS4MLmZCY6i62ssbynL7gNNBADiecD
         QPi5LfB792y/jeLw5vNlXZ4hO9jD4nnjj3BCl1drbZhyZdxWNjdG/MrCZnWRnd5XdWmE
         Jv8kWX/bdAVQU56XYSQF0YlLYTokUbOuzZjQBiCgic5zgHogIHTQlTyx1VktnkaEmyaU
         x9HSuPAO3ENtnDjwYtsXDsQNCCzZOIOXvCkdE50wV3sykXhwE7UnVRczEjvs10mUt8pA
         6QXMXgUI+mKSssMdqBsbTfUHFAqHvsW0/RPfNvRXniw1v8VzXtvH+J8U9Q9D2VN1ANBq
         1GbA==
X-Gm-Message-State: AGi0Puarw48xX3LGSSz8cCyxyKJXCow9ITqOb6VhUpf6Rt0fNOdGixMm
        K5zarTSPJSd/pfIc1N/VqUXJmMuvyVKfDXT0A/p4Lj1V
X-Google-Smtp-Source: APiQypLfV/REVA1t9wWKlXZlCIVJ3T/UyzTw6ZnIBS3pGt4uSR3Rf8vhSbrXmFSJEnGjx1c944pfHibLBSi85R8MpYM=
X-Received: by 2002:a17:906:2503:: with SMTP id i3mr13454264ejb.293.1588587825234;
 Mon, 04 May 2020 03:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200425120207.5400-1-dqfext@gmail.com>
In-Reply-To: <20200425120207.5400-1-dqfext@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 4 May 2020 13:23:34 +0300
Message-ID: <CA+h21hpeJK8mHduKoWn5rbmz=BEz_6HQdz3Xf63NsXpZxsky0A@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: fix roaming from DSA user ports
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qingfang,

On Sat, 25 Apr 2020 at 15:03, DENG Qingfang <dqfext@gmail.com> wrote:
>
> When a client moves from a DSA user port to a software port in a bridge,
> it cannot reach any other clients that connected to the DSA user ports.
> That is because SA learning on the CPU port is disabled, so the switch
> ignores the client's frames from the CPU port and still thinks it is at
> the user port.
>
> Fix it by enabling SA learning on the CPU port.
>
> To prevent the switch from learning from flooding frames from the CPU
> port, set skb->offload_fwd_mark to 1 for unicast and broadcast frames,
> and let the switch flood them instead of trapping to the CPU port.
> Multicast frames still need to be trapped to the CPU port for snooping,
> so set the SA_DIS bit of the MTK tag to 1 when transmitting those frames
> to disable SA learning.
>
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

I think enabling learning on the CPU port would fix the problem
sometimes, but not always. (actually nothing can solve it always, see
below)
The switch learns the new route only if it receives any packets from
the CPU port, with a SA equal to the station you're trying to reach.
But what if the station is not sending any traffic at the moment,
because it is simply waiting for connections to it first (just an
example)?
Unless there is any traffic already coming from the destination
station too, your patch won't work.
I am currently facing a similar situation with the ocelot/felix
switches, but in that case, enabling SA learning on the CPU port is
not possible.
The way I dealt with it is by forcing a flush of the FDB entries on
the port, in the following scenarios:
- link goes down
- port leaves its bridge
So traffic towards a destination that has migrated away will
temporarily be flooded again (towards the CPU port as well).
There is still one case which isn't treated using this approach: when
the station migrates away from a switch port that is not directly
connected to this one. So no "link down" events would get generated in
that case. We would still have to wait until the address expires in
that case. I don't think that particular situation can be solved.
My point is: if we agree that this is a larger problem, then DSA
should have a .port_fdb_flush method and schedule a workqueue whenever
necessary. Yes, it is a costly operation, but it will still probably
take a lot less than the 300 seconds that the bridge configures for
address ageing.

Thoughts?

>  drivers/net/dsa/mt7530.c |  9 ++-------
>  drivers/net/dsa/mt7530.h |  1 +
>  net/dsa/tag_mtk.c        | 15 +++++++++++++++
>  3 files changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 5c444cd722bd..34e4aadfa705 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -628,11 +628,8 @@ mt7530_cpu_port_enable(struct mt7530_priv *priv,
>         mt7530_write(priv, MT7530_PVC_P(port),
>                      PORT_SPEC_TAG);
>
> -       /* Disable auto learning on the cpu port */
> -       mt7530_set(priv, MT7530_PSC_P(port), SA_DIS);
> -
> -       /* Unknown unicast frame fordwarding to the cpu port */
> -       mt7530_set(priv, MT7530_MFC, UNU_FFP(BIT(port)));
> +       /* Unknown multicast frame forwarding to the cpu port */
> +       mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
>
>         /* Set CPU port number */
>         if (priv->id == ID_MT7621)
> @@ -1294,8 +1291,6 @@ mt7530_setup(struct dsa_switch *ds)
>         /* Enable and reset MIB counters */
>         mt7530_mib_reset(ds);
>
> -       mt7530_clear(priv, MT7530_MFC, UNU_FFP_MASK);
> -
>         for (i = 0; i < MT7530_NUM_PORTS; i++) {
>                 /* Disable forwarding by default on all ports */
>                 mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 979bb6374678..82af4d2d406e 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -31,6 +31,7 @@ enum {
>  #define MT7530_MFC                     0x10
>  #define  BC_FFP(x)                     (((x) & 0xff) << 24)
>  #define  UNM_FFP(x)                    (((x) & 0xff) << 16)
> +#define  UNM_FFP_MASK                  UNM_FFP(~0)
>  #define  UNU_FFP(x)                    (((x) & 0xff) << 8)
>  #define  UNU_FFP_MASK                  UNU_FFP(~0)
>  #define  CPU_EN                                BIT(7)
> diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
> index b5705cba8318..d6619edd53e5 100644
> --- a/net/dsa/tag_mtk.c
> +++ b/net/dsa/tag_mtk.c
> @@ -15,6 +15,7 @@
>  #define MTK_HDR_XMIT_TAGGED_TPID_8100  1
>  #define MTK_HDR_RECV_SOURCE_PORT_MASK  GENMASK(2, 0)
>  #define MTK_HDR_XMIT_DP_BIT_MASK       GENMASK(5, 0)
> +#define MTK_HDR_XMIT_SA_DIS            BIT(6)
>
>  static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>                                     struct net_device *dev)
> @@ -22,6 +23,9 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>         struct dsa_port *dp = dsa_slave_to_port(dev);
>         u8 *mtk_tag;
>         bool is_vlan_skb = true;
> +       unsigned char *dest = eth_hdr(skb)->h_dest;
> +       bool is_multicast_skb = is_multicast_ether_addr(dest) &&
> +                               !is_broadcast_ether_addr(dest);
>
>         /* Build the special tag after the MAC Source Address. If VLAN header
>          * is present, it's required that VLAN header and special tag is
> @@ -47,6 +51,10 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>                      MTK_HDR_XMIT_UNTAGGED;
>         mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
>
> +       /* Disable SA learning for multicast frames */
> +       if (unlikely(is_multicast_skb))
> +               mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
> +
>         /* Tag control information is kept for 802.1Q */
>         if (!is_vlan_skb) {
>                 mtk_tag[2] = 0;
> @@ -61,6 +69,9 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
>  {
>         int port;
>         __be16 *phdr, hdr;
> +       unsigned char *dest = eth_hdr(skb)->h_dest;
> +       bool is_multicast_skb = is_multicast_ether_addr(dest) &&
> +                               !is_broadcast_ether_addr(dest);
>
>         if (unlikely(!pskb_may_pull(skb, MTK_HDR_LEN)))
>                 return NULL;
> @@ -86,6 +97,10 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
>         if (!skb->dev)
>                 return NULL;
>
> +       /* Only unicast or broadcast frames are offloaded */
> +       if (likely(!is_multicast_skb))
> +               skb->offload_fwd_mark = 1;
> +
>         return skb;
>  }
>
> --
> 2.26.1
>

Thanks,
-Vladimir
