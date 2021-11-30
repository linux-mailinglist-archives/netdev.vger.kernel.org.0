Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50D44638EB
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244910AbhK3PG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243113AbhK3O61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:58:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D62EC0698D3;
        Tue, 30 Nov 2021 06:51:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB380CE1A4C;
        Tue, 30 Nov 2021 14:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBB5C53FC1;
        Tue, 30 Nov 2021 14:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283873;
        bh=QU6ElOIC9JTMbdY03CovcZaX0EF7e5BTCajILyq6Ywk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2JffrZ6lStvB7KfVcc1Iv+dfr13tESTDH82VBnoCKOukv3/yrIWa0WUuhDxLar71
         K8R0olPbcg5t4TxGNWI7H3XAfKChTilsxACUKYB/5oJ19XWtyIHmOwHlJxAycT7luZ
         E23th9wJJhZJcUOaudK9ffopU2uhFV8O1Knc2RGLTE6ekr378uAPBKYhdU0Tl8/0SL
         S0DLFyX718CIp4mWr/0dZedxT798//yqyRvFh8L/9xepwiF83u3FXUfv7PmpKcbFsF
         NgqldTBofScRdtpJhiRhIMEQOFRpHVgr25YoWAAjJrj6wp9KGKWdWr/6J9C0zca3mg
         ac1EP+F0X5IaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <zhijianx.li@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/43] selftests/tc-testings: Be compatible with newer tc output
Date:   Tue, 30 Nov 2021 09:49:57 -0500
Message-Id: <20211130145022.945517-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
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
index 503982b8f295b..91832400ddbdb 100644
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

