Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11ABE4BEE8E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbiBVAT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:19:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237788AbiBVATL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:19:11 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3810625C70;
        Mon, 21 Feb 2022 16:18:29 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y5so10268362pfe.4;
        Mon, 21 Feb 2022 16:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sqmDzRebjfXOuXlMcryS3UNB9N3nRJHs/4eRz+Wbrr4=;
        b=ZDb8MOt0Qlds6sX6kcrGKLHGbqGQlGs/k09IXtjrZdRyidr8VkBTyBz2Y28TqeGG0V
         PuwU0+/UVDnJilS6WnCEznxpoeRTfPn/NtWdJlx4GcEmy+jND7gYp1sApCANMyy7qufX
         wWpEv3a45Z85E3FUT+bay+S1uP5lQk/EMAMhqHn7ibr9JKgZeauzHmgAk7GqY1ISxQj1
         2AAFBvJTWno9GeCZVYvfYpIdACubw4PKCd84CiYydU13fHWsfihS8OjM3vSJYBhq0dvn
         0J/uyibKyV5f8pZRQFNrqhjfpl24toJdbHI+YrCyxirkOv9dyuZ1uqJdFrvrtmHQI7Vj
         NfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sqmDzRebjfXOuXlMcryS3UNB9N3nRJHs/4eRz+Wbrr4=;
        b=6FIoofKbZJ1g6P3v2pXuM+l9QxKPIP7kaDf88weUkcia6d6EdwmMgteZm+q3s/L1wN
         O+hSBQKyyjg2qd4xjpW9gw4VNzMuoz5/dVbt0tm4IusaTEnUc/uSqBXfbUHyyeYqCn3M
         tGmjgoPJZstiTpa3W/VPWyFhvhddK0865bE/0FDCLfsTT5Hofzex/xhTu6bHovcWJw9Y
         26rJhU5f9AlcAwncKVp5+LOYbsdMSWfdEBw8U6AvfiWM4b/gr2PBgrI3Nk0EUyEFrhgQ
         b745b5EjgOKMkDfZxJfmxIcF3gcPIuLQVOE1eq+WTMwxxyDqypnLkT9wvbe9S+1SgdR+
         Ntpw==
X-Gm-Message-State: AOAM532+Qqte0UEOUjyUvUarkDQpgG0xFaTHxlyk6GNTBrExbouvYFyR
        Rdu9AdsfHNTkE74wgnrV08kRHgmoEYsvs6tCZD4=
X-Google-Smtp-Source: ABdhPJwBzVlPVdSYUnyE8DCCygZJ+7BruiW9k8D1CHhvwO8NOCwx0byud2EwwF9qj6dYM0Nc+UqKBWiDKl0J9JRKReQ=
X-Received: by 2002:a05:6a00:be5:b0:4e1:9050:1e16 with SMTP id
 x37-20020a056a000be500b004e190501e16mr22516628pfu.78.1645489108727; Mon, 21
 Feb 2022 16:18:28 -0800 (PST)
MIME-Version: 1.0
References: <20220216160500.2341255-1-alvin@pqrs.dk> <20220216160500.2341255-3-alvin@pqrs.dk>
 <20220216233906.5dh67olhgfz7ji6o@skbuf> <CAJq09z6XBQUTBZoQ81Vy3nUc_5QGTF0GH8V-S3bXOw=JpYODvA@mail.gmail.com>
 <87v8xdrjpw.fsf@bang-olufsen.dk>
In-Reply-To: <87v8xdrjpw.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 21 Feb 2022 21:18:17 -0300
Message-ID: <CAJq09z4sbh1zWKd-yiQpeV1H_1fEU6f7uhsH69JmTXcb4YEVZg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

> > The realtek "API/driver" does exactly how the driver was doing. They
> > do have a lock/unlock placeholder, but only in the equivalent
> > regmap_{read,write} functions. Indirect access does not use locks at
> > all (in fact, there is no other mention of "lock" elsewhere), even
> > being obvious that it is not thread-safe. It was just with a DSA
> > driver that we started to exercise register access for real, specially
> > without interruptions. And even in that case, we could only notice
> > this issue in multicore devices. I believe that, if they know about
> > this issue, they might not be worried because it has never affected a
> > real device. It would be very interesting to hear from Realtek but I
> > do not have the contacts.
>
> This is not true, at least with the sources I am reading. As I said in
> my reply to Vladimir, the Realtek code takes a lock around each
> top-level API call. Example:
>
> rtk_api_ret_t rtk_port_phyStatus_get(...)
> {
>     rtk_api_ret_t retVal;
>
>     if (NULL == RT_MAPPER->port_phyStatus_get)
>         return RT_ERR_DRIVER_NOT_FOUND;
>
>     RTK_API_LOCK();
>     retVal = RT_MAPPER->port_phyStatus_get(port, pLinkStatus, pSpeed, pDuplex);
>     RTK_API_UNLOCK();
>
>     return retVal;
> }
>
> Deep down in this port_phyStatus_get() callback, the indirect PHY
> register access takes place.

For the record, in the rtl8367c driver I'm using as reference, there
is no mention of RTK_API_LOCK(). Check here same function you copied:

https://github.com/openwrt/openwrt/blob/aae7af4219e56c2787f675109d9dd1a44a5dcba4/target/linux/mediatek/files-5.10/drivers/net/phy/rtk/rtl8367c/port.c#L1003-L1040

So, this indirect reg access protection is something they added along
the way, probably when they started to use it with SMP systems.

> Kind regards,
> Alvin
