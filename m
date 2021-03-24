Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB38F3483CE
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhCXVfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:35:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231157AbhCXVez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616621693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VMcJL0oGgKCDOvoRw9WcoSULP+k/Om/qzonQD9lQGaM=;
        b=Rz+FdDJDvXaHhsxjOf0x+J4/cnGkxnkDO6D3smpZMw8J+28eQbNSdIMpI43k6rCD2BYjNc
        92nsfeX4A1L/C2DMvSiNTDqhv+u/+0Lj36Pb7o5giHN0XblYol6TEsQtXKbmWTqUZqAp/c
        WGWk1zxS+sajhVveYJxsCvfXyf7HfYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-y8newqq5Otia-uXv6uJcgw-1; Wed, 24 Mar 2021 17:34:49 -0400
X-MC-Unique: y8newqq5Otia-uXv6uJcgw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43D368030B5;
        Wed, 24 Mar 2021 21:34:48 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34A2D614FF;
        Wed, 24 Mar 2021 21:34:45 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1BBFE300A2A79;
        Wed, 24 Mar 2021 22:34:44 +0100 (CET)
Subject: [PATCH mel-git 0/3] page_pool using alloc_pages_bulk API
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Mar 2021 22:34:44 +0100
Message-ID: <161662166301.940814.9765023867613542235.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is against Mel's tree:
 - git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git
 - Branch: mm-bulk-rebase-v6r5
 - https://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git/log/?h=mm-bulk-rebase-v6r5

The benchmarks are here:
 - https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org#test-on-mel-git-tree-mm-bulk-rebase-v6r5

The compiler choose a strange code layout see here:
 - https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org#strange-code-layout
 - Used: gcc (GCC) 9.3.1 20200408 (Red Hat 9.3.1-2)

Intent is for Mel to pickup these patches.
---

Jesper Dangaard Brouer (3):
      net: page_pool: refactor dma_map into own function page_pool_dma_map
      net: page_pool: use alloc_pages_bulk in refill code path
      net: page_pool: convert to use alloc_pages_bulk_array variant


 include/net/page_pool.h |    2 -
 net/core/page_pool.c    |  111 +++++++++++++++++++++++++++++++----------------
 2 files changed, 75 insertions(+), 38 deletions(-)

--

