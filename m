Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C018BDBC56
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395281AbfJRFDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:03:00 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42873 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfJRFDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:03:00 -0400
Received: by mail-pl1-f196.google.com with SMTP id g9so936454plj.9;
        Thu, 17 Oct 2019 22:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GTOf/Ta9mLCx6uCsjSPuiUUWC38JnQfNI985qroQXjw=;
        b=kcjYXQQlaQbCtc9Ciikf6XULMEJAJ5vFb3gdSRzCeMwK4sYZNGGMT6i9FVjCdRumUS
         9l/uXXJxVZhHtgK2kgbrID2AQZ6dTNwTXSVBjPvMysVOzLgF6j/mnRt/KlkwxE7k+wbB
         Rz0WSP6WH9A/0Hkt0rNwDgwFyIIi3UKP6Le5mlpQfKCLYiJXbGnQme9MKnoRc+/oeSUB
         SUvajNx3msTLiP+HC9r5It8QE7q8wOLfTGKQKBzhLkahKfWwq8Ko3Z1QeTidZfMz9UPQ
         ucAcoyxh1UoLrH8aeJWc17hStbrljqQRU2BCFmgC90trSSW7RLmRfaYt0XV8WjQev1Fs
         ZpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GTOf/Ta9mLCx6uCsjSPuiUUWC38JnQfNI985qroQXjw=;
        b=G/y/uiWeOa8nYzj7B+77tzktGyH4DYvl3OVFhQCjoPZVnTvNc5ZrcIFBKxZQiJNhln
         cdTfOlDEej2Jlem59Qpo72uzVudee/ny7XYWkZufJHLSWUQQe6qNaHnsy0wf5wTUjzyQ
         XAZC7Kwv/K6lnjHYPeE/ypfHlGhx6CKhq4dbTlJIyOSAz9aCh1AkUo35TUhGN5d+bNza
         a5Ah/pD4Pr+lO7zQvC6Gjq3cN+shtWwk7OEKjd/I286z9Bm9fRI8F/T+AtqWbss1fElF
         y/qbf+7oHLcUOQNPlnamVRDsMotbI5cBeEnyhLAsxlkVx9VKZdr9xRpHtr25lmU7pEW6
         T3ig==
X-Gm-Message-State: APjAAAXi24xQWlHCa3i7un1KiCs30MLjvt5lWCfTUZjsHzm45CYJIQHn
        YQAh2nRHIwS4ZmkooCSaZKam9sUp
X-Google-Smtp-Source: APXvYqzCnHVgLSTfgaH3su/NNJ8g5y3hs5HySo+Msq15O4by3957SYjgWIFsILAOq3Dc3I9+RrkVEA==
X-Received: by 2002:a17:902:8d8e:: with SMTP id v14mr7619205plo.287.1571371722117;
        Thu, 17 Oct 2019 21:08:42 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:08:41 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [RFC PATCH v2 bpf-next 04/15] xdp: Export dev_check_xdp and dev_change_xdp
Date:   Fri, 18 Oct 2019 13:07:37 +0900
Message-Id: <20191018040748.30593-5-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out the check and change logic from dev_change_xdp_fd(),
and export them for the following commit.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 include/linux/netdevice.h |   4 ++
 net/core/dev.c            | 111 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 95 insertions(+), 20 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3207e0b..c338a73 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3707,6 +3707,10 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
+int dev_check_xdp(struct net_device *dev, struct netlink_ext_ack *extack,
+		  bool do_install, u32 *prog_id_p, u32 flags);
+int dev_change_xdp(struct net_device *dev, struct netlink_ext_ack *extack,
+		   struct bpf_prog *prod, u32 flags);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, u32 flags);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
diff --git a/net/core/dev.c b/net/core/dev.c
index 8bc3dce..9965675 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8317,23 +8317,24 @@ static void dev_xdp_uninstall(struct net_device *dev)
 }
 
 /**
- *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
+ *	dev_check_xdp - check if xdp prog can be [un]installed
  *	@dev: device
  *	@extack: netlink extended ack
- *	@fd: new program fd or negative value to clear
+ *	@install: flag to install or uninstall
+ *	@prog_id_p: pointer to a storage for program id
  *	@flags: xdp-related flags
  *
- *	Set or clear a bpf program for a device
+ *	Check if xdp prog can be [un]installed
+ *	If a program is already loaded, store the prog id to prog_id_p
  */
-int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags)
+int dev_check_xdp(struct net_device *dev, struct netlink_ext_ack *extack,
+		  bool install, u32 *prog_id_p, u32 flags)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	enum bpf_netdev_command query;
-	struct bpf_prog *prog = NULL;
 	bpf_op_t bpf_op, bpf_chk;
 	bool offload;
-	int err;
+	u32 prog_id;
 
 	ASSERT_RTNL();
 
@@ -8350,28 +8351,64 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	if (bpf_op == bpf_chk)
 		bpf_chk = generic_xdp_install;
 
-	if (fd >= 0) {
-		u32 prog_id;
-
+	if (install) {
 		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
 
 		prog_id = __dev_xdp_query(dev, bpf_op, query);
+		if (prog_id_p)
+			*prog_id_p = prog_id;
 		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && prog_id) {
 			NL_SET_ERR_MSG(extack, "XDP program already attached");
 			return -EBUSY;
 		}
+	} else {
+		prog_id = __dev_xdp_query(dev, bpf_op, query);
+		if (prog_id_p)
+			*prog_id_p = prog_id;
+		if (!prog_id)
+			return -ENOENT;
+	}
 
-		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
-					     bpf_op == ops->ndo_bpf);
-		if (IS_ERR(prog))
-			return PTR_ERR(prog);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dev_check_xdp);
+
+/**
+ *	dev_change_xdp - set or clear a bpf program for a device rx path
+ *	@dev: device
+ *	@extack: netlink extended ack
+ *	@prog: bpf progam
+ *	@flags: xdp-related flags
+ *
+ *	Set or clear a bpf program for a device.
+ *	Caller must call dev_check_xdp before calling this function to
+ *	check if xdp prog can be [un]installed.
+ */
+int dev_change_xdp(struct net_device *dev, struct netlink_ext_ack *extack,
+		   struct bpf_prog *prog, u32 flags)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	enum bpf_netdev_command query;
+	bpf_op_t bpf_op;
+	bool offload;
+
+	ASSERT_RTNL();
+
+	offload = flags & XDP_FLAGS_HW_MODE;
+	query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
+
+	bpf_op = ops->ndo_bpf;
+	if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
+		bpf_op = generic_xdp_install;
+
+	if (prog) {
+		u32 prog_id = __dev_xdp_query(dev, bpf_op, query);
 
 		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
 			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE flag is not supported");
-			bpf_prog_put(prog);
 			return -EINVAL;
 		}
 
@@ -8379,13 +8416,47 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			bpf_prog_put(prog);
 			return 0;
 		}
-	} else {
-		if (!__dev_xdp_query(dev, bpf_op, query))
-			return 0;
 	}
 
-	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
-	if (err < 0 && prog)
+	return dev_xdp_install(dev, bpf_op, extack, flags, prog);
+}
+EXPORT_SYMBOL_GPL(dev_change_xdp);
+
+/**
+ *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
+ *	@dev: device
+ *	@extack: netlink extended ack
+ *	@fd: new program fd or negative value to clear
+ *	@flags: xdp-related flags
+ *
+ *	Set or clear a bpf program for a device
+ */
+int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
+		      int fd, u32 flags)
+{
+	struct bpf_prog *prog = NULL;
+	bool install = fd >= 0;
+	int err;
+
+	err = dev_check_xdp(dev, extack, install, NULL, flags);
+	if (err) {
+		if (!install && err == -ENOENT)
+			err = 0;
+		return err;
+	}
+
+	if (install) {
+		bool attach_drv;
+
+		attach_drv = dev->netdev_ops->ndo_bpf &&
+			     !(flags & XDP_FLAGS_SKB_MODE);
+		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, attach_drv);
+		if (IS_ERR(prog))
+			return PTR_ERR(prog);
+	}
+
+	err = dev_change_xdp(dev, extack, prog, flags);
+	if (err && prog)
 		bpf_prog_put(prog);
 
 	return err;
-- 
1.8.3.1

