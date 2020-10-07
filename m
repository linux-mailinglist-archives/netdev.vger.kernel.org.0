Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00192866AA
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgJGSOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:14:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728859AbgJGSOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602094473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zqttVU40xfCqOOzwdMUTGq47oxpmrAarvgUO/CFxTjs=;
        b=TSsf3sWMelvDjTh9qEHZv6NVWkdlXqY9ie8VJA20O4q/sFB2XGv7zq8qCDHdW68GPw1HBS
        N+75TJZCgJ9AEZNAWfjRpcp3TaLk8G5XzlvW+21ZUjrhDt8s/juDzzaD3D95zqQ8pXkrb9
        dXOZgGsM16G+//Hp8aXmfeGCI5JAmGM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-sRR6H4e8OMCKrENq3Xc3mA-1; Wed, 07 Oct 2020 14:14:32 -0400
X-MC-Unique: sRR6H4e8OMCKrENq3Xc3mA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8040B106B330;
        Wed,  7 Oct 2020 18:14:30 +0000 (UTC)
Received: from hpe-dl360pgen9-01.klab.eng.bos.redhat.com (hpe-dl360pgen9-01.klab.eng.bos.redhat.com [10.16.160.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 603CB55764;
        Wed,  7 Oct 2020 18:14:27 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 4/5] bonding: rename bonding_sysfs_slave.c to _port.c
Date:   Wed,  7 Oct 2020 14:14:08 -0400
Message-Id: <20201007181409.1275639-5-jarod@redhat.com>
In-Reply-To: <20201007181409.1275639-1-jarod@redhat.com>
References: <20201007181409.1275639-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that use of "slave" has been replaced by "port", rename this file too.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/Makefile                                  | 2 +-
 drivers/net/bonding/{bond_sysfs_slave.c => bond_sysfs_port.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/net/bonding/{bond_sysfs_slave.c => bond_sysfs_port.c} (100%)

diff --git a/drivers/net/bonding/Makefile b/drivers/net/bonding/Makefile
index 30e8ae3da2da..2ed0083514a6 100644
--- a/drivers/net/bonding/Makefile
+++ b/drivers/net/bonding/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_BONDING) += bonding.o
 
-bonding-objs := bond_main.o bond_3ad.o bond_alb.o bond_sysfs.o bond_sysfs_slave.o bond_debugfs.o bond_netlink.o bond_options.o
+bonding-objs := bond_main.o bond_3ad.o bond_alb.o bond_sysfs.o bond_sysfs_port.o bond_debugfs.o bond_netlink.o bond_options.o
 
 proc-$(CONFIG_PROC_FS) += bond_procfs.o
 bonding-objs += $(proc-y)
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_port.c
similarity index 100%
rename from drivers/net/bonding/bond_sysfs_slave.c
rename to drivers/net/bonding/bond_sysfs_port.c
-- 
2.27.0

