Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C482FBB75
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbhASPli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391102AbhASPhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:37:54 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF84C061757;
        Tue, 19 Jan 2021 07:37:13 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id m13so22360485ljo.11;
        Tue, 19 Jan 2021 07:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RO1GdsGe/CwUlFc4QGSwFYrVwnR9WPHVNLK3C1RF8Gk=;
        b=nl/1LuKal+LY2hUK70DvHFUEAVo/Y8S9ZeNS34cNf82aMCQoX5Kd+xuLUDnf8jjSzu
         ICZf2EL6pykZWxQ2r4YcOML7rut3mV35IGAr+hvvYrKiNjxc+4AKmfvpdeb6RZUKcFG2
         dwVajnLd0dngeQrBBSC/nj6yUun992iJadbK6yrk0pngL5qOBKW0U3CRc7u1eRLYeeW2
         k8aosAWp4CT9EWmi9MsUz7yXvWYHvGN3SzI1kgP4jYlmDcAJBGk9LbZRDj+iCeADw4x4
         7/Cyz5oJK56XpdHnCf+hcNad3sVCYyRCmVyxMYBkWPXhM3atRE8lt7F3pY36HpXbHcMX
         suCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RO1GdsGe/CwUlFc4QGSwFYrVwnR9WPHVNLK3C1RF8Gk=;
        b=RpAwYlNj0Io6DkOprb5AfzsRFJZqybAgaMXJWXPSM5DqOE9gYpK312lUx9QVT+KNrH
         uSBxZAVz/KKPUN8bgXHvP6fGRHdUaXjKLScLA4jyJGNruP9WDyx1sGO7FJzHaQag1IxT
         P7ZXW9oHovocWG834nLGSfoh+PWNqB2hJA75ZwkwCDQSAGTMuadsy3rI9exOu+96oeFf
         GgFJyUtfpMt07gxMTrkjb+A4poSc46hTL/XEGjZXmABsEAOb93hzXk2IGJfhfeGY/qVr
         7AgUdvyfhwnssE4HcXhCObbN2Dl2qURQQi3XgYjxIIiCJBrJUibHecUiGOuYLro5ai3m
         Pg6g==
X-Gm-Message-State: AOAM532XspBio1NxBIpfgB3U9Jw5+sKOHCVU4kTFQlZTIEWgsGWzBTDi
        q6PQYllaXp07sOaIuAZCWaQ=
X-Google-Smtp-Source: ABdhPJxnJswRzGJUeUIiHcCMTkZmw2nYvj9Db6HS5/SCHwD81ZBQaxSqWpaXolCEf66+7EVATsEuiQ==
X-Received: by 2002:a05:651c:1123:: with SMTP id e3mr2101985ljo.131.1611070630431;
        Tue, 19 Jan 2021 07:37:10 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id z2sm2309075lfd.142.2021.01.19.07.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:37:09 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 2/8] xsk: remove explicit_free parameter from __xsk_rcv()
Date:   Tue, 19 Jan 2021 16:36:49 +0100
Message-Id: <20210119153655.153999-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119153655.153999-1-bjorn.topel@gmail.com>
References: <20210119153655.153999-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The explicit_free parameter of the __xsk_rcv() function was used to
mark whether the call was via the generic XDP or the native XDP
path. Instead of clutter the code with if-statements and "true/false"
parameters which are hard to understand, simply move the explicit free
to the __xsk_map_redirect() which is always called from the native XDP
path.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 8037b04a9edd..5820de65060b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -184,12 +184,13 @@ static void xsk_copy_xdp(struct xdp_buff *to, struct xdp_buff *from, u32 len)
 	memcpy(to_buf, from_buf, len + metalen);
 }
 
-static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
-		     bool explicit_free)
+static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	struct xdp_buff *xsk_xdp;
 	int err;
+	u32 len;
 
+	len = xdp->data_end - xdp->data;
 	if (len > xsk_pool_get_rx_frame_size(xs->pool)) {
 		xs->rx_dropped++;
 		return -ENOSPC;
@@ -207,8 +208,6 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
 		xsk_buff_free(xsk_xdp);
 		return err;
 	}
-	if (explicit_free)
-		xdp_return_buff(xdp);
 	return 0;
 }
 
@@ -230,11 +229,8 @@ static bool xsk_is_bound(struct xdp_sock *xs)
 	return false;
 }
 
-static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
-		   bool explicit_free)
+static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
-	u32 len;
-
 	if (!xsk_is_bound(xs))
 		return -EINVAL;
 
@@ -242,11 +238,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
 		return -EINVAL;
 
 	sk_mark_napi_id_once_xdp(&xs->sk, xdp);
-	len = xdp->data_end - xdp->data;
-
-	return xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL ?
-		__xsk_rcv_zc(xs, xdp, len) :
-		__xsk_rcv(xs, xdp, len, explicit_free);
+	return 0;
 }
 
 static void xsk_flush(struct xdp_sock *xs)
@@ -261,18 +253,41 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	int err;
 
 	spin_lock_bh(&xs->rx_lock);
-	err = xsk_rcv(xs, xdp, false);
-	xsk_flush(xs);
+	err = xsk_rcv_check(xs, xdp);
+	if (!err) {
+		err = __xsk_rcv(xs, xdp);
+		xsk_flush(xs);
+	}
 	spin_unlock_bh(&xs->rx_lock);
 	return err;
 }
 
+static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
+{
+	int err;
+	u32 len;
+
+	err = xsk_rcv_check(xs, xdp);
+	if (err)
+		return err;
+
+	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL) {
+		len = xdp->data_end - xdp->data;
+		return __xsk_rcv_zc(xs, xdp, len);
+	}
+
+	err = __xsk_rcv(xs, xdp);
+	if (!err)
+		xdp_return_buff(xdp);
+	return err;
+}
+
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	struct list_head *flush_list = this_cpu_ptr(&xskmap_flush_list);
 	int err;
 
-	err = xsk_rcv(xs, xdp, true);
+	err = xsk_rcv(xs, xdp);
 	if (err)
 		return err;
 
-- 
2.27.0

