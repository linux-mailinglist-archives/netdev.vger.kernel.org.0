Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE349305F37
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343711AbhA0PNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:13:11 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40047 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235751AbhA0PG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:06:27 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 892995C00CF;
        Wed, 27 Jan 2021 10:05:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 27 Jan 2021 10:05:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=NZ/BL+CX8ZrUPwXj4Uh/86z40F
        CVpFJbpqPIuN9jSec=; b=atQgHX2qSgfP06U5kuFU7gTfr/kLpf5lCsCIareSSO
        uNn+nnfsY/ohOStNFDVfX+lqvJmgj/5t1D81GtsJ72dYwVtwu6x8Y2ZJGXle29uw
        NEQuGlaZz0ByWg7OQW+I5RMwnlDYaMedZlGQkxvoykWTBIpZfUS1LPxI/e8taCrD
        g4pzSY/YPEoiMvpNPLpxVaEx72d1Xm5VPSxbGLUkNLEjTy41aNUIyIzgyUOMU8jN
        VdvQVmrO6ajbPedslhd6LzSoMU8Bj30/pyamRPlfBxr2XIwzA6Gh5kd2b7h8Fcno
        5IdCB2jFYqtZGcnAwv/fTNwjfNz/Z+8HaSapg6MfotUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NZ/BL+CX8ZrUPwXj4
        Uh/86z40FCVpFJbpqPIuN9jSec=; b=o2b1WHHivF88bjoSUXLVS9NQGPOZzAEMN
        DsA+lSWD1Lat7D2sA5TGROZadoWRBXNw+i3ObTPiD3JeaRgIa+50BVqFgrskL0qg
        aJao/AANLn4pU1t9lkD3BSaPnPbpsLh1xWuaUiK9RNxhSzzlN3ktSalzRh/UvlIX
        AptkpWvrkP0A1JLVxwjCx44oxSR6xc8OTm0+1wz2BacI2my17j00EVKA8+qYLLWl
        xW4MzM7ipsppbomdN3KW8bYkDKp/1cDqO3c81/35nr1s+H0W3V/XG4SQls0LVhD2
        orFE5lYZOaMF0iteBj4PpExXfNIMAM3z8NQ1NqUmq9oJC2Sb3p0Bg==
X-ME-Sender: <xms:PYERYOPOtb6_NVTq2pkNxQ4IS0TWpKNXFr1j15WBT0wJ7q3TkN2VeQ>
    <xme:PYERYEYAX9D32Tj-GYlCTnN6eeQXKTodQbvMHVSgJj9UEjHGZ9Hz4niTSxvV135k3
    KZ3vKNCbY79ogFQ8Ds>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefvohhmohihuhhkihcuofgrthhsuhhshhhithgruceogihorhhphhhi
    thhushesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeetgeffuefghe
    fftedvtefgjeejjeelhedtfeekveejtedtkedvhfelfedvieeugeenucfkphepuddtfedr
    vddrvdegledrudduleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpeigohhrphhhihhtuhhssehfrghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:PYERYCoKuDuUnF2io7Zrml9W4cqA445jyBjQuNxAeNyzZLYNtj_EUA>
    <xmx:PYERYIaTAHqVQvE5pd69GdF1nnYqyQX2gjkR0aCr9jwBck6x8fnWkA>
    <xmx:PYERYKSvshS-IiTxT0tA_TLTO1FXxDRJvA4l8Q4I4AcVdyixqKl_YA>
    <xmx:PoERYA78B2AX3kVB0CNgvghBlgYKxVBDSgPoCOfA4lahqw5OR7azag>
Received: from xorphitus-arch.flets-east.jp (119.249.2.103.shared.user.transix.jp [103.2.249.119])
        by mail.messagingengine.com (Postfix) with ESMTPA id D308B1080067;
        Wed, 27 Jan 2021 10:05:31 -0500 (EST)
From:   Tomoyuki Matsushita <xorphitus@fastmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Tomoyuki Matsushita <xorphitus@fastmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: af_bluetooth: checkpatch: fix indentation and alignment
Date:   Thu, 28 Jan 2021 00:05:20 +0900
Message-Id: <20210127150520.3459346-1-xorphitus@fastmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Tomoyuki Matsushita <xorphitus@fastmail.com>
---
 net/bluetooth/af_bluetooth.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 4ef6a54403aa..968ea03d863f 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -72,8 +72,8 @@ void bt_sock_reclassify_lock(struct sock *sk, int proto)
 	BUG_ON(!sock_allow_reclassification(sk));
 
 	sock_lock_init_class_and_name(sk,
-			bt_slock_key_strings[proto], &bt_slock_key[proto],
-				bt_key_strings[proto], &bt_lock_key[proto]);
+				      bt_slock_key_strings[proto], &bt_slock_key[proto],
+				      bt_key_strings[proto], &bt_lock_key[proto]);
 }
 EXPORT_SYMBOL(bt_sock_reclassify_lock);
 
@@ -451,7 +451,7 @@ static inline __poll_t bt_accept_poll(struct sock *parent)
 }
 
 __poll_t bt_sock_poll(struct file *file, struct socket *sock,
-			  poll_table *wait)
+		      poll_table *wait)
 {
 	struct sock *sk = sock->sk;
 	__poll_t mask = 0;
@@ -478,7 +478,7 @@ __poll_t bt_sock_poll(struct file *file, struct socket *sock,
 		mask |= EPOLLHUP;
 
 	if (sk->sk_state == BT_CONNECT ||
-			sk->sk_state == BT_CONNECT2 ||
+	    sk->sk_state == BT_CONNECT2 ||
 			sk->sk_state == BT_CONFIG)
 		return mask;
 
@@ -508,7 +508,7 @@ int bt_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
 		if (amount < 0)
 			amount = 0;
-		err = put_user(amount, (int __user *) arg);
+		err = put_user(amount, (int __user *)arg);
 		break;
 
 	case TIOCINQ:
@@ -519,7 +519,7 @@ int bt_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		skb = skb_peek(&sk->sk_receive_queue);
 		amount = skb ? skb->len : 0;
 		release_sock(sk);
-		err = put_user(amount, (int __user *) arg);
+		err = put_user(amount, (int __user *)arg);
 		break;
 
 	default:
@@ -637,7 +637,7 @@ static int bt_seq_show(struct seq_file *seq, void *v)
 	struct bt_sock_list *l = PDE_DATA(file_inode(seq->file));
 
 	if (v == SEQ_START_TOKEN) {
-		seq_puts(seq ,"sk               RefCnt Rmem   Wmem   User   Inode  Parent");
+		seq_puts(seq, "sk               RefCnt Rmem   Wmem   User   Inode  Parent");
 
 		if (l->custom_seq_show) {
 			seq_putc(seq, ' ');
@@ -657,7 +657,7 @@ static int bt_seq_show(struct seq_file *seq, void *v)
 			   sk_wmem_alloc_get(sk),
 			   from_kuid(seq_user_ns(seq), sock_i_uid(sk)),
 			   sock_i_ino(sk),
-			   bt->parent? sock_i_ino(bt->parent): 0LU);
+			   bt->parent ? sock_i_ino(bt->parent) : 0LU);
 
 		if (l->custom_seq_show) {
 			seq_putc(seq, ' ');
@@ -678,7 +678,7 @@ static const struct seq_operations bt_seq_ops = {
 
 int bt_procfs_init(struct net *net, const char *name,
 		   struct bt_sock_list *sk_list,
-		   int (* seq_show)(struct seq_file *, void *))
+		   int (*seq_show)(struct seq_file *, void *))
 {
 	sk_list->custom_seq_show = seq_show;
 
@@ -694,7 +694,7 @@ void bt_procfs_cleanup(struct net *net, const char *name)
 #else
 int bt_procfs_init(struct net *net, const char *name,
 		   struct bt_sock_list *sk_list,
-		   int (* seq_show)(struct seq_file *, void *))
+		   int (*seq_show)(struct seq_file *, void *))
 {
 	return 0;
 }
-- 
2.30.0

