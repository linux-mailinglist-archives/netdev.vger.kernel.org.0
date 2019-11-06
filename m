Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20EDF1C91
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbfKFRhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:37:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63382 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727286AbfKFRhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 12:37:20 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA6HbBDl026862
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 09:37:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Nj7rvl/wLad+h5Td+KHDBVmi8A0VUl1Ru23PmARYP74=;
 b=UppDPNUPMkeCQu7igm1kCpsWKO4P8GQS0IQyUivugLQzJ1lozODs1ZHXZiddIyqtmu8k
 /+MP8pM7qL7Y7QVIhZu2PQQRAHAC/+m2FvXm6LV1CPcWNH8VA6k4JZMvGBlW2+hCIhoc
 KQOVEMmWPzEEYl+ktJ2D+shCA+yKNMSDry4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2w41vc8a2u-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 09:37:19 -0800
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 09:37:03 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 599AB2EC18E9; Wed,  6 Nov 2019 09:37:02 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bps: clean up removed ints relocations negative tests
Date:   Wed, 6 Nov 2019 09:36:59 -0800
Message-ID: <20191106173659.1978131-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_06:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=691 impostorscore=0 adultscore=0 priorityscore=1501
 suspectscore=8 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911060170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of 42765ede5c54 ("selftests/bpf: Remove too strict field offset relo
test cases"), few ints relocations negative (supposed to fail) tests were
removed, but not completely. Due to them being negative, some leftovers in
prog_tests/core_reloc.c went unnoticed. Clean them up.

Fixes: 42765ede5c54 ("selftests/bpf: Remove too strict field offset relo test cases")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 00f1f3229542..f94bd071536b 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -337,12 +337,6 @@ static struct core_reloc_test_case test_cases[] = {
 	INTS_CASE(ints___bool),
 	INTS_CASE(ints___reverse_sign),
 
-	INTS_ERR_CASE(ints___err_bitfield),
-	INTS_ERR_CASE(ints___err_wrong_sz_8),
-	INTS_ERR_CASE(ints___err_wrong_sz_16),
-	INTS_ERR_CASE(ints___err_wrong_sz_32),
-	INTS_ERR_CASE(ints___err_wrong_sz_64),
-	
 	/* validate edge cases of capturing relocations */
 	{
 		.case_name = "misc",
-- 
2.17.1

