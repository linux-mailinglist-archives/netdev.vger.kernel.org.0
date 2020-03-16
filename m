Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE41875EA
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 23:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732871AbgCPW4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 18:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732840AbgCPW4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 18:56:55 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59FC8205ED;
        Mon, 16 Mar 2020 22:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584399414;
        bh=TzgLtqq0RK8QYJMNHKKMtrDmIEHuvSE/eTPQdeKuuq0=;
        h=From:To:Cc:Subject:Date:From;
        b=WkLqPh8tvaVdZug19o9OYyOioZzZhJTLGUZi1tnf7F3X/vhFpVNoLO399Utat2hv+
         VKRvfbe8eIPXEkkgVhNfLzWoT20tDmtiH4M6IEvvQ9nWtSEVi1SvKVOpugqkFQcqeB
         oXqnJygKw8KdWM8b8Y7h+S3sRC2FW67NFL+pp3y0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org, keescook@chromium.org
Cc:     luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Tim.Bird@sony.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 0/6] kselftest: add fixture parameters
Date:   Mon, 16 Mar 2020 15:56:40 -0700
Message-Id: <20200316225647.3129354-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Shuah please consider applying to the kselftest tree.

This set is an attempt to make running tests for different
sets of data easier. The direct motivation is the tls
test which we'd like to run for TLS 1.2 and TLS 1.3,
but currently there is no easy way to invoke the same
tests with different parameters.

Tested all users of kselftest_harness.h.

v2:
 - don't run tests by fixture
 - don't pass params as an explicit argument

v3:
 - go back to the orginal implementation with an extra
   parameter, and running by fixture (Kees);
 - add LIST_APPEND helper (Kees);
 - add a dot between fixture and param name (Kees);
 - rename the params to variants (Tim);

v1: https://lore.kernel.org/netdev/20200313031752.2332565-1-kuba@kernel.org/
v2: https://lore.kernel.org/netdev/20200314005501.2446494-1-kuba@kernel.org/

Jakub Kicinski (6):
  selftests/seccomp: use correct FIXTURE macro
  kselftest: factor out list manipulation to a helper
  kselftest: create fixture objects
  kselftest: run tests by fixture
  kselftest: add fixture variants
  selftests: tls: run all tests for TLS 1.2 and TLS 1.3

 Documentation/dev-tools/kselftest.rst         |   3 +-
 tools/testing/selftests/kselftest_harness.h   | 233 ++++++++++++++----
 tools/testing/selftests/net/tls.c             |  93 ++-----
 tools/testing/selftests/seccomp/seccomp_bpf.c |  10 +-
 4 files changed, 206 insertions(+), 133 deletions(-)

-- 
2.24.1

