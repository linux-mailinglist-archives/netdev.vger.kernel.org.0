Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F427646A2C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLHIMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiLHIL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:11:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D0F56EC9;
        Thu,  8 Dec 2022 00:11:57 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so3891089pjp.1;
        Thu, 08 Dec 2022 00:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2N2lp/nYzc3/wXhfAIotfumlRHeHcPqFEvES9+xaaeQ=;
        b=gP1+m3kPswPioVrjU3TzD/LArW7BTq+dH26Np2d56m9WmJaz2BLlKlIvC3qZr1Lh1G
         C0+1aHH4K9ECPTmNl+/KhGeYFCcLHtk5ajwTiFY3VG8g6ua8rRhheN98arKkSAjh8TWb
         iJurkgVKKH+1vNOeUCiKFXI0E1cTJFx50pBF2Hi45BR3gLKEvwnvs3YWoHFWUyox8iXQ
         /zi+rqb1f4RXjfQkJ9RdjozIlbFbimyDNZKGWcZ45mfm8yhn8NYtmHmkwXXbP6DKD8HW
         kGrytk3CM6t0evt1M/RtCo5ID2jBIJlWuATOk7ojWVFJ49azP8KZ/a4Os6ViMZ0UFj4T
         0ngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2N2lp/nYzc3/wXhfAIotfumlRHeHcPqFEvES9+xaaeQ=;
        b=QVS50Fdxb5QT+vfOW8E0MnVknrx6UcXKlX0dgjc/cU+lgaMB5Mx+J7iDe3DXhqOyAf
         yhk3YjEEeoqZaqCWi2wub26woUOvYKpNnAaEUk5g/7HyM+yQopSZyOD3m4M3mTe/eJEu
         x2GGRS3qEiRpcJEHkmbrgd2BTYvyzKKVBWcjLetz5dW43+QMED6ugQctd9lOWid7F2XE
         eBGv5KhjFUx7r9igvNOLgVV4ozuqQzzT7VJFPit9p38CcC5teNd9x2YDGQlTEE1mdYME
         jPk03iUNpat2eylfCnh3L1XhQgERQyI1vlR0Y3T/El5kX9oOQEg1tRNRM+2s1/mu+BzQ
         ydvQ==
X-Gm-Message-State: ANoB5pmn9NkQbzp9pLr4M1EVks7Oz9bcHuGxt972+2lXrL/H5JBsNOdm
        ddud9i2jcfOeb0N83vRCl40JtthZ3UhtEQ==
X-Google-Smtp-Source: AA0mqf59/JVgIDBQSk3nsNxHSg7sdsisJQ7kG9nYy89CN4lcA0CSgUg/M35D3LQ0VmKGm7dzwQB5gQ==
X-Received: by 2002:a17:902:9b96:b0:189:5a49:36b7 with SMTP id y22-20020a1709029b9600b001895a4936b7mr1729397plp.33.1670487117122;
        Thu, 08 Dec 2022 00:11:57 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b00188f07c9eedsm15735729plm.176.2022.12.08.00.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 00:11:56 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Maximilian Schneider <mws@schneidersoft.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?q?Christoph=20M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH 1/2] can: ucan: remove unused ucan_priv::intf
Date:   Thu,  8 Dec 2022 17:11:41 +0900
Message-Id: <20221208081142.16936-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208081142.16936-1-mailhol.vincent@wanadoo.fr>
References: <20221208081142.16936-1-mailhol.vincent@wanadoo.fr>
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

Field intf of struct ucan_priv is set but never used. Remove it.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/ucan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index ffa38f533c35..dc6158026a60 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -277,7 +277,6 @@ struct ucan_priv {
 
 	/* linux USB device structures */
 	struct usb_device *udev;
-	struct usb_interface *intf;
 	struct net_device *netdev;
 
 	/* lock for can->echo_skb (used around
@@ -1501,7 +1500,6 @@ static int ucan_probe(struct usb_interface *intf,
 
 	/* initialize data */
 	up->udev = udev;
-	up->intf = intf;
 	up->netdev = netdev;
 	up->intf_index = iface_desc->desc.bInterfaceNumber;
 	up->in_ep_addr = in_ep_addr;
-- 
2.25.1

