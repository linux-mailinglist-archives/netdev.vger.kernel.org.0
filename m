Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A52A61E87A
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 03:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiKGCCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 21:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiKGCCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 21:02:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B68DF45
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 18:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667786509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vS5z1neygmnwXrDMaIPF0jOMAafszNH5Byrw9RNwZLg=;
        b=VlioKa4NiYMJtxXSclcZFaV02z1mLs264FYi97VSmWY7ZSbDeCBUVjbTsrOTlBXtps47ob
        xq4TR7HvnbndGqjwvbWuPV+Ekd/nv2kHMKf+zKOYYMZkNbDJ3A3pzXaK/g6GwdER7306uh
        eE6r0kpQ4FsYHtAmKa9dORJVUkC5hTI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-91-X3KeQzdeNIqNVmzSSHS1TQ-1; Sun, 06 Nov 2022 21:01:48 -0500
X-MC-Unique: X3KeQzdeNIqNVmzSSHS1TQ-1
Received: by mail-ej1-f69.google.com with SMTP id gt15-20020a1709072d8f00b007aaac7973fbso5504884ejc.23
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 18:01:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vS5z1neygmnwXrDMaIPF0jOMAafszNH5Byrw9RNwZLg=;
        b=TKJIkyR6Ty8ggRxVfMmYvi5ZdV1B4VmI4+rNd7/VOjPwzuMCqAB0FB07iyuIPOdVYi
         Me8/AEtzPgIGf93DtmcTzmbDe/5YMEjKv47VGVOEqIt2pmfjOue2nN19KSgkAp1DEcOD
         U6LTIupb9gR4cfSGKcSlytFXh1nFeBTpU7OxafS8/GKrzadDC13hiV2nWYtpcOQD3aLG
         1ZVB/wh7/Ra15/5nxTB+D8GvxRbDwsZ+g7uvhR8Dq9JYdHFzql3MfpjSMmxCvOUp4+/F
         XSZKrZdHjTBfNTQVq6q2U+DVLOpAlSw4JbD5NccNKlc1onTbtbRYOXi70WflDsR8PlUF
         hpaA==
X-Gm-Message-State: ACrzQf2NtOgPM4v5ZBl1iNuP+hNZJ9gUqGbyKOyNDwsHN4dbRuM+kRiU
        G+ImJsV7eMqLm9oO1+6hRyPVDasNg4EHpeEW9aFDhF5JVj+6xSqKlZWENt5DIVq21G3YE7p8Py2
        Pep0k/RXAZ2dGe0Iro+vE3q1wpYI8wH2F
X-Received: by 2002:a05:6402:5409:b0:44f:1e05:1e8 with SMTP id ev9-20020a056402540900b0044f1e0501e8mr48013844edb.373.1667786506783;
        Sun, 06 Nov 2022 18:01:46 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5iifiGBBXml4IkmEE0Br8jgf5n3VJrnrAaRYMyHBqESC6/LfhzCV4sZCPJHXyI6HPyFW1Q9Sm+ZI8WlPq0/lQ=
X-Received: by 2002:a05:6402:5409:b0:44f:1e05:1e8 with SMTP id
 ev9-20020a056402540900b0044f1e0501e8mr48013828edb.373.1667786506514; Sun, 06
 Nov 2022 18:01:46 -0800 (PST)
MIME-Version: 1.0
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com> <20221102151915.1007815-2-miquel.raynal@bootlin.com>
In-Reply-To: <20221102151915.1007815-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 6 Nov 2022 21:01:35 -0500
Message-ID: <CAK-6q+iSzRyDDiNusXiRWvUsS5dSS5bSzAtNjSLTt6kgaxtbHg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/3] ieee802154: Advertize coordinators discovery
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
> Let's introduce the basics for advertizing discovered PANs and
> coordinators, which is:
> - A new "scan" netlink message group.
> - A couple of netlink command/attribute.
> - The main netlink helper to send a netlink message with all the
>   necessary information to forward the main information to the user.
>
> Two netlink attributes are proactively added to support future UWB
> complex channels, but are not actually used yet.
>
> Co-developed-by: David Girault <david.girault@qorvo.com>
> Signed-off-by: David Girault <david.girault@qorvo.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h   |  20 +++++++
>  include/net/nl802154.h    |  44 ++++++++++++++
>  net/ieee802154/nl802154.c | 121 ++++++++++++++++++++++++++++++++++++++
>  net/ieee802154/nl802154.h |   6 ++
>  4 files changed, 191 insertions(+)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index e1481f9cf049..8d67d9ed438d 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -260,6 +260,26 @@ struct ieee802154_addr {
>         };
>  };
>
> +/**
> + * struct ieee802154_coord_desc - Coordinator descriptor
> + * @coord: PAN ID and coordinator address
> + * @page: page this coordinator is using
> + * @channel: channel this coordinator is using
> + * @superframe_spec: SuperFrame specification as received
> + * @link_quality: link quality indicator at which the beacon was received
> + * @gts_permit: the coordinator accepts GTS requests
> + * @node: list item
> + */
> +struct ieee802154_coord_desc {
> +       struct ieee802154_addr *addr;

Why is this a pointer?

> +       u8 page;
> +       u8 channel;
> +       u16 superframe_spec;
> +       u8 link_quality;
> +       bool gts_permit;
> +       struct list_head node;
> +};
> +
>  struct ieee802154_llsec_key_id {
>         u8 mode;
>         u8 id;
> diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> index 145acb8f2509..cfe462288695 100644
> --- a/include/net/nl802154.h
> +++ b/include/net/nl802154.h
> @@ -58,6 +58,9 @@ enum nl802154_commands {
>
>         NL802154_CMD_SET_WPAN_PHY_NETNS,
>
> +       NL802154_CMD_NEW_COORDINATOR,
> +       NL802154_CMD_KNOWN_COORDINATOR,
> +

NEW is something we never saw before and KNOWN we already saw before?
I am not getting that when I just want to maintain a list in the user
space and keep them updated, but I think we had this discussion
already or? Currently they do the same thing, just the command is
different. The user can use it to filter NEW and KNOWN? Still I am not
getting it why there is not just a start ... event, event, event ....
end. and let the user decide if it knows that it's new or old from its
perspective.

>         /* add new commands above here */
>
>  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> @@ -133,6 +136,8 @@ enum nl802154_attrs {
>         NL802154_ATTR_PID,
>         NL802154_ATTR_NETNS_FD,
>
> +       NL802154_ATTR_COORDINATOR,
> +
>         /* add attributes here, update the policy in nl802154.c */
>
>  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> @@ -218,6 +223,45 @@ enum nl802154_wpan_phy_capability_attr {
>         NL802154_CAP_ATTR_MAX = __NL802154_CAP_ATTR_AFTER_LAST - 1
>  };
>
> +/**
> + * enum nl802154_coord - Netlink attributes for a coord
> + *
> + * @__NL802154_COORD_INVALID: invalid
> + * @NL802154_COORD_PANID: PANID of the coordinator (2 bytes)
> + * @NL802154_COORD_ADDR: coordinator address, (8 bytes or 2 bytes)
> + * @NL802154_COORD_CHANNEL: channel number, related to @NL802154_COORD_PAGE (u8)
> + * @NL802154_COORD_PAGE: channel page, related to @NL802154_COORD_CHANNEL (u8)
> + * @NL802154_COORD_PREAMBLE_CODE: Preamble code used when the beacon was received,
> + *     this is PHY dependent and optional (u8)
> + * @NL802154_COORD_MEAN_PRF: Mean PRF used when the beacon was received,
> + *     this is PHY dependent and optional (u8)
> + * @NL802154_COORD_SUPERFRAME_SPEC: superframe specification of the PAN (u16)
> + * @NL802154_COORD_LINK_QUALITY: signal quality of beacon in unspecified units,
> + *     scaled to 0..255 (u8)
> + * @NL802154_COORD_GTS_PERMIT: set to true if GTS is permitted on this PAN
> + * @NL802154_COORD_PAYLOAD_DATA: binary data containing the raw data from the
> + *     frame payload, (only if beacon or probe response had data)
> + * @NL802154_COORD_PAD: attribute used for padding for 64-bit alignment
> + * @NL802154_COORD_MAX: highest coordinator attribute
> + */
> +enum nl802154_coord {
> +       __NL802154_COORD_INVALID,
> +       NL802154_COORD_PANID,
> +       NL802154_COORD_ADDR,
> +       NL802154_COORD_CHANNEL,
> +       NL802154_COORD_PAGE,
> +       NL802154_COORD_PREAMBLE_CODE,

Interesting, if you do a scan and discover pans and others answers I
would think you would see only pans on the same preamble. How is this
working?

> +       NL802154_COORD_MEAN_PRF,
> +       NL802154_COORD_SUPERFRAME_SPEC,
> +       NL802154_COORD_LINK_QUALITY,

not against it to have it, it's fine. I just think it is not very
useful. A way to dump all LQI values with some timestamp and having
something in user space to collect stats and do some heuristic may be
better?

> +       NL802154_COORD_GTS_PERMIT,
> +       NL802154_COORD_PAYLOAD_DATA,
> +       NL802154_COORD_PAD,
> +
> +       /* keep last */
> +       NL802154_COORD_MAX,
> +};
> +
>  /**
>   * enum nl802154_cca_modes - cca modes
>   *
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index e0b072aecf0f..f6fb7a228747 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -26,10 +26,12 @@ static struct genl_family nl802154_fam;
>  /* multicast groups */
>  enum nl802154_multicast_groups {
>         NL802154_MCGRP_CONFIG,
> +       NL802154_MCGRP_SCAN,
>  };
>
>  static const struct genl_multicast_group nl802154_mcgrps[] = {
>         [NL802154_MCGRP_CONFIG] = { .name = "config", },
> +       [NL802154_MCGRP_SCAN] = { .name = "scan", },
>  };
>
>  /* returns ERR_PTR values */
> @@ -216,6 +218,9 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
>
>         [NL802154_ATTR_PID] = { .type = NLA_U32 },
>         [NL802154_ATTR_NETNS_FD] = { .type = NLA_U32 },
> +
> +       [NL802154_ATTR_COORDINATOR] = { .type = NLA_NESTED },
> +
>  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
>         [NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
>         [NL802154_ATTR_SEC_OUT_LEVEL] = { .type = NLA_U32, },
> @@ -1281,6 +1286,122 @@ static int nl802154_wpan_phy_netns(struct sk_buff *skb, struct genl_info *info)
>         return err;
>  }
>
> +static int nl802154_prep_new_coord_msg(struct sk_buff *msg,
> +                                      struct cfg802154_registered_device *rdev,
> +                                      struct wpan_dev *wpan_dev,
> +                                      u32 portid, u32 seq, int flags, u8 cmd,
> +                                      struct ieee802154_coord_desc *desc)
> +{
> +       struct nlattr *nla;
> +       void *hdr;
> +
> +       hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
> +       if (!hdr)
> +               return -ENOBUFS;
> +
> +       if (nla_put_u32(msg, NL802154_ATTR_WPAN_PHY, rdev->wpan_phy_idx))
> +               goto nla_put_failure;
> +
> +       if (wpan_dev->netdev &&
> +           nla_put_u32(msg, NL802154_ATTR_IFINDEX, wpan_dev->netdev->ifindex))
> +               goto nla_put_failure;
> +
> +       if (nla_put_u64_64bit(msg, NL802154_ATTR_WPAN_DEV,
> +                             wpan_dev_id(wpan_dev), NL802154_ATTR_PAD))
> +               goto nla_put_failure;
> +
> +       nla = nla_nest_start_noflag(msg, NL802154_ATTR_COORDINATOR);
> +       if (!nla)
> +               goto nla_put_failure;
> +
> +       if (nla_put(msg, NL802154_COORD_PANID, IEEE802154_PAN_ID_LEN,
> +                   &desc->addr->pan_id))
> +               goto nla_put_failure;
> +
> +       if (desc->addr->mode == IEEE802154_ADDR_SHORT) {
> +               if (nla_put(msg, NL802154_COORD_ADDR,
> +                           IEEE802154_SHORT_ADDR_LEN,
> +                           &desc->addr->short_addr))
> +                       goto nla_put_failure;
> +       } else {
> +               if (nla_put(msg, NL802154_COORD_ADDR,
> +                           IEEE802154_EXTENDED_ADDR_LEN,
> +                           &desc->addr->extended_addr))
> +                       goto nla_put_failure;
> +       }
> +
> +       if (nla_put_u8(msg, NL802154_COORD_CHANNEL, desc->channel))
> +               goto nla_put_failure;
> +
> +       if (nla_put_u8(msg, NL802154_COORD_PAGE, desc->page))
> +               goto nla_put_failure;
> +
> +       if (nla_put_u16(msg, NL802154_COORD_SUPERFRAME_SPEC,
> +                       desc->superframe_spec))
> +               goto nla_put_failure;
> +
> +       if (nla_put_u8(msg, NL802154_COORD_LINK_QUALITY, desc->link_quality))
> +               goto nla_put_failure;
> +
> +       if (desc->gts_permit && nla_put_flag(msg, NL802154_COORD_GTS_PERMIT))
> +               goto nla_put_failure;
> +
> +       /* TODO: NL802154_COORD_PAYLOAD_DATA if any */
> +
> +       nla_nest_end(msg, nla);
> +
> +       genlmsg_end(msg, hdr);
> +
> +       return 0;
> +
> + nla_put_failure:
> +       genlmsg_cancel(msg, hdr);
> +
> +       return -EMSGSIZE;
> +}
> +
> +static int nl802154_advertise_coordinator(struct wpan_phy *wpan_phy,
> +                                         struct wpan_dev *wpan_dev, u8 cmd,
> +                                         struct ieee802154_coord_desc *desc)
> +{
> +       struct cfg802154_registered_device *rdev = wpan_phy_to_rdev(wpan_phy);
> +       struct sk_buff *msg;
> +       int ret;
> +
> +       msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
> +       if (!msg)
> +               return -ENOMEM;
> +
> +       ret = nl802154_prep_new_coord_msg(msg, rdev, wpan_dev, 0, 0, 0, cmd, desc);
> +       if (ret < 0) {
> +               nlmsg_free(msg);
> +               return ret;
> +       }
> +
> +       return genlmsg_multicast_netns(&nl802154_fam, wpan_phy_net(wpan_phy),
> +                                      msg, 0, NL802154_MCGRP_SCAN, GFP_ATOMIC);
> +}

ah, okay that answers my previous question... regarding the trace event.

- Alex

