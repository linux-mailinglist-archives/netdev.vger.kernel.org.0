Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7040A428951
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 11:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhJKJDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 05:03:45 -0400
Received: from mout.gmx.net ([212.227.15.15]:59725 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235182AbhJKJDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 05:03:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1633942880;
        bh=QL1/2USoBJUi81zl6CidkHdUwzip2iXDOnIteGlXBUI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=iMGMtf14PsbeyM3DTIQMrCosO0IEcMZj0tobjo6zhoMjOtLWJfiVau7qbAp4+CSZC
         5HfPaJhSTD/xt6EVL4cBa1FAtGE9lf1MqweYVUdqgluB/pbh8/Uo9JJe/XpPJF8ZMC
         4Ug69s4l/i1NxtQxioJqP34bP406ej5+0o6Ulr5k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx005 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MTiPv-1mCMkH0N8X-00U1rH; Mon, 11 Oct 2021 11:01:20 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns: Prefer struct_size over open coded arithmetic
Date:   Mon, 11 Oct 2021 11:01:00 +0200
Message-Id: <20211011090100.5727-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QJSw2VIiYaSE/z4gfCPLRlIwKXVBEbNHEMNKeXOL7+4DSKzqXCh
 a8dUNxyzoQ1ynfucruDN8VkW69DGSEGsbS6H/hz38NN5NMsy0U72YfXWWWxhj9U/4efSa3L
 NwEujXeFaAiZEjA3R33RDDw24Ig2/IJ7O10yG4qzYVYqAzzeTHuIYCO4JnIUCKqIp1cloH9
 r9zCJeqCC0jFgoO2iOLnQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:IHgqHV+5zdU=:s+cH6xu3LlDz7e0IqEd84E
 6YfAijLR+7ZOTTxC34z2vgAJ7SDeVjnUD7f6kFD+hnqYko3P+antXSkgdaaRtlT/h4Hpn5YFe
 mBdIQ4x4wH2mPbkdXhiPZjofFf6H48jZxtGKczfPn/L5sHAWyxpbueDGA5uS62Srbks0rV4aJ
 MSG5fu0HENJZzWhfd03/Pfiy6yuyMfAO5XjmMZvfTV5zqqYm/hvpzj1CXzF1CRSo29Oy09H3M
 CH+ljRhlTvkQHuSNOeYdeY+XN77bx93R1huFXVsD1UUOxpCJmekc3spwtJMVOvfWS8lwfg+wR
 hOJRxuzddaCNzrCkG0PTrGmvmnFIXQw3v/RVphzPmzeq/n+OJftBnDb7PPpQnFKc80BypzWzv
 17sSN80cENCf+IY6q2h5sNngVwd51RXqu1o0MbrRt+o3Q4VlZhO+WpzBPtoVG9LJIUUkJrd+/
 u3BfHIL7o2v8OQQUjXTUM8rWLyp7VzRkcMgiABD7slahy2INhuNqQkuuBNaK614HqckRV1xq/
 Owe4/fCpFdU7t67HBl1kBHkpM9ffUs5JV+raGsXYho1Ao3M2OVYf/2KIeampHx4TPk5fzeuKX
 j//J23J9ehG/zDxDkgJKupWu7dXjTTjk62e9E5rgMthswrF73fQgerq/UaXoxk511dycuXG3h
 Zhm3BMrOfoD/3ksvkeozbsN6pNwzFt+85MqFqo98XlZ1G0lTeNFza7H6jRAZU23R7kGfJCIzC
 NBBxvk8tZU5/DevY0EA4KocXldMeMhtYd20PlgYwKnpROLRJAayohjlPgy8rBCHdfmGkn4sUp
 cJ27IoeWdEtSQzLxrqwVyWOLjXGPhU1MzC5IKktjTKRD+bfs4aqJi71+F1DLmWaRL5X+ZHvEF
 RdggUE5DfHcSv3773TRMRuA0yHc7eQmeC7AGCHnStELLbcc5+bncfPWVnKEiFX1CwcB8mfWiT
 v8TxE1EyfkoZVjtSHc+uq5q0ITyoGNGR+IgCVus887NLYJ2/RUTs/MGzL8Cwv/Ra4Vx776dCN
 d+rlhOT/VpmvptV/nJ6vwwIACZj/yB8CwxqAfJLIhCXfB6kIU7UpEfjH8tzKjOV+TxG9v9Drh
 EmymjGCoyxhUjE=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, take the opportunity to refactor the hnae_handle structure to switch
the last member to flexible array, changing the code accordingly. Also,
fix the comment in the hnae_vf_cb structure to inform that the ae_handle
member must be the last member.

Then, use the struct_size() helper to do the arithmetic instead of the
argument "size + count * size" in the kzalloc() function.

This code was detected with the help of Coccinelle and audited and fixed
manually.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-co=
ded-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 drivers/net/ethernet/hisilicon/hns/hnae.h          | 2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  | 5 ++---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.h b/drivers/net/ether=
net/hisilicon/hns/hnae.h
index 2b7db1c22321..d46e8f999019 100644
=2D-- a/drivers/net/ethernet/hisilicon/hns/hnae.h
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.h
@@ -558,7 +558,7 @@ struct hnae_handle {
 	enum hnae_media_type media_type;
 	struct list_head node;    /* list to hnae_ae_dev->handle_list */
 	struct hnae_buf_ops *bops; /* operation for the buffer */
-	struct hnae_queue **qs;  /* array base of all queues */
+	struct hnae_queue *qs[];  /* flexible array of all queues */
 };

 #define ring_to_dev(ring) ((ring)->q->dev->dev)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c b/drivers/n=
et/ethernet/hisilicon/hns/hns_ae_adapt.c
index 75e4ec569da8..e81116ad9bdf 100644
=2D-- a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
@@ -81,8 +81,8 @@ static struct hnae_handle *hns_ae_get_handle(struct hnae=
_ae_dev *dev,
 	vfnum_per_port =3D hns_ae_get_vf_num_per_port(dsaf_dev, port_id);
 	qnum_per_vf =3D hns_ae_get_q_num_per_vf(dsaf_dev, port_id);

-	vf_cb =3D kzalloc(sizeof(*vf_cb) +
-			qnum_per_vf * sizeof(struct hnae_queue *), GFP_KERNEL);
+	vf_cb =3D kzalloc(struct_size(vf_cb, ae_handle.qs, qnum_per_vf),
+			GFP_KERNEL);
 	if (unlikely(!vf_cb)) {
 		dev_err(dsaf_dev->dev, "malloc vf_cb fail!\n");
 		ae_handle =3D ERR_PTR(-ENOMEM);
@@ -108,7 +108,6 @@ static struct hnae_handle *hns_ae_get_handle(struct hn=
ae_ae_dev *dev,
 		goto vf_id_err;
 	}

-	ae_handle->qs =3D (struct hnae_queue **)(&ae_handle->qs + 1);
 	for (i =3D 0; i < qnum_per_vf; i++) {
 		ae_handle->qs[i] =3D &ring_pair_cb->q;
 		ae_handle->qs[i]->rx_ring.q =3D ae_handle->qs[i];
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h b/drivers/=
net/ethernet/hisilicon/hns/hns_dsaf_main.h
index cba04bfa0b3f..5526a10caac5 100644
=2D-- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h
@@ -210,7 +210,7 @@ struct hnae_vf_cb {
 	u8 port_index;
 	struct hns_mac_cb *mac_cb;
 	struct dsaf_device *dsaf_dev;
-	struct hnae_handle  ae_handle; /* must be the last number */
+	struct hnae_handle  ae_handle; /* must be the last member */
 };

 struct dsaf_int_xge_src {
=2D-
2.25.1

