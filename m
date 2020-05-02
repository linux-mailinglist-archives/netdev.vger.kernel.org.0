Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391D31C22B1
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 06:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgEBEL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 00:11:26 -0400
Received: from pbmsgap01.intersil.com ([192.157.179.201]:33542 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgEBEL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 00:11:26 -0400
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 0423WbBg030627;
        Fri, 1 May 2020 23:36:17 -0400
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap01.intersil.com with ESMTP id 30mgqyuxy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 23:36:17 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1531.3; Fri, 1 May 2020 23:36:16 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1531.3 via Frontend
 Transport; Fri, 1 May 2020 23:36:15 -0400
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v2 net-next 0/3] ptp: Add adjust phase to support phase offset.
Date:   Fri, 1 May 2020 23:35:35 -0400
Message-ID: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_18:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=672
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2005020027
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

This series adds adjust phase to the PTP Hardware Clock device interface.

Some PTP hardware clocks have a write phase mode that has
a built-in hardware filtering capability.  The write phase mode
utilizes a phase offset control word instead of a frequency offset 
control word.  Add adjust phase function to take advantage of this
capability.

Changes since v1:
- As suggested by Richard Cochran:
  1. ops->adjphase is new so need to check for non-null function pointer.
  2. Kernel coding style uses lower_case_underscores.
  3. Use existing PTP clock API for delayed worker.

Vincent Cheng (3):
  ptp: Add adjphase function to support phase offset control.
  ptp: Add adjust_phase to ptp_clock_caps capability.
  ptp: ptp_clockmatrix: Add adjphase() to support PHC write phase mode.

 drivers/ptp/ptp_chardev.c             |  1 +
 drivers/ptp/ptp_clock.c               |  3 ++
 drivers/ptp/ptp_clockmatrix.c         | 92 +++++++++++++++++++++++++++++++++++
 drivers/ptp/ptp_clockmatrix.h         |  8 ++-
 include/linux/ptp_clock_kernel.h      |  6 ++-
 include/uapi/linux/ptp_clock.h        |  4 +-
 tools/testing/selftests/ptp/testptp.c |  6 ++-
 7 files changed, 114 insertions(+), 6 deletions(-)

-- 
2.7.4

