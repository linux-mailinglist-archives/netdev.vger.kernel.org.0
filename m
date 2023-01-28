Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1216267F595
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 08:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjA1Hb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 02:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjA1Hb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 02:31:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26782199FB;
        Fri, 27 Jan 2023 23:31:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF89EB8121D;
        Sat, 28 Jan 2023 07:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA6FC433EF;
        Sat, 28 Jan 2023 07:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674891071;
        bh=/0Ri97j2/mKEiP4iuV2q/FxSOuesAb3rgKItcZaHWk4=;
        h=From:To:Cc:Subject:Date:From;
        b=og5+fqzZmTkRChUXLE9BNTJVNkx11Fp6bFUe92ljAMIaT0qiHWUiMrMHjNSY+pZSE
         yFX5rwSU6EmHGdDaxjuNm1ANxz/2G7pNvPL/cs+H46pNqhyXwhTWvzdZ1aZQLaQ+aQ
         YoweGMWgrp8H8YvKHPmtg6ot/wCUANwxhm1zTdib9UgBko/HfrEqkLL7Bt3XQBK47t
         QT+LXHmmUPOerIYGiWbHnrFMOuUwCYQO9wIZMdPw8h2/xRV4Zwm/rysu61h787GgOP
         pqzNWRntgS4GiYo9gYFVFXanIAZC+OeiQxYszh6zrlZKKyQ7RuX9OY38C3/o2QPOJq
         mokBJ+swYbPDQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, ysato@users.sourceforge.jp,
        dalias@libc.org, linux-sh@vger.kernel.org
Subject: [PATCH net-next] sh: checksum: add missing linux/uaccess.h include
Date:   Fri, 27 Jan 2023 23:31:08 -0800
Message-Id: <20230128073108.1603095-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SuperH does not include uaccess.h, even tho it calls access_ok().

Fixes: 68f4eae781dd ("net: checksum: drop the linux/uaccess.h include")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: ysato@users.sourceforge.jp
CC: dalias@libc.org
CC: linux-sh@vger.kernel.org
---
 arch/sh/include/asm/checksum_32.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/include/asm/checksum_32.h b/arch/sh/include/asm/checksum_32.h
index a6501b856f3e..2b5fa75b4651 100644
--- a/arch/sh/include/asm/checksum_32.h
+++ b/arch/sh/include/asm/checksum_32.h
@@ -7,6 +7,7 @@
  */
 
 #include <linux/in6.h>
+#include <linux/uaccess.h>
 
 /*
  * computes the checksum of a memory block at buff, length len,
-- 
2.39.1

