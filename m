Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1034CEF23
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 02:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiCGBe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 20:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbiCGBe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 20:34:57 -0500
Received: from smtpbg511.qq.com (smtpbg511.qq.com [203.205.250.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1171B13F0F
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 17:33:59 -0800 (PST)
X-QQ-mid: bizesmtp80t1646616832two2455y
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 07 Mar 2022 09:33:45 +0800 (CST)
X-QQ-SSF: 01400000002000B0I000B00A0000000
X-QQ-FEAT: YOzQJqMlvs4f0p3oV5qekI6gjmv0OXoUKubEtLBd7DsMVpP17aR3kyW0ldIiv
        EaXKoETMz0yDDbOfcuL5ONVBej/MrqqUkMx+snT2lnNT1GNWTWwSWyhbf/bNWDRQUzAnSAz
        NKfbCl8f5BkJDysjcPDz3z3BaTwO1a7xs7YEreEH3Ai5z3UmH0RfQbe69GaksQGLAUWwPOV
        ik1a9pnAACPQqSTKaOEm83NtFT4oXcz5s257yfeVncijvF/Zmd32gSR+qGgkdPTVfAuNtSq
        kot46+3u7HDH5cltLJCII71188gG/zd4Ipl0iGV3+4bDR/dzClfxHdaKeOffRBaM1tKVjUA
        mxRSKuFsF0Cm4ly+VW0ITr0Anx17w328Ah6ZFNBW8d6Ki24j7g=
X-QQ-GoodBg: 2
From:   Lianjie Zhang <zhanglianjie@uniontech.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        zhanglianjie <zhanglianjie@uniontech.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH v2] bonding: helper macro __ATTR_RO to make code more clear
Date:   Mon,  7 Mar 2022 09:33:33 +0800
Message-Id: <20220307013333.15826-1-zhanglianjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign6
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhanglianjie <zhanglianjie@uniontech.com>

Delete SLAVE_ATTR macro, use __ATTR_RO replacement,
make code logic clearer and unified.

Signed-off-by: Lianjie Zhang <zhanglianjie@uniontech.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>

diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 6a6cdd0bb258..69b0a3751dff 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -15,14 +15,8 @@ struct slave_attribute {
 	ssize_t (*show)(struct slave *, char *);
 };

-#define SLAVE_ATTR(_name, _mode, _show)				\
-const struct slave_attribute slave_attr_##_name = {		\
-	.attr = {.name = __stringify(_name),			\
-		 .mode = _mode },				\
-	.show	= _show,					\
-};
 #define SLAVE_ATTR_RO(_name)					\
-	SLAVE_ATTR(_name, 0444, _name##_show)
+const struct slave_attribute slave_attr_##_name = __ATTR_RO(_name)

 static ssize_t state_show(struct slave *slave, char *buf)
 {
--
2.20.1



