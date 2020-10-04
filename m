Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5B2282E60
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 01:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgJDXpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 19:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgJDXpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 19:45:11 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F193C0613CE;
        Sun,  4 Oct 2020 16:45:11 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 184so46535lfd.6;
        Sun, 04 Oct 2020 16:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LcT11QGgmi/Ja33fdmkdhrSSg0Rjfg/czbEbsKK1Qck=;
        b=piC7iX+MEyPEZ3qtt1g+wKSDsFEghkqQC6W8LZncmNb0nDcx+tO+ZLkrH+yzJbH9Ca
         3SLEIbctIs4RiBMfwiBOBRfqCq12lWF00d1DgnnpyMLtVno+QOtCmALSAcBhdqfdALX6
         XpGWvzuGBcCgcaUf1yXFurhC4MH6yl22j8Ski7pxITKzd/2LFZHZw8xZl1x3lWgxiVjg
         VMP9i87QZW2L9D20hs3HJ3XE+bUwlc2eybqS8Q7Giqeqzv4IerU0bUSwIdaZMpq3bid7
         le/3EYnnD8J1/6a/j190OnjVf04oRgLxMlRpCzhelR8pP87VgFl5luegkcnks3RN2peJ
         +Mew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LcT11QGgmi/Ja33fdmkdhrSSg0Rjfg/czbEbsKK1Qck=;
        b=AYjBLE77otRY5afRjHrwwNtsisO5B+jQqm4S6UiuOktFqjh6AGem1Tt0lhkVW4PXp7
         X+6Ome7uOtKPDyuSKDvIqHWUv/SGc4pU+uc2Ff4mT9y9/XrE+4452w9FF5epCWM9CpzU
         03k7vY8U6xtj7Wq7XTqnBey45crC9gk9nBPV+nKD1kfNA6pFdGgFn3zYifLPh40wVpLg
         O0OlNs94O9brupWbpYdiaUD0bR0+0vaDF32PSDm1HZx9FvzTkjUJ7NV3/Ioblbpq2sLE
         6oBZ14logzNcdOXl15dDTkYkVajw1jO7ZRUMYE7ZmxTb/6jBZGtMWXiV79iuFfEtfXA4
         Byrw==
X-Gm-Message-State: AOAM5310VdepaBM697HHR9lWeW7wTbofHNQaZIsuDmf4uABq/Gs/yX5K
        D5Fj0SsC6gcsG+Kb+yDovs3w0VuoHFOwsg==
X-Google-Smtp-Source: ABdhPJxEEoSyn5W8FLC7xi4oOsvEHHCest53tkhUDBhuBKe5Pe47YtorJ+kMTgTzHFglX1Bp8ZQyUg==
X-Received: by 2002:a19:4084:: with SMTP id n126mr4054816lfa.54.1601855109757;
        Sun, 04 Oct 2020 16:45:09 -0700 (PDT)
Received: from localhost.localdomain (h-155-4-221-232.NA.cust.bahnhof.se. [155.4.221.232])
        by smtp.gmail.com with ESMTPSA id y3sm159866ljc.131.2020.10.04.16.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 16:45:09 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.01.org
Subject: [PATCH net-next v2 1/2] mptcp: Constify mptcp_pm_ops
Date:   Mon,  5 Oct 2020 01:44:16 +0200
Message-Id: <20201004234417.12768-2-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201004234417.12768-1-rikard.falkeborn@gmail.com>
References: <20201004234417.12768-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usages of mptcp_pm_ops is to assign its address to the small_ops
field of the genl_family struct, which is a const pointer, and applying
ARRAY_SIZE() on it. Make it const to allow the compiler to put it in
read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 net/mptcp/pm_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9f9cd41b7733..0d6f3d912891 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1054,7 +1054,7 @@ mptcp_nl_cmd_get_limits(struct sk_buff *skb, struct genl_info *info)
 	return -EMSGSIZE;
 }
 
-static struct genl_small_ops mptcp_pm_ops[] = {
+static const struct genl_small_ops mptcp_pm_ops[] = {
 	{
 		.cmd    = MPTCP_PM_CMD_ADD_ADDR,
 		.doit   = mptcp_nl_cmd_add_addr,
-- 
2.28.0

