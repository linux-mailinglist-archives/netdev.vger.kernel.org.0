Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB9413B564
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 23:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgANWoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 17:44:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3816 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728808AbgANWoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 17:44:04 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EMf4m5024529
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:44:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Jv/VhNZ8ABSGPShN5dnCdYgIamQhgkzjl0EizyqxjPQ=;
 b=OGcajhWNxzJNIlV8uzOAbd/8nYkr9ywYZVpHbHD8AlYNwFHOgE+okJPBkGwnoW91TaJf
 EpDJ23aj+fn1gotBfP4Y/jnirm92e7b2vnhdhzY96BBUWY/BgsMy7rSpAYw0Atrc2OzX
 oiv2yNAtcRcCJNQFb3+94kwo6yEegQ63ikA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhftutcnb-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:44:03 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Jan 2020 14:44:02 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id EAED629438DC; Tue, 14 Jan 2020 14:43:58 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/5] bpftool: Support dumping a map with btf_vmlinux_value_type_id
Date:   Tue, 14 Jan 2020 14:43:58 -0800
Message-ID: <20200114224358.3027079-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 suspectscore=13 lowpriorityscore=0 mlxlogscore=536
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001140174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a map is storing a kernel's struct, its
map_info->btf_vmlinux_value_type_id is set.  The first map type
supporting it is BPF_MAP_TYPE_STRUCT_OPS.

This series adds support to dump this kind of map with BTF.
The first two patches are bug fixes which only applicable to
in bpf-next.

Please see individual patches for details.

Martin KaFai Lau (5):
  bpftool: Fix a leak of btf object
  bpftool: Fix missing BTF output for json during map dump
  libbpf: Expose bpf_find_kernel_btf to libbpf_internal.h
  bpftool: Add struct_ops map name
  bpftool: Support dumping a map with btf_vmlinux_value_type_id

 tools/bpf/bpftool/map.c         | 84 ++++++++++++++++++---------------
 tools/lib/bpf/libbpf.c          |  3 +-
 tools/lib/bpf/libbpf_internal.h |  1 +
 3 files changed, 49 insertions(+), 39 deletions(-)

-- 
2.17.1

