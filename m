Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84856D03D8
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfJHXKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:10:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58054 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725908AbfJHXKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:10:23 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x98N9tQn013491
        for <netdev@vger.kernel.org>; Tue, 8 Oct 2019 16:10:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=DSNf8hp9g/dB7otY6SnpKCQZcvrcUL9LROymFzvmQ5Q=;
 b=NOybpX3nFdNRaBre8S7GaPopXTfU25RwRGUhJWjeiz7vaKrs2EgNZKQHeK2+68ANpipi
 WV8/5WUfN+vLlNT1ljMNGzxRU0LUHThMdBvH6BLdd+uVFMdLpBM8reW5cA0I31RaKERi
 GiPsZXywiZL5PH91wPC3PpM3kc0KgHXpNgw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgvbytyjf-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:10:22 -0700
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 8 Oct 2019 16:10:11 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E42F98618FA; Tue,  8 Oct 2019 16:10:10 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/3] Fix BTF-to-C converter's padding generation
Date:   Tue, 8 Oct 2019 16:10:05 -0700
Message-ID: <20191008231009.2991130-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_09:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 suspectscore=8 mlxlogscore=827 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix BTF-to-C logic of handling padding at the end of a struct. Fix existing
test that should have captured this. Also move test_btf_dump into a test_progs
test to leverage common infrastructure.

Andrii Nakryiko (3):
  libbpf: fix struct end padding in btf_dump
  selftests/bpf: convert test_btf_dump into test_progs test
  selftests/bpf: fix btf_dump padding test case

 tools/lib/bpf/btf_dump.c                      |  8 +-
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../btf_dump.c}                               | 88 +++++++------------
 .../bpf/progs/btf_dump_test_case_padding.c    |  5 +-
 4 files changed, 46 insertions(+), 57 deletions(-)
 rename tools/testing/selftests/bpf/{test_btf_dump.c => prog_tests/btf_dump.c} (51%)

-- 
2.17.1

