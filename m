Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741FA656DB8
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 18:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiL0Rw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 12:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiL0RwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 12:52:24 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBA8C759
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 09:52:22 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id z18so7060824ils.3
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 09:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DjJAv8+dz5qzkt//9ChBMXUYM3gLvgUmgzPulr1q5L8=;
        b=W9Oh1RHsibG9b5nJG2L0/G7avXFkSdVchArgZZ4h5wu33N7ck71irudkyLxayJmXeY
         Ln1EQeyGfQJ632VOCVTZKDZiHbpkxm1K5zFfLFnhAxnkBgWio3gqfHdXZauTqE9t0Qjs
         QsSzTuaqH7p7YzQnqcR2tKeguCIzFnIV4dSOJQVQvyeTxxtIFylTt5rmYp3QsHknV1aw
         W1UF0f9x8bH36XJCg+86qJ9CgYnQlzvBAuMmJX9w3hOU6wp+nM59qhCJVfpqHiwQJhmC
         Lbe70IOHCBpDkNJg8Y979NureLIk2lybRgXi4KrnJB4W1u+v3f71A1RwPjHZf7/USKkZ
         wjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DjJAv8+dz5qzkt//9ChBMXUYM3gLvgUmgzPulr1q5L8=;
        b=TqHewdZ5tJiHxISmgRo1PC+OFP29V6tTI//AQ5ggcxpIiPHSSGPojNEe5psBmK6oZK
         bkw+Ejy/jZ3/iK1MPRejOiyG24XGy/lOmZcjnkjP/RP/sAz+ZEQp7On9pzqXyFg+IBn3
         2LZn+gPQCbYgrBfKN7BxMbdMCvIMjC20DnEDJBcMAxe2vxWAFClWMFPJrk7K5XHiC8I6
         OgZLLy+yf18HYziNxUm8VniqrO5HcEdwyUHx36UzovWgDdHr9IzBBvP9JDbHW+xF/2to
         gCVu0DMeAQNarFuUu9IJyhll3lEnr5iWct8o9HQsn7sgnkgaNTFKtYiBb2deyBckxhKp
         WDMA==
X-Gm-Message-State: AFqh2kpoYGs1NTI2zTMe6wgvtcWK1hscgwUQLGFhCE4eeKgxl519WUQs
        ySqk1kpPGTwR0DHVVPMM1A0=
X-Google-Smtp-Source: AMrXdXvo50LS2QGR/NU5M5RNinqflT+zGyl73s2OP2xjAhM5T2/lxRGKGbvm/EA0dTkDfAv7w/NbZg==
X-Received: by 2002:a92:6511:0:b0:303:5f4c:a8f8 with SMTP id z17-20020a926511000000b003035f4ca8f8mr14124415ilb.29.1672163542190;
        Tue, 27 Dec 2022 09:52:22 -0800 (PST)
Received: from fedora.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id c37-20020a029628000000b00389de6759b8sm4519266jai.162.2022.12.27.09.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 09:52:21 -0800 (PST)
From:   Maxim Georgiev <glipus@gmail.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com
Subject: [PATCH ethtool-next] JSON output support for Netlink implementation of --show-ring option
Date:   Tue, 27 Dec 2022 10:52:21 -0700
Message-Id: <20221227175221.7762-1-glipus@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Add --json support for Netlink implementation of --show-ring option
No changes for non-JSON output for this featire.

Example output without --json:
[ethtool-git]$ /ethtool -g enp9s0u2u1u2
Ring parameters for enp9s0u2u1u2:
Pre-set maximums:
RX:		4096
RX Mini:	n/a
RX Jumbo:	n/a
TX:		n/a
Current hardware settings:
RX:		100
RX Mini:	n/a
RX Jumbo:	n/a
TX:		n/a
RX Buf Len:	n/a
CQE Size:	n/a
TX Push:	off
TCP data split:	n/a

Same output with --json:
[ethtool-git]$ ./ethtool --json -g enp9s0u2u1u2
[ {
        "ifname": "enp9s0u2u1u2",
        "rx-max": 4096,
        "rx": 100,
        "tx-push": false
    } ]

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
 ethtool.c       |  1 +
 netlink/rings.c | 35 +++++++++++++++++++++++++----------
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 60da8af..cf08a69 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5751,6 +5751,7 @@ static const struct option args[] = {
 	},
 	{
 		.opts	= "-g|--show-ring",
+		.json	= true,
 		.func	= do_gring,
 		.nlfunc	= nl_gring,
 		.help	= "Query RX/TX ring parameters"
diff --git a/netlink/rings.c b/netlink/rings.c
index 5996d5a..d51ef78 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -21,6 +21,9 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	DECLARE_ATTR_TB_INFO(tb);
 	struct nl_context *nlctx = data;
 	unsigned char tcp_hds;
+	char *tcp_hds_fmt;
+	char *tcp_hds_key;
+	char tcp_hds_buf[256];
 	bool silent;
 	int err_ret;
 	int ret;
@@ -34,16 +37,19 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	if (!dev_ok(nlctx))
 		return err_ret;
 
+	open_json_object(NULL);
+
 	if (silent)
-		putchar('\n');
-	printf("Ring parameters for %s:\n", nlctx->devname);
-	printf("Pre-set maximums:\n");
+		show_cr();
+	print_string(PRINT_ANY, "ifname", "Ring parameters for %s:\n",
+		     nlctx->devname);
+	print_string(PRINT_FP, NULL, "Pre-set maximums:\n", NULL);
 	show_u32("rx-max", "RX:\t\t", tb[ETHTOOL_A_RINGS_RX_MAX]);
 	show_u32("rx-mini-max", "RX Mini:\t", tb[ETHTOOL_A_RINGS_RX_MINI_MAX]);
 	show_u32("rx-jumbo-max", "RX Jumbo:\t",
 		 tb[ETHTOOL_A_RINGS_RX_JUMBO_MAX]);
 	show_u32("tx-max", "TX:\t\t", tb[ETHTOOL_A_RINGS_TX_MAX]);
-	printf("Current hardware settings:\n");
+	print_string(PRINT_FP, NULL, "Current hardware settings:\n", NULL);
 	show_u32("rx", "RX:\t\t", tb[ETHTOOL_A_RINGS_RX]);
 	show_u32("rx-mini", "RX Mini:\t", tb[ETHTOOL_A_RINGS_RX_MINI]);
 	show_u32("rx-jumbo", "RX Jumbo:\t", tb[ETHTOOL_A_RINGS_RX_JUMBO]);
@@ -52,24 +58,29 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	show_u32("cqe-size", "CQE Size:\t", tb[ETHTOOL_A_RINGS_CQE_SIZE]);
 	show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
 
+	tcp_hds_fmt = "TCP data split:\t%s\n";
+	tcp_hds_key = "tcp-data-split";
 	tcp_hds = tb[ETHTOOL_A_RINGS_TCP_DATA_SPLIT] ?
 		mnl_attr_get_u8(tb[ETHTOOL_A_RINGS_TCP_DATA_SPLIT]) : 0;
-	printf("TCP data split:\t");
 	switch (tcp_hds) {
 	case ETHTOOL_TCP_DATA_SPLIT_UNKNOWN:
-		printf("n/a\n");
+		print_string(PRINT_FP, tcp_hds_key, tcp_hds_fmt, "n/a");
 		break;
 	case ETHTOOL_TCP_DATA_SPLIT_DISABLED:
-		printf("off\n");
+		print_string(PRINT_ANY, tcp_hds_key, tcp_hds_fmt, "off");
 		break;
 	case ETHTOOL_TCP_DATA_SPLIT_ENABLED:
-		printf("on\n");
+		print_string(PRINT_ANY, tcp_hds_key, tcp_hds_fmt, "on");
 		break;
 	default:
-		printf("unknown(%d)\n", tcp_hds);
+		snprintf(tcp_hds_buf, sizeof(tcp_hds_buf),
+			 "unknown(%d)\n", tcp_hds);
+		print_string(PRINT_ANY, tcp_hds_key, tcp_hds_fmt, tcp_hds_buf);
 		break;
 	}
 
+	close_json_object();
+
 	return MNL_CB_OK;
 }
 
@@ -91,7 +102,11 @@ int nl_gring(struct cmd_context *ctx)
 				      ETHTOOL_A_RINGS_HEADER, 0);
 	if (ret < 0)
 		return ret;
-	return nlsock_send_get_request(nlsk, rings_reply_cb);
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, rings_reply_cb);
+	delete_json_obj();
+	return ret;
 }
 
 /* RINGS_SET */
-- 
2.38.1

