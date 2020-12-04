Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173A82CED87
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgLDLxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:53:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730021AbgLDLxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 06:53:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607082727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o+PrJpjmM4DYTJUyGlvv6TVizorkSjrUkFAhD1cJoAc=;
        b=b8cjsvKNraXzC9YXHDpN2JCuQrdhC4AwQNwmduBfpcXy64jK/hHOW09jNZZAKAIbZ5eJ8O
        0fYqmF8utDCAVYNezTmRkEuNrkXDW5oFGGjBs2JeecH4bYPOtquu9h7SbPywu9v8d8ge0w
        8pvIdnrm9FJjIxS/QroGJBVKL4JDKKQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-WxJLOma9MpuWAHQtgd5cfQ-1; Fri, 04 Dec 2020 06:52:05 -0500
X-MC-Unique: WxJLOma9MpuWAHQtgd5cfQ-1
Received: by mail-ed1-f70.google.com with SMTP id bf13so2241873edb.10
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 03:52:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=o+PrJpjmM4DYTJUyGlvv6TVizorkSjrUkFAhD1cJoAc=;
        b=YQI7gicXFvNP4Ajcvk6cGZEHOLM9YE60wUXj72cOb+wdDpEyma36KBkB+6dmC14TY/
         1ljjIVC39KIiEs43H0Wxl+rabtYqzejK3C1/VmBaL81cQQqN6v+dlgP8qmMNanRE99hp
         7zYZ9Xl7BzicTUm2LdUVHDAX/+6ZUEip56+6Cv+XRmhqG6cLQzYQBNLZVFZ43x+dAzmL
         y71WDeRIgzvWSA++//JPIq01CZXV1cWagIOWoXwyVzFFxU2Xm4rYfKuQSp1D8g7czYLC
         LRi1D+MGFAzwreWQL44yyUtpGHzqPtAzAeSeojPpukIyStaBED+jTp9jzoc8JN00wVgE
         dreQ==
X-Gm-Message-State: AOAM5320nwn9WDlIjlowZUtOw2dV4iU4aQoFTZ3Xe9cAdPTfya73as9F
        KmHs0+rwpgYy59g/PxiqeOQw1kTexwTR7amy2KNcQy137GFYH36U3ZzvdMQinw3ec3qEsrtQvgW
        6XrQeFRoFeVXOH8J7
X-Received: by 2002:aa7:dc5a:: with SMTP id g26mr7159185edu.35.1607082724403;
        Fri, 04 Dec 2020 03:52:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSOGnoLZ1XWP7YZkoXojRE2PhgJ6M3W26c1RRj7AYQElgavQeSYr1QsJQbjPGLaZCb2r29tQ==
X-Received: by 2002:aa7:dc5a:: with SMTP id g26mr7159164edu.35.1607082724189;
        Fri, 04 Dec 2020 03:52:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k21sm3299595edq.26.2020.12.04.03.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 03:52:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 580221843EB; Fri,  4 Dec 2020 12:52:03 +0100 (CET)
Subject: [PATCH bpf v2 1/7] xdp: remove the xdp_attachment_flags_ok() callback
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 04 Dec 2020 12:52:03 +0100
Message-ID: <160708272326.192754.5292019194136947768.stgit@toke.dk>
In-Reply-To: <160708272217.192754.14019805999368221369.stgit@toke.dk>
References: <160708272217.192754.14019805999368221369.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Since commit 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF
programs in net_device"), the XDP program attachment info is now maintained
in the core code. This interacts badly with the xdp_attachment_flags_ok()
check that prevents unloading an XDP program with different load flags than
it was loaded with. In practice, two kinds of failures are seen:

- An XDP program loaded without specifying a mode (and which then ends up
  in driver mode) cannot be unloaded if the program mode is specified on
  unload.

- The dev_xdp_uninstall() hook always calls the driver callback with the
  mode set to the type of the program but an empty flags argument, which
  means the flags_ok() check prevents the program from being removed,
  leading to bpf prog reference leaks.

The original reason this check was added was to avoid ambiguity when
multiple programs were loaded. With the way the checks are done in the core
now, this is quite simple to enforce in the core code, so let's add a check
there and get rid of the xdp_attachment_flags_ok() callback entirely.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    6 -----
 drivers/net/ethernet/ti/cpsw_priv.c                |    3 ---
 drivers/net/netdevsim/bpf.c                        |    3 ---
 include/net/xdp.h                                  |    2 --
 net/core/dev.c                                     |   22 ++++++++++++++++++--
 net/core/xdp.c                                     |   12 -----------
 6 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b150da43adb2..437226866ce8 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3562,9 +3562,6 @@ static int nfp_net_xdp_setup_drv(struct nfp_net *nn, struct netdev_bpf *bpf)
 	struct nfp_net_dp *dp;
 	int err;
 
-	if (!xdp_attachment_flags_ok(&nn->xdp, bpf))
-		return -EBUSY;
-
 	if (!prog == !nn->dp.xdp_prog) {
 		WRITE_ONCE(nn->dp.xdp_prog, prog);
 		xdp_attachment_setup(&nn->xdp, bpf);
@@ -3593,9 +3590,6 @@ static int nfp_net_xdp_setup_hw(struct nfp_net *nn, struct netdev_bpf *bpf)
 {
 	int err;
 
-	if (!xdp_attachment_flags_ok(&nn->xdp_hw, bpf))
-		return -EBUSY;
-
 	err = nfp_app_xdp_offload(nn->app, nn, bpf->prog, bpf->extack);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 31c5e36ff706..424e644724e4 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1265,9 +1265,6 @@ static int cpsw_xdp_prog_setup(struct cpsw_priv *priv, struct netdev_bpf *bpf)
 	if (!priv->xdpi.prog && !prog)
 		return 0;
 
-	if (!xdp_attachment_flags_ok(&priv->xdpi, bpf))
-		return -EBUSY;
-
 	WRITE_ONCE(priv->xdp_prog, prog);
 
 	xdp_attachment_setup(&priv->xdpi, bpf);
diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 2e90512f3bbe..85546664bdd5 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -190,9 +190,6 @@ nsim_xdp_set_prog(struct netdevsim *ns, struct netdev_bpf *bpf,
 {
 	int err;
 
-	if (!xdp_attachment_flags_ok(xdp, bpf))
-		return -EBUSY;
-
 	if (bpf->command == XDP_SETUP_PROG && !ns->bpf_xdpdrv_accept) {
 		NSIM_EA(bpf->extack, "driver XDP disabled in DebugFS");
 		return -EOPNOTSUPP;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3814fb631d52..9dab2bc6f187 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -240,8 +240,6 @@ struct xdp_attachment_info {
 };
 
 struct netdev_bpf;
-bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
-			     struct netdev_bpf *bpf);
 void xdp_attachment_setup(struct xdp_attachment_info *info,
 			  struct netdev_bpf *bpf);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 8588ade790cb..38412e70f761 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8917,6 +8917,17 @@ static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
 	return dev->xdp_state[mode].prog;
 }
 
+static u8 dev_xdp_prog_count(struct net_device *dev)
+{
+	u8 count = 0;
+	int i;
+
+	for (i = 0; i < __MAX_XDP_MODE; i++)
+		if (dev->xdp_state[i].prog || dev->xdp_state[i].link)
+			count++;
+	return count;
+}
+
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode)
 {
 	struct bpf_prog *prog = dev_xdp_prog(dev, mode);
@@ -9007,6 +9018,7 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			  struct bpf_xdp_link *link, struct bpf_prog *new_prog,
 			  struct bpf_prog *old_prog, u32 flags)
 {
+	unsigned int num_modes = hweight32(flags & XDP_FLAGS_MODES);
 	struct bpf_prog *cur_prog;
 	enum bpf_xdp_mode mode;
 	bpf_op_t bpf_op;
@@ -9022,11 +9034,17 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 		NL_SET_ERR_MSG(extack, "Invalid XDP flags for BPF link attachment");
 		return -EINVAL;
 	}
-	/* just one XDP mode bit should be set, zero defaults to SKB mode */
-	if (hweight32(flags & XDP_FLAGS_MODES) > 1) {
+	/* just one XDP mode bit should be set, zero defaults to drv/skb mode */
+	if (num_modes > 1) {
 		NL_SET_ERR_MSG(extack, "Only one XDP mode flag can be set");
 		return -EINVAL;
 	}
+	/* avoid ambiguity if offload + drv/skb mode progs are both loaded */
+	if (!num_modes && dev_xdp_prog_count(dev) > 1) {
+		NL_SET_ERR_MSG(extack,
+			       "More than one program loaded, unset mode is ambiguous");
+		return -EINVAL;
+	}
 	/* old_prog != NULL implies XDP_FLAGS_REPLACE is set */
 	if (old_prog && !(flags & XDP_FLAGS_REPLACE)) {
 		NL_SET_ERR_MSG(extack, "XDP_FLAGS_REPLACE is not specified");
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 491ad569a79c..d900cebc0acd 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -403,18 +403,6 @@ void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
 }
 EXPORT_SYMBOL_GPL(__xdp_release_frame);
 
-bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
-			     struct netdev_bpf *bpf)
-{
-	if (info->prog && (bpf->flags ^ info->flags) & XDP_FLAGS_MODES) {
-		NL_SET_ERR_MSG(bpf->extack,
-			       "program loaded with different flags");
-		return false;
-	}
-	return true;
-}
-EXPORT_SYMBOL_GPL(xdp_attachment_flags_ok);
-
 void xdp_attachment_setup(struct xdp_attachment_info *info,
 			  struct netdev_bpf *bpf)
 {

