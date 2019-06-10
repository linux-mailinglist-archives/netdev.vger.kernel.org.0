Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DEC3B8E0
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391406AbfFJQDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:03:43 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46926 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391403AbfFJQDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:03:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id v9so3562136pgr.13;
        Mon, 10 Jun 2019 09:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HCfE1HXr841yj0UuVhFnJTe/4mtHmyzJWu6FOc5d5xg=;
        b=vMENmKodAfR8b/o+ajLdRPIEHoYD0PUw7zaMUP72lq3WQyuJ7isg7yO+DFQdZLy6gQ
         qHbW4SfGhltEPns+dCJVDL0BQJ50b3WC9+2jzS2suMyh5Qk3d+O66Mfdtk++7S93yM6u
         WkFkgVqLjPARD8qSJDCz0dtiaok57Bu+kqmZo6qAYT9X79eKXv9y8mvC9O2Qq2rlwAoA
         4iLOLRIdONvHwg0+k15eHeiuyecE/UvkXFmWCY+NCNNfztrqaAvn4le4cJSBvZsmZKSe
         uFHW0kPdsGsQVRxSn6qTXSTHzRdsXSXD1sJ3Yr/oEiFUUvYSBT7DJfZTgz+JKZWj7lv5
         PE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HCfE1HXr841yj0UuVhFnJTe/4mtHmyzJWu6FOc5d5xg=;
        b=lM2TCr4a0a4hboeU+tvCFZSxIzaB1fvlsSySOEtXY5ejBZPiDLpYGguWFBeppYLxJw
         S1LMkJD668M/FnxtZRXJU0J1YEaOPR/VgeT6aiVroyQk8MLz/M3jmryanlqfREkCsqVk
         fFl2xvSuQyh14irOux3VQRu/ztHw2e5UpxqCAmAL+jP6KSE4ZDvOaDdoYIHN8Hw+kZLU
         b71zpDYaYwvBnYP2eowpF9iYxSsZBFPquOX4hQRV5P93K4NqslpG4ZEUkl3paBiuPWo1
         8pylBRgU8z3vnZfGnM65+SiEHqbfP0LIOUmb8PQDKFawwGS10a2DVeHcQWqEfDdc/C2d
         kkZQ==
X-Gm-Message-State: APjAAAXrNpR7UYnyfFEgBaRnYnedRN1xGigDMqydRntWI07g/ii7dZgI
        C9BgiKXYSw2ATVD9RaRJ6A8=
X-Google-Smtp-Source: APXvYqxZDGhD6JcN70YCJC3WwmteOM+0OIP7/ZiKoHfOHfY3GNtepe8bAFyQocArFAIPfHCjtB6OBw==
X-Received: by 2002:a65:44cb:: with SMTP id g11mr16067015pgs.193.1560182618321;
        Mon, 10 Jun 2019 09:03:38 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id f5sm10574118pfn.161.2019.06.10.09.03.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 09:03:37 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, toke@redhat.com, brouer@redhat.com,
        bpf@vger.kernel.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com
Subject: [PATCH bpf-next v3 5/5] net: xdp: remove xdp_attachment_flags_ok() and flags member
Date:   Mon, 10 Jun 2019 18:02:34 +0200
Message-Id: <20190610160234.4070-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610160234.4070-1-bjorn.topel@gmail.com>
References: <20190610160234.4070-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The attachment flags check is done in the generic netdev code, so
there is no need for this function anymore. Remove it and all uses of
it.

Further; Passing flags from struct netdev_bpf when attaching an XDP
program is no longer necessary, so let us remove that member.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c |  6 ------
 drivers/net/netdevsim/bpf.c                         |  3 ---
 include/linux/netdevice.h                           |  1 -
 include/net/xdp.h                                   |  3 ---
 net/core/dev.c                                      |  1 -
 net/core/xdp.c                                      | 13 -------------
 6 files changed, 27 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 2a9683db54e5..c164da24c28c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3497,9 +3497,6 @@ static int nfp_net_xdp_setup_drv(struct nfp_net *nn, struct netdev_bpf *bpf)
 	struct nfp_net_dp *dp;
 	int err;
 
-	if (!xdp_attachment_flags_ok(&nn->xdp, bpf))
-		return -EBUSY;
-
 	if (!prog == !nn->dp.xdp_prog) {
 		WRITE_ONCE(nn->dp.xdp_prog, prog);
 		xdp_attachment_setup(&nn->xdp, bpf);
@@ -3528,9 +3525,6 @@ static int nfp_net_xdp_setup_hw(struct nfp_net *nn, struct netdev_bpf *bpf)
 {
 	int err;
 
-	if (!xdp_attachment_flags_ok(&nn->xdp_hw, bpf))
-		return -EBUSY;
-
 	err = nfp_app_xdp_offload(nn->app, nn, bpf->prog, bpf->extack);
 	if (err)
 		return err;
diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index d03d31721e38..51b2430f1edc 100644
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
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6b700005288d..d7fa2c9fa031 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -879,7 +879,6 @@ struct netdev_bpf {
 	union {
 		/* XDP_SETUP_PROG */
 		struct {
-			u32 flags;
 			struct bpf_prog *prog;
 			struct netlink_ext_ack *extack;
 		};
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 4ad4b20fe2c0..854267b3b624 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -155,12 +155,9 @@ xdp_data_meta_unsupported(const struct xdp_buff *xdp)
 
 struct xdp_attachment_info {
 	struct bpf_prog *prog;
-	u32 flags;
 };
 
 struct netdev_bpf;
-bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
-			     struct netdev_bpf *bpf);
 void xdp_attachment_setup(struct xdp_attachment_info *info,
 			  struct netdev_bpf *bpf);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index bb5fbb395596..b0476545fbc8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8026,7 +8026,6 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	}
 
 	xdp.extack = extack;
-	xdp.flags = flags;
 	xdp.prog = prog;
 
 	err = bpf_op(dev, &xdp);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 6f76ad995fef..b2cdebd0b17d 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -379,25 +379,12 @@ void xdp_return_buff(struct xdp_buff *xdp)
 }
 EXPORT_SYMBOL_GPL(xdp_return_buff);
 
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
 	if (info->prog)
 		bpf_prog_put(info->prog);
 	info->prog = bpf->prog;
-	info->flags = bpf->flags;
 }
 EXPORT_SYMBOL_GPL(xdp_attachment_setup);
 
-- 
2.20.1

