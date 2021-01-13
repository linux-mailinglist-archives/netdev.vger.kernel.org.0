Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C842F42B8
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbhAMEBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbhAMEBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:01:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52EFB2311B;
        Wed, 13 Jan 2021 04:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610510443;
        bh=UIaMd4E6PoN67jhXDtYf3uZyzxHxzPPvgrFk2U+H7G8=;
        h=From:To:Cc:Subject:Date:From;
        b=RMXe3205qvwcHSL0dB72xHnSr0BVsJ4FeE6EB+MwDFam970+cWvxee3Yr2iNf2OXR
         9++9X+JeemXZ+VPBSv92A0VoV7i8hBzGWywvIz4nGALQhgxyjcGbvwvLlOI3pQq3BG
         KQHARFLuDqOq0AG2Rw0MbQKaP4DaN9HQLCSKtN9kBuv4OmibVu5lGBYFv/LNkJZFDD
         tURvrmPoUr/agG9ZTw2CDYFqdNZhfjiVNR6oqoGo3t7AUUIGARTiEZtUSuJqKiFQ8e
         pvPkaWq7D0waWh/7rrfobuDU2lK7D6tEDGW8vZbdZA8UxgNBC6bJOo2BMOpCpX2Wvb
         WVxJecfAnmSuw==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next v3 00/13] selftests: Updates to allow single instance of nettest for client and server
Date:   Tue, 12 Jan 2021 21:00:27 -0700
Message-Id: <20210113040040.50813-1-dsahern@kernel.org>
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
 tools/testing/selftests/net/nettest.c     | 584 +++++++++++++++-------
 2 files changed, 605 insertions(+), 381 deletions(-)

-- 
2.24.3 (Apple Git-128)

