Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9AB61DD4D
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 19:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKEShH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 14:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiKEShF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 14:37:05 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8653211C3E;
        Sat,  5 Nov 2022 11:37:03 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v3so7041387pgh.4;
        Sat, 05 Nov 2022 11:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iPvbXiS700b+lttA0LO5c0SaACzw4bdF9reHv5JUqaI=;
        b=XBeFqKPx1RZ4LegH+A3UpV5hpziCKC/DXyTxC1pytDYErWf3qx3a+n3DLxTJgvUNut
         QKfE42zxmbvcMAw1yYRfugE6VgNohsfHohojX2UJp2ZzEBEOY1bDKvPTmqXIpOo3IGak
         zNa1bUeAoV45BmSWQSz6gORQMNKdFqEI+SHgLUxXs232SuJrg9sRc4IV+0wyZRoe/N8+
         T/hBVxyTPg4+YV+DHgkOd8aAe87d4tNQtS3SkuYINs4mBikKjlQNaVaEZ0h/WA8WXGco
         fijdVBD789Qn/oIdzOttuK/pPTGHoBw8VwmoXoWaseUOXAN+VWvKpP2JfYSrHlmJkBAG
         X+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iPvbXiS700b+lttA0LO5c0SaACzw4bdF9reHv5JUqaI=;
        b=YhBAkFDXt3sTxnIsT3Seey1TDNaylwyIlg092IU7KdUt33vBCy8qZy8MCx8MFMfHYL
         A3JSwjOQOEBzdqbe09zMRk7C9BqqqiuPCLUZn/bQotXww7FX/BV2amZ95aaon0ftNW4Y
         NWoorEOQcy+xzaGum2piNhCDyefDeFoWqskYeZGqz9VV/CHixitTxSsIN5iTLuqtKXV8
         1bd5VTEgc6l1i2X7JHn5xaR/SylQTUoySZW9Ql7bCMcCeINelw0Q2joCwGd8xuwCBFZa
         MGJ6rQj92+rMMvWbk3VkmhTmvRI2pO9ocR+O3pKTRHnD9KrnSInbtkfLvuFaPiNtpoln
         RDsw==
X-Gm-Message-State: ACrzQf3V4y5yZwx9ikDsMZIQPJ2OP0SlETftyl7OfBiR72kaTPpgREs+
        tmBSJGy/urAZA74GbbWZfW4=
X-Google-Smtp-Source: AMsMyM4SiqeG58EBDny7eMhipPe0d8zwrgGFuE57dlw+BUi29DbvmBXFexCqedKrPvGrW2KWA+KzXQ==
X-Received: by 2002:a05:6a00:d72:b0:56c:3c45:6953 with SMTP id n50-20020a056a000d7200b0056c3c456953mr41632260pfv.54.1667673422829;
        Sat, 05 Nov 2022 11:37:02 -0700 (PDT)
Received: from uftrace.. ([14.5.161.231])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090322c400b0016f196209c9sm1987146plg.123.2022.11.05.11.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 11:37:02 -0700 (PDT)
From:   Kang Minchul <tegongkang@gmail.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kang Minchul <tegongkang@gmail.com>
Subject: [PATCH v3] selftests/bpf: Fix u32 variable compared with less than zero
Date:   Sun,  6 Nov 2022 03:36:56 +0900
Message-Id: <20221105183656.86077-1-tegongkang@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable ret is compared with less than zero even though it was set as u32.
So u32 to int conversion is needed.

Signed-off-by: Kang Minchul <tegongkang@gmail.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 681a5db80dae..162d3a516f2c 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1006,7 +1006,8 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
 {
 	struct xsk_socket_info *xsk = ifobject->xsk;
 	bool use_poll = ifobject->use_poll;
-	u32 i, idx = 0, ret, valid_pkts = 0;
+	u32 i, idx = 0, valid_pkts = 0;
+	int ret;
 
 	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE) {
 		if (use_poll) {
-- 
2.34.1

