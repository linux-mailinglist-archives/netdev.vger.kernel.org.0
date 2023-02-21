Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BE969E29E
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 15:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbjBUOsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 09:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbjBUOr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 09:47:56 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F71928D2F
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 06:47:44 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id m25-20020a7bcb99000000b003e7842b75f2so1459562wmi.3
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 06:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o4mWVM9T8dfHGIl7P8eiExkKjczxJmVekYpJZZnuF0w=;
        b=Z9AjOxJzTYoZ2DIDfGgXBWzFfLcqYc6u7sRHjIITA4F3pganfmOao3DGyunICcyrai
         RFKSLlhJ6CrR9ktz1HSJlbA61Og4N8FlT8sxkNYtXmVWb/LBu0hTaDgmDfqYJ9+xcB0D
         iV2BNMEYfZkw13sRhE1Ub999SIBwaKm4SYTAau60gyjFJsjQ8RipJLQqT+traYnGqAN1
         PWLbn5ajy2GvFnBlZ8XH3tUoKXQ7iZBfZJ/5auNbn7LlmVwowC+lG/zfcMs03eWswVTk
         Pu9+N1zd0EUJFf/jSfC8DrPCu31Dz4SuBmoq19agOuiz2NtLYGyDa6I0ANXwu5TR1Gk3
         E3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o4mWVM9T8dfHGIl7P8eiExkKjczxJmVekYpJZZnuF0w=;
        b=EC0zDlHoN/MPr9lP91iy7mt33+/cVxV5uAqzfqSKQ4kL86BNzd/gngvVIoInHX2iWF
         b/lBPe+E4D5KxzFkfdkaEugto49IqzFH9sDomC5Ea/xwwFxwR0YNLvJd3RJlSxLy2b66
         O/jyssBuqtOzSbeklUk+thkh3KlxpWPT30oT1rgET3tUk12DifRY08s8CzO3SE0GomDh
         oxlj0efZOEsl/JM6osWPr53fCM7TGzJzvNvyTIPPHEWU59r+boSkACHhDidki7BlK6UZ
         lo9DggiO+FJ5Z4yFFGkGQij9pktDxzoBOG188J90qlovIMMckFkiZQPlKNmtYcp8SpFe
         Ryrw==
X-Gm-Message-State: AO0yUKV708ZqvNL6aVq1jI9Z9CMduWau1pnkcrZiRcsWbYc/6KOtHw7P
        fFdfkpysadWVIo5zWtII0EJ2y0uNcBn0jN06D9Afkg==
X-Google-Smtp-Source: AK7set9aahy7X6+87gTHV7TpgIzNTW6v9HbXn2RvM8cMKYKK3zXoO+BpzvAzvMQDU3rii1OjBDPOhg==
X-Received: by 2002:a05:600c:4d97:b0:3e2:bf1:9eb0 with SMTP id v23-20020a05600c4d9700b003e20bf19eb0mr3204208wmp.9.1676990863121;
        Tue, 21 Feb 2023 06:47:43 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c4f4600b003df245cd853sm6354173wmq.44.2023.02.21.06.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 06:47:42 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Subject: [patch net-next v2] net: virtio_net: implement exact header length guest feature
Date:   Tue, 21 Feb 2023 15:47:41 +0100
Message-Id: <20230221144741.316477-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
set implicates that the driver provides the exact size of the header.

Quoting the original virtio spec:
"hdr_len is a hint to the device as to how much of the header needs to
 be kept to copy into each packet"

"a hint" might not be clear for the reader what does it mean, if it is
"maybe like that" of "exactly like that". This feature just makes it
crystal clear and let the device count on the hdr_len being filled up
by the exact length of header.

Also note the spec already has following note about hdr_len:
"Due to various bugs in implementations, this field is not useful
 as a guarantee of the transport header size."

Without this feature the device needs to parse the header in core
data path handling. Accurate information helps the device to eliminate
such header parsing and directly use the hardware accelerators
for GSO operation.

virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
The driver already complies to fill the correct value. Introduce the
feature and advertise it.

Note that virtio spec also includes following note for device
implementation:
"Caution should be taken by the implementation so as to prevent
 a malicious driver from attacking the device by setting
 an incorrect hdr_len."

There is a plan to support this feature in our emulated device.
A device of SolidRun offers this feature bit. They claim this feature
will save the device a few cycles for every GSO packet.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- extended patch description
---
 drivers/net/virtio_net.c        | 6 ++++--
 include/uapi/linux/virtio_net.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fb5e68ed3ec2..e85b03988733 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_UFO,
 	VIRTIO_NET_F_GUEST_CSUM,
 	VIRTIO_NET_F_GUEST_USO4,
-	VIRTIO_NET_F_GUEST_USO6
+	VIRTIO_NET_F_GUEST_USO6,
+	VIRTIO_NET_F_GUEST_HDRLEN
 };
 
 #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
@@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
+	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
+	VIRTIO_NET_F_GUEST_HDRLEN
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index b4062bed186a..12c1c9699935 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -61,6 +61,7 @@
 #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
 #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
+#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
 #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
-- 
2.39.0

