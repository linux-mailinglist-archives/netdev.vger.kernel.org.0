Return-Path: <netdev+bounces-193-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8FAE6F5D55
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 19:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F3471C20F14
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 17:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B3C2771A;
	Wed,  3 May 2023 17:52:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A482F3A
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 17:52:36 +0000 (UTC)
X-Greylist: delayed 1088 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 May 2023 10:52:34 PDT
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741D95FDF
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:52:33 -0700 (PDT)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
	by mx0b-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343H68L0024435
	for <netdev@vger.kernel.org>; Wed, 3 May 2023 18:34:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=5tTFB/xCB62yzG69mg2ySPLaaGHxjaYUNdoYOsUXIKg=;
 b=X6cqt1xKkAWaSuDoeHCcWOfEUU79ZShC641ULLQjQyxTYzM01QQgwBEhO22BHNKxgQzc
 8IsNcS712lzNI8yWnZRrLJV5RM1UuKiAbEpHBrSAZueryzThacsBLLHntm0LmC5b9ulU
 if6bMmChDWSEZUgFQHkH8CYvklufoCrmvezqAeSUwUxGYBwCZkx1+619WfNeZxnQkrKX
 /Ii+xFfNF/O1vzhphHvJUXYRE3Jc0vpFRBTztp1yatZNDjxcyTVhmogozYhS5ST4Pstb
 Kx8tgmovHFzRK6A6yOPBN2Zv1iklDGRAcmqueZrd97GUm5a9+pR5PFrCoBr0JOGWLWR+ TQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
	by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 3q8r423m7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netdev@vger.kernel.org>; Wed, 03 May 2023 18:34:35 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
	by prod-mail-ppoint1.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 343GMxaH013968
	for <netdev@vger.kernel.org>; Wed, 3 May 2023 13:34:35 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.24])
	by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3q8xjyhs1m-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netdev@vger.kernel.org>; Wed, 03 May 2023 13:34:34 -0400
Received: from bos-lhv018.bos01.corp.akamai.com (172.28.222.198) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 3 May 2023 13:34:34 -0400
From: Max Tottenham <mtottenh@akamai.com>
To: <netdev@vger.kernel.org>
CC: <johunt@akamai.com>, Max Tottenham <mtottenh@akamai.com>
Subject: [RFC PATCH iproute2] Add ability to specify eBPF pin path
Date: Wed, 3 May 2023 13:33:49 -0400
Message-ID: <20230503173348.703437-2-mtottenh@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230503173348.703437-1-mtottenh@akamai.com>
References: <20230503173348.703437-1-mtottenh@akamai.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.28.222.198]
X-ClientProxiedBy: usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_12,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=632 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305030150
X-Proofpoint-ORIG-GUID: OInuyXvgqV-ZuZWQ6ggk3yrg9LhMOV3p
X-Proofpoint-GUID: OInuyXvgqV-ZuZWQ6ggk3yrg9LhMOV3p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_12,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=647
 mlxscore=0 spamscore=0 clxscore=1015 adultscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030150
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

---
 include/bpf_util.h |  1 +
 lib/bpf_legacy.c   | 11 +++++++++--
 lib/bpf_libbpf.c   | 16 +++++++++-------
 tc/f_bpf.c         |  4 +++-
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/bpf_util.h b/include/bpf_util.h
index 6a5f8ec6..e7ad643b 100644
--- a/include/bpf_util.h
+++ b/include/bpf_util.h
@@ -70,6 +70,7 @@ struct bpf_cfg_in {
 	const char *section;
 	const char *prog_name;
 	const char *uds;
+	const char *pin_path;
 	enum bpf_prog_type type;
 	enum bpf_mode mode;
 	__u32 ifindex;
diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 8ac64235..18b2760c 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -827,7 +827,7 @@ static int bpf_obj_pinned(const char *pathname, enum bpf_prog_type type)
 
 static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 {
-	const char *file, *section, *uds_name, *prog_name;
+	const char *file, *section, *uds_name, *prog_name, *pin_path;
 	bool verbose = false;
 	int i, ret, argc;
 	char **argv;
@@ -858,7 +858,7 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 	}
 
 	NEXT_ARG();
-	file = section = uds_name = prog_name = NULL;
+	file = section = uds_name = prog_name = pin_path = NULL;
 	if (cfg->mode == EBPF_OBJECT || cfg->mode == EBPF_PINNED) {
 		file = *argv;
 		NEXT_ARG_FWD();
@@ -901,6 +901,12 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 			NEXT_ARG_FWD();
 		}
 
+		if (argc > 0 && strcmp(*argv, "pin_path") == 0) {
+			NEXT_ARG();
+			pin_path = *argv;
+			NEXT_ARG_FWD();
+		}
+
 		if (__bpf_prog_meta[cfg->type].may_uds_export) {
 			uds_name = getenv(BPF_ENV_UDS);
 			if (argc > 0 && !uds_name &&
@@ -939,6 +945,7 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 	cfg->argv    = argv;
 	cfg->verbose = verbose;
 	cfg->prog_name = prog_name;
+	cfg->pin_path = pin_path;
 
 	return ret;
 }
diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index e1c211a1..6c4e18f7 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -226,7 +226,7 @@ static int handle_legacy_maps(struct bpf_object *obj)
 
 	bpf_object__for_each_map(map, obj) {
 		map_name = bpf_map__name(map);
-
+		fprintf(stderr, "Processing map: %s\n", map_name);
 		ret = handle_legacy_map_in_map(obj, map, map_name);
 		if (ret)
 			return ret;
@@ -277,16 +277,18 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 	char root_path[PATH_MAX];
 	struct bpf_map *map;
 	int prog_fd, ret = 0;
-
-	ret = iproute2_get_root_path(root_path, PATH_MAX);
-	if (ret)
-		return ret;
-
+	if (cfg->pin_path) {
+		strncpy(root_path , cfg->pin_path, PATH_MAX);
+	} else {
+		ret = iproute2_get_root_path(root_path, PATH_MAX);
+		if (ret)
+			return ret;
+	}
 	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts,
 			.relaxed_maps = true,
 			.pin_root_path = root_path,
 	);
-
+	fprintf(stderr, "About to bpf_object__open_file()\n");
 	obj = bpf_object__open_file(cfg->object, &open_opts);
 	if (libbpf_get_error(obj)) {
 		fprintf(stderr, "ERROR: opening BPF object file failed\n");
diff --git a/tc/f_bpf.c b/tc/f_bpf.c
index a6d4875f..4eb3e817 100644
--- a/tc/f_bpf.c
+++ b/tc/f_bpf.c
@@ -28,7 +28,7 @@ static void explain(void)
 		"\n"
 		"eBPF use case:\n"
 		" object-file FILE [ section CLS_NAME ] [ export UDS_FILE ]"
-		" [ verbose ] [ direct-action ] [ skip_hw | skip_sw ]\n"
+		" [ verbose ] [ direct-action ] [ skip_hw | skip_sw ] [pin_path PATH]\n"
 		" object-pinned FILE [ direct-action ] [ skip_hw | skip_sw ]\n"
 		"\n"
 		"Common remaining options:\n"
@@ -48,6 +48,8 @@ static void explain(void)
 		"Where UDS_FILE points to a unix domain socket file in order\n"
 		"to hand off control of all created eBPF maps to an agent.\n"
 		"\n"
+		"Where PATH points to a path under bpffs where all eBPF maps will be pinned.\n"
+		"\n"
 		"ACTION_SPEC := ... look at individual actions\n"
 		"NOTE: CLASSID is parsed as hexadecimal input.\n",
 		bpf_prog_to_default_section(bpf_type));
-- 
2.25.1


