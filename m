Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9E23B9FC8
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhGBL37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:29:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58721 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhGBL36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 07:29:58 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lzHKK-0003x3-Lf; Fri, 02 Jul 2021 11:27:20 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iavf: remove redundant null check on key
Date:   Fri,  2 Jul 2021 12:27:20 +0100
Message-Id: <20210702112720.16006-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The null check on pointer key has already been performed at the
start of the function and this leads to a return of -EOPNOTSUPP.
The second null check on key is therefore always false, it is
redundant and can be removed.

Addresses-Coverity: ("Logically dead code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index af43fbd8cb75..70193d8d54ed 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1873,8 +1873,7 @@ static int iavf_set_rxfh(struct net_device *netdev, const u32 *indir,
 	if (!indir)
 		return 0;
 
-	if (key)
-		memcpy(adapter->rss_key, key, adapter->rss_key_size);
+	memcpy(adapter->rss_key, key, adapter->rss_key_size);
 
 	/* Each 32 bits pointed by 'indir' is stored with a lut entry */
 	for (i = 0; i < adapter->rss_lut_size; i++)
-- 
2.31.1

