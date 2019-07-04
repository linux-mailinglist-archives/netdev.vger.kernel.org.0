Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E565F909
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfGDNV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:21:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52146 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbfGDNV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 09:21:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x64DJVff007553;
        Thu, 4 Jul 2019 06:21:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=UyGhsk3CVfyVsUCxPVnkxm8hRsOniV1lcu/caVjYV+Q=;
 b=e9HGH3NEsplGXlhW5vxtwdBvXDHG0SXFvnc+jQ5BY6dAX2q63tYiVUrfXC/I42hDcxJp
 Uw/6FWpKUbA7YpxWG57Y9KWDnjqcY4ohToz3ppMjGOp6aOH30IvxdKeFnAIrovC2Q5Tu
 UqjRFF7mTW27gHIsf/D1EQ+jFsoGNMm22Vi6lxrr5Mmi/IPnxiuNUdDbCAfqcgD9s72S
 NdNHElqRdlYXRkQ1TL+J+xwCqLOwtC8HTBEv2Nst5dHpkl6cZKxUls6T3vcI3vHMNaTz
 H92ZDqFeZr0tRxZ88WpCU3oZdchE0mLsco1gRaaaVbjkFhu89970OwD1ZXow8cIG967k Fw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tgtf75hb2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 04 Jul 2019 06:21:24 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 4 Jul
 2019 06:21:23 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 4 Jul 2019 06:21:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 768043F703F;
        Thu,  4 Jul 2019 06:21:23 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x64DLNmN013653;
        Thu, 4 Jul 2019 06:21:23 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x64DLMMI013652;
        Thu, 4 Jul 2019 06:21:22 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next v2 0/4] qed*/devlink: Devlink support for config attributes.
Date:   Thu, 4 Jul 2019 06:20:07 -0700
Message-ID: <20190704132011.13600-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-04_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series adds support for managing the config attributes using
devlink interfaces.

Patch (1) adds the APIs for publishing the devlink port params. Clubbing
this qed patches as per the review comment (i.e., need at least one
consumer for the new APIs).

Patches (2)-(4) adds the qed/qede devlink support for managing the
device/port attributes.

Please consider applying it to 'net-next' tree.

Sudarsana Reddy Kalluru (4):
  devlink: Add APIs to publish/unpublish the port parameters.
  qed: Add APIs for device attributes configuration.
  qed*: Add new file for devlink implementation.
  qed*: Add devlink support for configuration attributes.

 Documentation/networking/devlink-params-qede.txt |  72 ++++++
 drivers/net/ethernet/qlogic/qed/qed.h            |   1 -
 drivers/net/ethernet/qlogic/qed/qed_hsi.h        |  17 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c       | 160 ++++--------
 drivers/net/ethernet/qlogic/qed/qed_mcp.c        |  64 +++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h        |  14 ++
 drivers/net/ethernet/qlogic/qede/Makefile        |   2 +-
 drivers/net/ethernet/qlogic/qede/qede.h          |   5 +
 drivers/net/ethernet/qlogic/qede/qede_devlink.c  | 294 +++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qede/qede_devlink.h  |  41 ++++
 drivers/net/ethernet/qlogic/qede/qede_main.c     |  13 +
 include/linux/qed/qed_if.h                       |  19 ++
 include/net/devlink.h                            |   2 +
 net/core/devlink.c                               |  42 ++++
 14 files changed, 634 insertions(+), 112 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-qede.txt
 create mode 100644 drivers/net/ethernet/qlogic/qede/qede_devlink.c
 create mode 100644 drivers/net/ethernet/qlogic/qede/qede_devlink.h

-- 
1.8.3.1

