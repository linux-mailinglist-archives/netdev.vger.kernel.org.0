Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEBE204A80
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgFWHIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:08:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39642 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730781AbgFWHIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 03:08:23 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N74oMl031703
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 00:08:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=kpRFK5eT7Y0Oe/2pX8/G8IcpgFJH82Ap6lBX97XpQqs=;
 b=HbmE/JDAYj72vHT3TotUCr81k9hQXGWi5EiIsHMuEs+D2meWAI6dye2PzNEz8JmBWCh1
 5Q/dlVoUkfzomZXENw6tQaqsHKtZwKjGGXN8/hSx7HlNp8uCHkfn0KUWjxLqkj5fNRIQ
 5UEXpojtXBad564+Bq5A0e+8Pt0VO1trXrk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31sg9fm97t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 00:08:22 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 00:08:20 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 5019262E50B5; Tue, 23 Jun 2020 00:08:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/3] bpf: introduce bpf_get_task_stack_trace()
Date:   Tue, 23 Jun 2020 00:07:59 -0700
Message-ID: <20200623070802.2310018-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1011
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 suspectscore=9 mlxlogscore=752 mlxscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set introduces a new helper bpf_get_task_stack_trace(). The primary
use case is to dump all /proc/*/stack to seq_file via bpf_iter__task.

Song Liu (3):
  bpf: introduce helper bpf_get_task_stack_trace()
  bpf: allow %pB in bpf_seq_printf()
  selftests/bpf: add bpf_iter test with bpf_get_task_stack_trace()

 include/uapi/linux/bpf.h                      | 10 +++-
 kernel/trace/bpf_trace.c                      | 24 ++++++++-
 scripts/bpf_helpers_doc.py                    |  2 +
 tools/include/uapi/linux/bpf.h                | 10 +++-
 .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++++
 .../selftests/bpf/progs/bpf_iter_task_stack.c | 50 +++++++++++++++++++
 6 files changed, 110 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack=
.c

--
2.24.1
