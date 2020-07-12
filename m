Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B6D21C9E3
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 16:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgGLOzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 10:55:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728882AbgGLOzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 10:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594565711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=6nL6kDn6HMgn8sx0okC7YwBl7oR6NlWE67Kvx5ek+uw=;
        b=ezjziVssR4bm/MxYrwc1izd/WzS5nzuobW5RQyLimkibtSZ3z7FsdZVU+BgE/sqjB7fmle
        NX/11ykQfeeAypD4JWsWkVIMvTsfZN+l2jQiznjLxDmRs6W45bkWnwFWG+Nr5BNcTZ1+gS
        8/axs4z+7aqyoJQI1heNVB9lYPCgcbA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-8bCrrj4OMx2oNltvnKjA5g-1; Sun, 12 Jul 2020 10:55:10 -0400
X-MC-Unique: 8bCrrj4OMx2oNltvnKjA5g-1
Received: by mail-wr1-f72.google.com with SMTP id j5so14171768wro.6
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 07:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=6nL6kDn6HMgn8sx0okC7YwBl7oR6NlWE67Kvx5ek+uw=;
        b=nVu0kMu75oTpR1ct2bWVKQ2DwfZx3jcLRn1JESKZrhwCeiedZ/R5U2gAjpdiAcDHYw
         qUpSMcGidUrH0auJeLwOB3xPVCmrKQp8JO8Um9ZTnfW0kPJK6WxsWZG5J07CKJ+1z08F
         E3upP0cDQ3KktLF+Z3adU0J9WYxTv5Dc4kXvH0rGqnm4S+MU+ZFwC867nFWOBOd7jptJ
         AaBS2MS2F4QyZufaUkhnrCCKv6wmMBd05YF9QRkYIF3NA0paSMtudZokFTSgULYOL7YZ
         piB56zWTk/4XRPRPCusKRvVNsrcRdWtBh/CqaZUUugTkSMShDPGanD0uokw3gkQ21c1g
         pVzA==
X-Gm-Message-State: AOAM532Ne/GvGOVHotp0/f/t7UrmilOiyc45Bzbt64Zx53YPq5gt+2K3
        e7OBtvE9RUlOVXHY4IPbTzA+EJ0X0CYeKvl9+okRfezjBURP3/WQtvMgCQkjy1MEBWJZwH04ZKA
        PcWJBW4luZZHhCKZc
X-Received: by 2002:a05:600c:2dc1:: with SMTP id e1mr13878935wmh.108.1594565707259;
        Sun, 12 Jul 2020 07:55:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwk680C1Rkd/fNGPOmQc3S/qzMmIRqDIOQYMsKgiZpDsxSuaZsrQGI5EyVxtpuoVK3n/aNrsg==
X-Received: by 2002:a05:600c:2dc1:: with SMTP id e1mr13878912wmh.108.1594565706989;
        Sun, 12 Jul 2020 07:55:06 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id u186sm19324768wmu.10.2020.07.12.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 07:55:06 -0700 (PDT)
Date:   Sun, 12 Jul 2020 10:55:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     netdev@vger.kernel.org, dwoods@mellanox.com, lsun@mellanox.com
Cc:     Darren Hart <dvhart@infradead.org>,
        Vadim Pasternak <vadimp@mellanox.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH] mlxbf-tmfifo: endian-ness wrappers for config access
Message-ID: <20200712102743-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!
While working out some endian-ness issues with virtio,
I noticed that the following driver:

drivers/platform/mellanox/mlxbf-tmfifo.c

seems to access virtio net config directly.
E.g.:

                        if (ntohs(hdr.len) > config->mtu +
                            MLXBF_TMFIFO_NET_L2_OVERHEAD)
                                return;

This is not incorrect in that the specific device is at the
moment always legacy (no virtio 1).

However this throws up sparse warnings as the structure
is shared with modern devices which need the tagging for
correct virtio 1 endian-ness.

Using correct conversions will also allow virtio 1 support
in this driver down the road.

I'd like to merge the following patch. It's on top of
a branch config-endian in my tree which includes
the endian-ness tagging.

Would appreciate acks from relevant maintainers.
I also note that the console config field seems to be unused.
Would appreciate a confirmation.
Thanks!

--

mlxbf-tmfifo: endian-ness wrappers for config access

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

-->

diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 5739a9669b29..b1484206429f 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -608,6 +608,7 @@ static void mlxbf_tmfifo_rxtx_header(struct mlxbf_tmfifo_vring *vring,
 {
 	struct mlxbf_tmfifo *fifo = vring->fifo;
 	struct virtio_net_config *config;
+	struct virtio_device *vdev;
 	struct mlxbf_tmfifo_msg_hdr hdr;
 	int vdev_id, hdr_len;
 
@@ -625,7 +626,8 @@ static void mlxbf_tmfifo_rxtx_header(struct mlxbf_tmfifo_vring *vring,
 			vdev_id = VIRTIO_ID_NET;
 			hdr_len = sizeof(struct virtio_net_hdr);
 			config = &fifo->vdev[vdev_id]->config.net;
-			if (ntohs(hdr.len) > config->mtu +
+			vdev = &fifo->vdev[vdev_id]->vdev;
+			if (ntohs(hdr.len) > virtio16_to_cpu(vdev, config->mtu) +
 			    MLXBF_TMFIFO_NET_L2_OVERHEAD)
 				return;
 		} else {
@@ -1231,8 +1233,14 @@ static int mlxbf_tmfifo_probe(struct platform_device *pdev)
 
 	/* Create the network vdev. */
 	memset(&net_config, 0, sizeof(net_config));
-	net_config.mtu = ETH_DATA_LEN;
-	net_config.status = VIRTIO_NET_S_LINK_UP;
+
+#defined MLXBF_TMFIFO_LITTLE_ENDIAN (virtio_legacy_is_little_endian() ||
+			(MLXBF_TMFIFO_NET_FEATURES & (1ULL << VIRTIO_F_VERSION_1)))
+
+	net_config.mtu = __cpu_to_virtio16(MLXBF_TMFIFO_LITTLE_ENDIAN,
+					   ETH_DATA_LEN);
+	net_config.status = __cpu_to_virtio16(MLXBF_TMFIFO_LITTLE_ENDIAN,
+					      VIRTIO_NET_S_LINK_UP);
 	mlxbf_tmfifo_get_cfg_mac(net_config.mac);
 	rc = mlxbf_tmfifo_create_vdev(dev, fifo, VIRTIO_ID_NET,
 				      MLXBF_TMFIFO_NET_FEATURES, &net_config,
-- 
MST

