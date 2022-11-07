Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2B061E884
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 03:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiKGCEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 21:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiKGCEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 21:04:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71668A451
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 18:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667786620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0QLbQq89RZsbcW4HtRPSWT3eiugKiSYunL7uN+NYfmg=;
        b=ObApDEST1o9tx6apbRHqNW3YJpJ0ir81mQmTGfBvhLZXz5bDGp8gV6OIs8HT5LTwAErqaY
        lc8LTHEkTG2NmOYuk2kLSuPHMwGBry6NsxW/ZE1MVD0wJoXAXvuhuTTeIc2DJGMsYTzDe4
        PAKka4sItEMeBHVfWXyJsal60C2LNHw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-21-pPkCWqlzOm-tmvfUALNjIg-1; Sun, 06 Nov 2022 21:03:32 -0500
X-MC-Unique: pPkCWqlzOm-tmvfUALNjIg-1
Received: by mail-ej1-f70.google.com with SMTP id gt15-20020a1709072d8f00b007aaac7973fbso5506970ejc.23
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 18:03:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0QLbQq89RZsbcW4HtRPSWT3eiugKiSYunL7uN+NYfmg=;
        b=lmBQ9mJrujWTAhE3txuB8599sOQo7GqWTyAEDL1fm55DLZ8Hyg6Vguf8zZxg475STW
         0nE1txoXSxFFbKBeH6EOGoZmSvdNfJZaF+097atC414iEEUuEkpSSfsck0v+O2kO8FNL
         3QHFLzxB6n3St3Y6+ymOBdwUUHKX5HjuqQC8PP5TiOSsTpK0wdY8fQxYFEQ2/q0bwjxU
         FLTS+dgeY8sYlLyAvxYCZ4GdMdN4iS2oDejWkp3rTeDBHG8zn09OkEeYjVER+07ZKgOU
         t6eFCTCK92+4UXazqTcMK8rQ9SvYXlMQOgvAmuxvJArvh6eNKihzR/CSPuQRoIprYiVN
         Ri5w==
X-Gm-Message-State: ACrzQf1Mgvj0PDtbDoHhwY50tjT84KcF75PxciOGDt7MpowRVr35rzSf
        MNfSuQZ990u/sRCdt50knb5J3FOrxUztBj4BHH3fm5OZVW2FJHcmLhwc6TR/VwQzi+aGmFwkcC7
        7ziBssL/ZU5nW0cPHlND8JLAx4I61yLAY
X-Received: by 2002:a05:6402:1690:b0:45f:d702:9919 with SMTP id a16-20020a056402169000b0045fd7029919mr47950686edv.127.1667786610825;
        Sun, 06 Nov 2022 18:03:30 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5TdUeNsU7yMej49kr5yPIIqJBk/H0MzzBNKzeWszqFfH1RUlAEiI9OtX2TfumJoDgIqkKK5GiLfC8+OA/7dvY=
X-Received: by 2002:a05:6402:1690:b0:45f:d702:9919 with SMTP id
 a16-20020a056402169000b0045fd7029919mr47950666edv.127.1667786610606; Sun, 06
 Nov 2022 18:03:30 -0800 (PST)
MIME-Version: 1.0
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com> <20221102151915.1007815-3-miquel.raynal@bootlin.com>
In-Reply-To: <20221102151915.1007815-3-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 6 Nov 2022 21:03:19 -0500
Message-ID: <CAK-6q+hh4Ny7zV-MbdjrGQq-Dtb783A8m3G5GMcXSdhSwicuiw@mail.gmail.com>
Subject: Re: [PATCH wpan-next 2/3] ieee802154: Handle coordinators discovery
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Nov 2, 2022 at 11:20 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Let's introduce helpers for giving the MAC layer a generic interface for
> advertising discovered coordinators/PANs upon beacon reception. This
> support requires the MAC layers to:
> - Allocate a coordinator/PAN descriptor and fill it.
> - Register this structure, giving the generic ieee802154 layer the
>   necessary information about the coordinator/PAN the beacon originates
>   from.
> - To flush all the allocated structures once the scan is done.
>
> The generic layer keeps a temporary list of the discovered coordinators
> to tell the user whether or not the beacon comes from a new device or
> not, so stateless userspace applications might not spam the user with
> identical information if not required.
>
> Co-developed-by: David Girault <david.girault@qorvo.com>
> Signed-off-by: David Girault <david.girault@qorvo.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h   |  12 ++++
>  net/ieee802154/Makefile   |   2 +-
>  net/ieee802154/core.c     |   2 +
>  net/ieee802154/nl802154.c |   2 +
>  net/ieee802154/pan.c      | 114 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 131 insertions(+), 1 deletion(-)
>  create mode 100644 net/ieee802154/pan.c
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 8d67d9ed438d..3057b4e0726c 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -401,6 +401,10 @@ struct wpan_dev {
>
>         /* fallback for acknowledgment bit setting */
>         bool ackreq;
> +
> +       /* Coordinators management during scans */
> +       spinlock_t coord_list_lock;
> +       struct list_head coord_list;
>  };
>
>  #define to_phy(_dev)   container_of(_dev, struct wpan_phy, dev)
> @@ -451,4 +455,12 @@ static inline const char *wpan_phy_name(struct wpan_phy *phy)
>
>  void ieee802154_configure_durations(struct wpan_phy *phy);
>
> +struct ieee802154_coord_desc *
> +cfg802154_alloc_coordinator(struct ieee802154_addr *coord, gfp_t gfp);
> +void cfg802154_free_coordinator_desc(struct ieee802154_coord_desc *desc);
> +void cfg802154_record_coordinator(struct wpan_phy *wpan_phy,
> +                                 struct wpan_dev *wpan_dev,
> +                                 struct ieee802154_coord_desc *desc);
> +void cfg802154_flush_known_coordinators(struct wpan_dev *wpan_dev);
> +
>  #endif /* __NET_CFG802154_H */
> diff --git a/net/ieee802154/Makefile b/net/ieee802154/Makefile
> index f05b7bdae2aa..6b7c66de730d 100644
> --- a/net/ieee802154/Makefile
> +++ b/net/ieee802154/Makefile
> @@ -4,7 +4,7 @@ obj-$(CONFIG_IEEE802154_SOCKET) += ieee802154_socket.o
>  obj-y += 6lowpan/
>
>  ieee802154-y := netlink.o nl-mac.o nl-phy.o nl_policy.o core.o \
> -                header_ops.o sysfs.o nl802154.o trace.o
> +                header_ops.o sysfs.o nl802154.o pan.o trace.o
>  ieee802154_socket-y := socket.o
>
>  CFLAGS_trace.o := -I$(src)
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index 57546e07e06a..091eb467fde6 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -276,6 +276,8 @@ static int cfg802154_netdev_notifier_call(struct notifier_block *nb,
>                 wpan_dev->identifier = ++rdev->wpan_dev_id;
>                 list_add_rcu(&wpan_dev->list, &rdev->wpan_dev_list);
>                 rdev->devlist_generation++;
> +               spin_lock_init(&wpan_dev->coord_list_lock);
> +               INIT_LIST_HEAD(&wpan_dev->coord_list);
>
>                 wpan_dev->netdev = dev;
>                 break;
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index f6fb7a228747..b6bd04fe160b 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -1368,6 +1368,8 @@ static int nl802154_advertise_coordinator(struct wpan_phy *wpan_phy,
>         struct sk_buff *msg;
>         int ret;
>
> +       lockdep_assert(&wpan_dev->coord_list_lock);
> +
>         msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
>         if (!msg)
>                 return -ENOMEM;
> diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
> new file mode 100644
> index 000000000000..0d4f752a090a
> --- /dev/null
> +++ b/net/ieee802154/pan.c
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * IEEE 802.15.4 PAN management
> + *
> + * Copyright (C) 2021 Qorvo US, Inc
> + * Authors:
> + *   - David Girault <david.girault@qorvo.com>
> + *   - Miquel Raynal <miquel.raynal@bootlin.com>
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +
> +#include <net/cfg802154.h>
> +#include <net/af_ieee802154.h>
> +
> +#include "ieee802154.h"
> +#include "../ieee802154/nl802154.h"
> +
> +struct ieee802154_coord_desc *
> +cfg802154_alloc_coordinator(struct ieee802154_addr *coord, gfp_t gfp)
> +{
> +       struct ieee802154_coord_desc *desc;
> +
> +       desc = kzalloc(sizeof(*desc), gfp);
> +       if (!desc)
> +               return ERR_PTR(-ENOMEM);
> +
> +       desc->addr = kzalloc(sizeof(*coord), gfp);
> +       if (!desc->addr) {
> +               kfree(desc);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       memcpy(desc->addr, coord, sizeof(*coord));
> +
> +       return desc;
> +}
> +EXPORT_SYMBOL_GPL(cfg802154_alloc_coordinator);
> +
> +void cfg802154_free_coordinator_desc(struct ieee802154_coord_desc *desc)
> +{
> +       kfree(desc->addr);
> +       kfree(desc);
> +}
> +EXPORT_SYMBOL_GPL(cfg802154_free_coordinator_desc);
> +
> +static bool
> +cfg802154_is_same_coordinator(struct ieee802154_coord_desc *a,
> +                             struct ieee802154_coord_desc *b)
> +{
> +       if (a->addr->pan_id != b->addr->pan_id)
> +               return false;
> +
> +       if (a->addr->mode != b->addr->mode)
> +               return false;
> +
> +       if (a->addr->mode == IEEE802154_ADDR_SHORT &&
> +           a->addr->short_addr == b->addr->short_addr)
> +               return true;
> +       else if (a->addr->mode == IEEE802154_ADDR_LONG &&
> +                a->addr->extended_addr == b->addr->extended_addr)
> +               return true;
> +
> +       return false;

semantic is a little bit different, can we use "ieee802154_addr_equal()" here?

- Alex

