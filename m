Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC5F318D2B0
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgCTPVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:21:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbgCTPVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:21:05 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KFKKMN016785
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 08:21:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=GpaR7DMqdUzSGid6Gim9t4E+vLQW/LJT2WtXWUBIxJ0=;
 b=NjB+/AK57iNwNJtVuMyEX/LjKPEUVLe24RzYckcqq5YWv2dNZRHzerD4UV1UpTHtuvTu
 UJZTTQuurJaaGW2Opiv3hvWGqkEAoAn5qxt/dOiBf3kDLYBjUMzTDbqkSrJBYI4/3m66
 4fS3S7vvtcGCNvb6dhCNM882OV1WaYtp9U8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yvu8ysg94-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 08:21:05 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 08:20:57 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 46E8F29410F6; Fri, 20 Mar 2020 08:20:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/2] bpf: Add bpf_sk_storage support to bpf_tcp_ca
Date:   Fri, 20 Mar 2020 08:20:55 -0700
Message-ID: <20200320152055.2169341-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_05:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=876 suspectscore=13
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set adds bpf_sk_storage support to bpf_tcp_ca.
That will allow bpf-tcp-cc to share sk's private data with other
bpf_progs and also allow bpf-tcp-cc to use extra private
storage if the existing icsk_ca_priv is not enough.

v2:
- Move the sk_stg_map test immediately after connect() (Yonghong)
- Use global linkage var in bpf_dctcp.c (Yonghong)

Martin KaFai Lau (2):
  bpf: Add bpf_sk_storage support to bpf_tcp_ca
  bpf: Add tests for bpf_sk_storage to bpf_tcp_ca

 net/ipv4/bpf_tcp_ca.c                         | 33 ++++++++++++++++
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 39 +++++++++++++++----
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 16 ++++++++
 3 files changed, 80 insertions(+), 8 deletions(-)

-- 
2.17.1

