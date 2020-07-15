Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95D322175E
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgGOVwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgGOVwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 17:52:22 -0400
Received: from embeddedor (unknown [201.162.227.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07CB320657;
        Wed, 15 Jul 2020 21:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594849942;
        bh=Rlc9uBbdMh8nPCQYPMiL8KMBXH5cVcB8gLYx9jlnqeY=;
        h=Date:From:To:Cc:Subject:From;
        b=Uw+r3Sy4sRy1EaQREl16g0VNZH5ZmLBQiBuzR6f5/v3MSijrfDu8gXbf41JcJWusm
         yX6ck+MB1iuXDf8+NG8TWBCD7TW5TfcvbBzT239a7RU+eWBXDburG/fTmOej5UhEXg
         JCd0SeL/O9ZlQF2hyTa9pJghV7EFVR06+URmFhE8=
Date:   Wed, 15 Jul 2020 16:57:55 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] wil6210: Avoid the use of one-element array
Message-ID: <20200715215755.GA21716@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One-element arrays are being deprecated[1]. Replace the one-element
array with a simple value type 'u8 reserved'[2], once this is just
a placeholder for alignment.

[1] https://github.com/KSPP/linux/issues/79
[2] https://github.com/KSPP/linux/issues/86

Tested-by: kernel test robot <lkp@intel.com>
Link: https://github.com/GustavoARSilva/linux-hardening/blob/master/cii/0-day/wil6210-20200715.md
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/wil6210/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 9affa4525609..beb53cac329b 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -3086,7 +3086,7 @@ struct wmi_scheduling_scheme_event {
 	/* wmi_sched_scheme_failure_type */
 	u8 failure_type;
 	/* alignment to 32b */
-	u8 reserved[1];
+	u8 reserved;
 } __packed;
 
 /* WMI_RS_CFG_CMDID - deprecated */
-- 
2.27.0

