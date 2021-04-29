Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D43B36E50C
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 08:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbhD2GtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 02:49:07 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:52972 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhD2GtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 02:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619678901; x=1651214901;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+WtZzAwLavzB27rMq3LYfPTGCPhD5apFvOZYljfj/Z8=;
  b=CSKVjEm2RChtmRdq18W85pRAizAohCAEkleKeyPpEceJbAbmXXfmKKa0
   2yyt0+nIVUQFjAdWvj+VgAyA6iadLBds0tO0ZTlj5AQHmw9DCsNYeFY6s
   hfExis2SjqGjDN3NevtNKcakXSH4m85z4/KdRUWkh1mcxC69XtjQdKucG
   g=;
X-IronPort-AV: E=Sophos;i="5.82,258,1613433600"; 
   d="scan'208";a="131706885"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 29 Apr 2021 06:48:21 +0000
Received: from EX13D13EUB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 74F98A2126;
        Thu, 29 Apr 2021 06:48:17 +0000 (UTC)
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D13EUB002.ant.amazon.com (10.43.166.205) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 06:48:16 +0000
Received: from 8c85908914bf.ant.amazon.com.com (10.85.98.110) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 06:48:12 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     David Ahern <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH iproute2-next v2 0/2] Add copy-on-fork to get sys command 
Date:   Thu, 29 Apr 2021 09:48:01 +0300
Message-ID: <20210429064803.58458-1-galpress@amazon.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the userspace part for the new copy-on-fork attribute added to
the get sys netlink command.

The new attribute indicates that the kernel copies DMA pages on fork,
hence fork support through madvise and MADV_DONTFORK is not needed.

Kernel series was merged:
https://lore.kernel.org/linux-rdma/20210418121025.66849-1-galpress@amazon.com/

Changelog -
v1->v2: https://lore.kernel.org/linux-rdma/20210428114231.96944-1-galpress@amazon.com/
* Rebase kernel headers
* Print attributes on the same line
* Simplify if statement

Thanks

Gal Pressman (2):
  rdma: update uapi headers
  rdma: Add copy-on-fork to get sys command

 rdma/include/uapi/rdma/rdma_netlink.h |  3 +++
 rdma/sys.c                            | 11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

-- 
2.31.1

