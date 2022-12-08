Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01AC646A2A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiLHIMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiLHIL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:11:56 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF89555CA4;
        Thu,  8 Dec 2022 00:11:54 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cm20so931247pjb.1;
        Thu, 08 Dec 2022 00:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=PRliwF0o7oV85eapVBALB7fOMkMAiSkW6Oy/YS7Oo7U=;
        b=lATRXt6dkZH4gt5YhEeSt3x8Ghu6sSs3KcRDI+4ekQOB6pyiwssZyJfKLrqfQEJwbX
         H6oHmzvJEss7JQbYUADpVr9RQSmwRI1nqmg+kkgvmUBf6EynopgFdwzUgGKYCpcuq1Nm
         lo2d9Q7vSLrNyRaeLeGkYOWwhBqlgjP+kdCJsoItvTA4TP12Fo6NkfhCT6jprPFchxZV
         oGPB4MXBT42laQQxOIcPFoQdTlYf3P1C+JP+AmmV3hc8YyOAYYdZTyHGrEfsRPxk6G17
         aUK+amu4RPoHGOday6Uf2ZmmM5mZ2lnHY0gOhkin4p+GTfPkuxscKC+MbrN2XdvZn9Pp
         kxuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRliwF0o7oV85eapVBALB7fOMkMAiSkW6Oy/YS7Oo7U=;
        b=ESy191y8TjdZnq3s9v0nqDf650jqqGMACrbtOADaw6rLde35AH8IcZ3P3rlZ773ta1
         ZUGheeAyq8NcCaNywRQbaGSRmZkKItquymy2SOXVcMiq/JPsAPzefsLD0BpNd4ntYktQ
         y9Wnrv6Xx9BkFjKyiNyKxsvl45v55MhNMcGqwnPuH0UTCmavBeBm9fxhNle6nHzZbnsZ
         8V1E13xQO+WsbgSnSEqt63eSFlGVpyj9aucDQ+1cEPXDepS7/pIuTknkhqnjB3FDE6fW
         M123779FtGEjZ6CO45U72mdqBxLHJgKCj7SsD6Qh4N+/HALS/V6aj9Aq67BG5sC0Xdvl
         pQUg==
X-Gm-Message-State: ANoB5pl5J/xy3lEeKoHVhND9G8sdBtb6hKIQah7F3y8nfJtp2Kav5z4U
        29g9JZsrrA751mLjYbFVZNY=
X-Google-Smtp-Source: AA0mqf6OoB08efjyc4G4b7F2n3d5oULcT2PESghwoLBvau0HvIDl2PuC9FAFMkSCke2gzJE+TaeJQA==
X-Received: by 2002:a17:903:268f:b0:189:dfb0:d380 with SMTP id jf15-20020a170903268f00b00189dfb0d380mr1842759plb.33.1670487114241;
        Thu, 08 Dec 2022 00:11:54 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b00188f07c9eedsm15735729plm.176.2022.12.08.00.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 00:11:53 -0800 (PST)
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
Subject: [PATCH 0/2] can: usb: remove pointers to struct usb_interface in device's priv structures
Date:   Thu,  8 Dec 2022 17:11:40 +0900
Message-Id: <20221208081142.16936-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
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

The gs_can and ucan drivers keep a pointer to struct usb_interface in
their private structure. This is not needed. For gs_can the only use
is to retrieve struct usb_device, which is already available in
gs_usb::udev. For ucan, the field is set but never used.

Remove the struct usb_interface fields and clean up.

Vincent Mailhol (2):
  can: ucan: remove unused ucan_priv::intf
  can: gs_usb: remove gs_can::iface

 drivers/net/can/usb/gs_usb.c | 29 +++++++++--------------------
 drivers/net/can/usb/ucan.c   |  2 --
 2 files changed, 9 insertions(+), 22 deletions(-)

-- 
2.25.1

