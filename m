Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6B831500
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfEaS5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:57:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57486 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726308AbfEaS5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:57:09 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4VIrTvp019410
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:57:08 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2su9rbg1uw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:57:08 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 31 May 2019 11:57:07 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id D742622F2BC06; Fri, 31 May 2019 11:57:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v3 bpf-next 0/2] Better handling of xskmap entries
Date:   Fri, 31 May 2019 11:57:03 -0700
Message-ID: <20190531185705.2629959-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=337 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Respin of v2 to fix stupid error.

Testing with samples/bpf/xdpsock:
[root@kerneltest004.06.atn2 ~]# ./xdpsock  -i eth0 -q 0

 sock0@eth0:0 rxdrop	
                pps         pkts        1.00       
rx              17          17         
tx              0           0          


Jonathan Lemon (2):
  bpf: Allow bpf_map_lookup_elem() on an xskmap
  libbpf: remove qidconf and better support external bpf programs.

 include/net/xdp_sock.h                        |  6 +-
 kernel/bpf/verifier.c                         |  6 +-
 kernel/bpf/xskmap.c                           |  4 +-
 tools/lib/bpf/xsk.c                           | 79 ++++---------------
 .../bpf/verifier/prevent_map_lookup.c         | 15 ----
 5 files changed, 27 insertions(+), 83 deletions(-)

-- 
2.17.1

