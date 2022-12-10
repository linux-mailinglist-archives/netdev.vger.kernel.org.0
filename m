Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7341648DAC
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiLJJDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiLJJCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:02:53 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C37ECE29;
        Sat, 10 Dec 2022 01:02:48 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so10654533pjr.3;
        Sat, 10 Dec 2022 01:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WEzFVBHjlChIyGNfSXsDMILSBlIuNZRGCEm4ACWoGj4=;
        b=HWic7uxh/AbV8hV2WgxyQ1vvVbFk3c9MQW68etAkIrbqSURZKMpOn2qZb6dAbgoi1a
         XMrIPccsi/7TegTSxuyL+YDmpo8mpBKQ0Y0B7t5hKwtXEv28bSNCyCIPCyzWGd47BxgK
         ZyiOYKR3kOQsqzMMsJJ7Fp7Zj1Ff/xh+ZJ7dlXo2tcQs4jDDyeSVpbuuqxk/3AUbLEyK
         Y+8DE/1zaN62WK9pclDyqU7X+CBtvzpXRI0sKveDovJhbtL0uyB4y4QmfIanvHfrOL2M
         +TlK6MhMsJBlydYE+SnIXgtiHG+nmv7kthThjhnQ/p05yM5UN8s5fDtJYaZ5RVi7nHQx
         9jQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WEzFVBHjlChIyGNfSXsDMILSBlIuNZRGCEm4ACWoGj4=;
        b=159axLJr1Vxzh3N3duFEk8zGjibABn11CjiLwN33ALIsLxOROeIi7zl4oiEyDYUoWQ
         k0vy7sTBXzgB/rLFiGTK8d0MlWyA6mH6hJXmmVUZTkKR7zcqrq3adNS8OFJNSSlKvq5h
         eOdiNcdp2I/gRt++L4cuWcz5p4uozuIeb9e3M+joEuJg6rEXZz34XMBODEgbKTuf3Tj0
         ysT4+mvuL24BsTW8X25m7jlzezIu8Am4sISQfShDaqUSGC+p3srJBwtVjbbeNnj8Ba9r
         nsMlQWTM6keVwv9dl8NxyqtCuIJpMYLNUbLYrA82Y/iTk0Z6f8J1NhW4Ybdj03dr1Aq4
         thCA==
X-Gm-Message-State: ANoB5plhjlyq0LoAO6gCi9ccgz95m3/Tpc7xzn+7/ynUReoEVeivRqaD
        tvW3z/V+gNL8pjvlcCSO5BM=
X-Google-Smtp-Source: AA0mqf4mXeaGiyUity1h+Dz1k86o2loMg5APpySx38wtpnOdX7COCBVn29+WFsQnZjHF9BoZF2y7xw==
X-Received: by 2002:a17:902:bf46:b0:185:441e:2212 with SMTP id u6-20020a170902bf4600b00185441e2212mr8770457pls.13.1670662967472;
        Sat, 10 Dec 2022 01:02:47 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:02:46 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
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
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 0/9] can: usb: remove all usb_set_intfdata(intf, NULL) in drivers' disconnect()
Date:   Sat, 10 Dec 2022 18:01:48 +0900
Message-Id: <20221210090157.793547-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many of the can usb drivers set their driver's priv data to NULL in
their disconnect function using below pattern:

	struct driver_priv *priv = usb_get_intfdata(intf);

	usb_set_intfdata(intf, NULL);

	if (priv)
                /* ... */

The pattern comes from other drivers which have a secondary interface
and for which disconnect() may be called twice. However, usb can
drivers do not have such secondary interface.

On the contrary, if a driver set the driver's priv data to NULL before
all actions relying on the interface-data pointer complete, there is a
risk of NULL pointer dereference. Typically, this is the case if there
are outstanding urbs which have not yet completed when entering
disconnect().

Finally, even if there is a valid reason to set the driver's priv
data, it would still be useless to do it in usb_driver::disconnect()
because the core sets the driver's data to NULL in [1] (and this
operation is done in within locked context, so that race conditions
should not occur).

The first seven patches fix all drivers which set their usb_interface
to NULL while outstanding URB might still exists. There is one patch
per driver in order to add the relevant "Fixes:" tag to each of them.

The eighth patch removes the check toward the driver data being
NULL. This just reduces the kernel size so no fixes tag here and all
changes are done in bulk in one single patch.

Finally, the last patch removes in bulk the remaining benign calls to
usb_set_intfdata(intf, NULL) in etas_es58x and peak_usb.

N.B. some other usb drivers outside of the can tree also have the same
issue, but this is out of scope of this series.

[1] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497
---
* Changelog *

v1 -> v2

  * add explanation in the cover letter on the origin of this pattern
    and why it does not apply to can usb drivers.

  * v1 claimed that usb_set_intfdata(intf, NULL) sets the
    usb_interface to NULL. This is incorrect, it is the pointer to
    driver's private data which set to NULL. Fix this point of
    confusion in commit message.

  * add a patch to clean up the useless check on the driver's private
    data being NULL.

Vincent Mailhol (9):
  can: ems_usb: ems_usb_disconnect(): fix NULL pointer dereference
  can: esd_usb: esd_usb_disconnect(): fix NULL pointer dereference
  can: gs_usb: gs_usb_disconnect(): fix NULL pointer dereference
  can: kvaser_usb: kvaser_usb_disconnect(): fix NULL pointer dereference
  can: mcba_usb: mcba_usb_disconnect(): fix NULL pointer dereference
  can: ucan: ucan_disconnect(): fix NULL pointer dereference
  can: usb_8dev: usb_8dev_disconnect(): fix NULL pointer dereference
  can: usb: remove useless check on driver data
  can: etas_es58x and peak_usb: remove useless call to
    usb_set_intfdata()

 drivers/net/can/usb/ems_usb.c                  | 16 ++++++----------
 drivers/net/can/usb/esd_usb.c                  | 18 +++++++-----------
 drivers/net/can/usb/etas_es58x/es58x_core.c    |  1 -
 drivers/net/can/usb/gs_usb.c                   |  7 -------
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c   |  9 +--------
 drivers/net/can/usb/mcba_usb.c                 |  2 --
 drivers/net/can/usb/peak_usb/pcan_usb_core.c   |  2 --
 drivers/net/can/usb/ucan.c                     |  8 ++------
 drivers/net/can/usb/usb_8dev.c                 | 13 ++++---------
 9 files changed, 20 insertions(+), 56 deletions(-)

-- 
2.37.4

