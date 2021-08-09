Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9182F3E409F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 09:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhHIHBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 03:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbhHIHBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 03:01:21 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C8CC0613CF;
        Mon,  9 Aug 2021 00:01:00 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f3so4720162plg.3;
        Mon, 09 Aug 2021 00:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0xn3ZbqPT48Qgutw2euPm9KYmANN2Fb5eOs99RKHa2g=;
        b=OiQiolbXBBg21BcB+jFcTqKHBF65SZt7UW4g9TyU7NTo3At8QSS9Y49DckMg+tISHQ
         7aTRCmlio4qq4fgQtnM9LxAl+zCUnWy59WI25tU/qyiNUwVfVOX0AGzkt7YXCtrfQp4O
         eQijjet6ZsCH8KbdpaBjwk3+LcgiDcU1Rk7LWvmeHgaQoLtkP+Qzv7QB0J865rDconzl
         K+pOEk8DJp91Zj+S1Y2xD/VGXpFpqWP1w93y+3hZDoiAVpKSvyfTsJXAeZcBt4TL7TFd
         Q3YZsDyABAUslsqwXFCE2wtLyqA8XxZLtx6pybySy1WcbV9z8Zsb73S6DzZrHGcJyRyM
         6ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0xn3ZbqPT48Qgutw2euPm9KYmANN2Fb5eOs99RKHa2g=;
        b=rNg37sAoiB74oNU6Z/xbt8jWbhfCVUWz8GlViPdHDbbw2/5W4HyESwRWU9tSg4FGwV
         WecMHD665I4ljCuRQvG0EtKfe9k/gvbHhAURMPf/LFLje3eOvg1TyhGxnwKo6baKrsM5
         YMgjrFKrxeXIBT5oJD8sg7g064qJbeSPGr+N6UvkgR06ksqYxIqucy4zTl6Kujtq7ALV
         pDtUcrOZ+o1+3xHga+ykVQYlI1wRlYsat319WFagYzRUBdqgmysxaZCs89n67vuV/R0h
         fjBuOJbm5qyYDx6k+EycQeau57KIsZ6vPli1xbUVutSYJfuRCJLkWpqXaT3e2tAW03XA
         46nQ==
X-Gm-Message-State: AOAM5302qLSkr/5yScMKu9EtO0GEu5C9bIhGLSi6rV0Hu1r9hN2taZ5m
        l1t3Vgf+wsFLB7MeXlet5jk=
X-Google-Smtp-Source: ABdhPJxhcuCCQPGjmmyHGpv2DWq8jotYFUGzVA6dVcieOgSg+FCjCfe7/I8f08fl3ZTLCXzBKVnV1w==
X-Received: by 2002:a17:90a:509:: with SMTP id h9mr12526469pjh.71.1628492459944;
        Mon, 09 Aug 2021 00:00:59 -0700 (PDT)
Received: from u18.mshome.net ([167.220.238.132])
        by smtp.gmail.com with ESMTPSA id n11sm17316165pjf.17.2021.08.09.00.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 00:00:59 -0700 (PDT)
From:   Muhammad Falak R Wani <falakreyaz@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] samples: bpf: add an explict comment to handle nested vlan tagging.
Date:   Mon,  9 Aug 2021 12:30:46 +0530
Message-Id: <20210809070046.32142-1-falakreyaz@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A codeblock for handling nested vlan trips newbies into thinking it as
duplicate code. Explicitly add a comment to clarify.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 samples/bpf/xdp1_kern.c | 2 ++
 samples/bpf/xdp2_kern.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
index 34b64394ed9c..f0c5d95084de 100644
--- a/samples/bpf/xdp1_kern.c
+++ b/samples/bpf/xdp1_kern.c
@@ -57,6 +57,7 @@ int xdp_prog1(struct xdp_md *ctx)
 
 	h_proto = eth->h_proto;
 
+	/* Handle VLAN tagged packet */
 	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
 		struct vlan_hdr *vhdr;
 
@@ -66,6 +67,7 @@ int xdp_prog1(struct xdp_md *ctx)
 			return rc;
 		h_proto = vhdr->h_vlan_encapsulated_proto;
 	}
+	/* Handle double VLAN tagged packet */
 	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
 		struct vlan_hdr *vhdr;
 
diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
index c787f4b49646..d8a64ab077b0 100644
--- a/samples/bpf/xdp2_kern.c
+++ b/samples/bpf/xdp2_kern.c
@@ -73,6 +73,7 @@ int xdp_prog1(struct xdp_md *ctx)
 
 	h_proto = eth->h_proto;
 
+	/* Handle VLAN tagged packet */
 	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
 		struct vlan_hdr *vhdr;
 
@@ -82,6 +83,7 @@ int xdp_prog1(struct xdp_md *ctx)
 			return rc;
 		h_proto = vhdr->h_vlan_encapsulated_proto;
 	}
+	/* Handle double VLAN tagged packet */
 	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
 		struct vlan_hdr *vhdr;
 
-- 
2.17.1

