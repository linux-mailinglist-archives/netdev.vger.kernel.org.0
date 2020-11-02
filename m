Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24252A23E4
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 06:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgKBFG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 00:06:59 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17026 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgKBFG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 00:06:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A255Xrh013119;
        Sun, 1 Nov 2020 21:06:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=xSoLjXb0B85PfUHERptiyF/QueGdjc/bfi/Ey6OUUOA=;
 b=go/1BOdWa1+PV7Nvw0V2sw53XPYMkeJi/Kll/fMIN6CZ/iiMIAUz5Q8wLMOgJ8CshKC1
 k2UJFzbqSBTqgPglpqIDT6PkLXoonW/pyBZZsVW7qSw10N6jBThuWqjK5/D+KOsef43K
 IowDdioo4rTBSp5qkc/sAHbiE9l9fjC4ljd3tDV9Eazs0jfpjYiGjtuc8QeN460n4YJf
 vJxqtc7FHXzx+Y9WxTJaC9J8HBCHE/e3yVVLwmtCk37FanlNUpgqIVTd2fLmb6Y1medf
 THTUXYfXZVVc4KMLqLNU5Gd7WQCGcENef/wX5J08axRpYkHaFALqj+UruhQ4V+vT/xH7 7Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7ennyu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Nov 2020 21:06:55 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 21:06:53 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 1 Nov 2020 21:06:54 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 1B7F23F703F;
        Sun,  1 Nov 2020 21:06:50 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>
Subject: [net-next PATCH 0/3] Add devlink and devlink health reporters to
Date:   Mon, 2 Nov 2020 10:36:46 +0530
Message-ID: <20201102050649.2188434-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_01:2020-10-30,2020-11-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic devlink and devlink health reporters.
Devlink health reporters are added for NPA and NIX blocks.
These reporters report the error count in respective blocks.

Address Jakub's comment to add devlink support for error reporting.
https://www.spinics.net/lists/netdev/msg670712.html


George Cherian (3):
  octeontx2-af: Add devlink suppoort to af driver
  octeontx2-af: Add devlink health reporters for NPA
  octeontx2-af: Add devlink health reporters for NIX

 .../net/ethernet/marvell/octeontx2/Kconfig    |   1 +
 .../ethernet/marvell/octeontx2/af/Makefile    |   3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   5 +-
 .../marvell/octeontx2/af/rvu_devlink.c        | 875 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_devlink.h        |  67 ++
 .../marvell/octeontx2/af/rvu_struct.h         |  33 +
 7 files changed, 990 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h

-- 
2.25.1

