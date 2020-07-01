Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6012113D0
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgGATqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:46:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9646 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726021AbgGATqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:46:13 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 061Ji0pV027400
        for <netdev@vger.kernel.org>; Wed, 1 Jul 2020 12:46:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=VmvHXNXa8l7U9I+uEbIWGGSOhuxl/mzP83Ugw+e8pRc=;
 b=XVVY9P+Be1NRT5Ag2SRwCYrGtY2zzLyo/sLEyO7M3MBCfQWz9J6sXCN5Das9rn/H8U1y
 EqoHWiQ06XVejFQAH4QKhw4A5ACraCKP4w4n+YqRg7N88PRgCaeSqwPfGW0GKzS7qCYH
 WfL2ilZBA6JHZmuXJ5F7ccU0u1L4CPP17bM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xp3rs6vn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 12:46:12 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 12:46:11 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id E515A2943DD9; Wed,  1 Jul 2020 12:46:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/2] bpf: selftests: A few changes to network_helpers and netns-reset
Date:   Wed, 1 Jul 2020 12:46:00 -0700
Message-ID: <20200701194600.948847-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_12:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=662
 adultscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=1 clxscore=1015
 cotscore=-2147483648 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007010138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is separated out from the bpf tcp header option series [1] since
I think it is in general useful for other network related tests.
e.g. enforce socket-fd related timeout and restore netns after each test.

[1]: https://lore.kernel.org/netdev/20200626175501.1459961-1-kafai@fb.com=
/

Martin KaFai Lau (2):
  bpf: selftests: A few improvements to network_helpers.c
  bpf: selftests: Restore netns after each test

 tools/testing/selftests/bpf/network_helpers.c | 157 +++++++++++-------
 tools/testing/selftests/bpf/network_helpers.h |   9 +-
 .../bpf/prog_tests/cgroup_skb_sk_lookup.c     |  12 +-
 .../bpf/prog_tests/connect_force_port.c       |  10 +-
 .../bpf/prog_tests/load_bytes_relative.c      |   4 +-
 .../selftests/bpf/prog_tests/tcp_rtt.c        |   4 +-
 tools/testing/selftests/bpf/test_progs.c      |  23 ++-
 tools/testing/selftests/bpf/test_progs.h      |   2 +
 8 files changed, 133 insertions(+), 88 deletions(-)

--=20
2.24.1

