Return-Path: <netdev+bounces-7646-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4360D720F1C
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 12:10:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 404291C20E37
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 10:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF461C141;
	Sat,  3 Jun 2023 10:10:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE773257B
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 10:10:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3CF1A6
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 03:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685786998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QgQyDn0kuTs8pW8r/1D0kR3Mu4O4BRdFmzf7RMNRe08=;
	b=HTWowWVxTG7Wol4Nty+0l9TDrXkhRs12sgtlQ4QLn0B12gt3pNk9v7e1MGWE71EGBkUxQO
	8BFGJH8+95urwoRazHjvGdjMk0s/ntHTd2icGi3fsCfAkN1wAXXqw12OVUQ3/1pfNpSDd1
	zOLJ34dVi6lYwOlYKxPLds70umI2L/4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-hgWWhIzzMnSozfpisU5bUw-1; Sat, 03 Jun 2023 06:09:49 -0400
X-MC-Unique: hgWWhIzzMnSozfpisU5bUw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9744659b7b5so227839766b.3
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 03:09:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685786988; x=1688378988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QgQyDn0kuTs8pW8r/1D0kR3Mu4O4BRdFmzf7RMNRe08=;
        b=D+rZCAKETrbc4Is/Qr4VccYG3UYHgcFVW/dHOMbJ5RD8YX/uC4KMk0yJ8zUyDBlR/i
         H9XSLpsuTqlWQbFqtaFlu97EFifWOg5CJPaPhk0V72tyuGSRZcWVAn1TtbpCH2pCIl/R
         ZikHDlppl6BjplXoZsiQ4R7xVZ0SAwl6LOIFF1fYpsPXYF29C/ls3K7QwAhB1xrOHPbv
         wew26l229iMfV7XZA/u6dBQekyvM6GgmGGTGXyPwdY0hBasEAuVRUOfrso3Ps9qHdh3e
         aZUCMOcmiLOoNja2fSNP/yo3DbxhLzFEWJghMtMbAQyuYmc3MSTtehOuAGg6Q/B+c4Ae
         xmEw==
X-Gm-Message-State: AC+VfDyxG3rdbrr2ToPFJa7LNGUaZ39Vd9fG/PilR2M3AboAxDVdlUM/
	ROSV5LZWrBXp1kh/npGRl1T+OqmMCLUfIoHvqZ+3lZ8SU/HETdV9uv+IBZCvVX+7KhuCYIuHuCd
	v+hiJNj/9E/z22lGDeQH7Qvddwluul7PA
X-Received: by 2002:a17:907:a0a:b0:969:bac4:8e22 with SMTP id bb10-20020a1709070a0a00b00969bac48e22mr1156159ejc.26.1685786988399;
        Sat, 03 Jun 2023 03:09:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4m8lDsi7hvk5I3WNFGujTP7YkoZSj8xdvtVZhnt60axhRAdhbGUZIuyFIg2mocQK+NMwJWrhRWRtK3r8q1x4U=
X-Received: by 2002:a17:907:a0a:b0:969:bac4:8e22 with SMTP id
 bb10-20020a1709070a0a00b00969bac48e22mr1156137ejc.26.1685786988102; Sat, 03
 Jun 2023 03:09:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601154817.754519-1-miquel.raynal@bootlin.com> <20230601154817.754519-5-miquel.raynal@bootlin.com>
In-Reply-To: <20230601154817.754519-5-miquel.raynal@bootlin.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Sat, 3 Jun 2023 06:09:36 -0400
Message-ID: <CAK-6q+ibbYBbvbGK9ehJJoaJAw4hubh6Ff=q2P4mq+Z07ZgR0A@mail.gmail.com>
Subject: Re: [PATCH wpan-next 04/11] mac802154: Handle associating
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
> Joining a PAN officially goes by associating with a coordinator. This
> coordinator may have been discovered thanks to the beacons it sent in
> the past. Add support to the MAC layer for these associations, which
> require:
> - Sending an association request
> - Receiving an association response
>
> The association response contains the association status, eventually a
> reason if the association was unsuccessful, and finally a short address
> that we should use for intra-PAN communication from now on, if we
> required one (which is the default, and not yet configurable).
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/linux/ieee802154.h      |   1 +
>  include/net/cfg802154.h         |   1 +
>  include/net/ieee802154_netdev.h |   5 ++
>  net/ieee802154/core.c           |  14 ++++
>  net/mac802154/cfg.c             |  72 ++++++++++++++++++
>  net/mac802154/ieee802154_i.h    |  19 +++++
>  net/mac802154/main.c            |   2 +
>  net/mac802154/rx.c              |   9 +++
>  net/mac802154/scan.c            | 127 ++++++++++++++++++++++++++++++++
>  9 files changed, 250 insertions(+)
>
> diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
> index 140f61ec0f5f..c72bd76cac1b 100644
> --- a/include/linux/ieee802154.h
> +++ b/include/linux/ieee802154.h
> @@ -37,6 +37,7 @@
>                                          IEEE802154_FCS_LEN)
>
>  #define IEEE802154_PAN_ID_BROADCAST    0xffff
> +#define IEEE802154_ADDR_LONG_BROADCAST 0xffffffffffffffffULL
>  #define IEEE802154_ADDR_SHORT_BROADCAST        0xffff
>  #define IEEE802154_ADDR_SHORT_UNSPEC   0xfffe
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 3b9d65455b9a..dd0964d351cd 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -502,6 +502,7 @@ struct wpan_dev {
>         struct mutex association_lock;
>         struct ieee802154_pan_device *parent;
>         struct list_head children;
> +       unsigned int association_generation;
>  };
>
>  #define to_phy(_dev)   container_of(_dev, struct wpan_phy, dev)
> diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_net=
dev.h
> index ca8c827d0d7f..e26ffd079556 100644
> --- a/include/net/ieee802154_netdev.h
> +++ b/include/net/ieee802154_netdev.h
> @@ -149,6 +149,11 @@ struct ieee802154_assoc_req_pl {
>  #endif
>  } __packed;
>
> +struct ieee802154_assoc_resp_pl {
> +       __le16 short_addr;
> +       u8 status;
> +} __packed;
> +
>  enum ieee802154_frame_version {
>         IEEE802154_2003_STD,
>         IEEE802154_2006_STD,
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index cd69bdbfd59f..8bf01bb7e858 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -198,6 +198,18 @@ void wpan_phy_free(struct wpan_phy *phy)
>  }
>  EXPORT_SYMBOL(wpan_phy_free);
>
> +static void cfg802154_free_peer_structures(struct wpan_dev *wpan_dev)
> +{
> +       mutex_lock(&wpan_dev->association_lock);
> +
> +       if (wpan_dev->parent)
> +               kfree(wpan_dev->parent);
> +
> +       wpan_dev->association_generation++;
> +
> +       mutex_unlock(&wpan_dev->association_lock);
> +}
> +
>  int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
>                            struct net *net)
>  {
> @@ -293,6 +305,8 @@ static int cfg802154_netdev_notifier_call(struct noti=
fier_block *nb,
>                 rdev->opencount++;
>                 break;
>         case NETDEV_UNREGISTER:
> +               cfg802154_free_peer_structures(wpan_dev);
> +

I think the comment below is not relevant here, but I have also no
idea if this is still the case.

>                 /* It is possible to get NETDEV_UNREGISTER
>                  * multiple times. To detect that, check
>                  * that the interface is still on the list
> diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> index 5c3cb019f751..89112d2bcee7 100644
> --- a/net/mac802154/cfg.c
> +++ b/net/mac802154/cfg.c
> @@ -315,6 +315,77 @@ static int mac802154_stop_beacons(struct wpan_phy *w=
pan_phy,
>         return mac802154_stop_beacons_locked(local, sdata);
>  }
>
> +static int mac802154_associate(struct wpan_phy *wpan_phy,
> +                              struct wpan_dev *wpan_dev,
> +                              struct ieee802154_addr *coord)
> +{
> +       struct ieee802154_local *local =3D wpan_phy_priv(wpan_phy);
> +       u64 ceaddr =3D swab64((__force u64)coord->extended_addr);
> +       struct ieee802154_sub_if_data *sdata;
> +       struct ieee802154_pan_device *parent;
> +       __le16 short_addr;
> +       int ret;
> +
> +       ASSERT_RTNL();
> +
> +       sdata =3D IEEE802154_WPAN_DEV_TO_SUB_IF(wpan_dev);
> +
> +       if (wpan_dev->parent) {
> +               dev_err(&sdata->dev->dev,
> +                       "Device %8phC is already associated\n", &ceaddr);
> +               return -EPERM;
> +       }
> +
> +       parent =3D kzalloc(sizeof(*parent), GFP_KERNEL);
> +       if (!parent)
> +               return -ENOMEM;
> +
> +       parent->pan_id =3D coord->pan_id;
> +       parent->mode =3D coord->mode;
> +       if (parent->mode =3D=3D IEEE802154_SHORT_ADDRESSING) {
> +               parent->short_addr =3D coord->short_addr;
> +               parent->extended_addr =3D cpu_to_le64(IEEE802154_ADDR_LON=
G_BROADCAST);

There is no IEEE802154_ADDR_LONG_BROADCAST (extended address) address.
The broadcast address is always a short address 0xffff. (Talkin about
destination addresses).

Just to clarify we can have here two different types/length of mac
addresses being used, whereas the extended address is always present.
We have the monitor interface set to an invalid extended address
0x0...0 (talking about source address) which is a reserved EUI64 (what
long/extended address is) address, 0xffff...ffff is also being
reserved. Monitors get their address from the socket interface.

If there is a parent, an extended address is always present and known.
A short address can be set, but is not required as a node to have.
Sure if a node has a short address, you want to use a short address
because it saves payload.
Also remember when an address is unique in the network, an extended
address (LONG) is always being unique, a short address is unique in
combination of pan id + short address.

If you save some neighbors you want to store the extended and if
present panid/shortaddress.

Or I do not understand something here?

btw: as you probably noticed, the netdev interface dev_addr is an
extended address (because it's always present). Now there comes the
ugly part, netdevs cannot deal with other dev_addrs with different
length, that's why it's stored in the wpan specific dev structure and
things don't get easy and solutions need to be found how to make it
working... get prepared to get crazy...

- Alex


