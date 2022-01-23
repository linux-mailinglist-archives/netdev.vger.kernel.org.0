Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9410B497599
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 21:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240136AbiAWU4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 15:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237715AbiAWU4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 15:56:35 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0864EC06173B;
        Sun, 23 Jan 2022 12:56:35 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id e8so8243898wrc.0;
        Sun, 23 Jan 2022 12:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oLUpvTubRre2GuJW4nxw/st0JyHO82V6iM7x14BWgmk=;
        b=i97Fp2gztbbsC2VywPxhLECYixczBqRDn9gWDofEeHJm1I6jtL6wuBa0BzkQAS1YeF
         5lktoXq02uRe+bu9PYvu128dd8R8ICdwhNcg24M2go+L21XHBKf0OQsAXk3cb82n/5mJ
         0PjHDZUpOvdp9u/K46HSgatHXasucDJTzqGOD09AcRD89wgFRFiZ5sQC2V8kmpH1BRka
         o4KjJ40GuQnmx1XxEdeI2g8KlyHCC+4/eXOWHou6KTrK8XIBVVO0J9ADHgi8bgw5DONU
         ikngxb5id1mPH9KxsnHYWH8+epJw2HBONWKJozBrMrzTX40tGAQb37DH6Eg/lrd7JgCL
         fr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oLUpvTubRre2GuJW4nxw/st0JyHO82V6iM7x14BWgmk=;
        b=xxww5IQszJoqyxdMOACrWgdC4r+CfO/mZx8Of7gMLdic42GZ5nTu6tn8HhMku4hnTT
         URCPYEZ60P7D7Bh8VuodQiY9K30Jf3ATwn93itCz2NgmWgtUdohOAs4MlD6G4Hqr5s4O
         XTWrzsP5FGFoiX8RX85uS1nXA9R3VQXFEDWYOlVXLK448pACUlkij8I69qj3vxa3GmLr
         TaBTTfOi8JCpkO+C2UJqAuMFCXivYlnNgiI+NXm2AQQCD5ocj4Gx+LOo7vlpKbzTKHsv
         dommv4UHfQSOtxeyQOVW2+Vi9ixoCgrDmyKs2J9cgj4wkiPKN0NBAE2U66puI99R2ycX
         Cs4Q==
X-Gm-Message-State: AOAM5334Dpv3jDXRcVjDmX9tCCYCw4PqYakTbqSEsgVRN/qEf6b6B5sK
        n9hAOc3hPbwfUW3NTgtoRUTKV5VlYFQ7psM/IwWwQSpN
X-Google-Smtp-Source: ABdhPJxFg2MOwMwUmMVEWRR1p9aUu1VwyLGekZGfJ5L+EoFDAa/GigU4HkH0QAHGkJcyCxArT3aTDuu2t2uI7Eb68qE=
X-Received: by 2002:a05:6000:168f:: with SMTP id y15mr1695564wrd.205.1642971393578;
 Sun, 23 Jan 2022 12:56:33 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com> <20220120112115.448077-9-miquel.raynal@bootlin.com>
In-Reply-To: <20220120112115.448077-9-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 23 Jan 2022 15:56:22 -0500
Message-ID: <CAB_54W6dCoEinhdq-HAQj0CQ9_wf-xK9ESOfvB6K4JMwHo7Vaw@mail.gmail.com>
Subject: Re: [wpan-next v2 8/9] net: mac802154: Explain the use of ieee802154_wake/stop_queue()
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
> It is not straightforward to the newcomer that a single skb can be sent
> at a time and that the internal process is to stop the queue when
> processing a frame before re-enabling it. Make this clear by documenting
> the ieee802154_wake/stop_queue() helpers.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/mac802154.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> index d524ffb9eb25..94b2e3008e77 100644
> --- a/include/net/mac802154.h
> +++ b/include/net/mac802154.h
> @@ -464,6 +464,12 @@ void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb,
>   * ieee802154_wake_queue - wake ieee802154 queue
>   * @hw: pointer as obtained from ieee802154_alloc_hw().
>   *
> + * Tranceivers have either one transmit framebuffer or one framebuffer for both
> + * transmitting and receiving. Hence, the core only handles one frame at a time

this is not a fundamental physical law, they might exist but not supported yet.

> + * for each phy, which means we had to stop the queue to avoid new skb to come
> + * during the transmission. The queue then needs to be woken up after the
> + * operation.
> + *
>   * Drivers should use this function instead of netif_wake_queue.

It's a must.

>   */
>  void ieee802154_wake_queue(struct ieee802154_hw *hw);
> @@ -472,6 +478,12 @@ void ieee802154_wake_queue(struct ieee802154_hw *hw);
>   * ieee802154_stop_queue - stop ieee802154 queue
>   * @hw: pointer as obtained from ieee802154_alloc_hw().
>   *
> + * Tranceivers have either one transmit framebuffer or one framebuffer for both
> + * transmitting and receiving. Hence, the core only handles one frame at a time
> + * for each phy, which means we need to tell upper layers to stop giving us new
> + * skbs while we are busy with the transmitted one. The queue must then be
> + * stopped before transmitting.
> + *
>   * Drivers should use this function instead of netif_stop_queue.
>   */
>  void ieee802154_stop_queue(struct ieee802154_hw *hw);

Same for stop, stop has something additional here... it is never used
by any driver because we do that on mac802154 layer. Simply, they
don't use this function.

Where is the fix here?

- Alex
