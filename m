Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7755202820
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 05:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgFUDMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 23:12:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34722 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729165AbgFUDMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 23:12:05 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05L39cBN024547
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 20:12:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=JTtioOwaqlBFnLjjmXtUAWSeiiH9YwJAkmIrRDyDTAw=;
 b=eCnITYLCo2YEuh8w3Q4eEzow/ZvPhAwHwnQSq18t6ihqNewSTzARI8N+uby+SeO8h4gE
 95v11IVgP7etf4NUGtcWDJmrNEv1+cdE539CPD08PLux9+AbAe9AY0mGFpW4Bb56gKQ6
 lSjoF9vPcLKe+R2IBLGY0QPprM/l2W9pjkw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31shrt9y0r-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 20:12:05 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 20 Jun 2020 20:12:03 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 51D392EC2DFB; Sat, 20 Jun 2020 20:12:01 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] libbpf: forward-declare bpf_stats_type for systems with outdated UAPI headers
Date:   Sat, 20 Jun 2020 20:11:59 -0700
Message-ID: <20200621031159.2279101-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-20_16:2020-06-19,2020-06-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 mlxlogscore=642 cotscore=-2147483648
 clxscore=1015 mlxscore=0 phishscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006210024
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Systems that doesn't yet have the very latest linux/bpf.h header, enum
bpf_stats_type will be undefined, causing compilation warnings. Prevents =
this
by forward-declaring enum.

Fixes: 0bee106716cf ("libbpf: Add support for command BPF_ENABLE_STATS")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 1b6015b21ba8..dbef24ebcfcb 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -233,6 +233,8 @@ LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_size=
, char *log_buf,
 LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf=
,
 				 __u32 *buf_len, __u32 *prog_id, __u32 *fd_type,
 				 __u64 *probe_offset, __u64 *probe_addr);
+
+enum bpf_stats_type; /* defined in up-to-date linux/bpf.h */
 LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
=20
 #ifdef __cplusplus
--=20
2.24.1

