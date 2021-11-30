Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31964638F5
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245246AbhK3PGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243982AbhK3O7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:59:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181B7C07E5DB;
        Tue, 30 Nov 2021 06:52:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5139B81A4D;
        Tue, 30 Nov 2021 14:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ABDC8D181;
        Tue, 30 Nov 2021 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283936;
        bh=4lEzPjoY8VNC6YcnCKYxB+7P4eDvMZKWbxCenFRzZwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WA/vye/WwWmcFof/DazpC/ryDbQk33Fn6RbzXtvZ/XO/O36rfEZSG5la+tYfG+kSq
         UFiH2gQuCpwiOxvKHX7X3jJYyBhi7IUkQHlleXVoexwRSKdVwgHF2X8pvxzQDScjjh
         PoctEkXupITIIbe2TfTVTs5/gmmwwRJ0IVSsV1FVU8vt7ZPT5n11v7DcB3DJtQ9txc
         MvkKwZuoIvkv0KpBUDHoJagBPQBejapya0lK1zWxVzUE+lWuqKbz4MtdI0auuu05Bk
         X8v6wcOWy6q3pHKGNBxDgh5Ms4+FeIptzfb8UFIAakl4Fx6nbKvYzd/Z6YCx8HDSUw
         EwQGc1ig4Tk9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <zhijianx.li@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/25] selftests/tc-testings: Be compatible with newer tc output
Date:   Tue, 30 Nov 2021 09:51:39 -0500
Message-Id: <20211130145156.946083-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li Zhijian <zhijianx.li@intel.com>

[ Upstream commit ac2944abe4d7732f29a79f063c9cae7df2a3e3cc ]

old tc(iproute2-5.9.0) output:
 action order 1: bpf action.o:[action-ok] id 60 tag bcf7977d3b93787c jited default-action pipe
newer tc(iproute2-5.14.0) output:
 action order 1: bpf action.o:[action-ok] id 64 name tag bcf7977d3b93787c jited default-action pipe

It can fix below errors:
 # ok 260 f84a - Add cBPF action with invalid bytecode
 # not ok 261 e939 - Add eBPF action with valid object-file
 #       Could not match regex pattern. Verify command output:
 # total acts 0
 #
 #       action order 1: bpf action.o:[action-ok] id 42 name  tag bcf7977d3b93787c jited default-action pipe
 #        index 667 ref 1 bind 0

Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
index 47a3082b66613..8feaa712a7f5a 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
@@ -68,7 +68,7 @@
         "cmdUnderTest": "$TC action add action bpf object-file $EBPFDIR/action.o section action-ok index 667",
         "expExitCode": "0",
         "verifyCmd": "$TC action get action bpf index 667",
-        "matchPattern": "action order [0-9]*: bpf action.o:\\[action-ok\\] id [0-9]* tag [0-9a-f]{16}( jited)? default-action pipe.*index 667 ref",
+        "matchPattern": "action order [0-9]*: bpf action.o:\\[action-ok\\] id [0-9].* tag [0-9a-f]{16}( jited)? default-action pipe.*index 667 ref",
         "matchCount": "1",
         "teardown": [
             "$TC action flush action bpf"
-- 
2.33.0

