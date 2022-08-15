Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7D593444
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 19:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiHOR4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 13:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbiHOR4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 13:56:38 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E682928739;
        Mon, 15 Aug 2022 10:56:37 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v4so2759247pgi.10;
        Mon, 15 Aug 2022 10:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc;
        bh=ZlaiYwQmPOVoDuRV3NsPQqCjaBRVIY66ahwXf+LQSm8=;
        b=qX55hIBVbqBR0cZjAsEPn7sgPjIfKowbxBQYk3CrGCVeEG8h20RcAm8pP3RfiMqhTp
         4qQYFuJx43GZpeYhkVkKvpXTUIgy46PgYwoeLr2z5Jxd3GCDpfDBcKxq+UfJgvdk7ANL
         Ct5w6QtEE9SN1FY9puokVo3RQKpQesk9JbM2fRzZ75C9UuYzJzNG+dow1Cnox/cgcRwb
         shIxcXa69QoZqV+X+tXtL2EIBqopqS4Gqqvw2nuNTkAMXUVycGlY4LtciV3T2m2t+8/8
         Y7o9dZemlo/FOcbUznf4y/NJkFL2GpD6jfW9rp/DweDsWggEyVJG1I5Iwx6Q1qFthkA8
         MESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc;
        bh=ZlaiYwQmPOVoDuRV3NsPQqCjaBRVIY66ahwXf+LQSm8=;
        b=2sKIh6eQfM4CL9wzuNsvP1czkKNTUx7ZvGLkja5dHbJn05cr8I6L81V4cVaPlgshsY
         o2fk3u/tcNTQZrtXWw18T8dXt51371a4SHQlr3TwPrhXz00vtsk0OyBuaM4WeaHkmRc3
         froovYT1g//YWFoLsLCW9+ByahGGqT0v4d1TcQ9EKfGSSvl+BSbEijnlQpblp6xuvdZl
         Kr3UmrYhlTs6iAFSJeIFfLzFrpX50i7e3pgw6nb/dYOEGkspPrwHc7k/n/8PE+vKIkMK
         fLp/P+OHuFSCXKBMgMvIQEcKeRgFdajaqmfG7Lau3SXDCmysf0upv0QzEFcehR603ECm
         wfoA==
X-Gm-Message-State: ACgBeo3vaA2ScG3OFxhkUUdua2fUCy+GgD3sMpz9/x8ZdpUgBvKpxviE
        rb2TQDF5XLJk9JfYWOr+XX0=
X-Google-Smtp-Source: AA6agR7CPHwtNojFP6EFwNoAyZ00k+Ph/v48Aw674UaRQE4Mcyd4EZtT5pYGLysjaqzXCQid2p8PFw==
X-Received: by 2002:a05:6a00:1aca:b0:52f:55f8:c3ec with SMTP id f10-20020a056a001aca00b0052f55f8c3ecmr17343043pfv.25.1660586197377;
        Mon, 15 Aug 2022 10:56:37 -0700 (PDT)
Received: from C02G8BMUMD6R.bytedance.net (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b0016d6963cb12sm7299935plg.304.2022.08.15.10.56.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Aug 2022 10:56:36 -0700 (PDT)
Sender: Bobby Eshleman <bobbyeshleman@gmail.com>
From:   Bobby Eshleman <bobby.eshleman@gmail.com>
X-Google-Original-From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH 2/6] vsock: return errors other than -ENOMEM to socket
Date:   Mon, 15 Aug 2022 10:56:05 -0700
Message-Id: <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1660362668.git.bobby.eshleman@bytedance.com>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit allows vsock implementations to return errors
to the socket layer other than -ENOMEM. One immediate effect
of this is that upon the sk_sndbuf threshold being reached -EAGAIN
will be returned and userspace may throttle appropriately.

Resultingly, a known issue with uperf is resolved[1].

Additionally, to preserve legacy behavior for non-virtio
implementations, hyperv/vmci force errors to be -ENOMEM so that behavior
is unchanged.

[1]: https://gitlab.com/vsock/vsock/-/issues/1

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 include/linux/virtio_vsock.h            | 3 +++
 net/vmw_vsock/af_vsock.c                | 3 ++-
 net/vmw_vsock/hyperv_transport.c        | 2 +-
 net/vmw_vsock/virtio_transport_common.c | 3 ---
 net/vmw_vsock/vmci_transport.c          | 9 ++++++++-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 17ed01466875..9a37eddbb87a 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -8,6 +8,9 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 
+/* Threshold for detecting small packets to copy */
+#define GOOD_COPY_LEN  128
+
 enum virtio_vsock_metadata_flags {
 	VIRTIO_VSOCK_METADATA_FLAGS_REPLY		= BIT(0),
 	VIRTIO_VSOCK_METADATA_FLAGS_TAP_DELIVERED	= BIT(1),
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index e348b2d09eac..1893f8aafa48 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1844,8 +1844,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 			written = transport->stream_enqueue(vsk,
 					msg, len - total_written);
 		}
+
 		if (written < 0) {
-			err = -ENOMEM;
+			err = written;
 			goto out_err;
 		}
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index fd98229e3db3..e99aea571f6f 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -687,7 +687,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
 	if (bytes_written)
 		ret = bytes_written;
 	kfree(send_buf);
-	return ret;
+	return ret < 0 ? -ENOMEM : ret;
 }
 
 static s64 hvs_stream_has_data(struct vsock_sock *vsk)
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 920578597bb9..d5780599fe93 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -23,9 +23,6 @@
 /* How long to wait for graceful shutdown of a connection */
 #define VSOCK_CLOSE_TIMEOUT (8 * HZ)
 
-/* Threshold for detecting small packets to copy */
-#define GOOD_COPY_LEN  128
-
 static const struct virtio_transport *
 virtio_transport_get_ops(struct vsock_sock *vsk)
 {
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b14f0ed7427b..c927a90dc859 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1838,7 +1838,14 @@ static ssize_t vmci_transport_stream_enqueue(
 	struct msghdr *msg,
 	size_t len)
 {
-	return vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
+	int err;
+
+	err = vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
+
+	if (err < 0)
+		err = -ENOMEM;
+
+	return err;
 }
 
 static s64 vmci_transport_stream_has_data(struct vsock_sock *vsk)
-- 
2.35.1

