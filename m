Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA3725AA0
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 01:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfEUXGj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 19:06:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44616 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbfEUXGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 19:06:39 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4LMvCdA002542
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:06:38 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2smkvw1p9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:06:38 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 21 May 2019 16:06:37 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 9C093760B85; Tue, 21 May 2019 16:06:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/3] bpf: optimize explored_states
Date:   Tue, 21 May 2019 16:06:32 -0700
Message-ID: <20190521230635.2142522-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-21_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=44 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=44
 clxscore=1034 lowpriorityscore=0 mlxscore=44 impostorscore=0
 mlxlogscore=10 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert explored_states array into hash table and use simple hash to
reduce verifier peak memory consumption for programs with bpf2bpf calls.
More details in patch 3.

Alexei Starovoitov (3):
  bpf: cleanup explored_states
  bpf: split explored_states
  bpf: convert explored_states to hash table

 include/linux/bpf_verifier.h |  2 +
 kernel/bpf/verifier.c        | 78 ++++++++++++++++++++++--------------
 2 files changed, 51 insertions(+), 29 deletions(-)

-- 
2.20.0

