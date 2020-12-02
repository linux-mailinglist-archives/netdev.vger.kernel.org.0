Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9B62CC7CD
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgLBUaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:30:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17876 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727126AbgLBUaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:30:12 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0B2KRQXg013003
        for <netdev@vger.kernel.org>; Wed, 2 Dec 2020 12:29:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=KABH1YMs57kFvn7NXzvkZQPQ6YbnBtDQ71zNt1BBCmM=;
 b=n3SBdZqF6F25u7giA+1CFIbEiKN/eg+cKqlMDx/5dobtrHso7XyQ+MxdsCicEPN3k7Uz
 6kuIFiq//FiuLCgxo8xIYJJDxS/RmXK5eEE1LKcZW/uoiWZuHo5T4ACbJe2Dh+80pFKu
 zCtnWb3qwWiimzZf3zEkQdPu8l/b/OpnvWo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3562m9wpn6-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 12:29:30 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 12:29:29 -0800
Received: by devvm3178.ftw3.facebook.com (Postfix, from userid 201728)
        id 41CF24762F190; Wed,  2 Dec 2020 12:29:25 -0800 (PST)
From:   Prankur gupta <prankgup@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf-next 0/2] Add support to set window_clamp from bpf setsockops
Date:   Wed, 2 Dec 2020 12:29:23 -0800
Message-ID: <20201202202925.165803-1-prankgup@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_12:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 suspectscore=13 phishscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch contains support to set tcp window_field field from bpf setsoc=
kops.

v2: Used TCP_WINDOW_CLAMP setsockopt logic for bpf_setsockopt (review com=
ment addressed)

v3: Created a common function for duplicated code (review comment address=
ed)


Prankur gupta (2):
  bpf: Adds support for setting window clamp
  selftests/bpf: Add Userspace tests for TCP_WINDOW_CLAMP

 include/net/tcp.h                             |  1 +
 net/core/filter.c                             |  3 ++
 net/ipv4/tcp.c                                | 23 ++++++++-----
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  1 +
 .../selftests/bpf/prog_tests/tcpbpf_user.c    |  4 +++
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 33 +++++++++++++++++++
 tools/testing/selftests/bpf/test_tcpbpf.h     |  2 ++
 7 files changed, 58 insertions(+), 9 deletions(-)

--=20
2.24.1

