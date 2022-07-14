Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA41E57476E
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbiGNInO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiGNInL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:43:11 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEF15F87
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:43:09 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bu1so1566299wrb.9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L7U+xNUa7u+4OWKfAhwvkxkgEoSFOdVNXwdOBUNhl9M=;
        b=Ol0ItgBra8CvmNJ8jpibH2QON11G0XMH7k85OKhvXYQAFNLhV4mCOt1WOaP9HCrm6X
         aXaxORtY99UXr/RHS6QGwCPBwfvUFbej/qYzLEaOVlwjXWntgymNa/Zlr7sccDiMpTp8
         hC+ksv877LDHOn/OHjxeOIiw+ACYAZne2BM9L/VvpMhxCX6gcfllT48G63fFkTLoxGvS
         EBWjAPURzYow+FZXNB5ffS43M8cBTIKuQSrslzKJmKOEIle4EuBwmG0UuGHmO5B/KiAF
         L7KEhWopj3NJINDTYfOkuaGwgzruQ9Qykm0839QV4Ph6mZV2WR8q3h+ScyWhXONd/kMZ
         BSpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L7U+xNUa7u+4OWKfAhwvkxkgEoSFOdVNXwdOBUNhl9M=;
        b=7PvDXtUANQ5I8bqn3VdV/uidSlARKdzG3MD6q637eajfLlUM27Pc7sguJTSkBPVYNN
         9Rd3FCM/jQlIx5JXLc/Dvda1VbBe6s1f7yXFBGKTB6HOYuG+o1M3Bgt74Hgajk02DrJu
         aW+fAttdPznTvR2Ytigqk+qFjDg/HDb0lLdC9/yxu+MFRfhtWrFsJPv7Bj1EeEQqXQtz
         vsiCUgc1OTixoykVkdnsBehKBzZnkTFd80xgVNn2FcMj8D+s2TRWzCvKRSMUl1ZdFenm
         +AwdA2CC8PZ0wv5kfRCNbbMXeMPRwHgDbR07fJ76377UsCx+VnrKaT8pjPKJO5IfjJIW
         3ShA==
X-Gm-Message-State: AJIora8MwZbs50IRRxmtp+LphsHWvwLkV2dAdzMaQ2WP+uaXffiw3rzZ
        6j54bvZUPDoPUgoX560Jlca/2w==
X-Google-Smtp-Source: AGRyM1sYkTZXv+De3e9zo8Nj/yFYsp5RvzWolKLhXIiGgbrZVWfwK6L6SoGF7mX0YdxWp9LmYPqwEg==
X-Received: by 2002:a5d:4bc4:0:b0:21d:918c:b945 with SMTP id l4-20020a5d4bc4000000b0021d918cb945mr7040455wrt.287.1657788188298;
        Thu, 14 Jul 2022 01:43:08 -0700 (PDT)
Received: from rainbowdash.office.codethink.co.uk ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id i16-20020a5d5230000000b0021d9d13bf6csm854042wra.97.2022.07.14.01.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 01:43:07 -0700 (PDT)
From:   Ben Dooks <ben.dooks@sifive.com>
To:     linux-kernel@vger.kernel.org
Cc:     Sudip Mukherjee <sudip.mukherjee@sifive.com>,
        Jude Onyenegecha <jude.onyenegecha@sifive.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ben Dooks <ben.dooks@sifive.com>
Subject: [PATCH] net: macb: fixup sparse warnings on __be16 ports
Date:   Thu, 14 Jul 2022 09:43:05 +0100
Message-Id: <20220714084305.209425-1-ben.dooks@sifive.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port fields in the ethool flow structures are defined
to be __be16 types, so sparse is showing issues where these
are being passed to htons(). Fix these warnings by passing
them to be16_to_cpu() instead.

These are being used in netdev_dbg() so should only effect
anyone doing debug.

Fixes the following sparse warnings:

drivers/net/ethernet/cadence/macb_main.c:3366:9: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3366:9: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3366:9: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3419:25: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3419:25: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3419:25: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3419:25: warning: cast from restricted __be16

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>

--
Note, given the IP is also being passed ot htons() should
this either be changed to be32_to_cpu() or better passed
as a pointre and the %pI4 be used to print it.
---
 drivers/net/ethernet/cadence/macb_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d89098f4ede8..f38b924e393b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3482,7 +3482,8 @@ static int gem_add_flow_filter(struct net_device *netdev,
 			fs->flow_type, (int)fs->ring_cookie, fs->location,
 			htonl(fs->h_u.tcp_ip4_spec.ip4src),
 			htonl(fs->h_u.tcp_ip4_spec.ip4dst),
-			htons(fs->h_u.tcp_ip4_spec.psrc), htons(fs->h_u.tcp_ip4_spec.pdst));
+		        be16_to_cpu(fs->h_u.tcp_ip4_spec.psrc),
+		        be16_to_cpu(fs->h_u.tcp_ip4_spec.pdst));
 
 	spin_lock_irqsave(&bp->rx_fs_lock, flags);
 
@@ -3535,8 +3536,8 @@ static int gem_del_flow_filter(struct net_device *netdev,
 					fs->flow_type, (int)fs->ring_cookie, fs->location,
 					htonl(fs->h_u.tcp_ip4_spec.ip4src),
 					htonl(fs->h_u.tcp_ip4_spec.ip4dst),
-					htons(fs->h_u.tcp_ip4_spec.psrc),
-					htons(fs->h_u.tcp_ip4_spec.pdst));
+					be16_to_cpu(fs->h_u.tcp_ip4_spec.psrc),
+					be16_to_cpu(fs->h_u.tcp_ip4_spec.pdst));
 
 			gem_writel_n(bp, SCRT2, fs->location, 0);
 
-- 
2.35.1

