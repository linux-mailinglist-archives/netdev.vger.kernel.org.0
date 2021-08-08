Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD36C3E3A37
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhHHMfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhHHMe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 08:34:59 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0285AC061760;
        Sun,  8 Aug 2021 05:34:39 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso25375259pjf.4;
        Sun, 08 Aug 2021 05:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kZTCEpO46weGKXlGlV/kVDBT/mA13JjacOVJ1zjYzdA=;
        b=HBsvAWFtwd97kkuj4vSYoLEYqSixtYX/+29nW7D1ZWOkC0q3qz3Zx7c/sqY54y/qOO
         oKBGlkvVirxmm7C37vYesEH6BCge9W7JTt2oD07abPOy9xy0Y06ULxv6ZvlqGc+3QS9T
         xwr2Q6B7s77K7mVthktfSRKIP4e/LE+pV8H0h5IwIlC5d9oUItyrLv95e/N5zWZhN8Cl
         6DsmxTYfwzNjcvNA8JzqfZ5pseiJaW4kzJZb2k/NtsSAnYOikZa+AnnKzS628mgcgS65
         735nQZXUon/SBEHQ3LeNnOK2FnXp7U+M6hQ3tUlJpfChSSuW6SUAE+MhG64Jj0WtQe8a
         cIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kZTCEpO46weGKXlGlV/kVDBT/mA13JjacOVJ1zjYzdA=;
        b=CKvZzAzBU3z6ybg0rW61B4adKfgfjBAzxXQtqoG+MF+eJHqt+N1R+g8rzlqzENc3Dz
         +FsDwi/gh3ItC0Y0qTXR+feWDE37Wq/JJwOABtbNZ8QrC6CShRKJjL6H69hq3Wfx9bn5
         SrbWdNznYqTV8KX9IV9LtEm82UwI73xmffolfS1MNGvBb0MZX9HXvO/65x1Ouj8Bpdv2
         7uhv6apBb+IHVaAqU1SR0raWg07ZP68hTqunHRAWwlnABD8LvDJzGhBrIBVsjqw2ZNNn
         D3J+hUq2XAkRYnhJhGYSLGBnZQHHVJqCmMYLnivQxR48tiwJSbRa5oecu5Fc3J/0G4oG
         5G+w==
X-Gm-Message-State: AOAM533MaFtosA5uYpqgBEIPSA4erKFqdXP/yCAtStZ02hIKV8rjRY2J
        iuDJiwLCc6q81acvjbR4YYw=
X-Google-Smtp-Source: ABdhPJy/SspUG28+VcrTiiMl2wB1Bdyl7KY3P83lMOOKRlz5Slz1RooGU54stiPjaYzZIQKSDG/H0w==
X-Received: by 2002:a63:f959:: with SMTP id q25mr278841pgk.52.1628426079425;
        Sun, 08 Aug 2021 05:34:39 -0700 (PDT)
Received: from u18.mshome.net ([167.220.238.132])
        by smtp.gmail.com with ESMTPSA id h7sm14881710pjs.38.2021.08.08.05.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 05:34:39 -0700 (PDT)
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
Subject: [PATCH] samples: bpf: xdp2: remove duplicate code to find protocol
Date:   Sun,  8 Aug 2021 18:04:28 +0530
Message-Id: <20210808123428.12796-1-falakreyaz@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code to find h_vlan_encapsulated_proto is duplicated.
Remove the extra block.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 samples/bpf/xdp2_kern.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
index c787f4b49646..be4b0c642a6b 100644
--- a/samples/bpf/xdp2_kern.c
+++ b/samples/bpf/xdp2_kern.c
@@ -73,15 +73,6 @@ int xdp_prog1(struct xdp_md *ctx)
 
 	h_proto = eth->h_proto;
 
-	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
-		struct vlan_hdr *vhdr;
-
-		vhdr = data + nh_off;
-		nh_off += sizeof(struct vlan_hdr);
-		if (data + nh_off > data_end)
-			return rc;
-		h_proto = vhdr->h_vlan_encapsulated_proto;
-	}
 	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
 		struct vlan_hdr *vhdr;
 
-- 
2.17.1

