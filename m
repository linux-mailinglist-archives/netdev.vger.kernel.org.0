Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3062F58F6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbhANDKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:10:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbhANDKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:10:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E476235FA;
        Thu, 14 Jan 2021 03:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610593794;
        bh=vUD48pTk3EWrgSTJkk5y82ywPI3/KgZVDwPF0NXQKng=;
        h=From:To:Cc:Subject:Date:From;
        b=At1+g5ajd+AsZLlfx889gKobORNSR9kmMhpbmwX7GAvqiSPrGYeNbtjxaAvC0p6kB
         y8m/x6Bb+SHuoYHWSKBuafEA+wiaWCAgIU3S/970pTzSFBoDv0daXrwk2ehYWqAbY0
         0Ownqg83nxmzgTAAU5mY5H3YJ0kZsvEmd5HwTMUCdpz/pF74Fx1dR24WUMF3Nz9kyP
         12y8NpAr040ad0B3bzsAYhE308ApaLmY9wNObBc/fHfUVJYgbKJhvNOqSmJUqJxIZu
         3O3s9gmbJQK5SA8xame3hfS0eVuWPso+d/F9uZeloZ5aRbqLiMAyrSaItJ28bnnplY
         mSW13nO/1U4tA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next v4 00/13] selftests: Updates to allow single instance of nettest for client and server
Date:   Wed, 13 Jan 2021 20:09:36 -0700
Message-Id: <20210114030949.54425-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update nettest to handle namespace change internally to allow a
single instance to run both client and server modes. Device validation
needs to be moved after the namespace change and a few run time
options need to be split to allow values for client and server.

v4
- really fix the memory leak with stdout/stderr buffers

v3
- send proper status in do_server for UDP sockets
- fix memory leak with stdout/stderr buffers
- new patch with separate option for address binding
- new patch to remove unnecessary newline

v2
- fix checkpath warnings

David Ahern (13):
  selftests: Move device validation in nettest
  selftests: Move convert_addr up in nettest
  selftests: Move address validation in nettest
  selftests: Add options to set network namespace to nettest
  selftests: Add support to nettest to run both client and server
  selftests: Use separate stdout and stderr buffers in nettest
  selftests: Add missing newline in nettest error messages
  selftests: Make address validation apply only to client mode
  selftests: Consistently specify address for MD5 protection
  selftests: Add new option for client-side passwords
  selftests: Add separate options for server device bindings
  selftests: Remove exraneous newline in nettest
  selftests: Add separate option to nettest for address binding

 tools/testing/selftests/net/fcnal-test.sh | 402 +++++++--------
 tools/testing/selftests/net/nettest.c     | 585 +++++++++++++++-------
 2 files changed, 606 insertions(+), 381 deletions(-)

-- 
2.24.3 (Apple Git-128)

