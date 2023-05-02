Return-Path: <netdev+bounces-25-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED17D6F4C27
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4408D1C20988
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81465A93A;
	Tue,  2 May 2023 21:27:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAF89470
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 21:27:07 +0000 (UTC)
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FB31710;
	Tue,  2 May 2023 14:27:05 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-b9e2b65d006so3675071276.3;
        Tue, 02 May 2023 14:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683062824; x=1685654824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=knJwrsz/sIaCpvJlUBXXveg4rz275IOOMyO2S8skkn0=;
        b=FJFilFFe+xcy0Goi384A3gDjzqh7Mpu2K0IiO0fXyu9H/2M9/ZqZtN0+JfztjniGaH
         xNFxefNlAxu0F1hRaQqHO6LVePxhrrk84DXos5DnbJhXTQj9WI8pYTLDH+7UiuwtOU6W
         TognYxinD4urmTZ8fDh+xy2xLQLJ3LEJ+VfeAnujsiN2mi8nVBgrctHp/Bog+O7OCgKK
         9a5v8WK/R0tYTuVJ5wd66LnWvGcSWQhcBYRrYQxGUZBVHCzK0JX1aFMPOQ01wWYNtsFB
         fF5ri9piz9HbHyAYkVDkds+XtluySg97e/zBp6qKxjMh+Sh28za4YeWvxT2w3YX1G55D
         ePVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683062824; x=1685654824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=knJwrsz/sIaCpvJlUBXXveg4rz275IOOMyO2S8skkn0=;
        b=DSNGZpaPrQDIoDo2WSwfINuRQEBTrMbiUY1HolxZfmTv6vsXRIKwPQsu2yvzO4FgbG
         ivFTtct/UNbnfrmYYGME+a2vwBasF8BV0nPzxNNbRUicH8F0PzhaZ1HEiiFWOxyStQ7V
         DBM0Y0H4uXWCYsiQnq1xnaDJIDjY7Un7k/b1sNfn87t7AVEh6kKHMWqIz40WsK2Tm05H
         wsmWcQxRxTjuy1enKm+QhF8yd9bPv89jYErooHL2FK5j3pMuuIsmp0aNfkU8FiNJ/uos
         i1HzqUOj4gj1KBJrndI1eADu/CEyeHJJOpw2SrfWyxMOhMuTc599mFrq3D9B6773196j
         OySQ==
X-Gm-Message-State: AC+VfDw0YuPlwhe0SH2P/GSzpajJWCBdwHV1xyp+veq025TwLHaxILW1
	TobpIIl3dlEnC0IOPknAbpgA04ooEoA0bJSj0zM=
X-Google-Smtp-Source: ACHHUZ67XFCw3cwTsEZASwArZ6eMGgnCmgBwASY6jVyY4SqJlTx9++fkBScoIcBRK/7P3UhkeQJ28OyjpkRGAs8HeYA=
X-Received: by 2002:a25:58c4:0:b0:b99:e0ff:5f16 with SMTP id
 m187-20020a2558c4000000b00b99e0ff5f16mr14580089ybb.18.1683062824368; Tue, 02
 May 2023 14:27:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
 <1682535272-32249-4-git-send-email-justinpopo6@gmail.com> <ZFFn3UdlapiTlCam@corigine.com>
In-Reply-To: <ZFFn3UdlapiTlCam@corigine.com>
From: Justin Chen <justinpopo6@gmail.com>
Date: Tue, 2 May 2023 14:26:53 -0700
Message-ID: <CAJx26kV9E7M5ULoPqT8eJ5byaUEZDtW6v25f3DT04xs4NGcd6g@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
To: Simon Horman <simon.horman@corigine.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, bcm-kernel-feedback-list@broadcom.com, 
	justin.chen@broadcom.com, f.fainelli@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org, 
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com, andrew@lunn.ch, 
	hkallweit1@gmail.com, linux@armlinux.org.uk, richardcochran@gmail.com, 
	sumit.semwal@linaro.org, christian.koenig@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 2, 2023 at 12:44=E2=80=AFPM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Wed, Apr 26, 2023 at 11:54:29AM -0700, Justin Chen wrote:
> > Add support for the Broadcom ASP 2.0 Ethernet controller which is first
> > introduced with 72165. This controller features two distinct Ethernet
> > ports that can be independently operated.
> >
> > This patch supports:
> >
> > - Wake-on-LAN using magic packets
> > - basic ethtool operations (link, counters, message level)
> > - MAC destination address filtering (promiscuous, ALL_MULTI, etc.)
> >
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Justin Chen <justinpopo6@gmail.com>
>
> ...
>
> > diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/=
ethernet/broadcom/asp2/bcmasp.c
>
> ...
>
> > +static int bcmasp_netfilt_get_reg_offset(struct bcmasp_priv *priv,
> > +                                      struct bcmasp_net_filter *nfilt,
> > +                                      enum asp_netfilt_reg_type reg_ty=
pe,
> > +                                      u32 offset)
> > +{
> > +     u32 block_index, filter_sel;
> > +
> > +     if (offset < 32) {
> > +             block_index =3D ASP_RX_FILTER_NET_L2;
> > +             filter_sel =3D nfilt->hw_index;
> > +     } else if (offset < 64) {
> > +             block_index =3D ASP_RX_FILTER_NET_L2;
> > +             filter_sel =3D nfilt->hw_index + 1;
> > +     } else if (offset < 96) {
> > +             block_index =3D ASP_RX_FILTER_NET_L3_0;
> > +             filter_sel =3D nfilt->hw_index;
> > +     } else if (offset < 128) {
> > +             block_index =3D ASP_RX_FILTER_NET_L3_0;
> > +             filter_sel =3D nfilt->hw_index + 1;
> > +     } else if (offset < 160) {
> > +             block_index =3D ASP_RX_FILTER_NET_L3_1;
> > +             filter_sel =3D nfilt->hw_index;
> > +     } else if (offset < 192) {
> > +             block_index =3D ASP_RX_FILTER_NET_L3_1;
> > +             filter_sel =3D nfilt->hw_index + 1;
> > +     } else if (offset < 224) {
> > +             block_index =3D ASP_RX_FILTER_NET_L4;
> > +             filter_sel =3D nfilt->hw_index;
> > +     } else if (offset < 256) {
> > +             block_index =3D ASP_RX_FILTER_NET_L4;
> > +             filter_sel =3D nfilt->hw_index + 1;
> > +     }
>
> block_index and filter_sel are uninitialised if offset doesn't match any
> of the conditions above. Can that happen?
>

Nope. This is a helper function for netfilter read and write reg, we
check offset sizes in those functions.

> > +
> > +     switch (reg_type) {
> > +     case ASP_NETFILT_MATCH:
> > +             return ASP_RX_FILTER_NET_PAT(filter_sel, block_index,
> > +                                          (offset % 32));
> > +     case ASP_NETFILT_MASK:
> > +             return ASP_RX_FILTER_NET_MASK(filter_sel, block_index,
> > +                                           (offset % 32));
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +}
>
> ...
>
> > +static void bcmasp_netfilt_tcpip4_wr(struct bcmasp_priv *priv,
> > +                                  struct bcmasp_net_filter *nfilt,
> > +                                  struct ethtool_tcpip4_spec *match,
> > +                                  struct ethtool_tcpip4_spec *mask,
> > +                                  u32 offset)
> > +{
> > +     __be16 val_16, mask_16;
> > +
> > +     val_16 =3D htons(ETH_P_IP);
> > +     mask_16 =3D 0xFFFF;
>
> mask_17 is __be16, but 0xFFFF is host byte order.
>
> Please make sure there are no new warnings when building with W=3D1 C=3D1=
.
>
> ...
>
> > +/* If no network filter found, return open filter.
> > + * If no more open filters return NULL
> > + */
> > +struct bcmasp_net_filter *bcmasp_netfilt_get_init(struct bcmasp_intf *=
intf,
> > +                                               int loc, bool wake_filt=
er,
> > +                                               bool init)
> > +{
> > +     struct bcmasp_priv *priv =3D intf->parent;
> > +     struct bcmasp_net_filter *nfilter =3D NULL;
> > +     int i, open_index =3D -1;
>
> Please use reverse xmas tree - longest line to shortest - for local
> variable declarations in networking code.
>
> You can check for this using https://github.com/ecree-solarflare/xmastree
>
> ...
>
> > +static int bcmasp_combine_set_filter(struct bcmasp_intf *intf,
> > +                                  unsigned char *addr, unsigned char *=
mask,
> > +                                  int i)
> > +{
> > +     u64 addr1, addr2, mask1, mask2, mask3;
> > +     struct bcmasp_priv *priv =3D intf->parent;
> > +
> > +     /* Switch to u64 to help with the calculations */
> > +     addr1 =3D ether_addr_to_u64(priv->mda_filters[i].addr);
> > +     mask1 =3D ether_addr_to_u64(priv->mda_filters[i].mask);
> > +     addr2 =3D ether_addr_to_u64(addr);
> > +     mask2 =3D ether_addr_to_u64(mask);
> > +
> > +     /* Check if one filter resides within the other */
> > +     mask3 =3D mask1 & mask2;
> > +     if (mask3 =3D=3D mask1 && ((addr1 & mask1) =3D=3D (addr2 & mask1)=
)) {
> > +             /* Filter 2 resides within fitler 1, so everthing is good=
 */
>
> nit: s/fitler/filter/
>
> Please consider running ./scripts/checkpatch.pl --codespell
>
> ...
>
> > +static void bcmasp_update_mib_counters(struct bcmasp_intf *priv)
> > +{
> > +     int i, j =3D 0;
> > +
> > +     for (i =3D 0; i < BCMASP_STATS_LEN; i++) {
> > +             const struct bcmasp_stats *s;
> > +             u16 offset =3D 0;
> > +             u32 val =3D 0;
> > +             char *p;
> > +
> > +             s =3D &bcmasp_gstrings_stats[i];
> > +             switch (s->type) {
> > +             case BCMASP_STAT_NETDEV:
> > +             case BCMASP_STAT_SOFT:
> > +                     continue;
> > +             case BCMASP_STAT_RUNT:
> > +                     offset +=3D BCMASP_STAT_OFFSET;
> > +                     fallthrough;
> > +             case BCMASP_STAT_MIB_TX:
> > +                     offset +=3D BCMASP_STAT_OFFSET;
> > +                     fallthrough;
> > +             case BCMASP_STAT_MIB_RX:
> > +                     val =3D umac_rl(priv, UMC_MIB_START + j + offset)=
;
> > +                     offset =3D 0;     /* Reset Offset */
> > +                     break;
> > +             case BCMASP_STAT_RX_EDPKT:
> > +                     val =3D rx_edpkt_core_rl(priv->parent, s->reg_off=
set);
> > +                     break;
> > +             case BCMASP_STAT_RX_CTRL:
> > +                     offset =3D bcmasp_stat_fixup_offset(priv, s);
> > +                     if (offset !=3D ASP_RX_CTRL_FB_FILT_OUT_FRAME_COU=
NT)
> > +                             offset +=3D sizeof(u32) * priv->port;
> > +                     val =3D rx_ctrl_core_rl(priv->parent, offset);
> > +                     break;
> > +             }
> > +
> > +             j +=3D s->stat_sizeof;
> > +             p =3D (char *)priv + s->stat_offset;
> > +             *(u32 *)p =3D val;
>
> Is p always 32bit aligned?
>

Nope. I can make sure it is 32 bit aligned.

Acked, the other comments. Will submit v3 when net-next window is
open. Thank you for the review.

Justin

> > +     }
> > +}
> > +
> > +static void bcmasp_get_ethtool_stats(struct net_device *dev,
> > +                                  struct ethtool_stats *stats,
> > +                                  u64 *data)
> > +{
> > +     struct bcmasp_intf *priv =3D netdev_priv(dev);
> > +     int i, j =3D 0;
> > +
> > +     if (netif_running(dev))
> > +             bcmasp_update_mib_counters(priv);
> > +
> > +     dev->netdev_ops->ndo_get_stats(dev);
> > +
> > +     for (i =3D 0; i < BCMASP_STATS_LEN; i++) {
> > +             const struct bcmasp_stats *s;
> > +             char *p;
> > +
> > +             s =3D &bcmasp_gstrings_stats[i];
> > +             if (!bcmasp_stat_available(priv, s->type))
> > +                     continue;
> > +             if (s->type =3D=3D BCMASP_STAT_NETDEV)
> > +                     p =3D (char *)&dev->stats;
> > +             else
> > +                     p =3D (char *)priv;
> > +             p +=3D s->stat_offset;
> > +             if (sizeof(unsigned long) !=3D sizeof(u32) &&
> > +                 s->stat_sizeof =3D=3D sizeof(unsigned long))
> > +                     data[j] =3D *(unsigned long *)p;
> > +             else
> > +                     data[j] =3D *(u32 *)p;
>
> Maybe memcpy would make this a little easier to read.
>
> > +             j++;
> > +     }
> > +}
>
> ...
>
> > diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers=
/net/ethernet/broadcom/asp2/bcmasp_intf.c
>
> ...
>
> > +static int bcmasp_init_rx(struct bcmasp_intf *intf)
> > +{
> > +     struct device *kdev =3D &intf->parent->pdev->dev;
> > +     struct net_device *ndev =3D intf->ndev;
> > +     void *p;
> > +     dma_addr_t dma;
> > +     struct page *buffer_pg;
> > +     u32 reg;
> > +     int ret;
> > +
> > +     intf->rx_buf_order =3D get_order(RING_BUFFER_SIZE);
> > +     buffer_pg =3D alloc_pages(GFP_KERNEL, intf->rx_buf_order);
> > +
> > +     dma =3D dma_map_page(kdev, buffer_pg, 0, RING_BUFFER_SIZE,
> > +                        DMA_FROM_DEVICE);
> > +     if (dma_mapping_error(kdev, dma)) {
> > +             netdev_err(ndev, "Cannot allocate RX buffer\n");
>
> I think the core will log an error on allocation failure,
> so the message above is not needed.
>
> > +             __free_pages(buffer_pg, intf->rx_buf_order);
> > +             return -ENOMEM;
> > +     }
>
> ...

