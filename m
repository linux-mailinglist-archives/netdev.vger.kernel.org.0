Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F225D68B3EB
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 02:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBFBkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 20:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBFBkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 20:40:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2271E19F28
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 17:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675647586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lBb72unxjBxmDeLr8P7vofjNZqtkS4EDBwpFLKDXYXY=;
        b=eC2+oIPnp9pDgV/9a+TIaWYgotTR+Oxyf/DReruLAFTSK/sRJVutOilXEVQAIqiiEeLnU6
        W72lycW+1ejMJUSSAceyApK6LNka9hLLNgK0E0V1I3UDsHUqY7fXxLTQRn/LFG/aAA8f53
        8NirtYwMsrJEiVhBGmREgfIas9trcqg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-265-RJGSaoVBPyWTU593O1frCw-1; Sun, 05 Feb 2023 20:39:45 -0500
X-MC-Unique: RJGSaoVBPyWTU593O1frCw-1
Received: by mail-ed1-f71.google.com with SMTP id d21-20020aa7c1d5000000b004a6e1efa7d0so6424758edp.19
        for <netdev@vger.kernel.org>; Sun, 05 Feb 2023 17:39:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lBb72unxjBxmDeLr8P7vofjNZqtkS4EDBwpFLKDXYXY=;
        b=IC2cPclj50ZmGXnZeAHGVwIwoZUh6Vv102xGC8+xFMLyEGDtUSqRysAddRKVHNF8PF
         OPu+mzeiUjlEM5HUZSnrvkkRuyQvkJcU7C9n+UUoHsQQlwaZrQR+dKOLNtLA8kHNzavt
         +UHdUwgKQvOgenQDmZBkrfOHMuQxneYZO4i7CypXslfU3vCGytM4xh9vBeksFtukRl8p
         1ypt7slafcfDa3wurbp1KLFzMSlZtqsK2bFzjbGOAxwa0Spi+9X2tIt6AOvSogwfv3iP
         lMI2xGHzYlKEGUnQRL/Fz03VTe0Gew5AyT0kELHoZJ0hZXrszK0mxMeiTYY7x/zV4Ydr
         NXPA==
X-Gm-Message-State: AO0yUKXFF4nnhpkz4tZXpBFuDe3jhnHm7m1leR780LiA/F6hzcwHtjR1
        t0LvEoeA24vxAYGPtM0V4Ag57zNuxgqiL8IyiMmO7YMaPXkDniIFhB0ENgwzCaxYFLeBuWrMxDf
        u4elzlWQ5IIJvCB3lHjcNI5LaOTIHFvU3
X-Received: by 2002:a17:906:48b:b0:878:69e5:b797 with SMTP id f11-20020a170906048b00b0087869e5b797mr4239681eja.228.1675647583802;
        Sun, 05 Feb 2023 17:39:43 -0800 (PST)
X-Google-Smtp-Source: AK7set+cgvp9pFnI8ThvzgU3vMwhy/t40024Io3E8kyCpBDMdoZqU0DFB1sQvprwyigOiXHfwNOdJZOcdGnoz+zcuYs=
X-Received: by 2002:a17:906:48b:b0:878:69e5:b797 with SMTP id
 f11-20020a170906048b00b0087869e5b797mr4239663eja.228.1675647583601; Sun, 05
 Feb 2023 17:39:43 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com> <20221129160046.538864-2-miquel.raynal@bootlin.com>
In-Reply-To: <20221129160046.538864-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 5 Feb 2023 20:39:32 -0500
Message-ID: <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning requests
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Nov 29, 2022 at 11:02 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> The ieee802154 layer should be able to scan a set of channels in order
> to look for beacons advertizing PANs. Supporting this involves adding
> two user commands: triggering scans and aborting scans. The user should
> also be notified when a new beacon is received and also upon scan
> termination.
>
> A scan request structure is created to list the requirements and to be
> accessed asynchronously when changing channels or receiving beacons.
>
> Mac layers may now implement the ->trigger_scan() and ->abort_scan()
> hooks.
>
> Co-developed-by: David Girault <david.girault@qorvo.com>
> Signed-off-by: David Girault <david.girault@qorvo.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/linux/ieee802154.h |   3 +
>  include/net/cfg802154.h    |  25 +++++
>  include/net/nl802154.h     |  49 +++++++++
>  net/ieee802154/nl802154.c  | 215 +++++++++++++++++++++++++++++++++++++
>  net/ieee802154/nl802154.h  |   3 +
>  net/ieee802154/rdev-ops.h  |  28 +++++
>  net/ieee802154/trace.h     |  40 +++++++
>  7 files changed, 363 insertions(+)
>
> diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
> index 0303eb84d596..b22e4147d334 100644
> --- a/include/linux/ieee802154.h
> +++ b/include/linux/ieee802154.h
> @@ -44,6 +44,9 @@
>  #define IEEE802154_SHORT_ADDR_LEN      2
>  #define IEEE802154_PAN_ID_LEN          2
>
> +/* Duration in superframe order */
> +#define IEEE802154_MAX_SCAN_DURATION   14
> +#define IEEE802154_ACTIVE_SCAN_DURATION        15
>  #define IEEE802154_LIFS_PERIOD         40
>  #define IEEE802154_SIFS_PERIOD         12
>  #define IEEE802154_MAX_SIFS_FRAME_SIZE 18
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index d09c393d229f..76d4f95e9974 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -18,6 +18,7 @@
>
>  struct wpan_phy;
>  struct wpan_phy_cca;
> +struct cfg802154_scan_request;
>
>  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
>  struct ieee802154_llsec_device_key;
> @@ -67,6 +68,10 @@ struct cfg802154_ops {
>                                 struct wpan_dev *wpan_dev, bool mode);
>         int     (*set_ackreq_default)(struct wpan_phy *wpan_phy,
>                                       struct wpan_dev *wpan_dev, bool ackreq);
> +       int     (*trigger_scan)(struct wpan_phy *wpan_phy,
> +                               struct cfg802154_scan_request *request);
> +       int     (*abort_scan)(struct wpan_phy *wpan_phy,
> +                             struct wpan_dev *wpan_dev);
>  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
>         void    (*get_llsec_table)(struct wpan_phy *wpan_phy,
>                                    struct wpan_dev *wpan_dev,
> @@ -278,6 +283,26 @@ struct ieee802154_coord_desc {
>         bool gts_permit;
>  };
>
> +/**
> + * struct cfg802154_scan_request - Scan request
> + *
> + * @type: type of scan to be performed
> + * @page: page on which to perform the scan
> + * @channels: channels in te %page to be scanned
> + * @duration: time spent on each channel, calculated with:
> + *            aBaseSuperframeDuration * (2 ^ duration + 1)
> + * @wpan_dev: the wpan device on which to perform the scan
> + * @wpan_phy: the wpan phy on which to perform the scan
> + */
> +struct cfg802154_scan_request {
> +       enum nl802154_scan_types type;
> +       u8 page;
> +       u32 channels;
> +       u8 duration;
> +       struct wpan_dev *wpan_dev;
> +       struct wpan_phy *wpan_phy;
> +};
> +
>  struct ieee802154_llsec_key_id {
>         u8 mode;
>         u8 id;
> diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> index b79a89d5207c..79fbd820b25a 100644
> --- a/include/net/nl802154.h
> +++ b/include/net/nl802154.h
> @@ -73,6 +73,9 @@ enum nl802154_commands {
>         NL802154_CMD_DEL_SEC_LEVEL,
>
>         NL802154_CMD_SCAN_EVENT,
> +       NL802154_CMD_TRIGGER_SCAN,
> +       NL802154_CMD_ABORT_SCAN,
> +       NL802154_CMD_SCAN_DONE,
>
>         /* add new commands above here */
>
> @@ -134,6 +137,12 @@ enum nl802154_attrs {
>         NL802154_ATTR_NETNS_FD,
>
>         NL802154_ATTR_COORDINATOR,
> +       NL802154_ATTR_SCAN_TYPE,
> +       NL802154_ATTR_SCAN_FLAGS,
> +       NL802154_ATTR_SCAN_CHANNELS,
> +       NL802154_ATTR_SCAN_PREAMBLE_CODES,
> +       NL802154_ATTR_SCAN_MEAN_PRF,
> +       NL802154_ATTR_SCAN_DURATION,
>
>         /* add attributes here, update the policy in nl802154.c */
>
> @@ -259,6 +268,46 @@ enum nl802154_coord {
>         NL802154_COORD_MAX,
>  };
>
> +/**
> + * enum nl802154_scan_types - Scan types
> + *
> + * @__NL802154_SCAN_INVALID: scan type number 0 is reserved
> + * @NL802154_SCAN_ED: An ED scan allows a device to obtain a measure of the peak
> + *     energy in each requested channel
> + * @NL802154_SCAN_ACTIVE: Locate any coordinator transmitting Beacon frames using
> + *     a Beacon Request command
> + * @NL802154_SCAN_PASSIVE: Locate any coordinator transmitting Beacon frames
> + * @NL802154_SCAN_ORPHAN: Relocate coordinator following a loss of synchronisation
> + * @NL802154_SCAN_ENHANCED_ACTIVE: Same as Active using Enhanced Beacon Request
> + *     command instead of Beacon Request command
> + * @NL802154_SCAN_RIT_PASSIVE: Passive scan for RIT Data Request command frames
> + *     instead of Beacon frames
> + * @NL802154_SCAN_ATTR_MAX: Maximum SCAN attribute number
> + */
> +enum nl802154_scan_types {
> +       __NL802154_SCAN_INVALID,
> +       NL802154_SCAN_ED,
> +       NL802154_SCAN_ACTIVE,
> +       NL802154_SCAN_PASSIVE,
> +       NL802154_SCAN_ORPHAN,
> +       NL802154_SCAN_ENHANCED_ACTIVE,
> +       NL802154_SCAN_RIT_PASSIVE,
> +
> +       /* keep last */
> +       NL802154_SCAN_ATTR_MAX,
> +};
> +
> +/**
> + * enum nl802154_scan_flags - Scan request control flags
> + *
> + * @NL802154_SCAN_FLAG_RANDOM_ADDR: use a random MAC address for this scan (ie.
> + *     a different one for every scan iteration). When the flag is set, full
> + *     randomisation is assumed.
> + */
> +enum nl802154_scan_flags {
> +       NL802154_SCAN_FLAG_RANDOM_ADDR = BIT(0),
> +};
> +
>  /**
>   * enum nl802154_cca_modes - cca modes
>   *
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 80dc73182785..c497ffd8e897 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -221,6 +221,12 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
>
>         [NL802154_ATTR_COORDINATOR] = { .type = NLA_NESTED },
>
> +       [NL802154_ATTR_SCAN_TYPE] = { .type = NLA_U8 },
> +       [NL802154_ATTR_SCAN_CHANNELS] = { .type = NLA_U32 },
> +       [NL802154_ATTR_SCAN_PREAMBLE_CODES] = { .type = NLA_U64 },
> +       [NL802154_ATTR_SCAN_MEAN_PRF] = { .type = NLA_U8 },
> +       [NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8 },
> +
>  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
>         [NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
>         [NL802154_ATTR_SEC_OUT_LEVEL] = { .type = NLA_U32, },
> @@ -1384,6 +1390,199 @@ int nl802154_scan_event(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
>  }
>  EXPORT_SYMBOL_GPL(nl802154_scan_event);
>
> +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
> +{
> +       struct cfg802154_registered_device *rdev = info->user_ptr[0];
> +       struct net_device *dev = info->user_ptr[1];
> +       struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
> +       struct wpan_phy *wpan_phy = &rdev->wpan_phy;
> +       struct cfg802154_scan_request *request;
> +       u8 type;
> +       int err;
> +
> +       /* Monitors are not allowed to perform scans */
> +       if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
> +               return -EPERM;

btw: why are monitors not allowed?

- Alex

