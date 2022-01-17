Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6374349123D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 00:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243779AbiAQXOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 18:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiAQXO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 18:14:29 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B927C061574;
        Mon, 17 Jan 2022 15:14:29 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id e9-20020a05600c4e4900b0034d23cae3f0so679424wmq.2;
        Mon, 17 Jan 2022 15:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+DDlZOWObgE96mD8r18t+6GXnUAr+oljxdwIuzXVSqg=;
        b=bA17H8u0M9g7Tc9VpkQEWTPg069PRQq+4CtO0zidLT8QcpdYjAuu9kHFZDUFqH1kc2
         b94hLFeRsNMcUwyrf+RJKHuxDPHD+S4fTLet3YUdS/lX1sYrkTuPHixzzuq0WGM9PC9O
         lIzSD9v5YzZ8pT7EzpIX9SpyzSjkOnciKr1TEB9u4rFiDPeFPrB5EJpMZm90a16G3+hY
         dOQ16TSojra3rb/aR02nf8sDDraAIbVEe/Mu1fsF4RwdIZyjfjVf+f6z1ziN26dHTFvg
         3gutQxBC1inUl6HbWVRdS4sVbgOxWG8Y9VgljKaKgGYACMLzjvDreRdk+Bn1t+yRVGwG
         oyMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+DDlZOWObgE96mD8r18t+6GXnUAr+oljxdwIuzXVSqg=;
        b=GJUaTXV8iB5TP17A4s88m10tt0elPKkUtbC0drCEESubzjFUufekl/XkCxYqUiHzX1
         tyI+o/e1HIlNvTIuwHNr4soxhOfPURfPdXgQkZfo/GbR5Hj3/XuV2Ntz9GT56qufGYCj
         Krwrz6hXAwv9fMa4Td3lOr0c+eZjK5ebGMiTj38lpHD+1seNxicUXDLoZCP0N4XyL85w
         DoikR0Ftt6igu7S2DsmbnghdK52paUEJ9AZZhqr5oI8/uzunVzR8iJ6LlmNodDgvCyUQ
         ExZX83SNXVYx1IvdHPdwzNq2ndmnFPWkSWJ9EY8b4FGy+VZjv/WhQqYeWQ5fHLNo9TNo
         M8Nw==
X-Gm-Message-State: AOAM533vFpsGQ6hcYV0xxovF8HI2QzEDxApAIMr4Z+PG4T0Cfe0gPmdQ
        4t6BXaKWDuhg+vZDgV/pgSCvcsLDgrAkO9J8VSg=
X-Google-Smtp-Source: ABdhPJxPx+8WRMVns2AAnrwmh0645VTttb007AaTWkAN5PC2RgcQMMMKDAx17BT5LQYL/REx205g88HLG17mqnViAKY=
X-Received: by 2002:a5d:4a02:: with SMTP id m2mr21455622wrq.154.1642461268153;
 Mon, 17 Jan 2022 15:14:28 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com> <20220117115440.60296-27-miquel.raynal@bootlin.com>
In-Reply-To: <20220117115440.60296-27-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 17 Jan 2022 18:14:17 -0500
Message-ID: <CAB_54W4EPDiEBHOFka99P5XF2O5gNxFhcWgjMgwaK58AcYr+Xw@mail.gmail.com>
Subject: Re: [PATCH v3 26/41] net: mac802154: Add a warning in the hot path
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> We should never start a transmission after the queue has been stopped.
>
> But because it might work we don't kill the function here but rather
> warn loudly the user that something is wrong.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/tx.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index 18ee6fcfcd7f..de5ecda80472 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -112,6 +112,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
>  static netdev_tx_t
>  ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
>  {
> +       WARN_ON(mac802154_queue_is_stopped(local));
> +

we should do a WARN_ON_ONCE() in this hot function.

- Alex
