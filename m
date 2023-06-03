Return-Path: <netdev+bounces-7650-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E594C720FEE
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 198501C20D68
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 11:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6CFDC2C0;
	Sat,  3 Jun 2023 11:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B328832
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 11:30:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A4FDA
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 04:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685791819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jA+L302X21aYxkqH9/lHcodK1vnGG9Vy5qTtHkhY9oo=;
	b=Fke1bX9q+XdvEAfnV4F+6Ive3lu/YNy2Lk+tXo/ZcnO2sF8IeSDdZdV0eaqzdq4nJbirEk
	Y9D7HAi7UXOlfbvBuJ6dFhU8OQWTeanfVczYR5IAzpVkaKhyv7XAalo/eYjB86MXwjXAh7
	npiHwC8zERzcc+wRX4iU7/q31NHu2AE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-9BhQ3l2fNRaRT4vOkVso0g-1; Sat, 03 Jun 2023 07:30:18 -0400
X-MC-Unique: 9BhQ3l2fNRaRT4vOkVso0g-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-506a7b4f141so2008907a12.2
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 04:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685791817; x=1688383817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jA+L302X21aYxkqH9/lHcodK1vnGG9Vy5qTtHkhY9oo=;
        b=VMDLohtELXAvDO1Xq/JPke178mLjcIckxIAQJhQ1CeH/vxdIkkFPEAdYkQg2M71zwT
         wRT7Bdm9pB+DQ7oXEE/+VSAbyOWUgGfzRruhwUSi1RG8AodJF7PxIyTj274DBivYfAIG
         D6yQCBgkBRFjA3DDkjDzz28FO+pACi4/gdK+LgITg72H83AHKMHUg4XbhfE0pJnxsGxL
         xHZTSzMEcfFCeDR0r9gGlAeFUUIhq9kyYFUh1yHZyoHg0j+5X/eown2/uHk07yP7MRGe
         4bToygd3QOb6tohrExkUCJGZh6IH0ZVS4AzILeAszJUVH3j5IfpFD0dXhGF+irJ1EBeF
         acVg==
X-Gm-Message-State: AC+VfDxJSLGWre/YI2YR1M2yq2qDeCw/ybHb6fUIr0ZaqW72njqX973h
	u9dhNtLSCQ6Gd67FNmqmSQ1z6GDDeLPUVc6p9m+C5UzyaGNypF1DfTidRCbgENR8jWfQsVpfS59
	9LES0y+EtBIWINr25vZH/bh0/eJPhFsNS
X-Received: by 2002:a17:907:7fa9:b0:961:800b:3f1e with SMTP id qk41-20020a1709077fa900b00961800b3f1emr1632139ejc.73.1685791817312;
        Sat, 03 Jun 2023 04:30:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4LKGHHL+GwPFvOn9syVGUBc4afwXAkSmSvesI9G5o5xS3cD7y8xUuPxBXA3YH29jFLQ6Lzy8aCc3Va6wrFP1A=
X-Received: by 2002:a17:907:7fa9:b0:961:800b:3f1e with SMTP id
 qk41-20020a1709077fa900b00961800b3f1emr1632115ejc.73.1685791817015; Sat, 03
 Jun 2023 04:30:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601154817.754519-1-miquel.raynal@bootlin.com> <20230601154817.754519-7-miquel.raynal@bootlin.com>
In-Reply-To: <20230601154817.754519-7-miquel.raynal@bootlin.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Sat, 3 Jun 2023 07:30:05 -0400
Message-ID: <CAK-6q+hWR9cLt2+nbGY9KbtwLSJkN+NF+Q651aPDLCaO1mk1=Q@mail.gmail.com>
Subject: Re: [PATCH wpan-next 06/11] mac802154: Handle disassociations
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Thu, Jun 1, 2023 at 11:50=E2=80=AFAM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote:
>
> Devices may decide to disassociate from their coordinator for different
> reasons (device turning off, coordinator signal strength too low, etc),
> the MAC layer just has to send a disassociation notification.
>
> If the ack of the disassociation notification is not received, the
> device may consider itself disassociated anyway.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/ieee802154/pan.c         |   2 +
>  net/mac802154/cfg.c          | 102 +++++++++++++++++++++++++++++++++++
>  net/mac802154/ieee802154_i.h |   4 ++
>  net/mac802154/scan.c         |  60 +++++++++++++++++++++
>  4 files changed, 168 insertions(+)
>
> diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
> index e2a12a42ba2b..477e8dad0cf0 100644
> --- a/net/ieee802154/pan.c
> +++ b/net/ieee802154/pan.c
> @@ -49,6 +49,7 @@ bool cfg802154_device_is_parent(struct wpan_dev *wpan_d=
ev,
>
>         return false;
>  }
> +EXPORT_SYMBOL_GPL(cfg802154_device_is_parent);
>
>  struct ieee802154_pan_device *
>  cfg802154_device_is_child(struct wpan_dev *wpan_dev,
> @@ -64,3 +65,4 @@ cfg802154_device_is_child(struct wpan_dev *wpan_dev,
>
>         return NULL;
>  }
> +EXPORT_SYMBOL_GPL(cfg802154_device_is_child);
> diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> index 89112d2bcee7..c27c05e825ff 100644
> --- a/net/mac802154/cfg.c
> +++ b/net/mac802154/cfg.c
> @@ -386,6 +386,107 @@ static int mac802154_associate(struct wpan_phy *wpa=
n_phy,
>         return ret;
>  }
>
> +static int mac802154_disassociate_from_parent(struct wpan_phy *wpan_phy,
> +                                             struct wpan_dev *wpan_dev)
> +{
> +       struct ieee802154_local *local =3D wpan_phy_priv(wpan_phy);
> +       struct ieee802154_pan_device *child, *tmp;
> +       struct ieee802154_sub_if_data *sdata;
> +       u64 eaddr;
> +       int ret;
> +
> +       sdata =3D IEEE802154_WPAN_DEV_TO_SUB_IF(wpan_dev);
> +
> +       /* Start by disassociating all the children and preventing new on=
es to
> +        * attempt associations.
> +        */
> +       list_for_each_entry_safe(child, tmp, &wpan_dev->children, node) {
> +               ret =3D mac802154_send_disassociation_notif(sdata, child,
> +                                                         IEEE802154_COOR=
D_WISHES_DEVICE_TO_LEAVE);
> +               if (ret) {
> +                       eaddr =3D swab64((__force u64)child->extended_add=
r);

Does this pass sparse? I think this needs to be le64_to_cpu()?

- Alex


