Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475C921A08E
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGINNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:13:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51930 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbgGINNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594300380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B7dJZJlcb9zuBnrqDf69wpo2Z6Z3U6uqEdH3jg/B9aM=;
        b=CivoAJrGn2tvZWF4wli7llHJg2Ug5sTfF78Z4GekYHZU4Tf5XpODYb3q52DLi7j5ndvm6/
        V3gbZ9X1rvbdPBTdTpwMrbynIqr8uSu2NS2zDTcTcZPvnP3ALEYSDyI+LLDKecwvx77Eon
        BR0tusT0EMY91fQ/Yeult20XWpO66KE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-sCmpfgU9P1GRMbMDnoy6xQ-1; Thu, 09 Jul 2020 09:12:58 -0400
X-MC-Unique: sCmpfgU9P1GRMbMDnoy6xQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C335C100945B;
        Thu,  9 Jul 2020 13:12:57 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-239.ams2.redhat.com [10.36.113.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F1AB2B6DD;
        Thu,  9 Jul 2020 13:12:56 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 0/4] mptcp: introduce msk diag interface
Date:   Thu,  9 Jul 2020 15:12:38 +0200
Message-Id: <cover.1594292774.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements the diag interface for the MPTCP sockets.

Since the MPTCP protocol value can't be represented with the
current diag uAPI, the first patch introduces an extended attribute
allowing user-space to specify lager protocol values.

The token APIs are then extended to allow traversing the
whole token container.

Patch 3 carries the actual diag interface implementation, and 
later patch bring-in some functional self-tests.

Paolo Abeni (4):
  inet_diag: support for wider protocol numbers
  mptcp: add msk interations helper
  mptcp: add MPTCP socket diag interface
  selftests/mptcp: add diag interface tests

 include/uapi/linux/inet_diag.h                |   1 +
 include/uapi/linux/mptcp.h                    |  17 ++
 net/core/sock.c                               |   1 +
 net/ipv4/inet_diag.c                          |  65 +++++--
 net/mptcp/Kconfig                             |   4 +
 net/mptcp/Makefile                            |   2 +
 net/mptcp/mptcp_diag.c                        | 169 ++++++++++++++++++
 net/mptcp/protocol.h                          |   2 +
 net/mptcp/token.c                             |  61 ++++++-
 tools/testing/selftests/net/mptcp/Makefile    |   2 +-
 tools/testing/selftests/net/mptcp/diag.sh     | 122 +++++++++++++
 .../selftests/net/mptcp/mptcp_connect.c       |  22 ++-
 12 files changed, 445 insertions(+), 23 deletions(-)
 create mode 100644 net/mptcp/mptcp_diag.c
 create mode 100755 tools/testing/selftests/net/mptcp/diag.sh

-- 
2.26.2

