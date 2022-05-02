Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18027517654
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386712AbiEBSOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352269AbiEBSNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:13:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC74DDC;
        Mon,  2 May 2022 11:10:20 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g20so17484399edw.6;
        Mon, 02 May 2022 11:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cddP/Z13UXKTkYF9w5rF9NXnRnnOzjoeOmrL0f6HI08=;
        b=F4Ji6+339Da2kNbJt5KKB7iw7+2g8p0PdFRFplhegL4px6LEkwgymj9L/pFn3CKBMV
         M+iTz/GM3qvVMi2QegU8yveV2OOFZmAxCvrCM4nLweuQEEpJ4fxxBuwW0XcnPU3rjJ9v
         fcCIx4zoHjmKrJCBrSvCJw8DNNIJoMWbJlEjobxiZpJEGTuUESzb+Vpc9FAb8FFSQ79e
         TaNbZ9/pe0G86boa4lsXTrbTzX9iP/riBvjaCj5pi1N75VT11wl30atdIppi2ABltn2c
         +eMnaENwkKjFugo19M5yBot9eE3DFetuaurpWhQZ0JdK6VTc9D9pkL2NlLAeoooATGgA
         MZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cddP/Z13UXKTkYF9w5rF9NXnRnnOzjoeOmrL0f6HI08=;
        b=fQUEWfbe6OynlSN9aGgkfIqMhpg+UZnyo9ssnYCk/VXKmXt4nWwesw34A4jQhrcsDS
         ce3JZMQwwldktFrNP77gshpsEYJT684nzAXuGYJpZiYF6QCynYDd6tG4u9vcVRTCKLkI
         I1xF5VzP7EylIKmjADWBI+4RZGEifk0aVzdNNSJnyFZrx4A90uKRQJ3kdjRR1Cu18/Fo
         KpG8Y1ACH2mooQvQifgb6x10KLhQ1GD9x4kfF5Ap8sbrC0reG8sP0ehlT/yE0S7LvA07
         iHMH9FCWTyL5UGsF/VEt2GSpKx+SEV28PXFx+L7DKAR+OCLb4ZCkTb5lDEImHAzruo3H
         UugA==
X-Gm-Message-State: AOAM533GA0coyLo8T5QORr0gNK4uClSc3ic5abZf92rcXOUmffiaUPaj
        owWnXl2YQP7JyKW7AXMufvDRjnso+Y5KrV0Syzw=
X-Google-Smtp-Source: ABdhPJyAa/9HmMmjO94kXjbkmG4pWu+zNT9xHmyWE/CXwDtYN0lWRAO9cZuAqtNG8XIU0X0BXKICydnJAYvu0uflUi8=
X-Received: by 2002:a05:6402:484:b0:415:d931:cb2f with SMTP id
 k4-20020a056402048400b00415d931cb2fmr14666889edv.287.1651515019042; Mon, 02
 May 2022 11:10:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme> <87y200nf0a.fsf@kernel.org>
In-Reply-To: <87y200nf0a.fsf@kernel.org>
From:   Jaehee <jhpark1013@gmail.com>
Date:   Mon, 2 May 2022 14:10:07 -0400
Message-ID: <CAA1TwFCOEEwnayexnJin8T=Fc2HEgHC9jyfj5HxfiWybjUi9GA@mail.gmail.com>
Subject: Re: [PATCH] wfx: use container_of() to get vif
To:     Kalle Valo <kvalo@kernel.org>
Cc:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        Outreachy Linux Kernel <outreachy@lists.linux.dev>,
        Stefano Brivio <sbrivio@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 7:58 AM Kalle Valo <kvalo@kernel.org> wrote:
>
> Jaehee Park <jhpark1013@gmail.com> writes:
>
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
>
> [...]
>
> > +static inline struct ieee80211_vif *wvif_to_vif(struct wfx_vif *wvif)
> > +{
> > +     return container_of((void *)wvif, struct ieee80211_vif, drv_priv);
> > +}
>
> Why the void pointer cast? Avoid casts as much possible.
>

Hi Kalle,

Sorry for the delay in getting back to you about why the void pointer
cast was used.

In essence, I'm taking private data with a driver-specific pointer
and that needs to be resolved back to a generic pointer.

The private data (drv_priv) is declared as a generic u8 array in struct
ieee80211_vif, but wvif is a more specific type.

I wanted to also point to existing, reasonable examples such as:
static void iwl_mvm_tcm_uapsd_nonagg_detected_wk(struct work_struct *wk)
{
        struct iwl_mvm *mvm;
        struct iwl_mvm_vif *mvmvif;
        struct ieee80211_vif *vif;

        mvmvif = container_of(wk, struct iwl_mvm_vif,
                              uapsd_nonagg_detected_wk.work);
        vif = container_of((void *)mvmvif, struct ieee80211_vif, drv_priv);

in drivers/net/wireless$ less intel/iwlwifi/mvm/utils.c, which does the
same thing.

There are fifteen of them throughout:
wireless-next/drivers/net/wireless$ grep -rn "container_of(.* ieee80211_vif"
intel/iwlwifi/mvm/utils.c:794:  vif = container_of((void *)mvmvif,
struct ieee80211_vif, drv_priv);
intel/iwlwifi/mvm/mac80211.c:1347:      vif = container_of((void
*)mvmvif, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt76x02_mmio.c:415:               vif =
container_of(priv, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7615/mac.c:275: vif = container_of((void *)msta->vif,
struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7915/mac.c:416: vif = container_of((void *)msta->vif,
struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7915/mac.c:2327:                vif =
container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7915/debugfs.c:1026:    vif = container_of((void
*)msta->vif, struct ieee80211_vif, drv_priv);
mediatek/mt76/mt7921/mac.c:425: vif = container_of((void *)msta->vif,
struct ieee80211_vif, drv_priv);
ti/wlcore/wlcore_i.h:502:       return container_of((void *)wlvif,
struct ieee80211_vif, drv_priv);
realtek/rtl818x/rtl8187/dev.c:1068:             container_of((void
*)vif_priv, struct ieee80211_vif, drv_priv);
realtek/rtl818x/rtl8180/dev.c:1293:             container_of((void
*)vif_priv, struct ieee80211_vif, drv_priv);
realtek/rtw88/main.h:2075:      return container_of(p, struct
ieee80211_vif, drv_priv);
realtek/rtw89/core.h:3440:      return container_of(p, struct
ieee80211_vif, drv_priv);
ath/carl9170/carl9170.h:641:    return container_of((void *)priv,
struct ieee80211_vif, drv_priv);
ath/wcn36xx/wcn36xx.h:329:      return container_of((void *) vif_priv,
struct ieee80211_vif, drv_priv);

Thanks,
Jaehee


> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
