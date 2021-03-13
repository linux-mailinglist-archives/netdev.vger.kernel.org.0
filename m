Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D46E33A155
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 22:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhCMVJx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Mar 2021 16:09:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30692 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234723AbhCMVJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 16:09:37 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12DL8TAj025385
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:09:37 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 378ucs9nyg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:09:37 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 13 Mar 2021 13:09:30 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F02C12ED2050; Sat, 13 Mar 2021 13:09:22 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 0/4] Build BPF selftests and its libbpf, bpftool in debug mode
Date:   Sat, 13 Mar 2021 13:09:16 -0800
Message-ID: <20210313210920.1959628-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-13_10:2021-03-12,2021-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=797 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103130166
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build BPF selftests and libbpf and bpftool, that are used as part of
selftests, in debug mode (specifically, -Og). This makes it much simpler and
nicer to do development and/or bug fixing. See patch #4 for some unscientific
measurements.

This patch set fixes new maybe-unitialized warnings produced in -Og build
mode. Patch #1 fixes the blocker which was causing some XDP selftests failures
due to non-zero padding in bpf_xdp_set_link_opts, which only happened in debug
mode.

Andrii Nakryiko (4):
  libbpf: add explicit padding to bpf_xdp_set_link_opts
  bpftool: fix maybe-uninitialized warnings
  selftests/bpf: fix maybe-uninitialized warning in xdpxceiver test
  selftests/bpf: build everything in debug mode

 tools/bpf/bpftool/btf.c                  | 3 +++
 tools/bpf/bpftool/main.c                 | 3 +--
 tools/bpf/bpftool/map.c                  | 2 +-
 tools/lib/bpf/libbpf.h                   | 1 +
 tools/testing/selftests/bpf/Makefile     | 7 +++++--
 tools/testing/selftests/bpf/xdpxceiver.c | 4 ++--
 6 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.24.1

