Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E3A2CC1F8
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgLBQSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:18:47 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:53998 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728503AbgLBQSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:18:47 -0500
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2G2kHM020078;
        Wed, 2 Dec 2020 11:18:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=smtpout1; bh=KKtMcRRuRaa2iQTACw2ISjeqc+9U7fbuIz2AU7EVIX4=;
 b=RSwfAinnEjKSdhouTovNqDIZFP4gK+1vPNV2VFLLUTPIpyZP05TTayCgXr5lHcUdJagr
 +yrQXxUpUi4BxXoZXcC9C4eZSX0qOYJxL/HlxNg7TFOio0LSiEm7PDq7qNQZjnsrOM7R
 I8kJTbHLi4jGw/NgGt4txftDGJe8jfPAQysSwF6Uv/zARjfPyZW0BHe8kYy8g9m9OSRl
 pBNcYD6eDBgC5DJ8RFk5UT/LRHCS/yELMBxggmThrqdNILkPBm1f/M8PeWh4VFaxOQvm
 mc0Nk5u1XIxeNqPmSIzZRj495Q51FRk35A/VdghN1U8TxRSSnGrYNTHAFLDxlDDPOrf8 Dw== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 353jrq0n53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 11:18:06 -0500
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2GDDaS114781;
        Wed, 2 Dec 2020 11:18:05 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 3565vm86w5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 11:18:05 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,387,1599541200"; 
   d="scan'208";a="1013735359"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        Mario Limonciello <mario.limonciello@dell.com>
Subject: [PATCH v2 0/5] Improve s0ix flows for systems i219LM
Date:   Wed,  2 Dec 2020 10:17:43 -0600
Message-Id: <20201202161748.128938-1-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxlogscore=732
 lowpriorityscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020096
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=844 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
disabled s0ix flows for systems that have various incarnations of the
i219-LM ethernet controller.  This was done because of some regressions
caused by an earlier
commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case")
with i219-LM controller.

Performing suspend to idle with these ethernet controllers requires a properly
configured system.  To make enabling such systems easier, this patch
series allows turning on using ethtool.

The flows have also been confirmed to be configured correctly on Dell's Latitude
and Precision CML systems containing the i219-LM controller, when the kernel also
contains the fix for s0i3.2 entry previously submitted here:
https://marc.info/?l=linux-netdev&m=160677194809564&w=2

Patches 3 and 4 will turn the behavior on by default for Dell's CML systems.
Patch 5 allows accessing the value of the flags via ethtool to tell if the
heuristics have turned on s0ix flows, as well as for development purposes
to determine if a system should be added to the heuristics list.

Changes from v1 to v2:
 - Directly incorporate Vitaly's dependency patch in the series
 - Split out s0ix code into it's own file
 - Adjust from DMI matching to PCI subsystem vendor ID/device matching
 - Remove module parameter and sysfs, use ethtool flag instead.
 - Export s0ix flag to ethtool private flags
 - Include more people and lists directly in this submission chain.

Mario Limonciello (4):
  e1000e: Move all s0ix related code into it's own source file
  e1000e: Add Dell's Comet Lake systems into s0ix heuristics
  e1000e: Add more Dell CML systems into s0ix heuristics
  e1000e: Export adapter flags to ethtool

Vitaly Lifshits (1):
  e1000e: fix S0ix flow to allow S0i3.2 subset entry

 drivers/net/ethernet/intel/e1000e/Makefile  |   2 +-
 drivers/net/ethernet/intel/e1000e/e1000.h   |   4 +
 drivers/net/ethernet/intel/e1000e/ethtool.c |  23 ++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 272 +----------------
 drivers/net/ethernet/intel/e1000e/s0ix.c    | 308 ++++++++++++++++++++
 5 files changed, 341 insertions(+), 268 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/e1000e/s0ix.c

--
2.25.1

