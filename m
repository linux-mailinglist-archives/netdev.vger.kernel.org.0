Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9C2676BF9
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 11:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjAVKG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 05:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAVKG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 05:06:26 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844E71CF66;
        Sun, 22 Jan 2023 02:05:45 -0800 (PST)
Received: from lenovo-t14s.redhat.com ([82.142.8.70]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1N62mG-1odzFs1dl2-016Sip; Sun, 22 Jan 2023 11:05:32 +0100
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eli Cohen <elic@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Cindy Lu <lulu@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Subject: [PATCH 3/4] vdpa_sim_net: don't always set VIRTIO_NET_F_MAC
Date:   Sun, 22 Jan 2023 11:05:25 +0100
Message-Id: <20230122100526.2302556-4-lvivier@redhat.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230122100526.2302556-1-lvivier@redhat.com>
References: <20230122100526.2302556-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:C0lmlhI9YjKOrifXTYZOHEY7D8bGXsds0Mu6iD7d1jXwqVaA7WL
 sYcBzy078gS83j0QHDpnJctaFKmGZiLCuxb3AA/tfTBL3PRP12tRjCTniZHuigzDnhw/RSg
 zjJVDPHYnTe+K4n9N8dD0jA0kYx8t+SRt+UppkXo1ECIK5buDQUtx5S8U11UY/uLr7Wbis6
 lxctRwls0pgcX4TTRKSBQ==
UI-OutboundReport: notjunk:1;M01:P0:6zYbxARN6Fw=;NZdmpebzzy4EWONpLH5sP7s5tqY
 Pd0rYgvFLRGaaBtvWDkzvY5vtmGYpFo48jBn3ra9agZuwM6P7JtXAk9FWwptQILP0ZqWYdToY
 TAGSCJ2bjCkayikhHdNEAGLjNAGfincmOs8StnOdT4cW73zuT36kn+RWkMdTPBGqV2somiaIQ
 98cxTL64LzR+lANpumdAq6HFlI+a/3qPTwbdcfPOhaoLc+F1ZWOl3+w8MFDTbdT9hBlf5K4Nc
 wFi1M3vJxtH6CDUyrv5KY6F6J2FrbXVkWdLHxP3S++FZ2aPLmbKWLsm/P9y9LwW0JJXKagV7m
 YH91u7GjV3f5rFh5bRiMsroGK9Jcr3NKPWPR/tFdN/HswNroUtDndNsY74OsGrTeDRMIsqBaW
 iWCqlArzOY444BVAlswkyySL2bHvl+gFBdte6H1FqkZ2kYSen22lrw0HZ6+TpC4FyKvnopNwe
 2JKlhWyQ99SRmpBLVh3QijZqE6gYCSdcjGgq+17bKPwedvC1w0gKkfY7ZVsH8m6eROyHObHpj
 bu19aicnLqghoe+kjMJXDsqPqq2tZFY+sxia36YkY7yzsmqz2l+FozmphKL7+C6ByadbRvKEv
 Ql8AQDuspgjF3FQwDRLj9WA0/t6c4xqRpZmlIBEKFX0Mq/yzuDOghRS8T0iF2FVMy9VVFrlxs
 zi76BFTexWgbEu3x4Se8xDXA73pkqD7Pn4EBCmKoOg==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if vdpa dev command doesn't set a MAC address, don't report
VIRTIO_NET_F_MAC.

As vdpa_sim_net sets VIRTIO_NET_F_MAC without setting the MAC address,
virtio-net doesn't set a random one and the address appears to be the
zero MAC address.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index 584b975a98a7..28e858659b85 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -257,6 +257,12 @@ static int vdpasim_net_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	dev_attr.work_fn = vdpasim_net_work;
 	dev_attr.buffer_size = PAGE_SIZE;
 
+	/* if vdpa dev doesn't provide a MAC address,
+	 * don't report we have one
+	 */
+	if (!(config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)))
+		dev_attr.supported_features &= ~(1ULL << VIRTIO_NET_F_MAC);
+
 	simdev = vdpasim_create(&dev_attr, config);
 	if (IS_ERR(simdev))
 		return PTR_ERR(simdev);
-- 
2.39.0

