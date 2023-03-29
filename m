Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC266CD091
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 05:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjC2DOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 23:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjC2DN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 23:13:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B00326AD
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:13:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso14771382pjb.2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680059635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b3pVxvOfMKZYxHtIRhfXnPoeSe0EsgFYCjk+EHIOVUo=;
        b=aPq/YfugP9yh31isR/InaBXATO3L7yEZwJ/fNr3YVn2PpWLwNZZF9JhwQzOQ9zgAo7
         d3OfBWonlkO0TamP4/4dO1IVFBlF2TvqWZWwLaUczIxNsDrIcaaxNmFfEzzWhrjya+5e
         5+ROHlBSAls4uYPEQwmrtuC6zZ2P17Pr6bphJ1dModVBmdsTbvoZgCn3saD0C+nQEzlO
         7qFvTNTZZJfzapzY2FhLZDx2FiSPPZyQpZTRcolnx9SISc6VthljlntSpqClRXhHag7J
         ToMmx02r7Hm2wGw9cud1svfS/bN3joBDG7tNVVmzm6IXs/sF1obugtLklb20d+ke+b1b
         p+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680059635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b3pVxvOfMKZYxHtIRhfXnPoeSe0EsgFYCjk+EHIOVUo=;
        b=mym8ItV8CBHqbVpe6SEhMUvuuM/hSOvaPQKBHpg+30Y8mc6V4C4+CcZR6orlGkPpFK
         utkXTqrbY3v9qFSXg2Sj9OESuf9xa1wBUCrP1ul+4OeVyn26VMo1+EFXQWag9Yuw8wuc
         JcHVjwDyuTV/dFSsD76F6+kifnhP+D/iSZZ746jtI0ff/1o9Vq0b+M2bGYwR7QKU5Ren
         jsb1nsrLE7brBuVphU7UYpJjU1FQUyvanRpuigsj4Hi/0CRcDJZ8NC/fa3uwcCv0cjr4
         02R2xm7NhyvskhUpcFT7Lkvm/h9Lmc//wH0k37g0ig6FJBJIlE7Zc2SSR8MFvCbb9BQD
         XGpQ==
X-Gm-Message-State: AAQBX9cpoNzsR93fP7n9WqiO/j7UUVgFswmDS4Z/S3bHRGgTkEHeurqH
        K6u+R1luJ7DxAaRd2r4tkz+79B2ecWKidQ==
X-Google-Smtp-Source: AKy350ZYqHcPUzmbA1fulDyOV9GOGuZWsrHfqa9+Z82tgo3WAXhwa6bNZ2rvNFaKxNSeeVQFm+aQjw==
X-Received: by 2002:a17:90a:185:b0:237:161d:f5ac with SMTP id 5-20020a17090a018500b00237161df5acmr18861714pjc.36.1680059634891;
        Tue, 28 Mar 2023 20:13:54 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:7821:7c20:eae8:14e5:92b6:47cb])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090ab38c00b0023d16f05dd8sm272447pjr.36.2023.03.28.20.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 20:13:53 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] bonding: add software timestamping support
Date:   Wed, 29 Mar 2023 11:13:37 +0800
Message-Id: <20230329031337.3444547-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, bonding attempts to obtain the timestamp (ts) information of
the active slave. However, this feature is only available for mode 1, 5,
and 6. For other modes, bonding doesn't even provide support for software
timestamping. To address this issue, let's call ethtool_op_get_ts_info
when there is no primary active slave. This will enable the use of software
timestamping for the bonding interface.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 00646aa315c3..f0856bec59f5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5709,9 +5709,7 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 		}
 	}
 
-	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-				SOF_TIMESTAMPING_SOFTWARE;
-	info->phc_index = -1;
+	ret = ethtool_op_get_ts_info(bond_dev, info);
 
 out:
 	dev_put(real_dev);
-- 
2.38.1

