Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9691138EEE
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgAMKW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:22:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20367 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726001AbgAMKW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 05:22:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578910947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=03vuLyMcSo3+KdWAYqdpfj5B9wMnZwlsEsPHAEmkEMw=;
        b=eHyw+tqwl81aU1AnlGFZgMa0kT7LlbShcAvx6qm1YiqF/fkhYMhIxXDhHlfI7g7irluIl/
        UFfI2AKZ5bFkqdsKYkoAqlqS6HFQ6rXOvWf8cCwS1LE30jz8Ko4nXB4uFKatpWNbqx4+1x
        6f5PPU2kNMOu1nyCpfq1bEFO8zFoDpA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-DFLomiRVMz29GDX-dgNFGA-1; Mon, 13 Jan 2020 05:22:26 -0500
X-MC-Unique: DFLomiRVMz29GDX-dgNFGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2196F801E72;
        Mon, 13 Jan 2020 10:22:25 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-51.brq.redhat.com [10.40.200.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9731E5C28D;
        Mon, 13 Jan 2020 10:22:18 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id F409D30736C73;
        Mon, 13 Jan 2020 11:22:16 +0100 (CET)
Subject: [PATCH net-next] ptr_ring: add include of linux/mm.h
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Date:   Mon, 13 Jan 2020 11:22:16 +0100
Message-ID: <157891093662.53334.15580647502551818360.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0bf7800f1799 ("ptr_ring: try vmalloc() when kmalloc() fails")
started to use kvmalloc_array and kvfree, which are defined in mm.h,
the previous functions kcalloc and kfree, which are defined in slab.h.

Add the missing include of linux/mm.h.  This went unnoticed as other
include files happened to include mm.h.

Fixes: 0bf7800f1799 ("ptr_ring: try vmalloc() when kmalloc() fails")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/ptr_ring.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index 0abe9a4fc842..417db0a79a62 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <asm/errno.h>
 #endif
 


