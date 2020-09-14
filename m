Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C59E2691C9
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgINPbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:31:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20678 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726294AbgINPbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:31:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600097470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dMweHEZbFa5g/pRD+e4Ve63LcmOnunvsiH2Q7fDvBJM=;
        b=f1/hPMSyLp9gSRXKKt3toQ2GH/8rJAx2Fi29ywvQ7tYcqe8fPOoyU3nl4pF/Krypdn1ONt
        g76bztuIxWxg2Sy68VTfL4EzLtjJtQ0uQWroiI3Ajhl/rfzWGGUD/RaoOmTrocrH/yI06s
        rPWw5LWg3uiDdtr3dZ6fVOZajOpWgio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-Co38hbDPNs6TxDuuVECk7g-1; Mon, 14 Sep 2020 11:31:08 -0400
X-MC-Unique: Co38hbDPNs6TxDuuVECk7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60FC81007B0B;
        Mon, 14 Sep 2020 15:30:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 896F37512A;
        Mon, 14 Sep 2020 15:30:46 +0000 (UTC)
Subject: [PATCH net-next 0/5] rxrpc: Fixes for the connection manager rewrite
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 14 Sep 2020 16:30:46 +0100
Message-ID: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some fixes for the connection manager rewrite:

 (1) Fix a goto to the wrong place in error handling.

 (2) Fix a missing NULL pointer check.

 (3) The stored allocation error needs to be stored signed.

 (4) Fix a leak of connection bundle when clearing connections due to
     net namespace exit.

 (5) Fix an overget of the bundle when setting up a new client conn.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-next-20200914

and can also be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (5):
      rxrpc: Fix an error goto in rxrpc_connect_call()
      rxrpc: Fix a missing NULL-pointer check in a trace
      rxrpc: Fix rxrpc_bundle::alloc_error to be signed
      rxrpc: Fix conn bundle leak in net-namespace exit
      rxrpc: Fix an overget of the conn bundle when setting up a client conn


 include/trace/events/rxrpc.h | 2 +-
 net/rxrpc/ar-internal.h      | 2 +-
 net/rxrpc/conn_client.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


