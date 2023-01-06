Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E93165FAB9
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 05:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjAFE2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 23:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjAFE2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 23:28:52 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163AF551C7
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 20:28:51 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gq18so240501pjb.2
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 20:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6MtouSE/c/6IpUkzqBwoQWV9c2KUTTgxJg5BS9SVs/s=;
        b=l/Ap6Nw8wI7NGfkXN/3WQkm0HipP4d8IpiwQ8tbFwy/1MyZlpCxJmVSTHr5Z7CrVyC
         6Q84LVsMaaEY0zSlrdKyPYz1zxeU46YvTNbDmyUgyd2Ik8PVgJ63sq/6mBYkfr2vUtz6
         HrDNREcM9613KaaDMFTY+467qiJC/fxw1Aego=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6MtouSE/c/6IpUkzqBwoQWV9c2KUTTgxJg5BS9SVs/s=;
        b=NaHr6Dhj5w4OlhUpMjNAa7EhOTbXZ/0XvGUYXyK6kHuRd9Ovswr0opHA3cIlolS5aX
         pU5fWXYE8DokRfOQua8oSOYuKhsuok6q0AFMPrwjA519wfD0ptPnZ0AuwmVBO3IVmeLN
         NTd069euXCDR05mg6HNXyO0AOOKj9bqksBKYVC0HKbxUJ1Hdb+/XvSghPhyBRinaPZmq
         oLQ9+b0ZSkYmGwTbhBKbzrmybSYSBK9v7fz4WeoW7rvRgqQp8Ftub+l/6ZKabSQffpkB
         E3PcKH9JS0aEQsguf7Lqd7WUrXNRVS+egAqjT8v00155Mi6LtfWORGgSoid12r+lhoaA
         ASwQ==
X-Gm-Message-State: AFqh2kpSp7ifF6hA4EpNpqyIXDsJCyNL8TxP1JhQE2E7ipStmIGRMLON
        BozUFAt8xoOVDCDAKsecS1M2nw==
X-Google-Smtp-Source: AMrXdXu3TV+pr86lAl/63OdQH+yd1F7I+N4nkpU/brgp9vvORdbuvpOYuM3Qw/20glsrtv6RhuPOYw==
X-Received: by 2002:a17:902:b414:b0:186:748e:9383 with SMTP id x20-20020a170902b41400b00186748e9383mr50928233plr.46.1672979330555;
        Thu, 05 Jan 2023 20:28:50 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n15-20020a170902d2cf00b00192902287d1sm18749402plc.288.2023.01.05.20.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 20:28:49 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        kernel test robot <lkp@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH v3] ethtool: Replace 0-length array with flexible array
Date:   Thu,  5 Jan 2023 20:28:48 -0800
Message-Id: <20230106042844.give.885-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; h=from:subject:message-id; bh=DKp2Eu0HGyg7pTlg/vHwD58jjHq4zOalTg6VuLkK1Ds=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjt6OAkODbjy1W2ZpLP5aLSnBaokwWRxffKKlCCKzH RHrHiN2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY7ejgAAKCRCJcvTf3G3AJr/wEA CjCp54OIIN2hDjgjrgLc704V/PLrFQSVrJOFBtEnITgTrIx/F9Z4fveot6egvNwYQaeSRQOXiXX6Eb UJHDIwUEuJIn7uhw2o038rVPEF0VtiSchIEOKwyco97aqwmJcqIVlnPzMdUHv5Qptc7G1Pt62Vbmya LFmtlSv/xPCNCaTj+Pp+YTwcj+ijyHZ6Ei9tDce3t71RYp0GUeV/Fgq3FQ94iirCk3ikGqi9huXNti niTraWIXywXJfMr0a8KBOhHnbB48a2o7u1VXC1gE6pHKBqk2NbtyiBu4XgJmJXSckR18FXSNc0II+e xMaQxAghjlxv3DtSrN/H30pqrqAbo/TXEGfoar67rK252904iDkGtPns4MBiVplVIpvyuOKttjwvJN PYkE9pTq6jz/zMeD/LxRaTvwgs8CxGIeqeA3ooEmXkyxuKIncVG+SNk3tEOPoBLjbwx20ALn+n0yDf VfqQJV+nrVunJrFiMW483YCw5E4wgY4Ln3zQSqncqgiitjaP2Jbyn/ZXTvQBFjp85GyMsT/mchyoog 2VKLajUDA+rRpYMW/YYZ3GPlOdwNss3i/eSg1+moD3+9vJwU3KiSBgBADWyz1M/0SkKE3Ftfi9OyVd 8uToWUkUeBWWXgyQx7wNYzuvjahqktiYzj3dWDrljeDT4cZDFRtQdtYwZ1Iw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated[1]. Replace struct ethtool_rxnfc's
"rule_locs" 0-length array with a flexible array. Detected with GCC 13,
using -fstrict-flex-arrays=3:

net/ethtool/common.c: In function 'ethtool_get_max_rxnfc_channel':
net/ethtool/common.c:558:55: warning: array subscript i is outside array bounds of '__u32[0]' {aka 'unsigned int[]'} [-Warray-bounds=]
  558 |                         .fs.location = info->rule_locs[i],
      |                                        ~~~~~~~~~~~~~~~^~~
In file included from include/linux/ethtool.h:19,
                 from include/uapi/linux/ethtool_netlink.h:12,
                 from include/linux/ethtool_netlink.h:6,
                 from net/ethtool/common.c:3:
include/uapi/linux/ethtool.h:1186:41: note: while referencing
'rule_locs'
 1186 |         __u32                           rule_locs[0];
      |                                         ^~~~~~~~~

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: kernel test robot <lkp@intel.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>
Cc: Sean Anderson <sean.anderson@seco.com>
Cc: Alexandru Tachici <alexandru.tachici@analog.com>
Cc: Amit Cohen <amcohen@nvidia.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3: don't use helper (vincent)
v2: https://lore.kernel.org/lkml/20230105233420.gonna.036-kees@kernel.org
---
 include/uapi/linux/ethtool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 58e587ba0450..3135fa0ba9a4 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1183,7 +1183,7 @@ struct ethtool_rxnfc {
 		__u32			rule_cnt;
 		__u32			rss_context;
 	};
-	__u32				rule_locs[0];
+	__u32				rule_locs[];
 };
 
 
-- 
2.34.1

