Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976D33BEBCC
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhGGQOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhGGQOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:14:00 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FC7C061574;
        Wed,  7 Jul 2021 09:11:18 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id c17so4082123ejk.13;
        Wed, 07 Jul 2021 09:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LPc2qNU/VIe5sZOEkhG3d0C8qdMRokFxLpvqhr2pZtU=;
        b=H1N73JjW9Wqpazm4xdkwx1BGX8HrKTHOaWZ6kdDFgns8Uqx2EpKOjJ+1Y2/mPE72GQ
         RlH3p8g2CVkEow1MFOnJRt1+br9f7QX8VS+wNY08FXwHqICqn7hfuBvPeI4sKxwbnzXl
         4P5v/9ECBGNfXD4BgbAEHbt4EDrx/An7Xy4u50EZj4my2BQr6SOREwfGAdAVRh5QZ6lU
         DMt0WFIB8c5rJvbwSJtRattI+J18iyqv9vBtuLS3eQp7WTaB1HE+O+eYPNQ7eD8Izg2i
         FLVdXXFyI2QEmKDGSezXUN/wdGtwk8InoBJa9k06sYA5UPLftMR7Jmg5w6TpG1JY7R8x
         RkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LPc2qNU/VIe5sZOEkhG3d0C8qdMRokFxLpvqhr2pZtU=;
        b=CDE7r4Y3A76J7lVaa2pCeC9mns780G7oQHn9D7iOKwqfnJ5+dt+3kMDX5hEof44Bmn
         AUAfYC3LIBiFXM6HUf7rtaQ7VxFPohqrMXZkwk8x6HWZfCbbojLghGXJoBzyUoZaGigd
         RCcOHenW02wYSNwCKaZPwI0c/7vUbk++sUY4PXfO7681xFgUnWnkzpvsaLkt1uC5icAp
         6Zj+ZXVJWGegie2Lp8pQ4K7UDQ1EDDaWKOkZ1Kc6zzI/YBytginviMoWGGVNevmvRrOC
         O0ID7rIRXcBx9UC7ZzgOKJg9a2np106lBWOi9jWUWu5YTqTwoVhUoW57akCFgmHltLGR
         PYAQ==
X-Gm-Message-State: AOAM531QGr0hHAwkB63P0+hQgy4KEG2pcN3GJEc51MfNQDU4d/Z0TsEz
        DmLIA3wRrS1oLlkHg8pYVe/dpHdQrJrqL/gLwSo=
X-Google-Smtp-Source: ABdhPJzNQUfa0AMSBhwqpAVIM0RdwtiGJ5zAXO34fcn+wtta+/CIhBXJVZuDdcxSVH4B1guXAegu1JSP7pv0bZuDpWk=
X-Received: by 2002:a17:906:4784:: with SMTP id cw4mr9069964ejc.160.1625674277560;
 Wed, 07 Jul 2021 09:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210707155633.1486603-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210707155633.1486603-1-mudongliangabcd@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 8 Jul 2021 00:10:51 +0800
Message-ID: <CAD-N9QWZTRWv0HYX9EpYCiGjeCPkiRP1SLn+ObW8zK=s4DTrhQ@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: fix GPF in hwsim_new_edge_nl
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Aring <aring@mojatatu.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 11:56 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
> must be present to fix GPF.

I double-check the whole file, and there is only one similar issue
left in Line 421.

 mac802154_hwsim.c      187 if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID])

mac802154_hwsim.c      299 if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID])

mac802154_hwsim.c      421 if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&

mac802154_hwsim.c      483 if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||

mac802154_hwsim.c      531 if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID]  ||

mac80211_hwsim.c      3575 if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||

mac80211_hwsim.c      3663 if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||

mac80211_hwsim.c      3982 if (!info->attrs[HWSIM_ATTR_RADIO_ID])

In addition, I check this pattern in the whole source code, it seems
if statements with "&&" in other files are correct. For example,

        if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
            (!info->attrs[NFC_ATTR_LLC_PARAM_LTO] &&
             !info->attrs[NFC_ATTR_LLC_PARAM_RW] &&
             !info->attrs[NFC_ATTR_LLC_PARAM_MIUX]))
                return -EINVAL;

>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> index cae52bfb871e..8caa61ec718f 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -418,7 +418,7 @@ static int hwsim_new_edge_nl(struct sk_buff *msg, struct genl_info *info)
>         struct hwsim_edge *e;
>         u32 v0, v1;
>
> -       if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
> +       if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
>             !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
>                 return -EINVAL;
>
> --
> 2.25.1
>
