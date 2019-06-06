Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7929F37D54
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 21:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFFTjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 15:39:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60464 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbfFFTjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 15:39:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56JX1JX016700
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 12:39:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=38DQ+3g934vYUYobAs/hM6beyrP80BjTsmtytCr1cbU=;
 b=XJrjjhfwR4ZGogPYQQ4gEk1c9EPNEDJ9Ne/LVP3/cU8fdMKSVs4ALxE3gWkgV7xu1JBh
 mMhVJkptHcL9I/wRWtpGmmYeshi9lvMFgWctctwNgR4VCGrurWg84n3Xe9vMpDTKza3O
 X0sQQVXBuOYIbVGgtNO6wej+H3LpiruI1us= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy7pu8cye-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 12:39:50 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 12:39:49 -0700
Received: by devvm3632.prn2.facebook.com (Postfix, from userid 172007)
        id 8C35BCCF2569; Thu,  6 Jun 2019 12:39:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Hechao Li <hechaol@fb.com>
Smtp-Origin-Hostname: devvm3632.prn2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, Hechao Li <hechaol@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 0/2] bpf: Add a new API libbpf_num_possible_cpus()
Date:   Thu, 6 Jun 2019 12:39:25 -0700
Message-ID: <20190606193927.2489147-1-hechaol@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=700 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Getting number of possible CPUs is commonly used for per-CPU BPF maps
and perf_event_maps. Add a new API libbpf_num_possible_cpus() that
helps user with per-CPU related operations and remove duplicate
implementations in bpftool and selftests.

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

