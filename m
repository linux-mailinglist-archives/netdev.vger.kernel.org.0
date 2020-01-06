Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949AF131A0D
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgAFVFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:05:22 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32790 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgAFVFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:05:21 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so27419411pgk.0
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 13:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QRvRJ17yAgfqPGiRV0RGDzXVBVOSCZZmRgPS4VPHyZM=;
        b=Ox0dzOrp/RMLEy1cV7wN+t5WGHnvE92dBze//Kcmsifp7lVeT2aEcuzpNFbyYHbZ+G
         Q21o7JcBEe+wbJpOYALRZEfDKqpI01erR0bEBPusDseKkl6ecR2aNUCR7YN5ilNLw/6j
         Z7fN12cTlxSLMUJWLEkDMEz8ZCPBsFPEqw250dt7L825976MduyRNKq1Ldwq3TM8Krl8
         Blu+q1ehnUSnwfjuCPvjI8dZFInvUE6lCh8Z/G51V3EU7en/DalxuI91WsrGNqfW9qUl
         FsMgktTn1npLC+Itit42FIcTuRUM3JTj5fNHnRggvU2BnE16BYLpcJaSqg1XLPvviQhj
         vobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QRvRJ17yAgfqPGiRV0RGDzXVBVOSCZZmRgPS4VPHyZM=;
        b=kpWaqmjEgaRWa7a6x/UkGC1Ku2RmiE7u2LcOCdijM5SUCGWWArfAR8IsCB41KaDyn7
         exXCXp1Te7+4Bz00mpxCWRyBtV+4F+NSM90bfcusP9YVLfgkrb2SJTc1SsMRYNzFzYO7
         gKhR5ABjLf7qVkHh7HgF6YIuyrotwNoogwZPkwo5V+c4qxLVHyidq30sg0AWP1PxmP0r
         IpQDoe/ap8s9ks4WvHkwQ78s+Q4slDGvcWFy7y5xVYHIGVF5DGfOIB0BauY+xo5bIzSc
         ipubjih4qwa2lRxl9kLM43CMQ9g7U+UDjt2z0JYrxw+Q+4xdmdNGTyIMzhwBhamxS1qD
         XHLA==
X-Gm-Message-State: APjAAAVjFYAkL4AXH9lM9+X6vP0YRmzE8DbcWnMnFsayS43MDVpnbl3h
        gbRUJuiKWpo7QFxrLmlQc058xwZnzXo=
X-Google-Smtp-Source: APXvYqyN1dn4Fsh4CrBo84YYcvNESUAwDAPwAsBOPPZTYG5PhSzCjeaqoYxOCZByyEIgSDDg52/Cbg==
X-Received: by 2002:aa7:98d0:: with SMTP id e16mr107622520pfm.77.1578344720012;
        Mon, 06 Jan 2020 13:05:20 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p16sm63183003pfq.184.2020.01.06.13.05.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 13:05:19 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/4] ionic: drop use of subdevice tags
Date:   Mon,  6 Jan 2020 13:05:09 -0800
Message-Id: <20200106210512.34244-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106210512.34244-1-snelson@pensando.io>
References: <20200106210512.34244-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subdevice concept is not being used in the driver, so
drop the references to it.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index ca0b21911ad6..bb106a32f416 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -19,10 +19,6 @@ struct ionic_lif;
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
 
-#define IONIC_SUBDEV_ID_NAPLES_25	0x4000
-#define IONIC_SUBDEV_ID_NAPLES_100_4	0x4001
-#define IONIC_SUBDEV_ID_NAPLES_100_8	0x4002
-
 #define DEVCMD_TIMEOUT  10
 
 struct ionic_vf {
-- 
2.17.1

