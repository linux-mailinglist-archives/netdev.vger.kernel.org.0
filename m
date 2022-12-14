Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C5D64C24C
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 03:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiLNClN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 21:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLNClM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 21:41:12 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F391A20BFF
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 18:41:10 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id s16so5976654iln.4
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 18:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7oZRp8bQZC5F08RxDb6m39mWDAxQlVDTXi97yZPrR38=;
        b=NWRg6H1yvlyfGjXLx9pGmOOVgAVcDt/GPI4b5XPA0WMxdrDy3PNEVbOKY2T5kc/naM
         N1mNUtfA3ciiZzNsWcYPen04zMrTP1INU8+9y0gCcoWHFl3ny173W8N4yu0U3Swnft37
         jt3RsrOdIZmyRsJ3LTFriiqSbeO4VGCaJ7ws+fwiRB49qhPB0Kf65cNFzBBxBjhUmO0E
         Pj4xoyji6k+u3uJ3RF3KNL0f7Lbz8ZSi2MJmBGuUcUjQl62jwwQM51pYiLQaLAH+Tqbu
         x/QHHHim8Dh56h1FlIknX59GJRRmHdpEslnyLMZXygwQuSt4xBT7pxXwAJf9Ia9YtweJ
         HHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7oZRp8bQZC5F08RxDb6m39mWDAxQlVDTXi97yZPrR38=;
        b=tGxCTs1B4qrdmu0s/hGR1ySKx+z1PLyajGxEQtKh/PlGnE3UHPv8kAWUEO3Xtcpsvt
         4sVnD3FVaqieWFQuqsUmiltZIboIk3b0J/AMCZCimYa32iYxPbw7sxhgGRfUZn+Ymg4r
         79MsHoz2Y2PwmmSpUnrGi+We9c1jLlJq/p9cOBLUBiZRhS24JJPmJ9ouKnF2imeustBX
         +JRdf7PsU45KgCTA+9I58HvxHT4lD0CCUOKejYBnYtJbFaaFlHrJoe7B7dLvfx4PwyjF
         d7TcfKnV97L8glPkHDDo1eEW9TBuNqnHQ0cc5zwrb1JRmC25YRAhQO+YhDlooEZ08NrC
         +MMA==
X-Gm-Message-State: ANoB5pkb26AorWiBoWZNGng0e4yCHu/8dgUw5ZBu9x3IY+olzNZ42gQK
        NlUgYpn2/QjMuB622FNNgZc=
X-Google-Smtp-Source: AA0mqf4dF1/RfKQ4qWjCatrl8W1TE1FF/HiWI8vXux+B6wIur+BXalmaXJIETuW6SPD68ZxRXpGj0g==
X-Received: by 2002:a92:6812:0:b0:300:b9be:74f9 with SMTP id d18-20020a926812000000b00300b9be74f9mr13087058ilc.21.1670985670204;
        Tue, 13 Dec 2022 18:41:10 -0800 (PST)
Received: from fedora.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id g14-20020a056e020d0e00b00300bcda1de6sm4217410ilj.35.2022.12.13.18.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 18:41:09 -0800 (PST)
From:   Maxim Georgiev <glipus@gmail.com>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH ethtool-next v2] JSON output support for Netlink implementation of --show-coalesce option
Date:   Tue, 13 Dec 2022 19:41:08 -0700
Message-Id: <20221214024108.11095-1-glipus@gmail.com>
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

Add --json support for Netlink implementation of --show-coalesce option
No changes for non-JSON output for this featire.

Example output without --json:
[ethtool-git]$ sudo ./ethtool --show-coalesce enp9s0u2u1u2
Coalesce parameters for enp9s0u2u1u2:
Adaptive RX: n/a  TX: n/a
stats-block-usecs:	n/a
sample-interval:	n/a
pkt-rate-low:		n/a
pkt-rate-high:		n/a

rx-usecs:	15000
rx-frames:	n/a
rx-usecs-irq:	n/a
rx-frames-irq:	n/a

tx-usecs:	0
tx-frames:	n/a
tx-usecs-irq:	n/a
tx-frames-irq:	n/a

rx-usecs-low:	n/a
rx-frame-low:	n/a
tx-usecs-low:	n/a
tx-frame-low:	n/a

rx-usecs-high:	n/a
rx-frame-high:	n/a
tx-usecs-high:	n/a
tx-frame-high:	n/a

CQE mode RX: n/a  TX: n/a

Same output with --json:
[ethtool-git]$ sudo ./ethtool --json --show-coalesce enp9s0u2u1u2
[ {
        "ifname": "enp9s0u2u1u2",
        "rx-usecs": 15000,
        "tx-usecs": 0
    } ]

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
Changes in v2:
- Moved the patch to ethtool-next branch
- Eliminated ':' in JSON key names
- Replaced the last 'putchar('\n')' call left in coalesce_reply_cb() with show_cr()

 ethtool.c          |  1 +
 netlink/channels.c | 18 +++++-----
 netlink/coalesce.c | 88 ++++++++++++++++++++++++++++++----------------
 netlink/netlink.h  | 24 ++++++++++---
 netlink/rings.c    | 21 +++++------
 5 files changed, 98 insertions(+), 54 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 3207e49..3b8412c 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5694,6 +5694,7 @@ static const struct option args[] = {
 	},
 	{
 		.opts	= "-c|--show-coalesce",
+		.json	= true,
 		.func	= do_gcoalesce,
 		.nlfunc	= nl_gcoalesce,
 		.help	= "Show coalesce options"
diff --git a/netlink/channels.c b/netlink/channels.c
index 894c74b..5cae227 100644
--- a/netlink/channels.c
+++ b/netlink/channels.c
@@ -37,15 +37,17 @@ int channels_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		putchar('\n');
 	printf("Channel parameters for %s:\n", nlctx->devname);
 	printf("Pre-set maximums:\n");
-	show_u32(tb[ETHTOOL_A_CHANNELS_RX_MAX], "RX:\t\t");
-	show_u32(tb[ETHTOOL_A_CHANNELS_TX_MAX], "TX:\t\t");
-	show_u32(tb[ETHTOOL_A_CHANNELS_OTHER_MAX], "Other:\t\t");
-	show_u32(tb[ETHTOOL_A_CHANNELS_COMBINED_MAX], "Combined:\t");
+	show_u32("rx-max", "RX:\t\t", tb[ETHTOOL_A_CHANNELS_RX_MAX]);
+	show_u32("tx-max", "TX:\t\t", tb[ETHTOOL_A_CHANNELS_TX_MAX]);
+	show_u32("other-max", "Other:\t\t", tb[ETHTOOL_A_CHANNELS_OTHER_MAX]);
+	show_u32("combined-max", "Combined:\t",
+		 tb[ETHTOOL_A_CHANNELS_COMBINED_MAX]);
 	printf("Current hardware settings:\n");
-	show_u32(tb[ETHTOOL_A_CHANNELS_RX_COUNT], "RX:\t\t");
-	show_u32(tb[ETHTOOL_A_CHANNELS_TX_COUNT], "TX:\t\t");
-	show_u32(tb[ETHTOOL_A_CHANNELS_OTHER_COUNT], "Other:\t\t");
-	show_u32(tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], "Combined:\t");
+	show_u32("rx", "RX:\t\t", tb[ETHTOOL_A_CHANNELS_RX_COUNT]);
+	show_u32("tx", "TX:\t\t", tb[ETHTOOL_A_CHANNELS_TX_COUNT]);
+	show_u32("other", "Other:\t\t", tb[ETHTOOL_A_CHANNELS_OTHER_COUNT]);
+	show_u32("combined", "Combined:\t",
+		 tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT]);
 
 	return MNL_CB_OK;
 }
diff --git a/netlink/coalesce.c b/netlink/coalesce.c
index 15037c2..3cc35ba 100644
--- a/netlink/coalesce.c
+++ b/netlink/coalesce.c
@@ -33,43 +33,64 @@ int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	if (!dev_ok(nlctx))
 		return err_ret;
 
+	open_json_object(NULL);
+
 	if (silent)
-		putchar('\n');
-	printf("Coalesce parameters for %s:\n", nlctx->devname);
+		show_cr();
+	print_string(PRINT_ANY, "ifname", "Coalesce parameters for %s:\n",
+		     nlctx->devname);
 	show_bool("rx", "Adaptive RX: %s  ",
 		  tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]);
 	show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]);
-	show_u32(tb[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS],
-		 "stats-block-usecs: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL],
-		 "sample-interval: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_PKT_RATE_LOW], "pkt-rate-low: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_PKT_RATE_HIGH], "pkt-rate-high: ");
-	putchar('\n');
-	show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS], "rx-usecs: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES], "rx-frames: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS_IRQ], "rx-usecs-irq: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ], "rx-frames-irq: ");
-	putchar('\n');
-	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS], "tx-usecs: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES], "tx-frames: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_IRQ], "tx-usecs-irq: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ], "tx-frames-irq: ");
-	putchar('\n');
-	show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS_LOW], "rx-usecs-low: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW], "rx-frame-low: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_LOW], "tx-usecs-low: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW], "tx-frame-low: ");
-	putchar('\n');
-	show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS_HIGH], "rx-usecs-high: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH], "rx-frame-high: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], "tx-usecs-high: ");
-	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], "tx-frame-high: ");
-	putchar('\n');
+	show_u32("stats-block-usecs", "stats-block-usecs:\t",
+		 tb[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS]);
+	show_u32("sample-interval", "sample-interval:\t",
+		 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL]);
+	show_u32("pkt-rate-low", "pkt-rate-low:\t\t",
+		 tb[ETHTOOL_A_COALESCE_PKT_RATE_LOW]);
+	show_u32("pkt-rate-high", "pkt-rate-high:\t\t",
+		 tb[ETHTOOL_A_COALESCE_PKT_RATE_HIGH]);
+	show_cr();
+	show_u32("rx-usecs", "rx-usecs:\t", tb[ETHTOOL_A_COALESCE_RX_USECS]);
+	show_u32("rx-frames", "rx-frames:\t",
+		 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES]);
+	show_u32("rx-usecs-irq", "rx-usecs-irq:\t",
+		 tb[ETHTOOL_A_COALESCE_RX_USECS_IRQ]);
+	show_u32("rx-frames-irq", "rx-frames-irq:\t",
+		 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ]);
+	show_cr();
+	show_u32("tx-usecs", "tx-usecs:\t", tb[ETHTOOL_A_COALESCE_TX_USECS]);
+	show_u32("tx-frames", "tx-frames:\t",
+		 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES]);
+	show_u32("tx-usecs-irq", "tx-usecs-irq:\t",
+		 tb[ETHTOOL_A_COALESCE_TX_USECS_IRQ]);
+	show_u32("tx-frames-irq", "tx-frames-irq:\t",
+		 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ]);
+	show_cr();
+	show_u32("rx-usecs-low", "rx-usecs-low:\t",
+		 tb[ETHTOOL_A_COALESCE_RX_USECS_LOW]);
+	show_u32("rx-frame-low", "rx-frame-low:\t",
+		 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW]);
+	show_u32("tx-usecs-low", "tx-usecs-low:\t",
+		 tb[ETHTOOL_A_COALESCE_TX_USECS_LOW]);
+	show_u32("tx-frame-low", "tx-frame-low:\t",
+		 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW]);
+	show_cr();
+	show_u32("rx-usecs-high", "rx-usecs-high:\t",
+		 tb[ETHTOOL_A_COALESCE_RX_USECS_HIGH]);
+	show_u32("rx-frame-high", "rx-frame-high:\t",
+		 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH]);
+	show_u32("tx-usecs-high", "tx-usecs-high:\t",
+		 tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH]);
+	show_u32("tx-frame-high", "tx-frame-high:\t",
+		 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]);
+	show_cr();
 	show_bool("rx", "CQE mode RX: %s  ",
 		  tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]);
 	show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]);
-	putchar('\n');
+	show_cr();
+
+	close_json_object();
 
 	return MNL_CB_OK;
 }
@@ -92,7 +113,12 @@ int nl_gcoalesce(struct cmd_context *ctx)
 				      ETHTOOL_A_COALESCE_HEADER, 0);
 	if (ret < 0)
 		return ret;
-	return nlsock_send_get_request(nlsk, coalesce_reply_cb);
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, coalesce_reply_cb);
+	delete_json_obj();
+	return ret;
+
 }
 
 /* COALESCE_SET */
diff --git a/netlink/netlink.h b/netlink/netlink.h
index f43c1bf..3240fca 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -100,12 +100,20 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 		    const char *between, const char *after,
 		    const char *if_none);
 
-static inline void show_u32(const struct nlattr *attr, const char *label)
+static inline void show_u32(const char *key,
+			    const char *fmt,
+			    const struct nlattr *attr)
 {
-	if (attr)
-		printf("%s%u\n", label, mnl_attr_get_u32(attr));
-	else
-		printf("%sn/a\n", label);
+	if (is_json_context()) {
+		if (attr)
+			print_uint(PRINT_JSON, key, NULL,
+				   mnl_attr_get_u32(attr));
+	} else {
+		if (attr)
+			printf("%s%u\n", fmt, mnl_attr_get_u32(attr));
+		else
+			printf("%sn/a\n", fmt);
+	}
 }
 
 static inline const char *u8_to_bool(const uint8_t *val)
@@ -132,6 +140,12 @@ static inline void show_bool(const char *key, const char *fmt,
 	show_bool_val(key, fmt, attr ? mnl_attr_get_payload(attr) : NULL);
 }
 
+static inline void show_cr(void)
+{
+	if (!is_json_context())
+		putchar('\n');
+}
+
 /* misc */
 
 static inline void copy_devname(char *dst, const char *src)
diff --git a/netlink/rings.c b/netlink/rings.c
index 6284035..5996d5a 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -38,17 +38,18 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		putchar('\n');
 	printf("Ring parameters for %s:\n", nlctx->devname);
 	printf("Pre-set maximums:\n");
-	show_u32(tb[ETHTOOL_A_RINGS_RX_MAX], "RX:\t\t");
-	show_u32(tb[ETHTOOL_A_RINGS_RX_MINI_MAX], "RX Mini:\t");
-	show_u32(tb[ETHTOOL_A_RINGS_RX_JUMBO_MAX], "RX Jumbo:\t");
-	show_u32(tb[ETHTOOL_A_RINGS_TX_MAX], "TX:\t\t");
+	show_u32("rx-max", "RX:\t\t", tb[ETHTOOL_A_RINGS_RX_MAX]);
+	show_u32("rx-mini-max", "RX Mini:\t", tb[ETHTOOL_A_RINGS_RX_MINI_MAX]);
+	show_u32("rx-jumbo-max", "RX Jumbo:\t",
+		 tb[ETHTOOL_A_RINGS_RX_JUMBO_MAX]);
+	show_u32("tx-max", "TX:\t\t", tb[ETHTOOL_A_RINGS_TX_MAX]);
 	printf("Current hardware settings:\n");
-	show_u32(tb[ETHTOOL_A_RINGS_RX], "RX:\t\t");
-	show_u32(tb[ETHTOOL_A_RINGS_RX_MINI], "RX Mini:\t");
-	show_u32(tb[ETHTOOL_A_RINGS_RX_JUMBO], "RX Jumbo:\t");
-	show_u32(tb[ETHTOOL_A_RINGS_TX], "TX:\t\t");
-	show_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN], "RX Buf Len:\t\t");
-	show_u32(tb[ETHTOOL_A_RINGS_CQE_SIZE], "CQE Size:\t\t");
+	show_u32("rx", "RX:\t\t", tb[ETHTOOL_A_RINGS_RX]);
+	show_u32("rx-mini", "RX Mini:\t", tb[ETHTOOL_A_RINGS_RX_MINI]);
+	show_u32("rx-jumbo", "RX Jumbo:\t", tb[ETHTOOL_A_RINGS_RX_JUMBO]);
+	show_u32("tx", "TX:\t\t", tb[ETHTOOL_A_RINGS_TX]);
+	show_u32("rx-buf-len", "RX Buf Len:\t", tb[ETHTOOL_A_RINGS_RX_BUF_LEN]);
+	show_u32("cqe-size", "CQE Size:\t", tb[ETHTOOL_A_RINGS_CQE_SIZE]);
 	show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
 
 	tcp_hds = tb[ETHTOOL_A_RINGS_TCP_DATA_SPLIT] ?
-- 
2.38.1

