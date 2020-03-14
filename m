Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C7418538D
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgCNAzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgCNAzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 20:55:06 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA4FE2074B;
        Sat, 14 Mar 2020 00:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584147306;
        bh=RLYRpy4622gRvx6hFmcjZnEGqbbP+eDGQEflbxTRy7I=;
        h=From:To:Cc:Subject:Date:From;
        b=GFpz8cjlMp1NrEmyKMHrmVI3Hs7alzAK/i2Saz66kE9mSYahRWSh7+2xsst17qvgt
         sqbavoBxkN7P5wtcqPSjwXNWaQreEae/ZFzwEhNKBVS56E5/DP37uzk20E1Yy0VP3C
         QdOGidw7X3zHbw3ma2K8KhghQ1fdWGABBHHEhmmU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org, keescook@chromium.org
Cc:     luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 0/4] kselftest: add fixture parameters
Date:   Fri, 13 Mar 2020 17:54:57 -0700
Message-Id: <20200314005501.2446494-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set is an attempt to make running tests for different
sets of data easier. The direct motivation is the tls
test which we'd like to run for TLS 1.2 and TLS 1.3,
but currently there is no easy way to invoke the same
tests with different parameters.

Tested all users of kselftest_harness.h.

v2:
 - don't run tests by fixture
 - don't pass params as an explicit argument

Note that we loose a little bit of type safety
without passing parameters as an explicit argument.
If user puts the name of the wrong fixture as argument
to CURRENT_FIXTURE() it will happily cast the type.

Jakub Kicinski (4):
  selftests/seccomp: use correct FIXTURE macro
  kselftest: create fixture objects
  kselftest: add fixture parameters
  selftests: tls: run all tests for TLS 1.2 and TLS 1.3

 Documentation/dev-tools/kselftest.rst         |   3 +-
 tools/testing/selftests/kselftest_harness.h   | 156 ++++++++++++++++--
 tools/testing/selftests/net/tls.c             |  93 ++---------
 tools/testing/selftests/seccomp/seccomp_bpf.c |  10 +-
 4 files changed, 168 insertions(+), 94 deletions(-)

-- 
2.24.1

