Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7CA56223
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 08:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfFZGMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 02:12:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42320 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbfFZGMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 02:12:44 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q68kqu011020
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 23:12:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=PwSn+7J7E3QErHZMey9N2j0zc6bGmvSLJbzoIpJ9ZPs=;
 b=aF9F2snry+kI6kFuHyc1gi25+3LvTw1lGDJWhuN0z9Q1nZtSOOtjD3oX7llO/urmZ4y3
 Chgdrt44zecxXrME1N/gJfan4CPbvuH15Ss3UgD5YGXmkZ8RxlxL8CFYcsxnZeLt1zkw
 4HGD+TTBWViPOVsW08Ym4BfirZSecl3pddA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tc1mrg89k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 23:12:42 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 25 Jun 2019 23:12:41 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id DE0EF861896; Tue, 25 Jun 2019 23:12:40 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/3] libbpf: add perf buffer abstraction and API
Date:   Tue, 25 Jun 2019 23:12:32 -0700
Message-ID: <20190626061235.602633-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds a high-level API for setting up and polling perf buffers
associated with BPF_MAP_TYPE_PERF_EVENT_ARRAY map. Details of APIs are
described in corresponding commit.

Patch #1 adds a set of APIs to set up and work with perf buffer.
Patch #2 enhances libbpf to supprot auto-setting PERF_EVENT_ARRAY map size.
Patch #3 adds test.

Andrii Nakryiko (3):
  libbpf: add perf buffer API
  libbpf: auto-set PERF_EVENT_ARRAY size to number of CPUs
  selftests/bpf: test perf buffer API

 tools/lib/bpf/libbpf.c                        | 299 +++++++++++++++++-
 tools/lib/bpf/libbpf.h                        |  12 +
 tools/lib/bpf/libbpf.map                      |   5 +-
 .../selftests/bpf/prog_tests/perf_buffer.c    |  86 +++++
 .../selftests/bpf/progs/test_perf_buffer.c    |  29 ++
 5 files changed, 429 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c

-- 
2.17.1

