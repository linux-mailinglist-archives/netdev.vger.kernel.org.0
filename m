Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04D15B0455
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 14:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiIGMw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 08:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiIGMwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 08:52:09 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DBCBA17F
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 05:51:51 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so9435807wmb.4
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 05:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ywbHx8uPG8BROy2AsLXbenY9pZ4XxIgdV+TM84PqKY0=;
        b=EagLoc7mgqRqmMzrCNlH+G2xp1vLIBxFZpHuINYqAaumHZ5H6eRgyj9jQkR+IweVbV
         39/X7EcIhisZOWCcX99rev3RzuR0Z5HJaj3+wQAUXm535kF0A1RfVKTqAJAiTObxR+Mm
         CDQRl21UIwabggLm4/1v+zNTDMTrgNi05NoyI2fnarXAqnjrBbLJZanxQg3g47AYjuoc
         WMS175FGz90fjq++UTLU5R/HgAlRC0PzyRvwGqiKRjkVBjlLcM+bK28OYzjsRLka9yJH
         XnzKZi+FhkaF6KaKMHiNaCnBOqH4QocSuyaVjY3i+qr40tmxu4lSoms05JVpoT1yViBB
         o1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ywbHx8uPG8BROy2AsLXbenY9pZ4XxIgdV+TM84PqKY0=;
        b=D+cZO9VD6h9s49qCkBmN+4hz/kceUvWhrlwwNGUl581lvu/x8WEEFLRfuuTsPJQBVa
         m1pAuixK2U8iIayEqOgeV12dKtFVbTt97PpHTc3wRVv/FOXG4PU1kSGX+KQ3j37T4HdF
         bH7I64/VOikoqhYVYqnVfeGmnl0fzNSix0p2kGEYhHju8FqJF9uTN/4YgPKyknTaY7tm
         DtToC78NGQrN4F9IyVtzbvmAvoGzKdkbV/D0p6LySUcoGAjkgl/B+4SQGkd8XtHSxe1F
         9BLHe5NegIXwroO4dHO/ES0IbpovMjSk7kBC0yE1DIycl6LgXj//+HkFBbXpxLwAGLJI
         Lrqw==
X-Gm-Message-State: ACgBeo1dbhalLq2fk+Olavdo1H/6DlGjJZun1cMJWcUwWSTCMg0+9o1t
        AKzHJqjeJzzdtJygBVFmHeaivQ==
X-Google-Smtp-Source: AA6agR5TISsCqM1wwAjvQMCYn+H4fwJF0mxPK90BuOZ14oHjdYbfn6F/Q47rCCiVb3TXt5olnSbtVg==
X-Received: by 2002:a7b:c848:0:b0:3a5:41f6:4d37 with SMTP id c8-20020a7bc848000000b003a541f64d37mr1987590wml.23.1662555103607;
        Wed, 07 Sep 2022 05:51:43 -0700 (PDT)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id e27-20020adf9bdb000000b0021f0ff1bc6csm11480001wrc.41.2022.09.07.05.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 05:51:43 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     edumazet@google.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v3 6/6] drivers/net/virtio_net.c: Added USO support.
Date:   Wed,  7 Sep 2022 15:50:48 +0300
Message-Id: <20220907125048.396126-7-andrew@daynix.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907125048.396126-1-andrew@daynix.com>
References: <20220907125048.396126-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now, it possible to enable GSO_UDP_L4("tx-udp-segmentation") for VirtioNet.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9cce7dec7366..0f70110957eb 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -60,13 +60,17 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_TSO6,
 	VIRTIO_NET_F_GUEST_ECN,
 	VIRTIO_NET_F_GUEST_UFO,
-	VIRTIO_NET_F_GUEST_CSUM
+	VIRTIO_NET_F_GUEST_CSUM,
+	VIRTIO_NET_F_GUEST_USO4,
+	VIRTIO_NET_F_GUEST_USO6
 };
 
 #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
 				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
 				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
-				(1ULL << VIRTIO_NET_F_GUEST_UFO))
+				(1ULL << VIRTIO_NET_F_GUEST_UFO)  | \
+				(1ULL << VIRTIO_NET_F_GUEST_USO4) | \
+				(1ULL << VIRTIO_NET_F_GUEST_USO6))
 
 struct virtnet_stat_desc {
 	char desc[ETH_GSTRING_LEN];
@@ -3082,7 +3086,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
-		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6))) {
 		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
 		return -EOPNOTSUPP;
 	}
@@ -3734,6 +3740,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 			dev->hw_features |= NETIF_F_TSO6;
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
 			dev->hw_features |= NETIF_F_TSO_ECN;
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_USO))
+			dev->hw_features |= NETIF_F_GSO_UDP_L4;
 
 		dev->features |= NETIF_F_GSO_ROBUST;
 
@@ -3780,7 +3788,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
+	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO) ||
+	    (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_USO4) &&
+	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_USO6)))
 		vi->big_packets = true;
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
@@ -4021,6 +4031,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_HOST_TSO4, VIRTIO_NET_F_HOST_UFO, VIRTIO_NET_F_HOST_TSO6, \
 	VIRTIO_NET_F_HOST_ECN, VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6, \
 	VIRTIO_NET_F_GUEST_ECN, VIRTIO_NET_F_GUEST_UFO, \
+	VIRTIO_NET_F_HOST_USO, VIRTIO_NET_F_GUEST_USO4, VIRTIO_NET_F_GUEST_USO6, \
 	VIRTIO_NET_F_MRG_RXBUF, VIRTIO_NET_F_STATUS, VIRTIO_NET_F_CTRL_VQ, \
 	VIRTIO_NET_F_CTRL_RX, VIRTIO_NET_F_CTRL_VLAN, \
 	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
-- 
2.37.2

