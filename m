Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A470D183F80
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 04:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgCMDS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 23:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbgCMDR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 23:17:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293112071C;
        Fri, 13 Mar 2020 03:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584069479;
        bh=dBsWz9addWONFKhna+kM5dhqeNsPSINqhlpIe9wHGnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkOEPFxekPaOUhpwQXExkI6th5eeIMqR55776626fuZNyXStrSi70kEqHmU8NL97o
         Fbd4U+DT48btY2a8OE525yZLr8qzcBljr+tC6qWHMKiLJ5kfQ/6ZUQPr1Zf1tbqIiM
         1/A32nCujHQDknbxy2z20lxbSnqhyiAMUa265XNI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org
Cc:     keescook@chromium.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/5] selftests/seccomp: use correct FIXTURE macro
Date:   Thu, 12 Mar 2020 20:17:48 -0700
Message-Id: <20200313031752.2332565-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313031752.2332565-1-kuba@kernel.org>
References: <20200313031752.2332565-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting kdoc:

FIXTURE_DATA:
 * This call may be used when the type of the fixture data
 * is needed.  In general, this should not be needed unless
 * the *self* is being passed to a helper directly.

FIXTURE:
 * Defines the data provided to TEST_F()-defined tests as *self*.  It should be
 * populated and cleaned up using FIXTURE_SETUP() and FIXTURE_TEARDOWN().

seccomp should use FIXTURE to declare types.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index ee1b727ede04..7bf82fb07f67 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -909,7 +909,7 @@ TEST(ERRNO_order)
 	EXPECT_EQ(12, errno);
 }
 
-FIXTURE_DATA(TRAP) {
+FIXTURE(TRAP) {
 	struct sock_fprog prog;
 };
 
@@ -1020,7 +1020,7 @@ TEST_F(TRAP, handler)
 	EXPECT_NE(0, (unsigned long)sigsys->_call_addr);
 }
 
-FIXTURE_DATA(precedence) {
+FIXTURE(precedence) {
 	struct sock_fprog allow;
 	struct sock_fprog log;
 	struct sock_fprog trace;
@@ -1509,7 +1509,7 @@ void tracer_poke(struct __test_metadata *_metadata, pid_t tracee, int status,
 	EXPECT_EQ(0, ret);
 }
 
-FIXTURE_DATA(TRACE_poke) {
+FIXTURE(TRACE_poke) {
 	struct sock_fprog prog;
 	pid_t tracer;
 	long poked;
@@ -1817,7 +1817,7 @@ void tracer_ptrace(struct __test_metadata *_metadata, pid_t tracee,
 		change_syscall(_metadata, tracee, -1, -ESRCH);
 }
 
-FIXTURE_DATA(TRACE_syscall) {
+FIXTURE(TRACE_syscall) {
 	struct sock_fprog prog;
 	pid_t tracer, mytid, mypid, parent;
 };
@@ -2321,7 +2321,7 @@ struct tsync_sibling {
 		}							\
 	} while (0)
 
-FIXTURE_DATA(TSYNC) {
+FIXTURE(TSYNC) {
 	struct sock_fprog root_prog, apply_prog;
 	struct tsync_sibling sibling[TSYNC_SIBLINGS];
 	sem_t started;
-- 
2.24.1

