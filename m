Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FAD2D8407
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 03:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437635AbgLLCtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 21:49:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4496 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437624AbgLLCtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 21:49:07 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BC2lBsA028264
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 18:48:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nlY7wfws6yRYwVzKfxHUW3g9ZHtYcHyphmCk2figMJI=;
 b=pWcxuwpSvdlYYqrGpRgOjU8YoGst2WWUdyIiB2wlC5i1NClK/ZZ5YsfJ1BKrglC7way6
 NNsd0SxafBZ5nlZsP/Tm/tJ04+54NpEW9cYGCMgNczEC7Uq352dsoZRHXsjE8FyMuJcc
 03jpkvtkikmrk+zhrYc47jLezLuLp18jfPw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 35c8ssm5n4-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 18:48:24 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Dec 2020 18:48:22 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 71C9762E50ED; Fri, 11 Dec 2020 18:48:20 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 0/4] introduce bpf_iter for task_vma
Date:   Fri, 11 Dec 2020 18:48:06 -0800
Message-ID: <20201212024810.807616-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_10:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxlogscore=538 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012120020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set introduces bpf_iter for task_vma, which can be used to generate
information similar to /proc/pid/maps or /proc/pid/smaps. Patch 4/4 adds
an example that mimics /proc/pid/maps.

Song Liu (4):
  bpf: introduce task_vma bpf_iter
  bpf: allow bpf_d_path in sleepable bpf_iter program
  libbpf: introduce section "iter.s/" for sleepable bpf_iter program
  selftests/bpf: add test for bpf_iter_task_vma

 include/linux/bpf.h                           |   2 +-
 include/uapi/linux/bpf.h                      |   7 +
 kernel/bpf/task_iter.c                        | 193 +++++++++++++++++-
 kernel/trace/bpf_trace.c                      |   5 +
 tools/lib/bpf/libbpf.c                        |   5 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 106 +++++++++-
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   9 +
 .../selftests/bpf/progs/bpf_iter_task_vma.c   |  55 +++++
 8 files changed, 370 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c

--
2.24.1
