Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715E860DFEF
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 13:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbiJZLq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 07:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiJZLqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 07:46:33 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13374C613;
        Wed, 26 Oct 2022 04:45:27 -0700 (PDT)
X-UUID: 2ac84e4e357745dd93cb33e04406c6bc-20221026
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=9LC/FK6XWFOIUm1Lv8D9Fr/dapnZXyyTO4BlfBq5dRg=;
        b=aYBrZgdhXMvYIp1bsCpYOyTraJHZTUgfD/5FzQtWgtpSXx6hAAk5i2V0v+2Q86OgglBK4Vcq23Rno35kLE/19aRN1XBDS0mNynvlg9hGGfxE7j2o7I9Y54PlRDV9RZnt2drs2MmlqCYIuDu/g3D6jw0VsNOO5ln0wi5sVv25/Sw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:ba85b83b-2751-4653-8c34-78f8a5a7e86e,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:62cd327,CLOUDID:67b93527-9eb1-469f-b210-e32d06cfa36e,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 2ac84e4e357745dd93cb33e04406c6bc-20221026
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 125040454; Wed, 26 Oct 2022 19:45:21 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 26 Oct 2022 19:45:19 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 26 Oct 2022 19:45:17 +0800
Message-ID: <82a7acf3176c90d9bea773bb4ea365745c1a1971.camel@mediatek.com>
Subject: Re: [PATCH] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
From:   haozhe chang <haozhe.chang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        Haijun Liu =?UTF-8?Q?=28=E5=88=98=E6=B5=B7=E5=86=9B=29?= 
        <haijun.liu@mediatek.com>,
        "m.chetan.kumar@linux.intel.com" <m.chetan.kumar@linux.intel.com>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Lambert Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BC=9F=29?= 
        <Lambert.Wang@mediatek.com>,
        "Xiayu Zhang =?UTF-8?Q?=28=E5=BC=A0=E5=A4=8F=E5=AE=87=29?=" 
        <Xiayu.Zhang@mediatek.com>, <srv_heupstream@mediatek.com>
Date:   Wed, 26 Oct 2022 19:45:17 +0800
In-Reply-To: <CAMZdPi_XSWeTf-eP+O2ZXGXtn5yviEp=p1Q0rs_fG76UGf2FsQ@mail.gmail.com>
References: <20221026011540.8499-1-haozhe.chang@mediatek.com>
         <CAMZdPi_XSWeTf-eP+O2ZXGXtn5yviEp=p1Q0rs_fG76UGf2FsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR,
        UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-10-26 at 15:28 +0800, Loic Poulain wrote:
> Hi Haozhe,
> 
> On Wed, 26 Oct 2022 at 03:16, <haozhe.chang@mediatek.com> wrote:
> > 
> > From: haozhe chang <haozhe.chang@mediatek.com>
> > 
> > wwan_port_fops_write inputs the SKB parameter to the TX callback of
> > the WWAN device driver. However, the WWAN device (e.g., t7xx) may
> > have an MTU less than the size of SKB, causing the TX buffer to be
> > sliced and copied once more in the WWAN device driver.
> 
> The benefit of putting data in an skb is that it is easy to
> manipulate, so not sure why there is an additional copy in the first
> place. Isn't possible for the t7xx driver to consume the skb
> progressively (without intermediate copy), according to its own MTU
> limitation?
> 
t7xx driver needs to add metadata to the SKB head for each fragment, so
the driver has to allocate a new buffer to copy data(skb_put_data) and
insert metadata. 
Providing the option to slice in common layer benefits varieties of
devices with different DMA capabilities. The patch is also compatible
with existing WWAN devices.
> > 
> > This patch implements the slicing in the WWAN subsystem and gives
> > the WWAN devices driver the option to slice(by chunk) or not. By
> > doing so, the additional memory copy is reduced.
> > 
> > Meanwhile, this patch gives WWAN devices driver the option to
> > reserve
> > headroom in SKB for the device-specific metadata.
> > 
> > Signed-off-by: haozhe chang <haozhe.chang@mediatek.com>
> > ---
> >  drivers/net/wwan/t7xx/t7xx_port_wwan.c | 41 ++++++++++++--------
> > ---
> >  drivers/net/wwan/wwan_core.c           | 45 ++++++++++++++++++--
> > ------
> >  include/linux/wwan.h                   |  5 ++-
> >  3 files changed, 56 insertions(+), 35 deletions(-)
> > 
> > diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> > b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> > index 33931bfd78fd..5e8589582121 100644
> > --- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> > +++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> > @@ -54,13 +54,12 @@ static void t7xx_port_ctrl_stop(struct
> > wwan_port *port)
> >  static int t7xx_port_ctrl_tx(struct wwan_port *port, struct
> > sk_buff *skb)
> >  {
> >         struct t7xx_port *port_private =
> > wwan_port_get_drvdata(port);
> > -       size_t len, offset, chunk_len = 0, txq_mtu = CLDMA_MTU;
> >         const struct t7xx_port_conf *port_conf;
> >         struct t7xx_fsm_ctl *ctl;
> >         enum md_state md_state;
> > +       int ret;
> > 
> > -       len = skb->len;
> > -       if (!len || !port_private->chan_enable)
> > +       if (!port_private->chan_enable)
> >                 return -EINVAL;
> > 
> >         port_conf = port_private->port_conf;
> > @@ -72,33 +71,33 @@ static int t7xx_port_ctrl_tx(struct wwan_port
> > *port, struct sk_buff *skb)
> >                 return -ENODEV;
> >         }
> > 
> > -       for (offset = 0; offset < len; offset += chunk_len) {
> > -               struct sk_buff *skb_ccci;
> > -               int ret;
> > -
> > -               chunk_len = min(len - offset, txq_mtu -
> > sizeof(struct ccci_header));
> > -               skb_ccci = t7xx_port_alloc_skb(chunk_len);
> > -               if (!skb_ccci)
> > -                       return -ENOMEM;
> > -
> > -               skb_put_data(skb_ccci, skb->data + offset,
> > chunk_len);
> > -               ret = t7xx_port_send_skb(port_private, skb_ccci, 0,
> > 0);
> > -               if (ret) {
> > -                       dev_kfree_skb_any(skb_ccci);
> > -                       dev_err(port_private->dev, "Write error on
> > %s port, %d\n",
> > -                               port_conf->name, ret);
> > -                       return ret;
> > -               }
> > +       ret = t7xx_port_send_skb(port_private, skb, 0, 0);
> > +       if (ret) {
> > +               dev_err(port_private->dev, "Write error on %s port,
> > %d\n",
> > +                       port_conf->name, ret);
> > +               return ret;
> >         }
> > -
> >         dev_kfree_skb(skb);
> > +
> >         return 0;
> >  }
> > 
> > +static size_t t7xx_port_get_tx_rsvd_headroom(struct wwan_port
> > *port)
> > +{
> > +       return sizeof(struct ccci_header);
> > +}
> > +
> > +static size_t t7xx_port_get_tx_chunk_len(struct wwan_port *port)
> > +{
> > +       return CLDMA_MTU - sizeof(struct ccci_header);
> > +}
> > +
> >  static const struct wwan_port_ops wwan_ops = {
> >         .start = t7xx_port_ctrl_start,
> >         .stop = t7xx_port_ctrl_stop,
> >         .tx = t7xx_port_ctrl_tx,
> > +       .get_tx_rsvd_headroom = t7xx_port_get_tx_rsvd_headroom,
> 
> Can't we have a simple 'skb_headroom' or 'needed_headroom' member
> here?
> 
OK, I will change it in patch v2.
> > +       .get_tx_chunk_len = t7xx_port_get_tx_chunk_len,
> >  };
> > 
