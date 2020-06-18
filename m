Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B21FECD8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 09:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgFRHuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 03:50:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54302 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728144AbgFRHuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 03:50:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592466621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PDcgiaJNLiWYXI7v/eZt6zw/T0PDPCuZ8sjZurKJ94s=;
        b=S+sNhKyrdQrWXH1W/PoKEUyNCXTEV7oqiVTK7sNmmbXEklIdW+wqEVmg8VI6WJ6z7y2iSj
        X0YqmE/lkmvbcSATi5NACCFwnY0w9c+Fi0/ZOZYClFHgU21UhR2nwELkZaXTc/Drz6tgc9
        H80kK2394XrTYOvTxABSeIkXy9Ib51U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-gLG1G5RDM5C1hDqEODsWjQ-1; Thu, 18 Jun 2020 03:50:17 -0400
X-MC-Unique: gLG1G5RDM5C1hDqEODsWjQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8A601883607;
        Thu, 18 Jun 2020 07:50:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECD401C4;
        Thu, 18 Jun 2020 07:50:15 +0000 (UTC)
Subject: [PATCH net 0/3] rxrpc: Performance drop fix and other fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 18 Jun 2020 08:50:15 +0100
Message-ID: <159246661514.1229328.4419873299996950969.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are three fixes for rxrpc:

 (1) Fix a trace symbol mapping.  It doesn't seem to let you map to "".

 (2) Fix the handling of the remote receive window size when it increases
     beyond the size we can support for our transmit window.

 (3) Fix a performance drop caused by retransmitted packets being
     accidentally marked as already ACK'd.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20200618

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (1):
      rxrpc: Fix afs large storage transmission performance drop


 include/trace/events/rxrpc.h | 2 +-
 net/rxrpc/call_event.c       | 2 +-
 net/rxrpc/input.c            | 7 +++----
 3 files changed, 5 insertions(+), 6 deletions(-)


