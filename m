Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5F3517695
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386897AbiEBShl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiEBShj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:37:39 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909D2636B;
        Mon,  2 May 2022 11:34:09 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id t11so11725577qto.11;
        Mon, 02 May 2022 11:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4pWl4qpJf3TJEYYU3tzVCW+qGQ3DSAzsFResAB6bdFY=;
        b=hljZ054dngOMdWddIV70DVGtwCcA0eE7eauXelWgVRkyjbo8qvg1QfZ0ACZak4cSXb
         mhLtdisGjhZL4DupQ8BV4OopRmeGYqUa8AKYsYC1WvsK4R/RG79bN518MEH6dDL9X3eN
         9x3dDg2IjHmp2ddAhKE4irB+CjeQz6ToDkv2IIIOzMj0epQ4jF97HgdKxPYzMpxJ5J+N
         Ku/GLJvpiK3+1S7rOJgg52MTk3AHV5B0Pryexo1v6IxHo+rJN/UVnAqENm5tr+XwupKc
         IrT+7L4qhDqTCkw8sVJ4PxSr09gEt2tMC0o5BEZThyilstGQv7wa0dc2NlBtWYPBokmN
         3x6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4pWl4qpJf3TJEYYU3tzVCW+qGQ3DSAzsFResAB6bdFY=;
        b=4UXnJDERFRdOZXRvRxd26kx7u2wK5sjHLRCa33WsI0kRaEm042PCfw7eaLzR+lRqcD
         yiyEMEIyNbsA8IYkSQEsqiT66nj0kxYusGKBnIKz83TWOS/1ZBvo+J1XygFtO+BUVd4g
         XLj9bGd4Ozk+sUdoUC0ZJGMtX4xWAbHnpiAvoFWKuaYQJL0cRQHI2WGXMObLcMsaNs9m
         +19ci8L8xHeBtfq+Cc55BFc84r0i3vWzMuXC1riop2kj7ze23l1aP9K0ypC1it+eQRlj
         XaR8SGDS+fDuI0dZ/K2es8DncTU7lyl73Q9IU9S3DHMzhqbLbFqET57PXO3o5zA+ZHVF
         IQjA==
X-Gm-Message-State: AOAM5302a6KCEwp/28m9NCWUvwNaHYNxcvvUUfslfxpLkR6sVp2+KlJ1
        fJXTukuVHpQjQMAzpoRnQHk=
X-Google-Smtp-Source: ABdhPJxEHbQthHynKn6InPI8iEFvDKDeokgE1dGsJguX910oVK6dcW4hmvOXKaRtlN+Uk5JTgcWtoA==
X-Received: by 2002:a05:622a:1352:b0:2f3:9afb:5ab8 with SMTP id w18-20020a05622a135200b002f39afb5ab8mr11572008qtk.451.1651516448617;
        Mon, 02 May 2022 11:34:08 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([4.34.18.218])
        by smtp.gmail.com with ESMTPSA id bj33-20020a05620a192100b0069fc13ce1dcsm4688245qkb.13.2022.05.02.11.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 11:34:07 -0700 (PDT)
Date:   Mon, 2 May 2022 14:34:03 -0400
From:   Jaehee Park <jhpark1013@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        Outreachy Linux Kernel <outreachy@lists.linux.dev>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] wfx: use container_of() to get vif
Message-ID: <20220502183403.GA812540@jaehee-ThinkPad-X1-Extreme>
References: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme>
 <87y200nf0a.fsf@kernel.org>
 <CAA1TwFCOEEwnayexnJin8T=Fc2HEgHC9jyfj5HxfiWybjUi9GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1TwFCOEEwnayexnJin8T=Fc2HEgHC9jyfj5HxfiWybjUi9GA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 02:10:07PM -0400, Jaehee wrote:
> On Wed, Apr 20, 2022 at 7:58 AM Kalle Valo <kvalo@kernel.org> wrote:
> >
> > Jaehee Park <jhpark1013@gmail.com> writes:
> >
> > > Currently, upon virtual interface creation, wfx_add_interface() stores
> > > a reference to the corresponding struct ieee80211_vif in private data,
> > > for later usage. This is not needed when using the container_of
> > > construct. This construct already has all the info it needs to retrieve
> > > the reference to the corresponding struct from the offset that is
> > > already available, inherent in container_of(), between its type and
> > > member inputs (struct ieee80211_vif and drv_priv, respectively).
> > > Remove vif (which was previously storing the reference to the struct
> > > ieee80211_vif) from the struct wfx_vif, define a function
> > > wvif_to_vif(wvif) for container_of(), and replace all wvif->vif with
> > > the newly defined container_of construct.
> > >
> > > Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> >
> > [...]
> >
> > > +static inline struct ieee80211_vif *wvif_to_vif(struct wfx_vif *wvif)
> > > +{
> > > +     return container_of((void *)wvif, struct ieee80211_vif, drv_priv);
> > > +}
> >
> > Why the void pointer cast? Avoid casts as much possible.
> >
> 
> Hi Kalle,
> 
> Sorry for the delay in getting back to you about why the void pointer
> cast was used.
> 
> In essence, I'm taking private data with a driver-specific pointer
> and that needs to be resolved back to a generic pointer.
> 
> The private data (drv_priv) is declared as a generic u8 array in struct
> ieee80211_vif, but wvif is a more specific type.
> 
> I wanted to also point to existing, reasonable examples such as:
> static void iwl_mvm_tcm_uapsd_nonagg_detected_wk(struct work_struct *wk)
> {
>         struct iwl_mvm *mvm;
>         struct iwl_mvm_vif *mvmvif;
>         struct ieee80211_vif *vif;
> 
>         mvmvif = container_of(wk, struct iwl_mvm_vif,
>                               uapsd_nonagg_detected_wk.work);
>         vif = container_of((void *)mvmvif, struct ieee80211_vif, drv_priv);
> 
> in drivers/net/wireless$ less intel/iwlwifi/mvm/utils.c, which does the
> same thing.
> 
> There are fifteen of them throughout:
> wireless-next/drivers/net/wireless$ grep -rn "container_of(.* ieee80211_vif"
> intel/iwlwifi/mvm/utils.c:794:  vif = container_of((void *)mvmvif,
> struct ieee80211_vif, drv_priv);
> intel/iwlwifi/mvm/mac80211.c:1347:      vif = container_of((void
> *)mvmvif, struct ieee80211_vif, drv_priv);
> mediatek/mt76/mt76x02_mmio.c:415:               vif =
> container_of(priv, struct ieee80211_vif, drv_priv);
> mediatek/mt76/mt7615/mac.c:275: vif = container_of((void *)msta->vif,
> struct ieee80211_vif, drv_priv);
> mediatek/mt76/mt7915/mac.c:416: vif = container_of((void *)msta->vif,
> struct ieee80211_vif, drv_priv);
> mediatek/mt76/mt7915/mac.c:2327:                vif =
> container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
> mediatek/mt76/mt7915/debugfs.c:1026:    vif = container_of((void
> *)msta->vif, struct ieee80211_vif, drv_priv);
> mediatek/mt76/mt7921/mac.c:425: vif = container_of((void *)msta->vif,
> struct ieee80211_vif, drv_priv);
> ti/wlcore/wlcore_i.h:502:       return container_of((void *)wlvif,
> struct ieee80211_vif, drv_priv);
> realtek/rtl818x/rtl8187/dev.c:1068:             container_of((void
> *)vif_priv, struct ieee80211_vif, drv_priv);
> realtek/rtl818x/rtl8180/dev.c:1293:             container_of((void
> *)vif_priv, struct ieee80211_vif, drv_priv);
> realtek/rtw88/main.h:2075:      return container_of(p, struct
> ieee80211_vif, drv_priv);
> realtek/rtw89/core.h:3440:      return container_of(p, struct
> ieee80211_vif, drv_priv);
> ath/carl9170/carl9170.h:641:    return container_of((void *)priv,
> struct ieee80211_vif, drv_priv);
> ath/wcn36xx/wcn36xx.h:329:      return container_of((void *) vif_priv,
> struct ieee80211_vif, drv_priv);
> 

Sorry -- here's the last portion of the email without wrapping.

wireless-next/drivers/net/wireless$ grep -rn "container_of(.* ieee80211_vif"
intel/iwlwifi/mvm/utils.c:794:  vif = container_of((void *)mvmvif, struct ieee80211_vif, drv_priv);
intel/iwlwifi/mvm/mac80211.c:1347:      vif = container_of((void *)mvmvif, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt76x02_mmio.c:415:               vif = container_of(priv, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7615/mac.c:275: vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7915/mac.c:416: vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7915/mac.c:2327:                vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7915/debugfs.c:1026:    vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7921/mac.c:425: vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
ti/wlcore/wlcore_i.h:502:       return container_of((void *)wlvif, struct ieee80211_vif, drv_priv);
realtek/rtl818x/rtl8187/dev.c:1068:             container_of((void *)vif_priv, struct ieee80211_vif, drv_priv);
realtek/rtl818x/rtl8180/dev.c:1293:             container_of((void *)vif_priv, struct ieee80211_vif, drv_priv);
realtek/rtw88/main.h:2075:      return container_of(p, struct ieee80211_vif, drv_priv);
realtek/rtw89/core.h:3440:      return container_of(p, struct ieee80211_vif, drv_priv);
ath/carl9170/carl9170.h:641:    return container_of((void *)priv, struct ieee80211_vif, drv_priv);
ath/wcn36xx/wcn36xx.h:329:      return container_of((void *) vif_priv, struct ieee80211_vif, drv_priv);

> Thanks,
> Jaehee
> 
> 
> > --
> > https://patchwork.kernel.org/project/linux-wireless/list/
> >
> > https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
