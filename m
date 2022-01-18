Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721654924EF
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbiARLcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:32:24 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35926 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238183AbiARLby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:31:54 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 311A41F43EC7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642505512;
        bh=j2O8LnNgJ6OKkizZGg+d3m4SsHwhUYOUVwABCSHGGkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSrrDQ9XgSxkBN+e/R1kQvEzYgYdnpmph/vwRkROcAFvLEyL/vETunfoI0pRI4KXa
         sytamsT3T59HnEdC2rMwvYUGxX6p3MGqGHZwlbrytDoCHKPr/re21UNqfCMG/nKsIN
         yj3HA124c04FoItqlpV7KiBGdxs7MpJHMPBeFurHnl8nSHLSTg8vlGYImuIQ/pbY+t
         GC9cSW1RAhQ5TEw92mRXm//8qg2EoAvjmjeeaedQ+dOBPTi+5SFMPCBAeTjb5OonHr
         LkklzKgKg8OvQB7skIJldlBXd/IMFtVlBaiGs08FTwOeqT7ZqndRxHTQL8nI8PuNhn
         xc35KbB8FpqQg==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        linux-security-module@vger.kernel.org (open list:LANDLOCK SECURITY
        MODULE), netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        mptcp@lists.linux.dev (open list:NETWORKING [MPTCP]),
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 08/10] selftests: mptcp: Add the uapi headers include variable
Date:   Tue, 18 Jan 2022 16:29:07 +0500
Message-Id: <20220118112909.1885705-9-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220118112909.1885705-1-usama.anjum@collabora.com>
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Out of tree build of this test fails if relative path of the output
directory is specified. Remove the un-needed include paths and use
KHDR_INCLUDES to correctly reach the headers.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/net/mptcp/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/Makefile b/tools/testing/selftests/net/mptcp/Makefile
index 0356c4501c99..fed6866d3b73 100644
--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -1,9 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
-top_srcdir = ../../../../..
 KSFT_KHDR_INSTALL := 1
 
-CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g  -I$(top_srcdir)/usr/include
+CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g $(KHDR_INCLUDES)
 
 TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh mptcp_sockopt.sh
-- 
2.30.2

