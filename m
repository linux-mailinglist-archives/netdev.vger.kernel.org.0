Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479DD31D54E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhBQGNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:13:22 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:54498 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbhBQGNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:13:20 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11H5glCx032617;
        Wed, 17 Feb 2021 00:42:47 -0500
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 36p9tmscnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 00:42:47 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Wed, 17 Feb 2021 00:42:46 -0500
Received: from localhost (132.158.202.108) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Feb 2021 00:42:45 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v3 net-next 0/7] ptp: ptp_clockmatrix: Fix output 1 PPS alignment.
Date:   Wed, 17 Feb 2021 00:42:11 -0500
Message-ID: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_02:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170042
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

This series fixes a race condition that may result in the output clock
not aligned to internal 1 PPS clock.

Part of device initialization is to align the rising edge of output
clocks to the internal rising edge of the 1 PPS clock.  If the system
APLL and DPLL are not locked when this alignment occurs, the alignment
fails and a fixed offset between the internal 1 PPS clock and the
output clock occurs.

If a clock is dynamically enabled after power-up, the output clock
also needs to be aligned to the internal 1 PPS clock.

v3:
Suggested by: Jakub Kicinski <kuba@kernel.org>
- Remove unnecessary 'err' variable
- Increase msleep()/loop accuracy by using jiffies in while()
- No empty lines between variables
- No empty lines between call and the if
- parenthesis around a == b are unnecessary
- Inconsistent \n usage in dev_()
- Remove unnecessary empty line
- Leave string format in place so static code checkers can
  validate arguments

v2:
Suggested by: Richard Cochran <richardcochran@gmail.com>
- Added const to "char * fmt"
- Break unrelated header change into separate patch

Vincent Cheng (7):
  ptp: ptp_clockmatrix: Add wait_for_sys_apll_dpll_lock.
  ptp: ptp_clockmatrix: Add alignment of 1 PPS to idtcm_perout_enable.
  ptp: ptp_clockmatrix: Remove unused header declarations.
  ptp: ptp_clockmatrix: Clean-up dev_*() messages.
  ptp: ptp_clockmatrix: Coding style - tighten vertical spacing.
  ptp: ptp_clockmatrix: Simplify code - remove unnecessary `err`
    variable.
  ptp: ptp_clockmatrix: clean-up - parenthesis around a == b are
    unnecessary

 drivers/ptp/idt8a340_reg.h    |  10 ++
 drivers/ptp/ptp_clockmatrix.c | 313 ++++++++++++++++++------------------------
 drivers/ptp/ptp_clockmatrix.h |  17 ++-
 3 files changed, 162 insertions(+), 178 deletions(-)

-- 
2.7.4

