Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2A5E7B09
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403888AbfJ1VHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:07:10 -0400
Received: from mail-eopbgr750103.outbound.protection.outlook.com ([40.107.75.103]:38017
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391173AbfJ1VHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 17:07:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b75NeJSpTE1FzLfM0+4+JEkBI/bL3Fpa/nHsZxVv8j8kQt7AiwFcOLlsl7piUlzo2LTvD3uTrNJlK6ulYuj34RrNsRhnHuHjpbru+ZS3agZoa9XAhgETZC/JDLT+Ufx2y4njPCS6YR84iRlHmcsN6QnvQuUh3d3T6sOCX/4kGIabKTVh5uJUkeg8tGjHhaiLShpWTLhxx9ySn6lCi4uFE56BnJq7JDTAn0PG1FkBN1b8ZmhYTDPXm7JnNsAzWtPERJqT/E3b12KgKTcFMbYxhGXypPsdKDXWoOhC4YWs/8H/YmY7FRudkjEQO2+oMzHJgurZSTfFqPxgmuuF2iSTZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4SN/vgN95qZuQBFfRo2Xuuv4wMUboEVvBpBp63x/OA=;
 b=eKBz7bpXHQe4suxi0PvX4116E9rrUA7QZ4bWVNbqRjPLV/z3MM7/YNAxcVUJh9e3bNq/UrroYQvg8Vzr7aCeS5DeWqVKYPMyT2dr5++IwZvSW3jGilD4OLJ28CVZJtaV7n9W9ynwc5/bvtDJNWOC+bHUN1OliBH5EqqhXxsihta4fQglBlZ30ES7FeGhNfSkPt1XQYpTnAJfFUdZemzLH/QYGhpadKGwMNkubTdSfgGd51ATitMny5J89v2Qv1ewSwfkp21szIR3oTDEZ1uihcs2wapVoctNxWaFZYuZ9m6qAuuV1KLukwkZnJyeFTzowpKVe0ODWNUjrWPU7qK38w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4SN/vgN95qZuQBFfRo2Xuuv4wMUboEVvBpBp63x/OA=;
 b=c4ht19w69uq42ICohMF/NL6u4a1utL2MnzFXQcZ6rEgkMm/DW8t1SOMLq61OOlq796wFLQrUVI+OLAZWcSlc9bi7OweQtT/2uPXi9+jeyyRl/5bRk88D5rtQCMyEes/jUCSXFWC9r1Lc7KjLJ9KeEXcgKbWESrhR71VH6gPeljA=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1404.namprd21.prod.outlook.com (20.180.22.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.8; Mon, 28 Oct 2019 21:07:05 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7%3]) with mapi id 15.20.2408.016; Mon, 28 Oct 2019
 21:07:04 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Thread-Topic: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Thread-Index: AQHVjdOmTIjUBBGLTk2QDOIbF4Kc2g==
Date:   Mon, 28 Oct 2019 21:07:04 +0000
Message-ID: <1572296801-4789-4-git-send-email-haiyangz@microsoft.com>
References: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0076.namprd04.prod.outlook.com
 (2603:10b6:102:1::44) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: df13a167-31dc-43a2-5a79-08d75beac8df
x-ms-traffictypediagnostic: DM6PR21MB1404:|DM6PR21MB1404:|DM6PR21MB1404:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB14040AC53AB7414B0E4B9A9DAC660@DM6PR21MB1404.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(396003)(39860400002)(136003)(199004)(189003)(6512007)(446003)(36756003)(54906003)(50226002)(486006)(22452003)(2616005)(30864003)(476003)(305945005)(14454004)(478600001)(2501003)(6392003)(66066001)(7846003)(66476007)(66446008)(64756008)(66556008)(66946007)(10290500003)(6436002)(386003)(10090500001)(102836004)(7736002)(99286004)(11346002)(76176011)(52116002)(5660300002)(14444005)(186003)(26005)(6506007)(256004)(5024004)(8936002)(81156014)(81166006)(6116002)(6486002)(3846002)(4326008)(8676002)(2201001)(316002)(110136005)(25786009)(2906002)(4720700003)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1404;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qNJGim+yZ5/xaG/th1JzQDj+3u80B1chXQlwRP5XcytabmcUOvtEEpC7QLPgUwCSvQCjSTE3jWPhNvKWrmFaaVpAqFQ8b51ZwkBVODCmEsyHXA92sJLWVbwymHELOrOCsEdZTdHlRbvKWmvw4aN7Qchr6fSn54xIG4eDjZ/bDgMLO1sdVgK2BRBCdsXQauT74RBUY4LBiKFGUj1nb+rmsHLQIZV1ZksdsDV9DMnLgODgHLBck6HxQObyffr6FhzU+HNzZaHKc0He9QsHn9+1gWwJZKn06UMweWfwvpCixTC88OssdWSeo2XEUIiqhT9AFv4X1Gl9BomWy+Gmvh8YpXR1OdOnH3rDnoLfzhrx0qXSaBSFRhGybIS2XRTCx+LpED91f6hB83iqBbv/z5v2lJYkoD9csDVM6KDoEQ1klua+1lLNfob+W/o2TZX2Qt08
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df13a167-31dc-43a2-5a79-08d75beac8df
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 21:07:04.8969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ipu4PaFcYMfESthADVd4e6Kdv4lOfXa/+hvMlz4ZMSQqur8gRR+I/xxbedzhuknV8ZLQPSqmwFth6okqNs7Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1404
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support of XDP in native mode for hv_netvsc driver, and
transparently sets the XDP program on the associated VF NIC as well.

XDP program cannot run with LRO (RSC) enabled, so you need to disable LRO
before running XDP:
        ethtool -K eth0 lro off

XDP actions not yet supported:
        XDP_TX, XDP_REDIRECT

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/Makefile     |   2 +-
 drivers/net/hyperv/hyperv_net.h |  15 +++
 drivers/net/hyperv/netvsc.c     |   8 +-
 drivers/net/hyperv/netvsc_bpf.c | 211 ++++++++++++++++++++++++++++++++++++=
++++
 drivers/net/hyperv/netvsc_drv.c | 141 ++++++++++++++++++++++-----
 5 files changed, 351 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/hyperv/netvsc_bpf.c

diff --git a/drivers/net/hyperv/Makefile b/drivers/net/hyperv/Makefile
index 3a2aa07..0db7cca 100644
--- a/drivers/net/hyperv/Makefile
+++ b/drivers/net/hyperv/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_HYPERV_NET) +=3D hv_netvsc.o
=20
-hv_netvsc-y :=3D netvsc_drv.o netvsc.o rndis_filter.o netvsc_trace.o
+hv_netvsc-y :=3D netvsc_drv.o netvsc.o rndis_filter.o netvsc_trace.o netvs=
c_bpf.o
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_ne=
t.h
index 670ef68..e5aa256 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -142,6 +142,8 @@ struct netvsc_device_info {
 	u32  send_section_size;
 	u32  recv_section_size;
=20
+	struct bpf_prog *bprog;
+
 	u8 rss_key[NETVSC_HASH_KEYLEN];
 };
=20
@@ -199,6 +201,15 @@ int netvsc_recv_callback(struct net_device *net,
 void netvsc_channel_cb(void *context);
 int netvsc_poll(struct napi_struct *napi, int budget);
=20
+u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
+		   void **p_pbuf);
+unsigned int netvsc_xdp_fraglen(unsigned int len);
+struct bpf_prog *netvsc_xdp_get(struct netvsc_device *nvdev);
+int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
+		   struct netvsc_device *nvdev);
+int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog);
+int netvsc_bpf(struct net_device *dev, struct netdev_bpf *bpf);
+
 int rndis_set_subchannel(struct net_device *ndev,
 			 struct netvsc_device *nvdev,
 			 struct netvsc_device_info *dev_info);
@@ -865,6 +876,7 @@ struct netvsc_stats {
 	u64 bytes;
 	u64 broadcast;
 	u64 multicast;
+	u64 xdp_drop;
 	struct u64_stats_sync syncp;
 };
=20
@@ -965,6 +977,9 @@ struct netvsc_channel {
 	atomic_t queue_sends;
 	struct nvsc_rsc rsc;
=20
+	struct bpf_prog __rcu *bpf_prog;
+	struct xdp_rxq_info xdp_rxq;
+
 	struct netvsc_stats tx_stats;
 	struct netvsc_stats rx_stats;
 };
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index d22a36f..688487b 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -122,8 +122,10 @@ static void free_netvsc_device(struct rcu_head *head)
 	vfree(nvdev->send_buf);
 	kfree(nvdev->send_section_map);
=20
-	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++)
+	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++) {
+		xdp_rxq_info_unreg(&nvdev->chan_table[i].xdp_rxq);
 		vfree(nvdev->chan_table[i].mrc.slots);
+	}
=20
 	kfree(nvdev);
 }
@@ -1370,6 +1372,10 @@ struct netvsc_device *netvsc_device_add(struct hv_de=
vice *device,
 		nvchan->net_device =3D net_device;
 		u64_stats_init(&nvchan->tx_stats.syncp);
 		u64_stats_init(&nvchan->rx_stats.syncp);
+
+		xdp_rxq_info_reg(&nvchan->xdp_rxq, ndev, i);
+		xdp_rxq_info_reg_mem_model(&nvchan->xdp_rxq,
+					   MEM_TYPE_PAGE_SHARED, NULL);
 	}
=20
 	/* Enable NAPI handler before init callbacks */
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bp=
f.c
new file mode 100644
index 0000000..4d235ac
--- /dev/null
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019, Microsoft Corporation.
+ *
+ * Author:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
+#include <linux/kernel.h>
+#include <net/xdp.h>
+
+#include <linux/mutex.h>
+#include <linux/rtnetlink.h>
+
+#include "hyperv_net.h"
+
+u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
+		   void **p_pbuf)
+{
+	struct page *page =3D NULL;
+	void *data =3D nvchan->rsc.data[0];
+	u32 len =3D nvchan->rsc.len[0];
+	void *pbuf =3D data;
+	struct bpf_prog *prog;
+	struct xdp_buff xdp;
+	u32 act =3D XDP_PASS;
+
+	*p_pbuf =3D NULL;
+
+	rcu_read_lock();
+	prog =3D rcu_dereference(nvchan->bpf_prog);
+
+	if (!prog || nvchan->rsc.cnt > 1)
+		goto out;
+
+	/* copy to a new page buffer if data are not within a page */
+	if (virt_to_page(data) !=3D virt_to_page(data + len - 1)) {
+		page =3D alloc_page(GFP_ATOMIC);
+		if (!page)
+			goto out;
+
+		pbuf =3D page_address(page);
+		memcpy(pbuf, nvchan->rsc.data[0], len);
+
+		*p_pbuf =3D pbuf;
+	}
+
+	xdp.data_hard_start =3D pbuf;
+	xdp.data =3D xdp.data_hard_start;
+	xdp_set_data_meta_invalid(&xdp);
+	xdp.data_end =3D xdp.data + len;
+	xdp.rxq =3D &nvchan->xdp_rxq;
+	xdp.handle =3D 0;
+
+	act =3D bpf_prog_run_xdp(prog, &xdp);
+
+	switch (act) {
+	case XDP_PASS:
+		/* Pass to upper layers */
+		break;
+
+	case XDP_ABORTED:
+		trace_xdp_exception(ndev, prog, act);
+		break;
+
+	case XDP_DROP:
+		break;
+
+	default:
+		bpf_warn_invalid_xdp_action(act);
+	}
+
+out:
+	rcu_read_unlock();
+
+	if (page && act !=3D XDP_PASS) {
+		*p_pbuf =3D NULL;
+		__free_page(page);
+	}
+
+	return act;
+}
+
+unsigned int netvsc_xdp_fraglen(unsigned int len)
+{
+	return SKB_DATA_ALIGN(len) +
+	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+}
+
+struct bpf_prog *netvsc_xdp_get(struct netvsc_device *nvdev)
+{
+	return rtnl_dereference(nvdev->chan_table[0].bpf_prog);
+}
+
+int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
+		   struct netvsc_device *nvdev)
+{
+	struct bpf_prog *old_prog;
+	int frag_max, i;
+
+	old_prog =3D netvsc_xdp_get(nvdev);
+
+	if (!old_prog && !prog)
+		return 0;
+
+	frag_max =3D netvsc_xdp_fraglen(dev->mtu + ETH_HLEN);
+	if (prog && frag_max > PAGE_SIZE) {
+		netdev_err(dev, "XDP: mtu:%u too large, frag:%u\n",
+			   dev->mtu, frag_max);
+		return -EOPNOTSUPP;
+	}
+
+	if (prog && (dev->features & NETIF_F_LRO)) {
+		netdev_err(dev, "XDP: not support LRO\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (prog) {
+		prog =3D bpf_prog_add(prog, nvdev->num_chn);
+		if (IS_ERR(prog))
+			return PTR_ERR(prog);
+	}
+
+	for (i =3D 0; i < nvdev->num_chn; i++)
+		rcu_assign_pointer(nvdev->chan_table[i].bpf_prog, prog);
+
+	if (old_prog)
+		for (i =3D 0; i < nvdev->num_chn; i++)
+			bpf_prog_put(old_prog);
+
+	return 0;
+}
+
+int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog)
+{
+	struct netdev_bpf xdp;
+	bpf_op_t ndo_bpf;
+
+	ASSERT_RTNL();
+
+	if (!vf_netdev)
+		return 0;
+
+	ndo_bpf =3D vf_netdev->netdev_ops->ndo_bpf;
+	if (!ndo_bpf)
+		return 0;
+
+	memset(&xdp, 0, sizeof(xdp));
+
+	xdp.command =3D XDP_SETUP_PROG;
+	xdp.prog =3D prog;
+
+	return ndo_bpf(vf_netdev, &xdp);
+}
+
+static u32 netvsc_xdp_query(struct netvsc_device *nvdev)
+{
+	struct bpf_prog *prog =3D netvsc_xdp_get(nvdev);
+
+	if (prog)
+		return prog->aux->id;
+
+	return 0;
+}
+
+int netvsc_bpf(struct net_device *dev, struct netdev_bpf *bpf)
+{
+	struct net_device_context *ndevctx =3D netdev_priv(dev);
+	struct netvsc_device *nvdev =3D rtnl_dereference(ndevctx->nvdev);
+	struct net_device *vf_netdev =3D rtnl_dereference(ndevctx->vf_netdev);
+	int ret;
+
+	if (!nvdev || nvdev->destroy) {
+		if (bpf->command =3D=3D XDP_QUERY_PROG) {
+			bpf->prog_id =3D 0;
+			return 0; /* Query must always succeed */
+		} else {
+			return -ENODEV;
+		}
+	}
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		ret =3D netvsc_xdp_set(dev, bpf->prog, nvdev);
+
+		if (ret)
+			return ret;
+
+		ret =3D netvsc_vf_setxdp(vf_netdev, bpf->prog);
+
+		if (ret) {
+			netdev_err(dev, "vf_setxdp failed:%d\n", ret);
+			netvsc_xdp_set(dev, NULL, nvdev);
+		}
+
+		return ret;
+
+	case XDP_QUERY_PROG:
+		bpf->prog_id =3D netvsc_xdp_query(nvdev);
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index a14fc8e..415f8db 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/rtnetlink.h>
 #include <linux/netpoll.h>
+#include <linux/bpf.h>
=20
 #include <net/arp.h>
 #include <net/route.h>
@@ -760,7 +761,8 @@ static void netvsc_comp_ipcsum(struct sk_buff *skb)
 }
=20
 static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
-					     struct netvsc_channel *nvchan)
+					     struct netvsc_channel *nvchan,
+					     void *pbuf)
 {
 	struct napi_struct *napi =3D &nvchan->napi;
 	const struct ndis_pkt_8021q_info *vlan =3D nvchan->rsc.vlan;
@@ -769,16 +771,32 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct n=
et_device *net,
 	struct sk_buff *skb;
 	int i;
=20
-	skb =3D napi_alloc_skb(napi, nvchan->rsc.pktlen);
-	if (!skb)
-		return skb;
+	if (pbuf) {
+		unsigned int len =3D nvchan->rsc.pktlen;
+		unsigned int frag_size =3D netvsc_xdp_fraglen(len);
=20
-	/*
-	 * Copy to skb. This copy is needed here since the memory pointed by
-	 * hv_netvsc_packet cannot be deallocated
-	 */
-	for (i =3D 0; i < nvchan->rsc.cnt; i++)
-		skb_put_data(skb, nvchan->rsc.data[i], nvchan->rsc.len[i]);
+		skb =3D build_skb(pbuf, frag_size);
+
+		if (!skb) {
+			__free_page(virt_to_page(pbuf));
+			return NULL;
+		}
+
+		skb_put(skb, len);
+		skb->dev =3D napi->dev;
+	} else {
+		skb =3D napi_alloc_skb(napi, nvchan->rsc.pktlen);
+
+		if (!skb)
+			return NULL;
+
+		/* Copy to skb. This copy is needed here since the memory
+		 * pointed by hv_netvsc_packet cannot be deallocated.
+		 */
+		for (i =3D 0; i < nvchan->rsc.cnt; i++)
+			skb_put_data(skb, nvchan->rsc.data[i],
+				     nvchan->rsc.len[i]);
+	}
=20
 	skb->protocol =3D eth_type_trans(skb, net);
=20
@@ -826,13 +844,25 @@ int netvsc_recv_callback(struct net_device *net,
 	struct vmbus_channel *channel =3D nvchan->channel;
 	u16 q_idx =3D channel->offermsg.offer.sub_channel_index;
 	struct sk_buff *skb;
-	struct netvsc_stats *rx_stats;
+	struct netvsc_stats *rx_stats =3D &nvchan->rx_stats;
+	void *pbuf =3D NULL; /* page buffer */
+	u32 act;
=20
 	if (net->reg_state !=3D NETREG_REGISTERED)
 		return NVSP_STAT_FAIL;
=20
+	act =3D netvsc_run_xdp(net, nvchan, &pbuf);
+
+	if (act !=3D XDP_PASS) {
+		u64_stats_update_begin(&rx_stats->syncp);
+		rx_stats->xdp_drop++;
+		u64_stats_update_end(&rx_stats->syncp);
+
+		return NVSP_STAT_SUCCESS; /* consumed by XDP */
+	}
+
 	/* Allocate a skb - TODO direct I/O to pages? */
-	skb =3D netvsc_alloc_recv_skb(net, nvchan);
+	skb =3D netvsc_alloc_recv_skb(net, nvchan, pbuf);
=20
 	if (unlikely(!skb)) {
 		++net_device_ctx->eth_stats.rx_no_memory;
@@ -846,7 +876,6 @@ int netvsc_recv_callback(struct net_device *net,
 	 * on the synthetic device because modifying the VF device
 	 * statistics will not work correctly.
 	 */
-	rx_stats =3D &nvchan->rx_stats;
 	u64_stats_update_begin(&rx_stats->syncp);
 	rx_stats->packets++;
 	rx_stats->bytes +=3D nvchan->rsc.pktlen;
@@ -887,6 +916,7 @@ static void netvsc_get_channels(struct net_device *net,
 			(struct netvsc_device *nvdev)
 {
 	struct netvsc_device_info *dev_info;
+	struct bpf_prog *prog;
=20
 	dev_info =3D kzalloc(sizeof(*dev_info), GFP_ATOMIC);
=20
@@ -894,6 +924,8 @@ static void netvsc_get_channels(struct net_device *net,
 		return NULL;
=20
 	if (nvdev) {
+		ASSERT_RTNL();
+
 		dev_info->num_chn =3D nvdev->num_chn;
 		dev_info->send_sections =3D nvdev->send_section_cnt;
 		dev_info->send_section_size =3D nvdev->send_section_size;
@@ -902,6 +934,13 @@ static void netvsc_get_channels(struct net_device *net=
,
=20
 		memcpy(dev_info->rss_key, nvdev->extension->rss_key,
 		       NETVSC_HASH_KEYLEN);
+
+		prog =3D netvsc_xdp_get(nvdev);
+		if (prog) {
+			prog =3D bpf_prog_add(prog, 1);
+			if (!IS_ERR(prog))
+				dev_info->bprog =3D prog;
+		}
 	} else {
 		dev_info->num_chn =3D VRSS_CHANNEL_DEFAULT;
 		dev_info->send_sections =3D NETVSC_DEFAULT_TX;
@@ -913,6 +952,17 @@ static void netvsc_get_channels(struct net_device *net=
,
 	return dev_info;
 }
=20
+/* Free struct netvsc_device_info */
+static void netvsc_devinfo_put(struct netvsc_device_info *dev_info)
+{
+	if (dev_info->bprog) {
+		ASSERT_RTNL();
+		bpf_prog_put(dev_info->bprog);
+	}
+
+	kfree(dev_info);
+}
+
 static int netvsc_detach(struct net_device *ndev,
 			 struct netvsc_device *nvdev)
 {
@@ -924,6 +974,8 @@ static int netvsc_detach(struct net_device *ndev,
 	if (cancel_work_sync(&nvdev->subchan_work))
 		nvdev->num_chn =3D 1;
=20
+	netvsc_xdp_set(ndev, NULL, nvdev);
+
 	/* If device was up (receiving) then shutdown */
 	if (netif_running(ndev)) {
 		netvsc_tx_disable(nvdev, ndev);
@@ -957,7 +1009,8 @@ static int netvsc_attach(struct net_device *ndev,
 	struct hv_device *hdev =3D ndev_ctx->device_ctx;
 	struct netvsc_device *nvdev;
 	struct rndis_device *rdev;
-	int ret;
+	struct bpf_prog *prog;
+	int ret =3D 0;
=20
 	nvdev =3D rndis_filter_device_add(hdev, dev_info);
 	if (IS_ERR(nvdev))
@@ -973,6 +1026,13 @@ static int netvsc_attach(struct net_device *ndev,
 		}
 	}
=20
+	prog =3D dev_info->bprog;
+	if (prog) {
+		ret =3D netvsc_xdp_set(ndev, prog, nvdev);
+		if (ret)
+			goto err1;
+	}
+
 	/* In any case device is now ready */
 	netif_device_attach(ndev);
=20
@@ -982,7 +1042,7 @@ static int netvsc_attach(struct net_device *ndev,
 	if (netif_running(ndev)) {
 		ret =3D rndis_filter_open(nvdev);
 		if (ret)
-			goto err;
+			goto err2;
=20
 		rdev =3D nvdev->extension;
 		if (!rdev->link_state)
@@ -991,9 +1051,10 @@ static int netvsc_attach(struct net_device *ndev,
=20
 	return 0;
=20
-err:
+err2:
 	netif_device_detach(ndev);
=20
+err1:
 	rndis_filter_device_remove(hdev, nvdev);
=20
 	return ret;
@@ -1043,7 +1104,7 @@ static int netvsc_set_channels(struct net_device *net=
,
 	}
=20
 out:
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 	return ret;
 }
=20
@@ -1150,7 +1211,7 @@ static int netvsc_change_mtu(struct net_device *ndev,=
 int mtu)
 		dev_set_mtu(vf_netdev, orig_mtu);
=20
 out:
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 	return ret;
 }
=20
@@ -1375,8 +1436,8 @@ static int netvsc_set_mac_addr(struct net_device *nde=
v, void *p)
 /* statistics per queue (rx/tx packets/bytes) */
 #define NETVSC_PCPU_STATS_LEN (num_present_cpus() * ARRAY_SIZE(pcpu_stats)=
)
=20
-/* 4 statistics per queue (rx/tx packets/bytes) */
-#define NETVSC_QUEUE_STATS_LEN(dev) ((dev)->num_chn * 4)
+/* 5 statistics per queue (rx/tx packets/bytes, rx xdp_drop) */
+#define NETVSC_QUEUE_STATS_LEN(dev) ((dev)->num_chn * 5)
=20
 static int netvsc_get_sset_count(struct net_device *dev, int string_set)
 {
@@ -1408,6 +1469,7 @@ static void netvsc_get_ethtool_stats(struct net_devic=
e *dev,
 	struct netvsc_ethtool_pcpu_stats *pcpu_sum;
 	unsigned int start;
 	u64 packets, bytes;
+	u64 xdp_drop;
 	int i, j, cpu;
=20
 	if (!nvdev)
@@ -1436,9 +1498,11 @@ static void netvsc_get_ethtool_stats(struct net_devi=
ce *dev,
 			start =3D u64_stats_fetch_begin_irq(&qstats->syncp);
 			packets =3D qstats->packets;
 			bytes =3D qstats->bytes;
+			xdp_drop =3D qstats->xdp_drop;
 		} while (u64_stats_fetch_retry_irq(&qstats->syncp, start));
 		data[i++] =3D packets;
 		data[i++] =3D bytes;
+		data[i++] =3D xdp_drop;
 	}
=20
 	pcpu_sum =3D kvmalloc_array(num_possible_cpus(),
@@ -1486,6 +1550,8 @@ static void netvsc_get_strings(struct net_device *dev=
, u32 stringset, u8 *data)
 			p +=3D ETH_GSTRING_LEN;
 			sprintf(p, "rx_queue_%u_bytes", i);
 			p +=3D ETH_GSTRING_LEN;
+			sprintf(p, "rx_queue_%u_xdp_drop", i);
+			p +=3D ETH_GSTRING_LEN;
 		}
=20
 		for_each_present_cpu(cpu) {
@@ -1782,10 +1848,27 @@ static int netvsc_set_ringparam(struct net_device *=
ndev,
 	}
=20
 out:
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 	return ret;
 }
=20
+static netdev_features_t netvsc_fix_features(struct net_device *ndev,
+					     netdev_features_t features)
+{
+	struct net_device_context *ndevctx =3D netdev_priv(ndev);
+	struct netvsc_device *nvdev =3D rtnl_dereference(ndevctx->nvdev);
+
+	if (!nvdev || nvdev->destroy)
+		return features;
+
+	if ((features & NETIF_F_LRO) && netvsc_xdp_get(nvdev)) {
+		features ^=3D NETIF_F_LRO;
+		netdev_info(ndev, "Skip LRO - unsupported with XDP\n");
+	}
+
+	return features;
+}
+
 static int netvsc_set_features(struct net_device *ndev,
 			       netdev_features_t features)
 {
@@ -1872,12 +1955,14 @@ static void netvsc_set_msglevel(struct net_device *=
ndev, u32 val)
 	.ndo_start_xmit =3D		netvsc_start_xmit,
 	.ndo_change_rx_flags =3D		netvsc_change_rx_flags,
 	.ndo_set_rx_mode =3D		netvsc_set_rx_mode,
+	.ndo_fix_features =3D		netvsc_fix_features,
 	.ndo_set_features =3D		netvsc_set_features,
 	.ndo_change_mtu =3D		netvsc_change_mtu,
 	.ndo_validate_addr =3D		eth_validate_addr,
 	.ndo_set_mac_address =3D		netvsc_set_mac_addr,
 	.ndo_select_queue =3D		netvsc_select_queue,
 	.ndo_get_stats64 =3D		netvsc_get_stats64,
+	.ndo_bpf =3D			netvsc_bpf,
 };
=20
 /*
@@ -2164,6 +2249,7 @@ static int netvsc_register_vf(struct net_device *vf_n=
etdev)
 {
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device *netvsc_dev;
+	struct bpf_prog *prog;
 	struct net_device *ndev;
 	int ret;
=20
@@ -2208,6 +2294,9 @@ static int netvsc_register_vf(struct net_device *vf_n=
etdev)
 	vf_netdev->wanted_features =3D ndev->features;
 	netdev_update_features(vf_netdev);
=20
+	prog =3D netvsc_xdp_get(netvsc_dev);
+	netvsc_vf_setxdp(vf_netdev, prog);
+
 	return NOTIFY_OK;
 }
=20
@@ -2249,6 +2338,8 @@ static int netvsc_unregister_vf(struct net_device *vf=
_netdev)
=20
 	netdev_info(ndev, "VF unregistering: %s\n", vf_netdev->name);
=20
+	netvsc_vf_setxdp(vf_netdev, NULL);
+
 	netdev_rx_handler_unregister(vf_netdev);
 	netdev_upper_dev_unlink(vf_netdev, ndev);
 	RCU_INIT_POINTER(net_device_ctx->vf_netdev, NULL);
@@ -2362,14 +2453,14 @@ static int netvsc_probe(struct hv_device *dev,
 	list_add(&net_device_ctx->list, &netvsc_dev_list);
 	rtnl_unlock();
=20
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 	return 0;
=20
 register_failed:
 	rtnl_unlock();
 	rndis_filter_device_remove(dev, nvdev);
 rndis_failed:
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 devinfo_failed:
 	free_percpu(net_device_ctx->vf_stats);
 no_stats:
@@ -2397,8 +2488,10 @@ static int netvsc_remove(struct hv_device *dev)
=20
 	rtnl_lock();
 	nvdev =3D rtnl_dereference(ndev_ctx->nvdev);
-	if (nvdev)
+	if (nvdev) {
 		cancel_work_sync(&nvdev->subchan_work);
+		netvsc_xdp_set(net, NULL, nvdev);
+	}
=20
 	/*
 	 * Call to the vsc driver to let it know that the device is being
--=20
1.8.3.1

