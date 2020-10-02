Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4893B2819ED
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388459AbgJBRlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:41:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388264AbgJBRlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 13:41:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601660475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zqttVU40xfCqOOzwdMUTGq47oxpmrAarvgUO/CFxTjs=;
        b=NteParaR7mjfDA9N7UIqGAZrPKLtlFyl62V/qUt7rWqSFMRmIlDQyCVnsEV4Lu9lf9QoOZ
        ERHkPE8A5Lko4Ml2s/Px3EPX5w/OazsryFDTl+AOttgTtBTPsfSTSTsATFC7NX2VUFJj7R
        Y4dP53bQu4Lrj3wbeS97jB/ss4rI7lU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-TnbMkzffPZytYcArEzG8Dg-1; Fri, 02 Oct 2020 13:41:11 -0400
X-MC-Unique: TnbMkzffPZytYcArEzG8Dg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F5CB101FFC9;
        Fri,  2 Oct 2020 17:41:06 +0000 (UTC)
Received: from hpe-dl360pgen9-01.klab.eng.bos.redhat.com (hpe-dl360pgen9-01.klab.eng.bos.redhat.com [10.16.160.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F8471002C2F;
        Fri,  2 Oct 2020 17:40:53 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/6] bonding: rename bonding_sysfs_slave.c to _port.c
Date:   Fri,  2 Oct 2020 13:39:59 -0400
Message-Id: <20201002174001.3012643-5-jarod@redhat.com>
In-Reply-To: <20201002174001.3012643-1-jarod@redhat.com>
References: <20201002174001.3012643-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

