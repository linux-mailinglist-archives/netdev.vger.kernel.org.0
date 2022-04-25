Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C53350DCBD
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240182AbiDYJfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241502AbiDYJee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:34:34 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA66B27FC5
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 02:30:41 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id kq17so5277416ejb.4
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 02:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cs6ZiEgx8SyyS6hEEEQEYz4uH0qBIc6lrWRNFibpVV4=;
        b=vG4Hl6+sOJWxO5xvtzNp2wprln2e+BPXIQ8eRYUC3CvCfws9awwrSkKq2YS/4Ec/Fe
         4ZLahXNXntBNNm84EUBnlVb+X1KijnD9UwqLc55abOIa2wyB0/kKB80nylFcjwWL9gib
         dfE5DV3MUBxtbe+IMRK7a3qsHZ6BP3FzLOYkWTRKldOOL0HhvBNPBIprD2pYOCuI7fP0
         o8WSgH4Uv5i3cnZtW4vOIAM0MXuMOVaaXbN0Pt7diyeFil4+1Us7uqta0INDMyfVUbZ+
         n92xNAS0z6MP0sx4V/dbJ+tP6Pg61dXL8x2qSKWyqf0dc1NsWz4jiKT/TqGOuJEXgCxb
         NGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cs6ZiEgx8SyyS6hEEEQEYz4uH0qBIc6lrWRNFibpVV4=;
        b=2X4By0wGCStvhWTDr7a/fNGBekRGPDdYGoTCQ1Awz1L4byZN4UlPccKAfuecB8j04e
         9SqwiNjKFwggPDT0McgI4vCDNd+1vP+nTLLbH9j4jxNpfWy55ckhtzLwRMMcsohHldIf
         EFxosiMHXiwJe1B+GKv2xWcSzlHxjlOVas0oLFd5peSX+LTHqqFb+8s3/fysQFFrPWUo
         dyyL0pOZhlcFJEVVc3Mm2ntwiDmgDE5UJzg+vcVPGsSHwvmBNMP50NN9CfbiWGYSWwsv
         LsS0tp3J3kcpvA4iSKu3hmqQg1+Mbi+nhCyDx61FfBEhd/RnPEdS19Z9FLAnLBpTKbKE
         KN3A==
X-Gm-Message-State: AOAM531+jt1PrRyi1CDhpM3EP7/YKzaHM9iwjcmXx1idee33ABjrdRaU
        8CpBPtXU9aX0pHeAC73TC0INX5ebH9jjDdcZ
X-Google-Smtp-Source: ABdhPJxbt2HeF3ABH1M4w5awlOpwce4PAvObCa1VLyoDksQR0JC18GFG6U2zKi3h0zj9D5Q1ltsRaw==
X-Received: by 2002:a17:907:105d:b0:6f3:a3ea:cdfd with SMTP id oy29-20020a170907105d00b006f3a3eacdfdmr481964ejb.704.1650879039729;
        Mon, 25 Apr 2022 02:30:39 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t22-20020a50d716000000b00425b6799dc4sm4389359edi.71.2022.04.25.02.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 02:30:38 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, snelson@pensando.io
Subject: [patch iproute2-next v2] devlink: introduce -h[ex] cmdline option to allow dumping numbers in hex format
Date:   Mon, 25 Apr 2022 11:30:36 +0200
Message-Id: <20220425093036.1518107-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

For health reporter dumps it is quite convenient to have the numbers in
hexadecimal format. Introduce a command line option to allow user to
achieve that output.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- changed the hex output option to "-x"
- added "0x" prefix to hex numbers
---
 devlink/devlink.c  | 19 +++++++++++++------
 man/man8/devlink.8 |  4 ++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index da9f97788bcf..7ace968ca081 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -367,6 +367,7 @@ struct dl {
 	bool pretty_output;
 	bool verbose;
 	bool stats;
+	bool hex;
 	struct {
 		bool present;
 		char *bus_name;
@@ -8044,6 +8045,8 @@ static int cmd_health_dump_clear(struct dl *dl)
 
 static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 {
+	const char *num_fmt = dl->hex ? "%#x" : "%u";
+	const char *num64_fmt = dl->hex ? "%#"PRIx64 : "%"PRIu64;
 	uint8_t *data;
 	uint32_t len;
 
@@ -8053,16 +8056,16 @@ static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 		print_bool(PRINT_ANY, NULL, "%s", mnl_attr_get_u8(nl_data));
 		break;
 	case MNL_TYPE_U8:
-		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u8(nl_data));
+		print_uint(PRINT_ANY, NULL, num_fmt, mnl_attr_get_u8(nl_data));
 		break;
 	case MNL_TYPE_U16:
-		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u16(nl_data));
+		print_uint(PRINT_ANY, NULL, num_fmt, mnl_attr_get_u16(nl_data));
 		break;
 	case MNL_TYPE_U32:
-		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u32(nl_data));
+		print_uint(PRINT_ANY, NULL, num_fmt, mnl_attr_get_u32(nl_data));
 		break;
 	case MNL_TYPE_U64:
-		print_u64(PRINT_ANY, NULL, "%"PRIu64, mnl_attr_get_u64(nl_data));
+		print_u64(PRINT_ANY, NULL, num64_fmt, mnl_attr_get_u64(nl_data));
 		break;
 	case MNL_TYPE_NUL_STRING:
 		print_string(PRINT_ANY, NULL, "%s", mnl_attr_get_str(nl_data));
@@ -8928,7 +8931,7 @@ static void help(void)
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
 	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
-	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
+	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] -[he]x }\n");
 }
 
 static int dl_cmd(struct dl *dl, int argc, char **argv)
@@ -9042,6 +9045,7 @@ int main(int argc, char **argv)
 		{ "statistics",		no_argument,		NULL, 's' },
 		{ "Netns",		required_argument,	NULL, 'N' },
 		{ "iec",		no_argument,		NULL, 'i' },
+		{ "hex",		no_argument,		NULL, 'x' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -9057,7 +9061,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:i",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:ix",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -9095,6 +9099,9 @@ int main(int argc, char **argv)
 		case 'i':
 			use_iec = true;
 			break;
+		case 'x':
+			dl->hex = true;
+			break;
 		default:
 			pr_err("Unknown option.\n");
 			help();
diff --git a/man/man8/devlink.8 b/man/man8/devlink.8
index 840cf44cf97b..de53061bc880 100644
--- a/man/man8/devlink.8
+++ b/man/man8/devlink.8
@@ -63,6 +63,10 @@ Switches to the specified network namespace.
 .BR "\-i", " --iec"
 Print human readable rates in IEC units (e.g. 1Ki = 1024).
 
+.TP
+.BR "\-x", " --hex"
+Print dump numbers in hexadecimal format.
+
 .SS
 .I OBJECT
 
-- 
2.35.1

