Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA8008D728
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfHNP0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:26:12 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:40801 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfHNP0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:26:10 -0400
Received: by mail-wm1-f44.google.com with SMTP id v19so4831289wmj.5
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 08:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oxRwEXAVstWIzVhCtKLI+uJftYF7Jca1fTx4xr/sTgc=;
        b=kXbXalR2NOhEWKWyftMpB7kW1+KN/PJHSujXsTldyzRswfwyYMiJdI/Crd3zK96Otv
         zbEg0vjKBL2H2QQJS+JPQ+XTVy333IKywBk+mNnCdkCY6pXmLYr2IyiJUC9nQEWrKtJe
         olrpMTKNkETFc5gHU9E2yKcCaWAHjYNiqclPabeykUCbiFTANiRryIoUOkiIHs4nampO
         f9VRtJvrKjvC4zqhkc4tMdniQ0ljP18uGAYMq92uG3CWH83CMuXr1ITclN6WRdZHIP/1
         K2Pt1WuoMKrMyH4Zyxbl6ZEfK3EksFlpxmwihM7497pyPs+loO+JHC26TxjaSyJkoov8
         w/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oxRwEXAVstWIzVhCtKLI+uJftYF7Jca1fTx4xr/sTgc=;
        b=hFJwWl+VDGhCPLS9Nt8bI/NpnNziZZ6RsfePa4sxbwTRlc37D3c0S+GKI8yBhLmNLX
         0dtWrUgFa5qkWhJEnFA5G8Tn6/r8877M41E0h2ysOxgXPwiz383Dy7401erE+RTPUn6a
         xpGDjUlozBc0geISH8HC38QFlcBi2Xv4hxGS4HCuF7+PzC+DpMZ6z5VM7QQs76V9MuI+
         TRDNBrfiw7i2VS+oeDS6VKGOZ6CwpErMECWcrLcxizqTzFRUVlPctgHtwMWJX4zKXcSi
         j3PQF6YHrPmInMqg0zE9SiilD39G4DQpIHyjhLg9r6zrPO1Ii1wQFzup2J20Hs7eFUFe
         tOCQ==
X-Gm-Message-State: APjAAAUYrW6+dE8+3q/9Dtz6kiSnwrXNF4eJjER4v4vp9U+R3F7n7gRl
        cf/QhPGF8ijXOLUifMhKIMumnm/wzSk=
X-Google-Smtp-Source: APXvYqxiiLIOnzoFQ5bre5fzs5vHdIQg5Gn5eSIUmRSf8HUiAd1oS0e7j9QOeADtIiFGX8N4jCL66Q==
X-Received: by 2002:a1c:e487:: with SMTP id b129mr9269829wmh.93.1565796367815;
        Wed, 14 Aug 2019 08:26:07 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t140sm4531201wmt.0.2019.08.14.08.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 08:26:07 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 2/2] selftests: netdevsim: add devlink params tests
Date:   Wed, 14 Aug 2019 17:26:04 +0200
Message-Id: <20190814152604.6385-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814152604.6385-1-jiri@resnulli.us>
References: <20190814152604.6385-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Test recently added netdevsim devlink param implementation.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
-using cmd_jq helper
---
 .../drivers/net/netdevsim/devlink.sh          | 62 ++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 9d8baf5d14b3..6828e9404460 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -3,7 +3,7 @@
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 
-ALL_TESTS="fw_flash_test"
+ALL_TESTS="fw_flash_test params_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
@@ -30,6 +30,66 @@ fw_flash_test()
 	log_test "fw flash test"
 }
 
+param_get()
+{
+	local name=$1
+
+	cmd_jq "devlink dev param show $DL_HANDLE name $name -j" \
+	       '.[][][].values[] | select(.cmode == "driverinit").value'
+}
+
+param_set()
+{
+	local name=$1
+	local value=$2
+
+	devlink dev param set $DL_HANDLE name $name cmode driverinit value $value
+}
+
+check_value()
+{
+	local name=$1
+	local phase_name=$2
+	local expected_param_value=$3
+	local expected_debugfs_value=$4
+	local value
+
+	value=$(param_get $name)
+	check_err $? "Failed to get $name param value"
+	[ "$value" == "$expected_param_value" ]
+	check_err $? "Unexpected $phase_name $name param value"
+	value=$(<$DEBUGFS_DIR/$name)
+	check_err $? "Failed to get $name debugfs value"
+	[ "$value" == "$expected_debugfs_value" ]
+	check_err $? "Unexpected $phase_name $name debugfs value"
+}
+
+params_test()
+{
+	RET=0
+
+	local max_macs
+	local test1
+
+	check_value max_macs initial 32 32
+	check_value test1 initial true Y
+
+	param_set max_macs 16
+	check_err $? "Failed to set max_macs param value"
+	param_set test1 false
+	check_err $? "Failed to set test1 param value"
+
+	check_value max_macs post-set 16 32
+	check_value test1 post-set false Y
+
+	devlink dev reload $DL_HANDLE
+
+	check_value max_macs post-reload 16 16
+	check_value test1 post-reload false N
+
+	log_test "params test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
2.21.0

