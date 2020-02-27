Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617BA1711BD
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgB0Huo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:44 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:32841 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728528AbgB0Huh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:37 -0500
Received: by mail-wm1-f43.google.com with SMTP id m10so6342332wmc.0
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mC4PXVHlN/1ABGeU3AxAO98HTrdy2UHIFeXngMq+NeU=;
        b=sFlKuvhKHnBv+YK4OE/TZPH2w/eebRa3aLSv64TDsbY9XFe3sEl/BjzRVHhWeIz+5M
         yBGDES29OtJEoFGPdK8foLNrcct4Rxf4RxXbIzFLoocb7gqTJY4w5zUV+paTYJydSOnT
         JuyoEnt5OrX3mMORNUNFUQ2JJSyPffAKSw6xZ+228lG57RHj2Ci68nPiK1I2mKWnH1tQ
         fUOyOytQ09eHGmKteh4AsOSbrQNVI6uTV7EghdmdLJut9cUlKI1O+c8Zi5VCHUbEeEKI
         gFMgq0McfVTofO+25d3peUXJQM89qHrzktKcw1eWo+tYgJc92PyaQFRo03rU1lKhDjzE
         hW6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mC4PXVHlN/1ABGeU3AxAO98HTrdy2UHIFeXngMq+NeU=;
        b=Lz9+diub9qEoF6dOR7Qk8GAAUL7nsAezVd8LecL2EGReuVPE7snYdnHtkVRG+xKpes
         Cx+HUDaWwvOWIKzX8tW1mxI3DIWmtBZrfIjHXBcnuL9XHEZWwrQ3E/6768e/ESomXWKD
         q0OTSjRbi16whOg3KJmopIDubgF2vP6MZ16cVEf1ZQ7/XsQcELiPQZJA1ENRYy26VgD/
         I63qetKrebZOYVoKHfp72ZWh2gHfDy8LL0QzkmM26PdQJSHcUnrCLXMbZqEgiiUhzieS
         +aRY2VfyRjCwPS0mdnQGrmmS2HVkOAe/RdpXf9VX4OcJeefXpP5eUHyP/nwawx7DOHOI
         SKmw==
X-Gm-Message-State: APjAAAXu7bPyeupghF2JtLTNvo5sl2bSmTFsZIJQ5xlroZgJwd3XQdtC
        LBsTVdeCa2ap/R+upPmg9B8baIwuqdU=
X-Google-Smtp-Source: APXvYqxuq1cwgSnoGEnhxA351bfZNZVPSnDVuSTPAitJg1SONc1xfBWIYupwDxxp5+SJpOZeC1Fhrg==
X-Received: by 2002:a7b:c08d:: with SMTP id r13mr3620794wmh.84.1582789834403;
        Wed, 26 Feb 2020 23:50:34 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b16sm1880765wrq.14.2020.02.26.23.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:34 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 10/16] selftests: devlink_lib: Check devlink info command is supported
Date:   Thu, 27 Feb 2020 08:50:15 +0100
Message-Id: <20200227075021.3472-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Sanity check for devlink info command.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 tools/testing/selftests/net/forwarding/devlink_lib.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 24798ae846de..07e360e2f275 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -35,6 +35,12 @@ if [ $? -ne 0 ]; then
 	exit 1
 fi
 
+devlink dev help 2>&1 | grep info &> /dev/null
+if [ $? -ne 0 ]; then
+	echo "SKIP: iproute2 too old, missing devlink dev info support"
+	exit 1
+fi
+
 ##############################################################################
 # Devlink helpers
 
-- 
2.21.1

