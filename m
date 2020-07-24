Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA27122C5BE
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGXNIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:08:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27050 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726182AbgGXNIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:08:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06OD5C49016534;
        Fri, 24 Jul 2020 06:08:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=y3RydmnB8M7VO029cO4XjG6CTtcx3iqIXOuriZpwN60=;
 b=iupiY9tcklBGD3o+dZyqvtOLv8KfzFOIAAXB7mnWZVjQN84mzE8NSbs66vssE7/6UNDi
 sSwTk1jydi4Ez/WDd181k8Ekbk5aktalOeCKj3XOvrfe9W25+F5y4feOiM7YlvTxa8zm
 98ZuwJp7xBoDGPn35hbZNST8PjCI6xEdMcxYFUK2r0/zdb4rBp0gkfL7/XkJKGIHy8kF
 i88zx3mL4ZBsTih5drnlXzzVjiyWf98rDH6ZGwnDtxA49wGhqKEqPRVJqzL7vluy3fmr
 2P9FY5I0tmw+saBNeWw6ePYUKAaOWGUwCdAnggnIvs6yVew1hJZYYkrKv0FxDyB422ZS jA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0km1t4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 06:08:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul
 2020 06:08:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul
 2020 06:08:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Jul 2020 06:08:26 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id D75113F7040;
        Fri, 24 Jul 2020 06:08:23 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <sgoutham@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH 0/4] Add Support for Marvell OcteonTX2 Cryptographic
Date:   Fri, 24 Jul 2020 18:38:00 +0530
Message-ID: <1595596084-29809-1-git-send-email-schalla@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_04:2020-07-24,2020-07-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series adds support for Marvell Cryptographic Acceleration
Unit(CPT) on OcteonTX2 CN96XX SoC.
This series is tested with CRYPTO_EXTRA_TESTS enabled and
CRYPTO_DISABLE_TESTS disabled.

Srujana Challa (4):
  octeontx2-af: add support to manage the CPT unit
  drivers: crypto: add support for OCTEONTX2 CPT engine
  drivers: crypto: add the Virtual Function driver for OcteonTX2 CPT
  crypto: marvell: enable OcteonTX2 cpt options for build

 drivers/crypto/marvell/Kconfig                     |   17 +
 drivers/crypto/marvell/Makefile                    |    1 +
 drivers/crypto/marvell/octeontx2/Makefile          |   14 +
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |   53 +
 .../crypto/marvell/octeontx2/otx2_cpt_hw_types.h   |  572 ++++++
 .../marvell/octeontx2/otx2_cpt_mbox_common.c       |  286 +++
 .../marvell/octeontx2/otx2_cpt_mbox_common.h       |  100 +
 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h |  202 ++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h      |  370 ++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c |  964 +++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h      |   79 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |  599 ++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c |  694 +++++++
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    | 2173 ++++++++++++++++++++
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.h    |  180 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h      |   29 +
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 1708 +++++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h |  172 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |  229 +++
 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c |  189 ++
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |  543 +++++
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   85 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    7 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  343 +++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  342 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   76 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   65 +-
 29 files changed, 10088 insertions(+), 8 deletions(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c

-- 
1.9.1

