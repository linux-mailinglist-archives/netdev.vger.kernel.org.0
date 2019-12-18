Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765861254F0
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 22:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfLRVnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 16:43:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36010 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfLRVnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 16:43:53 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBILhmMD003640
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 13:43:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=4yUfY7Tjj7WNz8PiEy97qP9OQCzQNpzSlGf2IrDbw7w=;
 b=fwp1ManFKmbK+As9yZoqTl4ZnWQyc+L7u5fOQ9Zc8f7DTJm/AEv/MOJygbrJrMl0a5Kt
 MiXLpTSPeMCdWWiL1IqHDlDTZ9OwrpAE35eBzIxUCp15liqbto19VizftAW+wMvTXo7E
 ESbBaeAVGSY35QsCW71NuMEPLLGkLgWX0XU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wypvwhwqa-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 13:43:51 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Dec 2019 13:43:19 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2E5AA2EC1DF5; Wed, 18 Dec 2019 13:43:18 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpftool: simplify format string to not use positional args
Date:   Wed, 18 Dec 2019 13:43:14 -0800
Message-ID: <20191218214314.2403729-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_07:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=866 malwarescore=0 suspectscore=8 lowpriorityscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change format string referring to just single argument out of two available.
Some versions of libc can reject such format string.

Reported-by: Nikita Shirokov <tehnerd@tehnerd.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 8d93c8f90f82..851c465f99dc 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -567,9 +567,9 @@ static int do_skeleton(int argc, char **argv)
 			return -1;					    \n\
 		}							    \n\
 									    \n\
-		#endif /* %2$s */					    \n\
+		#endif /* %s */						    \n\
 		",
-		obj_name, header_guard);
+		header_guard);
 	err = 0;
 out:
 	bpf_object__close(obj);
-- 
2.17.1

