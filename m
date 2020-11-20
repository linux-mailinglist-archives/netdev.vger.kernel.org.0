Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB242BA24D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 07:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgKTG2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 01:28:14 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29992 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725833AbgKTG2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 01:28:14 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK6Q4NH020879;
        Thu, 19 Nov 2020 22:28:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=RTiiY1W5QiroEgCbb5B4H8U08XnFYLJCbRH3ROGnkNA=;
 b=I70+BAE5DkF6tfl6MmQXBhkkXNEhfFXvD8itRmE/2iqsTXH5QZZtSq1IBre4l/6232nl
 COpEj79+a+IHcpbI/bKVG8j3fYxpCm1i6R6CzKx/EmX8BUPRIH3OWerG1vJH9XiB8xch
 VKCIU+kAIXbArqdxFWUi0NxjODekhwNjcjC8wybFc1tjlCc5GKaKJRRznu7duP8Louql
 QDXNcLFC+3e1iiJ+xKCOeGmA1rW+55nsxdCvSjk1R5LTIHdSbAoyWyt0ir1x7ctgaxx/
 1YJFsn4EelYBni90XdJCU7ur404qrI6/a3YnAXsRjDfd2d42fY5xA14/rQIWkIHZECON 9w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34w7ncy0ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 22:28:08 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Nov
 2020 22:28:07 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Nov
 2020 22:28:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 19 Nov 2020 22:28:06 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id A76083F703F;
        Thu, 19 Nov 2020 22:28:02 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>,
        <willemdebruijn.kernel@gmail.com>, <saeed@kernel.org>
Subject: [PATCHv3 net-next 0/3] Add devlink and devlink health reporters to 
Date:   Fri, 20 Nov 2020 11:57:58 +0530
Message-ID: <20201120062801.2821502-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_03:2020-11-19,2020-11-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic devlink and devlink health reporters.
Devlink health reporters are added for NPA and NIX blocks.
These reporters report the error count in respective blocks.

Address Jakub's comment to add devlink support for error reporting.
https://www.spinics.net/lists/netdev/msg670712.html

Change-log:
v3
 - Address Saeed's comments on v2.
 - Renamed the reporter name as hw_*.
 - Call devlink_health_report() when an event is raised.
 - Added recover op too.

v2
 - Address Willem's comments on v1.
 - Fixed the sparse issues, reported by Jakub.

George Cherian (3):
  octeontx2-af: Add devlink suppoort to af driver
  octeontx2-af: Add devlink health reporters for NPA
  octeontx2-af: Add devlink health reporters for NIX

 .../net/ethernet/marvell/octeontx2/Kconfig    |   1 +
 .../ethernet/marvell/octeontx2/af/Makefile    |   3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../marvell/octeontx2/af/rvu_devlink.c        | 972 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_devlink.h        |  82 ++
 .../marvell/octeontx2/af/rvu_struct.h         |  33 +
 7 files changed, 1102 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h

-- 
2.25.1

