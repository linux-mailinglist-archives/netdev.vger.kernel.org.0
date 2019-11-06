Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AA3F2261
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfKFXMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:12:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43790 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725937AbfKFXMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 18:12:13 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA6NA1ld022394
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 15:12:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=V6b7+K6hHxAHP89Q7cYxIDWvSSbjdGdtxZxFrOEHw3k=;
 b=DD7iKWuqL+3QQ9ilVcDLYl1BloEBlP99i3EhaCZ025QYh+VLBuOGKej8AAbZIMmdM39S
 DUkwWsAgHtGMUkp2jsLDYWHfehoLmMS0ffFjP0VcAYOrPs11YCqNO+XuwPBKWRT89i38
 CfyL2oIDepotB8fY83RN9jNawbD9cX31pQY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41uj9ukt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 15:12:12 -0800
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 15:12:10 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3A72E29431A0; Wed,  6 Nov 2019 15:12:10 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/2] bpf: Add array support to btf_struct_access
Date:   Wed, 6 Nov 2019 15:12:10 -0800
Message-ID: <20191106231210.3615828-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_08:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 suspectscore=8 priorityscore=1501 spamscore=0 mlxlogscore=848
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911060223
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds array support to btf_struct_access().
Please see individual patch for details.

v2:
- Fix a divide-by-zero when there is empty array in
  a struct (e.g. "__u8 __cloned_offset[0];" in skbuff)
- Add 'static' to a global var in prog_tests/kfree_skb.c

Martin KaFai Lau (2):
  bpf: Add array support to btf_struct_access
  bpf: Add cb access in kfree_skb test

 kernel/bpf/btf.c                              | 187 +++++++++++++++---
 .../selftests/bpf/prog_tests/kfree_skb.c      |  54 +++--
 tools/testing/selftests/bpf/progs/kfree_skb.c |  25 ++-
 3 files changed, 220 insertions(+), 46 deletions(-)

-- 
2.17.1

