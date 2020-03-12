Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083E418388D
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgCLSYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:24:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31510 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726569AbgCLSYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:24:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CIHgT0020284
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:24:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=DYeI4xDldKGYM55ob3MvA89OrCHGz438Apo+oI5jwWc=;
 b=pjJrA+uxkd965ElFuRooo8mw5X8hUiJ8EMXtpbUWuYzgjrv+sPFnBrK0SbouvNJv1c4v
 hwNN+ThCwribQ5fWrNkk/Cxjs3ArFmmvVCxtAgaA+0EoBb3MZpLSlVk5JzI3fR/TNDVv
 tpk0EMII1bwtw1MoKhRz1G5tVoXr9ae3Wtg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt80r15d-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:24:42 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 12 Mar 2020 11:23:44 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E2BFC62E017A; Thu, 12 Mar 2020 11:23:38 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <john.fastabend@gmail.com>, <quentin@isovalent.com>,
        <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/3] Fixes for bpftool-prog-profile
Date:   Thu, 12 Mar 2020 11:23:29 -0700
Message-ID: <20200312182332.3953408-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_12:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=837 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120093
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Fix build for older clang;
2. Fix skeleton's dependency on libbpf;
3. Add files to .gitignore.

Changes v2 => v3:
1. Add -I$(LIBBPF_PATH) to Makefile (Quentin);
2. Use p_err() for error message (Quentin).

Changes v1 => v2:
1. Rewrite patch 1 with real feature detection (Quentin, Alexei).
2. Add files to .gitignore (Andrii).

Song Liu (3):
  bpftool: only build bpftool-prog-profile if supported by clang
  bpftool: skeleton should depend on libbpf
  bpftool: add _bpftool and profiler.skel.h to .gitignore

 tools/bpf/bpftool/.gitignore                  |  2 ++
 tools/bpf/bpftool/Makefile                    | 20 +++++++++++++------
 tools/bpf/bpftool/prog.c                      |  1 +
 tools/build/feature/Makefile                  |  9 ++++++++-
 .../build/feature/test-clang-bpf-global-var.c |  4 ++++
 5 files changed, 29 insertions(+), 7 deletions(-)
 create mode 100644 tools/build/feature/test-clang-bpf-global-var.c

--
2.17.1
