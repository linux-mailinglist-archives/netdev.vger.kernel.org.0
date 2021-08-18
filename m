Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84243F0872
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240051AbhHRPxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:53:05 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:33948
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239958AbhHRPxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:53:01 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 4B67240CD2
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629301944;
        bh=a4yimsaD54f0w0M2iKmjYx0RkapSJobec2lRCuhnCeI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=cFmBtr8aGX3B+qeCIFJ8oDi7Q57vqslSzCyV2Ht/CGhplf0AFG54eNvD2eHzgauef
         L/CcROa/X4R/2MxnVdM9v4iMG7G7PiqeQG/H6ptu1uWlQu2XdawSsyMIelYfZiBM/c
         Pwmdm7saqErzVZiWIbofGoIxESsJBXynqL3MJswUxW9neYgS+Bhw0wAGMn1CcPabK+
         t3pmrEn+a9BnryD/Scv5JDZXosQF1e7Ty3juO8uceB4T/rGNWh3+IJMPgc4yUvfm3T
         Biilji5znRWi5d0anOWO4Y1jmCq17qOKfAOAjQLK1zRG4uapGK7LQ2qqc8DPGpX2UP
         2RA5pC5cF5irw==
Received: by mail-pf1-f198.google.com with SMTP id z8-20020aa788880000b02903c5c860de7aso1515329pfe.8
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 08:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a4yimsaD54f0w0M2iKmjYx0RkapSJobec2lRCuhnCeI=;
        b=EUyhVeTKOzF5X4uvfaHPO5DnJLhIvEXKpMJpYn/TlUnDPrlofeDjyDF6Ts3fBtsc66
         RGUYeoZQnH5t6k6ImgOF9IsCD0YsH42S45Yi9WBg+D30OiL2wmtHr02DYFeKDfD6g52B
         eDMoMobMTsonZX6IjegzN8GJDpaULydZBJ1CGr0KGWxnNthmLtbiNI+eUbYbuXfyuuRT
         30lQoWNTj8IG2WvPXiCNRQvjrmzNosb9bf2sJgn6fnKIB/ptHePArIoZAd7wfJKV+Xk8
         PdapPFLz8uxLFTqUGghHMtHkpC2rHRTKbqFSLnuY2hk0glJCyZQnK5qyKqA1KM5wz/Qs
         cgyg==
X-Gm-Message-State: AOAM530U6v+XXDqZ0LAqFnvZRmdGbMuPwPvDu2csX8oykDcoxsnrdSw/
        IzphzDfyf9kIZkxCf0tQaDJ9Tw++gPbmYrSg5zivvtdj/1ogq901K/+vqVLS/Yr4XCS84w2L9PW
        gBXWALXg6FVCiC7ddttSVQBMrAhMEi/32Mw==
X-Received: by 2002:a05:6a00:10cf:b0:3e2:139b:6d6c with SMTP id d15-20020a056a0010cf00b003e2139b6d6cmr10152672pfu.3.1629301942800;
        Wed, 18 Aug 2021 08:52:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyr41UVZeTDSI360h/gDC1oF4ZXumjqyY+ZQgymCzpmdw7UeXfWqDIYa7yOfQqyWYoB6UZSOw==
X-Received: by 2002:a05:6a00:10cf:b0:3e2:139b:6d6c with SMTP id d15-20020a056a0010cf00b003e2139b6d6cmr10152635pfu.3.1629301942520;
        Wed, 18 Aug 2021 08:52:22 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id g10sm145654pfh.120.2021.08.18.08.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 08:52:22 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     linux-kernel@vger.kernel.org
Cc:     tim.gardner@canonical.com, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH][linux-next] net/mlx5: Bridge, fix uninitialized variable in mlx5_esw_bridge_port_changeupper()
Date:   Wed, 18 Aug 2021 09:52:10 -0600
Message-Id: <20210818155210.14522-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent change removed code that initialized the return code variable 'err'. It
is now possible for mlx5_esw_bridge_port_changeupper() to return an error code
using this uninitialized variable. Fix it by initializing to 0.

Addresses-Coverity: ("Uninitialized scalar variable (UNINIT)")

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Vlad Buslov <vladbu@nvidia.com>
Cc: Jianbo Liu <jianbol@nvidia.com>
Cc: Mark Bloch <mbloch@nvidia.com>
Cc: Roi Dayan <roid@nvidia.com>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 0c38c2e319be..c6435c69b7c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -137,7 +137,7 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	u16 vport_num, esw_owner_vhca_id;
 	struct netlink_ext_ack *extack;
 	int ifindex = upper->ifindex;
-	int err;
+	int err = 0;
 
 	if (!netif_is_bridge_master(upper))
 		return 0;
-- 
2.33.0

