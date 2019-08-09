Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3BD287EE4
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437021AbfHIQFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfHIQFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 12:05:48 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3F497306F4A9;
        Fri,  9 Aug 2019 16:05:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64C275C29A;
        Fri,  9 Aug 2019 16:05:47 +0000 (UTC)
Subject: [PATCH net 0/2] rxrpc: Fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 09 Aug 2019 17:05:46 +0100
Message-ID: <156536674651.17478.15139844428920800280.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 09 Aug 2019 16:05:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here's a couple of fixes for rxrpc:

 (1) Fix refcounting of the local endpoint.

 (2) Don't calculate or report packet skew information.  This has been
     obsolete since AFS 3.1 and so is a waste of resources.


The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20190809

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (2):
      rxrpc: Fix local endpoint refcounting
      rxrpc: Don't bother generating maxSkew in the ACK packet


 net/rxrpc/af_rxrpc.c     |    6 ++-
 net/rxrpc/ar-internal.h  |    8 +++-
 net/rxrpc/call_event.c   |   15 +++-----
 net/rxrpc/input.c        |   59 +++++++++++++++-----------------
 net/rxrpc/local_object.c |   86 +++++++++++++++++++++++++++++-----------------
 net/rxrpc/output.c       |    3 +-
 net/rxrpc/recvmsg.c      |    6 ++-
 7 files changed, 100 insertions(+), 83 deletions(-)

