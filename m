Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C38049D5AA
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiAZWtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiAZWta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:49:30 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888A1C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:49:30 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so5673464pjt.5
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gf7tKx9UBPdGZlyIUQi5kzgKp35lY98+Psdaqv4lGbM=;
        b=niqrC9/QSjsyV2iMpX+cahcPDKzUuWcAAv0rDHcBDzR6o+ksezSZF3jhfH5u10j6Ii
         ds5h+pVQp3JyatEHyIH3eXK9WHIaVQqNhOTFzK5zDTuitlp/BTzrQdQ5OhOQ/uUAM2sC
         7UTj3g83PEJVIxOui3XvEuWjh0shpGbkiGAdJS4db0OD/HCvFMMpd3KDQFAD+NSfGUkn
         DpCFUJF/r4K29PjFsY6ZnvBV+pxQx8xC3Af9T2dF/CBJyEfufbnqHq96QZ8N97ugTaIQ
         zH4rNoUXRRk+YnKejLYR3LDxta2N85UBWt64K1e+ursahxKAG6HHs+DwyJxFhxWOtsMV
         uXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gf7tKx9UBPdGZlyIUQi5kzgKp35lY98+Psdaqv4lGbM=;
        b=0LXPMbmyCtj5i7Ymyd2+IgPRY7ngX+UtEQPj13Fcg7tcx5rTBGV2mM18EqAfysTEme
         UUMdzBOA11YOTK772tp7bqdnhc28IF2ImvBRujQPuVCahUZgGEMIYwG5gGnYCISbEmt5
         RuI4JnYD+kQT6p4O+31tKk4IOUku6COppoDJD1lMHDTXn9KZK6EMo863G0zQtY2nFMWa
         AQGBNJSUuR3rCpRocO8Gt0C3qYgnFeSmUeWpeDpHPaBu+NjqJsv10ycgjVbV5xZ0XdcJ
         zt0vaNFAeTkJ9P2NqFwuQq53LsFOts5dzT7lRtHRgl88O532J64ucZiOw9q5n8fg7jY1
         MoUg==
X-Gm-Message-State: AOAM5339g4PNQSgT+p8xj23wkXKNUMGtng5v6UkhFSm34OiNYTNQovpM
        fbx2bIc2O2n1fiTsQMPzQl06sq/eL2BmqxNCa5cR4Al17ymbiNyl
X-Google-Smtp-Source: ABdhPJx4/dsbELCi6Ne0pDraUIUxdZRyb55U4gipYcbBSvafKPySckpCaXr44AgpipzZ1MZ+vzJ9jPK5oKJVUAFN8FI=
X-Received: by 2002:a17:90a:dac2:: with SMTP id g2mr10880539pjx.135.1643237369899;
 Wed, 26 Jan 2022 14:49:29 -0800 (PST)
MIME-Version: 1.0
References: <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
 <20220124172158.tkbfstpwg2zp5kaq@skbuf> <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124190845.md3m2wzu7jx4xtpr@skbuf> <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124205607.kugsccikzgmbdgmf@skbuf> <20220124134242.595fd728@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124223053.gpeonw6f34icwsht@skbuf> <CAJq09z5JF71kFKxF860RCXPvofhitaPe7ES4UTMeEVO8LH=PoA@mail.gmail.com>
 <20220125094742.nkxgv4r2fetpko7r@skbuf> <CAJq09z4OC4OijWT8=-=vXRQhqFsaP0+asXyO69i37aj39DMB6A@mail.gmail.com>
 <ae29e4cc-c66c-ea29-b93f-c9c35d64dd66@gmail.com>
In-Reply-To: <ae29e4cc-c66c-ea29-b93f-c9c35d64dd66@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 26 Jan 2022 19:49:18 -0300
Message-ID: <CAJq09z7ut78M6_FB6H-5WycfBR=CBrTQEuCmNKxsWFNqCE7ArQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 1/25/2022 2:29 PM, Luiz Angelo Daros de Luca wrote:
> >> Could you implement a prototype of packet parsing in ndo_features_check,
> >> which checks for the known DSA EtherType and clears the offload bit for
> >> unsupported packets, and do some performance testing before and after,
> >> to lean the argument in your favor with some numbers? I've no problem if
> >> you test for the worst case, i.e. line rate with small UDP packets
> >> encapsulated with the known (offload-capable) DSA tag format, where
> >> there is little benefit for offloading TX checksumming.
> >
> > There is no way to tell if a packet has a DSA tag only by parsing its
> > content. For Realtek and Marvel EDSA, there is a distinct ethertype
> > (although Marvel EDSA uses a non-registered number) that drivers can
> > check. For others, specially those that add the tag before the
> > ethernet header or after the payload, it might not have a magic
> > number. It is impossible to securely identify if and which DSA is in
> > use for some DSA tags from the packet alone. This is also the case for
> > mediatek. Although it places its tag just before ethertype (like
> > Realtek and Marvel), there is no magic number. It needs some context
> > to know what type of DSA was applied.
>
> Looking at mtk_eth_soc.h TX_DMA_CHKSUM is 0x7 << 29 so we set 3 bits
> there, which makes me think that either we defined too many bits, or
> some of those bits have a compounded meaning. The rest of the bits do
> not seem to be defined, so maybe there is a programmable offset where to
> calculate the checksum from and deposit it. Is there a public
> programmable manual?

Thanks Florian, I'm using this that I googled ;-)

http://download.villagetelco.org/hardware/MT7620/MT7620_ProgrammingGuide.pdf
page 206?

It says:

DWORD0 31:0 SDP0 Segment Data Pointer0

DWORD1 31 DDONE DMA Done: Indicates DMA has transferred the segment
pointed to by this Tx
descriptor.
30 LS0 Last Segment0: Data pointed to by SDP0 is the last segment.
29:16 SDL0 Segment Data Length0: Segment data length for the data
pointed to by SDP0.
15 BURST When set, the scheduler cannot hand over to other Tx queues.
Should not transmit
the next packet.
14 LS1 Last Segment1: Data pointed to by SDP1 is the last segment.
13:0 SDL1 Segment Data Length1: Segment data length for the data
pointed to by SDP1.

DWORD2
31:0 SDP1 Segment Data Pointer1

DWORD3 (TXINFO)
31 ICO IP checksum offload enable
30 UCO UDP checksum offload enable
23 TCO TCP checksum offload enable
28 TSO TCP segmentation offload
27:20 FP_BMAP Forced destination port on GSW
bit[0:5]: Ports 0 to 5
bit[6]: CPU
bit[7]: PPE
FP_BMAP = 0: routing by DA
19:15 UDF User defined field
14 0 Reserved
13 0 Reserved
12 INSP Insert PPPoE header
11:8 SIDX PPPoE session index
7 INSV Insert VLAN tag
6:4 VPRI VLAN priority tag to be inserted
3:0 VIDX VLAN ID index

It looks like st->txd.txd4 is DWORD3. There is nothing too useful for
pointing L3 headers. The remaining bits are about vlan and pppoe
offload (and forcing the forwarding port).
There are those two segment 0 and 1 data pointers and their size in
txd{1,2,3} that I don't understand how it works (yet), but I guess
that is not what we are looking for.

There are also some offload settings at CDMA (page 217), but it is
simply an enable bit. (And I don't know what CDMA or GDMA are :-/).

> > skb_buf today knows nothing about the added DSA tag. Although
> > net_device does know if it is a master port in a dsa tree, and it has
> > a default dsa tag, with multiple switches using different tags, it
> > cannot tell which dsa tag was added to that packet.
> > That is the information I need to test if that tag is supported or not
> > by this drive.
> >
> > I believe once an offload HW can digest a dsa tag, it might support
> > the same type of protocols with or without the tag.
> > In the end, what really matters is if a driver supports a specific dsa tag.
>
> To be honest, I am not sure if we need to know about the specific
> details of the tag like is it Realtek, Broadcom, Mediatek, QCA, more
> than knowing whether the L3/L4 offsets will be at "expected" locations.
> By that I mean, located at 14 bytes from the start of the frame for IP
> without VLAN , and 18 bytes with VLAN, did we "stack" switch tags on top
> of another thus moving by another X bytes etc.

I would be perfect if the HW supported that (and I'm afraid it does not).

>
>
> >
> > Wouldn't it be much easier to have a dedicated optional
> > ndo_dsa_tag_supported()? It would be only needed for those drivers
> > that still use NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM and only those that
> > can digest a tag.
>
> I don't think we need to invent something new, we "just" need to tell
> the DSA conduit interface what type of switch tagger it is attached to
> and where it is in the Ethernet frame. Once we do that, the DSA conduit
> ought to be able to strip out features statically, or dynamically via
> ndo_features_check().

Is it a 1:1 relation between tags and the DSA conduit interface (I'm
guessing this is the CPU port Ethernet device)?
Anyway, this mediatek does not seem to support multiple tags. This
patch might disable offloading when it is using any DSA tags but the
mediatek one.
I never used the NONE tag but maybe I should also exempt that tag from
disabling offloading.

diff --git a/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
b/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
index 0ae520183b..8eb5dd8721 100644
--- a/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
+++ b/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
@@ -31,6 +31,7 @@
#include <linux/io.h>
#include <linux/bug.h>
#include <linux/netfilter.h>
+#include <net/dsa.h>
#include <net/netfilter/nf_flow_table.h>
#include <linux/of_gpio.h>
#include <linux/gpio.h>
@@ -788,6 +789,27 @@ err_out:
       return -1;
}

+static netdev_features_t fe_features_check(struct sk_buff *skb,
+                                          struct net_device *dev,
+                                          netdev_features_t features)
+{
+       /* No point in doing any of this if neither checksum nor GSO are
+        * being requested for this frame. We can rule out both by just
+        * checking for CHECKSUM_PARTIAL
+        */
+       if (skb->ip_summed != CHECKSUM_PARTIAL)
+               return features;
+
+       if (netdev_uses_dsa(dev)) {
+               struct dsa_device_ops *tag_ops = dev->dsa_ptr->tag_ops;
+
+               if (tag_ops && (tag_ops->proto != DSA_TAG_PROTO_MTK))
+                       features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+       }
+
+       return features;
+}
+
static inline int fe_skb_padto(struct sk_buff *skb, struct fe_priv *priv)
{
       unsigned int len;
@@ -1523,6 +1545,7 @@ static const struct net_device_ops fe_netdev_ops = {
#ifdef CONFIG_NET_POLL_CONTROLLER
       .ndo_poll_controller    = fe_poll_controller,
#endif
+       .ndo_features_check     = fe_features_check,
};

static void fe_reset_pending(struct fe_priv *priv)

However, I still feel odd to call a function for every single packet
when the return value is exclusively dependent on a state that will
change only when the CPU port joins or leaves the DSA switch (or when
tag is changed).

Regards,

Luiz
