Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B895B48CE80
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiALWoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbiALWoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:44:15 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696CCC06173F;
        Wed, 12 Jan 2022 14:44:15 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id d187-20020a1c1dc4000000b003474b4b7ebcso2514733wmd.5;
        Wed, 12 Jan 2022 14:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vlFNYMn2c5VUx6J0DZH2+On8edmyn45r+tZ7Y1m0GSc=;
        b=Txb9MfkJ7HqgoT87pqU+IKal1/FR48fhREtpOhOx3ZMBMZXyHc/LUtw7HYNu3WreEi
         X7rRDbUgR9Dtp7KkLi+j0f2uH0W7qRt9IA8pzfw2/PZ6HXHrF6IDkXlbadZehprnx/nG
         XBHMZq3M/YNNqTAGv89gsNAPrHzoUNqd15DKNa21rULDVJR9dP6TfA0BxYZwF/8p0J8W
         SrLhLFFw2qTsMDf4vFC2MEcZrMR10WQoQFlH7mnhh+vIvb7wY3w/SOwQA5oUTkbqzQeO
         UCn2hsk5W6TLKUnUpXPUL12VpAgHntCotLBb5/1IBZwjfKqmGs7efGAcsUKzTaJ4Qlen
         4oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vlFNYMn2c5VUx6J0DZH2+On8edmyn45r+tZ7Y1m0GSc=;
        b=5ikaBY/l4jBHz6HEbBeIbIdpfVLf4jrZusUGwN4B01a/Dq5Jmpc0TBuw/3bJcmo67w
         nKV1YdopvDGXWptoTKT821BV2L0a1gW4Ecla3UitcPlNeLt/sUaUMxmdNPDZCzpaJDpf
         c49D10nDZRez8T6YMaUGgJ+o6BBrl5GqAp3kxB9Wku5ferQ3kOQLnwto6kJ7zBDipRIB
         Z/0xgBkthOAMhdmDoqZnBKin1Bfr8XbOqdRb9lA6Gm0l9CGPmwfYS+2FuryAbDujZi1C
         dPP6EEhpLH0GKp7dEvXUBWlrDW4NCFkAeqRG2D/Enobpvn44VWOhiGPRyP0vq83EgyWB
         lN9w==
X-Gm-Message-State: AOAM53301OiGDqVgpIpxbzG21zKoSRIWK+3Dxb9udhFMxx7sab6Go8gs
        W7nXYLMmab4AbUjV1BgrdECGaNB9JSpTPao123Y=
X-Google-Smtp-Source: ABdhPJw7Yo9J1Kfc7THPzH8ETOo5nHuyME2tOACdsnvJBnOQloE0Zk5F0VQ01Q85MufaI+LjLZ4M1c+vvRZervsge1I=
X-Received: by 2002:a7b:c142:: with SMTP id z2mr1313372wmi.167.1642027454060;
 Wed, 12 Jan 2022 14:44:14 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com> <20220112173312.764660-19-miquel.raynal@bootlin.com>
In-Reply-To: <20220112173312.764660-19-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 12 Jan 2022 17:44:02 -0500
Message-ID: <CAB_54W4PL1ty5XsqRoEKwsy-h8KL9gSGMK6N=HiWJDp6NHsb0A@mail.gmail.com>
Subject: Re: [wpan-next v2 18/27] net: mac802154: Handle scan requests
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
...
> +       return 0;
> +}
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index c829e4a75325..40656728c624 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -54,6 +54,9 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
>         struct net_device *dev = skb->dev;
>         int ret;
>
> +       if (unlikely(mac802154_scan_is_ongoing(local)))
> +               return NETDEV_TX_BUSY;
> +

Please look into the functions "ieee802154_wake_queue()" and
"ieee802154_stop_queue()" which prevent this function from being
called. Call stop before starting scanning and wake after scanning is
done or stopped.

Also there exists a race which exists in your way and also the one
mentioned above. There can still be some transmissions going on... We
need to wait until "all possible" tx completions are done... to be
sure there are really no transmissions going on. However we need to be
sure that a wake cannot be done if a tx completion is done, we need to
avoid it when the scan operation is ongoing as a workaround for this
race.

This race exists and should be fixed in future work?

- Alex
