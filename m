Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7902D399BE2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhFCHqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:46:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7082 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhFCHqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:46:17 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FwdBd08WJzYqPp;
        Thu,  3 Jun 2021 15:41:45 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 15:44:14 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 15:44:14 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH v3 04/12] Bluetooth: rfcomm: Use the correct print format
Date:   Thu, 3 Jun 2021 15:40:57 +0800
Message-ID: <1622706065-45409-5-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622706065-45409-1-git-send-email-yekai13@huawei.com>
References: <1622706065-45409-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Documentation/core-api/printk-formats.rst,
Use the correct print format. Printing an unsigned int value should use %u
instead of %d. Otherwise printk() might end up displaying negative numbers.
And fix the correct local variables type that been used.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 net/bluetooth/rfcomm/core.c | 68 ++++++++++++++++++++++-----------------------
 net/bluetooth/rfcomm/sock.c |  8 +++---
 net/bluetooth/rfcomm/tty.c  | 10 +++----
 3 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index f2bacb4..eec8fdc 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -338,7 +338,7 @@ static void rfcomm_dlc_unlink(struct rfcomm_dlc *d)
 {
 	struct rfcomm_session *s = d->session;
 
-	BT_DBG("dlc %p refcnt %d session %p", d, refcount_read(&d->refcnt), s);
+	BT_DBG("dlc %p refcnt %u session %p", d, refcount_read(&d->refcnt), s);
 
 	list_del(&d->list);
 	d->session = NULL;
@@ -370,7 +370,7 @@ static int __rfcomm_dlc_open(struct rfcomm_dlc *d, bdaddr_t *src, bdaddr_t *dst,
 	int err = 0;
 	u8 dlci;
 
-	BT_DBG("dlc %p state %ld %pMR -> %pMR channel %d",
+	BT_DBG("dlc %p state %lu %pMR -> %pMR channel %u",
 	       d, d->state, src, dst, channel);
 
 	if (rfcomm_check_channel(channel))
@@ -450,8 +450,8 @@ static int __rfcomm_dlc_close(struct rfcomm_dlc *d, int err)
 	if (!s)
 		return 0;
 
-	BT_DBG("dlc %p state %ld dlci %d err %d session %p",
-			d, d->state, d->dlci, err, s);
+	BT_DBG("dlc %p state %lu dlci %u err %d session %p",
+	       d, d->state, d->dlci, err, s);
 
 	switch (d->state) {
 	case BT_CONNECT:
@@ -502,7 +502,7 @@ int rfcomm_dlc_close(struct rfcomm_dlc *d, int err)
 	struct rfcomm_dlc *d_list;
 	struct rfcomm_session *s, *s_list;
 
-	BT_DBG("dlc %p state %ld dlci %d err %d", d, d->state, d->dlci, err);
+	BT_DBG("dlc %p state %lu dlci %u err %d", d, d->state, d->dlci, err);
 
 	rfcomm_lock();
 
@@ -551,12 +551,12 @@ struct rfcomm_dlc *rfcomm_dlc_exists(bdaddr_t *src, bdaddr_t *dst, u8 channel)
 
 int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
-	int len = skb->len;
+	unsigned int len = skb->len;
 
 	if (d->state != BT_CONNECTED)
 		return -ENOTCONN;
 
-	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
+	BT_DBG("dlc %p mtu %u len %u", d, d->mtu, len);
 
 	if (len > d->mtu)
 		return -EINVAL;
@@ -571,9 +571,9 @@ int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 
 void rfcomm_dlc_send_noerror(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
-	int len = skb->len;
+	unsigned int len = skb->len;
 
-	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
+	BT_DBG("dlc %p mtu %u len %u", d, d->mtu, len);
 
 	rfcomm_make_uih(skb, d->addr);
 	skb_queue_tail(&d->tx_queue, skb);
@@ -826,7 +826,7 @@ static int rfcomm_send_ua(struct rfcomm_session *s, u8 dlci)
 {
 	struct rfcomm_cmd cmd;
 
-	BT_DBG("%p dlci %d", s, dlci);
+	BT_DBG("%p dlci %u", s, dlci);
 
 	cmd.addr = __addr(!s->initiator, dlci);
 	cmd.ctrl = __ctrl(RFCOMM_UA, 1);
@@ -840,7 +840,7 @@ static int rfcomm_send_disc(struct rfcomm_session *s, u8 dlci)
 {
 	struct rfcomm_cmd cmd;
 
-	BT_DBG("%p dlci %d", s, dlci);
+	BT_DBG("%p dlci %u", s, dlci);
 
 	cmd.addr = __addr(s->initiator, dlci);
 	cmd.ctrl = __ctrl(RFCOMM_DISC, 1);
@@ -855,7 +855,7 @@ static int rfcomm_queue_disc(struct rfcomm_dlc *d)
 	struct rfcomm_cmd *cmd;
 	struct sk_buff *skb;
 
-	BT_DBG("dlc %p dlci %d", d, d->dlci);
+	BT_DBG("dlc %p dlci %u", d, d->dlci);
 
 	skb = alloc_skb(sizeof(*cmd), GFP_KERNEL);
 	if (!skb)
@@ -876,7 +876,7 @@ static int rfcomm_send_dm(struct rfcomm_session *s, u8 dlci)
 {
 	struct rfcomm_cmd cmd;
 
-	BT_DBG("%p dlci %d", s, dlci);
+	BT_DBG("%p dlci %u", s, dlci);
 
 	cmd.addr = __addr(!s->initiator, dlci);
 	cmd.ctrl = __ctrl(RFCOMM_DM, 1);
@@ -892,7 +892,7 @@ static int rfcomm_send_nsc(struct rfcomm_session *s, int cr, u8 type)
 	struct rfcomm_mcc *mcc;
 	u8 buf[16], *ptr = buf;
 
-	BT_DBG("%p cr %d type %d", s, cr, type);
+	BT_DBG("%p cr %d type %u", s, cr, type);
 
 	hdr = (void *) ptr; ptr += sizeof(*hdr);
 	hdr->addr = __addr(s->initiator, 0);
@@ -918,7 +918,7 @@ static int rfcomm_send_pn(struct rfcomm_session *s, int cr, struct rfcomm_dlc *d
 	struct rfcomm_pn  *pn;
 	u8 buf[16], *ptr = buf;
 
-	BT_DBG("%p cr %d dlci %d mtu %d", s, cr, d->dlci, d->mtu);
+	BT_DBG("%p cr %d dlci %u mtu %u", s, cr, d->dlci, d->mtu);
 
 	hdr = (void *) ptr; ptr += sizeof(*hdr);
 	hdr->addr = __addr(s->initiator, 0);
@@ -963,7 +963,7 @@ int rfcomm_send_rpn(struct rfcomm_session *s, int cr, u8 dlci,
 	struct rfcomm_rpn *rpn;
 	u8 buf[16], *ptr = buf;
 
-	BT_DBG("%p cr %d dlci %d bit_r 0x%x data_b 0x%x stop_b 0x%x parity 0x%x"
+	BT_DBG("%p cr %d dlci %u bit_r 0x%x data_b 0x%x stop_b 0x%x parity 0x%x"
 			" flwc_s 0x%x xon_c 0x%x xoff_c 0x%x p_mask 0x%x",
 		s, cr, dlci, bit_rate, data_bits, stop_bits, parity,
 		flow_ctrl_settings, xon_char, xoff_char, param_mask);
@@ -998,7 +998,7 @@ static int rfcomm_send_rls(struct rfcomm_session *s, int cr, u8 dlci, u8 status)
 	struct rfcomm_rls *rls;
 	u8 buf[16], *ptr = buf;
 
-	BT_DBG("%p cr %d status 0x%x", s, cr, status);
+	BT_DBG("%p cr %u status 0x%x", s, cr, status);
 
 	hdr = (void *) ptr; ptr += sizeof(*hdr);
 	hdr->addr = __addr(s->initiator, 0);
@@ -1025,7 +1025,7 @@ static int rfcomm_send_msc(struct rfcomm_session *s, int cr, u8 dlci, u8 v24_sig
 	struct rfcomm_msc *msc;
 	u8 buf[16], *ptr = buf;
 
-	BT_DBG("%p cr %d v24 0x%x", s, cr, v24_sig);
+	BT_DBG("%p cr %u v24 0x%x", s, cr, v24_sig);
 
 	hdr = (void *) ptr; ptr += sizeof(*hdr);
 	hdr->addr = __addr(s->initiator, 0);
@@ -1126,7 +1126,7 @@ static int rfcomm_send_credits(struct rfcomm_session *s, u8 addr, u8 credits)
 	struct rfcomm_hdr *hdr;
 	u8 buf[16], *ptr = buf;
 
-	BT_DBG("%p addr %d credits %d", s, addr, credits);
+	BT_DBG("%p addr %u credits %u", s, addr, credits);
 
 	hdr = (void *) ptr; ptr += sizeof(*hdr);
 	hdr->addr = addr;
@@ -1163,7 +1163,7 @@ static void rfcomm_make_uih(struct sk_buff *skb, u8 addr)
 /* ---- RFCOMM frame reception ---- */
 static struct rfcomm_session *rfcomm_recv_ua(struct rfcomm_session *s, u8 dlci)
 {
-	BT_DBG("session %p state %ld dlci %d", s, s->state, dlci);
+	BT_DBG("session %p state %ld dlci %u", s, s->state, dlci);
 
 	if (dlci) {
 		/* Data channel */
@@ -1217,7 +1217,7 @@ static struct rfcomm_session *rfcomm_recv_dm(struct rfcomm_session *s, u8 dlci)
 {
 	int err = 0;
 
-	BT_DBG("session %p state %ld dlci %d", s, s->state, dlci);
+	BT_DBG("session %p state %ld dlci %u", s, s->state, dlci);
 
 	if (dlci) {
 		/* Data DLC */
@@ -1247,7 +1247,7 @@ static struct rfcomm_session *rfcomm_recv_disc(struct rfcomm_session *s,
 {
 	int err = 0;
 
-	BT_DBG("session %p state %ld dlci %d", s, s->state, dlci);
+	BT_DBG("session %p state %ld dlci %u", s, s->state, dlci);
 
 	if (dlci) {
 		struct rfcomm_dlc *d = rfcomm_dlc_get(s, dlci);
@@ -1323,7 +1323,7 @@ static int rfcomm_recv_sabm(struct rfcomm_session *s, u8 dlci)
 	struct rfcomm_dlc *d;
 	u8 channel;
 
-	BT_DBG("session %p state %ld dlci %d", s, s->state, dlci);
+	BT_DBG("session %p state %ld dlci %u", s, s->state, dlci);
 
 	if (!dlci) {
 		rfcomm_send_ua(s, 0);
@@ -1364,8 +1364,8 @@ static int rfcomm_apply_pn(struct rfcomm_dlc *d, int cr, struct rfcomm_pn *pn)
 {
 	struct rfcomm_session *s = d->session;
 
-	BT_DBG("dlc %p state %ld dlci %d mtu %d fc 0x%x credits %d",
-			d, d->state, d->dlci, pn->mtu, pn->flow_ctrl, pn->credits);
+	BT_DBG("dlc %p state %lu dlci %u mtu %u fc 0x%x credits %u",
+	       d, d->state, d->dlci, pn->mtu, pn->flow_ctrl, pn->credits);
 
 	if ((pn->flow_ctrl == 0xf0 && s->cfc != RFCOMM_CFC_DISABLED) ||
 						pn->flow_ctrl == 0xe0) {
@@ -1395,7 +1395,7 @@ static int rfcomm_recv_pn(struct rfcomm_session *s, int cr, struct sk_buff *skb)
 	struct rfcomm_dlc *d;
 	u8 dlci = pn->dlci;
 
-	BT_DBG("session %p state %ld dlci %d", s, s->state, dlci);
+	BT_DBG("session %p state %lu dlci %u", s, s->state, dlci);
 
 	if (!dlci)
 		return 0;
@@ -1552,7 +1552,7 @@ static int rfcomm_recv_rls(struct rfcomm_session *s, int cr, struct sk_buff *skb
 	struct rfcomm_rls *rls = (void *) skb->data;
 	u8 dlci = __get_dlci(rls->dlci);
 
-	BT_DBG("dlci %d cr %d status 0x%x", dlci, cr, rls->status);
+	BT_DBG("dlci %u cr %d status 0x%x", dlci, cr, rls->status);
 
 	if (!cr)
 		return 0;
@@ -1572,7 +1572,7 @@ static int rfcomm_recv_msc(struct rfcomm_session *s, int cr, struct sk_buff *skb
 	struct rfcomm_dlc *d;
 	u8 dlci = __get_dlci(msc->dlci);
 
-	BT_DBG("dlci %d cr %d v24 0x%x", dlci, cr, msc->v24_sig);
+	BT_DBG("dlci %u cr %d v24 0x%x", dlci, cr, msc->v24_sig);
 
 	d = rfcomm_dlc_get(s, dlci);
 	if (!d)
@@ -1611,7 +1611,7 @@ static int rfcomm_recv_mcc(struct rfcomm_session *s, struct sk_buff *skb)
 	type = __get_mcc_type(mcc->type);
 	len  = __get_mcc_len(mcc->len);
 
-	BT_DBG("%p type 0x%x cr %d", s, type, cr);
+	BT_DBG("%p type 0x%x cr %u", s, type, cr);
 
 	skb_pull(skb, 2);
 
@@ -1666,7 +1666,7 @@ static int rfcomm_recv_data(struct rfcomm_session *s, u8 dlci, int pf, struct sk
 {
 	struct rfcomm_dlc *d;
 
-	BT_DBG("session %p state %ld dlci %d pf %d", s, s->state, dlci, pf);
+	BT_DBG("session %p state %lu dlci %u pf %d", s, s->state, dlci, pf);
 
 	d = rfcomm_dlc_get(s, dlci);
 	if (!d) {
@@ -1790,8 +1790,8 @@ static int rfcomm_process_tx(struct rfcomm_dlc *d)
 	struct sk_buff *skb;
 	int err;
 
-	BT_DBG("dlc %p state %ld cfc %d rx_credits %d tx_credits %d",
-			d, d->state, d->cfc, d->rx_credits, d->tx_credits);
+	BT_DBG("dlc %p state %lu cfc %u rx_credits %u tx_credits %u",
+	       d, d->state, d->cfc, d->rx_credits, d->tx_credits);
 
 	/* Send pending MSC */
 	if (test_and_clear_bit(RFCOMM_MSC_PENDING, &d->flags))
@@ -1896,7 +1896,7 @@ static struct rfcomm_session *rfcomm_process_rx(struct rfcomm_session *s)
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 
-	BT_DBG("session %p state %ld qlen %d", s, s->state, skb_queue_len(&sk->sk_receive_queue));
+	BT_DBG("session %p state %lu qlen %u", s, s->state, skb_queue_len(&sk->sk_receive_queue));
 
 	/* Get data directly from socket receive queue without copying it. */
 	while ((skb = skb_dequeue(&sk->sk_receive_queue))) {
@@ -2153,7 +2153,7 @@ static int rfcomm_dlc_debugfs_show(struct seq_file *f, void *x)
 		struct l2cap_chan *chan = l2cap_pi(s->sock->sk)->chan;
 		struct rfcomm_dlc *d;
 		list_for_each_entry(d, &s->dlcs, list) {
-			seq_printf(f, "%pMR %pMR %ld %d %d %d %d\n",
+			seq_printf(f, "%pMR %pMR %lu %u %u %u %u\n",
 				   &chan->src, &chan->dst,
 				   d->state, d->dlci, d->mtu,
 				   d->rx_credits, d->tx_credits);
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index ae6f807..4c4081e 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -194,7 +194,7 @@ static void rfcomm_sock_kill(struct sock *sk)
 	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
 		return;
 
-	BT_DBG("sk %p state %d refcnt %d", sk, sk->sk_state, refcount_read(&sk->sk_refcnt));
+	BT_DBG("sk %p state %d refcnt %u", sk, sk->sk_state, refcount_read(&sk->sk_refcnt));
 
 	/* Kill poor orphan */
 	bt_sock_unlink(&rfcomm_sk_list, sk);
@@ -965,7 +965,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 	bdaddr_t src, dst;
 	int result = 0;
 
-	BT_DBG("session %p channel %d", s, channel);
+	BT_DBG("session %p channel %u", s, channel);
 
 	rfcomm_session_getaddr(s, &src, &dst);
 
@@ -978,7 +978,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 
 	/* Check for backlog size */
 	if (sk_acceptq_is_full(parent)) {
-		BT_DBG("backlog full %d", parent->sk_ack_backlog);
+		BT_DBG("backlog full %u", parent->sk_ack_backlog);
 		goto done;
 	}
 
@@ -1016,7 +1016,7 @@ static int rfcomm_sock_debugfs_show(struct seq_file *f, void *p)
 	read_lock(&rfcomm_sk_list.lock);
 
 	sk_for_each(sk, &rfcomm_sk_list.head) {
-		seq_printf(f, "%pMR %pMR %d %d\n",
+		seq_printf(f, "%pMR %pMR %d %u\n",
 			   &rfcomm_pi(sk)->src, &rfcomm_pi(sk)->dst,
 			   sk->sk_state, rfcomm_pi(sk)->channel);
 	}
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index a585849..eeae373 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -207,7 +207,7 @@ static ssize_t show_address(struct device *tty_dev, struct device_attribute *att
 static ssize_t show_channel(struct device *tty_dev, struct device_attribute *attr, char *buf)
 {
 	struct rfcomm_dev *dev = dev_get_drvdata(tty_dev);
-	return sprintf(buf, "%d\n", dev->channel);
+	return sprintf(buf, "%u\n", dev->channel);
 }
 
 static DEVICE_ATTR(address, 0444, show_address, NULL);
@@ -319,7 +319,7 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 	struct rfcomm_dev *dev;
 	struct device *tty;
 
-	BT_DBG("id %d channel %d", req->dev_id, req->channel);
+	BT_DBG("id %d channel %u", req->dev_id, req->channel);
 
 	dev = __rfcomm_dev_add(req, dlc);
 	if (IS_ERR(dev)) {
@@ -579,7 +579,7 @@ static int rfcomm_get_dev_info(void __user *arg)
 
 int rfcomm_dev_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
 {
-	BT_DBG("cmd %d arg %p", cmd, arg);
+	BT_DBG("cmd %u arg %p", cmd, arg);
 
 	switch (cmd) {
 	case RFCOMMCREATEDEV:
@@ -613,7 +613,7 @@ static void rfcomm_dev_data_ready(struct rfcomm_dlc *dlc, struct sk_buff *skb)
 		return;
 	}
 
-	BT_DBG("dlc %p len %d", dlc, skb->len);
+	BT_DBG("dlc %p len %u", dlc, skb->len);
 
 	tty_insert_flip_string(&dev->port, skb->data, skb->len);
 	tty_flip_buffer_push(&dev->port);
@@ -749,7 +749,7 @@ static int rfcomm_tty_open(struct tty_struct *tty, struct file *filp)
 
 	BT_DBG("tty %p id %d", tty, tty->index);
 
-	BT_DBG("dev %p dst %pMR channel %d opened %d", dev, &dev->dst,
+	BT_DBG("dev %p dst %pMR channel %u opened %d", dev, &dev->dst,
 	       dev->channel, dev->port.count);
 
 	err = tty_port_open(&dev->port, tty, filp);
-- 
2.8.1

