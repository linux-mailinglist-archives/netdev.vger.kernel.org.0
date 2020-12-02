Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E63D2CB557
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 07:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgLBGxg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 01:53:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39354 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728709AbgLBGxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 01:53:35 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B26jkMM007145
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 22:52:54 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355t7y4514-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 22:52:54 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 22:52:51 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3CE052ECA750; Tue,  1 Dec 2020 22:52:46 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 0/3] bpftool: improve split BTF support
Date:   Tue, 1 Dec 2020 22:52:40 -0800
Message-ID: <20201202065244.530571-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_01:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=473 phishscore=0
 mlxscore=0 suspectscore=8 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few follow up improvements to bpftool for split BTF support:
  - emit "name <anon>" for non-named BTFs in `bpftool btf show` command;
  - when dumping /sys/kernel/btf/<module> use /sys/kernel/btf/vmlinux as the
    base BTF, unless base BTF is explicitly specified with -B flag.

This patch set also adds btf__base_btf() getter to access base BTF of the
struct btf.

Andrii Nakryiko (3):
  tools/bpftool: emit name <anon> for anonymous BTFs
  libbpf: add base BTF accessor
  tools/bpftool: auto-detect split BTFs in common cases

 tools/bpf/bpftool/btf.c  | 27 +++++++++++++++++++++++----
 tools/lib/bpf/btf.c      |  5 +++++
 tools/lib/bpf/btf.h      |  1 +
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 30 insertions(+), 4 deletions(-)

-- 
2.24.1

