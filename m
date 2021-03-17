Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D26B33E77A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 04:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCQDND convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Mar 2021 23:13:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54558 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhCQDNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 23:13:02 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12H344N7013291
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:13:02 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379ee5qsj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:13:01 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 20:13:00 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 39DDD2ED23D6; Tue, 16 Mar 2021 20:12:59 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 0/4] Generate NULL in vmlinux.h
Date:   Tue, 16 Mar 2021 20:12:53 -0700
Message-ID: <20210317031257.846314-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_09:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 mlxlogscore=527 mlxscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generate NULL definition as part of vmlinux.h. This is a pretty common and
unfortunate annoyance that most users of vmlinux.h have to deal with. Patch #2
drops such custom NULL definition in one of the selftests. Patches #3 and #4
make bpftool and selftests compilations stricter by treating warnings as
errors.

v1->v2:
  - fix few typos and wrong copy/paste;
  - fix #pragma push -> pop.

Andrii Nakryiko (4):
  bpftool: generate NULL definition in vmlinux.h
  selftests/bpf: drop custom NULL #define in skb_pkt_end selftest
  selftests/bpf: treat compilation warnings as errors
  bpftool: treat compilation warnings as errors

 tools/bpf/bpftool/Makefile                      | 3 ++-
 tools/bpf/bpftool/btf.c                         | 2 ++
 tools/bpf/bpftool/jit_disasm.c                  | 3 +++
 tools/testing/selftests/bpf/Makefile            | 4 ++--
 tools/testing/selftests/bpf/progs/skb_pkt_end.c | 1 -
 5 files changed, 9 insertions(+), 4 deletions(-)

-- 
2.30.2

