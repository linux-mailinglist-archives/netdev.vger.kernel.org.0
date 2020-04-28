Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAF01BB334
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgD1BD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgD1BD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 21:03:58 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35E50206D6;
        Tue, 28 Apr 2020 01:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588035837;
        bh=MGJvylZiGkTZwwzCHb5ZFTaQJFtBOk//T/dAGP9LFuk=;
        h=From:To:Cc:Subject:Date:From;
        b=B4HM7VVc2Ui10qnNjm+8cBH8Ycc+25mPPyK4A0JOCN9vXVxeH/2yQO8iuSHHKxu7a
         K10b9rA/jDKae6xISuL+IN5+3tNKNWuy8l5GgTm/TArZxHNm4ZPNoMqtSggtZPCYuj
         LmfEvfSWVH+qp6jnrPyIfwxvMubg+ngkjP751/BI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     keescook@chromium.org, shuah@kernel.org, netdev@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v6 0/5] kselftest: add fixture parameters
Date:   Mon, 27 Apr 2020 18:03:46 -0700
Message-Id: <20200428010351.331260-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
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

Dave, would it be possible to take these via net-next?
It seems we're failing to get Shuah's attention.

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

v5 (Kees):
 - move a comment;
 - remove a temporary variable;
 - reword the commit message on patch 4.

v6:
 - resend for net-next.

v1: https://lore.kernel.org/netdev/20200313031752.2332565-1-kuba@kernel.org/
v2: https://lore.kernel.org/netdev/20200314005501.2446494-1-kuba@kernel.org/
v3: https://lore.kernel.org/netdev/20200316225647.3129354-1-kuba@kernel.org/
v4: https://lore.kernel.org/netdev/20200317010419.3268916-1-kuba@kernel.org/
v5: https://lore.kernel.org/netdev/20200318010153.40797-1-kuba@kernel.org/

Jakub Kicinski (5):
  kselftest: factor out list manipulation to a helper
  kselftest: create fixture objects
  kselftest: run tests by fixture
  kselftest: add fixture variants
  selftests: tls: run all tests for TLS 1.2 and TLS 1.3

 Documentation/dev-tools/kselftest.rst       |   3 +-
 tools/testing/selftests/kselftest_harness.h | 234 +++++++++++++++-----
 tools/testing/selftests/net/tls.c           |  93 ++------
 3 files changed, 202 insertions(+), 128 deletions(-)

-- 
2.25.4

