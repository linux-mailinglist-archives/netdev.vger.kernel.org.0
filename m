Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57ED45FA995
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJKBEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJKBEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:04:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D712E9ED
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665450286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tj7b8etUISJ6IPzDCcs2yYR97FlmsIH/Lt0/b1uu4to=;
        b=PIuW+B0bQnh9YzWjc6hR+LAJ8jZZYHjNp+sjxWcNag+jJVk8+76HnYiHYByB7fbrDBLw3A
        7Y4kq+tvzgUq5zS1epg7QRnM67gmZ2KG4LYY8bd6/sxqCLZEyQm8/uqCeyy59zsbGYRll9
        /P22+BTCTlodVywiTvvh7dlyU1YkNXw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-342-b1gJijHnMnCnZHhGQepxaA-1; Mon, 10 Oct 2022 21:04:44 -0400
X-MC-Unique: b1gJijHnMnCnZHhGQepxaA-1
Received: by mail-wr1-f72.google.com with SMTP id j8-20020adfa548000000b0022e2bf8f48fso3229569wrb.23
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:04:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tj7b8etUISJ6IPzDCcs2yYR97FlmsIH/Lt0/b1uu4to=;
        b=YVtVWazMQQVIWJBCmpAmd+12ua3Pc7TlOrodvT2iRBXYYGrkSkAQmBy1MHbHD1IKS6
         tGMR+Mf8AFdqo9DsL3IJH8Sa5fk3pw6oNkLHZCELaQc1DXIAH8MDbxlOBYiwkoZXxncV
         3ri3CUBqN+FH4M2yxHkkrNWWN5We66KElbK+r76YieYrJoNN38uBSp7KFQaOy4yzPAC6
         7jaJJEHQrTtgvL95TCzr+uWZbkjAodFeuvmi2cIljdhHe3/CGF9ArnKu2yLddM/IGsBA
         Of0WGY1IeE6DVps0NM3SMaIjkDbxpsRgQ7EUCvxb/1wkd/oywoLJJwj2mgzDoHaEmcy3
         ApaA==
X-Gm-Message-State: ACrzQf0O5HWJzz5ZN2idoSMNUrgSio5hxzHmlj+gjSMjjoXforSktGb0
        LGxTJR8LNQbjTiiQco00qqQLc0heXjMw1nEQ+zQq8MdeogXAAJRIbvOvwpR4UhqLtT6Enj/ZlDu
        6qH85GdqG7FAIaqGJ8/lJbpR20bcZ+V5U
X-Received: by 2002:a05:600c:4ec8:b0:3b4:bdc6:9b3d with SMTP id g8-20020a05600c4ec800b003b4bdc69b3dmr21402196wmq.181.1665450283745;
        Mon, 10 Oct 2022 18:04:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5STw1li0mEkR9xIraT72+kIZmH+WlHKmSzlTlZO3nW8klUsqqLyNxvb6RYdCLLgiC9MQ0t4JlKIQGbVYXiwhc=
X-Received: by 2002:a05:600c:4ec8:b0:3b4:bdc6:9b3d with SMTP id
 g8-20020a05600c4ec800b003b4bdc69b3dmr21402188wmq.181.1665450283584; Mon, 10
 Oct 2022 18:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221007085310.503366-1-miquel.raynal@bootlin.com> <20221007085310.503366-6-miquel.raynal@bootlin.com>
In-Reply-To: <20221007085310.503366-6-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 10 Oct 2022 21:04:32 -0400
Message-ID: <CAK-6q+iun+K8F6Mv3=WLL92iZnv-9oSnoRYtY4Zex2DZqS8ABQ@mail.gmail.com>
Subject: Re: [PATCH wpan/next v4 5/8] ieee802154: hwsim: Implement address filtering
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Oct 7, 2022 at 4:53 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> We have access to the address filters being theoretically applied, we
> also have access to the actual filtering level applied, so let's add a
> proper frame validation sequence in hwsim.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/mac802154_hwsim.c | 111 ++++++++++++++++++++++-
>  include/net/ieee802154_netdev.h          |   8 ++
>  2 files changed, 117 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> index 458be66b5195..84ee948f35bc 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -18,6 +18,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/device.h>
>  #include <linux/spinlock.h>
> +#include <net/ieee802154_netdev.h>
>  #include <net/mac802154.h>
>  #include <net/cfg802154.h>
>  #include <net/genetlink.h>
> @@ -139,6 +140,113 @@ static int hwsim_hw_addr_filt(struct ieee802154_hw *hw,
>         return 0;
>  }
>
> +static void hwsim_hw_receive(struct ieee802154_hw *hw, struct sk_buff *skb,
> +                            u8 lqi)
> +{
> +       struct ieee802154_hdr hdr;
> +       struct hwsim_phy *phy = hw->priv;
> +       struct hwsim_pib *pib;
> +
> +       rcu_read_lock();
> +       pib = rcu_dereference(phy->pib);
> +
> +       if (!pskb_may_pull(skb, 3)) {
> +               dev_dbg(hw->parent, "invalid frame\n");
> +               goto drop;
> +       }
> +
> +       memcpy(&hdr, skb->data, 3);
> +
> +       /* Level 4 filtering: Frame fields validity */
> +       if (hw->phy->filtering == IEEE802154_FILTERING_4_FRAME_FIELDS) {
> +
> +               /* a) Drop reserved frame types */
> +               switch (mac_cb(skb)->type) {
> +               case IEEE802154_FC_TYPE_BEACON:
> +               case IEEE802154_FC_TYPE_DATA:
> +               case IEEE802154_FC_TYPE_ACK:
> +               case IEEE802154_FC_TYPE_MAC_CMD:
> +                       break;
> +               default:
> +                       dev_dbg(hw->parent, "unrecognized frame type 0x%x\n",
> +                               mac_cb(skb)->type);
> +                       goto drop;
> +               }
> +
> +               /* b) Drop reserved frame versions */
> +               switch (hdr.fc.version) {
> +               case IEEE802154_2003_STD:
> +               case IEEE802154_2006_STD:
> +               case IEEE802154_STD:
> +                       break;
> +               default:
> +                       dev_dbg(hw->parent,
> +                               "unrecognized frame version 0x%x\n",
> +                               hdr.fc.version);
> +                       goto drop;
> +               }
> +
> +               /* c) PAN ID constraints */
> +               if ((mac_cb(skb)->dest.mode == IEEE802154_ADDR_LONG ||
> +                    mac_cb(skb)->dest.mode == IEEE802154_ADDR_SHORT) &&
> +                   mac_cb(skb)->dest.pan_id != pib->filt.pan_id &&
> +                   mac_cb(skb)->dest.pan_id != cpu_to_le16(IEEE802154_PANID_BROADCAST)) {
> +                       dev_dbg(hw->parent,
> +                               "unrecognized PAN ID %04x\n",
> +                               le16_to_cpu(mac_cb(skb)->dest.pan_id));
> +                       goto drop;
> +               }
> +
> +               /* d1) Short address constraints */
> +               if (mac_cb(skb)->dest.mode == IEEE802154_ADDR_SHORT &&
> +                   mac_cb(skb)->dest.short_addr != pib->filt.short_addr &&
> +                   mac_cb(skb)->dest.short_addr != cpu_to_le16(IEEE802154_ADDR_BROADCAST)) {
> +                       dev_dbg(hw->parent,
> +                               "unrecognized short address %04x\n",
> +                               le16_to_cpu(mac_cb(skb)->dest.short_addr));
> +                       goto drop;
> +               }
> +
> +               /* d2) Extended address constraints */
> +               if (mac_cb(skb)->dest.mode == IEEE802154_ADDR_LONG &&
> +                   mac_cb(skb)->dest.extended_addr != pib->filt.ieee_addr) {
> +                       dev_dbg(hw->parent,
> +                               "unrecognized long address 0x%016llx\n",
> +                               mac_cb(skb)->dest.extended_addr);
> +                       goto drop;
> +               }
> +
> +               /* d4) Specific PAN coordinator case (no parent) */
> +               if ((mac_cb(skb)->type == IEEE802154_FC_TYPE_DATA ||
> +                    mac_cb(skb)->type == IEEE802154_FC_TYPE_MAC_CMD) &&
> +                   mac_cb(skb)->dest.mode == IEEE802154_ADDR_NONE) {
> +                       dev_dbg(hw->parent,
> +                               "relaying is not supported\n");
> +                       goto drop;
> +               }
> +
> +               /* e) Beacon frames follow specific PAN ID rules */
> +               if (mac_cb(skb)->type == IEEE802154_FC_TYPE_BEACON &&
> +                   pib->filt.pan_id != cpu_to_le16(IEEE802154_PANID_BROADCAST) &&
> +                   mac_cb(skb)->dest.pan_id != pib->filt.pan_id) {
> +                       dev_dbg(hw->parent,
> +                               "invalid beacon PAN ID %04x\n",
> +                               le16_to_cpu(mac_cb(skb)->dest.pan_id));
> +                       goto drop;
> +               }
> +        }
> +
> +       rcu_read_unlock();
> +
> +       ieee802154_rx_irqsafe(hw, skb, lqi);

what is about if hwsim goes into promiscuous mode, then this software
filtering should be skipped?

- Alex

