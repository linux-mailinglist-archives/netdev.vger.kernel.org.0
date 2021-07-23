Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0E3D4032
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhGWRg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:36:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61088 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhGWRg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:36:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NIBgG2015681;
        Fri, 23 Jul 2021 11:16:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=gYnkw50w80YUq7zRjAMU0GSkiBIjHrvh87PnMbJ7r8U=;
 b=iO2AnMsnSkKsmVi8qTYlwoMmlqoeo0eJOgwlo3joQ3dTHnR8eGu6glqZymZG7ATAka7b
 i1iaiZqefbRzZoXg37c7F8fNHyxQtAesco36tyapEDyV38t8Rs6e6Hz5LqMBItSyjRO9
 Y7z5SIrJC8fAPUde3LUJ9i+3h0fVVrDVbB2CUKlf17X7WkobhhczR2Cq0SvzjGwMq53y
 inFhAAdnbVb1LMrCc8rED5O7M7nJ1R0V+/PXfQJD94Bz5ZnTwLB+SAi4qx8zyAqle8xa
 zjOeZLWeYOGsxSazoAXqhX2n5Re+V+WepotORO4GebWazEfzXh8AEFf5sE5QMXE6YakW yw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 39y972dwsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 11:16:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 23 Jul
 2021 11:16:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 23 Jul 2021 11:16:57 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id C59793F7061;
        Fri, 23 Jul 2021 11:16:55 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 0/2] Support ethtool ntuple rule count change
Date:   Fri, 23 Jul 2021 23:46:44 +0530
Message-ID: <1627064206-16032-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: LcSdEj9BCgw1vR7K-68spPKl0j8smY4u
X-Proofpoint-ORIG-GUID: LcSdEj9BCgw1vR7K-68spPKl0j8smY4u
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some NICs share resources like packet filters across
multiple interfaces they support. From HW point of view
it is possible to use all filters for a single interface.
This 2 patch series adds support to modify ntuple rule
count for OcteonTx2 netdev.

Changes from v1:
   * No changes in code.
   * Previous discussion didn't conclude, submiting patches again to revive it.
   * Jakub suggested if devlink-resource can be used for this.
   * But since ntuple rule insert and delete are part of ethtool,
     I thought having this config also in ethtool makes sense ie
     all ntuple related stuff within one tool.
   * Also number of MCAM entries can be changed at runtime
     without a driver reload.

Sunil Goutham (2):
  net: ethtool: Support setting ntuple rule count
  octeontx2-pf: Support setting ntuple rule count

 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  3 +++
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 27 ++++++++++++++++++++--
 include/uapi/linux/ethtool.h                       |  1 +
 net/ethtool/ioctl.c                                |  1 +
 5 files changed, 31 insertions(+), 2 deletions(-)

-- 
2.7.4

