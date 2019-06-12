Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7DA0447D0
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfFMRCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:02:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729532AbfFLXYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 19:24:21 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CNKv5L005969
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 16:24:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=XVxuA1EzurNKd6KUiT5wSyRjls6JSPTbn22EboO8Z0A=;
 b=fZfOpxMQYkHEwCFFXw4epwjDVqHeR0rkPX4bMBhPL9VayZsNl7/A8TXejpFTeoTtZkkZ
 v/XSz9GM/aGPmuPDh3NfxXq2h3scTQ5IKulP9lvlKkeYrmqpOFaEj85accRqptp9IZuT
 oO+ZpIQ76aCM1ZREc7qKc3uj27XheAV4Ydw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t365k130y-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 16:24:20 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 16:24:14 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id EDCDF294308C; Wed, 12 Jun 2019 16:24:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/3] bpf: net: Detach BPF prog from reuseport sk
Date:   Wed, 12 Jun 2019 16:24:12 -0700
Message-ID: <20190612232412.3196844-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=496 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
Copy asm-generic/socket.h to tools/ in the new patch 2 (Stanislav Fomichev)

This patch adds SO_DETACH_REUSEPORT_BPF to detach BPF prog from
reuseport sk.

Martin KaFai Lau (3):
  bpf: net: Add SO_DETACH_REUSEPORT_BPF
  bpf: Sync asm-generic/socket.h to tools/
  bpf: Add test for SO_REUSEPORT_DETACH_BPF

 arch/alpha/include/uapi/asm/socket.h          |  2 +
 arch/mips/include/uapi/asm/socket.h           |  2 +
 arch/parisc/include/uapi/asm/socket.h         |  2 +
 arch/sparc/include/uapi/asm/socket.h          |  2 +
 include/net/sock_reuseport.h                  |  2 +
 include/uapi/asm-generic/socket.h             |  2 +
 net/core/sock.c                               |  4 ++
 net/core/sock_reuseport.c                     | 24 +++++++++
 .../include}/uapi/asm-generic/socket.h        |  2 +
 .../selftests/bpf/test_select_reuseport.c     | 54 +++++++++++++++++++
 10 files changed, 96 insertions(+)
 copy {include => tools/include}/uapi/asm-generic/socket.h (98%)

-- 
2.17.1

