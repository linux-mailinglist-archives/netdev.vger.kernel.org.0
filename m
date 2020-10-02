Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615AC281B66
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388365AbgJBTNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387712AbgJBTNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:13:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58322C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 12:13:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 5so1418013pgf.5
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 12:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uNJs9pxvzX60LPaGBiVfHoplXWEUEMr0awFIuGZwEpk=;
        b=Ee6JXggLvSie9Hjk6V6BfqUAIoveC/R2C0SREOfMGSza1RLeH5mBUPUyO8bWsrvq4o
         LoYBJlfPv97pQL6O2qeABYk3Y1/UOekbZN41DG/CYm0gFGcshKUvv2PeiDL7RCwASzlD
         THVjBnkuhtsHhuYWdzTKB8S5g5j+ufDU3s10Ny7dXQieDifwbLPH9q0A4XdMhCFZ2Y1b
         vPZeeJKlzLJe1ztIlayB1PpMyZoF0Ac21ZJ1ecGt1XNCuBY2sj9O79sREe4WCqeTMl1Y
         2bIfRms/YCUU20KxAYH5Bd/Bj+RxWQLBXEV70Fy+cbAWOEThIiZtSbIE0KBWbzzvoYel
         863g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uNJs9pxvzX60LPaGBiVfHoplXWEUEMr0awFIuGZwEpk=;
        b=YrSlcmZEsDRDbyvxRabBN0DrC5S8zvzf6yO9ckAdYcDiZjwbAq89q19UYy5dVX4zDr
         yKSNCFnken8ySBvJ9oQQeHSMTyjqI8BIkufokwexrSyuvjj3YBnZAAkZhoVZzvzeGUTZ
         fW3x5RpDVPeIfypwCfNOV+s5J3pIXu7YzORfPKYs2vc+fEyCrUQqwIAjwMWRcQOPpu72
         Uuzzs98tgaZet1KMEbRMBdJ5+/ulGA7m8mPqI5JXEwDke8OiIhP0N7la4vXPsBi6mUHE
         djqfvRVmZ/L7xrMo+8Qo5vNoRl35ZtCxScHOo1SII4i9slvwNiYooGqJXE81jwyCqpIB
         ogdA==
X-Gm-Message-State: AOAM533CfmB6EZ3exuSP/FF15BtxtkX25aD0k9TAWoDWo+POXl1Gf1LG
        R2FW7zOM4G8kxImqEL8oB7Bi1pOSuHmduA==
X-Google-Smtp-Source: ABdhPJyDGMRINxFhKNu993xj7QBzR+93XuakcnG5ZD2LwsIVpc26Jr9fgZL27wj3aoBZ3tyPoe8mxw==
X-Received: by 2002:a63:ed01:: with SMTP id d1mr3548290pgi.58.1601666021662;
        Fri, 02 Oct 2020 12:13:41 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id o134sm2855676pfg.134.2020.10.02.12.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 12:13:40 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: check error pointer in tcf_dump_walker()
Date:   Fri,  2 Oct 2020 12:13:34 -0700
Message-Id: <20201002191334.14135-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although we take RTNL on dump path, it is possible to
skip RTNL on insertion path. So the following race condition
is possible:

rtnl_lock()		// no rtnl lock
			mutex_lock(&idrinfo->lock);
			// insert ERR_PTR(-EBUSY)
			mutex_unlock(&idrinfo->lock);
tc_dump_action()
rtnl_unlock()

So we have to skip those temporary -EBUSY entries on dump path
too.

Reported-and-tested-by: syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com
Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/act_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 5612b336e18e..798430e1a79f 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -235,6 +235,8 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 		index++;
 		if (index < s_i)
 			continue;
+		if (IS_ERR(p))
+			continue;
 
 		if (jiffy_since &&
 		    time_after(jiffy_since,
-- 
2.28.0

