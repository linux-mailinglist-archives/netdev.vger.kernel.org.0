Return-Path: <netdev+bounces-7649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04545720FEC
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:28:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 425DC281A6A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 11:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189CCC15C;
	Sat,  3 Jun 2023 11:28:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD162F5F
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 11:28:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ED818D
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 04:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685791722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qc19+AkncC4nxIEryKXqxdYJw3SDpS86Yjih3aznMXw=;
	b=WxzvzEc6pHKJBccv6TPgxDSt24uuFhJmA68WPXq5f2YL8Qp51RJM6LkbbROK9Vkm/weqG7
	BC5ztiqyw5v/ilUJlAGqv+enAvboSxgVVJBNxj+/9tMeU7Cnw1byXXwCFFCtnv0YwUeS0g
	ro9EEw/PxeS7ozJMlXEmIwAc7iwumEc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-Ei5uMxU3Ow6-do_eiemBGA-1; Sat, 03 Jun 2023 07:28:41 -0400
X-MC-Unique: Ei5uMxU3Ow6-do_eiemBGA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-977c8170b52so26882166b.0
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 04:28:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685791717; x=1688383717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qc19+AkncC4nxIEryKXqxdYJw3SDpS86Yjih3aznMXw=;
        b=kG17pGG7/bwT+tZttmks+Tk0cWvSYb3Zj4UOcdHVccbdU4QhHsMdGPbG7RbD9MciuS
         u6y5MdrvM4vCbK2d3Rseh0nRh6spcwZikhZna52+GFLdtd8BQsaYDRNCws4/20BXmoG0
         7fJ0D3kxjA6ttwG60ii1YBZd2yRMxO0i12o9EyoIu5XEp9Rd8L8/fOo77CsTGzSTmKoq
         PsY1WoZpe229oKnfxbTdxtWXQDgerEZ1wNk5GTbjSQ8WQ+wwWLxeyjQBo+CLmPYoqk0B
         B2mKpa8C2wFl3nEiIZN1S4IOtjF8G4vjsX13KIMMpzpwB+YDbpMh6tJg2dfsR7vu5mLA
         EX6g==
X-Gm-Message-State: AC+VfDxP6Mkrl0IOVa33GRhpeL33EMZ0k/gmlZ4rqh1T4XItpR/ZiCeq
	pm4gd8X2l7AuaWF9M78+j4UW8cfPa2AO7/dLICxaqAbTwxnDTRVfXCu+RajXPbLaVAHDPoARZtV
	a+Q5YDtCFGzMVldZCp05PxH74ri3Z9Gpd
X-Received: by 2002:a17:907:6e89:b0:974:218d:c048 with SMTP id sh9-20020a1709076e8900b00974218dc048mr1489944ejc.26.1685791716868;
        Sat, 03 Jun 2023 04:28:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7SFTJhxQKr8PLRQA8DsZIzwnYvrIUM2AN53X2Npmf940OE0B10h0eAoV6UnTTboVoRcZ8rso3+go5zTWvl5xk=
X-Received: by 2002:a17:907:6e89:b0:974:218d:c048 with SMTP id
 sh9-20020a1709076e8900b00974218dc048mr1489927ejc.26.1685791716527; Sat, 03
 Jun 2023 04:28:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601154817.754519-1-miquel.raynal@bootlin.com> <20230601154817.754519-8-miquel.raynal@bootlin.com>
In-Reply-To: <20230601154817.754519-8-miquel.raynal@bootlin.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Sat, 3 Jun 2023 07:28:25 -0400
Message-ID: <CAK-6q+hWsLSy8vx_Hiwo0gRDYsW4Y7U=sQbAi5Na7BXQoOHWhw@mail.gmail.com>
Subject: Re: [PATCH wpan-next 07/11] mac802154: Handle association requests
 from peers
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, 
	linux-wpan@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, 
	netdev@vger.kernel.org, David Girault <david.girault@qorvo.com>, 
	Romuald Despres <romuald.despres@qorvo.com>, Frederic Blain <frederic.blain@qorvo.com>, 
	Nicolas Schodet <nico@ni.fr.eu.org>, Guilhem Imberton <guilhem.imberton@qorvo.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Thu, Jun 1, 2023 at 11:50=E2=80=AFAM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote:
>
> Coordinators may have to handle association requests from peers which
> want to join the PAN. The logic involves:
> - Acknowledging the request (done by hardware)
> - If requested, a random short address that is free on this PAN should
>   be chosen for the device.
> - Sending an association response with the short address allocated for
>   the peer and expecting it to be ack'ed.
>
> If anything fails during this procedure, the peer is considered not
> associated.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h         |   7 ++
>  include/net/ieee802154_netdev.h |   6 ++
>  net/ieee802154/core.c           |   7 ++
>  net/ieee802154/pan.c            |  27 ++++++
>  net/mac802154/ieee802154_i.h    |   2 +
>  net/mac802154/rx.c              |   8 ++
>  net/mac802154/scan.c            | 147 ++++++++++++++++++++++++++++++++
>  7 files changed, 204 insertions(+)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 01bc6c2da7b9..4404072365e7 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -582,4 +582,11 @@ struct ieee802154_pan_device *
>  cfg802154_device_is_child(struct wpan_dev *wpan_dev,
>                           struct ieee802154_addr *target);
>
> +/**
> + * cfg802154_get_free_short_addr - Get a free address among the known de=
vices
> + * @wpan_dev: the wpan device
> + * @return: a random short address expectedly unused on our PAN
> + */
> +__le16 cfg802154_get_free_short_addr(struct wpan_dev *wpan_dev);
> +
>  #endif /* __NET_CFG802154_H */
> diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_net=
dev.h
> index 16194356cfe7..4de858f9929e 100644
> --- a/include/net/ieee802154_netdev.h
> +++ b/include/net/ieee802154_netdev.h
> @@ -211,6 +211,12 @@ struct ieee802154_association_req_frame {
>         struct ieee802154_assoc_req_pl assoc_req_pl;
>  };
>
> +struct ieee802154_association_resp_frame {
> +       struct ieee802154_hdr mhr;
> +       struct ieee802154_mac_cmd_pl mac_pl;
> +       struct ieee802154_assoc_resp_pl assoc_resp_pl;
> +};
> +
>  struct ieee802154_disassociation_notif_frame {
>         struct ieee802154_hdr mhr;
>         struct ieee802154_mac_cmd_pl mac_pl;
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index 8bf01bb7e858..39674db64336 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -200,11 +200,18 @@ EXPORT_SYMBOL(wpan_phy_free);
>
>  static void cfg802154_free_peer_structures(struct wpan_dev *wpan_dev)
>  {
> +       struct ieee802154_pan_device *child, *tmp;
> +
>         mutex_lock(&wpan_dev->association_lock);
>
>         if (wpan_dev->parent)
>                 kfree(wpan_dev->parent);
>
> +       list_for_each_entry_safe(child, tmp, &wpan_dev->children, node) {
> +               list_del(&child->node);
> +               kfree(child);
> +       }
> +
>         wpan_dev->association_generation++;
>
>         mutex_unlock(&wpan_dev->association_lock);
> diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
> index 477e8dad0cf0..7756906c201d 100644
> --- a/net/ieee802154/pan.c
> +++ b/net/ieee802154/pan.c
> @@ -66,3 +66,30 @@ cfg802154_device_is_child(struct wpan_dev *wpan_dev,
>         return NULL;
>  }
>  EXPORT_SYMBOL_GPL(cfg802154_device_is_child);
> +
> +__le16 cfg802154_get_free_short_addr(struct wpan_dev *wpan_dev)
> +{
> +       struct ieee802154_pan_device *child;
> +       __le16 addr;
> +
> +       lockdep_assert_held(&wpan_dev->association_lock);
> +
> +       do {
> +               get_random_bytes(&addr, 2);

This is combined with the max associations setting? I am not sure if
this is the best way to get free values from a u16 value where we have
some data structure of "given" addresses to a node. I recently was
looking into idr/xarray data structure... maybe we can use something
from there.

- Alex


