Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB16492999
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 16:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbiARPZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 10:25:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235669AbiARPZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 10:25:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642519514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Djoy93LgAZSk7rkucVlYXmnzb8XgU2h4ZBN81+P+blo=;
        b=eHPj3b0WFNT4N8Ea+aUznOQAc3xf74CFWOb++cLqE9g5OBinC6ZUxc5Ox5W66oIX8dgwr8
        i2gfB7rnSxnLTe2FQ2jw9Xxf2f7gADdHl/6ErIwNkpAHkuCUvtgLFYem40OTZfsiH0NmbB
        F5O9vHt/7xblmi9U4omqC+ogpR4hlKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-BVLOoK-xOou6Gh_-yu7t1g-1; Tue, 18 Jan 2022 10:25:13 -0500
X-MC-Unique: BVLOoK-xOou6Gh_-yu7t1g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE29683DEA6;
        Tue, 18 Jan 2022 15:25:11 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECE2D106C06F;
        Tue, 18 Jan 2022 15:25:10 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH 0/3] gro: some minor optimizations
Date:   Tue, 18 Jan 2022 16:24:17 +0100
Message-Id: <cover.1642519257.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series collects a few small optimization for the GRO engine.
I measure a 10% performance improvements in micro-benchmarks
around dev_gro_receive(), but deltas are within noise range in tput
tests - ence the RFC tag.

Any feedback more then welcome.

Paolo Abeni (3):
  net: gro: avoid re-computing truesize twice on recycle
  net: gro: minor optimization for dev_gro_receive()
  net: gro: register gso and gro offload on separate lists

 include/linux/netdevice.h |   3 +-
 include/net/gro.h         |  13 +++--
 net/core/gro.c            | 107 +++++++++++++++++++++-----------------
 3 files changed, 70 insertions(+), 53 deletions(-)

-- 
2.34.1

