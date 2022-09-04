Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F745AC59E
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 19:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbiIDROH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 13:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiIDROG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 13:14:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A696532AA8
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 10:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662311643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QGDoXzTF8Cb48mmT6A1DlkTHZU8f6c1pchx0hQUH288=;
        b=E1elD4IUGSJkZL5HMzNuPp0IMWmy0t576U14o40OIwf8eF+z4e85W2lOx1IgX/cyV+5tFO
        iq5QujkB/412Dk2SeQHmzmdrZ+WvJKc1eK7wgEKnvfFu/Dw+CBih5l0OHbZSz+e+DFoyLC
        r4OmsH0WY6gyJs5WhA0n6ijmQfpfBhI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-155-m5OP8VEQO72oZegB33FAbQ-1; Sun, 04 Sep 2022 13:14:02 -0400
X-MC-Unique: m5OP8VEQO72oZegB33FAbQ-1
Received: by mail-qv1-f69.google.com with SMTP id y5-20020a056214016500b004992ae3b0c2so4583564qvs.22
        for <netdev@vger.kernel.org>; Sun, 04 Sep 2022 10:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=QGDoXzTF8Cb48mmT6A1DlkTHZU8f6c1pchx0hQUH288=;
        b=IaGa3XXuDaYXxE/HQxaHUADoXRCAnQ/Z7T/jsYmAoWY6F5Z/7dULknkyc2kicfuc7t
         zOkzYnphVTqp1mXOOj1tT5AGQWiRW8BYQMhhUkd4hsebFU7WDV5t65sddsdAm5/efQW2
         PMWxkuzQlNkLY15FZIt0Dujf6LJICo9uFvofPYRygh9Scuo4HiWMXqFHGHqRA4MYrmo3
         o2k/hF7ZWRCk/Csr9VNIeS7+CV+38QyHiLtERml8+5RtdWFIRh5ZfnCndRGm1Ga7YsuL
         EERMv6IPB63gehIhhLl8TD4CLxWkINwI+q7NH4KtpwS23QyS/67QlNXmrJns13JzAkTN
         +x/g==
X-Gm-Message-State: ACgBeo2Cm1b9mA7II1kV1K8QRGU8w2EUE82h4XOaBFhprKDsIKhP0XuR
        72KGgFtT3PHjh2LOt58b1fFBEvIDqPYvLlBKK6fJAjxnn15mAtkbTELygxDZCH0KXk8kdoEy5p+
        FEOkO8tidfAc6UmKpSnBCGo8s5OZb18WV
X-Received: by 2002:a05:6214:2581:b0:499:91e:2fb with SMTP id fq1-20020a056214258100b00499091e02fbmr28150545qvb.59.1662311642219;
        Sun, 04 Sep 2022 10:14:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4pXThVtobppU9X9eUJSxuuVCk6Tq7msI8oDx/JMtg93cLJvjqWexYSW3wu3FA0iGltSaZsb16aIKNwuBwDRaU=
X-Received: by 2002:a05:6214:2581:b0:499:91e:2fb with SMTP id
 fq1-20020a056214258100b00499091e02fbmr28150537qvb.59.1662311642022; Sun, 04
 Sep 2022 10:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220826144049.256134-1-miquel.raynal@bootlin.com> <20220826144049.256134-2-miquel.raynal@bootlin.com>
In-Reply-To: <20220826144049.256134-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 4 Sep 2022 13:13:51 -0400
Message-ID: <CAK-6q+izdwhN=3VcB=oYJjMvkWh4YPWHPcJwmAktXe9FCQ1pAQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 01/11] net: mac802154: Introduce filtering levels
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

On Fri, Aug 26, 2022 at 10:41 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> The 802154 specification details several filtering levels in which the
> PHY and the MAC could be. The amount of filtering will vary if they are
> in promiscuous mode or in scanning mode. Otherwise they are expected to
> do some very basic checks, such as enforcing the frame validity. Either
> the PHY is able to do so, and the MAC has nothing to do, or the PHY has
> a lower filtering level than expected and the MAC should take over.
>
> For now we define these levels in an enumeration, we add a per-PHY
> parameter showing the PHY filtering level and we set it to a default
> value. The drivers, if they cannot reach this level of filtering, should
> overwrite this value so that it reflects what they do. Then, in the
> core, this filtering level will be used to decide whether some
> additional software processing is needed or not.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h |  3 +++
>  include/net/mac802154.h | 24 ++++++++++++++++++++++++
>  net/mac802154/iface.c   |  2 ++
>  3 files changed, 29 insertions(+)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 04b996895fc1..2f29e95da47a 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -223,6 +223,9 @@ struct wpan_phy {
>         atomic_t hold_txs;
>         wait_queue_head_t sync_txq;
>
> +       /* Current filtering level on reception */
> +       unsigned long filtering;
> +

enum ieee802154_filtering_level?

>         char priv[] __aligned(NETDEV_ALIGN);
>  };
>
> diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> index 357d25ef627a..41c28118790c 100644
> --- a/include/net/mac802154.h
> +++ b/include/net/mac802154.h
> @@ -130,6 +130,30 @@ enum ieee802154_hw_flags {
>  #define IEEE802154_HW_OMIT_CKSUM       (IEEE802154_HW_TX_OMIT_CKSUM | \
>                                          IEEE802154_HW_RX_OMIT_CKSUM)
>
> +/**
> + * enum ieee802154_filtering_level - Filtering levels applicable to a PHY
> + *
> + * @IEEE802154_FILTERING_NONE: No filtering at all, what is received is
> + *     forwarded to the softMAC
> + * @IEEE802154_FILTERING_1_FCS: First filtering level, frames with an invalid
> + *     FCS should be dropped
> + * @IEEE802154_FILTERING_2_PROMISCUOUS: Second filtering level, promiscuous
> + *     mode, identical in terms of filtering to the first level at the PHY
> + *     level, but no ACK should be transmitted automatically and at the MAC
> + *     level the frame should be forwarded to the upper layer directly

You have no ACK back in all filtering levels except in
IEEE802154_FILTERING_4_FRAME_FIELDS. It is some kind of mixed thing
between "receive mode and filtering mode" but I am fine with it.

> + * @IEEE802154_FILTERING_3_SCAN: Third filtering level, enforced during scans,
> + *     which only forwards beacons
> + * @IEEE802154_FILTERING_4_FRAME_FIELDS: Fourth filtering level actually
> + *     enforcing the validity of the content of the frame with various checks
> + */
> +enum ieee802154_filtering_level {
> +       IEEE802154_FILTERING_NONE,
> +       IEEE802154_FILTERING_1_FCS,
> +       IEEE802154_FILTERING_2_PROMISCUOUS,
> +       IEEE802154_FILTERING_3_SCAN,
> +       IEEE802154_FILTERING_4_FRAME_FIELDS,
> +};
> +
>  /* struct ieee802154_ops - callbacks from mac802154 to the driver
>   *
>   * This structure contains various callbacks that the driver may
> diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> index 500ed1b81250..4bab2807acbe 100644
> --- a/net/mac802154/iface.c
> +++ b/net/mac802154/iface.c
> @@ -587,6 +587,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
>                 sdata->dev->netdev_ops = &mac802154_wpan_ops;
>                 sdata->dev->ml_priv = &mac802154_mlme_wpan;
>                 wpan_dev->promiscuous_mode = false;
> +               wpan_dev->wpan_phy->filtering = IEEE802154_FILTERING_4_FRAME_FIELDS;
>                 wpan_dev->header_ops = &ieee802154_header_ops;
>
>                 mutex_init(&sdata->sec_mtx);
> @@ -601,6 +602,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
>                 sdata->dev->needs_free_netdev = true;
>                 sdata->dev->netdev_ops = &mac802154_monitor_ops;
>                 wpan_dev->promiscuous_mode = true;
> +               wpan_dev->wpan_phy->filtering = IEEE802154_FILTERING_2_PROMISCUOUS;

In my opinion this is currently IEEE802154_FILTERING_NONE ?

- Alex

