Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F050139A1B
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 04:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbfFHCT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 22:19:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728860AbfFHCT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 22:19:29 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x582JSvB030663
        for <netdev@vger.kernel.org>; Fri, 7 Jun 2019 19:19:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=GbaFTvpyFTq1p954+8DIE9YJjCQ9LlKHadFwEpT85EM=;
 b=jeSEWFa9ubLz50agGk8a/QgNHYe/SGPxDqmkEGvwUJtqqGlduCJBq9zSnRPrQW14ckcw
 7DCG1hQuhF9W6WUQQfDGji4jcL6fmQRFMuhhVYqbAC1bYbt/fQjZtW7LF+Fac0c3p6rd
 H/d10AynSUvjtvwTCl6LBEfM/d8/bmFEaso= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t00xjresc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 19:19:28 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 7 Jun 2019 19:19:27 -0700
Received: by devvm3632.prn2.facebook.com (Postfix, from userid 172007)
        id 52AD4CE318F4; Fri,  7 Jun 2019 19:19:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Hechao Li <hechaol@fb.com>
Smtp-Origin-Hostname: devvm3632.prn2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <kernel-team@fb.com>, Hechao Li <hechaol@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 0/2] bpf: Add a new API libbpf_num_possible_cpus()
Date:   Fri, 7 Jun 2019 19:19:23 -0700
Message-ID: <20190608021925.4060095-1-hechaol@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=743 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Getting number of possible CPUs is commonly used for per-CPU BPF maps
and perf_event_maps. Add a new API libbpf_num_possible_cpus() that
helps user with per-CPU related operations and remove duplicate
implementations in bpftool and selftests.

v2: Save errno before calling pr_warning in case it is changed.
v3: Make sure libbpf_num_possible_cpus never returns 0 so that user only has 
    to check if ret value < 0.
v4: Fix error code when reading 0 bytes from possible CPU file.
v5: Fix selftests compliation issue.

Hechao Li (2):
  bpf: add a new API libbpf_num_possible_cpus()
  bpf: use libbpf_num_possible_cpus in bpftool and selftests

 tools/bpf/bpftool/common.c             | 53 +++---------------------
 tools/lib/bpf/libbpf.c                 | 57 ++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h                 | 16 ++++++++
 tools/lib/bpf/libbpf.map               |  1 +
 tools/testing/selftests/bpf/bpf_util.h | 37 +++--------------
 5 files changed, 84 insertions(+), 80 deletions(-)

-- 
2.17.1

