Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD8E3D75D1
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbhG0NSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbhG0NS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:29 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA50C061757;
        Tue, 27 Jul 2021 06:18:28 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id a80-20020a1c98530000b0290245467f26a4so2353110wme.0;
        Tue, 27 Jul 2021 06:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XDCGMnZwqvwnTKJJVSQ0Q5+65eOgD5z0zzT93aFCQ3w=;
        b=MYeuHGrEEHHAjHLJSuKvDKLY88yETDOobeq4y4BPEYJ2ynCTXEbCsRJ5bmNf5ek1lc
         9KYGs+qOyorxU+LUbXrG1siJA0BskfMF5aoRBYGchNuBGLT/wiTA/krL7SlUUz356z3E
         xt+N3PeL3cm4qhuy5g5jAh49rI2s5rXiGVIR6GWEUbX2Mos1uSQfuClSvQWziWkDYAPY
         F5hbK4QCZzabexB1CRft0ESwZ99GB52zuCoqAgSaKc1KX3Jlr3+4xXu28zADKDpmK5x9
         4ziOV01N6EaojIeKpLCvwhHJ/Jtqh4eO8TlKAWSxKXAAtHCt9wCJMg+a/qm9bQcfR+Zo
         i6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XDCGMnZwqvwnTKJJVSQ0Q5+65eOgD5z0zzT93aFCQ3w=;
        b=ovdIFt3a49YjNLzS9olpaEsp16oQSG48XwukK72ldZI5GwkhrVyNfHKgDFTYaTj0EQ
         kpsIJ55BzQES3VvUlx/Rwqmgd8M6S8sWuVSKdvbnmz5AhQmlR8r8jZdBZtiMBNbXjVEm
         Va7/LWw8ny24nXcR5ucDPBo4Gr8lkUy5gmm/qWRVy9evKLZKwhiPxELYavU4q7tjtrxN
         nMmxx2x2Z6383TCWpZMrvvQr6fU0eJXNMI1srUTP9dtuhCXq4YVTxPZ9NfbHXsSI7UYs
         v/PpS0nNrhErhuwLXxd21iQ0Yn1PbGuGbhpHAC8nHBiFEExsJDmV/xSHn8bMXXRX3CV2
         PDTw==
X-Gm-Message-State: AOAM532sOulS/3Kbgm15TQJXJZjIMyyuwJk9TW97XtQn3mgZTfeX2Yhv
        Q5w+sjgA9GM+4jLK6RiVmgg=
X-Google-Smtp-Source: ABdhPJzmozIXrR296GOfl+lUOgmr8EIZz9IZ19/3CkT6Psa2dtE/Dk7IsnECXmcOVxBIsKqB8+2USw==
X-Received: by 2002:a1c:a54b:: with SMTP id o72mr4183901wme.114.1627391907558;
        Tue, 27 Jul 2021 06:18:27 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:27 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 12/17] selftests: xsk: decrease batch size
Date:   Tue, 27 Jul 2021 15:17:48 +0200
Message-Id: <20210727131753.10924-13-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Decrease the batch size from 64 to 8 to stress the system some more
and avoid potentially overflowing some buffers in the skb case.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 0fb657b505ae..1c5457e9f1d6 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -36,7 +36,7 @@
 #define UDP_PKT_DATA_SIZE (UDP_PKT_SIZE - sizeof(struct udphdr))
 #define USLEEP_MAX 10000
 #define SOCK_RECONF_CTR 10
-#define BATCH_SIZE 64
+#define BATCH_SIZE 8
 #define POLL_TMOUT 1000
 #define DEFAULT_PKT_CNT (4 * 1024)
 #define RX_FULL_RXQSIZE 32
-- 
2.29.0

