Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23C432443B
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 20:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbhBXS7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 13:59:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235091AbhBXS6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 13:58:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614193005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZTlVunrnBnDi4OnuZ76TrsKCORphywznJKQVNEf/9ag=;
        b=enLn49cwyY9N4baEcs96KXacX/9ir2dEGPRaM7jthJOh+4FEzqT437+H4uRORiKm/p1YMb
        sJ4HCva55+R2YSfcs34wA7adshIw/ijAqFz/tpEdKhMCl11P+8JtEoMYpgfjHXrD/+BhVz
        eOQKNEvzU2U/wtXdVyYNUq/psWtHjM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-TkS_rbykP4-2G_oxHMNMPA-1; Wed, 24 Feb 2021 13:56:42 -0500
X-MC-Unique: TkS_rbykP4-2G_oxHMNMPA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D212F9126F;
        Wed, 24 Feb 2021 18:56:40 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A9E1100239A;
        Wed, 24 Feb 2021 18:56:37 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 0CD2C30736C73;
        Wed, 24 Feb 2021 19:56:36 +0100 (CET)
Subject: [PATCH RFC net-next 0/3] Use bulk order-0 page allocator API for
 page_pool
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Feb 2021 19:56:35 +0100
Message-ID: <161419296941.2718959.12575257358107256094.stgit@firesoul>
In-Reply-To: <20210224102603.19524-1-mgorman@techsingularity.net>
References: <20210224102603.19524-1-mgorman@techsingularity.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a followup to Mel Gorman's patchset:
 - Message-Id: <20210224102603.19524-1-mgorman@techsingularity.net>
 - https://lore.kernel.org/netdev/20210224102603.19524-1-mgorman@techsingularity.net/

Showing page_pool usage of the API for alloc_pages_bulk().

---

Jesper Dangaard Brouer (3):
      net: page_pool: refactor dma_map into own function page_pool_dma_map
      net: page_pool: use alloc_pages_bulk in refill code path
      mm: make zone->free_area[order] access faster


 include/linux/mmzone.h |    6 ++-
 net/core/page_pool.c   |   96 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 65 insertions(+), 37 deletions(-)

--

