Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822B7CC8A9
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 09:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfJEH7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 03:59:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1918 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbfJEH7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 03:59:34 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x957wN2C014162
        for <netdev@vger.kernel.org>; Sat, 5 Oct 2019 00:59:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=RVRe34uiWPw42OqzN46cFPWAf6rj8BwGkHpL/W5iQ8s=;
 b=qqt3mMBk5oIsYGieZ3RRaHglE+7vKs5LCg9m2exbOPLHweDK7JmtwhPoyquEROsFbJ3A
 g4JDA2bGzftnQwd5uCMaFNNdJuaqptrdiCNDPvz5ml+DWbMAOcPsDrOM++XL7TRa0JsP
 uF055YVl03teNnO/4GV2pGduXA+qM0AJpko= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ved83a80g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 00:59:33 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 5 Oct 2019 00:59:32 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E194086182A; Sat,  5 Oct 2019 00:59:31 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/3] Auto-generate list of BPF helpers
Date:   Sat, 5 Oct 2019 00:59:18 -0700
Message-ID: <20191005075921.3310139-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-05_04:2019-10-03,2019-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=629
 mlxscore=0 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=9 adultscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910050076
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds ability to auto-generate list of BPF helper definitions.
It relies on existing scripts/bpf_helpers_doc.py and include/uapi/linux/bpf.h
having a well-defined set of comments.  All this is integrated with libbpf's
Makefile to ensure that bpf_helpers_defs.h stays in sync with latest kernel
UAPI. By checking bpf_helpers_defs.h, we also make sure that Github projection
doesn't rely on latest kernel headers for successful build.

Andrii Nakryiko (3):
  uapi/bpf: fix helper docs
  scripts/bpf: teach bpf_helpers_doc.py to dump BPF helper definitions
  libbpf: auto-generate list of BPF helper definitions

 include/uapi/linux/bpf.h         |   32 +-
 scripts/bpf_helpers_doc.py       |  156 +-
 tools/include/uapi/linux/bpf.h   |   32 +-
 tools/lib/bpf/Makefile           |    8 +-
 tools/lib/bpf/bpf_helpers.h      |  264 +--
 tools/lib/bpf/bpf_helpers_defs.h | 2677 ++++++++++++++++++++++++++++++
 6 files changed, 2872 insertions(+), 297 deletions(-)
 create mode 100644 tools/lib/bpf/bpf_helpers_defs.h

-- 
2.17.1

