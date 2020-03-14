Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC63185388
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgCNAzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgCNAzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 20:55:07 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A652074E;
        Sat, 14 Mar 2020 00:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584147306;
        bh=2cnl7okg3AmxXu5dT6XkLmtDGqMJ8gn49k1Ichb3lvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBSNMpKxSaf5YdTXgfO6tieQtSAiMMIOInTFSlcgHUTi4aziXCqjN8mwLKtHj3zdx
         U2+9LO+wQ8G6EWd2JNBn0LOZplJc1V0jxG4wVeEqSuL9mxREYU1bVsv4j5zsJTGa1b
         vFCHsNJNTAKfnuk5Q9awDM13lnqyABu5r5RyQPBI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org, keescook@chromium.org
Cc:     luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 1/4] selftests/seccomp: use correct FIXTURE macro
Date:   Fri, 13 Mar 2020 17:54:58 -0700
Message-Id: <20200314005501.2446494-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314005501.2446494-1-kuba@kernel.org>
References: <20200314005501.2446494-1-kuba@kernel.org>
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
Acked-by: Kees Cook <keescook@chromium.org>
---
Kees noted that he posted an equivalent patch already, feel free
to drop this one.
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

