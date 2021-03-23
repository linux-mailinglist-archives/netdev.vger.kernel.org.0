Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D848345547
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 03:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhCWCGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 22:06:48 -0400
Received: from m12-15.163.com ([220.181.12.15]:45580 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCWCGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 22:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=9sdXz
        0tALfOI2leZ5ji9YmZOodSU6t+mAa6CveDIcYk=; b=IJJZSNCn5QbMR9AP184LE
        9t3LBbpp3jekTwuqPrkLIfR80KhmFdQD/bRNdWQsQ1MpYay/fgSGAiopjE+ojkWa
        qhSK6Ms4nHsZncadFl3baS7bKPdNsG6UMjIiClc0toP19etOmdYUwPc4KBXZ45aG
        TzDBxI2wsCBhJ0sQFjQmT8=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp11 (Coremail) with SMTP id D8CowACHjgrNTFlg9J8_GA--.21S2;
        Tue, 23 Mar 2021 10:05:15 +0800 (CST)
From:   zuoqilin1@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] net/smc: Simplify the return expression
Date:   Tue, 23 Mar 2021 10:05:09 +0800
Message-Id: <20210323020509.1499-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowACHjgrNTFlg9J8_GA--.21S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF1xWF1UGFWrJFyrJrykuFg_yoWDKFXEk3
        48Xrs2gFyUZ3Z3ArWftrsIyryfGFsFqw40qFs7ta98Jr45XrWrArn8GFnxC34rCws5JF9F
        gr4ftFWIy34UCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUezuWPUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/xtbBRRteiVPAKqAISQAAsR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

Simplify the return expression of smc_ism_signal_shutdown().

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 net/smc/smc_ism.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 9c6e958..c3558cc 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -344,7 +344,6 @@ static void smcd_handle_sw_event(struct smc_ism_event_work *wrk)
 
 int smc_ism_signal_shutdown(struct smc_link_group *lgr)
 {
-	int rc;
 	union smcd_sw_event_info ev_info;
 
 	if (lgr->peer_shutdown)
@@ -353,11 +352,10 @@ int smc_ism_signal_shutdown(struct smc_link_group *lgr)
 	memcpy(ev_info.uid, lgr->id, SMC_LGR_ID_SIZE);
 	ev_info.vlan_id = lgr->vlan_id;
 	ev_info.code = ISM_EVENT_REQUEST;
-	rc = lgr->smcd->ops->signal_event(lgr->smcd, lgr->peer_gid,
+	return lgr->smcd->ops->signal_event(lgr->smcd, lgr->peer_gid,
 					  ISM_EVENT_REQUEST_IR,
 					  ISM_EVENT_CODE_SHUTDOWN,
 					  ev_info.info);
-	return rc;
 }
 
 /* worker for SMC-D events */
-- 
1.9.1


