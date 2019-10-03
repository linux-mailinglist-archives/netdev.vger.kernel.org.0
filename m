Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6237C9B10
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbfJCJuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:50:06 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:39653 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbfJCJuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:50:03 -0400
Received: by mail-wr1-f49.google.com with SMTP id r3so2226982wrj.6
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=huoGsMQEO05iI2uOoEnQcuoc3CDCEdsprOqh8k25L/c=;
        b=UgPj5NjUTozLmmenPkIxz3PZ6qBcLCGLVPlTtvRNuw+H1kRDz2xtnhUQPEyDVBBGLa
         yveZmGqMn1/kl8V+yhyPkN+8g8YQMujTJ2C/H53gnIHRGb2RnWF8N+Y6MNaUFgF/OI+c
         luti6gImXwpnCgxG1kAYgREGcmD3xTAXYsZyhkGSGTUybkYvny0OTqHqvGfUU5qyF7Nc
         j6ACYEcmQ2p4m/5O3GZ4e0fDaGxaSKFsZsrQv5TC3fU9S5JOp8glw53GtTLLaZhxxpCy
         sbWrHF6eybcRnY4ZT5xwMpd/jVuDgqbZ/ecaYZM0qI8r/ugrta4xSf2WENJJ7vQS/UUw
         RB4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=huoGsMQEO05iI2uOoEnQcuoc3CDCEdsprOqh8k25L/c=;
        b=QRzcaAluQZjfrVWESCeJKygl2Pi65f6M5TV6FriRIREGVGwqzZKcnSxRGszeG+W8Dh
         kSGI+J6PBsbn/saQxiokuhoRO5kXlAjQcFJgSVI7T3MWQ3vQGwqOoUlkyuRbWBwrYfKv
         N864teds7bjx0pPu6/v+hyJrIUR722cVnKz8dT1yboMrY0xeCSVr4SCCbrxYxEndQNiF
         3UJdUJEY+F5d6SbH3MyURihaGuPs/jg4izlNhqPoGZi5mYIthE7ffR7gWmQK7JbAZYH0
         uyoRsoULSBwgG8KqhiskayCyJiOwNXoyOcHl4khJ+nquIwC18si7U/2pyA2CIQcat4uo
         CzyQ==
X-Gm-Message-State: APjAAAUfduoy9GMndHEXIOBNMcnheuk168NbWO80EzzmcEC7txxqZIm1
        yJ8i5kgLO6FPIxesucRiWOs8ukBqwcE=
X-Google-Smtp-Source: APXvYqyLHxrVzUS2Zf0mI0+NP7E8udjKI0TZ55a8P2z7hoF5ZkyahptVzwhBV/R8yqmqQkWtPhAt2g==
X-Received: by 2002:a5d:670f:: with SMTP id o15mr6081520wru.242.1570096199460;
        Thu, 03 Oct 2019 02:49:59 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id z142sm5948932wmc.24.2019.10.03.02.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:59 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 15/15] selftests: netdevsim: add tests for devlink reload with resources
Date:   Thu,  3 Oct 2019 11:49:40 +0200
Message-Id: <20191003094940.9797-16-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
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

