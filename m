Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCDE218774E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbgCQBEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733193AbgCQBEW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 21:04:22 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1446B2051A;
        Tue, 17 Mar 2020 01:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584407061;
        bh=Wbg6Rtk1wpx3tRDX+mqiJ9Yo99G3T/nP1fANeE8dp70=;
        h=From:To:Cc:Subject:Date:From;
        b=YlR9DmTVHpktl51bYvDFEyWMXYC/6VEgdI2H+AOnvQ2Mgbn82paCF0OEB3MOgVZw0
         5fyescRl7tZnQCBVOtVJA7G241wu5uypm5skLLU5N/tuaItA4jcUM0vlghUxDS/6R9
         JxWPxgPznbd7LZFX/c2vNOJz0MGPGy75v6rIBamQ=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org, keescook@chromium.org
Cc:     luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Tim.Bird@sony.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v4 0/5] kselftest: add fixture parameters
Date:   Mon, 16 Mar 2020 18:04:14 -0700
Message-Id: <20200317010419.3268916-1-kuba@kernel.org>
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

v4:
 - whitespace fixes.

v1: https://lore.kernel.org/netdev/20200313031752.2332565-1-kuba@kernel.org/
v2: https://lore.kernel.org/netdev/20200314005501.2446494-1-kuba@kernel.org/
v3: https://lore.kernel.org/netdev/20200316225647.3129354-1-kuba@kernel.org/

Jakub Kicinski (5):
  kselftest: factor out list manipulation to a helper
  kselftest: create fixture objects
  kselftest: run tests by fixture
  kselftest: add fixture variants
  selftests: tls: run all tests for TLS 1.2 and TLS 1.3

 Documentation/dev-tools/kselftest.rst       |   3 +-
 tools/testing/selftests/kselftest_harness.h | 236 +++++++++++++++-----
 tools/testing/selftests/net/tls.c           |  93 ++------
 3 files changed, 204 insertions(+), 128 deletions(-)

-- 
2.24.1

