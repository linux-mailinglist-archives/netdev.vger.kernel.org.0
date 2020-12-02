Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6622CB552
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 07:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgLBGxh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 01:53:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3806 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728733AbgLBGxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 01:53:36 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B26jnsg012469
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 22:52:55 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355vfk31pn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 22:52:55 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 22:52:51 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 607A42ECA750; Tue,  1 Dec 2020 22:52:48 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 1/3] tools/bpftool: emit name <anon> for anonymous BTFs
Date:   Tue, 1 Dec 2020 22:52:41 -0800
Message-ID: <20201202065244.530571-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201202065244.530571-1-andrii@kernel.org>
References: <20201202065244.530571-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_01:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=916 malwarescore=0 spamscore=0 suspectscore=8 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For consistency of output, emit "name <anon>" for BTFs without the name. This
keeps output more consistent and obvious.

Suggested-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/btf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index ed5e97157241..bd46af6a61cc 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -750,6 +750,8 @@ show_btf_plain(struct bpf_btf_info *info, int fd,
 		printf("name [%s]  ", name);
 	else if (name && name[0])
 		printf("name %s  ", name);
+	else
+		printf("name <anon>  ");
 	printf("size %uB", info->btf_size);
 
 	n = 0;
-- 
2.24.1

