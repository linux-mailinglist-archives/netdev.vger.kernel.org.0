Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2323518C1E
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 20:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbiECSWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 14:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241184AbiECSWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 14:22:32 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A53EAB7;
        Tue,  3 May 2022 11:18:59 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id j9so14412524qkg.1;
        Tue, 03 May 2022 11:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=spnn+q8TrCXO+IkFYKXUusDYogbgo9s6L1zJCpp5TCU=;
        b=PNLMlGltCnL18Npgw9YraobHTN/rKVDLZuJyqL85R8HLKuf8oqHSBnfX8dQHOPmZiP
         aarS9uVpVGxzYOfxFA3Gw70jW91DD54EXyBHYJ69Vh6R8rTtijhUg8CPY7BXamu29zJ0
         FUvfTLhvlIXT+XGIvS4f/TBbaefYEfndO/tg6eLNcg/BdW18Pc9RhVMz39DMPaM9STQi
         cPX8Jqi80F+MrGski65Dgjsp7Y9fdw3dQVMLjC5XgMZtLT/OQTQIkupdfXvIvKO0jdqu
         m+HnLFxlWvq53WlyBtHBbDbOHXmy4TSg/jNNe3W7j3HTwl/IO7CIaI6/sLph5oxg5Dxi
         P6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=spnn+q8TrCXO+IkFYKXUusDYogbgo9s6L1zJCpp5TCU=;
        b=Wuhq/cATYnZseC8Lz1yQL1lF99pLlWE85pTuSJE8YM8Uja5JkfKTN4MZufDUafbepe
         lXCwUFTsBGjJkUVe8jnBQ4tGmqdVer60C8hLzoweWpRpErcQro3wRKxIXnllieAl0pII
         vg5xTkLxj0Tu4MwT6mnNYstqX99fUkC0btSAnRe3l+VoT7D0m+3BI6/zwGhl0ar9Obet
         OIwc2Fi1/yhEn3Ohncha7nkbZLzr+WQVHDNVIVWFhIglgQHB4gAcxoAywtKGZQ5GYuc5
         IkOWyu29KBoyRY/5Dp8kF7zC3fvUPfj5iw+8Eu+kE15UX0tMuXqIdHPZ6HcLiS8q4iI8
         vbTw==
X-Gm-Message-State: AOAM530k/oyuyJChKAXMHvdpu7IX3XNBdio9V7I9Qhizbv5FDiUkNx1b
        CppKLgzR5oSaYEChsd1NDaU=
X-Google-Smtp-Source: ABdhPJwBrg7LhR7U5VoEkeRrAZ3cCPybGO2VL1rpu95WON/xwJVhqheWdJsp4TmZt4hKVD/qJIjL5Q==
X-Received: by 2002:a05:620a:e01:b0:69f:6042:7fa3 with SMTP id y1-20020a05620a0e0100b0069f60427fa3mr12383818qkm.524.1651601938329;
        Tue, 03 May 2022 11:18:58 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([4.34.18.218])
        by smtp.gmail.com with ESMTPSA id b25-20020a05620a127900b0069fc13ce1f6sm6194868qkl.39.2022.05.03.11.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 11:18:57 -0700 (PDT)
Date:   Tue, 3 May 2022 14:18:53 -0400
From:   Jaehee Park <jhpark1013@gmail.com>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        outreachy@lists.linux.dev, Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] wfx: use container_of() to get vif
Message-ID: <20220503181853.GA886315@jaehee-ThinkPad-X1-Extreme>
References: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme>
 <22643645.6Emhk5qWAg@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22643645.6Emhk5qWAg@pc-42>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 03:39:19PM +0200, Jérôme Pouiller wrote:
> On Monday 18 April 2022 05:51:10 CEST Jaehee Park wrote:
> > 
> > Currently, upon virtual interface creation, wfx_add_interface() stores
> > a reference to the corresponding struct ieee80211_vif in private data,
> > for later usage. This is not needed when using the container_of
> > construct. This construct already has all the info it needs to retrieve
> > the reference to the corresponding struct from the offset that is
> > already available, inherent in container_of(), between its type and
> > member inputs (struct ieee80211_vif and drv_priv, respectively).
> > Remove vif (which was previously storing the reference to the struct
> > ieee80211_vif) from the struct wfx_vif, define a function
> > wvif_to_vif(wvif) for container_of(), and replace all wvif->vif with
> > the newly defined container_of construct.
> > 
> > Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> > ---
> > 
> > Changes from staging to wireless-next tree
> > - changed macro into function and named it back to wvif_to_vif
> > - fit all lines in patch to 80 columns
> > - decared a reference to vif at the beginning of the functions
> > 
> > NOTE: Jérôme is going to be testing this patch on his hardware
> 
> Don't forget to increment the version number of your submission (option
> -v of git send-email).
> 
> >  drivers/net/wireless/silabs/wfx/wfx.h     |  6 +-
> >  drivers/net/wireless/silabs/wfx/data_rx.c |  5 +-
> >  drivers/net/wireless/silabs/wfx/data_tx.c |  3 +-
> >  drivers/net/wireless/silabs/wfx/key.c     |  4 +-
> >  drivers/net/wireless/silabs/wfx/queue.c   |  3 +-
> >  drivers/net/wireless/silabs/wfx/scan.c    |  9 ++-
> >  drivers/net/wireless/silabs/wfx/sta.c     | 69 ++++++++++++++---------
> >  7 files changed, 63 insertions(+), 36 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/silabs/wfx/wfx.h b/drivers/net/wireless/silabs/wfx/wfx.h
> > index 6594cc647c2f..718693a4273d 100644
> > --- a/drivers/net/wireless/silabs/wfx/wfx.h
> > +++ b/drivers/net/wireless/silabs/wfx/wfx.h
> > @@ -61,7 +61,6 @@ struct wfx_dev {
> > 
> >  struct wfx_vif {
> >         struct wfx_dev             *wdev;
> > -       struct ieee80211_vif       *vif;
> >         struct ieee80211_channel   *channel;
> >         int                        id;
> > 
> > @@ -91,6 +90,11 @@ struct wfx_vif {
> >         struct completion          set_pm_mode_complete;
> >  };
> > 
> > +static inline struct ieee80211_vif *wvif_to_vif(struct wfx_vif *wvif)
> > +{
> > +       return container_of((void *)wvif, struct ieee80211_vif, drv_priv);
> > +}
> > +
> >  static inline struct wfx_vif *wdev_to_wvif(struct wfx_dev *wdev, int vif_id)
> >  {
> >         if (vif_id >= ARRAY_SIZE(wdev->vif)) {
> > diff --git a/drivers/net/wireless/silabs/wfx/data_rx.c b/drivers/net/wireless/silabs/wfx/data_rx.c
> > index a4b5ffe158e4..342b9cd0e74c 100644
> > --- a/drivers/net/wireless/silabs/wfx/data_rx.c
> > +++ b/drivers/net/wireless/silabs/wfx/data_rx.c
> > @@ -16,6 +16,7 @@
> >  static void wfx_rx_handle_ba(struct wfx_vif *wvif, struct ieee80211_mgmt *mgmt)
> >  {
> >         int params, tid;
> > +       struct ieee80211_vif *vif = wvif_to_vif(wvif);
> 
> When you can, try to place the longest declaration first ("reverse
> Christmas tree order").

Thanks Jerome, I have a new version of the patch I'm going to send today
with this edit.

> 
> [...]
> > diff --git a/drivers/net/wireless/silabs/wfx/sta.c b/drivers/net/wireless/silabs/wfx/sta.c
> > index 3297d73c327a..97fcbad23c94 100644
> > --- a/drivers/net/wireless/silabs/wfx/sta.c
> > +++ b/drivers/net/wireless/silabs/wfx/sta.c
> [...]
> > @@ -152,19 +153,28 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvif, bool *enable_ps)
> >  {
> >         struct ieee80211_channel *chan0 = NULL, *chan1 = NULL;
> >         struct ieee80211_conf *conf = &wvif->wdev->hw->conf;
> > +       struct ieee80211_vif *vif = wvif_to_vif(wvif);
> > 
> > -       WARN(!wvif->vif->bss_conf.assoc && enable_ps,
> > +       WARN(!vif->bss_conf.assoc && enable_ps,
> >              "enable_ps is reliable only if associated");
> > -       if (wdev_to_wvif(wvif->wdev, 0))
> > -               chan0 = wdev_to_wvif(wvif->wdev, 0)->vif->bss_conf.chandef.chan;
> > -       if (wdev_to_wvif(wvif->wdev, 1))
> > -               chan1 = wdev_to_wvif(wvif->wdev, 1)->vif->bss_conf.chandef.chan;
> > -       if (chan0 && chan1 && wvif->vif->type != NL80211_IFTYPE_AP) {
> > +       if (wdev_to_wvif(wvif->wdev, 0)) {
> > +               struct wfx_vif *wvif_ch0 = wdev_to_wvif(wvif->wdev, 0);
> > +               struct ieee80211_vif *vif_ch0 = wvif_to_vif(wvif_ch0);
> > +
> > +               chan0 = vif_ch0->bss_conf.chandef.chan;
> > +       }
> > +       if (wdev_to_wvif(wvif->wdev, 1)) {
> > +               struct wfx_vif *wvif_ch1 = wdev_to_wvif(wvif->wdev, 1);
> > +               struct ieee80211_vif *vif_ch1 = wvif_to_vif(wvif_ch1);
> > +
> > +               chan1 = vif_ch1->bss_conf.chandef.chan;
> > +       }
> 
> I think this code could be simplified into:
> 
>        if (wvif->wdev->vif[1])
>                chan1 = wvif->wdev->vif[1]->bss_conf.chandef.chan;
> 
> (If you choose this way, I suggest to place this change in a separate
> patch)
> 

Ok I'll send your suggested edit in a separate patch after this patch
gets through.

> [...]
> 
> -- 
> Jérôme Pouiller
> 
> 
