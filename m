Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B436416E6
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiLCNcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLCNcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:32:19 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5081CB31;
        Sat,  3 Dec 2022 05:32:18 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id a9so7037433pld.7;
        Sat, 03 Dec 2022 05:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Ge/hvb27wH9tqZKTvQJ35IDsoTdlfsfW2RzAv9+gF3w=;
        b=k1d/Uab7IlDLX6e5E27qe0CBQhCi8ZjEvPIIa1x/Usq+VKJF6+mnGK0TX8YOHsljsh
         qjh7BmIzwix8tJ2FT4KpULD2oM7vwMdmRyNK30rZo1j97USnIcNAw621wo580gQswMSQ
         YwkcC+3xRtYXlyf66EfqIwkimsRZMJXDjP5AEBz8mrxJ/prAO2+NPiD3goVnjiK2i44/
         1gajD9iTICYw+9dBUFlOyiPXoEcrhKBAIMJcI5b9ggoYM2Xmr4WzkDcV5zHeG/2BEwME
         5Y8GHBAZLGfXs11By/wtaHn6aTynVdko9MTpNo+7jtEpw717d63USI6tR9gmIpTu/07u
         4Ozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ge/hvb27wH9tqZKTvQJ35IDsoTdlfsfW2RzAv9+gF3w=;
        b=ZbHMGi4454YtL26hGmcT+iFZcPE1X65iVF4JLK4hBA8eCFZ7CvRx4oDl6S85tgvx2t
         dLCw1+PnDGrw/R2wSDOohEfOpwWkghLzwMO/d5H8hRfiiZcqLvVKbFKwrN2a9hCL1JiU
         XP8jDeZxrk1NiH3mL0esYzfK12y1zBgq1mP/wm9ccfe9E/w+Ns0avlRBqvoIquMObO+l
         WalPPvdZ16+Wy7S7brkfy0i5WaXP4+ieoU9p3BiXJwI3b1IXX2riK5kcb2zUEjAKOj7S
         4joliveYhsZc6kv9KrFVozbym7PdPwoQf56Z7y0Eu7934OkjOyZOSH2svfNFtYFSBUXC
         B+aA==
X-Gm-Message-State: ANoB5pnItWg99W5o36LZiYOxe9yKH08FV/qrx3smFFK/nrxh1JiOOW48
        hkkimogVP+9bpyKG+mFuWqg=
X-Google-Smtp-Source: AA0mqf5B214dZKTD3qNQ4z0ukitrTNIFHKRW3JKAkwCYTOVPzjoiTNoTrVfvT46AGxqY8zVloxL69A==
X-Received: by 2002:a17:902:7885:b0:189:1366:fba7 with SMTP id q5-20020a170902788500b001891366fba7mr58575707pll.45.1670074337649;
        Sat, 03 Dec 2022 05:32:17 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm7414472plx.246.2022.12.03.05.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 05:32:17 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?q?Christoph=20M=C3=B6hring?= <cmoehring@christ-es.de>,
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
        =?UTF-8?q?Remigiusz=20Ko=C5=82=C5=82=C4=85taj?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH 0/8] can: usb: remove all usb_set_intfdata(intf, NULL) in drivers' disconnect()
Date:   Sat,  3 Dec 2022 22:31:51 +0900
Message-Id: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The core sets the usb_interface to NULL in [1]. Also setting it to
NULL in usb_driver::disconnects() is at best useless, at worse risky.

Indeed, if a driver set the usb interface to NULL before all actions
relying on the interface-data pointer complete, there is a risk of
NULL pointer dereference. Typically, this is the case if there are
outstanding urbs which have not yet completed when entering
disconnect().

If all actions are already completed, doing usb_set_intfdata(intf,
NULL) is useless because the core does it at [1].

The first seven patches fix all drivers which set their usb_interface
to NULL while outstanding URB might still exists. There is one patch
per driver in order to add the relevant "Fixes:" tag to each of them.

The last patch removes in bulk the remaining benign calls to
usb_set_intfdata(intf, NULL) in etas_es58x and peak_usb.

N.B. some other usb drivers outside of the can tree also have the same
issue, but this is out of scope of this.

[1] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Vincent Mailhol (8):
  can: ems_usb: ems_usb_disconnect(): fix NULL pointer dereference
  can: esd_usb: esd_usb_disconnect(): fix NULL pointer dereference
  can: gs_usb: gs_usb_disconnect(): fix NULL pointer dereference
  can: kvaser_usb: kvaser_usb_disconnect(): fix NULL pointer dereference
  can: mcba_usb: mcba_usb_disconnect(): fix NULL pointer dereference
  can: ucan: ucan_disconnect(): fix NULL pointer dereference
  can: usb_8dev: usb_8dev_disconnect(): fix NULL pointer dereference
  can: etas_es58x and peak_usb: remove useless call to
    usb_set_intfdata()

 drivers/net/can/usb/ems_usb.c                    | 2 --
 drivers/net/can/usb/esd_usb.c                    | 2 --
 drivers/net/can/usb/etas_es58x/es58x_core.c      | 1 -
 drivers/net/can/usb/gs_usb.c                     | 2 --
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 --
 drivers/net/can/usb/mcba_usb.c                   | 2 --
 drivers/net/can/usb/peak_usb/pcan_usb_core.c     | 2 --
 drivers/net/can/usb/ucan.c                       | 2 --
 drivers/net/can/usb/usb_8dev.c                   | 2 --
 9 files changed, 17 deletions(-)

-- 
2.37.4

