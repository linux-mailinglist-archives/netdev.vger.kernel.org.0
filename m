Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A8925C06
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 05:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfEVDO0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 23:14:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727930AbfEVDO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 23:14:26 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4M37gBc019577
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 20:14:24 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2smcnpuj2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 20:14:24 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 21 May 2019 20:14:23 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id D0813760CB3; Tue, 21 May 2019 20:14:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/3] bpf: increase jmp sequence limit
Date:   Tue, 21 May 2019 20:14:18 -0700
Message-ID: <20190522031421.2825174-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=647 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220020
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 - jmp sequence limit
Patch 2 - improve existing tests
Patch 3 - add pyperf-based realistic bpf program that takes advantage
of higher limit and use it as a stress test

v1->v2: fixed nit in patch 3. added Andrii's acks

Alexei Starovoitov (3):
  bpf: bump jmp sequence limit
  selftests/bpf: adjust verifier scale test
  selftests/bpf: add pyperf scale test

 kernel/bpf/verifier.c                         |   7 +-
 .../bpf/prog_tests/bpf_verif_scale.c          |  31 +-
 tools/testing/selftests/bpf/progs/pyperf.h    | 268 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/pyperf100.c |   4 +
 tools/testing/selftests/bpf/progs/pyperf180.c |   4 +
 tools/testing/selftests/bpf/progs/pyperf50.c  |   4 +
 tools/testing/selftests/bpf/test_verifier.c   |  31 +-
 7 files changed, 319 insertions(+), 30 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf.h
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf100.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf180.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf50.c

-- 
2.20.0

