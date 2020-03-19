Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67BE718C3EC
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 00:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgCSXt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 19:49:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65198 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726663AbgCSXt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 19:49:59 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02JNjHY7025255
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 16:49:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=c8biSNUc3qCdbHNV0/3rTooJ2yYM9OQBX8C2WXCyeuA=;
 b=YvzeVMG8B4KV94ZicBYEFNKg3P12PsUdcTJ55M8pE6UiZGB1JOCJNVBKpUBGTI6Yxuwg
 WJ+/MhpOg3SepXAoLTC3iJFEwMTHU57ec9TlxG2zS/HAMJd788/0y3WY0EPgBWIqxPaY
 k7tJoTIIrsPDjsHQxWcbsx06uF5vk7tEuxQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yvg258rnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 16:49:58 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 16:49:57 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id D47492942DAE; Thu, 19 Mar 2020 16:49:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/2] bpf: Add bpf_sk_storage support to bpf_tcp_ca
Date:   Thu, 19 Mar 2020 16:49:55 -0700
Message-ID: <20200319234955.2933540-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=754
 impostorscore=0 suspectscore=13 adultscore=0 malwarescore=0 clxscore=1015
 spamscore=0 phishscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190095
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set adds bpf_sk_storage support to bpf_tcp_ca.
That will allow bpf-tcp-cc to share sk's private data with other
bpf_progs and also allow bpf-tcp-cc to use extra private
storage if the existing icsk_ca_priv is not enough.

Martin KaFai Lau (2):
  bpf: Add bpf_sk_storage support to bpf_tcp_ca
  bpf: Add tests for bpf_sk_storage to bpf_tcp_ca

 net/ipv4/bpf_tcp_ca.c                         | 33 +++++++++++++++++++
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 28 ++++++++++++++--
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 16 +++++++++
 3 files changed, 74 insertions(+), 3 deletions(-)

-- 
2.17.1

