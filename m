Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844EC23EA63
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgHGJc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 05:32:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30765 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727771AbgHGJc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 05:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596792777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lm8W7xPI/m+XL0p+WPcP/4xWrD1OGvdDAwSJYyI6fCw=;
        b=bsgQkz397otUDGQUN9zxCgABYlubfpyNKdDnen2xtrQNGgGv7O1X7kyoZR1z4UYKtKy9uY
        sJc8QHw6jmA0TuBQqu38AOk93BwHnkqpsTRU9yH4ADW4mjND5PIHT4cFi4YTpdETt35dwW
        KYel81fjnjwLMbDEcMRlzPKam5qd8VM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-mTHbcHKvNWKhGZewV4skEw-1; Fri, 07 Aug 2020 05:32:55 -0400
X-MC-Unique: mTHbcHKvNWKhGZewV4skEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A73880046C;
        Fri,  7 Aug 2020 09:32:54 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-201.ams2.redhat.com [10.36.113.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED11D5F7D8;
        Fri,  7 Aug 2020 09:32:52 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] selftests: mptcp: fix dependecies
Date:   Fri,  7 Aug 2020 11:32:04 +0200
Message-Id: <781f07aa4d05b123a80bf98f5839e1611a833272.1596791966.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
the MPTCP selftests relies on the MPTCP diag interface which is
enabled by a specific kconfig knob: be sure to include it.

Fixes: df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/mptcp/config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
index 2499824d9e1c..8df5cb8f71ff 100644
--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -1,4 +1,6 @@
 CONFIG_MPTCP=y
 CONFIG_MPTCP_IPV6=y
+CONFIG_INET_DIAG=m
+CONFIG_INET_MPTCP_DIAG=m
 CONFIG_VETH=y
 CONFIG_NET_SCH_NETEM=m
-- 
2.26.2

