Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED681B9709
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 08:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgD0GK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 02:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726221AbgD0GK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 02:10:59 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EA1C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 23:10:58 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u16so18993722wmc.5
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 23:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DcgnoTRiupIGvlClR2P0tm0JopcCm8tuPglMWuMR5MY=;
        b=FAwKuFCyZ9djNlBuZOkPVwTSQUoldRLhZVF9DwP3TKmMI1V44xGH5BLsnt7HWvBmgg
         R6WhaSdtH6M7b76tnCBvZjZ/ybSX9vrzzduPlG3RKeji+rzZ0ZKZ5zU6AdwPIamLLVxa
         7N3XPyw8hvEZnUkQSbwSr5CyMAmtksUMTwvhU6TEdpy7pbc0txw4/xOljN2wxDQ1Q46j
         k8FZLX9+7svUs50wijYlSMkJ74qxSnGgpEuuNHA8JQvYRmMwSLbIc0Owy0/nrDOCudot
         EfzMEY4VjxqAEcoaTgzfz07v22ykDg4Sy+4k4mBG1vuHvtP6mxTlECzMDqcQG6rrTA3D
         HlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DcgnoTRiupIGvlClR2P0tm0JopcCm8tuPglMWuMR5MY=;
        b=FeXAm+hVF8fLIfRT8JSobJ7fjcV0DxS3CfGp8mhLTe8E2EPCOsWccPDMgUrhj9ApQp
         6bniUUgZ2HLp0KQ1rJBmHXm6c4+dR8/GFGgHKHou0TFhjzZFQwdmcczHRISzwtcFzKEF
         W1WIho4ybyRc7xDi4lWdkNORsMK9CEGt+7fCACiQ1uZUrgE2GzkKtmCx8FcRJE+nBZkP
         myhX5WKK8xQl4cDam6CHiejFn13KnSLu6RF/s0zAJSU6YsK7KPeDE1YNmw1UQTtd0WTk
         cH+Ijys/rg+gK8/G8iEA3CWfiht01h2WR0zDemuhjiBCtlz9tjYRc7IsKEZX3pNlEhxw
         4WDA==
X-Gm-Message-State: AGi0PuZsgZFNQy82EGR0NfPp+ZfZ25Bmr3z3GI+ZMeUq7Mb7sudNCvza
        Rq81kBvWAabYlPaJ9h1Ohqi8VkM9SXE=
X-Google-Smtp-Source: APiQypJWysHt69Db6upqDmbnheMOjIiPcESBvNtkSuPcl/8UJl++R0VWYceb0UlmRTf9fKO4Nh2Tqg==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr25082407wmm.48.1587967856989;
        Sun, 26 Apr 2020 23:10:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 1sm14244223wmz.13.2020.04.26.23.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 23:10:56 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        alexanderk@mellanox.com, mlxsw@mellanox.com
Subject: [patch iproute2] tc: m_action: check cookie hex string len
Date:   Mon, 27 Apr 2020 08:10:55 +0200
Message-Id: <20200427061055.4058-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Check the cookie hex string len is dividable by 2 as the valid hex
string always should be.

Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/m_action.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index 108329db29d0..b41782de9a02 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -291,7 +291,8 @@ done0:
 					invarg(cookie_err_m, *argv);
 				}
 
-				if (hex2mem(*argv, act_ck, slen / 2) < 0)
+				if (slen % 2 ||
+				    hex2mem(*argv, act_ck, slen / 2) < 0)
 					invarg("cookie must be a hex string\n",
 					       *argv);
 
-- 
2.21.1

