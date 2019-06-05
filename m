Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0D93609D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfFEP6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:58:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32844 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfFEP6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:58:00 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x55Flqmg011963
        for <netdev@vger.kernel.org>; Wed, 5 Jun 2019 08:57:59 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sx4muj17c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 08:57:59 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Jun 2019 08:57:58 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id E8B2923248ABB; Wed,  5 Jun 2019 08:57:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <bjorn.topel@intel.com>, <magnus.karlsson@intel.com>,
        <toke@redhat.com>, <brouer@redhat.com>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH bpf-next 0/1] bpf: add XDP_SOCK type
Date:   Wed, 5 Jun 2019 08:57:55 -0700
Message-ID: <20190605155756.3779466-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=575 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050099
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Have the xskmap version of bpf_map_lookup_elem() return
an XDP_SOCK type.  This can be used to verify the existence
of an entry, and then check the sock properties.

Further improvements would include passing the pointer 
directly to a helper for redirrection instead of referencing
the map again.

Jonathan Lemon (1):
  bpf: Allow bpf_map_lookup_elem() on an xskmap

 include/linux/bpf.h                           |  8 ++++
 include/net/xdp_sock.h                        |  4 +-
 include/uapi/linux/bpf.h                      |  4 ++
 kernel/bpf/verifier.c                         | 26 +++++++++++-
 kernel/bpf/xskmap.c                           |  7 ++++
 net/core/filter.c                             | 40 +++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  4 ++
 .../bpf/verifier/prevent_map_lookup.c         | 15 -------
 tools/testing/selftests/bpf/verifier/sock.c   | 18 +++++++++
 9 files changed, 107 insertions(+), 19 deletions(-)

-- 
2.17.1

