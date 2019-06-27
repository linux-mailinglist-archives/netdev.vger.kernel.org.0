Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADF658DA7
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfF0WIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:08:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726498AbfF0WIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:08:41 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RM5cHR001671
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:40 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2td0y51dd8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:40 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 15:08:39 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8BB95240E9952; Thu, 27 Jun 2019 15:08:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <brouer@redhat.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 0/6 bpf-next] xsk: reuseq cleanup
Date:   Thu, 27 Jun 2019 15:08:30 -0700
Message-ID: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=908 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270254
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up and normalize usage of the recycle queue in order to
support upcoming TX from RX queue functionality.

Jonathan Lemon (6):
  Have xsk_umem_peek_addr_rq() return chunk-aligned handles.
  Clean up xsk reuseq API
  Always check the recycle stack when using the umem fq.
  Simplify AF_XDP umem allocation path for Intel drivers.
  Remove use of umem _rq variants from Mellanox driver.
  Remove the umem _rq variants now that the last consumer is gone.

 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 86 +++----------------
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 59 ++-----------
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  8 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |  7 +-
 include/net/xdp_sock.h                        | 69 ++-------------
 net/xdp/xdp_umem.c                            |  2 +-
 net/xdp/xsk.c                                 | 22 ++++-
 net/xdp/xsk_queue.c                           | 56 +++++-------
 net/xdp/xsk_queue.h                           |  2 +-
 10 files changed, 68 insertions(+), 245 deletions(-)

-- 
2.17.1

