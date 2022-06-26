Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C0555AE3C
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 04:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiFZC30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 22:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiFZC3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 22:29:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1D31140BC
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 19:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656210562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rJjFrVqOIs6fBbktNSds93e5JBItTxxPnrIffy3Upo8=;
        b=IM83VtBkv4BVCC89yA5fwmMyH3cW6l3BZQd3aBN0gvJqocyiDxKk57EToNieQCGvEHH/bN
        otwogdh3u2VrrYOjoLStw1sLuOumqMYUeCm4oa33M7zaY+xy6LtDyrHE4ZS+2tTFu59drU
        jUNni527/AijZGwPIXY7UT6GbU3KoEM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-xRCs7_vBMY-6kW7PRh2jOw-1; Sat, 25 Jun 2022 22:29:19 -0400
X-MC-Unique: xRCs7_vBMY-6kW7PRh2jOw-1
Received: by mail-qv1-f72.google.com with SMTP id x18-20020a0ce252000000b004703cbb92ebso6173122qvl.21
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 19:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJjFrVqOIs6fBbktNSds93e5JBItTxxPnrIffy3Upo8=;
        b=x78p3Km4zauuj2JH9Dt2fjKxP8hztB7ElwUlcLQ3OkRPkUU0vRTKQoI1zMpoysS/H6
         Zzlqq3zqg8cSqMkNkGip3ZxCbFHWbNAFDf5a7NFjJk9gTQe+slioadNnMyEhw2pgVwWX
         u5ykl2zx6C92R4ohHwVMrX8O/n0Uzz78oky8Bi47qTDWGfgzco9BLa+cCEhyyAl6I/1/
         j05IjDZ1wFXm6F+H7/Qm7aec13xwFHXOyIi2sYSxAQhpl3edePgbx8aOpoNTHx2l3t6y
         4/kf+HeSdAvQTCYhL2VQZZ1tj+5eMAAOeRMJSxFjc5hC9TRxu3XAwrRa88EQCSJg8GLL
         fTzw==
X-Gm-Message-State: AJIora8ihXKxQsHm1mzNmbyfhTDoJLCOZbePuNNizGJ4P1gQanEaFkVF
        mZYjCjev/x/MNw8Hv25fXqofmG2lb3Xkn9XhshV4Y9oLf1ZMEyu+Rw5mar/KQlrQbEbkjgX5x8a
        P4VfWpPFJQm1yNv769WlGUYwQul9wjvhE
X-Received: by 2002:a05:622a:1314:b0:306:657d:5f72 with SMTP id v20-20020a05622a131400b00306657d5f72mr4934475qtk.339.1656210559094;
        Sat, 25 Jun 2022 19:29:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vqekAitkKWhhmXbbZUlHcuyp5F6ZXHfCLZj9d+7bCjelcEP//yNWVgEk4YxzJbNw+dd1NGWxD7TpZ0EGapr4Q=
X-Received: by 2002:a05:622a:1314:b0:306:657d:5f72 with SMTP id
 v20-20020a05622a131400b00306657d5f72mr4934465qtk.339.1656210558918; Sat, 25
 Jun 2022 19:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220620134018.62414-1-miquel.raynal@bootlin.com> <20220620134018.62414-3-miquel.raynal@bootlin.com>
In-Reply-To: <20220620134018.62414-3-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 25 Jun 2022 22:29:08 -0400
Message-ID: <CAK-6q+jAhikJq5tp-DRx1C_7ka5M4w6EKUB_cUdagSSwP5Tk_A@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 2/4] net: ieee802154: Add support for inter
 PAN management
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
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 20, 2022 at 10:26 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Let's introduce the basics for defining PANs:
> - structures defining a PAN
> - helpers for PAN registration
> - helpers discarding old PANs
>

I think the whole pan management can/should be stored in user space by
a daemon running in background. This can be a network manager as it
listens to netlink events as "detect PAN xy" and stores it and offers
it in their list to associate with it.

We need somewhere to draw a line and I guess the line is "Is this
information used e.g. as any lookup or something in the hot path", I
don't see this currently...

- Alex

