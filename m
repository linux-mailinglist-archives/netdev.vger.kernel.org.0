Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85FF5B2B45
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiIIBAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiIIBAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:00:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4679593
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 18:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662685250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I856H1rwIbhfqio8LN/TVnW62r8orIp+O6WZ+aXtKuU=;
        b=XCJ2vYRscCbULcj9XZrECVefAJG0W7YTxyiKltzFMOvaNj6wsW9iesLSWaVfep7lD8bZ5O
        ocw+Wp4R3FIfQq2ZgLZKFeR1E+xXaIksrvjsNMFVkBV5JUrSqkUeHMvnj2o5rVTr7/W05y
        hbCZadsi/Jvk204NYQFU4GndQE7/M7w=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-303-tQDqQ9CNONiJ5RhWcmT7LA-1; Thu, 08 Sep 2022 21:00:49 -0400
X-MC-Unique: tQDqQ9CNONiJ5RhWcmT7LA-1
Received: by mail-il1-f197.google.com with SMTP id s15-20020a056e021a0f00b002f1760d1437so144241ild.1
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 18:00:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=I856H1rwIbhfqio8LN/TVnW62r8orIp+O6WZ+aXtKuU=;
        b=MP52ipN6RBK2fJhiQws7yukm4WQPAzwInMOWe13XnW8F4YiZzlBbIVevWay3Zd440u
         i3q0eJAonN2VnkxfDALnbOS6DZV4VB4hXH2MOf90SpCckOdahsjy/6PBJBt4B0BwDRnE
         m5a/69VPs6komRHzoOR7trhzLagzDfDoWs0oPAVJk2j9J5YtN4l5PDQe1rDg/GL9l7MO
         ZA7PqWxuIMc7iQhT6GFy8GAoGWZSwmjaAFGAdR1ZR4+RJXnbyykAPDrYp4fB2SW52r8h
         DCBq+gmvu9HJNGsq3tVgjW1qEkyKdRGtS/2DYI0GGzRCN9uVTotuAkp18ssI00Upkdxm
         FO6A==
X-Gm-Message-State: ACgBeo0Q0mSfRFJkqScaYZV/7cs858tDDKCTfv8LP4X7mRoorHYQW83F
        9JK8rhx7O6hesmBj4bdG8vOa9buwWttuh7SzGLlbRt39KUZZtq7UIpUjIJaG0ChU1t8myA1oH7K
        JTAz3KlQsWJ/0It1I9wBJLiRlboDnt5Pa
X-Received: by 2002:a92:c54a:0:b0:2ee:adca:6ec4 with SMTP id a10-20020a92c54a000000b002eeadca6ec4mr3149209ilj.180.1662685248795;
        Thu, 08 Sep 2022 18:00:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7Jc8+Q/F7r9Jujbos3Hs8U+8aPf9qbXr/oSo5IL76Czr3xFQfl9L/Z7mg5yCy6qtF8owITQpIzkTnEJqSUCW8=
X-Received: by 2002:a92:c54a:0:b0:2ee:adca:6ec4 with SMTP id
 a10-20020a92c54a000000b002eeadca6ec4mr3149192ilj.180.1662685248607; Thu, 08
 Sep 2022 18:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com> <20220905203412.1322947-9-miquel.raynal@bootlin.com>
In-Reply-To: <20220905203412.1322947-9-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 8 Sep 2022 21:00:37 -0400
Message-ID: <CAK-6q+jB0HQsU_wzr2T-qdGj=YSdf08DTZ0WTmRvDQt0Px7+Rg@mail.gmail.com>
Subject: Re: [PATCH wpan/next v3 8/9] net: mac802154: Ensure proper general
 purpose frame filtering
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Sep 5, 2022 at 4:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Most of the PHYs seem to cope with the standard filtering rules by
> default. Some of them might not, like hwsim which is only software, and

yes, as I said before hwsim should pretend to be like all other
hardware we have.

> in this case advertises its real filtering level with the new
> "filtering" internal value.
>
> The core then needs to check what is expected by looking at the PHY
> requested filtering level and possibly apply additional filtering
> rules.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/ieee802154_netdev.h |  8 ++++
>  net/mac802154/rx.c              | 78 +++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+)
>
> diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
> index d0d188c3294b..1b82bbafe8c7 100644
> --- a/include/net/ieee802154_netdev.h
> +++ b/include/net/ieee802154_netdev.h
> @@ -69,6 +69,14 @@ struct ieee802154_hdr_fc {
>  #endif
>  };
>
> +enum ieee802154_frame_version {
> +       IEEE802154_2003_STD,
> +       IEEE802154_2006_STD,
> +       IEEE802154_STD,
> +       IEEE802154_RESERVED_STD,
> +       IEEE802154_MULTIPURPOSE_STD = IEEE802154_2003_STD,
> +};
> +
>  struct ieee802154_hdr {
>         struct ieee802154_hdr_fc fc;
>         u8 seq;
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index c43289c0fdd7..bc46e4a7669d 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -52,6 +52,84 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
>                                 mac_cb(skb)->type);
>                         goto fail;
>                 }
> +       } else if (sdata->required_filtering == IEEE802154_FILTERING_4_FRAME_FIELDS &&

We switch here from determine that receive path, means way we are
going from interface type to the required filtering value. Sure there
is currently a 1:1 mapping for them now but I don't know why we are
doing that and this is in my opinion wrong. The receive path should
depend on interface type as it was before and for scanning there is
some early check like:

if (wpan_phy_is_in_scan_mode_state(local)) {
     do_receive_scanning(...)
     /* don't do any other delivery because they provide it to upper layer */
     return;
}

Maybe you should do monitors receive that frame before as well, but
every other interface type should currently not receive it.

- Alex

