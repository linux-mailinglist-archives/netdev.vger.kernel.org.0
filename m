Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B5F54561E
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 23:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbiFIVFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 17:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiFIVFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 17:05:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C034265230
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 14:05:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so453302pju.1
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 14:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VEf6uJJ9Rqn3qK0MT0WXSjL5ADmXkgwO2f5jI1otFnA=;
        b=bodoldQsaK/6tGeVwAdLiDyOwDQr5fMo+hPcss6tLiDowflDbkzyQ9XhaLi2DHvmut
         enneli+66p33T+CgC18lkQpyJTjrkettqhw2AMN8IIF/fXoIyuUB6FH9mW6Wj+E3HIMq
         G2lKkNiFPkXYqLcgqlk20yY70lafO/KNYdQ5Y5ZZH3vEWDmaUZxYzndrruZ5J0VmLJRD
         2oZ2pvtY0WGR8d3FtXk+XzUrEZKhq0YIcYtQRimSXGhvmGZJlcszq+d9XOBZlW7OVITv
         o/ehZDDWX/i+sgyCi4Ejm0eegSLbFJtFNtJH2SnH85Meopyv/JxQiRsTBk6YtqLwl3Jc
         hoJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VEf6uJJ9Rqn3qK0MT0WXSjL5ADmXkgwO2f5jI1otFnA=;
        b=z/I9ojOWpRLQA0ngv/+BoFipKCgabAFFNEZ9oNC/qkn2xR95IgQfqCOwNhWmhWi7jB
         9vMl+w/q4To+PRKiYC1DaxqHVjXr7IENMGg9S+dcbYENxx63kxE0tM+vfQPcKElxUzSl
         T9Hg7xWb25/fc2NhketNj1gUPJwo4g7xV6pLxTfcQmtW9n6CPskqHGujj6TOsknsa9+G
         lr82gj1KFsvI2NI8IGuhCV55Qn99VzkskFDVUIzAa8qE93khnWutJpioK6wOgegO/Z+N
         XgA/+On4dzYcdWWMcBoVwYndIkxQuLOjk29tKsKFFIaFFs2U+Wi0Hx5Y1RaqETil9gfC
         Nipw==
X-Gm-Message-State: AOAM533Oyg8gefoOvTaFpwiqWU0nkuhwJCWhOWkCWMYIJpu0djlHdyxo
        shwOEYpOi+uLxR+K72dCbC0=
X-Google-Smtp-Source: ABdhPJywoIVGlqEMvq772NUVtlcd8L5QVJFcdOvvx1JtKfYbCV1XtkMX0mKmwD+LlRfUr8R4YJD1sQ==
X-Received: by 2002:a17:90a:b894:b0:1e2:d8f8:41e9 with SMTP id o20-20020a17090ab89400b001e2d8f841e9mr5168585pjr.20.1654808721443;
        Thu, 09 Jun 2022 14:05:21 -0700 (PDT)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id b15-20020a170903228f00b001620960f1dfsm17371447plh.198.2022.06.09.14.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 14:05:20 -0700 (PDT)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
Subject: [PATCH iproute2-next v2] show rx_otherehost_dropped stat in ip link show
Date:   Thu,  9 Jun 2022 21:05:16 +0000
Message-Id: <20220609210516.2311379-1-jeffreyjilinux@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
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

From: Jeffrey Ji <jeffreyji@google.com>

This stat was added in commit 794c24e9921f ("net-core: rx_otherhost_dropped to core_stats")

Tested: sent packet with wrong MAC address from 1
network namespace to another, verified that counter showed "1" in
`ip -s -s link sh` and `ip -s -s -j link sh`

Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
---
changelog:
v2: otherhost <- otherhost_dropped

 ip/ipaddress.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 142731933ba3..d7d047cf901e 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -692,6 +692,7 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		strlen("heartbt"),
 		strlen("overrun"),
 		strlen("compressed"),
+		strlen("otherhost"),
 	};
 
 	if (is_json_context()) {
@@ -730,6 +731,10 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 			if (s->rx_nohandler)
 				print_u64(PRINT_JSON,
 					   "nohandler", NULL, s->rx_nohandler);
+			if (s->rx_otherhost_dropped)
+				print_u64(PRINT_JSON,
+					   "otherhost", NULL,
+					   s->rx_otherhost_dropped);
 		}
 		close_json_object();
 
@@ -778,7 +783,8 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 			size_columns(cols, ARRAY_SIZE(cols), 0,
 				     s->rx_length_errors, s->rx_crc_errors,
 				     s->rx_frame_errors, s->rx_fifo_errors,
-				     s->rx_over_errors, s->rx_nohandler);
+				     s->rx_over_errors, s->rx_nohandler,
+				     s->rx_otherhost_dropped);
 		size_columns(cols, ARRAY_SIZE(cols),
 			     s->tx_bytes, s->tx_packets, s->tx_errors,
 			     s->tx_dropped, s->tx_carrier_errors,
@@ -811,11 +817,14 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		/* RX error stats */
 		if (show_stats > 1) {
 			fprintf(fp, "%s", _SL_);
-			fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s %*s%s",
+			fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s%*s%*s%s",
 				cols[0] - 10, "", cols[1], "length",
 				cols[2], "crc", cols[3], "frame",
 				cols[4], "fifo", cols[5], "overrun",
-				cols[6], s->rx_nohandler ? "nohandler" : "",
+				s->rx_nohandler ? cols[6] + 1 : 0,
+				s->rx_nohandler ? " nohandler" : "",
+				s->rx_otherhost_dropped ? cols[7] + 1 : 0,
+				s->rx_otherhost_dropped ? " otherhost" : "",
 				_SL_);
 			fprintf(fp, "%*s", cols[0] + 5, "");
 			print_num(fp, cols[1], s->rx_length_errors);
@@ -825,6 +834,9 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 			print_num(fp, cols[5], s->rx_over_errors);
 			if (s->rx_nohandler)
 				print_num(fp, cols[6], s->rx_nohandler);
+			if (s->rx_otherhost_dropped)
+				print_num(fp, cols[7],
+				s->rx_otherhost_dropped);
 		}
 		fprintf(fp, "%s", _SL_);
 
-- 
2.36.1.476.g0c4daa206d-goog

