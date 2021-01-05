Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC242EA8DC
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbhAEKeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbhAEKeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:34:01 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEE1C061574;
        Tue,  5 Jan 2021 02:33:21 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jx16so40523558ejb.10;
        Tue, 05 Jan 2021 02:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dq/maS4XldzpEIGlbDHKZApzDTOwZvZ/+2d1tQgalN8=;
        b=WLK8B0dALXja7tR4ks/3hCp5JsNGM+rPQTjQxDrFPdm8FTFoLPr8YryEI1L+5A6vKU
         3F6AD+dwWSEo3sVAv0TBq1rqFweDVbwuxNYhbTeo9rQUqzI0KPc2/GZtYkSaDCC9MHMG
         6OcFI25x4oXa1FN3KXp8H9wpRmw9diiQyTLLFC2rWckiWevYEcDud+zt7q8JOXGsN+V4
         IGvuzooTqiBzL27srKbL4OSYSAUV3a6zlsH9PLNhuIjN0MDLnhSvZ+CpXJ/DBeZisAtM
         DIozd4mx4noxgpsdJ/lwmrgCp5U8hBKDxOtsor7s3fvHsgKdHmxTRih4TpCHaIyYtGyl
         Fh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dq/maS4XldzpEIGlbDHKZApzDTOwZvZ/+2d1tQgalN8=;
        b=PSiDRzbP9bcl7iriH2H1AuguyQ+H1XkXE95fLayFEKL3Ka65tCU6nCGkaVJnHb9pAg
         Ea7OfhQDI8BcjeDoL0W1g8JULCNbq2wKuNlRiK2XRP3qGsARUlu6T0lO+O8QoIMuH0sY
         PBlYh4nc9hyhy78uGtHz/+XZpyC/c32B5ET5pPLpWCBw3PPhyKbm80a5vlo7cUxDIrg2
         whsCDHogtsN+VivFbWJfxHZpERYgZMBn7t74bh3cWuc57bNwdhldxZwRBjKGNr+uJsNW
         7cvaddgJcAX2ixIA+EvDDwxHRiNHHTeOM1nxruyvEGlUhsyj+RjP1d3VXhrFmgHHVhc+
         n5uQ==
X-Gm-Message-State: AOAM532I46k3izlMRWGznp0XMyyXI2bJwB1iQDfp3Sn6ge4NNxoTipZk
        3S4qlDSw5vAqVYKNffOb4mjB2g3IT/t9KssxcEc=
X-Google-Smtp-Source: ABdhPJw1IwoJvvz4E+71CPNwYvcxrEWRatNU1zEF3QU2DLXubK5dt1H79wfPg49In58VUpdywFPTICQ9yXUZfDnwO7k=
X-Received: by 2002:a17:906:7f0b:: with SMTP id d11mr70752957ejr.7.1609842800032;
 Tue, 05 Jan 2021 02:33:20 -0800 (PST)
MIME-Version: 1.0
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
In-Reply-To: <20210105101738.13072-1-unixbhaskar@gmail.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 5 Jan 2021 21:33:08 +1100
Message-ID: <CAGRGNgX-JSPW8LSmAUbm=2jkx+K4EYdntCq6P2i8td0TUk7Nww@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word association
 defautly de-faulty
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        zhengbin13@huawei.com, baijiaju1990@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bhaskar,

On Tue, Jan 5, 2021 at 9:19 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>
> s/defautly/de-faulty/p
>
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> index c948dafa0c80..7d02d8abb4eb 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> @@ -814,7 +814,7 @@ bool rtl88ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
>         u8 own = (u8)rtl88ee_get_desc(hw, entry, true, HW_DESC_OWN);
>
>         /*beacon packet will only use the first
> -        *descriptor defautly,and the own may not
> +        *descriptor de-faulty,and the own may not

Really? "de-faultly" isn't any better than "defaultly" and in fact
it's even worse as it breaks up the word "default".

This change doesn't make sense and the comment really needs to be
completely re-written by someone who understands what's going on here
as it barely makes sense.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
