Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3993662EFD7
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241180AbiKRIoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241597AbiKRIoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:44:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D6274CE1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668760987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0xP3BnY5Oo5jPdgLVmQFsxOPOuyQzhEeHptpu8Dd8M0=;
        b=BErcx5rh0zfGUAXtkwynv7978AqfETZAXpmQQDT5EISq04PAuNeXafnFGJbLCtYYTspDyL
        lubPo597E7YttLvYuunngSwVXUQIItEKoY2zF3RkOW8lNElbqZ3idU2Iknh3SH6e4cunTU
        Qod87WjzXqcL6QCZh3WJajzjCTVf2W0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-usdEjcDrMzC56z2QGN2WKQ-1; Fri, 18 Nov 2022 03:43:02 -0500
X-MC-Unique: usdEjcDrMzC56z2QGN2WKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4A2085A59D;
        Fri, 18 Nov 2022 08:43:01 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7098F1415119;
        Fri, 18 Nov 2022 08:43:00 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Jiri Kosina <jkosina@suse.cz>
Cc:     linux-bluetooth@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH hid-next] HID: fix BT_HIDP Kconfig dependencies
Date:   Fri, 18 Nov 2022 09:42:54 +0100
Message-Id: <20221118084254.1880165-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If HID_SUPPORT is not selected, BT_HIDP should not be available, simply
because we disallowed the HID bus entirely.

Add a new depends and actually revert this file back to where it was 10
years ago before it was changed by commit 1f41a6a99476 ("HID: Fix the
generic Kconfig options").

Fixes: 25621bcc8976 ("HID: Kconfig: split HID support and hid-core compilation")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/202211181514.fLhaiS7o-lkp@intel.com/
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 net/bluetooth/hidp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
index 14100f341f33..6746be07e222 100644
--- a/net/bluetooth/hidp/Kconfig
+++ b/net/bluetooth/hidp/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config BT_HIDP
 	tristate "HIDP protocol support"
-	depends on BT_BREDR && INPUT
+	depends on BT_BREDR && INPUT && HID_SUPPORT
 	select HID
 	help
 	  HIDP (Human Interface Device Protocol) is a transport layer
-- 
2.38.1

