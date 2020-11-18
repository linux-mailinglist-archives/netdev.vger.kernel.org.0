Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBE62B7CFC
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 12:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgKRLoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 06:44:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60820 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725781AbgKRLog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 06:44:36 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIBeeZP008926;
        Wed, 18 Nov 2020 03:44:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=XMIMJoVEnbjVXt8e/8JPsVEAUrWRiQ4k0RNhkrNlDl0=;
 b=krAWRZd5lX4bM0DfDXFQ5ew6My95hDp0AQobwu8FGcmFn7sL30R1x6fc4yOhm2mJdVjG
 XoCUnrzCZtthjkC9Xbb8rTr8aePib4GLSJQTUUdXfjglID9zly3xRNhlH2OU4g7mCteF
 zSy72o6Id09VJWN+6lvTFrLgAglExdELan1F+0kN16WeIrsz9DabjXgVOutuXolZ+pCT
 LwnHCsZ0jGUEXePWgh3+fRjjEfEaRobtsNzVOVCEcEHksm67veaJVaoLc1napsKA22X6
 1k6cnE7pMlsT/MyGmtUCffK1Tu9cjYuSX008kBRe4N9S4lRboG7F9Rt8H385vi7jBh5/ 6w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34vd2scyrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 03:44:29 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 03:44:28 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 03:44:27 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 03:44:27 -0800
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 7382D3F703F;
        Wed, 18 Nov 2020 03:44:24 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v10,net-next,0/3] Add Support for Marvell OcteonTX2 Cryptographic
Date:   Wed, 18 Nov 2020 17:14:13 +0530
Message-ID: <20201118114416.28307-1-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_04:2020-11-17,2020-11-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for CPT in OcteonTX2 admin function(AF).
CPT is a cryptographic accelerator unit and it includes microcoded
Giga Cipher engines.

OcteonTX2 SOC's resource virtualization unit (RVU) supports multiple
physical and virtual functions. Each of the PF/VF's functionality is
determined by what kind of resources are attached to it. When the CPT
block is attached to a VF, it can function as a security device.
The following document provides an overview of the hardware and
different drivers for the OcteonTX2 SOC:
https://www.kernel.org/doc/Documentation/networking/device_drivers/marvell/octeontx2.rst

This patch series includes:
- Patch to update existing Marvell sources to support CPT.
- Patch that adds mailbox messages to the admin function (AF) driver,
to configure CPT HW registers.
- Patch to provide debug information about CPT.

Changes since v9:
 * Dropped CPT PF & VF driver patches to submit to cryptodev-2.6 in next
   release cycle.
Changes since v8:
 * Load firmware files individually instead of tar.
Changes since v7:
 * Removed writable entries in debugfs.
 * Dropped IPsec support.
Changes since v6:
 * Removed driver version.
Changes since v4:
 * Rebased the patches onto net-next tree with base
   'commit bc081a693a56 ("Merge branch 'Offload-tc-vlan-mangle-to-mscc_ocelot-switch'")'
Changes since v3:
 * Splitup the patches into smaller patches with more informartion.
Changes since v2:
 * Fixed C=1 warnings.
 * Added code to exit CPT VF driver gracefully.
 * Moved OcteonTx2 asm code to a header file under include/linux/soc/
Changes since v1:
 * Moved Makefile changes from patch4 to patch2 and patch3.

Srujana Challa (3):
  octeontx2-pf: move lmt flush to include/linux/soc
  octeontx2-af: add mailbox interface for CPT
  octeontx2-af: add debugfs entries for CPT block

 MAINTAINERS                                   |   2 +
 .../ethernet/marvell/octeontx2/af/Makefile    |   3 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  33 +++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   1 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 233 +++++++++++++++
 .../marvell/octeontx2/af/rvu_debugfs.c        | 272 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  63 +++-
 .../marvell/octeontx2/nic/otx2_common.h       |  13 +-
 include/linux/soc/marvell/octeontx2/asm.h     |  29 ++
 9 files changed, 630 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
 create mode 100644 include/linux/soc/marvell/octeontx2/asm.h

-- 
2.29.0

