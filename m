Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39F033F9BE
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 21:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhCQUFo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Mar 2021 16:05:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49308 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233428AbhCQUFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 16:05:17 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HK4tnM006407
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 13:05:17 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bek0kreg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 13:05:17 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 17 Mar 2021 13:05:15 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B17092ED245B; Wed, 17 Mar 2021 13:05:11 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 0/2] Provide NULL and KERNEL_VERSION macros in bpf_helpers.h
Date:   Wed, 17 Mar 2021 13:05:08 -0700
Message-ID: <20210317200510.1354627-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_11:2021-03-17,2021-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=687 phishscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide NULL and KERNEL_VERSION macros in bpf_helpers.h. Patch #2 removes such
custom NULL definition from one of the selftests.

v2->v3:
  - instead of vmlinux.h, do this in bpf_helpers.h;
  - added KERNEL_VERSION, which comes up periodically as well;
  - I dropped strict compilation patches for now, because we run into new
    warnings (e.g., not checking read() result) in kernel-patches CI, which
    I can't even reproduce locally. Also -Wdiscarded-qualifiers pragma for
    jit_disasm.c is not supported by Clang, it needs to be
    -Wincompatible-pointer-types-discards-qualifiers for Clang; we don't have
    to deal with that in this patch set;
v1->v2:
  - fix few typos and wrong copy/paste;
  - fix #pragma push -> pop.

Andrii Nakryiko (2):
  libbpf: provide NULL and KERNEL_VERSION macros in bpf_helpers.h
  selftests/bpf: drop custom NULL #define in skb_pkt_end selftest

 tools/lib/bpf/bpf_helpers.h                     | 16 +++++++++++++++-
 tools/testing/selftests/bpf/progs/skb_pkt_end.c |  1 -
 2 files changed, 15 insertions(+), 2 deletions(-)

-- 
2.30.2

