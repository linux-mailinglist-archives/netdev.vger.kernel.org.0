Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693D1DBCBE
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391209AbfJRFNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:13:55 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45514 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbfJRFNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:13:55 -0400
Received: by mail-pl1-f193.google.com with SMTP id u12so2249789pls.12;
        Thu, 17 Oct 2019 22:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZAQePQ7/QLeSg6o7fSfTOlJs0MDCwCY0jzDB1HxnUcQ=;
        b=iCpOTOH9CYfmcmecB5Wh8gDJXCHxZoJ+w3WlbTojmcVz/s7aKXUzKW+iQ+ohveaxe0
         hMtHiiizZUjZwlXnlNQ70sdOe1t41XdEG70tbWk13YGqBnKu25HCcZLcIE7t+4TEL7SJ
         nNGh5WuQL66Cx5MXSNObE9eU748wZ7WcTbakilfHNyqqg5tvq/byNgi90vWHMt7sT4p4
         9ryqJmptlr0HXD98u/l4YYRNVWkbImS+fh7FbypBImSsUUVmgqZunZy4AgKmSFzEVyMm
         Y5f5P99zOOCzGvP4dbV0+grEJWCzEaTE2p0wX/NcZ1y/PdhdapSr+y8W7bM1l2Nu8IQD
         fk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZAQePQ7/QLeSg6o7fSfTOlJs0MDCwCY0jzDB1HxnUcQ=;
        b=sadyiA9CyTzOHNtLiIBGgkuTeyaHsRSlYCavit9ttXmiLztWj6QzdLz/5fvFiIs1/Y
         I/d2FjCt6apK9yBg26/glq+LCNRsjTFqtFsj/M2CofOMeEGJ6dGkMvuof1oZBMuQNnvV
         phCuzt8SSmMilckv2g9O77azH5hBecJeqRDO4yy0F6VT/MfNj3gmwU1wC1/5LFem376Y
         F6k9U6imvANnYrU2ZDbQun6ILC7wIWzLrMDsmFxemCAQIN48VBDc6w6ueP2VuCi+wFhW
         Aw3gf7MpGHvwdZ6LIGvlWFd1QiugIv+0KPO1N5+vXS7dyV6X8uTHvCuh70FDPoLyUtc2
         3pxQ==
X-Gm-Message-State: APjAAAXM6uVDJNh/JAc3tzvQFFB//QXAVJ9Bv1po3w2DTphr85pe4m3l
        Sg6W2kMs5Jq46tIRpVmklI9bIETd
X-Google-Smtp-Source: APXvYqwoMBLtFgL83xyAx7Sa5V55f25Tj7JBU8z9TKjXc9uRls3ZYbUiyyE2NOZHbmPmfK/+syX/sQ==
X-Received: by 2002:a17:902:d888:: with SMTP id b8mr7850950plz.259.1571371727060;
        Thu, 17 Oct 2019 21:08:47 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:08:46 -0700 (PDT)
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
Subject: [RFC PATCH v2 bpf-next 05/15] xdp_flow: Attach bpf prog to XDP in kernel after UMH loaded program
Date:   Fri, 18 Oct 2019 13:07:38 +0900
Message-Id: <20191018040748.30593-6-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As UMH runs under RTNL, it cannot attach XDP from userspace. Thus the
kernel, xdp_flow module, installs the XDP program.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/xdp_flow/xdp_flow_kern_mod.c | 109 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 103 insertions(+), 6 deletions(-)

diff --git a/net/xdp_flow/xdp_flow_kern_mod.c b/net/xdp_flow/xdp_flow_kern_mod.c
index 14e06ee..2c80590 100644
--- a/net/xdp_flow/xdp_flow_kern_mod.c
+++ b/net/xdp_flow/xdp_flow_kern_mod.c
@@ -3,10 +3,27 @@
 #include <linux/module.h>
 #include <linux/umh.h>
 #include <linux/sched/signal.h>
+#include <linux/rhashtable.h>
 #include <linux/rtnetlink.h>
+#include <linux/filter.h>
 #include "xdp_flow.h"
 #include "msgfmt.h"
 
+struct xdp_flow_prog {
+	struct rhash_head ht_node;
+	struct net_device *dev;
+	struct bpf_prog *prog;
+};
+
+static const struct rhashtable_params progs_params = {
+	.key_len = sizeof(struct net_devce *),
+	.key_offset = offsetof(struct xdp_flow_prog, dev),
+	.head_offset = offsetof(struct xdp_flow_prog, ht_node),
+	.automatic_shrinking = true,
+};
+
+static struct rhashtable progs;
+
 extern char xdp_flow_umh_start;
 extern char xdp_flow_umh_end;
 
@@ -116,10 +133,17 @@ static int xdp_flow_setup_block_cb(enum tc_setup_type type, void *type_data,
 static int xdp_flow_setup_bind(struct net_device *dev,
 			       struct netlink_ext_ack *extack)
 {
+	u32 flags = XDP_FLAGS_DRV_MODE | XDP_FLAGS_UPDATE_IF_NOEXIST;
+	struct xdp_flow_prog *prog_node;
 	struct mbox_request *req;
+	struct bpf_prog *prog;
 	u32 id = 0;
 	int err;
 
+	err = dev_check_xdp(dev, extack, true, NULL, flags);
+	if (err)
+		return err;
+
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
@@ -129,21 +153,83 @@ static int xdp_flow_setup_bind(struct net_device *dev,
 
 	/* Load bpf in UMH and get prog id */
 	err = transact_umh(req, &id);
+	if (err)
+		goto out;
+
+	prog = bpf_prog_get_type_dev_by_id(id, BPF_PROG_TYPE_XDP, true);
+	if (IS_ERR(prog)) {
+		err = PTR_ERR(prog);
+		goto err_umh;
+	}
 
-	/* TODO: id will be used to attach bpf prog to XDP
-	 * As we have rtnl_lock, UMH cannot attach prog to XDP
-	 */
+	err = dev_change_xdp(dev, extack, prog, flags);
+	if (err)
+		goto err_prog;
 
+	prog_node = kzalloc(sizeof(*prog_node), GFP_KERNEL);
+	if (!prog_node) {
+		err = -ENOMEM;
+		goto err_xdp;
+	}
+
+	prog_node->dev = dev;
+	prog_node->prog = prog;
+	err = rhashtable_insert_fast(&progs, &prog_node->ht_node, progs_params);
+	if (err)
+		goto err_pnode;
+
+	prog = bpf_prog_inc(prog);
+	if (IS_ERR(prog)) {
+		err = PTR_ERR(prog);
+		goto err_rht;
+	}
+out:
 	kfree(req);
 
 	return err;
+err_rht:
+	rhashtable_remove_fast(&progs, &prog_node->ht_node, progs_params);
+err_pnode:
+	kfree(prog_node);
+err_xdp:
+	dev_change_xdp(dev, extack, NULL, flags);
+err_prog:
+	bpf_prog_put(prog);
+err_umh:
+	req->cmd = XDP_FLOW_CMD_UNLOAD;
+	transact_umh(req, NULL);
+
+	goto out;
 }
 
 static int xdp_flow_setup_unbind(struct net_device *dev,
 				 struct netlink_ext_ack *extack)
 {
+	struct xdp_flow_prog *prog_node;
+	u32 flags = XDP_FLAGS_DRV_MODE;
 	struct mbox_request *req;
-	int err;
+	int err, ret = 0;
+	u32 prog_id = 0;
+
+	prog_node = rhashtable_lookup_fast(&progs, &dev, progs_params);
+	if (!prog_node) {
+		pr_warn_once("%s: xdp_flow unbind was requested before bind\n",
+			     dev->name);
+		return -ENOENT;
+	}
+
+	err = dev_check_xdp(dev, extack, false, &prog_id, flags);
+	if (!err && prog_id == prog_node->prog->aux->id) {
+		err = dev_change_xdp(dev, extack, NULL, flags);
+		if (err) {
+			pr_warn("Failed to uninstall XDP prog: %d\n", err);
+			ret = err;
+		}
+	}
+
+	bpf_prog_put(prog_node->prog);
+	rhashtable_remove_fast(&progs, &prog_node->ht_node, progs_params);
+	kfree(prog_node);
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
@@ -153,10 +239,12 @@ static int xdp_flow_setup_unbind(struct net_device *dev,
 	req->ifindex = dev->ifindex;
 
 	err = transact_umh(req, NULL);
+	if (err)
+		ret = err;
 
 	kfree(req);
 
-	return err;
+	return ret;
 }
 
 static int xdp_flow_setup(struct net_device *dev, bool do_bind,
@@ -214,7 +302,11 @@ static int start_umh(void)
 
 static int __init load_umh(void)
 {
-	int err = 0;
+	int err;
+
+	err = rhashtable_init(&progs, &progs_params);
+	if (err)
+		return err;
 
 	mutex_lock(&xdp_flow_ops.lock);
 	if (!xdp_flow_ops.stop) {
@@ -230,8 +322,12 @@ static int __init load_umh(void)
 	xdp_flow_ops.setup = &xdp_flow_setup;
 	xdp_flow_ops.start = &start_umh;
 	xdp_flow_ops.module = THIS_MODULE;
+
+	mutex_unlock(&xdp_flow_ops.lock);
+	return 0;
 err:
 	mutex_unlock(&xdp_flow_ops.lock);
+	rhashtable_destroy(&progs);
 	return err;
 }
 
@@ -244,6 +340,7 @@ static void __exit fini_umh(void)
 	xdp_flow_ops.setup = NULL;
 	xdp_flow_ops.setup_cb = NULL;
 	mutex_unlock(&xdp_flow_ops.lock);
+	rhashtable_destroy(&progs);
 }
 module_init(load_umh);
 module_exit(fini_umh);
-- 
1.8.3.1

