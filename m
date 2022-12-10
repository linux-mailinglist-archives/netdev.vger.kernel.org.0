Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EC8648DA7
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLJJC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLJJC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:02:27 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE5526F9;
        Sat, 10 Dec 2022 01:02:24 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso10679501pjt.0;
        Sat, 10 Dec 2022 01:02:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mECpz9PO560rZEtmlTIIyNmHohjFDYglNrHTBIHy5Mk=;
        b=bnWMSY42zrmurVmUXgTIz11OP6tZViFo9gF79h6m1ynb1eiQD2XUFVdaB4p/p+Ks1s
         LzuFwNxyUxhdZfuKLXd3HRG9ZsGgAk3MQlCXkc3sCD2RNI2I73ZSnIEiMmZ95hfvdRXy
         7JfWVaPHRoG4AgIAF8jwEaCZ5jDKYLwfj+Kqh3itelfIkKvcPn+TboTJwv0DicpZt9qG
         RrP1/9hSiUs1ftqbfmp69veeMZnmTdIMd9trjG6DofpCYCX1d44yQuwMfKIcBaBjefah
         9kO7HWHjx2BAKliLGIUgqmtmvx2zs9nJzAeSxERvVjXnc/KggCoPAhLtrO0rLQQ4Ysto
         OldQ==
X-Gm-Message-State: ANoB5plMH4YZ2hLy0K8DyyUcwuiaRoTI7ZjOTLGsmzIE/qE7wWvUAdF4
        bvCEr6ToZ8BVzYJ1TYC0VJGcVRJIoc/ee7aAyD8=
X-Google-Smtp-Source: AA0mqf5XfADBHlEewgMAO0oHreDg7KDhD3vofPsPaEMatJptU1XF4MljYrUhZIoRRaAEdgM7zROcqGxM2JQKP5t9/k4=
X-Received: by 2002:a17:90b:1293:b0:21c:bc8b:b080 with SMTP id
 fw19-20020a17090b129300b0021cbc8bb080mr1821276pjb.19.1670662943811; Sat, 10
 Dec 2022 01:02:23 -0800 (PST)
MIME-Version: 1.0
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <9493232b-c8fa-5612-fb13-fccf58b01942@suse.com> <CAMZ6RqJejJCOUk+MSvxjw9Us0gYhTuoOB4MUTk9jji6Bk=ix3A@mail.gmail.com>
 <b5df2262-7a4f-0dcf-6460-793dad02401d@suse.com> <CAMZ6RqL9eKco+fAMZoQ6X9PNE7dDK3KnFZoMCXrjgvx_ZU8=Ew@mail.gmail.com>
 <9d1fac95-d7e0-69a5-c6c1-9df5bd90bcb0@suse.com>
In-Reply-To: <9d1fac95-d7e0-69a5-c6c1-9df5bd90bcb0@suse.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 10 Dec 2022 18:02:10 +0900
Message-ID: <CAMZ6RqKvJWBWOdCEve9cE9xGuVxTicZjn-5PROHsMdHn=eMqng@mail.gmail.com>
Subject: Re: [PATCH 0/8] can: usb: remove all usb_set_intfdata(intf, NULL) in
 drivers' disconnect()
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?Q?Christoph_M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        =?UTF-8?B?UmVtaWdpdXN6IEtvxYLFgsSFdGFq?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks Alan and Oliver for your patience, really appreciated. And
sorry that it took me four messages to realize my mistake.

I will send a v2 right now.
