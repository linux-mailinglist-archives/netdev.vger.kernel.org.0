Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B607A300043
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbhAVK2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbhAVJsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:48:13 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804B0C061222
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:47:02 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q7so4420163wre.13
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sc8jlqQuYYPLSE830XBt6S33key0tFUdbBI/SjUuSbw=;
        b=f7NCjtph2aZ/8wgtiRTwlE9QaWtpizdqBTAa0CuQdjjvMFI0MPPQ29WSaZnYw1tGU8
         fUInVCiwXWNUYizNosuM86G+QkUO7vmjO8enEhcuhbjDsffBRPD28jt7H1krFwaI+4r+
         xv4ShBISbzzu/401abHqW+FQSrT7Ru9IEmWXpKaC2zQ3ySKPPTZCK+BprPqDa33/vs48
         cYW8Gri1nwu0VIVp1CaJa9F6lEdFQwhipY4yfhxCyy82mPap4G0pF+/sle6NDj4iPIEZ
         XQpDDfpLfHy8SRiKzFqXdyRLNOvhK9UL/PXCjjMVTcqIinoo6hFQxfxgFraGotQ7Nzk+
         0FAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sc8jlqQuYYPLSE830XBt6S33key0tFUdbBI/SjUuSbw=;
        b=g4WgxVcsnCYhevLjtOVx7odsGGeQKwY367XKreiZ6c871gvDeVLAOjKfL6D5zKTu+F
         3fDQ/rDHtyl4RKd1aNQbrjGcH8NqA37UjUqRDhsYKLnT1KnQ/LmJwSs0UMncAi8Ny/bj
         DReLkfT3Prd7zd1Rx0LakfhOT+pKgSOQrZpSpcvILV9J+9b1usddi9uvMNl9h/O2XPlZ
         PFfkEda2LaDccEVT2Z3eLVtRZY0xbO7BfvqBAg7NxXiGjmrhr2QNc4K70zyEsPNGMCiH
         T6IMlhnDBw10UJv8x2FHjzJJIHqL064yp7PaXlp+jCLkoVFuh918JSJ01d4qC7T4P7WK
         dheQ==
X-Gm-Message-State: AOAM5301TJ+314cxtOyic1+7oZ83IAcCMCXd7EVQHd1wYrQwRrVOMBQ6
        nXXbbJiHO5e/lcJYGmsyWrOisAnsUJpczRP/Ud0=
X-Google-Smtp-Source: ABdhPJxsavfz+NLZLqmmUqMtAm0vy5dUnQZnuJKFjLdYln/nVUWZAF5JITg28CUJm+S91sbpdynX0Q==
X-Received: by 2002:adf:f04b:: with SMTP id t11mr3516825wro.347.1611308821018;
        Fri, 22 Jan 2021 01:47:01 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id r13sm11441671wrt.10.2021.01.22.01.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:47:00 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 10/10] selftests: add netdevsim devlink lc test
Date:   Fri, 22 Jan 2021 10:46:48 +0100
Message-Id: <20210122094648.1631078-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add test to verify netdevsim driver line card functionality.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- adjusted to "active"->"insert_type" activation conversion
---
 .../drivers/net/netdevsim/devlink.sh          | 62 ++++++++++++++++++-
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 40909c254365..212fe3d5b1c6 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -5,12 +5,13 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
 	   netns_reload_test resource_test dev_info_test \
-	   empty_reporter_test dummy_reporter_test"
+	   empty_reporter_test dummy_reporter_test linecard_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
 BUS_ADDR=10
 PORT_COUNT=4
+LINECARD_COUNT=2
 DEV_NAME=netdevsim$BUS_ADDR
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
@@ -507,10 +508,67 @@ dummy_reporter_test()
 	log_test "dummy reporter test"
 }
 
+check_linecards_state()
+{
+	local expected_state_0=$1
+	local expected_state_1=$2
+
+	local state=$(devlink lc show $DL_HANDLE lc 0 -j | jq -e -r ".[][][].state")
+	check_err $? "Failed to get linecard 0 state"
+
+	[ "$state" == "$expected_state_0" ]
+	check_err $? "Unexpected linecard 0 state (got $state, expected $expected_state_0)"
+
+	local state=$(devlink lc show $DL_HANDLE lc 1 -j | jq -e -r ".[][][].state")
+	check_err $? "Failed to get linecard 1 state"
+
+	[ "$state" == "$expected_state_1" ]
+	check_err $? "Unexpected linecard 1 state (got $state, expected $expected_state_1)"
+}
+
+linecard_test()
+{
+	RET=0
+
+	check_linecards_state "unprovisioned" "unprovisioned"
+
+	devlink lc set $DL_HANDLE lc 0 type card2ports
+	check_err $? "Failed to provision linecard 0 with card2ports"
+
+	check_linecards_state "provisioned" "unprovisioned"
+
+	devlink lc set $DL_HANDLE lc 1 type card4ports
+	check_err $? "Failed to provision linecard 0 with card4ports"
+
+	check_linecards_state "provisioned" "provisioned"
+
+	echo "card2ports"> $DEBUGFS_DIR/linecards/0/inserted_type
+	check_err $? "Failed to insert linecard 0"
+
+	check_linecards_state "active" "provisioned"
+
+	echo "card4ports"> $DEBUGFS_DIR/linecards/1/inserted_type
+	check_err $? "Failed to insert linecard 1"
+
+	check_linecards_state "active" "active"
+
+	devlink lc set $DL_HANDLE lc 0 notype
+	check_err $? "Failed to unprovision linecard 0"
+
+	check_linecards_state "unprovisioned" "active"
+
+	devlink lc set $DL_HANDLE lc 1 notype
+	check_err $? "Failed to unprovision linecard 1"
+
+	check_linecards_state "unprovisioned" "unprovisioned"
+
+	log_test "linecard test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-	echo "$BUS_ADDR $PORT_COUNT" > /sys/bus/netdevsim/new_device
+	echo "$BUS_ADDR $PORT_COUNT $LINECARD_COUNT" > /sys/bus/netdevsim/new_device
 	while [ ! -d $SYSFS_NET_DIR ] ; do :; done
 }
 
-- 
2.26.2

