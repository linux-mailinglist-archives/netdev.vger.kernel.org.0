Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245A3FEBC7
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 12:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfKPLWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 06:22:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50559 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727331AbfKPLWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 06:22:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573903362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DFvtcaYXXdNUDQYLEti992lt0Z4LB/5qnNbfONAo4rk=;
        b=J7Wo5ZhGjbUvYroCt3mCszamPZ/SKbQN6NKn6i6sXg8YIuSJFOb/eOXQMWRsCyv6q29KK2
        bHSqq0aTRXB64h5wKmzwJRpbDQrBCr0uJYD7FbSjj37JvWz6EwtYYA9Q4VF9VSLgzDC4Dy
        lRgmXnkr0ejKxPKTGDWQA9H7j5gjIzM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-t5d6b-8SNtetDtBVJ2LYZw-1; Sat, 16 Nov 2019 06:22:41 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F21E1802CE2;
        Sat, 16 Nov 2019 11:22:39 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 172C21036C81;
        Sat, 16 Nov 2019 11:22:34 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 05BFE30FC134D;
        Sat, 16 Nov 2019 12:22:33 +0100 (CET)
Subject: [net-next v2 PATCH 0/3] page_pool: followup changes to restore
 tracepoint features
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Sat, 16 Nov 2019 12:22:32 +0100
Message-ID: <157390333500.4062.15569811103072483038.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: t5d6b-8SNtetDtBVJ2LYZw-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is a followup to Jonathan patch, that do not release
pool until inflight =3D=3D 0. That changed page_pool to be responsible for
its own delayed destruction instead of relying on xdp memory model.

As the page_pool maintainer, I'm promoting the use of tracepoint to
troubleshoot and help driver developers verify correctness when
converting at driver to use page_pool. The role of xdp:mem_disconnect
have changed, which broke my bpftrace tools for shutdown verification.
With these changes, the same capabilities are regained.

---

Jesper Dangaard Brouer (3):
      xdp: remove memory poison on free for struct xdp_mem_allocator
      page_pool: add destroy attempts counter and rename tracepoint
      page_pool: extend tracepoint to also include the page PFN


 include/net/page_pool.h          |    2 ++
 include/trace/events/page_pool.h |   22 +++++++++++++++-------
 net/core/page_pool.c             |   13 +++++++++++--
 net/core/xdp.c                   |    5 -----
 4 files changed, 28 insertions(+), 14 deletions(-)

--
Signature

