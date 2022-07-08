Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD97456BA3A
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 15:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbiGHNDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 09:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237443AbiGHNDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 09:03:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F132EA1B2;
        Fri,  8 Jul 2022 06:03:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPNlI6aUnSj+aBrUB2AlNWSlMmMLJ+OrFPOqo4WQ4FJ1hA54KjCpswjQgAY8g4eMGImH6WqnUet7MhN8Rt/4U6uM3IEJLcnW8AUTVnAsWLtqSW+OF44xtUTAeFmqQKtbtkwSaUNzALzDJ5HPSfjkeJk8KKMzqSw1NvXVgoytuQ2I1zaADH7+2W6hifCWuAIb4zlLnYawAiOcgd8HQi/KNidxfcIB37jvtGkjwG4chXIg/s2+175ux7vU3vrauPZTg1ack/9hut9bPtuBzOh9m9DjK00hHdh7zvwhYq4/42oVPTk2WRbpS4HZy+Br88am5+jEz+/YjakUAco1aEMdOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TwYAiMLEYWxpECEnOU8pJHLqwvlbYJxrhO27RukLDMU=;
 b=a8bFRm2CJnlmEZsHbggEkdvdZ0SrYdwLFWZw9HhfJGqMBRbz2ftzU0sSvGfGfoEGaE1q6+//EHERvH1Tk8LNG8v3vtcsGuu+yNnxMCqH6airYkP0khC0wh29iWZ3VHzhyzJIEBvlKeGY5B8QMOCikAWWdoN4J7XVXOYld0Ag8Ahm2m86bycIZxjqdyZ+XiQiIJ/Hhow2aK+J6V15HI/xycTVXUts7MztlkdtfG0B8lLHHCVs846ZcAJv5pjflMEyjOC7Z4la1/yOcLbtqChRM37iLCbcH6rbprH5fN+VPb2DAkmMbBMYxnFMgvALzNt8JE79mU7teUhbQ5m1FJwuFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwYAiMLEYWxpECEnOU8pJHLqwvlbYJxrhO27RukLDMU=;
 b=c3iF17CaMT8Sf8W8yQfWOBk7i5O+9b4VjxFdMNOA7VuLHs57GCTjZB8fnmJ5Tx2raC2VrESHkObEriabFdb3LT4Caz4+FkCvn04dGsoovKCtnNRYU9JJXXdwWpkXAbIL4vVpvgtTrQAjXF/5mC8C+7I1uavXwnd8+pwNyyVHX3ITeI1F0+AS+Uxi+GTwZli+iVK0xlDOX3ydCjjs+A8l+S5STnK170zHWRgHEBAhyEYe710zJY4CyBLaxNtPBOe2qHnYw3YV8/Dtn1Fv6NlgT6V8SEyX/wclMHIVKjdq6P0z6/ozlM6E+1XREG8K00Q3WEO5i3RbvRKxgzaNxqv9Mw==
Received: from DM6PR11CA0070.namprd11.prod.outlook.com (2603:10b6:5:14c::47)
 by MN2PR12MB4190.namprd12.prod.outlook.com (2603:10b6:208:1dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 13:03:29 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::da) by DM6PR11CA0070.outlook.office365.com
 (2603:10b6:5:14c::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17 via Frontend
 Transport; Fri, 8 Jul 2022 13:03:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Fri, 8 Jul 2022 13:03:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 8 Jul
 2022 13:03:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 8 Jul 2022
 06:03:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Fri, 8 Jul
 2022 06:03:23 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Shuah Khan <shuah@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
CC:     Yauheni Kaliuta <ykaliuta@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf] selftests/bpf: Fix xdp_synproxy build failure if CONFIG_NF_CONNTRACK=m/n
Date:   Fri, 8 Jul 2022 16:03:19 +0300
Message-ID: <20220708130319.1016294-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b65a0b8-00ce-4b1d-d923-08da60e240b6
X-MS-TrafficTypeDiagnostic: MN2PR12MB4190:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DVj+kyEkC4DWRTrH9wcJuPU5vG4van8l3qGDc4/hKRCBz7OSPzfz92x3t8y1Yv9QTtB/hZgEStnOP5AgFQKiOCqN41RGrCv+rCuVjl9Dlc6JMw1TPaY8I3lmSIsZN3E1i5007FcfFJSXZoSPBg+S3r7jQOsRCV/aSMWM9OIUBQTLvyrz9a9HOBBYQZNHV8QPWOaQGgqrMmlWoyF+Sn2Pk53YSy0vMG2aCe/suVKJYuj3ZGapjFzeKtOMJoiXTIR6vvzz8PPDU2Ts3W2x2RCNm6DqeE5atwQ8EbviPI4TR/Hr0BmmWaKFOp2RnXBqGZRrPtrhNBqo9JTRiw7a6U9GW/eCKYJYliTFuwaWJYmdC6JbEMINnxQNcxBjKrJOVuB3T47lMiFTvQbBzO+lDuteyFKVOKcOiGBG2ebtsV8ipNL9/BgvW0QCH71TfMbJlRmx83AyAfm6unHMeZZj4ZgdJtL8ERAauFoYj/gW1LT27RWFmC9tyyA0TQ8qyby07YycfHlY0Yqa4xeEpS8jNuwhPGUVlzh1ALyUbrT9d7mWPisAPmnOk449MzHy/Wa9piO4aPG6QzIjEX/tEqGjT/xHhvvZFDF3muzLUlTdHtlX5ExCt9fl0c60r6U7OxUN/h5OLYzJmdX/0WwKhmil/UIQWIr0F9+LmmEwiyL9UZKrESRMFTc4eA/7FLtbYjfGmEgtpscukkiCInqENJjXzDf+OKODRDAMAaQdd7lkKxBJUyNGoR2uAwE5TIKOP61hcodOuYVr203/CvsThL/V5/rFrFulzxkP3xcjvEpjG0nMaRwPKVNOvzpKoIH7vEDyounAsUj42pqeTvkVoYS3vl1+i6LDGkXREJ8qKziaAS/Wv2w=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(40470700004)(336012)(426003)(83380400001)(186003)(8676002)(110136005)(40480700001)(70206006)(47076005)(70586007)(1076003)(36756003)(4326008)(107886003)(26005)(54906003)(7696005)(2616005)(86362001)(82310400005)(41300700001)(7416002)(6666004)(356005)(2906002)(81166007)(316002)(5660300002)(36860700001)(478600001)(8936002)(40460700003)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 13:03:28.9696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b65a0b8-00ce-4b1d-d923-08da60e240b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4190
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_NF_CONNTRACK=m, struct bpf_ct_opts and enum member
BPF_F_CURRENT_NETNS are not exposed. This commit allows building the
xdp_synproxy selftest in such cases. Note that nf_conntrack must be
loaded before running the test if it's compiled as a module.

This commit also allows this selftest to be successfully compiled when
CONFIG_NF_CONNTRACK is disabled.

One unused local variable of type struct bpf_ct_opts is also removed.

Reported-by: Yauheni Kaliuta <ykaliuta@redhat.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie helpers")
---
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
index 9fd62e94b5e6..736686e903f6 100644
--- a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
+++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
@@ -77,16 +77,30 @@ struct {
 	__uint(max_entries, MAX_ALLOWED_PORTS);
 } allowed_ports SEC(".maps");
 
+/* Some symbols defined in net/netfilter/nf_conntrack_bpf.c are unavailable in
+ * vmlinux.h if CONFIG_NF_CONNTRACK=m, so they are redefined locally.
+ */
+
+struct bpf_ct_opts___local {
+	s32 netns_id;
+	s32 error;
+	u8 l4proto;
+	u8 dir;
+	u8 reserved[2];
+} __attribute__((preserve_access_index));
+
+#define BPF_F_CURRENT_NETNS (-1)
+
 extern struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx,
 					 struct bpf_sock_tuple *bpf_tuple,
 					 __u32 len_tuple,
-					 struct bpf_ct_opts *opts,
+					 struct bpf_ct_opts___local *opts,
 					 __u32 len_opts) __ksym;
 
 extern struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *skb_ctx,
 					 struct bpf_sock_tuple *bpf_tuple,
 					 u32 len_tuple,
-					 struct bpf_ct_opts *opts,
+					 struct bpf_ct_opts___local *opts,
 					 u32 len_opts) __ksym;
 
 extern void bpf_ct_release(struct nf_conn *ct) __ksym;
@@ -393,7 +407,7 @@ static __always_inline int tcp_dissect(void *data, void *data_end,
 
 static __always_inline int tcp_lookup(void *ctx, struct header_pointers *hdr, bool xdp)
 {
-	struct bpf_ct_opts ct_lookup_opts = {
+	struct bpf_ct_opts___local ct_lookup_opts = {
 		.netns_id = BPF_F_CURRENT_NETNS,
 		.l4proto = IPPROTO_TCP,
 	};
@@ -714,10 +728,6 @@ static __always_inline int syncookie_handle_ack(struct header_pointers *hdr)
 static __always_inline int syncookie_part1(void *ctx, void *data, void *data_end,
 					   struct header_pointers *hdr, bool xdp)
 {
-	struct bpf_ct_opts ct_lookup_opts = {
-		.netns_id = BPF_F_CURRENT_NETNS,
-		.l4proto = IPPROTO_TCP,
-	};
 	int ret;
 
 	ret = tcp_dissect(data, data_end, hdr);
-- 
2.30.2

