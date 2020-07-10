Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37B221C0B4
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 01:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgGJX0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 19:26:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49508 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726328AbgGJX0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 19:26:32 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ANQVmk026540
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 16:26:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=d80Mi8EwvifTnkw14/d1LZC8MymGdbwtk7pITsmLEEA=;
 b=PuB8Mfb80Hj1xq4D7zGzlHKlTGoj/p5T1HQOewA206ui6ZR8PfjKs0ZSqXSFcouZdRG7
 2K+y1gGrkYJEGQBPxKIgnEaucqM6fHPjcKZ5WcVXVORtV71SRiHv04yabhUlGEQBWnBY
 kim60gOXK1+4Bj3qYApT0uP/dLppf8koiug= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 326yxdrgn6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 16:26:32 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 10 Jul 2020 16:26:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8DCD22EC3D5F; Fri, 10 Jul 2020 16:26:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] tools/bpftool: remove warning about PID iterator support
Date:   Fri, 10 Jul 2020 16:26:04 -0700
Message-ID: <20200710232605.20918-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-10_14:2020-07-10,2020-07-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=801 phishscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't emit warning that bpftool was built without PID iterator support. T=
his
error garbles JSON output of otherwise perfectly valid show commands.

Reported-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/pids.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index c0d23ce4a6f4..e3b116325403 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -15,7 +15,6 @@
=20
 int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type=
 type)
 {
-	p_err("bpftool built without PID iterator support");
 	return -ENOTSUP;
 }
 void delete_obj_refs_table(struct obj_refs_table *table) {}
--=20
2.24.1

