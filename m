Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A1C2A3772
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgKCAGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgKCAGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 19:06:32 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C18C061A48
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 16:06:32 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id i2so17072088ljg.4
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 16:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WHMOmkhlRWyq97AfxS2rXTffakjk5zbzZZUU7niR7ko=;
        b=hv08MmKqPW2kwHXqrNQp2ucUSP5RIUEfSR109ZFv/+GCfvLMMs748r0m1pga8q2tP7
         NKctrAbp0S6uaLSATDuyAfO2MPnGC4c4ilXwVCDYmawkODWJXJ/TkvVBDFuStFWWuL1R
         ySxawLXlGOyaudd+de2xvN3RGV4tNKoNyIGq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WHMOmkhlRWyq97AfxS2rXTffakjk5zbzZZUU7niR7ko=;
        b=deYHA2pgXR3tcnlgw/Aaj58Tlhe+8cs4TdNbh269+Gawe5w5NTaPEjmfVwemkYWhoB
         gTiIshr2xD3wMvKmOxRmMYSmGNwYXN6uhCl5xgN9mLafpi4r43d0/Wd978W52pywjaIT
         Y5ClTt4kN6RtTAdhTKByLVEwjKIuRhkmRqkL1+YYSU08F5O/ceHRv0idp+YmnVEQjuRY
         0KmE/ir3kY9tgcL7oDNjyZ//LotkYisPL6dpVImmFmbVGbsWqOUWO8S6KxdUq25w3Drx
         q29uwDDJgRimnj5hDd4LdUY1wuGmAttsM3JTWD9PlrMUViNBHhDnFcYwWaImhwNMbp7b
         VgHQ==
X-Gm-Message-State: AOAM533+J+6Jfeka15xuulCfnKf1rTMkNUp8ujOfB5kq8vYq7qDnfNHZ
        W1OaBcP38RaIX5HEs2RzcptN/pZk4wdnSA==
X-Google-Smtp-Source: ABdhPJyA8Qutp7SIrx6ZP56hxDmtArVGC1WpnTBN6lWt9zLtGmhQ87HyrcAVZlMqKUZ+2+YDFCpjyg==
X-Received: by 2002:a05:651c:234:: with SMTP id z20mr8100459ljn.337.1604361990677;
        Mon, 02 Nov 2020 16:06:30 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id m2sm2787026lfo.25.2020.11.02.16.06.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 16:06:30 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id l2so19850538lfk.0
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 16:06:28 -0800 (PST)
X-Received: by 2002:a19:41d7:: with SMTP id o206mr7188801lfa.396.1604361987822;
 Mon, 02 Nov 2020 16:06:27 -0800 (PST)
MIME-Version: 1.0
References: <20201102112410.1049272-1-lee.jones@linaro.org> <20201102112410.1049272-42-lee.jones@linaro.org>
In-Reply-To: <20201102112410.1049272-42-lee.jones@linaro.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 2 Nov 2020 16:06:15 -0800
X-Gmail-Original-Message-ID: <CA+ASDXOobW1_qL5SCGS86aoGvhKDMoBzjxbAwn+QjHfkqZhukw@mail.gmail.com>
Message-ID: <CA+ASDXOobW1_qL5SCGS86aoGvhKDMoBzjxbAwn+QjHfkqZhukw@mail.gmail.com>
Subject: Re: [PATCH 41/41] realtek: rtw88: pci: Add prototypes for .probe,
 .remove and .shutdown
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 3:25 AM Lee Jones <lee.jones@linaro.org> wrote:
> --- a/drivers/net/wireless/realtek/rtw88/pci.h
> +++ b/drivers/net/wireless/realtek/rtw88/pci.h
> @@ -212,6 +212,10 @@ struct rtw_pci {
>         void __iomem *mmap;
>  };
>
> +int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
> +void rtw_pci_remove(struct pci_dev *pdev);
> +void rtw_pci_shutdown(struct pci_dev *pdev);
> +
>

These definitions are already in 4 other header files:

drivers/net/wireless/realtek/rtw88/rtw8723de.h
drivers/net/wireless/realtek/rtw88/rtw8821ce.h
drivers/net/wireless/realtek/rtw88/rtw8822be.h
drivers/net/wireless/realtek/rtw88/rtw8822ce.h

Seems like you should be moving them, not just adding yet another duplicate.

Brian
