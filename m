Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA29509FF5
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385639AbiDUMuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 08:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383225AbiDUMuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 08:50:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 724AC326E1
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 05:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650545251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=t4gvH2vkKY20OkhKQ0uTd4eiUeQRQjWF42e9zqTkqwk=;
        b=ILl4kZuMM8Ay4YW7Gu+bFYVCl11mz9Np1aZvkGCdwRjp2eMYfFvxLnKWOON7dGCLbVbo0I
        cEmIA0KYYqTBlM4FH5aqmwjzgp6dZ6wzmX14LfEFzQHP5mzM1uGOSRfd1VqB156LvGBGRY
        oE0PBZQcaQDmmsbabyIfDAeiPjgU76E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-61RhXjKUPOamj5GZVbvs8w-1; Thu, 21 Apr 2022 08:47:30 -0400
X-MC-Unique: 61RhXjKUPOamj5GZVbvs8w-1
Received: by mail-wm1-f69.google.com with SMTP id d6-20020a05600c34c600b0039296a2ac7cso2384373wmq.1
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 05:47:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=t4gvH2vkKY20OkhKQ0uTd4eiUeQRQjWF42e9zqTkqwk=;
        b=fm33/iAHLl6rXqcG8PqiZoo29ulbc18pMuFGB5ZWQIWHd2dLluYUrgH+NTf8LGHyAI
         f3r/NYfGwf8v+In1m130s0k0JoSZ2FoeyNp8z702Ij+X66W1f825JsK6JwLTMraejFhp
         vcsOWoN/yi6vbyGDveM4E074fdbX/sIXAJm8awOiaWfODqEJ9l9GZNBOTO/3uYrjPLI/
         O9qAMnqHXVUs3S1oo4eaPxNlMNOYphd7dEp7EonwWIm0Hy0+VBAzD9N9caOBwk2vXtIn
         suBQn8K/MZQU1YsgB7WQCI6GYDqN59LS8zSfOTNariz39K/Jf0UaJJDJ5wlBVXSwbSNs
         exQQ==
X-Gm-Message-State: AOAM531bbeTY+k+bal/yM8aE6KcTQ5RpqR2gu1qsuPR6l7RkAnvUOakM
        izJRCCScpbvNtmhEOZ1l/rwRA7/Joip5RoikuAfYAjAvQ7kfthS3Ev1X/cK/t8ASGb5l6WiqoXO
        shL1tfqUmpiTUSSkk
X-Received: by 2002:adf:a1c4:0:b0:20a:92c3:abfd with SMTP id v4-20020adfa1c4000000b0020a92c3abfdmr16250991wrv.551.1650545249142;
        Thu, 21 Apr 2022 05:47:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNvqmlN+NOkQKuiX0HreL9YQ2wIB18U0+VTWvC8PxKuFqoa+IbMCvW3kg2W9ulhvz4NJMCSQ==
X-Received: by 2002:adf:a1c4:0:b0:20a:92c3:abfd with SMTP id v4-20020adfa1c4000000b0020a92c3abfdmr16250966wrv.551.1650545248916;
        Thu, 21 Apr 2022 05:47:28 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id 3-20020a056000154300b0020a9dcac3c2sm2836850wry.20.2022.04.21.05.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 05:47:28 -0700 (PDT)
Date:   Thu, 21 Apr 2022 14:47:26 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikolay Assa <nassa@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Shai Malin <smalin@marvell.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH net-next] qed: Remove IP services API.
Message-ID: <351ac8c847980e22850eb390553f8cc0e1ccd0ce.1650545051.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qed_nvmetcp_ip_services.c and its corresponding header file were
introduced in commit 806ee7f81a2b ("qed: Add IP services APIs support")
but there's still no users for any of the functions they declare.
Since these files are effectively unused, let's just drop them.

Found by code inspection. Compile-tested only.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/ethernet/qlogic/qed/Makefile      |   3 +-
 .../qlogic/qed/qed_nvmetcp_ip_services.c      | 238 ------------------
 .../linux/qed/qed_nvmetcp_ip_services_if.h    |  29 ---
 3 files changed, 1 insertion(+), 269 deletions(-)
 delete mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
 delete mode 100644 include/linux/qed/qed_nvmetcp_ip_services_if.h

diff --git a/drivers/net/ethernet/qlogic/qed/Makefile b/drivers/net/ethernet/qlogic/qed/Makefile
index 0d9c2fe0245d..3d2098f21bb7 100644
--- a/drivers/net/ethernet/qlogic/qed/Makefile
+++ b/drivers/net/ethernet/qlogic/qed/Makefile
@@ -30,8 +30,7 @@ qed-$(CONFIG_QED_OOO) += qed_ooo.o
 
 qed-$(CONFIG_QED_NVMETCP) +=	\
 	qed_nvmetcp.o		\
-	qed_nvmetcp_fw_funcs.o	\
-	qed_nvmetcp_ip_services.o
+	qed_nvmetcp_fw_funcs.o
 
 qed-$(CONFIG_QED_RDMA) +=	\
 	qed_iwarp.o		\
diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
deleted file mode 100644
index 7e286cddbedb..000000000000
--- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
+++ /dev/null
@@ -1,238 +0,0 @@
-// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
-/*
- * Copyright 2021 Marvell. All rights reserved.
- */
-
-#include <linux/types.h>
-#include <asm/byteorder.h>
-#include <asm/param.h>
-#include <linux/delay.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
-#include <linux/etherdevice.h>
-#include <linux/kernel.h>
-#include <linux/stddef.h>
-#include <linux/errno.h>
-
-#include <net/tcp.h>
-
-#include <linux/qed/qed_nvmetcp_ip_services_if.h>
-
-#define QED_IP_RESOL_TIMEOUT  4
-
-int qed_route_ipv4(struct sockaddr_storage *local_addr,
-		   struct sockaddr_storage *remote_addr,
-		   struct sockaddr *hardware_address,
-		   struct net_device **ndev)
-{
-	struct neighbour *neigh = NULL;
-	__be32 *loc_ip, *rem_ip;
-	struct rtable *rt;
-	int rc = -ENXIO;
-	int retry;
-
-	loc_ip = &((struct sockaddr_in *)local_addr)->sin_addr.s_addr;
-	rem_ip = &((struct sockaddr_in *)remote_addr)->sin_addr.s_addr;
-	*ndev = NULL;
-	rt = ip_route_output(&init_net, *rem_ip, *loc_ip, 0/*tos*/, 0/*oif*/);
-	if (IS_ERR(rt)) {
-		pr_err("lookup route failed\n");
-		rc = PTR_ERR(rt);
-		goto return_err;
-	}
-
-	neigh = dst_neigh_lookup(&rt->dst, rem_ip);
-	if (!neigh) {
-		rc = -ENOMEM;
-		ip_rt_put(rt);
-		goto return_err;
-	}
-
-	*ndev = rt->dst.dev;
-	ip_rt_put(rt);
-
-	/* If not resolved, kick-off state machine towards resolution */
-	if (!(neigh->nud_state & NUD_VALID))
-		neigh_event_send(neigh, NULL);
-
-	/* query neighbor until resolved or timeout */
-	retry = QED_IP_RESOL_TIMEOUT;
-	while (!(neigh->nud_state & NUD_VALID) && retry > 0) {
-		msleep(1000);
-		retry--;
-	}
-
-	if (neigh->nud_state & NUD_VALID) {
-		/* copy resolved MAC address */
-		neigh_ha_snapshot(hardware_address->sa_data, neigh, *ndev);
-		hardware_address->sa_family = (*ndev)->type;
-		rc = 0;
-	}
-
-	neigh_release(neigh);
-	if (!(*loc_ip)) {
-		*loc_ip = inet_select_addr(*ndev, *rem_ip, RT_SCOPE_UNIVERSE);
-		local_addr->ss_family = AF_INET;
-	}
-
-return_err:
-
-	return rc;
-}
-EXPORT_SYMBOL(qed_route_ipv4);
-
-int qed_route_ipv6(struct sockaddr_storage *local_addr,
-		   struct sockaddr_storage *remote_addr,
-		   struct sockaddr *hardware_address,
-		   struct net_device **ndev)
-{
-	struct neighbour *neigh = NULL;
-	struct dst_entry *dst;
-	struct flowi6 fl6;
-	int rc = -ENXIO;
-	int retry;
-
-	memset(&fl6, 0, sizeof(fl6));
-	fl6.saddr = ((struct sockaddr_in6 *)local_addr)->sin6_addr;
-	fl6.daddr = ((struct sockaddr_in6 *)remote_addr)->sin6_addr;
-	dst = ip6_route_output(&init_net, NULL, &fl6);
-	if (!dst || dst->error) {
-		if (dst) {
-			dst_release(dst);
-			pr_err("lookup route failed %d\n", dst->error);
-		}
-
-		goto out;
-	}
-
-	neigh = dst_neigh_lookup(dst, &fl6.daddr);
-	if (neigh) {
-		*ndev = ip6_dst_idev(dst)->dev;
-
-		/* If not resolved, kick-off state machine towards resolution */
-		if (!(neigh->nud_state & NUD_VALID))
-			neigh_event_send(neigh, NULL);
-
-		/* query neighbor until resolved or timeout */
-		retry = QED_IP_RESOL_TIMEOUT;
-		while (!(neigh->nud_state & NUD_VALID) && retry > 0) {
-			msleep(1000);
-			retry--;
-		}
-
-		if (neigh->nud_state & NUD_VALID) {
-			neigh_ha_snapshot((u8 *)hardware_address->sa_data,
-					  neigh, *ndev);
-			hardware_address->sa_family = (*ndev)->type;
-			rc = 0;
-		}
-
-		neigh_release(neigh);
-
-		if (ipv6_addr_any(&fl6.saddr)) {
-			if (ipv6_dev_get_saddr(dev_net(*ndev), *ndev,
-					       &fl6.daddr, 0, &fl6.saddr)) {
-				pr_err("Unable to find source IP address\n");
-				goto out;
-			}
-
-			local_addr->ss_family = AF_INET6;
-			((struct sockaddr_in6 *)local_addr)->sin6_addr =
-								fl6.saddr;
-		}
-	}
-
-	dst_release(dst);
-
-out:
-
-	return rc;
-}
-EXPORT_SYMBOL(qed_route_ipv6);
-
-void qed_vlan_get_ndev(struct net_device **ndev, u16 *vlan_id)
-{
-	if (is_vlan_dev(*ndev)) {
-		*vlan_id = vlan_dev_vlan_id(*ndev);
-		*ndev = vlan_dev_real_dev(*ndev);
-	}
-}
-EXPORT_SYMBOL(qed_vlan_get_ndev);
-
-struct pci_dev *qed_validate_ndev(struct net_device *ndev)
-{
-	struct net_device *upper;
-	struct pci_dev *pdev;
-
-	for_each_pci_dev(pdev) {
-		if (pdev->driver &&
-		    !strcmp(pdev->driver->name, "qede")) {
-			upper = pci_get_drvdata(pdev);
-			if (upper->ifindex == ndev->ifindex)
-				return pdev;
-		}
-	}
-
-	return NULL;
-}
-EXPORT_SYMBOL(qed_validate_ndev);
-
-__be16 qed_get_in_port(struct sockaddr_storage *sa)
-{
-	return sa->ss_family == AF_INET
-		? ((struct sockaddr_in *)sa)->sin_port
-		: ((struct sockaddr_in6 *)sa)->sin6_port;
-}
-EXPORT_SYMBOL(qed_get_in_port);
-
-int qed_fetch_tcp_port(struct sockaddr_storage local_ip_addr,
-		       struct socket **sock, u16 *port)
-{
-	struct sockaddr_storage sa;
-	int rc = 0;
-
-	rc = sock_create(local_ip_addr.ss_family, SOCK_STREAM, IPPROTO_TCP,
-			 sock);
-	if (rc) {
-		pr_warn("failed to create socket: %d\n", rc);
-		goto err;
-	}
-
-	(*sock)->sk->sk_allocation = GFP_KERNEL;
-	sk_set_memalloc((*sock)->sk);
-
-	rc = kernel_bind(*sock, (struct sockaddr *)&local_ip_addr,
-			 sizeof(local_ip_addr));
-
-	if (rc) {
-		pr_warn("failed to bind socket: %d\n", rc);
-		goto err_sock;
-	}
-
-	rc = kernel_getsockname(*sock, (struct sockaddr *)&sa);
-	if (rc < 0) {
-		pr_warn("getsockname() failed: %d\n", rc);
-		goto err_sock;
-	}
-
-	*port = ntohs(qed_get_in_port(&sa));
-
-	return 0;
-
-err_sock:
-	sock_release(*sock);
-	sock = NULL;
-err:
-
-	return rc;
-}
-EXPORT_SYMBOL(qed_fetch_tcp_port);
-
-void qed_return_tcp_port(struct socket *sock)
-{
-	if (sock && sock->sk) {
-		tcp_set_state(sock->sk, TCP_CLOSE);
-		sock_release(sock);
-	}
-}
-EXPORT_SYMBOL(qed_return_tcp_port);
diff --git a/include/linux/qed/qed_nvmetcp_ip_services_if.h b/include/linux/qed/qed_nvmetcp_ip_services_if.h
deleted file mode 100644
index 3604aee53796..000000000000
--- a/include/linux/qed/qed_nvmetcp_ip_services_if.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
-/*
- * Copyright 2021 Marvell. All rights reserved.
- */
-
-#ifndef _QED_IP_SERVICES_IF_H
-#define _QED_IP_SERVICES_IF_H
-
-#include <linux/types.h>
-#include <net/route.h>
-#include <net/ip6_route.h>
-#include <linux/inetdevice.h>
-
-int qed_route_ipv4(struct sockaddr_storage *local_addr,
-		   struct sockaddr_storage *remote_addr,
-		   struct sockaddr *hardware_address,
-		   struct net_device **ndev);
-int qed_route_ipv6(struct sockaddr_storage *local_addr,
-		   struct sockaddr_storage *remote_addr,
-		   struct sockaddr *hardware_address,
-		   struct net_device **ndev);
-void qed_vlan_get_ndev(struct net_device **ndev, u16 *vlan_id);
-struct pci_dev *qed_validate_ndev(struct net_device *ndev);
-void qed_return_tcp_port(struct socket *sock);
-int qed_fetch_tcp_port(struct sockaddr_storage local_ip_addr,
-		       struct socket **sock, u16 *port);
-__be16 qed_get_in_port(struct sockaddr_storage *sa);
-
-#endif /* _QED_IP_SERVICES_IF_H */
-- 
2.21.3

