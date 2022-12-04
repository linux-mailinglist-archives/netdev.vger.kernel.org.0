Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C864201B
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 23:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiLDWpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 17:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiLDWpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 17:45:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4FCAE45
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 14:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670193878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cDvp/36klGwDyLue/cazWo2NSGv84oNLZObnyySxhz8=;
        b=X5wRU8raZkJlPIXKwe1O4yBGYPtw55AcETRuelwlmtzaHJavMUd5frJfAi/nS1mfX04yzF
        cAFnLVAR5JXyobmPDunABEJHrGX3UJxj9CdWUzHmbuzVdJgXjTRthbwzESt2RJXqgdv5Vo
        OHKKQGTZCu0I+/6UuxAfp9kNf24OTr4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-ZaNJ8qRpMb-D4GTbiGz3JQ-1; Sun, 04 Dec 2022 17:44:36 -0500
X-MC-Unique: ZaNJ8qRpMb-D4GTbiGz3JQ-1
Received: by mail-ed1-f69.google.com with SMTP id h9-20020a05640250c900b00461d8ee12e2so4690796edb.23
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 14:44:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cDvp/36klGwDyLue/cazWo2NSGv84oNLZObnyySxhz8=;
        b=k+g12uyuLFV5Jy9zzP73O+bvPpTpEch5vC42H3DXR/mQ34uW73G0fUKjzBeb8KjPte
         JBXWxBWw+VZk3RV5KOTfxlhf7FTMh8o2ybOdDXiLmV8QI3DvaP1uojsav8NJxyTs7pnj
         G8q3oor/SzvbOUXAahb/jO78dHl9GuLzGbRUcPa1ubxFZRI8WoSRFivIt3NyoicfceVf
         OTYqk50u3+RODkB9SW1mv1ghY9xccvdZsSBNrSDIZH7hg5ZljCZoro1wP4fesJbFuBAL
         S2lCLxoxnqgOhTyF0N8FU/VbtlZpr+dPQmwx/ssZn/gltWddU1DcyfCsnb7amAK3tUcN
         ISTQ==
X-Gm-Message-State: ANoB5pnhRs3BhgbE8gXhKgqYvmf69F5ZHexwKNfsHBua15dgV83y5K1e
        bYEQt4BlFUuoqZvjhk/68OTbtzz9P8W01jSl0aBYpPRkkJKJcpj3/x/0is5aKynjKnFVlVTHPMO
        IpWU+NP+MF8WBUnVMcLW0heVIuI8qtkUo
X-Received: by 2002:a17:906:5213:b0:7b6:12ee:b7fc with SMTP id g19-20020a170906521300b007b612eeb7fcmr17284034ejm.265.1670193875672;
        Sun, 04 Dec 2022 14:44:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6kCdJcNQRRfjxBIFdzd1cFTpGwWUJ6sBNgrUju/qGfG0CbWm8k/QieZ0liB9R8ByDs4p5cOh8tp5oPGwuODws=
X-Received: by 2002:a17:906:5213:b0:7b6:12ee:b7fc with SMTP id
 g19-20020a170906521300b007b612eeb7fcmr17284013ejm.265.1670193875449; Sun, 04
 Dec 2022 14:44:35 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com> <20221129160046.538864-2-miquel.raynal@bootlin.com>
In-Reply-To: <20221129160046.538864-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 4 Dec 2022 17:44:24 -0500
Message-ID: <CAK-6q+hjXKmOrf-p=hRzuD=4pOJeWNUu46iU8YAVL4BqWC437A@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

Is NL802154_CMD_SCAN_DONE reserved now? I don't see it implemented in
this series and I think we had some discussion about the need of abort
vs done. Is the event now?

- Alex

