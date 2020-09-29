Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E896C27BFF5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgI2IsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:48:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51396 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgI2Ir7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:47:59 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T8dkV7030472
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:47:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=MvNShYh0XkJBtZGp+NAVoGeK3HTwl3VwHI+goioSK5A=;
 b=GULg01tbkZDn7RjoXFtxSSw6ZTmyoryBMUcmOmg42mzoKqTR73YVrjAXP4z1fK56Oo29
 OuM7CylqeLr+UKinQtSu24it0wP0zwJf+XFCFXblM10SxiKBikVz+uz6amo2A/o8GM8z
 zlkcecJF+Wn7SWYYTOollVL/au3LkMQOP9s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33t35n3ww7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:47:58 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 01:47:56 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 4BA5C62E5765; Tue, 29 Sep 2020 01:47:55 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 0/2] introduce BPF_F_SHARE_PE
Date:   Tue, 29 Sep 2020 01:47:48 -0700
Message-ID: <20200929084750.419168-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=674
 mlxscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290080
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set introduces BPF_F_SHARE_PE to perf event array for better sharing
of perf event. By default, perf event array removes the perf event when t=
he
map fd used to add the event is closed. With BPF_F_SHARE_PE set, however,
the perf event will stay in the array until it is removed, or the map is
closed.

Song Liu (2):
  bpf: introduce BPF_F_SHARE_PE for perf event array
  selftests/bpf: add tests for BPF_F_SHARE_PE

 include/uapi/linux/bpf.h                      |  3 +
 kernel/bpf/arraymap.c                         | 31 ++++++++-
 tools/include/uapi/linux/bpf.h                |  3 +
 .../bpf/prog_tests/perf_event_share.c         | 68 +++++++++++++++++++
 .../bpf/progs/test_perf_event_share.c         | 44 ++++++++++++
 5 files changed, 147 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_event_sha=
re.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_event_sha=
re.c

--
2.24.1
