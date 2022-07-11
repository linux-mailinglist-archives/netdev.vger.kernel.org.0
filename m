Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AEA56D2DB
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 04:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiGKCHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 22:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKCHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 22:07:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ECD514D31
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 19:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657505236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=meNn6SbpJh9fea8sNzE6pLer+JbMNyWdQAZ+kpRRRwo=;
        b=HGJcfk8UnpPhWH0e85YRQYAPsQU8jMM3BddYZK59K30V6cXBYZZ3dn7Z0nTAPJ+IeSiSsr
        ergFLjsEA+SrGxAghHV0euyM1B49c2umQ1kv7QF1nlYXWW/KBT1o9Sjj7cmHv4bjS5wRXj
        J6NuhW8SnSzgvXlXD4/bQkxld2s2928=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-MdZ-KOn5PM6QzAXZrxltvQ-1; Sun, 10 Jul 2022 22:07:09 -0400
X-MC-Unique: MdZ-KOn5PM6QzAXZrxltvQ-1
Received: by mail-qt1-f200.google.com with SMTP id f14-20020ac8068e000000b0031e899fabdcso3924569qth.5
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 19:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=meNn6SbpJh9fea8sNzE6pLer+JbMNyWdQAZ+kpRRRwo=;
        b=l9PJHXtVQZ/0AS4W74Of+DMwkg00H5So1Jj9ntXk3o3iHFjsbYxzduErMxmelZgNpe
         7o65ABXmQ+F7OTJKZCM2TEBNOXbFDSpaHJcqJ/pNon8s03bTaJkHmdKd2Fkhry31V0DY
         jJ0BTiacpT40XfQPOpc4iuI9SQza+zt/mfpWzAbbP1o9Ob5dXQLKH+1nnBhm2RuCm9Xx
         od0jpTlP/dI5YAjgl7r827hxByHUQf+qRDErCQZCsjD85v+ixU1lUvrrmkxIR2SjvZw8
         YcZSMONLwtbroHjLb7WuaqBbBEG64brssAfBkRdWpkbKeBX8JGicjCbFUwKipzQ5Ic6x
         365g==
X-Gm-Message-State: AJIora9mdCamBihZ3TYzFFUkGGTFBnlPghQS8GLdxMapjDck9gPPE1yo
        qDvQlll+mH4XBt/9yNVWxNPsbjRVaddoKNUtukPjv+WPomEcb8MKkwI3PQGmrz90BoiPCiofCiO
        Y4Fthep3yKayktIgqS9fwnV+LkxL3/bxu
X-Received: by 2002:a05:622a:4cb:b0:31e:a94d:f8aa with SMTP id q11-20020a05622a04cb00b0031ea94df8aamr9581157qtx.526.1657505228754;
        Sun, 10 Jul 2022 19:07:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1swo0XjTp8Y/xb37YTwTbEFtbyj1jv27lOnGpdxWXFDq1UtDxu9MChS8YMYrOYFM6B2zx4h06J4QeTiLiXbyFE=
X-Received: by 2002:a05:622a:4cb:b0:31e:a94d:f8aa with SMTP id
 q11-20020a05622a04cb00b0031ea94df8aamr9581152qtx.526.1657505228585; Sun, 10
 Jul 2022 19:07:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com> <20220701143052.1267509-6-miquel.raynal@bootlin.com>
In-Reply-To: <20220701143052.1267509-6-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 10 Jul 2022 22:06:57 -0400
Message-ID: <CAK-6q+gXUySx1YzPdq1+dt5MN5y_4qGWAB5a1qPe2tOGkbq19A@mail.gmail.com>
Subject: Re: [PATCH wpan-next 05/20] net: ieee802154: Define frame types
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> A 802.15.4 frame can be of different types, here is a definition
> matching the specification. This enumeration will be soon be used when
> adding scanning support.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/ieee802154_netdev.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
> index d0d188c3294b..13167851b1c3 100644
> --- a/include/net/ieee802154_netdev.h
> +++ b/include/net/ieee802154_netdev.h
> @@ -69,6 +69,17 @@ struct ieee802154_hdr_fc {
>  #endif
>  };
>
> +enum ieee802154_frame_type {
> +       IEEE802154_BEACON_FRAME,
> +       IEEE802154_DATA_FRAME,
> +       IEEE802154_ACKNOWLEDGEMENT_FRAME,
> +       IEEE802154_MAC_COMMAND_FRAME,
> +       IEEE802154_RESERVED_FRAME,
> +       IEEE802154_MULTIPURPOSE_FRAME,
> +       IEEE802154_FRAGMENT_FRAME,
> +       IEEE802154_EXTENDED_FRAME,
> +};

Please use and extend include/linux/ieee802154.h e.g. IEEE802154_FC_TYPE_DATA.
I am also not a fan of putting those structs on payload, because there
can be several problems with it, we should introduce inline helpers to
check/get each individual fields but... the struct is currently how
it's implemented.

- Alex

