Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3B11E11C7
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404083AbgEYPcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404002AbgEYPcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 11:32:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CC9C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 08:32:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q16so17540330ybg.18
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 08:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1aPJAz4aiRZJLGo9Zppdv6l/2UMHYuCErqh9nEDAlVw=;
        b=YyhrYJdxW7Th9HHCMfEcljW9TMcq6yqlKP+g09M04H46XosgqxYKIuqivVkfRagJGi
         4HTa7IJEqMafGxMXU3Q8BuJ1IhHwNQWzWXkQ2iuDaRO8GUQaddO29sVikEIflBpLPrpm
         8TFsfR9ugSx6M5yULIhqDrhkDrTTrYvx7ImnKAAf8qsyYAnw+mNMpt4KHO976WzlVF2b
         pAXf4hJESkFxemlW/aqX1fdCYU5gr06w4Np2N9F3Y3l2yuQo//qtxTZZ79w4GOeszwHk
         Mt2rUdbpQcGYj89Af9cnHInj8RHz2Bx/HS4SJv4H37vQZWE+OVxeCz6XtAktkzty70jk
         d5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1aPJAz4aiRZJLGo9Zppdv6l/2UMHYuCErqh9nEDAlVw=;
        b=khjokN/Ns7bS4T3AzkdqymYRXpa/K5qHKFHXHVEbOt7V/drhmy1e3sqvFmnuJHslmo
         6Z00iBixp1kwbfVjaM1lXIHowNDhqD6E76RupWird6a7UGtekQ7BQUw+dAK24k9jJdpn
         IjyGlJNkLzTAXqtFA4kgTw6jvtleGjPO4QwOpVS0mp4fND+VPntwWqKIBNV12cZnQRoY
         zgwyBC8WLE2WpOCZ2h2IFNnFTs7V9o1vx4I4ZF1qZr5XHgH5u1/HDjoOtByobqgl9xsh
         D0oUAPv1QlCflXfkeUNFdA608bSLjauyo0lg9Q7IyDBUhKYCtAJ+AmCLVNbB1/E+/ClL
         deWA==
X-Gm-Message-State: AOAM5309cC0up5vTOCNptZ/d1ia7oAw5zzk+4h6ysTuJXp5SUBaRcR72
        6c1agDek10NVaILIYAFLLOn8z73e1Wme
X-Google-Smtp-Source: ABdhPJya/2GUziXPBk3NUocIvSMoZVWhlGIJuvfXIr49RmOkgaE3thIWHR39GaNnOmRGCJdlKCJr2u4JSiWD
X-Received: by 2002:a5b:5c6:: with SMTP id w6mr44787174ybp.339.1590420721796;
 Mon, 25 May 2020 08:32:01 -0700 (PDT)
Date:   Mon, 25 May 2020 17:31:58 +0200
Message-Id: <20200525153158.247394-1-dvyukov@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH] net/smc: mark smc_pnet_policy as const
From:   Dmitry Vyukov <dvyukov@google.com>
To:     ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        linux-s390@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlink policies are generally declared as const.
This is safer and prevents potential bugs.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
---
 net/smc/smc_pnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 2a5ed47c3e08..45d5ea570293 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -32,7 +32,7 @@
 
 static struct net_device *pnet_find_base_ndev(struct net_device *ndev);
 
-static struct nla_policy smc_pnet_policy[SMC_PNETID_MAX + 1] = {
+static const struct nla_policy smc_pnet_policy[SMC_PNETID_MAX + 1] = {
 	[SMC_PNETID_NAME] = {
 		.type = NLA_NUL_STRING,
 		.len = SMC_MAX_PNETID_LEN
-- 
2.27.0.rc0.183.gde8f92d652-goog

