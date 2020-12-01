Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9F72C9771
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 07:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgLAGKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 01:10:09 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:47263 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgLAGKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 01:10:09 -0500
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 5DD1A4400C5;
        Tue,  1 Dec 2020 08:09:26 +0200 (IST)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH ethtool] Improve error message when SFP module is missing
Date:   Tue,  1 Dec 2020 08:09:21 +0200
Message-Id: <4267a91b40ef4dff755c4476757e2b17f48dbf57.1606802961.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETHTOOL_GMODULEINFO request success indicates that SFP cage is present.
Failure of ETHTOOL_GMODULEEEPROM is most likely because SFP module is
not plugged in. Add an indication to the user as to what might be the
reason for the failure.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ethtool.c b/ethtool.c
index 1d9067e774af..6d785f830ffa 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -4856,6 +4856,7 @@ static int do_getmodule(struct cmd_context *ctx)
 	err = send_ioctl(ctx, eeprom);
 	if (err < 0) {
 		perror("Cannot get Module EEPROM data");
+		fprintf(stderr, "SFP module not in cage?\n");
 		free(eeprom);
 		return 1;
 	}
-- 
2.29.2

