Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2EC1BECFF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD3Aeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:34:31 -0400
Received: from pbmsgap01.intersil.com ([192.157.179.201]:48322 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgD3Aea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 20:34:30 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2020 20:34:30 EDT
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 03U0P6iB005024;
        Wed, 29 Apr 2020 20:28:46 -0400
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap01.intersil.com with ESMTP id 30mgqytds5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 20:28:46 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1531.3; Wed, 29 Apr 2020 20:28:45 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1531.3 via Frontend
 Transport; Wed, 29 Apr 2020 20:28:44 -0400
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next 0/3] ptp: Add adjust phase to support phase offset.
Date:   Wed, 29 Apr 2020 20:28:22 -0400
Message-ID: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_11:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=661
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2004300000
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

Vincent Cheng (3):
  ptp: Add adjphase function to support phase offset control.
  ptp: Add adjust_phase to ptp_clock_caps capability.
  ptp: ptp_clockmatrix: Add adjphase() to support PHC write phase mode.

 drivers/ptp/ptp_chardev.c             |   1 +
 drivers/ptp/ptp_clock.c               |   2 +
 drivers/ptp/ptp_clockmatrix.c         | 123 ++++++++++++++++++++++++++++++++++
 drivers/ptp/ptp_clockmatrix.h         |  11 ++-
 include/linux/ptp_clock_kernel.h      |   6 +-
 include/uapi/linux/ptp_clock.h        |   4 +-
 tools/testing/selftests/ptp/testptp.c |   6 +-
 7 files changed, 147 insertions(+), 6 deletions(-)

-- 
2.7.4

