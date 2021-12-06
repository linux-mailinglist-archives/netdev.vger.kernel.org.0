Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFD646AE44
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377319AbhLFXLz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Dec 2021 18:11:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357400AbhLFXLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:11:54 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6MkHsD024864
        for <netdev@vger.kernel.org>; Mon, 6 Dec 2021 15:08:25 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cscujp3av-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 15:08:25 -0800
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 15:08:23 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id DC73824453F2C; Mon,  6 Dec 2021 15:08:20 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <acme@kernel.org>, <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH bpf-next] perf/bpf_counter: use bpf_map_create instead of bpf_create_map
Date:   Mon, 6 Dec 2021 15:08:11 -0800
Message-ID: <20211206230811.4131230-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: 5MZM0WQ7zaSHznc-Mv0HAcHzszZxBQoN
X-Proofpoint-GUID: 5MZM0WQ7zaSHznc-Mv0HAcHzszZxBQoN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-06_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 adultscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_create_map is deprecated. Replace it with bpf_map_create.

Fixes: 992c4225419a ("libbpf: Unify low-level map creation APIs w/ new bpf_map_create()")
Signed-off-by: Song Liu <song@kernel.org>
---
 tools/perf/util/bpf_counter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index c17d4a43ce065..ed150a9b3a0c0 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -320,10 +320,10 @@ static int bperf_lock_attr_map(struct target *target)
 	}
 
 	if (access(path, F_OK)) {
-		map_fd = bpf_create_map(BPF_MAP_TYPE_HASH,
+		map_fd = bpf_map_create(BPF_MAP_TYPE_HASH, NULL,
 					sizeof(struct perf_event_attr),
 					sizeof(struct perf_event_attr_map_entry),
-					ATTR_MAP_SIZE, 0);
+					ATTR_MAP_SIZE, NULL);
 		if (map_fd < 0)
 			return -1;
 
-- 
2.30.2

