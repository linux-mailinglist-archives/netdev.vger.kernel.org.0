Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C0A3932A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbfFGR1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:27:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52771 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730833AbfFGR1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 13:27:41 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190607172739euoutp01222a90e0d52592995b7af6ea2606c693~l_qthfX1P1064910649euoutp01i
        for <netdev@vger.kernel.org>; Fri,  7 Jun 2019 17:27:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190607172739euoutp01222a90e0d52592995b7af6ea2606c693~l_qthfX1P1064910649euoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559928459;
        bh=9P2QBaiZ1ihJh/1tM3pcrMJkLOkTqdSK1PLPgQqSMiE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=mpP+XR8riTvz3+EB83ULLiriH4kjRIA/vEiyco9G1xZcJX+/oEq3SUDANaJiHhJRk
         Jb7UZlwa9Wjx1fg4mGfH9BeAzj26ZLmPhhH2yJtYWkEWhILjr+u+iWSqmPiGtPOh/z
         5/uXOA4h4eamcH+Mbwbmcwzb4m9qyxPv5lUhXo5Y=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190607172738eucas1p2627736a149ba8c78382120878d834565~l_qsG9YJd2090420904eucas1p2Z;
        Fri,  7 Jun 2019 17:27:38 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 77.14.04377.A8E9AFC5; Fri,  7
        Jun 2019 18:27:38 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e~l_qrSiI7P2088520885eucas1p2f;
        Fri,  7 Jun 2019 17:27:37 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190607172737eusmtrp16ca0b42e3052308b18bd7c0761fc4885~l_qrC_EhI1793017930eusmtrp1M;
        Fri,  7 Jun 2019 17:27:37 +0000 (GMT)
X-AuditID: cbfec7f4-12dff70000001119-64-5cfa9e8a82f5
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 62.40.04146.98E9AFC5; Fri,  7
        Jun 2019 18:27:37 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190607172736eusmtip1c0e8143d5a848d2e993238f565d99b98~l_qqb3Xpi2562725627eusmtip1J;
        Fri,  7 Jun 2019 17:27:36 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf] xdp: check device pointer before clearing
Date:   Fri,  7 Jun 2019 20:27:32 +0300
Message-Id: <20190607172732.4710-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWy7djP87pd837FGOzq47D407aB0eLzkeNs
        FnPOt7BYXGn/yW5xedccNosVh06wWxxbIGaxvX8fowOHx5aVN5k8Fu95yeTRt2UVo8fnTXIB
        LFFcNimpOZllqUX6dglcGVfPKBbs4Kw42vabsYHxEnsXIyeHhICJxK3eZ8xdjFwcQgIrGCUO
        vv3JCJIQEvjCKLH7QihE4jOjxPXPd+A6en8dZIFILGeUWPtyJROE84NRYuu0vWBVbAI6EqdW
        HwEbJSIgJfFxx3Z2kCJmgclMEi9f/gUrEhawk2jbNIMFxGYRUJX4dnwRWAOvgJXE2TtToNbJ
        S6zecADsQAmBy2wS+/e+Y+1i5AByXCR+70qHqBGWeHV8C1S9jMTpyT0sEHa9xP2Wl4wQvR2M
        EtMP/WOCSNhLbHl9jh1kDrOApsT6XfoQYUeJ6xtbmCHG80nceCsIEmYGMidtmw4V5pXoaBOC
        qFaR+H1wOTOELSVx891nqAs8JL6/PsoECcVYicvLXrFPYJSbhbBrASPjKkbx1NLi3PTUYqO8
        1HK94sTc4tK8dL3k/NxNjMA0cPrf8S87GHf9STrEKMDBqMTD+6LkV4wQa2JZcWXuIUYJDmYl
        Ed6yCz9ihHhTEiurUovy44tKc1KLDzFKc7AoifNWMzyIFhJITyxJzU5NLUgtgskycXBKNTCG
        vNJi2Jjack/60z3bNOe3UeE6anvFP8Qu/PrR3vAYV1/gA701k98sXnsgoHvKnVA7gW0bL1Q3
        fZl2PnB9redxt+kHChZOZnV9vkJSNE2ZSea5Fl/rDbPEPxeXL0oSClUw/2ppWH9RWpDh0gy7
        gi1+iZt5DyvWvnovvr3tgIvQ6h0Vj1TqLHOUWIozEg21mIuKEwG5EJv7/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xu7qd837FGCz+ymPxp20Do8XnI8fZ
        LOacb2GxuNL+k93i8q45bBYrDp1gtzi2QMxie/8+RgcOjy0rbzJ5LN7zksmjb8sqRo/Pm+QC
        WKL0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLLUov07RL0Mq6e
        USzYwVlxtO03YwPjJfYuRk4OCQETid5fB1m6GLk4hASWMkrMObuJDSIhJfHj1wVWCFtY4s+1
        LjaIom+MEl96ZzKCJNgEdCROrT4CZosANXzcsZ0dpIhZYCaTxJ7+EywgCWEBO4m2TTPAbBYB
        VYlvxxeBNfAKWEmcvTMF6gx5idUbDjBPYORZwMiwilEktbQ4Nz232FCvODG3uDQvXS85P3cT
        IzAEtx37uXkH46WNwYcYBTgYlXh4X5T8ihFiTSwrrsw9xCjBwawkwlt24UeMEG9KYmVValF+
        fFFpTmrxIUZToOUTmaVEk/OB8ZFXEm9oamhuYWlobmxubGahJM7bIXAwRkggPbEkNTs1tSC1
        CKaPiYNTqoGxzfkb215x+d8BjhJzttTLHbq7R+0m99MF31bzZ+xKm6l6ly3N+/r79og7W9tO
        7fI/9SBBQv6EYdev3Ml5FZrRRz//evx6U7qJron2ngKt35a3VmgIKh130Lv8wdN4rZFfmudk
        KbavvzL27tcpn82Q7sq+1L5VPTeX6XR24ze9q/fOKr8wWFqpxFKckWioxVxUnAgA+h3bmVcC
        AAA=
X-CMS-MailID: 20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e
References: <CGME20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should not call 'ndo_bpf()' or 'dev_put()' with NULL argument.

Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and zero-copy on one queue id")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---

I'm not sure if this fixes any real NULL pointer dereference, but code
is not consistent anyway and should be fixed.

 net/xdp/xdp_umem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 2b18223e7eb8..9c6de4f114f8 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -143,6 +143,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 	struct netdev_bpf bpf;
 	int err;
 
+	if (!umem->dev)
+		return;
+
 	if (umem->zc) {
 		bpf.command = XDP_SETUP_XSK_UMEM;
 		bpf.xsk.umem = NULL;
@@ -156,11 +159,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 			WARN(1, "failed to disable umem!\n");
 	}
 
-	if (umem->dev) {
-		rtnl_lock();
-		xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
-		rtnl_unlock();
-	}
+	rtnl_lock();
+	xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
+	rtnl_unlock();
 
 	if (umem->zc) {
 		dev_put(umem->dev);
-- 
2.17.1

