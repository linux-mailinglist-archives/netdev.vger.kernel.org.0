Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90E74AB281
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 22:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245258AbiBFV7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 16:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiBFV7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 16:59:02 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D203C06173B;
        Sun,  6 Feb 2022 13:59:01 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id bg21-20020a05600c3c9500b0035283e7a012so7410772wmb.0;
        Sun, 06 Feb 2022 13:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iVLO6CIU9ZokS5PeDM8VP0GTPDsJCx2YjVykQBICzsU=;
        b=P7FX3jQd/AYRpQM3Mwmgtbqu0sc+cwGwGPvTW7H4BYUkyo6VPTFEl0LhH8O/QjFRT6
         eWi42ZZYVYX0suNxJJNwjQB4OsKO+V+oHsN74788eZRYiMYutTiRdohJXz0JsjjYv8C9
         Kh5alNqeL6bMbvDTFcV6tzK1GFsXBOqBqFuz02od4CLlzYpxfI37yxWz7GkYevNWic7C
         r6N+0jpxtSL6sb/gjjYtQ/ZiUYCQLwkz0+UbhrHUluIFtGbN8Io2tN75VOZiDhiE6p3H
         gG0P2TtLe6Qy8xr7qPZTxB65ftkfAhIifHR+FtKWF7WqTZ0JEl5EDhf8XoSyhNzaP1GQ
         eOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iVLO6CIU9ZokS5PeDM8VP0GTPDsJCx2YjVykQBICzsU=;
        b=bup16XAXhLt+AkG3c/f150jCrsmLGIz0kstOowuLoceoBrlPJqM2/ESGb+MqaXlUtc
         bOYLaJey9a2ucLmgP+tZeHiSlZSG6t1An9xsaFqf02lS6asEJEOCKqjicfMK4J6F0zXT
         hZROdDkWMWnD9e3nmu83f08CR1CHLbnd+F27pfUoA+CZrYvrpASznFiksrcwu2TnoB15
         M9dZH+uMXr1CttipCBVlQsbe2ZNfQEGzyPQytGNVvY8RuNUA390WvVDWlQCtppXi6mWj
         skZsGvpJnxAVw5+7IRuBIgU4U/2aeUy86+gI287xWY5OKDwpjR/3C8l9PCGTQMev1Br9
         oZIA==
X-Gm-Message-State: AOAM533H5TOhCo211Z3XVSWe4JZIVQWR40R+mrSCKFCBOAfMP1cFvzl/
        mmXZOIh4ZR6rmf5sUDFqiFF/W0S8IPAof2bFbMs=
X-Google-Smtp-Source: ABdhPJx46HKULo3owJTZVRlXXAI224iD6KLw+xQPBvtzwXtmfnR6LImq1ZlAGO8B/9ADGgBFHJ+t2rtHjd67bn/Ttq4=
X-Received: by 2002:a7b:ce90:: with SMTP id q16mr6221032wmj.91.1644184739543;
 Sun, 06 Feb 2022 13:58:59 -0800 (PST)
MIME-Version: 1.0
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220201180629.93410-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 6 Feb 2022 16:58:48 -0500
Message-ID: <CAB_54W6BtEqfRmC2QUyk9ny+D_XZEPLfb8LdpqPorjNbg4hwQw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 0/4] ieee802154: Improve durations handling
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Feb 1, 2022 at 1:06 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> These patches try to enhance the support of the various delays by adding
> into the core the necessary logic to derive the actual symbol duration
> (and then the lifs/sifs durations) depending on the protocol used. The
> symbol duration type is also updated to fit smaller numbers.
>
> Having the symbol durations properly set is a mandatory step in order to
> use the scanning feature that will soon be introduced.
>
> Changes since v2:
> * Added the ca8210 driver fix.
> * Fully dropped my rework of the way channels are advertised by device
>   drivers. Adapted instead the main existing helper to derive durations
>   based on the page/channel couple.
>
> Miquel Raynal (4):
>   net: ieee802154: ca8210: Fix lifs/sifs periods
>   net: mac802154: Convert the symbol duration into nanoseconds
>   net: mac802154: Set durations automatically
>   net: ieee802154: Drop duration settings when the core does it already
>

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks Stefan. I agree "net: ieee802154: ca8210: Fix lifs/sifs
periods" should go into "wpan".

- Alex
