Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6365943D62F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhJ0WDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:03:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32842 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229906AbhJ0WDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:03:22 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RLfjrk026705
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 15:00:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=9Z4DHBUKQ7KDMPBFYeTqQo5w8PrCfjCKAN0i6BSeSvw=;
 b=jmtWpf4W9JzBbeaBvjFbMGU3TmryxYMnDa5i0owgwFaSWQkK9sB/AJnfywLZUgQvBhKx
 pXtgBzV4GQG+a2kI1Pn3Aeq5rQIBM/izEga2aHTAQD752AnJoWE3scpihvKsnq2jFLra
 4Dwdwm4fdHmKUTI4/tN201fc5RVLMi66/F4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bxy9e8a69-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 15:00:56 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 27 Oct 2021 15:00:52 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9E0A71B7DA3B8; Wed, 27 Oct 2021 15:00:45 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 0/2] introduce bpf_find_vma
Date:   Wed, 27 Oct 2021 15:00:41 -0700
Message-ID: <20211027220043.1937648-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: DTfhbPhHgJThsHRFSrT5klzwF4rv_Tk8
X-Proofpoint-GUID: DTfhbPhHgJThsHRFSrT5klzwF4rv_Tk8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_06,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 phishscore=0
 mlxlogscore=397 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110270121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper bpf_find_vma. This can be used in some profiling use cases. It
might also be useful for LSM.

Song Liu (2):
  bpf: introduce helper bpf_find_vma
  selftests/bpf: add tests for bpf_find_vma

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  20 ++++
 kernel/bpf/task_iter.c                        | 102 +++++++++++++++++-
 kernel/bpf/verifier.c                         |  36 +++++++
 kernel/trace/bpf_trace.c                      |   2 +
 tools/include/uapi/linux/bpf.h                |  19 ++++
 .../selftests/bpf/prog_tests/find_vma.c       |  95 ++++++++++++++++
 tools/testing/selftests/bpf/progs/find_vma.c  |  70 ++++++++++++
 8 files changed, 344 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c

--
2.30.2
