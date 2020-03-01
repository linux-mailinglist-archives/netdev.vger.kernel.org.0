Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34C1174C06
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 07:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgCAGYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 01:24:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32692 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726094AbgCAGYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 01:24:53 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0216OpLU005104
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 22:24:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=c/QX5W/r2mwr9/SDP1vw/TZfdqkWHOQPMXu2BQAiUy8=;
 b=IgXbBlJWF/1ULeJyms8SlntDxSUnzbHsKadG7SmfwHbba7Y1LcdEp7UH+rfXvOssrfXT
 HOdip+YvYSGHp3wiUe+YILOMyQUvpFoUzyW/cbzxJMsPWxYwlhqk0ZGcrZIGEjuMx8fH
 wkKXP/LzsQ4GAgOEnk48Ce4wa4oKyboV/OE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2yfmguk7un-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 22:24:52 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 22:24:16 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 153CC2EC2CFD; Sat, 29 Feb 2020 22:24:15 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] tools/runqslower: drop copy/pasted BPF_F_CURRENT_CPU definiton
Date:   Sat, 29 Feb 2020 22:24:05 -0800
Message-ID: <20200301062405.2850114-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200301062405.2850114-1-andriin@fb.com>
References: <20200301062405.2850114-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_01:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 suspectscore=8 impostorscore=0
 mlxlogscore=775 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With BPF_F_CURRENT_CPU being an enum, it is now captured in vmlinux.h and is
readily usable by runqslower. So drop local copy/pasted definition in favor of
the one coming from vmlinux.h.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/runqslower/runqslower.bpf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
index 48a39f72fadf..0ba501305bad 100644
--- a/tools/bpf/runqslower/runqslower.bpf.c
+++ b/tools/bpf/runqslower/runqslower.bpf.c
@@ -6,9 +6,6 @@
 
 #define TASK_RUNNING 0
 
-#define BPF_F_INDEX_MASK		0xffffffffULL
-#define BPF_F_CURRENT_CPU		BPF_F_INDEX_MASK
-
 const volatile __u64 min_us = 0;
 const volatile pid_t targ_pid = 0;
 
-- 
2.17.1

