Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B793236D6AF
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 13:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhD1Lno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 07:43:44 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:9719 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhD1Lno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 07:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619610180; x=1651146180;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QnD6akGO//FI+gZLQLLDdH5w1c3ZnX3NMF7Lc/VTaH0=;
  b=SDEcphjlVhcPwoiIgeGxs/TE9kTptnf25Nhef+sfvYhuKxNc7+MzSUAr
   oKeoMKs+Ib+Q/7b6y09oiF2adZcjJHj45YLXKshRrx/lz/e22GHzdFAJB
   ybzKE6cKaOgyt4X+031nUlCIYInyx7+S1NdB6Y/AFnEERYgysRSiNQpJ9
   s=;
X-IronPort-AV: E=Sophos;i="5.82,258,1613433600"; 
   d="scan'208";a="131440658"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 28 Apr 2021 11:42:53 +0000
Received: from EX13D13EUB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 30B61A1BCB;
        Wed, 28 Apr 2021 11:42:50 +0000 (UTC)
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D13EUB002.ant.amazon.com (10.43.166.205) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 11:42:49 +0000
Received: from 8c85908914bf.ant.amazon.com.com (10.85.90.101) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 28 Apr 2021 11:42:47 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     David Ahern <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH iproute2-next 0/2] Add copy-on-fork to get sys command
Date:   Wed, 28 Apr 2021 14:42:29 +0300
Message-ID: <20210428114231.96944-1-galpress@amazon.com>
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

Thanks

Gal Pressman (2):
  rdma: update uapi headers
  rdma: Add copy-on-fork to get sys command

 rdma/include/uapi/rdma/rdma_netlink.h | 16 ++++++++++++++++
 rdma/sys.c                            |  9 +++++++++
 2 files changed, 25 insertions(+)

-- 
2.31.1

