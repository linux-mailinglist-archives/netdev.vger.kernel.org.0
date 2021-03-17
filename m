Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE3733E68E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhCQCGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:06:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhCQCGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cFx2KLTYQBO42qJf1Or8MNikQ4+JDcPE+souxlhSmoI=;
        b=RCVGQtg0lzVmoxinecUcVzxhZ0GwGAeQ2PXfaksLlHKIxDwjhkFgyy8n3xoTt95A04MbYW
        GB4qFKdH4+68Xu5T6pUNRvAbQvyV3OKRQnMa/th/mAkpkT8XMVjwkuF+NlymC6ZZpzn3N4
        Q3si2UccGGhSVtyAgyUEt8GX5sdOiag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-n3GGIh0yNFuWUUxsezRQKA-1; Tue, 16 Mar 2021 22:06:27 -0400
X-MC-Unique: n3GGIh0yNFuWUUxsezRQKA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BCD818D6A2C;
        Wed, 17 Mar 2021 02:06:25 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8500F5C1A1;
        Wed, 17 Mar 2021 02:06:23 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 00/16] tipc: cleanups and simplifications
Date:   Tue, 16 Mar 2021 22:06:07 -0400
Message-Id: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We do a number of cleanups and simplifications, especially regarding
call signatures in the binding table. This makes the code easier to
understand and serves as preparation for upcoming functional additions.

Jon Maloy (16):
  tipc: re-organize members of struct publication
  tipc: move creation of publication item one level up in call chain
  tipc: introduce new unified address type for internal use
  tipc: simplify signature of tipc_namtbl_publish()
  tipc: simplify call signatures for publication creation
  tipc: simplify signature of tipc_nametbl_withdraw() functions
  tipc: rename binding table lookup functions
  tipc: refactor tipc_sendmsg() and tipc_lookup_anycast()
  tipc: simplify signature of tipc_namtbl_lookup_mcast_sockets()
  tipc: simplify signature of tipc_nametbl_lookup_mcast_nodes()
  tipc: simplify signature of tipc_nametbl_lookup_group()
  tipc: simplify signature of tipc_service_find_range()
  tipc: simplify signature of tipc_find_service()
  tipc: simplify api between binding table and topology server
  tipc: add host-endian copy of user subscription to struct
    tipc_subscription
  tipc: remove some unnecessary warnings

 net/tipc/addr.c       |   1 +
 net/tipc/addr.h       |  46 ++++-
 net/tipc/msg.c        |  23 ++-
 net/tipc/name_distr.c |  93 +++++----
 net/tipc/name_table.c | 426 +++++++++++++++++++++---------------------
 net/tipc/name_table.h |  63 +++----
 net/tipc/net.c        |   8 +-
 net/tipc/node.c       |  28 +--
 net/tipc/socket.c     | 319 ++++++++++++++++---------------
 net/tipc/subscr.c     |  86 +++++----
 net/tipc/subscr.h     |  14 +-
 11 files changed, 578 insertions(+), 529 deletions(-)

-- 
2.29.2

