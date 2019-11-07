Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECE7F24FB
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732993AbfKGCJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:09:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727916AbfKGCJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:09:23 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7281iR027649
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 18:09:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=gg08qCfDg4ZgIQqw/AQObo9HxVXi+vKfc948bZ5/waE=;
 b=THy42hYVWIoMHi6dV4u25+RuBSOqI2g5zbH4ELrrvJTcXInVxqDpjYyUbN2PxmLZyeoO
 rNsEcFrbse0TYbpetGK9X+y6AlGU72lzjlPCTur/4EwYg6AJb/hn13zeJJygtfE6Imy+
 b78a9B6ABjXl+R9Yc6V6MrE4BzSY9okvW3A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vxtknp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 18:09:22 -0800
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 18:09:20 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 36A262EC17EE; Wed,  6 Nov 2019 18:09:20 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/5] Fix bugs and issues found by static analysis in libbpf
Date:   Wed, 6 Nov 2019 18:08:50 -0800
Message-ID: <20191107020855.3834758-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=25 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=651
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070021
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Github's mirror of libbpf got LGTM and Coverity statis analysis running
against it and spotted few real bugs and few potential issues. This patch
series fixes found issues.

Andrii Nakryiko (5):
  libbpf: fix memory leak/double free issue
  libbpf: fix potential overflow issue
  libbpf: fix another potential overflow issue in bpf_prog_linfo
  libbpf: make btf__resolve_size logic always check size error condition
  libbpf: improve handling of corrupted ELF during map initialization

 tools/lib/bpf/bpf.c            |  2 +-
 tools/lib/bpf/bpf_prog_linfo.c | 14 +++++++-------
 tools/lib/bpf/btf.c            |  3 +--
 tools/lib/bpf/libbpf.c         |  6 +++---
 4 files changed, 12 insertions(+), 13 deletions(-)

-- 
2.17.1

