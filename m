Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E3D6207E6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 04:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiKHD6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 22:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiKHD6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 22:58:15 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDDA31F8D;
        Mon,  7 Nov 2022 19:58:09 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id 4so13118125pli.0;
        Mon, 07 Nov 2022 19:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=3w2NZSwyPPI/Z7ZkFiZmUgxVMdr3WnPezn9G8jIb89k=;
        b=X7mu302r89riVzCOc5c+QGr3J3ji059SuTRG+TJx6kuVWDrRW3lv3gkTC1uHEyPpyH
         PHxhlYGHktePLoMIyLJ4LsQEJdnsyZDw5+QbG9MG77UD8wLMi2yQ322T6jcOjm3wIYD9
         xxcoPXaBe8lj6/jl2fcEWFiv9HEiTyd7lGLqNHXxSMEeUnqYk5i/EhLMyBrFa4imTFNX
         ZvJrth5PYo27TsjmYXAwfdifsW92nn597nk4qKi03oboTpck1Nk3+L8uaWOeMgktd4fi
         cbrPEjgkiST2oGWIRnuFroFS3PGiAA7VwzeuuVKgYCPeXgEuZ45LjmoLlT21LFc2tlRi
         G2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3w2NZSwyPPI/Z7ZkFiZmUgxVMdr3WnPezn9G8jIb89k=;
        b=uXzaVUi58lkypRXSbgtmwvzMhrpt3de4i1Vq9k+rVdSP15gUzTDZG6z+XZRXSXBVsv
         hpFReGTi4HJeVeMjGkisP4xX0zszL3aE7onNK2iodEreVNZuBtNtalaofoLai/hR/RKR
         bzyHenMczemuhQCiKG2SHL5s4DVQDqxKKIxcGnh/7mt3x/mqAhQIArGpjMtEcpXyR+nY
         hZXS+Cl9Bm7D94AfJ8jdTTDpGoYQKRitKR4FuY2nwI/U9D9VdCzm4vBU8Jpj28AzAynL
         k6B6Bs0uik0Op2GX2n0O7rJZDEuI+dxXo+bAPmMbtsdMQs/re6ec7fYEucO2Q8IpSP83
         ccPw==
X-Gm-Message-State: ACrzQf2Qkpc+YtkVJflO2VVzbO4VsgaBbnSeifYMSW6uDie95PqTsIgE
        yqCS1gz/JczhSDg6ziY+NKkx32C2AiosrQ==
X-Google-Smtp-Source: AMsMyM4x7rvP60abguWcxTGRbCowt/rtTIIGdTlcjrCW4mEjjh+hL3fix3lxJQ0LBbPEc6Fz2rv+sw==
X-Received: by 2002:a17:90b:1a84:b0:213:e8b5:2d16 with SMTP id ng4-20020a17090b1a8400b00213e8b52d16mr45255481pjb.9.1667879888388;
        Mon, 07 Nov 2022 19:58:08 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s5-20020a170903200500b00172cb8b97a8sm5785105pla.5.2022.11.07.19.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 19:58:08 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate drvinfo fields even if callback exits
Date:   Tue,  8 Nov 2022 12:57:54 +0900
Message-Id: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ethtool_ops::get_drvinfo() callback isn't set,
ethtool_get_drvinfo() will fill the ethtool_drvinfo::name and
ethtool_drvinfo::bus_info fields.

However, if the driver provides the callback function, those two
fields are not touched. This means that the driver has to fill these
itself.

Allow the driver to leave those two fields empty and populate them in
such case. This way, the driver can rely on the default values for the
name and the bus_info. If the driver provides values, do nothing.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 net/ethtool/ioctl.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 57e7238a4136..546f931c3b6c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -713,15 +713,22 @@ static int
 ethtool_get_drvinfo(struct net_device *dev, struct ethtool_devlink_compat *rsp)
 {
 	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct device *parent = dev->dev.parent;
 
 	rsp->info.cmd = ETHTOOL_GDRVINFO;
 	strscpy(rsp->info.version, UTS_RELEASE, sizeof(rsp->info.version));
 	if (ops->get_drvinfo) {
 		ops->get_drvinfo(dev, &rsp->info);
-	} else if (dev->dev.parent && dev->dev.parent->driver) {
-		strscpy(rsp->info.bus_info, dev_name(dev->dev.parent),
+		if (!rsp->info.bus_info[0] && parent)
+			strscpy(rsp->info.bus_info, dev_name(parent),
+				sizeof(rsp->info.bus_info));
+		if (!rsp->info.driver[0] && parent && parent->driver)
+			strscpy(rsp->info.driver, parent->driver->name,
+				sizeof(rsp->info.driver));
+	} else if (parent && parent->driver) {
+		strscpy(rsp->info.bus_info, dev_name(parent),
 			sizeof(rsp->info.bus_info));
-		strscpy(rsp->info.driver, dev->dev.parent->driver->name,
+		strscpy(rsp->info.driver, parent->driver->name,
 			sizeof(rsp->info.driver));
 	} else if (dev->rtnl_link_ops) {
 		strscpy(rsp->info.driver, dev->rtnl_link_ops->kind,
-- 
2.37.4

