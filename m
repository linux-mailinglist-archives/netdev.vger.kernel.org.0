Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3DA25F071
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 22:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIFUGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 16:06:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52196 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726286AbgIFUF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 16:05:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599422757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=22GEKdlDGamdrcCdfxHjJVYzr9HNsngs+YDvy62bHWk=;
        b=CNuzeaXVhnItVa1D5Fdn3cTleo3w6ysgPhmPOecqi67RmVHru+DgB5XSCY7kAaQ5+P2Pkd
        xmeftGel0JdL8VapHlzRA8kf2PL2AN1r9OcoEC8GLj5T0pKzV8IhSln2ta2pRpU6V0VLwY
        0lPoCI+29hYLg2+exxO6xaQKJ6qUVaI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-5Hvm2-z4OF6dvCVzchFGkA-1; Sun, 06 Sep 2020 16:05:55 -0400
X-MC-Unique: 5Hvm2-z4OF6dvCVzchFGkA-1
Received: by mail-qt1-f200.google.com with SMTP id l5so7820791qtu.20
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 13:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=22GEKdlDGamdrcCdfxHjJVYzr9HNsngs+YDvy62bHWk=;
        b=r5ip4fpWE+MSP605SlFjPCoTmhom1ktLjjoSTJ9fBw3l/ejGCxvs/wFy8ddh0GGy8d
         2tkiCDE6zSFcsYQ9D8rJAqtiYP+87vvceyJbBcwPMsmdCo07Wq0AKK0gkF/5E9wsdMJH
         RFuq9wB/tYmcfqm2+7PX4U7ChheUKajOdFbYzRQKyUM2Zqvl78+DhcQ0XiO7LUiTgE4k
         /vvqyRkud9GkhqPCub6Zc1vFCdYp4v82DOxoBYLO04fVDu8vM6SPubRR2sZoyMk/wvLu
         mwFav7H0FP0ireAm2d9lAqNQHAjtbBCRCAXITFS6pADaGXc1EHjWDLjWrHnxkyBuq0oM
         sM9A==
X-Gm-Message-State: AOAM531nPCRmcz3QlMYInY++emJY7D6J9Ads0KOI0l+ZXVqI0OrqvUdi
        6ZnuqL9lV8klB9VRWBE3vsBhVCdOT5GJ5Dg3oxJoqjma6Z8KU5I9Xdr4aewmbJk5FM4W5V7Jyzd
        XaXA3+JOgyS6y9E1k
X-Received: by 2002:ac8:310c:: with SMTP id g12mr18097174qtb.281.1599422755468;
        Sun, 06 Sep 2020 13:05:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUi6FjudeZbwzO+c/2NwD6TWr2lq6erqaKfWv9r02JiQWr5InA3Ycp5fEU/mKbzgvlBSRZsA==
X-Received: by 2002:ac8:310c:: with SMTP id g12mr18097140qtb.281.1599422755202;
        Sun, 06 Sep 2020 13:05:55 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id x3sm3727737qta.53.2020.09.06.13.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 13:05:54 -0700 (PDT)
From:   trix@redhat.com
To:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, natechancellor@gmail.com, ndesaulniers@google.com,
        bzhao@marvell.com, dkiran@marvell.com, frankh@marvell.com,
        linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] mwifiex: remove function pointer check
Date:   Sun,  6 Sep 2020 13:05:48 -0700
Message-Id: <20200906200548.18053-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analyzer reports this problem

init.c:739:8: warning: Called function pointer
  is null (null dereference)
        ret = adapter->if_ops.check_fw_status( ...
              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In mwifiex_dnld_fw, there is an earlier check for check_fw_status(),
The check was introduced for usb support at the same time this
check in _mwifiex_fw_dpc() was made

	if (adapter->if_ops.dnld_fw) {
		ret = adapter->if_ops.dnld_fw(adapter, &fw);
	} else {
		ret = mwifiex_dnld_fw(adapter, &fw);
	}

And a dnld_fw function initialized as part the usb's
mwifiex_if_ops.

The other instances of mwifiex_if_ops for pci and sdio
both set check_fw_status.

So the first check is not needed and can be removed.

Fixes: 4daffe354366 ("mwifiex: add support for Marvell USB8797 chipset")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/marvell/mwifiex/init.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 82d69bc3aaaf..f006a3d72b40 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -695,14 +695,12 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 	int ret;
 	u32 poll_num = 1;
 
-	if (adapter->if_ops.check_fw_status) {
-		/* check if firmware is already running */
-		ret = adapter->if_ops.check_fw_status(adapter, poll_num);
-		if (!ret) {
-			mwifiex_dbg(adapter, MSG,
-				    "WLAN FW already running! Skip FW dnld\n");
-			return 0;
-		}
+	/* check if firmware is already running */
+	ret = adapter->if_ops.check_fw_status(adapter, poll_num);
+	if (!ret) {
+		mwifiex_dbg(adapter, MSG,
+			    "WLAN FW already running! Skip FW dnld\n");
+		return 0;
 	}
 
 	/* check if we are the winner for downloading FW */
-- 
2.18.1

