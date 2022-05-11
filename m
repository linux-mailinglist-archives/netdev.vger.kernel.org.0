Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0659522918
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 03:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239517AbiEKBqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 21:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240757AbiEKBqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 21:46:10 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF67B3586E;
        Tue, 10 May 2022 18:46:08 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g23so729030edy.13;
        Tue, 10 May 2022 18:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lyB03zfkduhEQiKRtkxNNhqSXJSw0Ic5n3CoIbYjaT8=;
        b=PQfJWnTl4JTkqYV9vXc5RAPcrHTk3U40whCmQ7E/JC7ivDUBuz4k48ILtQKDiSWBRG
         JptbT4Td5Rn1lOXj5gyNVWMVXgdEVd3Ikn5LUZwwkSdotAC5tFwvqrboc+E0fahrbkVy
         fDsek+rD/1D3nA1uh/mw06whwWIKbVdw7j5F5UioiQBnXsflDDlC/8hrYpqu3sUNS0Tv
         iYK5aXLgujdlQVA8Pja79jS8+mLsuWN8dPobMkyYnJLMGH3Ar3tvUk+eR6AJFQYhsoXv
         UWcsSB7JLJ0CVPd0PV98W6sq+N1z+l5+iRmiPBEi8PjXuRT8iYWVkX7Z5yC+rEcHZg2v
         w04g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lyB03zfkduhEQiKRtkxNNhqSXJSw0Ic5n3CoIbYjaT8=;
        b=FV4SIkobs4KTgj4J6oAiymy1Rxt5jDNfk/5+vUgpFvwSeV8HfBJ957kVgts4ITnobP
         KshvHfPYMN+BQzVlRmhQLIJz5bLvvq5tlOlXo57g+tnM6TOEm7MqIuZ4Cqj/DeESTva7
         J0J9SKC3CNZmH3x/EpgASdgI9zjM2yRVQ33zhGl9tXCDemhb1Jf190Mw1gagxbrUj/T9
         3raok+RQ32fcZ8KZfzvrzdWOTRUH+JlnALUFFsnHaFRpOSkLjYKS2kpTfUUg5aquAZdG
         TLQBmX4FfdV3V9UM5df8bhM+jV2vGr7JWCNcsH5kZeyTZ64O+iiJFIUtlq8Okl+4r/N4
         KiRg==
X-Gm-Message-State: AOAM533Q0+F/V81u8nX0aHh1K1cohbxuN0+dX2CEkrSJbExZn1Wp3u7x
        8aYK0VPR9zRu3/O04p+Y9+FZ3QAnbrODSAtLwSw=
X-Google-Smtp-Source: ABdhPJyqTVojPz5rdn5gqtln5rHLx1GDmbyqtSJ8oJaxRgefOPVmNUn4LBKW8qWffhB2mSlIbhsHF6lAOHGx1jixXLw=
X-Received: by 2002:aa7:cd58:0:b0:427:b21f:5f79 with SMTP id
 v24-20020aa7cd58000000b00427b21f5f79mr25894850edw.172.1652233566587; Tue, 10
 May 2022 18:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220510092503.1546698-1-dzm91@hust.edu.cn> <87ee118kmk.fsf@kernel.org>
In-Reply-To: <87ee118kmk.fsf@kernel.org>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 11 May 2022 09:45:40 +0800
Message-ID: <CAD-N9QULVjecGcsmFGREGV=joyA2SoZFzLB9A-2tRPsVM0_Ohg@mail.gmail.com>
Subject: Re: [PATCH] net: rtlwifi: Use pr_warn_once instead of WARN_ONCE
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:37 PM Kalle Valo <kvalo@kernel.org> wrote:
>
> Dongliang Mu <dzm91@hust.edu.cn> writes:
>
> > From: Dongliang Mu <mudongliangabcd@gmail.com>
> >
> > This memory allocation failure can be triggered by fault injection or
> > high pressure testing, resulting a WARN.
> >
> > Fix this by replacing WARN with pr_warn_once.
> >
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  drivers/net/wireless/realtek/rtlwifi/usb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
> > index 86a236873254..acb0c15e9748 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
> > +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
> > @@ -1014,7 +1014,7 @@ int rtl_usb_probe(struct usb_interface *intf,
> >       hw = ieee80211_alloc_hw(sizeof(struct rtl_priv) +
> >                               sizeof(struct rtl_usb_priv), &rtl_ops);
> >       if (!hw) {
> > -             WARN_ONCE(true, "rtl_usb: ieee80211 alloc failed\n");
> > +             pr_warn_once("rtl_usb: ieee80211 alloc failed\n");
> >               return -ENOMEM;
> >       }
> >       rtlpriv = hw->priv;
>
> I think we should warn every time ieee80211_alloc_hw() fails, it's
> called only once per device initialisation, so pr_warn() is more
> approriate.

Yes, this is better. Already sent a v2 patch.

>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
