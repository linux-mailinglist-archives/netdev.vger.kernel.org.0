Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E1D44E98D
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhKLPKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:10:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22716 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229509AbhKLPKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:10:02 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1ACF5Xau023791
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 07:07:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=VX7J7Gzy96s0CAxZsM8utdZ4Hm+Uw3NgP1n/8spaUd4=;
 b=f0DYnfjNc5eJO6Py388rB8Qw+W71bLuqnOo4P6/TBWWZYWvoVIhC2ret3adeFBNfdFPk
 qG7OhtTQtv/m9NMzSOgba6tHYaRri+xkFEotWGSscfrXugrhYHMssdjBmokdPOuCYxVA
 mSHPVWx1XI+NvMFevLfWR9+NlF8+KgyhDMA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3c9pa5swqa-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 07:07:11 -0800
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 12 Nov 2021 07:02:53 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E4E021FA8FBEF; Fri, 12 Nov 2021 07:02:47 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 bpf-next 0/2] introduce btf_tracing_ids
Date:   Fri, 12 Nov 2021 07:02:41 -0800
Message-ID: <20211112150243.1270987-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: 6FXENl9c4697PUVBK2GMAkIIqg1ucl8w
X-Proofpoint-GUID: 6FXENl9c4697PUVBK2GMAkIIqg1ucl8w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-12_05,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 adultscore=0 mlxlogscore=384 priorityscore=1501 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111120087
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes v2 =3D> v3:
1. Fix bug in task_iter.c. (Kernel test robot <lkp@intel.com>)

Changes v1 =3D> v2:
1. Add patch 2/2. (Alexei)

1/2 fixes issue with btf_task_struct_ids w/o CONFIG_DEBUG_INFO_BTF.
2/2 replaces btf_task_struct_ids with easier to understand btf_tracing_id=
s.

Song Liu (2):
  bpf: extend BTF_ID_LIST_GLOBAL with parameter for number of IDs
  bpf: introduce btf_tracing_ids

 include/linux/btf_ids.h       | 20 ++++++++++++++++----
 kernel/bpf/bpf_task_storage.c |  4 ++--
 kernel/bpf/btf.c              |  8 ++++----
 kernel/bpf/stackmap.c         |  2 +-
 kernel/bpf/task_iter.c        | 12 ++++++------
 kernel/bpf/verifier.c         |  2 +-
 kernel/trace/bpf_trace.c      |  4 ++--
 net/core/filter.c             |  6 +-----
 8 files changed, 33 insertions(+), 25 deletions(-)

--
2.30.2
