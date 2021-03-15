Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABE133C6E1
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhCOTdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:33:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233015AbhCOTde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 15:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615836814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RFIjDQlgAbDZb84hCcz/nIlskkxfDKDLDVdmAvsZ6QA=;
        b=fbPIiYEKUvd42oQ9p+dddaMZbU9dqFWW1ReskGWGc8rBNHW0NFlhH3cvob1ED42Y1u8/K+
        5NRp/asfHD6u8ajGXJkdy+5/I2vSlSNqcNWoVZx676r5r1QvKdTS54hbgA3jeRkzcpfYj4
        1ShqbQvpfO3fge0FT5ef5tBI+x30GSg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-2zLsoK69PWCE-vaq_Q0KEw-1; Mon, 15 Mar 2021 15:33:31 -0400
X-MC-Unique: 2zLsoK69PWCE-vaq_Q0KEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42B7B100C618;
        Mon, 15 Mar 2021 19:33:29 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1FE210023AB;
        Mon, 15 Mar 2021 19:33:25 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 524D93250E696;
        Mon, 15 Mar 2021 20:33:24 +0100 (CET)
Subject: [PATCH mel-git] Followup: Update [PATCH 7/7] in Mel's series
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 15 Mar 2021 20:33:24 +0100
Message-ID: <161583677541.3715498.6118778324185171839.stgit@firesoul>
In-Reply-To: <20210315094038.22d6d79a@carbon>
References: <20210315094038.22d6d79a@carbon>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is against Mel's git-tree:
 git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git

Using branch: mm-bulk-rebase-v4r2 but replacing the last patch related to
the page_pool using __alloc_pages_bulk().

 https://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git/log/?h=mm-bulk-rebase-v4r2

While implementing suggestions by Alexander Duyck, I realised that I could
simplify the code further, and simply take the last page from the
pool->alloc.cache given this avoids special casing the last page.

I re-ran performance tests and the improvement have been reduced to 13% from
18% before, but I don't think the rewrite of the specific patch have
anything to do with this.

Notes on tests:
 https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org#test-on-mel-git-tree

---

Jesper Dangaard Brouer (1):
      net: page_pool: use alloc_pages_bulk in refill code path


 net/core/page_pool.c |   73 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 26 deletions(-)

--

