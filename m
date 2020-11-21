Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4302BBCD2
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 05:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgKUECR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 23:02:17 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65106 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbgKUECR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 23:02:17 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AL40aoD011653;
        Fri, 20 Nov 2020 20:02:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=iZ7Ev6OTjObwBpiSSazKwfkX5akX9Ugr56b+UoEefH8=;
 b=c45mnWtHSSo73YLZ2j2/P0Xy1kczAleNHJlEodyuEHKw0Nw3XB9cqBRTX2pebG7xqpYX
 qg9HeVr0L2/tG7l6RZOUCz9udgEy+SiQ+L91+rLbhPKuH55LyN4t26nFKc8P3VfEthWC
 36UzemddErttMyY5lPMrt0IcfHftsLZiOuN0187Xdbn/fL5LUgQRi+IYjahn1dysC2JW
 E6+IrL2C/wJ7R5UVwyMA7wOudlYXThPT2B1d4IbQMM1097iqJ3P/PsOMdxA0pV5XLAlf
 dsYIykcz1KKNnXY6Vx9LKrYdwqomQ+5Y5NFxjLI59InEz0Ka6fXHptXqZkXR8xrpjjPl QA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34w7nd2jsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 20:02:12 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Nov
 2020 20:02:11 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 20 Nov 2020 20:02:11 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 883283F7045;
        Fri, 20 Nov 2020 20:02:04 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>,
        <willemdebruijn.kernel@gmail.com>, <saeed@kernel.org>
Subject: [PATCHv3 net-next 0/3] Add devlink and devlink health reporters to 
Date:   Sat, 21 Nov 2020 09:31:58 +0530
Message-ID: <20201121040201.3171542-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-21_02:2020-11-20,2020-11-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic devlink and devlink health reporters.
Devlink health reporters are added for NPA and NIX blocks.
These reporters report the error count in respective blocks.

Address Jakub's comment to add devlink support for error reporting.
https://www.spinics.net/lists/netdev/msg670712.html

Change-log:
v4 
 - Rebase to net-next (no logic changes).
 
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
 .../ethernet/marvell/octeontx2/af/Makefile    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../marvell/octeontx2/af/rvu_devlink.c        | 972 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_devlink.h        |  82 ++
 .../marvell/octeontx2/af/rvu_struct.h         |  33 +
 7 files changed, 1101 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h

-- 
2.25.1

