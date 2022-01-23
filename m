Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5954975A0
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 22:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240158AbiAWVAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 16:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbiAWVAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 16:00:30 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03FAC06173B;
        Sun, 23 Jan 2022 13:00:29 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id i2so10019859wrb.12;
        Sun, 23 Jan 2022 13:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=olv/YTpIbYDjAawX1Ar0Xjxlxt5vrVPFp3+RWr5YO0s=;
        b=nu3TVLcVbqLx9auhi8cXln011DsCW9vvd+fSi29FlEq5ADQmaPLnLKwUzxIVOAg7xT
         3X+NaSMdtyv+Q2PWsttg9h3zOKwSGTa/sVpcde6WgKY47MPV7V2w9pTrHXJ8wi2s8O7Y
         eOlxOrNZcuaxuSNVqzQrB5MJ8y2Sdn2B1Rkl4w3aopxhjSRK4WurDFArvqXTPxdCeN01
         nbROohRt5GyR1XAlQhfe8xA4EPsJzhnGTD5W7dmhk0XZ7b8DSXQlyZd1F7+CLm/PB9Om
         WIHMoEWd8HQuvnM+x4+ZqsiZVZ8BcrHeslPULmLFrLKrPVnDmLePviJEI8eOeyriVl4q
         UyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=olv/YTpIbYDjAawX1Ar0Xjxlxt5vrVPFp3+RWr5YO0s=;
        b=1jBXDryzBOk0gnIu8UluXtao+mbuqYfszpKcL7yxePXK3SH9ypQZFN3hqxx1hVAcPk
         Wp01oPtmSXq0bqpmisbvL+ITGs2pg3N66dPKypG3q1x0jEvkRumrXX96fFh/54pMFCIv
         GbRpxKdITF58XKul+N1g7pfbuY1TePatSPedtw5QhIl+JcnwQuBXMKixtiaGdWia9lJO
         NKp6gRqxFZyQnaulJronO5bv7Nb82Lwz72S+cHV9oUtcOXyoHFG3ipzfqZkqCYE9IFXd
         4wswN0Xo8Aob9XtiekHz6Fom8TfBnsjkd9UCxxFvrdfkc5SXD/AkENXbq/FRkq8luGWZ
         54Eg==
X-Gm-Message-State: AOAM533g4563GAxdnWBeN7YHjASTw+3D8H9aW9/d50l2PXXxpz45UweC
        wp15nFfppmA2b1MU0PeXiTQ1Mnr6moTnl8rUuf4=
X-Google-Smtp-Source: ABdhPJzTXF6bvne/9YmKhlGKG9zXUDKg2Aj8maZUoePiqgmar1dI8BU5iJ5zvqhh41VLweA6MKokov3EnUWIHZY5Bls=
X-Received: by 2002:a05:6000:168f:: with SMTP id y15mr1703129wrd.205.1642971628523;
 Sun, 23 Jan 2022 13:00:28 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com> <20220120112115.448077-6-miquel.raynal@bootlin.com>
In-Reply-To: <20220120112115.448077-6-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 23 Jan 2022 16:00:17 -0500
Message-ID: <CAB_54W4GidkZiHTJzfE8ZX8_MatUPW92O7tyjuyJ=OxmHOFwbQ@mail.gmail.com>
Subject: Re: [wpan-next v2 5/9] net: ieee802154: ca8210: Stop leaking skb's
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Upon error the ieee802154_xmit_complete() helper is not called. Only
> ieee802154_wake_queue() is called manually. We then leak the skb
> structure.
>
> Free the skb structure upon error before returning.
>
> Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/ca8210.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index ece6ff6049f6..8e69441f1fff 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -1772,6 +1772,7 @@ static int ca8210_async_xmit_complete(
>                 );
>                 if (status != MAC_TRANSACTION_OVERFLOW) {
>                         ieee802154_wake_queue(priv->hw);
> +                       dev_kfree_skb_any(priv->tx_skb);
>                         return 0;

first free() then wake().

- Alex
