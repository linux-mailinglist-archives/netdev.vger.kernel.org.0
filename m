Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DB942F82
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfFLTFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:05:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbfFLTFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 15:05:40 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CJ4YSe032023
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 12:05:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=BZ9wl21VPaEPa4GER1hHqcmAiFKEXojmHjRVib2Zpx0=;
 b=S2QHifyVSD+Q67ftH+4O06+u9iDErnyNIp4TTP2x5XMgvFyi4Ohh8nMPiYZsfmVAcTrD
 m52vrWubmQlAHTrTohyslV8ezf5N+pgvsF2zJWiYzF+lTFj2pcazfxxqmuGIzrZBCV7z
 b/iqe/InC63HlwEXZwH2IQ8ZcKcSS2Rasvg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t33xx0tct-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 12:05:39 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 12:05:38 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 6624C2941B77; Wed, 12 Jun 2019 12:05:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/2] bpf: net: Detach BPF prog from reuseport sk
Date:   Wed, 12 Jun 2019 12:05:36 -0700
Message-ID: <20190612190536.2340077-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=615 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds SO_DETACH_REUSEPORT_BPF to detach BPF prog from
reuseport sk.

Martin KaFai Lau (2):
  bpf: net: Add SO_DETACH_REUSEPORT_BPF
  bpf: Add test for SO_REUSEPORT_DETACH_BPF

 arch/alpha/include/uapi/asm/socket.h          |  2 +
 arch/mips/include/uapi/asm/socket.h           |  2 +
 arch/parisc/include/uapi/asm/socket.h         |  2 +
 arch/sparc/include/uapi/asm/socket.h          |  2 +
 include/net/sock_reuseport.h                  |  2 +
 include/uapi/asm-generic/socket.h             |  2 +
 net/core/sock.c                               |  4 ++
 net/core/sock_reuseport.c                     | 24 +++++++++
 tools/testing/selftests/bpf/Makefile          |  1 +
 .../selftests/bpf/test_select_reuseport.c     | 50 +++++++++++++++++++
 10 files changed, 91 insertions(+)

-- 
2.17.1

