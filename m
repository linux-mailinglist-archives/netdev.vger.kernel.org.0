Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64C848CF07
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 00:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiALXQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 18:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbiALXQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 18:16:23 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA75C06173F;
        Wed, 12 Jan 2022 15:16:23 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p18so2652098wmg.4;
        Wed, 12 Jan 2022 15:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dv6pc+JoSrqBX2AZ4Y5u186caW5FzV8GVKLRws4BTnc=;
        b=bUGfuIBwiXJlzr9YRA4ZdKS52M5LQrNX8k48lodePS4pqH0gEtL7y3VvEeulS6Gfru
         oRSI/ukHI+GcqDzf+s2YafDK7XahCQeAbId1AnFL6D30km33y0d0wG3XqKSGeH9qdj8k
         TjWEpU16LYv/zAaxmlr14XbJOVfGmEcBXcJPW0Z70yFfjYU0pQX9VME3ltcvqJjtenpV
         IwZNumxA57CcmJRIk41uwqbESkFANMcMukfi8z2iuXyfDAhxFhnJUyzuV174swvLuRXt
         0WPGXBnEm5jAV0vc+kZqfju+iEX49sVOB8r+wJ02TRi/v2wnMaoMancE9IY13dr549KK
         pRJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dv6pc+JoSrqBX2AZ4Y5u186caW5FzV8GVKLRws4BTnc=;
        b=ER60mzbFs86RuNOC5e+jPjfFTqtYKEKRpWEU07ZxBdLf0CQTyZBlBllARPzcHq6OJn
         ns0X1Dz2gBPNF3xN+DgvxcpCYiVgPb9t2Pp+fO6DerV0/d/I7il/kiz0eSPIsCihf88g
         xZzha1gIhSvB2D+HE3jd6jtaW7o47rbIb7DmSap+ZXVCVWSjHADwVtAeYfWpmS7Wa4xF
         0SYRRd2gS9gV5iudZryN+xwHPuR6kDE/eZn/N/NRJfci079O36AFREqjYiJ/s9KuUpa5
         3wQjtURakxFxb7xLeOWxkD47KvceriELTVTlM/8RWvn+5tH/hfuDQ0+KzLWK0pefLzsG
         JabQ==
X-Gm-Message-State: AOAM530bfe4DVWA31Z+pNKWnAeeb5GCo+of7dc55rBpxBqvqOgNZ8HDt
        KlvKiCgZaXjQwFVB7MPeh+1tupah/KYj2lNolnM=
X-Google-Smtp-Source: ABdhPJy/BYlvZB1v7EUFO2Aed1sLC550uY72jRNFYq4xRDcadJ52FiwpUvUQvBldtfJz5UjK4/xq75HKWvSKxjuwmW4=
X-Received: by 2002:a1c:545b:: with SMTP id p27mr8651528wmi.178.1642029382252;
 Wed, 12 Jan 2022 15:16:22 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com> <20220112173312.764660-24-miquel.raynal@bootlin.com>
In-Reply-To: <20220112173312.764660-24-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 12 Jan 2022 18:16:11 -0500
Message-ID: <CAB_54W6bJ5oV1pTX03-xWaFohdyxrjy2WSa2kxp3rBzLqSo=UA@mail.gmail.com>
Subject: Re: [wpan-next v2 23/27] net: mac802154: Add support for active scans
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

On Wed, 12 Jan 2022 at 12:34, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
...
> +static int mac802154_scan_send_beacon_req_locked(struct ieee802154_local *local)
> +{
> +       struct sk_buff *skb;
> +       int ret;
> +
> +       lockdep_assert_held(&local->scan_lock);
> +
> +       skb = alloc_skb(IEEE802154_BEACON_REQ_SKB_SZ, GFP_KERNEL);
> +       if (!skb)
> +               return -ENOBUFS;
> +
> +       ret = ieee802154_beacon_req_push(skb, &local->beacon_req);
> +       if (ret) {
> +               kfree_skb(skb);
> +               return ret;
> +       }
> +
> +       return drv_xmit_async(local, skb);

I think you need to implement a sync transmit handling here. And what
I mean is not using dryv_xmit_sync() (It is a long story and should
not be used, it's just that the driver is allowed to call bus api
functions which can sleep). We don't have such a function yet (but I
think it can be implemented), you should wait until the transmission
is done. If we don't wait we fill framebuffers on the hardware while
the hardware is transmitting the framebuffer which is... bad.

Please implement it so that we have a synchronous api above the
asynchronous transmit api.

- Alex
