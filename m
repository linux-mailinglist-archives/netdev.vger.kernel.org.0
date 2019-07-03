Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C926E5DBF8
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfGCCSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfGCCSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 22:18:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ED2721882;
        Wed,  3 Jul 2019 02:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120333;
        bh=mMmFreGYxbftWf4XSVYFu9p4ZsjbHFSeyPDPQgZBY2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP8GHCMNHB3fyxmHf2up0OA3yeR7HlOfgtCHyY34SiuANXfC9bCSVfh+bjQ9ZMigJ
         Ik/6dX22H6y28Ckrfxa8WU7qd3ZcFC2+NsK/Jlkqn3sTwcW9Xh/H+XaQZV+7JNaER9
         Xn2uYOhv9OD6cSTik6K4mpGdEq2f7+ZMAVKVJqKg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/8] ppp: mppe: Add softdep to arc4
Date:   Tue,  2 Jul 2019 22:18:43 -0400
Message-Id: <20190703021847.18542-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021847.18542-1-sashal@kernel.org>
References: <20190703021847.18542-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit aad1dcc4f011ea409850e040363dff1e59aa4175 ]

The arc4 crypto is mandatory at ppp_mppe probe time, so let's put a
softdep line, so that the corresponding module gets prepared
gracefully.  Without this, a simple inclusion to initrd via dracut
failed due to the missing dependency, for example.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_mppe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index f60f7660b451..92f52a73ec0e 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -63,6 +63,7 @@ MODULE_AUTHOR("Frank Cusack <fcusack@fcusack.com>");
 MODULE_DESCRIPTION("Point-to-Point Protocol Microsoft Point-to-Point Encryption support");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS("ppp-compress-" __stringify(CI_MPPE));
+MODULE_SOFTDEP("pre: arc4");
 MODULE_VERSION("1.0.2");
 
 static unsigned int
-- 
2.20.1

