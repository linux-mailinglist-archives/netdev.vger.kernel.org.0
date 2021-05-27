Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636F6392C2E
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 12:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhE0K4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 06:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbhE0K4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 06:56:53 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63365C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 03:55:18 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso2314393wmm.3
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 03:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JVsrlE+MEh311GaOsnSdNfIQf5DAGvZBRabeMifH74M=;
        b=Zpi2bFQtp/ZWlM4B/P9BfckI9cDAcjGM5GNR+tmUFX37x5OUL2I9557ycTarEj6qRG
         bTAzDdd/1HcCfVv9nzwr700Kr3L+c2Ngz9JIg2AaTN8v6DVEzKAIXlkrLZQkfgSs2f7C
         3Vq6Ng2TCxuHvX4JnN+1syUpsi+U3cylLgvQeY4rnXOmmS2CZXtzdCN+RqKGxIS6chNJ
         mH5cNAM6RuGfokNu8J1W8n7dz/DjEu27GkgDFjRrlQ0tGxsH8zRtkUhWIb79D2FdQeAP
         8YSU5iHGPtRNKlJDp+i9y1PFjsycwU97VwNkXEtljnqTa0QKSnd1WtVoNXqDB8NK9zDt
         we/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JVsrlE+MEh311GaOsnSdNfIQf5DAGvZBRabeMifH74M=;
        b=F93Y+xrsMBGwQWUpqAMXnXpEwSs8hKohAdjmrB71G11dD1ALyD/V87BYx+nh73jUsg
         ZXVQWMv5gc3fM9K5JMmqP2NU3ChtDjCtgrJHx2IKgWeFo4mOGqLc44rtCMySxy4sD2S7
         8/dmJFv7JUEa/jDBbXmkYh6i0HTF4RSi6l0u+A3qLglR8tdMCGlyv+qSrO5k/6INRETm
         Kly1VYxGVjSD6rYaXxgqqLC9WnEAqQ/KTUdP6yRmHWTu/FAYt3B8acWoYg+ZSbIgA8Rt
         RCUIhgQa9eEuFxGXc1gbd6qAv7iIucpJQRjCksM6QrIKB/s0o4yx0wgZOVk//VT/XT8I
         KF5g==
X-Gm-Message-State: AOAM5337nVJ4eAz1rsFRf//WIwUTiBsyPU5oLnPW7uhfwJKssxjU60V2
        fXi0DR6YFdjnHZETzbz4CbENc5XUtmhU6vQ+
X-Google-Smtp-Source: ABdhPJyRxynpKkS3j4+Lo/jg+fVhN5kEYNg8wSXeys9QDeul4Pv10nNo0OxGxaaf1gKc5JZ3Z6kBdg==
X-Received: by 2002:a05:600c:2209:: with SMTP id z9mr2814380wml.120.1622112917022;
        Thu, 27 May 2021 03:55:17 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id n13sm2923822wrg.75.2021.05.27.03.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 03:55:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com
Subject: [patch net-next] selftests: devlink_lib: add check for devlink device existence
Date:   Thu, 27 May 2021 12:55:15 +0200
Message-Id: <20210527105515.790330-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

If user passes devlink handle over DEVLINK_DEV variable, check if the
device exists.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 tools/testing/selftests/net/forwarding/devlink_lib.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 9c12c4fd3afc..c19e001f138b 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -18,6 +18,12 @@ if [[ ! -v DEVLINK_DEV ]]; then
 
 	DEVLINK_VIDDID=$(lspci -s $(echo $DEVLINK_DEV | cut -d"/" -f2) \
 			 -n | cut -d" " -f3)
+else
+	devlink dev show $DEVLINK_DEV &> /dev/null
+	if [ $? -ne 0 ]; then
+		echo "SKIP: devlink device \"$DEVLINK_DEV\" not found"
+		exit 1
+	fi
 fi
 
 ##############################################################################
-- 
2.31.1

