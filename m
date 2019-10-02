Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C79C8DFD
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfJBQNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:13:00 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:36165 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbfJBQMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:53 -0400
Received: by mail-wr1-f49.google.com with SMTP id y19so20357294wrd.3
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=huoGsMQEO05iI2uOoEnQcuoc3CDCEdsprOqh8k25L/c=;
        b=rnuKolTgdDC3rStKcPPKv7tGuFrkLpBUuPyjhcYZ3FYQSU9WgtsAqY88sxt3d5ppdo
         rMEum0gizFbsdQs6NjFqFHEukc3AHTXbr+gkHyulX4tcu9siVHXjoFZ4OIWAn8IlCInW
         ZeeCBVXljMJQM/y/nlJwXyadMEy0SdrEpfqKNfEPdUeN9JaL602Rc74Ici0/kUFNpkwP
         DUOJYqOlWuPY4hr4/CFZM3Jf0pR4Nh1OvIzWe7x9P3j5Jl80tLdZ6FxEXGN5Y2XZkwas
         IIbMSnl5O4/YS+qbxAE1L2mTt0rGCFLklEChJ2xI7FXOIrcIj9g0SXov/Mq+FCT7li+r
         2OrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=huoGsMQEO05iI2uOoEnQcuoc3CDCEdsprOqh8k25L/c=;
        b=ICqFCeLkFZNPrO8Wu6kYDOSZ7k4Bu6N45NsAHNP9grbU9NOIDo59u7mmj58wpXzyST
         tORQ7rfx0VvwJF4PhDFtBfWr6CGHTWWuVeYYFPJnBkPb7ZlmisIQ2l2/clNaPkomyzRc
         qBvrFTQ0rwJCBdul36yXTyVRdue05r+hAFC+FOnACIux8U0MRMcqfQFQfw+j+FC0SXFY
         kBsSc9G7IY93+clsfNG6Lj0SaCidbRjXXXbli1a7eHRfppS5Ish/66g/lsL1pZLEJk/h
         IjyuxhYWiPZd9nunpmWDL8RzMNcHSmIrqa6hvs70rp6cscs5NVSm2NcyG0jsLfzNNjbf
         O/rw==
X-Gm-Message-State: APjAAAUxC3h2255t3HjE9hZ6kbzh4r97HGSJD/XHnFg7I9jQ7Q869+lO
        dhHrl08EWQkPsVy1SI7mfrG2nP6STKA=
X-Google-Smtp-Source: APXvYqw6N5OhAP2pFtpd/9Q1XfpnTmZyBrZlc0lrXt/Lo5MFR3hnQ7TyoSHFx2zRflKDWoBWPUGXIQ==
X-Received: by 2002:adf:e951:: with SMTP id m17mr3348688wrn.154.1570032769355;
        Wed, 02 Oct 2019 09:12:49 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s9sm6462188wme.36.2019.10.02.09.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 15/15] selftests: netdevsim: add tests for devlink reload with resources
Date:   Wed,  2 Oct 2019 18:12:31 +0200
Message-Id: <20191002161231.2987-16-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002161231.2987-1-jiri@resnulli.us>
References: <20191002161231.2987-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add couple of tests for devlink reload testing and also resource
limitations testing, along with devlink reload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 120 +++++++++++++++++-
 1 file changed, 119 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 115837355eaf..69af99bd562b 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -3,7 +3,8 @@
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 
-ALL_TESTS="fw_flash_test params_test regions_test"
+ALL_TESTS="fw_flash_test params_test regions_test reload_test \
+	   netns_reload_test resource_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
@@ -142,6 +143,123 @@ regions_test()
 	log_test "regions test"
 }
 
+reload_test()
+{
+	RET=0
+
+	devlink dev reload $DL_HANDLE
+	check_err $? "Failed to reload"
+
+	log_test "reload test"
+}
+
+netns_reload_test()
+{
+	RET=0
+
+	ip netns add testns1
+	check_err $? "Failed add netns \"testns1\""
+	ip netns add testns2
+	check_err $? "Failed add netns \"testns2\""
+
+	devlink dev reload $DL_HANDLE netns testns1
+	check_err $? "Failed to reload into netns \"testns1\""
+
+	devlink -N testns1 dev reload $DL_HANDLE netns testns2
+	check_err $? "Failed to reload from netns \"testns1\" into netns \"testns2\""
+
+	ip netns del testns2
+	ip netns del testns1
+
+	log_test "netns reload test"
+}
+
+DUMMYDEV="dummytest"
+
+res_val_get()
+{
+	local netns=$1
+	local parentname=$2
+	local name=$3
+	local type=$4
+
+	cmd_jq "devlink -N $netns resource show $DL_HANDLE -j" \
+	       ".[][][] | select(.name == \"$parentname\").resources[] \
+	        | select(.name == \"$name\").$type"
+}
+
+resource_test()
+{
+	RET=0
+
+	ip netns add testns1
+	check_err $? "Failed add netns \"testns1\""
+	ip netns add testns2
+	check_err $? "Failed add netns \"testns2\""
+
+	devlink dev reload $DL_HANDLE netns testns1
+	check_err $? "Failed to reload into netns \"testns1\""
+
+	# Create dummy dev to add the address and routes on.
+
+	ip -n testns1 link add name $DUMMYDEV type dummy
+	check_err $? "Failed create dummy device"
+	ip -n testns1 link set $DUMMYDEV up
+	check_err $? "Failed bring up dummy device"
+	ip -n testns1 a a 192.0.1.1/24 dev $DUMMYDEV
+	check_err $? "Failed add an IP address to dummy device"
+
+	local occ=$(res_val_get testns1 IPv4 fib occ)
+	local limit=$((occ+1))
+
+	# Set fib size limit to handle one another route only.
+
+	devlink -N testns1 resource set $DL_HANDLE path IPv4/fib size $limit
+	check_err $? "Failed to set IPv4/fib resource size"
+	local size_new=$(res_val_get testns1 IPv4 fib size_new)
+	[ "$size_new" -eq "$limit" ]
+	check_err $? "Unexpected \"size_new\" value (got $size_new, expected $limit)"
+
+	devlink -N testns1 dev reload $DL_HANDLE
+	check_err $? "Failed to reload"
+	local size=$(res_val_get testns1 IPv4 fib size)
+	[ "$size" -eq "$limit" ]
+	check_err $? "Unexpected \"size\" value (got $size, expected $limit)"
+
+	# Insert 2 routes, the first is going to be inserted,
+	# the second is expected to fail to be inserted.
+
+	ip -n testns1 r a 192.0.2.0/24 via 192.0.1.2
+	check_err $? "Failed to add route"
+
+	ip -n testns1 r a 192.0.3.0/24 via 192.0.1.2
+	check_fail $? "Unexpected successful route add over limit"
+
+	# Now create another dummy in second network namespace and
+	# insert two routes. That is over the limit of the netdevsim
+	# instance in the first namespace. Move the netdevsim instance
+	# into the second namespace and expect it to fail.
+
+	ip -n testns2 link add name $DUMMYDEV type dummy
+	check_err $? "Failed create dummy device"
+	ip -n testns2 link set $DUMMYDEV up
+	check_err $? "Failed bring up dummy device"
+	ip -n testns2 a a 192.0.1.1/24 dev $DUMMYDEV
+	check_err $? "Failed add an IP address to dummy device"
+	ip -n testns2 r a 192.0.2.0/24 via 192.0.1.2
+	check_err $? "Failed to add route"
+	ip -n testns2 r a 192.0.3.0/24 via 192.0.1.2
+	check_err $? "Failed to add route"
+
+	devlink -N testns1 dev reload $DL_HANDLE netns testns2
+	check_fail $? "Unexpected successful reload from netns \"testns1\" into netns \"testns2\""
+
+	ip netns del testns2
+	ip netns del testns1
+
+	log_test "resource test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
2.21.0

