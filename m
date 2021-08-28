Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F1F3FA2AB
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 03:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhH1BDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 21:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhH1BDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 21:03:43 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9CBC0613D9;
        Fri, 27 Aug 2021 18:02:53 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id a10so9083837qka.12;
        Fri, 27 Aug 2021 18:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZqtHOG1cYK3m7nQOspZdmgqBHZtI39r10WDkq42VZZo=;
        b=oy0u2A7w+ItIZw2vt87rTBTtEfak+ioIj5khLZXR0XJSyNzvCmCMIUGwuygAqljVOW
         JLkrhfrdbkae9oDDBaYYH/7df3MOAhx9qg02WzVaMtavI5fNnDvaqWht1nhEwWrEozX5
         Mzl4X59c0DsTVs3TxVRdo0exfVKfW+xZwslhYF8OsAa4McLaQ9h6K5KRY0ZvtPdR1MPU
         UBo83xTESY2RxGt/OUzQbiaOUVGm4lC44tvkS0+yu8opKQpwbQUKrrAMKX0JDjmLRYlg
         K8R/YCUVZqOXEgf9F8qYYQuN09bLLZZ6dn+OV2BahsvH7gG7CSOhTylGSLUb5XPwZHx9
         nzhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZqtHOG1cYK3m7nQOspZdmgqBHZtI39r10WDkq42VZZo=;
        b=ffMdrO36b8kLrakDIheuq27LDlox5VjRhE+5eaBWmBuxN5VJ0Zipiyd8rjgUoF9oQm
         s5OKqWYNXZ6odFJ684wl5SRLqJPjPqWLOdLrWlvaCR5iOCczvGcxHT5Wv+8tf854OXW9
         SHCIbZOUwzjlMOkFp9v3uiP3PAkze5NoldepYLOxP6ufEHAOA6cEzkwjZgq6M+tLbxKB
         KfXWSBh5hLW+w3lH6BxhaoSNiNiaeIApSpzsLHx/6BRRlpvN5YQRTc+07rjOeQkIsqec
         sHj0wtf3Jc3ONT/rb1jlFVABfCIXz2ftao4TPnvb38dBN7S7ZAI/F5MrgBRjAVKlDpP/
         2Wqw==
X-Gm-Message-State: AOAM5320IPpR11rAEl46Ev70XYKpGd3EEKEL1CNMEHRILu/DPcbAJ2J0
        Lgwy8x+L1uOMyz1sN9a05aU=
X-Google-Smtp-Source: ABdhPJzzS2e1SA/F8Wa8VH56LDI7BZ12lZcsaitMYNWlfKT9NEFe2c/ICccHO3pueeM6xqRZElouWA==
X-Received: by 2002:a37:2d04:: with SMTP id t4mr11920659qkh.463.1630112572718;
        Fri, 27 Aug 2021 18:02:52 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id q184sm6023102qkd.35.2021.08.27.18.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 18:02:51 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <deng.changcheng@zte.com.cn>
To:     Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net: bonding: bond_alb: Replace if (cond) BUG() with BUG_ON()
Date:   Fri, 27 Aug 2021 18:02:30 -0700
Message-Id: <20210828010230.11022-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the following coccinelle reports:

./drivers/net/bonding/bond_alb.c:976:3-6 WARNING: Use BUG_ON instead of
if condition followed by BUG.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/bonding/bond_alb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 7d3752c..3288022 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -972,8 +972,7 @@ static int alb_upper_dev_walk(struct net_device *upper,
 	 */
 	if (netif_is_macvlan(upper) && !strict_match) {
 		tags = bond_verify_device_path(bond->dev, upper, 0);
-		if (IS_ERR_OR_NULL(tags))
-			BUG();
+		BUG_ON(IS_ERR_OR_NULL(tags));
 		alb_send_lp_vid(slave, upper->dev_addr,
 				tags[0].vlan_proto, tags[0].vlan_id);
 		kfree(tags);
-- 
1.8.3.1


