Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEC153F85C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbiFGIlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238316AbiFGIkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:40:53 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D359D2471;
        Tue,  7 Jun 2022 01:40:52 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t2so14261860pld.4;
        Tue, 07 Jun 2022 01:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vwPyT1T8v9wSlM5J2T2gMD/gfjhpWPJJcViEUxRXN10=;
        b=YsPk5e0WMhfJWt+DWkYp3zzu4rh4T1wuMtmvTgxrGrXM/XEhkArP0tGlakuyCtNK97
         ImrWacaFfXop9OqehY/YA5RUHQSZ6ZNsvErcEOCd72FUqoYt7xAaAhHkZt2loCDPzcLj
         bB07XYgmBjqP4gr/4E5EkHwOBDop+AZeRZ73goQ9QBYD290J+tf0WqRp6A5ktNOZBP/S
         LMw0y7zM3kukK00vVGyYxTO1zhPfb/jR4h25EEBWJx3a84Jmsl8BesaXqYe5ndHePjSl
         cxAERwar5Jjk7qu5mnxvMpIlRJNWGlNG+PBTatBVJgqo8fyu5dSzOqong7bVkWEpxwj3
         iReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vwPyT1T8v9wSlM5J2T2gMD/gfjhpWPJJcViEUxRXN10=;
        b=C2tHhkM3+XW7Pd5JpyOCbfCQk8287mrU2EFm1RALJvwbBLU8pDv4Qz4TNJnmml7JTk
         eae8ynHusGo5y2aWl+4Q69EIemtTw9EC6e9M3Y23WBRrAMfmuOhR2H+sAQehmjREzZgB
         9D1Y6EjSD0Jx3QZSfOk64tl0BfNo5yQRUssFvDdip6xhfSbVNl85fQ2JWuUflRgbigQ2
         t4wqlOtS+vxuqk6kiUM4PnfJWU0CmbQZy5/nYdV+b2CQ4Hkye16PNMQNfOOzLDewg7mx
         3O1iDslRfFMv1mss1elAmmCSuNkHbEuGOt2NIbDrRbi39Uf+2zJLCMY6L0ywa064Ktul
         JXcQ==
X-Gm-Message-State: AOAM532iIaiseflBtWj+c/kTrbSwrWyF2Zea7G88rqWK67YtOn73LwcM
        mBegWhBsBvtqJBbEaddttncrqqWrN9q83g==
X-Google-Smtp-Source: ABdhPJyR52TJh5XcoU9ehSssx+J6Tt5kil+RukboQ8LQxvT/PIhbUVSVR2feDDLhj4vWdYE4OMpe6Q==
X-Received: by 2002:a17:902:ea0e:b0:163:efcf:adc7 with SMTP id s14-20020a170902ea0e00b00163efcfadc7mr27757194plg.145.1654591251284;
        Tue, 07 Jun 2022 01:40:51 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s18-20020aa78d52000000b0050dc76281fdsm12134047pfe.215.2022.06.07.01.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 01:40:50 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next 3/3] selftests/bpf: move AF_XDP APIs to libxdp
Date:   Tue,  7 Jun 2022 16:40:03 +0800
Message-Id: <20220607084003.898387-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607084003.898387-1-liuhangbin@gmail.com>
References: <20220607084003.898387-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf APIs for AF_XDP are deprecated starting from v0.7.
Let's move to libxdp.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index e5992a6b5e09..e4969aa8c463 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -97,16 +97,10 @@
 #include <time.h>
 #include <unistd.h>
 #include <stdatomic.h>
-#include <bpf/xsk.h>
+#include <xdp/xsk.h>
 #include "xdpxceiver.h"
 #include "../kselftest.h"
 
-/* AF_XDP APIs were moved into libxdp and marked as deprecated in libbpf.
- * Until xdpxceiver is either moved or re-writed into libxdp, suppress
- * deprecation warnings in this file
- */
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-
 static const char *MAC1 = "\x00\x0A\x56\x9E\xEE\x62";
 static const char *MAC2 = "\x00\x0A\x56\x9E\xEE\x61";
 static const char *IP1 = "192.168.100.162";
-- 
2.35.1

