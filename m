Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DDA2873ED
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgJHMTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJHMTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 08:19:49 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC5AC061755;
        Thu,  8 Oct 2020 05:19:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id x16so4153369pgj.3;
        Thu, 08 Oct 2020 05:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1CA425vbWwjFQrsT0hVnTla+NVXZOa5B24PA0M3G49E=;
        b=tLof7ZgI51M9pwjScND+pAJ5mDdGWF+natvmIxLwwhOzE9HSBYOPdhK+8uLdVL44o5
         KZL74nkU6VXqdcnPm3qE+8YT94DSHUwzVZ7FoSod+X4sFWlPugLVVMdMJYeCld1WovqU
         DcQJoh3HJAhSaUyxIkP1qwdoZvC5pgKNbr+hX0enXI3WfRMP/ZgBjMyKzuwA9DMqoImQ
         6LOe0nNzBk/OgWXiQbMnFrPKuDsHy4V22L9Sv3Wbj6sFtOaLbqOh8VZRRyuJNjfRok8h
         Gup7vOBtVFSza7CC8FAFWjNEOclEXzAvyLydb3qx4k1J375twP3hATCtREETw9e9dLaV
         7Rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1CA425vbWwjFQrsT0hVnTla+NVXZOa5B24PA0M3G49E=;
        b=CjxhNiS0OT21X75VXRNtDo8/QWrLkjJ2VazhUTXdzofNJ4TcwVI2hVWTdLzbrAiUhH
         5vqvABeewVpmI5mR37kHxYy8ZF/BydejA9deGrUGILXCfSl42EStk3PCofyviE0Pj7Ew
         wx0/cIhXHqbmGf+35CTZ6Hr1RG4PsaMCz8kz3Kl980ty5YREYz7t98urzfJKWTxNqhkx
         my8jU62mj3ErYOWZmnJH8xM7Oo/j99WUe+4QfnfxDApigJHURvbNx0rNA9E95ATj/3pR
         bJmGOU8RrS1K4o4dD9MVJmy4H8mVLGqygEyBhYKajDZdVk8oPhEhjk4HFvUYJv3PidD6
         MgdQ==
X-Gm-Message-State: AOAM531wxfyq5t8MGlztorTFtMA3nTtxGp9zJlKRdNUHMftT3X4f5M5F
        G/YWtwP8RmvO6QsBeWy/ww==
X-Google-Smtp-Source: ABdhPJwbSTQfC7Pbcdo+SQ8cZvp7bmyr47AoUrvtlbp97scUNUSAx1nvnWzjaV8hjaQj4aaFe7PluQ==
X-Received: by 2002:a62:6346:0:b029:154:f822:27cf with SMTP id x67-20020a6263460000b0290154f82227cfmr7133362pfb.42.1602159586960;
        Thu, 08 Oct 2020 05:19:46 -0700 (PDT)
Received: from localhost.localdomain ([47.242.140.181])
        by smtp.gmail.com with ESMTPSA id c7sm7233914pfj.84.2020.10.08.05.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 05:19:46 -0700 (PDT)
From:   Pujin Shi <shipujin.t@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hankinsea@gmail.com,
        Pujin Shi <shipujin.t@gmail.com>
Subject: [PATCH 1/2] net: smc: fix missing brace warning for old compilers
Date:   Thu,  8 Oct 2020 20:19:28 +0800
Message-Id: <20201008121929.1270-1-shipujin.t@gmail.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For older versions of gcc, the array = {0}; will cause warnings:

net/smc/smc_llc.c: In function 'smc_llc_send_link_delete_all':
net/smc/smc_llc.c:1317:9: warning: missing braces around initializer [-Wmissing-braces]
  struct smc_llc_msg_del_link delllc = {0};
         ^
net/smc/smc_llc.c:1317:9: warning: (near initialization for 'delllc.hd') [-Wmissing-braces]

1 warnings generated

Fixes: f3811fd7bc97 ("net/smc: send DELETE_LINK, ALL message and wait for send to complete")
Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
---
 net/smc/smc_llc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 2db967f2fb50..d09d9d2d0bfd 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1314,7 +1314,7 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
  */
 void smc_llc_send_link_delete_all(struct smc_link_group *lgr, bool ord, u32 rsn)
 {
-	struct smc_llc_msg_del_link delllc = {0};
+	struct smc_llc_msg_del_link delllc = {};
 	int i;
 
 	delllc.hd.common.type = SMC_LLC_DELETE_LINK;
-- 
2.18.1

