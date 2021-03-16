Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245CC33DCA4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240044AbhCPSfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:35:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10970 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240034AbhCPSee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:34:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GIGx6C026702;
        Tue, 16 Mar 2021 11:34:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=h+h9oei2djDSyPKRVeWJU5FY3F6YQP28SNKH9X2lmuA=;
 b=AsZo8KpH4YjXQSR3CTuZd+PEcpeDmw9z28oDRq312kUh2cmgpBY4rq0Gk3Qsft6/cjdJ
 dYmMLignCULeK6MgzWJYdrkAFbiaBeqy/ig4llTScNSJQG4zTcMm8+zFKxuzuh3VKgQ8
 SCdGMfmGfpZuUQS+T5VCmZK702+Vvoo9VOr2tgsrD+WG7edTQ7JzTHPWBAtGWlPbFvqM
 WIYAu8MJIT9ThhYxrQxbhOCUou9sneoPefEWL4uszeY/XxbF2PcOspdKRugo79mB4zTn
 qzW3LTm2wmQdGrDgxE7c7Cd2Wj1caqiynUk2/EiEXGAEdu9bUhC+NrEEOo1/sMkFh1ju ag== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqsg81-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 11:34:30 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 14:34:28 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 14:34:28 -0400
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id F326A3F703F;
        Tue, 16 Mar 2021 11:34:27 -0700 (PDT)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <davem@davemloft.net>, <bupadhaya@marvell.com>
Subject: [PATCH net 0/2] qede: fix ethernet self adapter and skb failure issue
Date:   Tue, 16 Mar 2021 11:34:08 -0700
Message-ID: <1615919650-4262-1-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_06:2021-03-16,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Fix ethernet self adapter test issue by preventing start_xmit
	 function to be called.start_xmit function should not be called
	 during the execution of self adapter test, netif_tx_disable()
	 ensures this.
Patch 2: Fix to return proper error code when sdk buffer allocation fails.

Bhaskar Upadhaya (2):
  qede: fix to disable start_xmit functionality during self adapter test
  qede: fix memory allocation failures under heavy load

 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  4 +++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    | 19 +++++++++++++------
 2 files changed, 16 insertions(+), 7 deletions(-)

-- 
2.17.1

