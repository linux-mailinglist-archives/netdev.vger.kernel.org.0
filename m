Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A6760DC12
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiJZH3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbiJZH3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:29:38 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317C955A9
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:29:35 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id t4so9577779wmj.5
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T/IjroO2S8DcRAcgUC984Ih3tCuwktfX/cLb+yvJTYE=;
        b=KDjhCe2pYrt5U9tgFi89KJ0PHf6g6B9GuiqZZXRyUNK1tVkhx4ZaQacn2QPYYUM45z
         n1bpUmclo0BWzghTm3l1SiYANMm6xNoPbdIXvNwCTbLA4OFhSRJFvmqtwhnEgUG6rXiY
         cWZn6xP/KHV0SjaRpelyL2sRGbfhLFeeTTAZ3a5ixe+oHgr/WMN4McIUUwc1DteqNCoU
         evqSWxUg16IdfTJ3o1w2tvCoFJfQ8jYGkAe0FvDDivuuNMrbR1eFreZY5cZxFxaXY8br
         aEABVzaThShNjSTWFhEUhFR6Dvz3x9GpG+ecGTrh5N/sweoIUe4W7CjmsZKHqy8e20ba
         7MEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/IjroO2S8DcRAcgUC984Ih3tCuwktfX/cLb+yvJTYE=;
        b=g4ydS7iCrbTM3Qgpd9Zar8O6gw6/T6E+jClpNhgL1i2n2q4IlazhuQVoVwKvebvTCZ
         aBd0BhQ5dASZm4tkZESqlhvV3yYDGsZR02JEZTHwqpd4bzO5LKUe5AqdISy9OqtM5aV6
         MkSay3Zt7UVhWoWzWavIhyffrJ+PnTOQ7abtsWspqcJpZBmK9kKoEHMP8kSk/FSOriZJ
         M95UtxzEiO5UrwC93Cxdk+4DX2h+7lo2KB7PXPbVuRDWa5EyzoXMuLsSVYFT4FRGpXw9
         KuVI0lanUDN3Oa3fxHLRsIJ0Al+v952krFvWmT5hDDH+JNw/trwIgN8dxognDYp8jsIW
         O1UA==
X-Gm-Message-State: ACrzQf2TVYbcFfKVn1Xmg16IRNFIGbAQtz2cdobiHgxao5nZ8SsiRv7W
        Dnp91L414hjvb9pGFA0Cgosb1PnSSc+DD91dCI8/UA==
X-Google-Smtp-Source: AMsMyM6DLhFMZ27HUXE4iWzamEQeTdwYl4PdiF+77+dTOOfhgmynxUIFnvXgspUsVr8ntS3TCAw4li+MloJdPqUZOjQ=
X-Received: by 2002:a05:600c:3b97:b0:3c7:14f0:f8d2 with SMTP id
 n23-20020a05600c3b9700b003c714f0f8d2mr1394909wms.159.1666769373579; Wed, 26
 Oct 2022 00:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20221026011540.8499-1-haozhe.chang@mediatek.com>
In-Reply-To: <20221026011540.8499-1-haozhe.chang@mediatek.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 26 Oct 2022 09:28:57 +0200
Message-ID: <CAMZdPi_XSWeTf-eP+O2ZXGXtn5yviEp=p1Q0rs_fG76UGf2FsQ@mail.gmail.com>
Subject: Re: [PATCH] wwan: core: Support slicing in port TX flow of WWAN subsystem
To:     haozhe.chang@mediatek.com
Cc:     chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lambert.wang@mediatek.com,
        xiayu.zhang@mediatek.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Haozhe,

On Wed, 26 Oct 2022 at 03:16, <haozhe.chang@mediatek.com> wrote:
>
> From: haozhe chang <haozhe.chang@mediatek.com>
>
> wwan_port_fops_write inputs the SKB parameter to the TX callback of
> the WWAN device driver. However, the WWAN device (e.g., t7xx) may
> have an MTU less than the size of SKB, causing the TX buffer to be
> sliced and copied once more in the WWAN device driver.

The benefit of putting data in an skb is that it is easy to
manipulate, so not sure why there is an additional copy in the first
place. Isn't possible for the t7xx driver to consume the skb
progressively (without intermediate copy), according to its own MTU
limitation?

>
> This patch implements the slicing in the WWAN subsystem and gives
> the WWAN devices driver the option to slice(by chunk) or not. By
> doing so, the additional memory copy is reduced.
>
> Meanwhile, this patch gives WWAN devices driver the option to reserve
> headroom in SKB for the device-specific metadata.
>
> Signed-off-by: haozhe chang <haozhe.chang@mediatek.com>
> ---
>  drivers/net/wwan/t7xx/t7xx_port_wwan.c | 41 ++++++++++++-----------
>  drivers/net/wwan/wwan_core.c           | 45 ++++++++++++++++++--------
>  include/linux/wwan.h                   |  5 ++-
>  3 files changed, 56 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> index 33931bfd78fd..5e8589582121 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> +++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> @@ -54,13 +54,12 @@ static void t7xx_port_ctrl_stop(struct wwan_port *port)
>  static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
>  {
>         struct t7xx_port *port_private = wwan_port_get_drvdata(port);
> -       size_t len, offset, chunk_len = 0, txq_mtu = CLDMA_MTU;
>         const struct t7xx_port_conf *port_conf;
>         struct t7xx_fsm_ctl *ctl;
>         enum md_state md_state;
> +       int ret;
>
> -       len = skb->len;
> -       if (!len || !port_private->chan_enable)
> +       if (!port_private->chan_enable)
>                 return -EINVAL;
>
>         port_conf = port_private->port_conf;
> @@ -72,33 +71,33 @@ static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
>                 return -ENODEV;
>         }
>
> -       for (offset = 0; offset < len; offset += chunk_len) {
> -               struct sk_buff *skb_ccci;
> -               int ret;
> -
> -               chunk_len = min(len - offset, txq_mtu - sizeof(struct ccci_header));
> -               skb_ccci = t7xx_port_alloc_skb(chunk_len);
> -               if (!skb_ccci)
> -                       return -ENOMEM;
> -
> -               skb_put_data(skb_ccci, skb->data + offset, chunk_len);
> -               ret = t7xx_port_send_skb(port_private, skb_ccci, 0, 0);
> -               if (ret) {
> -                       dev_kfree_skb_any(skb_ccci);
> -                       dev_err(port_private->dev, "Write error on %s port, %d\n",
> -                               port_conf->name, ret);
> -                       return ret;
> -               }
> +       ret = t7xx_port_send_skb(port_private, skb, 0, 0);
> +       if (ret) {
> +               dev_err(port_private->dev, "Write error on %s port, %d\n",
> +                       port_conf->name, ret);
> +               return ret;
>         }
> -
>         dev_kfree_skb(skb);
> +
>         return 0;
>  }
>
> +static size_t t7xx_port_get_tx_rsvd_headroom(struct wwan_port *port)
> +{
> +       return sizeof(struct ccci_header);
> +}
> +
> +static size_t t7xx_port_get_tx_chunk_len(struct wwan_port *port)
> +{
> +       return CLDMA_MTU - sizeof(struct ccci_header);
> +}
> +
>  static const struct wwan_port_ops wwan_ops = {
>         .start = t7xx_port_ctrl_start,
>         .stop = t7xx_port_ctrl_stop,
>         .tx = t7xx_port_ctrl_tx,
> +       .get_tx_rsvd_headroom = t7xx_port_get_tx_rsvd_headroom,

Can't we have a simple 'skb_headroom' or 'needed_headroom' member here?

> +       .get_tx_chunk_len = t7xx_port_get_tx_chunk_len,
>  };
>
