Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBA55F80B0
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 00:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiJGWNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 18:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJGWNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 18:13:46 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B1AD73DF;
        Fri,  7 Oct 2022 15:13:44 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id a22so3739897qkk.7;
        Fri, 07 Oct 2022 15:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8LVMDbb8aoZZxQ9zLCn/yPHl/Bg9P8AXUaj0syiW8g=;
        b=GQcQ+4YzTA/6+j4pPQIqVfhFEv4ptOXNuAg+MZ0mHPMl7fp1xojwuN8kp1PM5L8bvT
         LjNCc0LXSQb4IIQP0Uq08w2p5SBmIv0YvaRYB73/uFbNwExv5zbdHNo0KOLsDLCiW+zR
         gYKHZeuLr2k1/80Z3zz9T/nqJ+ZQt98JjvJPcwjKdEg22ByK9y1GrXlcLiZp2TatjOZi
         iA3iEJkaVMXZ+EZsfSfkLyi2+XwXUgw6bGp+32wW4uL8uHAOL7Yc/3mSL9OQ1KTtvyc6
         1dL3KAqjpKpsSlah1gaAUFPhGR58LbnFs0+pi2S5RmlfP54ut8D9iZxvOgxiDT0Mjg4E
         VjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a8LVMDbb8aoZZxQ9zLCn/yPHl/Bg9P8AXUaj0syiW8g=;
        b=a/Rgzx+EvT0hrebW7RDMjS68RLRUyc41Kg7Qu28JM6N8X/MLX1Wv/JPNNRTJMN8uVe
         g62rtnGZsx95sh2xEquItI+3G8pJSEW9iUSpfxO0Yp50x7VZRmFv6b9kyS9AW/gk0vBC
         3A+2+B1t1PhAITtz1fYcboEEGPiUJTI+j/G+0h0PfHdbihp9OLkkQqBuCefwHNbxg0M7
         xQFhNn56/g7iMpB+I83Dyulw6Bq+biJ0Sc45vicCI+7ea8omM+HWKFSValzV+Odm0j+G
         M57JmLvvNpH0mYhKNpihkZU7uAtGcfUz9l58KC0IhaiRp/GoEgGXdZPV/QxySVmHsKUI
         rfNg==
X-Gm-Message-State: ACrzQf15n8c5Opb0JEqwh/1wWnJeBtbr3CFbocXMx6dGNsayxNCBBPMc
        gIqYTO+wqwTCfmNdg5CGbA==
X-Google-Smtp-Source: AMsMyM4LRDGSkQFS4eDWKWv3r8+C1+oMd/0gzsAEpQtCQR3i6rLLyd44PuQXjwBpVtoAL/jG8mG/7g==
X-Received: by 2002:a05:620a:254f:b0:6bc:5763:de4b with SMTP id s15-20020a05620a254f00b006bc5763de4bmr5189778qko.207.1665180823456;
        Fri, 07 Oct 2022 15:13:43 -0700 (PDT)
Received: from bytedance.attlocal.net ([130.44.212.155])
        by smtp.gmail.com with ESMTPSA id z22-20020ac84556000000b0031eddc83560sm2928905qtn.90.2022.10.07.15.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 15:13:42 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next v2] net/sock: Introduce trace_sk_data_ready()
Date:   Fri,  7 Oct 2022 15:10:38 -0700
Message-Id: <20221007221038.2345-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220928221514.27350-1-yepeilin.cs@gmail.com>
References: <20220928221514.27350-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
callback implementations.  For example:

<...>
  dpkg-deb-7752    [000] .....   145.660735: sk_data_ready: family=16 protocol=16 func=sock_def_readable
  dpkg-deb-7757    [000] .....   145.759168: sk_data_ready: family=16 protocol=16 func=sock_def_readable
  dpkg-deb-7758    [000] .....   145.763956: sk_data_ready: family=16 protocol=16 func=sock_def_readable
<...>

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
changes since v1:
  - Move tracepoint into ->sk_data_ready() callback implementations
    (Eric Dumazet)
  - Fix W=1 warning (Jakub Kicinski)

 drivers/infiniband/hw/erdma/erdma_cm.c   |  3 +++
 drivers/infiniband/sw/siw/siw_cm.c       |  5 +++++
 drivers/infiniband/sw/siw/siw_qp.c       |  3 +++
 drivers/nvme/host/tcp.c                  |  3 +++
 drivers/nvme/target/tcp.c                |  5 +++++
 drivers/scsi/iscsi_tcp.c                 |  3 +++
 drivers/soc/qcom/qmi_interface.c         |  3 +++
 drivers/target/iscsi/iscsi_target_nego.c |  2 ++
 drivers/xen/pvcalls-back.c               |  5 +++++
 fs/dlm/lowcomms.c                        |  5 +++++
 fs/ocfs2/cluster/tcp.c                   |  5 +++++
 include/trace/events/sock.h              | 24 ++++++++++++++++++++++++
 net/ceph/messenger.c                     |  4 ++++
 net/core/skmsg.c                         |  3 +++
 net/core/sock.c                          |  2 ++
 net/kcm/kcmsock.c                        |  3 +++
 net/mptcp/subflow.c                      |  3 +++
 net/qrtr/ns.c                            |  3 +++
 net/rds/tcp_listen.c                     |  2 ++
 net/rds/tcp_recv.c                       |  2 ++
 net/sctp/socket.c                        |  3 +++
 net/smc/smc_rx.c                         |  3 +++
 net/sunrpc/svcsock.c                     |  5 +++++
 net/sunrpc/xprtsock.c                    |  3 +++
 net/tipc/socket.c                        |  3 +++
 net/tipc/topsrv.c                        |  5 +++++
 net/tls/tls_sw.c                         |  3 +++
 net/xfrm/espintcp.c                      |  3 +++
 28 files changed, 116 insertions(+)

diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
index f13f16479eca..63f314222813 100644
--- a/drivers/infiniband/hw/erdma/erdma_cm.c
+++ b/drivers/infiniband/hw/erdma/erdma_cm.c
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <net/addrconf.h>
+#include <trace/events/sock.h>
 
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_verbs.h>
@@ -933,6 +934,8 @@ static void erdma_cm_llp_data_ready(struct sock *sk)
 {
 	struct erdma_cep *cep;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock(&sk->sk_callback_lock);
 
 	cep = sk_to_cep(sk);
diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index f88d2971c2c6..05c58f0f1e2d 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -16,6 +16,7 @@
 #include <net/tcp.h>
 #include <linux/inet.h>
 #include <linux/tcp.h>
+#include <trace/events/sock.h>
 
 #include <rdma/iw_cm.h>
 #include <rdma/ib_verbs.h>
@@ -109,6 +110,8 @@ static void siw_rtr_data_ready(struct sock *sk)
 	struct siw_qp *qp = NULL;
 	read_descriptor_t rd_desc;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock(&sk->sk_callback_lock);
 
 	cep = sk_to_cep(sk);
@@ -1216,6 +1219,8 @@ static void siw_cm_llp_data_ready(struct sock *sk)
 {
 	struct siw_cep *cep;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock(&sk->sk_callback_lock);
 
 	cep = sk_to_cep(sk);
diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
index 7e01f2438afc..f0710d346102 100644
--- a/drivers/infiniband/sw/siw/siw_qp.c
+++ b/drivers/infiniband/sw/siw/siw_qp.c
@@ -10,6 +10,7 @@
 #include <linux/llist.h>
 #include <asm/barrier.h>
 #include <net/tcp.h>
+#include <trace/events/sock.h>
 
 #include "siw.h"
 #include "siw_verbs.h"
@@ -94,6 +95,8 @@ void siw_qp_llp_data_ready(struct sock *sk)
 {
 	struct siw_qp *qp;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock(&sk->sk_callback_lock);
 
 	if (unlikely(!sk->sk_user_data || !sk_to_qp(sk)))
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index d5871fd6f769..a1cab344cc41 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -14,6 +14,7 @@
 #include <linux/blk-mq.h>
 #include <crypto/hash.h>
 #include <net/busy_poll.h>
+#include <trace/events/sock.h>
 
 #include "nvme.h"
 #include "fabrics.h"
@@ -906,6 +907,8 @@ static void nvme_tcp_data_ready(struct sock *sk)
 {
 	struct nvme_tcp_queue *queue;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock_bh(&sk->sk_callback_lock);
 	queue = sk->sk_user_data;
 	if (likely(queue && queue->rd_enabled) &&
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index a3694a32f6d5..bee3af922876 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -14,6 +14,7 @@
 #include <linux/inet.h>
 #include <linux/llist.h>
 #include <crypto/hash.h>
+#include <trace/events/sock.h>
 
 #include "nvmet.h"
 
@@ -1467,6 +1468,8 @@ static void nvmet_tcp_data_ready(struct sock *sk)
 {
 	struct nvmet_tcp_queue *queue;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock_bh(&sk->sk_callback_lock);
 	queue = sk->sk_user_data;
 	if (likely(queue))
@@ -1664,6 +1667,8 @@ static void nvmet_tcp_listen_data_ready(struct sock *sk)
 {
 	struct nvmet_tcp_port *port;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock_bh(&sk->sk_callback_lock);
 	port = sk->sk_user_data;
 	if (!port)
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 29b1bd755afe..5f9110d0578b 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -36,6 +36,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <trace/events/iscsi.h>
+#include <trace/events/sock.h>
 
 #include "iscsi_tcp.h"
 
@@ -170,6 +171,8 @@ static void iscsi_sw_tcp_data_ready(struct sock *sk)
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_conn *conn;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock_bh(&sk->sk_callback_lock);
 	conn = sk->sk_user_data;
 	if (!conn) {
diff --git a/drivers/soc/qcom/qmi_interface.c b/drivers/soc/qcom/qmi_interface.c
index c8c4c730b135..c5f441bf2198 100644
--- a/drivers/soc/qcom/qmi_interface.c
+++ b/drivers/soc/qcom/qmi_interface.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <net/sock.h>
 #include <linux/workqueue.h>
+#include <trace/events/sock.h>
 #include <linux/soc/qcom/qmi.h>
 
 static struct socket *qmi_sock_create(struct qmi_handle *qmi,
@@ -569,6 +570,8 @@ static void qmi_data_ready(struct sock *sk)
 {
 	struct qmi_handle *qmi = sk->sk_user_data;
 
+	trace_sk_data_ready(sk, __func__);
+
 	/*
 	 * This will be NULL if we receive data while being in
 	 * qmi_handle_release()
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index f2919319ad38..210788c80366 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/sched/signal.h>
 #include <net/sock.h>
+#include <trace/events/sock.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
@@ -384,6 +385,7 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
 	struct iscsit_conn *conn = sk->sk_user_data;
 	bool rc;
 
+	trace_sk_data_ready(sk, __func__);
 	pr_debug("Entering iscsi_target_sk_data_ready: conn: %p\n", conn);
 
 	write_lock_bh(&sk->sk_callback_lock);
diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index d6f945fd4147..6644f191a89c 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -14,6 +14,7 @@
 #include <net/inet_common.h>
 #include <net/inet_connection_sock.h>
 #include <net/request_sock.h>
+#include <trace/events/sock.h>
 
 #include <xen/events.h>
 #include <xen/grant_table.h>
@@ -300,6 +301,8 @@ static void pvcalls_sk_data_ready(struct sock *sock)
 	struct sock_mapping *map = sock->sk_user_data;
 	struct pvcalls_ioworker *iow;
 
+	trace_sk_data_ready(sock, __func__);
+
 	if (map == NULL)
 		return;
 
@@ -588,6 +591,8 @@ static void pvcalls_pass_sk_data_ready(struct sock *sock)
 	unsigned long flags;
 	int notify;
 
+	trace_sk_data_ready(sock, __func__);
+
 	if (mappass == NULL)
 		return;
 
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 59f64c596233..e79c4bab121d 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -54,6 +54,7 @@
 #include <net/ipv6.h>
 
 #include <trace/events/dlm.h>
+#include <trace/events/sock.h>
 
 #include "dlm_internal.h"
 #include "lowcomms.h"
@@ -507,6 +508,8 @@ static void lowcomms_data_ready(struct sock *sk)
 {
 	struct connection *con;
 
+	trace_sk_data_ready(sk, __func__);
+
 	con = sock2con(sk);
 	if (con && !test_and_set_bit(CF_READ_PENDING, &con->flags))
 		queue_work(recv_workqueue, &con->rwork);
@@ -514,6 +517,8 @@ static void lowcomms_data_ready(struct sock *sk)
 
 static void lowcomms_listen_data_ready(struct sock *sk)
 {
+	trace_sk_data_ready(sk, __func__);
+
 	if (!dlm_allow_conn)
 		return;
 
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index f660c0dbdb63..464142e8908a 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -46,6 +46,7 @@
 #include <linux/net.h>
 #include <linux/export.h>
 #include <net/tcp.h>
+#include <trace/events/sock.h>
 
 #include <linux/uaccess.h>
 
@@ -585,6 +586,8 @@ static void o2net_data_ready(struct sock *sk)
 	void (*ready)(struct sock *sk);
 	struct o2net_sock_container *sc;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock_bh(&sk->sk_callback_lock);
 	sc = sk->sk_user_data;
 	if (sc) {
@@ -645,6 +648,8 @@ static void o2net_state_change(struct sock *sk)
 static void o2net_register_callbacks(struct sock *sk,
 				     struct o2net_sock_container *sc)
 {
+	trace_sk_data_ready(sk, __func__);
+
 	write_lock_bh(&sk->sk_callback_lock);
 
 	/* accepted sockets inherit the old listen socket data ready */
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 777ee6cbe933..4d373e26d897 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -263,6 +263,30 @@ TRACE_EVENT(inet_sk_error_report,
 		  __entry->error)
 );
 
+TRACE_EVENT(sk_data_ready,
+
+	TP_PROTO(const struct sock *sk, const char *func),
+
+	TP_ARGS(sk, func),
+
+	TP_STRUCT__entry(
+		__field(const void *, skaddr)
+		__field(__u16, family)
+		__field(__u16, protocol)
+		__string(func, func)
+	),
+
+	TP_fast_assign(
+		__entry->skaddr = sk;
+		__entry->family = sk->sk_family;
+		__entry->protocol = sk->sk_protocol;
+		__assign_str(func, func)
+	),
+
+	TP_printk("family=%u protocol=%u func=%s",
+		  __entry->family, __entry->protocol, __get_str(func))
+);
+
 #endif /* _TRACE_SOCK_H */
 
 /* This part must be outside protection */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d3bb656308b4..835bf9c8e3bc 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -17,6 +17,7 @@
 #endif	/* CONFIG_BLOCK */
 #include <linux/dns_resolver.h>
 #include <net/tcp.h>
+#include <trace/events/sock.h>
 
 #include <linux/ceph/ceph_features.h>
 #include <linux/ceph/libceph.h>
@@ -344,6 +345,9 @@ static void con_sock_state_closed(struct ceph_connection *con)
 static void ceph_sock_data_ready(struct sock *sk)
 {
 	struct ceph_connection *con = sk->sk_user_data;
+
+	trace_sk_data_ready(sk, __func__);
+
 	if (atomic_read(&con->msgr->stopping)) {
 		return;
 	}
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ca70525621c7..58e25ae451d7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -8,6 +8,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <net/tls.h>
+#include <trace/events/sock.h>
 
 static bool sk_msg_try_coalesce_ok(struct sk_msg *msg, int elem_first_coalesce)
 {
@@ -1210,6 +1211,8 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
 
+	trace_sk_data_ready(sk, __func__);
+
 	if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
 		return;
 	sock->ops->read_skb(sk, sk_psock_verdict_recv);
diff --git a/net/core/sock.c b/net/core/sock.c
index eeb6cbac6f49..0a25dcecdd5b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3269,6 +3269,8 @@ void sock_def_readable(struct sock *sk)
 {
 	struct socket_wq *wq;
 
+	trace_sk_data_ready(sk, __func__);
+
 	rcu_read_lock();
 	wq = rcu_dereference(sk->sk_wq);
 	if (skwq_has_sleeper(wq))
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 1215c863e1c4..dac5c67ef312 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -28,6 +28,7 @@
 #include <net/netns/generic.h>
 #include <net/sock.h>
 #include <uapi/linux/kcm.h>
+#include <trace/events/sock.h>
 
 unsigned int kcm_net_id;
 
@@ -344,6 +345,8 @@ static void psock_data_ready(struct sock *sk)
 {
 	struct kcm_psock *psock;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock_bh(&sk->sk_callback_lock);
 
 	psock = (struct kcm_psock *)sk->sk_user_data;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 07dd23d0fe04..20ee6884f03e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -26,6 +26,7 @@
 #include "mib.h"
 
 #include <trace/events/mptcp.h>
+#include <trace/events/sock.h>
 
 static void mptcp_subflow_ops_undo_override(struct sock *ssk);
 
@@ -1349,6 +1350,8 @@ static void subflow_data_ready(struct sock *sk)
 	struct sock *parent = subflow->conn;
 	struct mptcp_sock *msk;
 
+	trace_sk_data_ready(sk, __func__);
+
 	msk = mptcp_sk(parent);
 	if (state & TCPF_LISTEN) {
 		/* MPJ subflow are removed from accept queue before reaching here,
diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 1990d496fcfc..eee6fc837621 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -12,6 +12,7 @@
 
 #include "qrtr.h"
 
+#include <trace/events/sock.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/qrtr.h>
 
@@ -752,6 +753,8 @@ static void qrtr_ns_worker(struct work_struct *work)
 
 static void qrtr_ns_data_ready(struct sock *sk)
 {
+	trace_sk_data_ready(sk, __func__);
+
 	queue_work(qrtr_ns.workqueue, &qrtr_ns.work);
 }
 
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 7edf2e69d3fe..e1a165816737 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -34,6 +34,7 @@
 #include <linux/gfp.h>
 #include <linux/in.h>
 #include <net/tcp.h>
+#include <trace/events/sock.h>
 
 #include "rds.h"
 #include "tcp.h"
@@ -234,6 +235,7 @@ void rds_tcp_listen_data_ready(struct sock *sk)
 {
 	void (*ready)(struct sock *sk);
 
+	trace_sk_data_ready(sk, __func__);
 	rdsdebug("listen data ready sk %p\n", sk);
 
 	read_lock_bh(&sk->sk_callback_lock);
diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index f4ee13da90c7..0c2efbfc3f32 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -33,6 +33,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <net/tcp.h>
+#include <trace/events/sock.h>
 
 #include "rds.h"
 #include "tcp.h"
@@ -309,6 +310,7 @@ void rds_tcp_data_ready(struct sock *sk)
 	struct rds_conn_path *cp;
 	struct rds_tcp_connection *tc;
 
+	trace_sk_data_ready(sk, __func__);
 	rdsdebug("data ready sk %p\n", sk);
 
 	read_lock_bh(&sk->sk_callback_lock);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 171f1a35d205..a76ffbe08c6d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -59,6 +59,7 @@
 #include <net/ipv6.h>
 #include <net/inet_common.h>
 #include <net/busy_poll.h>
+#include <trace/events/sock.h>
 
 #include <linux/socket.h> /* for sa_family_t */
 #include <linux/export.h>
@@ -9237,6 +9238,8 @@ void sctp_data_ready(struct sock *sk)
 {
 	struct socket_wq *wq;
 
+	trace_sk_data_ready(sk, __func__);
+
 	rcu_read_lock();
 	wq = rcu_dereference(sk->sk_wq);
 	if (skwq_has_sleeper(wq))
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 17c5aee7ee4f..da309723a8de 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -15,6 +15,7 @@
 #include <linux/sched/signal.h>
 
 #include <net/sock.h>
+#include <trace/events/sock.h>
 
 #include "smc.h"
 #include "smc_core.h"
@@ -31,6 +32,8 @@ static void smc_rx_wake_up(struct sock *sk)
 {
 	struct socket_wq *wq;
 
+	trace_sk_data_ready(sk, __func__);
+
 	/* derived from sock_def_readable() */
 	/* called already in smc_listen_work() */
 	rcu_read_lock();
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 2fc98fea59b4..eb767fd3545f 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -55,6 +55,7 @@
 #include <linux/sunrpc/stats.h>
 #include <linux/sunrpc/xprt.h>
 
+#include <trace/events/sock.h>
 #include <trace/events/sunrpc.h>
 
 #include "socklib.h"
@@ -310,6 +311,8 @@ static void svc_data_ready(struct sock *sk)
 {
 	struct svc_sock	*svsk = (struct svc_sock *)sk->sk_user_data;
 
+	trace_sk_data_ready(sk, __func__);
+
 	if (svsk) {
 		/* Refer to svc_setup_socket() for details. */
 		rmb();
@@ -687,6 +690,8 @@ static void svc_tcp_listen_data_ready(struct sock *sk)
 {
 	struct svc_sock	*svsk = (struct svc_sock *)sk->sk_user_data;
 
+	trace_sk_data_ready(sk, __func__);
+
 	if (svsk) {
 		/* Refer to svc_setup_socket() for details. */
 		rmb();
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e976007f4fd0..c2e06a4881d7 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -52,6 +52,7 @@
 #include <linux/uio.h>
 #include <linux/sched/mm.h>
 
+#include <trace/events/sock.h>
 #include <trace/events/sunrpc.h>
 
 #include "socklib.h"
@@ -1378,6 +1379,8 @@ static void xs_data_ready(struct sock *sk)
 {
 	struct rpc_xprt *xprt;
 
+	trace_sk_data_ready(sk, __func__);
+
 	xprt = xprt_from_sock(sk);
 	if (xprt != NULL) {
 		struct sock_xprt *transport = container_of(xprt,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index f1c3b8eb4b3d..14965b05a691 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -37,6 +37,7 @@
 
 #include <linux/rhashtable.h>
 #include <linux/sched/signal.h>
+#include <trace/events/sock.h>
 
 #include "core.h"
 #include "name_table.h"
@@ -2130,6 +2131,8 @@ static void tipc_data_ready(struct sock *sk)
 {
 	struct socket_wq *wq;
 
+	trace_sk_data_ready(sk, __func__);
+
 	rcu_read_lock();
 	wq = rcu_dereference(sk->sk_wq);
 	if (skwq_has_sleeper(wq))
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 5522865deae9..231bb704b455 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -43,6 +43,7 @@
 #include "bearer.h"
 #include <net/sock.h>
 #include <linux/module.h>
+#include <trace/events/sock.h>
 
 /* Number of messages to send before rescheduling */
 #define MAX_SEND_MSG_COUNT	25
@@ -437,6 +438,8 @@ static void tipc_conn_data_ready(struct sock *sk)
 {
 	struct tipc_conn *con;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock_bh(&sk->sk_callback_lock);
 	con = sk->sk_user_data;
 	if (connected(con)) {
@@ -487,6 +490,8 @@ static void tipc_topsrv_listener_data_ready(struct sock *sk)
 {
 	struct tipc_topsrv *srv;
 
+	trace_sk_data_ready(sk, __func__);
+
 	read_lock_bh(&sk->sk_callback_lock);
 	srv = sk->sk_user_data;
 	if (srv->listener)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 264cf367e265..412733bdb8db 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -43,6 +43,7 @@
 
 #include <net/strparser.h>
 #include <net/tls.h>
+#include <trace/events/sock.h>
 
 #include "tls.h"
 
@@ -2282,6 +2283,8 @@ static void tls_data_ready(struct sock *sk)
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct sk_psock *psock;
 
+	trace_sk_data_ready(sk, __func__);
+
 	tls_strp_data_ready(&ctx->strp);
 
 	psock = sk_psock_get(sk);
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 29a540dcb5a7..9f68fb7dab6c 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -6,6 +6,7 @@
 #include <net/espintcp.h>
 #include <linux/skmsg.h>
 #include <net/inet_common.h>
+#include <trace/events/sock.h>
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6_stubs.h>
 #endif
@@ -397,6 +398,8 @@ static void espintcp_data_ready(struct sock *sk)
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
+	trace_sk_data_ready(sk, __func__);
+
 	strp_data_ready(&ctx->strp);
 }
 
-- 
2.20.1

