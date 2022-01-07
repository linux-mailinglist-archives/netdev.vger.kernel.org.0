Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CA1487312
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 07:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiAGGas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 01:30:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20462 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231627AbiAGGar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 01:30:47 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2072GYJ1006230;
        Thu, 6 Jan 2022 22:30:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=7OM+IiDSGKDxS8gIHoXIE265R/tIByzE6TCUnmPriRk=;
 b=Doa8yQHcqg6e6/ylco+DWT1zLvK9Zi0Ox1+zq66rssS40OMZmE3G1shDqF7o2zUrO8Ia
 xub0UmkAanMIkzucM9lLEiPVoF0nEPRoVIph9Hn0ei1+mmr99dysS1XcJpt8J8VHP3nc
 tWKwC+HYo89HQXALYRwEC0n5A6WG8wg0OtW5eK8J6IXwAZn2gQixpmYv9AcIDM8tTk0c
 5mRzJO2DfqAAIlAbaA/PxNxBHAD/oQ9bUuqVbDJ71DYEXQTBW16oxBzB/HBAcZ4PF7KM
 rz2+z+g6w8rlbrr1ipEEwwehHnkIMyU7Tj2G3JnsZpBSW/G5LQFObxkhjwUxjrzE2qqZ 9w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3de4w5j28n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 22:30:37 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 6 Jan
 2022 22:30:35 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 6 Jan 2022 22:30:35 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 399373F7069;
        Thu,  6 Jan 2022 22:30:32 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        <rsaladi2@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 0/2] octeontx2: Fix PTP bugs
Date:   Fri, 7 Jan 2022 12:00:28 +0530
Message-ID: <1641537030-27911-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0bRxOqswBJsIFGq_GtBUMhtvlRuBJl-B
X-Proofpoint-GUID: 0bRxOqswBJsIFGq_GtBUMhtvlRuBJl-B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_01,2022-01-06_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset addresses two problems found when using
ptp.
Patch 1 - Increases the refcount of ptp device before use
which was missing and it lead to refcount increment after use
bug when module is loaded and unloaded couple of times.
Patch 2 - PTP resources allocated by VF are not being freed
during VF teardown. This patch fixes that.

Thanks,
Sundeep


Rakesh Babu Saladi (1):
  octeontx2-nicvf: Free VF PTP resources.

Subbaraya Sundeep (1):
  octeontx2-af: Increment ptp refcount before use

 drivers/net/ethernet/marvell/octeontx2/af/ptp.c      | 2 ++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.7.4

