Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DA72A603B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgKDJH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbgKDJGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:36 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3B2C0401C1
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:35 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id p19so1423454wmg.0
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kRmJDRZK6hYnZwsJWtSyII6GRFG28FGG7WVn2jtoat0=;
        b=Vy0ifnFNZsdam2EYQqrtqEkqnpo+nDE+vtZ1Exog/zDTxcDNqjIjGsjIU1pi4kN3El
         WJb+mUgrcdzGRp3ibB8ikQUE/nHlWxpqRKWFVzAojniHotRo1+HOdbKPDVdxQrzIx6sR
         o5bH/KMSqaIrUmQaZkvfPrv1gFxI//c+XLeUSm9xVA3kwk7Z26qKNIX1zX0RkPnJ08Uu
         3N/AsWZ+Jl5bU+SZ4vt/SsxAgf4VmWQbEcGIUXSUX2VSwqItVn590AY7hkgF110FhA9z
         j+QBoryGrshn3GGWS2c27qqPt497aXTtIabvKKAeyhw/gsk+3P4aFPmg5/JE0C/2HE/p
         rbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kRmJDRZK6hYnZwsJWtSyII6GRFG28FGG7WVn2jtoat0=;
        b=nUMm05gonfnB4lWaFs1472nmLdUNxW4azgt6ZgNqfUta1vTBwQvb6fY/ec8Dq9joAR
         fXkaSXjGeqylpCgMIedZkS6BLHTad0PfwvyDBOYU86l1c6hyCkBiapJCGfIQr5UlxkLp
         3uh0tDnr3+RByeRlKCOuPYBJ7B2zbCKk9Kwr9h83rLz2ebbfVKhQVgIIyJaRvabA6lO9
         sIQi7pjyirmZl9v/kY+VlaAaX23b4TGUa3VYhh9bbp+6MV3HK6g7zJ1jsmzob9MM4F0s
         XGcqh+XicxN+KlBFwVNXuuQbl8bI4LmumaJircBILkOzT+3awn4XPG4fWAkp4CzlYuMi
         E4nA==
X-Gm-Message-State: AOAM532b0DDqQek2MRtKKdOC3WqCpGpGZe+1Juf+BAvkelJt0xuXTUMJ
        aL8rkgzEQ43AQ0p3egCJja8Qhg==
X-Google-Smtp-Source: ABdhPJwqi0yB/+B9/s0ULCABSavH/6P6SV0tchgnVRlqqMJnN0CKjV/Hb1Yj3pHPlBIYEvJ5zSVeQA==
X-Received: by 2002:a1c:1dc1:: with SMTP id d184mr3360241wmd.169.1604480793874;
        Wed, 04 Nov 2020 01:06:33 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:33 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 08/12] net: xen-netfront: Demote non-kernel-doc headers to standard comment blocks
Date:   Wed,  4 Nov 2020 09:06:06 +0000
Message-Id: <20201104090610.1446616-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201104090610.1446616-1-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/xen-netfront.c: In function ‘store_rxbuf’:
 drivers/net/xen-netfront.c:2416:16: warning: variable ‘target’ set but not used [-Wunused-but-set-variable]
 drivers/net/xen-netfront.c:1592: warning: Function parameter or member 'dev' not described in 'netfront_probe'
 drivers/net/xen-netfront.c:1592: warning: Function parameter or member 'id' not described in 'netfront_probe'
 drivers/net/xen-netfront.c:1669: warning: Function parameter or member 'dev' not described in 'netfront_resume'
 drivers/net/xen-netfront.c:2313: warning: Function parameter or member 'dev' not described in 'netback_changed'
 drivers/net/xen-netfront.c:2313: warning: Function parameter or member 'backend_state' not described in 'netback_changed'

Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: KP Singh <kpsingh@chromium.org>
Cc: xen-devel@lists.xenproject.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/xen-netfront.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 920cac4385bf7..93740ef4cf1b4 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1582,7 +1582,7 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 	return ERR_PTR(err);
 }
 
-/**
+/*
  * Entry point to this code when a new device is created.  Allocate the basic
  * structures and the ring buffers for communication with the backend, and
  * inform the backend of the appropriate details for those.
@@ -1659,7 +1659,7 @@ static void xennet_disconnect_backend(struct netfront_info *info)
 	}
 }
 
-/**
+/*
  * We are reconnecting to the backend, due to a suspend/resume, or a backend
  * driver restart.  We tear down our netif structure and recreate it, but
  * leave the device-layer structures intact so that this is transparent to the
@@ -2305,7 +2305,7 @@ static int xennet_connect(struct net_device *dev)
 	return 0;
 }
 
-/**
+/*
  * Callback received when the backend's state changes.
  */
 static void netback_changed(struct xenbus_device *dev,
-- 
2.25.1

