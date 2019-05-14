Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C45A1C038
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 02:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfENAzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 20:55:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44778 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfENAzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 20:55:24 -0400
Received: by mail-qt1-f195.google.com with SMTP id f24so12663507qtk.11
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 17:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=pUBFTG3mMVYxmSF25knkwovcz+vklh44Q18Z6S9OSMc=;
        b=MEimntidxOkQd50CgVh8V2VxRsFvKBoAstt85gad8xJKVyOeEoV11zNRiqblSvAjiq
         1QMi0NcKTVMLI1kA/Ti0gtw7ZFby3wLfPdAYxMEersXhqvV0bIM4WNTeqPD3JVn0eq3L
         fXCzgi2TPzX1K+d0wwQ8aa0i+RPNEWdCQhRT0tVOFlu9oLDteHUUwFB6fGSD9P5kO5Fy
         QMPfyLpS3waf7LwPmFKhZOL+oGi8jEkKE5cOJIomUMyRcDSV7JsDlyP/y0jWzDqj9i00
         VlzwONALu4JbkW8pjGfZbB2qrLpPHFJKoEUZRXHhDVxONQG1nfBbKJzOdnph7/mfKImg
         wP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pUBFTG3mMVYxmSF25knkwovcz+vklh44Q18Z6S9OSMc=;
        b=ZACWTjE3vSuXjhpAomneerKxLoqyc0tBySB04bL2/fNXweLPYfROQEQiz5JwM9hNsZ
         2da/SAGuAlWxnPEXTyAi9pR2WGhxIA9J1wDRQ2pTaEDLnr+zasCjqu0lDMx8+Ab4WA1e
         UPuRyc0JvIbXH6Awsb58ZEdwauHiBtWWcny3Z89ucmlz+wSdY8FhV6runTgnyE6sGfsL
         +j8rviE7+mBRXgltYkpv6fU8m9V6uUL3Q+kZq3NFStEG4Q5LrGX8Cgv06RXTqK1g7ly8
         XSUB3pz97yW9Bkl2Ef/bJ8479G5ywlCOBSM/zpDNJhwZixO+0515Qw1RcW3VwCdnIriz
         tlxQ==
X-Gm-Message-State: APjAAAW7h1TdTwzWBu5wr9jzR9TdE7P8/s78E9da1cz/cGGbKeREJZYS
        EfzLlgQkWKRsSS4gJC/kJZAYqfRjDYM=
X-Google-Smtp-Source: APXvYqyBUTx5Iw2WP9ZH7PL2DyEW9PA/PLDHy2q3fM6GCCJLcIjrlSwisidKRxN8NrlAM44YqdEpjA==
X-Received: by 2002:ac8:4304:: with SMTP id z4mr18655245qtm.275.1557795322864;
        Mon, 13 May 2019 17:55:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id r47sm11534911qtc.14.2019.05.13.17.55.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 May 2019 17:55:22 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hQLiz-0008Kd-Jd; Mon, 13 May 2019 21:55:21 -0300
Date:   Mon, 13 May 2019 21:55:21 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: [PATCH v2] RDMA: Directly cast the sockaddr union to sockaddr
Message-ID: <20190514005521.GA18085@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc 9 now does allocation size tracking and thinks that passing the member
of a union and then accessing beyond that member's bounds is an overflow.

Instead of using the union member, use the entire union with a cast to
get to the sockaddr. gcc will now know that the memory extends the full
size of the union.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/core/addr.c           | 16 ++++++++--------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  5 ++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |  5 ++---
 3 files changed, 12 insertions(+), 14 deletions(-)

I missed the ocrdma files in the v1

We can revisit what to do with that repetitive union after the merge
window, but this simple patch will eliminate the warnings for now.

Linus, I'll send this as a PR tomorrow - there is also a bug fix for
the rdma-netlink changes posted that should go too.

Thanks,
Jason

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index ba01b90c04e775..2f7d14159841f8 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -731,8 +731,8 @@ int roce_resolve_route_from_path(struct sa_path_rec *rec,
 	if (rec->roce.route_resolved)
 		return 0;
 
-	rdma_gid2ip(&sgid._sockaddr, &rec->sgid);
-	rdma_gid2ip(&dgid._sockaddr, &rec->dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid, &rec->sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid, &rec->dgid);
 
 	if (sgid._sockaddr.sa_family != dgid._sockaddr.sa_family)
 		return -EINVAL;
@@ -743,7 +743,7 @@ int roce_resolve_route_from_path(struct sa_path_rec *rec,
 	dev_addr.net = &init_net;
 	dev_addr.sgid_attr = attr;
 
-	ret = addr_resolve(&sgid._sockaddr, &dgid._sockaddr,
+	ret = addr_resolve((struct sockaddr *)&sgid, (struct sockaddr *)&dgid,
 			   &dev_addr, false, true, 0);
 	if (ret)
 		return ret;
@@ -815,22 +815,22 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 	struct rdma_dev_addr dev_addr;
 	struct resolve_cb_context ctx;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
 	int ret;
 
-	rdma_gid2ip(&sgid_addr._sockaddr, sgid);
-	rdma_gid2ip(&dgid_addr._sockaddr, dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid_addr, sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid_addr, dgid);
 
 	memset(&dev_addr, 0, sizeof(dev_addr));
 	dev_addr.net = &init_net;
 	dev_addr.sgid_attr = sgid_attr;
 
 	init_completion(&ctx.comp);
-	ret = rdma_resolve_ip(&sgid_addr._sockaddr, &dgid_addr._sockaddr,
-			      &dev_addr, 1000, resolve_cb, true, &ctx);
+	ret = rdma_resolve_ip((struct sockaddr *)&sgid_addr,
+			      (struct sockaddr *)&dgid_addr, &dev_addr, 1000,
+			      resolve_cb, true, &ctx);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 1d4ea135c28f2a..8d3e36d548aae9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -83,7 +83,6 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	struct iphdr ipv4;
 	const struct ib_global_route *ib_grh;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
@@ -133,9 +132,9 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 		ipv4.tot_len = htons(0);
 		ipv4.ttl = ib_grh->hop_limit;
 		ipv4.protocol = nxthdr;
-		rdma_gid2ip(&sgid_addr._sockaddr, sgid);
+		rdma_gid2ip((struct sockaddr *)&sgid_addr, sgid);
 		ipv4.saddr = sgid_addr._sockaddr_in.sin_addr.s_addr;
-		rdma_gid2ip(&dgid_addr._sockaddr, &ib_grh->dgid);
+		rdma_gid2ip((struct sockaddr*)&dgid_addr, &ib_grh->dgid);
 		ipv4.daddr = dgid_addr._sockaddr_in.sin_addr.s_addr;
 		memcpy((u8 *)ah->av + eth_sz, &ipv4, sizeof(struct iphdr));
 	} else {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 32674b291f60da..5127e2ea4bdd2d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2499,7 +2499,6 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	u16 vlan_id = 0xFFFF;
 	u8 mac_addr[6], hdr_type;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
@@ -2542,8 +2541,8 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 
 	hdr_type = rdma_gid_attr_network_type(sgid_attr);
 	if (hdr_type == RDMA_NETWORK_IPV4) {
-		rdma_gid2ip(&sgid_addr._sockaddr, &sgid_attr->gid);
-		rdma_gid2ip(&dgid_addr._sockaddr, &grh->dgid);
+		rdma_gid2ip((struct sockaddr *)&sgid_addr, &sgid_attr->gid);
+		rdma_gid2ip((struct sockaddr *)&dgid_addr, &grh->dgid);
 		memcpy(&cmd->params.dgid[0],
 		       &dgid_addr._sockaddr_in.sin_addr.s_addr, 4);
 		memcpy(&cmd->params.sgid[0],
-- 
2.21.0

