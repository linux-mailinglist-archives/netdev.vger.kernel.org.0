Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25054282DD9
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgJDV6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgJDV6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:58:17 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18583C0613CE;
        Sun,  4 Oct 2020 14:58:17 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id 133so2644773ljj.0;
        Sun, 04 Oct 2020 14:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S4lKbgbl4+KsaG98foBPmtxvo5zcq508g1cRJgesLFg=;
        b=KL5/7+rqhaFOAg98Yo5zgqCpLo6IF5d1kJO3xCtg8XNVWlJqbHS7xToKxZ3h1px6vd
         x0+MS4BmbHIpKn2NmjgqV2R03jbPCEnLhOu6ARcCPlEoQm5ecAxh/7TmKkJ1QeJyjfre
         MOhNgeCYIlD0myVHdO4gXuBNwgjp3yrrgoJg/fH8U84PwhMrjOLAZFL3g6LwVuEmaH3y
         6Yd0jpF7gxFVMJNvrIeVE9u3npJ/pSdu2vzefcGP6Qbz5RhxHy0sLCmYUwXsz9wuplQq
         sxo2/9AxXNHHZ2Md+lfXbkMko0b1k2xyUZiAMN/Pbnx5fAJ5N6VghcnuDHNiT1NdgpFL
         sBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S4lKbgbl4+KsaG98foBPmtxvo5zcq508g1cRJgesLFg=;
        b=YGmcoFxhy8CBN7+H56bAMEy6dOPeq4a3JuOKuYrcc86k97voYsMZVWR9yBEyCwG1mA
         ERXuVob7gLIvg/sRoZ/q+YNQGc7SoivmQyfgDpFjHd756uy23XrS4TUZqMSri950EsdX
         j8oZ+/iGZWhIE+WMPnHulfWAqYenQztL5/Q6e9vsY7+5tL844ySPm3nC5LhFdiiPhQct
         CH3L7pMc6t87kVShPEWkpju4tHym+bB491uRIxNsYod8dk8Gkq1BC+7KSiLSo98PEi3R
         ad8CznCTMLtyXNofyt5lBsklibCTo58xxr+erJG4GnCFo+uvxNNJIHgNe1qLO1/pop1q
         2JZQ==
X-Gm-Message-State: AOAM5314H/xQU+vjdlMNzQkJMdUToVbpQlED2v2Du3aQrUftmxkqUBTC
        VfEULRhAX38Tpl/qXdbbuP55uvXTc0rEzw==
X-Google-Smtp-Source: ABdhPJx2jMxi8hZLuD2HFZarO+tYl3tF6HlB0QDmHOadDNq783SgzA9CLYBs41gQKDhU+lQZYktGww==
X-Received: by 2002:a2e:8159:: with SMTP id t25mr3479808ljg.137.1601848695568;
        Sun, 04 Oct 2020 14:58:15 -0700 (PDT)
Received: from localhost.localdomain (h-155-4-221-232.NA.cust.bahnhof.se. [155.4.221.232])
        by smtp.gmail.com with ESMTPSA id r17sm310255lff.239.2020.10.04.14.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 14:58:14 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.01.org
Subject: [PATCH net-next 1/2] mptcp: Constify mptcp_pm_ops
Date:   Sun,  4 Oct 2020 23:58:09 +0200
Message-Id: <20201004215810.26872-2-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201004215810.26872-1-rikard.falkeborn@gmail.com>
References: <20201004215810.26872-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usages of mptcp_pm_ops is to assign its address to the ops field
of the genl_family struct, which is a const pointer, and applying
ARRAY_SIZE() on it. Make it const to allow the compiler to put it in
read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 net/mptcp/pm_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5a0e4d11bcc3..0681d493ba63 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1054,7 +1054,7 @@ mptcp_nl_cmd_get_limits(struct sk_buff *skb, struct genl_info *info)
 	return -EMSGSIZE;
 }
 
-static struct genl_ops mptcp_pm_ops[] = {
+static const struct genl_ops mptcp_pm_ops[] = {
 	{
 		.cmd    = MPTCP_PM_CMD_ADD_ADDR,
 		.doit   = mptcp_nl_cmd_add_addr,
-- 
2.28.0

