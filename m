Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA0723EEBE
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 16:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgHGOKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 10:10:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48430 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbgHGOKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 10:10:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077EAFXQ026269;
        Fri, 7 Aug 2020 07:10:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=9l8GI0v0BTOsB/VnoX64y9gXiuPeQbQGwJsVjk2zR4c=;
 b=XXapOBhB++f2J9LBGwAiCS5tmw6TyHt/mT5clFHgAqdN1uCgYs62tho41pZbSLcdqqKm
 bwyH1YXzvdAA3rxD4zT7YNQWMggbDyiYXBEimr1FuB9CulFHTatR1aeu+q+dMJsWuILl
 29t+2+VEkz7MEDIErqYHmkUhCJiVLTab0babf1AvuYIuK4qa7vnk74kCsBoynP1+EUl1
 QKJp+mm9JgzkKBDYkM/4Q60qZYhedgFLlYe31E7J5bxTXMur+VLhcBMvo2wO9FfdQenS
 q7cmVAh//dRqgWxqkUAuI/dGP/rKwYjaI6jBafp6bB0GSbqSPyhE0OUzOVwsUX2f2wVW 5w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32s3c992jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 07:10:15 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 Aug
 2020 07:10:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 Aug 2020 07:10:10 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 493B73F7043;
        Fri,  7 Aug 2020 07:10:07 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH v2 0/3] Add Support for Marvell OcteonTX2 Cryptographic
Date:   Fri, 7 Aug 2020 19:39:17 +0530
Message-ID: <1596809360-12597-1-git-send-email-schalla@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_09:2020-08-06,2020-08-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series adds support for Marvell Cryptographic Acceleration
Unit(CPT) on OcteonTX2 CN96XX SoC.
This series is tested with CRYPTO_EXTRA_TESTS enabled and
CRYPTO_DISABLE_TESTS disabled.

Changes since v1:
 * Moved Makefile changes from patch4 to patch2 and patch3.

Srujana Challa (3):
  octeontx2-af: add support to manage the CPT unit
  drivers: crypto: add support for OCTEONTX2 CPT engine
  drivers: crypto: add the Virtual Function driver for OcteonTX2 CPT

 drivers/crypto/marvell/Kconfig                     |   17 +
 drivers/crypto/marvell/Makefile                    |    1 +
 drivers/crypto/marvell/octeontx2/Makefile          |   10 +
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
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |  536 +++++
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   85 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    7 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  343 +++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  342 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   76 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   65 +-
 29 files changed, 10077 insertions(+), 8 deletions(-)
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

