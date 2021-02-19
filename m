Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FF731FDF0
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBSRhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:37:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhBSRhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 12:37:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ekWX7q27FPROIY9UEIDTTpbW4pRkKxPu/jRqn+X5HBA=;
        b=XGfff6IIqel5MtEBDEEyU2mE8v1WqIeS0WtGSracke39VAAzHGI1kUvgFO+gJCVOtP7L3D
        FGOk4rd8gi3LGYTskqygW5RlyXXLorBsQfp96LGrl/R0w1c/8CRko+iFGGpGNttmkIBCZW
        HMKdKq7g27p0LlXKuGNVGw3Kt0omyZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-QCyqBq3CNumNAgCcgfplGw-1; Fri, 19 Feb 2021 12:35:52 -0500
X-MC-Unique: QCyqBq3CNumNAgCcgfplGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A8031005501;
        Fri, 19 Feb 2021 17:35:51 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-85.ams2.redhat.com [10.36.115.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9583D1A353;
        Fri, 19 Feb 2021 17:35:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 0/4] mptcp: a bunch of fixes
Date:   Fri, 19 Feb 2021 18:35:36 +0100
Message-Id: <cover.1613755058.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series bundle a few MPTCP fixes for the current net tree.
They have been detected via syzkaller and packetdrill

Patch 1 fixes a slow close for orphaned sockets

Patch 2 fixes another hangup at close time, when no
data was actually transmitted before close

Patch 3 fixes a memory leak with unusual sockopts

Patch 4 fixes stray wake-ups on listener sockets

Florian Westphal (1):
  mptcp: provide subflow aware release function

Paolo Abeni (3):
  mptcp: fix DATA_FIN processing for orphaned sockets
  mptcp: fix DATA_FIN generation on early shutdown
  mptcp: do not wakeup listener for MPJ subflows

 net/mptcp/options.c  | 23 +++++++++-------
 net/mptcp/protocol.c | 64 +++++++++++++++++++++++++++++++++++++++-----
 net/mptcp/subflow.c  |  6 +++++
 3 files changed, 77 insertions(+), 16 deletions(-)

-- 
2.26.2

