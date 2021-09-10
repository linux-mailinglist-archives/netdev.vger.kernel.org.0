Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63CA406A93
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 13:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhIJLQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 07:16:25 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59648
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232513AbhIJLQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 07:16:23 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 893EC40199;
        Fri, 10 Sep 2021 11:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631272511;
        bh=cjPpya8twFJF6CcLRkfsJIkT17XF6AkIODgivDV6meE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=dYiyxGTAHHfIUbTT0v6/0mY1fjl+9nGCTts5R7pKEtlUIzS4JVY2yDn0FnUMOU+T0
         Ssv8yqWzRiNxo3Kqv80b+KiI4/oLeqUEE0kfdFa6kFTox3j8xQK8j04qqkDSmiC8jK
         s6T9V30QIjJ9MwcHQXtA1Ok9Hp2TrMuL60IWXxaxYjhoY6EtYOUiCpcZl2xe4TBmm3
         dlQVCbSzzXlwKfFWoHTzd+SXPy+6eLmELijvsahoUz/zMUaOX7JJXa9CrwboxC8To/
         sjXOraq18Sn4EaN/xrJI97ECARutBfsTqTDDMRM/VrWl4llpVh/1UAm2Lbt32zhNbn
         vTFzK7Pcj6loQ==
From:   Colin King <colin.king@canonical.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qlcnic: Remove redundant initialization of variable ret
Date:   Fri, 10 Sep 2021 12:15:11 +0100
Message-Id: <20210910111511.33796-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never read, it
is being updated later on. The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index 0a2f34fc8b24..27dffa299ca6 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -1354,10 +1354,10 @@ static int qlcnic_83xx_copy_fw_file(struct qlcnic_adapter *adapter)
 	struct qlc_83xx_fw_info *fw_info = adapter->ahw->fw_info;
 	const struct firmware *fw = fw_info->fw;
 	u32 dest, *p_cache, *temp;
-	int i, ret = -EIO;
 	__le32 *temp_le;
 	u8 data[16];
 	size_t size;
+	int i, ret;
 	u64 addr;
 
 	temp = vzalloc(fw->size);
-- 
2.32.0

