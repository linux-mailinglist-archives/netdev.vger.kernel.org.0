Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B386527AB5
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 00:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiEOWao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 18:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbiEOWan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 18:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 633F6E08
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 15:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652653840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z2afwjIDkeUQKVDWAoCYxsLx7BdV4+9UcZrmq3nNKUg=;
        b=Jfj2bFW4NdfV8TvzMKphfoh0k2zwZuGNejcR/swCIooNOv+I6vqI3CWnOtnRIuWjapL8TK
        paljanxWakx+XNVRGe8tVCsE/ara7KfoMfuNbixYTEExT3CAU6/dmTI3qx31fuPo33SnYX
        xQxXaPTMKaElitGzs7sYWp+T1WbqSe0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-GWhC8iESPs6vg4mBnUQKUQ-1; Sun, 15 May 2022 18:30:39 -0400
X-MC-Unique: GWhC8iESPs6vg4mBnUQKUQ-1
Received: by mail-qv1-f70.google.com with SMTP id w6-20020a05621404a600b00461c740f357so1833431qvz.6
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 15:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z2afwjIDkeUQKVDWAoCYxsLx7BdV4+9UcZrmq3nNKUg=;
        b=laM4NebIylbofYfr9F0oAttEodrDuQHVyNTAFsW5HK/F2XUyzyLBaVdpqJIntgR5sf
         gF7rKgOKFP9AxQt90xBYzdecgaHG2qQYUqGB8uEXEl6QbJ9x+Rt3Cw2bsmpfeSRt2fAJ
         dCpd90gegYUojls6XOwKy0Jdlv234ibvjON1OOisPr4pzhSgMpoNJp0R6q68Gg1N157w
         IQTUNOmO4Up3Km5/994j6LAUNvkIH5wrCYHGOeR+p2GJziqzk1asOSs9OMltbzTWqCHU
         E0krYgTD0xlaHWQh3uwbaFY7sbAPcTK56reOXXqWnP0PnUiaj8NaqZnhLhCV7Mr0gcDX
         ULTg==
X-Gm-Message-State: AOAM532z2Xom4Xsqro5EUEUP6Z99164V3GO5wgYK7ZaGt2XTd8vpzFMK
        YKTmvzlPI4VrGaXBp3BkujpBMadEAlSoQcy/ixihZ3kR59X1r8vTNgr9qIg2tTHLeLL65tSz1ER
        U3nC0J2bzXPQeU00JPfB5qUWZ3YE170ef
X-Received: by 2002:ac8:5a8d:0:b0:2f3:e201:33ab with SMTP id c13-20020ac85a8d000000b002f3e20133abmr13155291qtc.470.1652653838942;
        Sun, 15 May 2022 15:30:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxFsibATT1VNZCLVowjtCcxtN44a/jk9k8zqDWQ8pDqnfc9UMiHUpXkyZ5g3FVLv/PCjl+bguwIFYDuIu50b0=
X-Received: by 2002:ac8:5a8d:0:b0:2f3:e201:33ab with SMTP id
 c13-20020ac85a8d000000b002f3e20133abmr13155285qtc.470.1652653838785; Sun, 15
 May 2022 15:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220512143314.235604-1-miquel.raynal@bootlin.com> <20220512143314.235604-12-miquel.raynal@bootlin.com>
In-Reply-To: <20220512143314.235604-12-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 15 May 2022 18:30:28 -0400
Message-ID: <CAK-6q+iuB4kFOP7RwwaFQ9AbQTijrmXBzDis7wXo2Pat=cW6kA@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 11/11] net: mac802154: Add a warning in the
 slow path
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> In order to be able to detect possible conflicts between the net
> interface core and the ieee802154 core, let's add a warning in the slow
> path: we want to be sure that whenever we start an asynchronous MLME
> transmission (which can be fully asynchronous) the net core somehow
> agrees that this transmission is possible, ie. the device was not
> stopped. Warning in this case would allow us to track down more easily
> possible issues with the MLME logic if we ever get reports.
>
> Unlike in the hot path, such a situation cannot be handled.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/tx.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index a3c9f194c025..d61b076239c3 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -132,6 +132,25 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
>         return ret;
>  }
>
> +static bool ieee802154_netif_is_down(struct ieee802154_local *local)
> +{
> +       struct ieee802154_sub_if_data *sdata;
> +       bool is_down = false;
> +
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +               if (!sdata->dev)
> +                       continue;
> +
> +               is_down = !(sdata->dev->flags & IFF_UP);

Is there not a helper for this flag?

- Alex

