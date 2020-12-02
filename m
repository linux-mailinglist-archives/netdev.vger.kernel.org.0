Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C342CC8F7
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbgLBVcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:32:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56808 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729366AbgLBVcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:32:35 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2LQG3D020062
        for <netdev@vger.kernel.org>; Wed, 2 Dec 2020 13:31:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=G1Y9hdvbK4qmmUhPaxvp/07XyNLgHhb2MpEGsGRireQ=;
 b=SbI4ZYF0leDFY+wFka9V9tzABq7CzVp0eIm/OZrok8Um9eonCmHWvu0lK7PSN6oVodRp
 DxAEmmU9U8m/d4AMVf+jFdHSYEEG5apBsVzyNrJwca4YFArge1lGYwl8leWjwYBABa5e
 FkkuW/cgQHln7JQqzvIGWH+zfff37+aCGsc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355wgw7uk9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 13:31:54 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 13:31:53 -0800
Received: by devvm3178.ftw3.facebook.com (Postfix, from userid 201728)
        id 2485C476377B8; Wed,  2 Dec 2020 13:31:52 -0800 (PST)
From:   Prankur gupta <prankgup@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 0/2] Add support to set window_clamp from bpf setsockops
Date:   Wed, 2 Dec 2020 13:31:50 -0800
Message-ID: <20201202213152.435886-1-prankgup@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_13:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=13 priorityscore=1501 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020130
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

v4: Removing logic to pass struct sock and struct tcp_sock together (revi=
ew comment addressed)

Prankur gupta (2):
  bpf: Adds support for setting window clamp
  selftests/bpf: Add Userspace tests for TCP_WINDOW_CLAMP

 include/net/tcp.h                             |  1 +
 net/core/filter.c                             |  3 ++
 net/ipv4/tcp.c                                | 25 +++++++++-----
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  1 +
 .../selftests/bpf/prog_tests/tcpbpf_user.c    |  4 +++
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 33 +++++++++++++++++++
 tools/testing/selftests/bpf/test_tcpbpf.h     |  2 ++
 7 files changed, 60 insertions(+), 9 deletions(-)

--=20
2.24.1

