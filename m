Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF84556FA7
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbiFWA51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiFWA50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:57:26 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4979424A3
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 17:57:25 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id AFCB1500595;
        Thu, 23 Jun 2022 03:55:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru AFCB1500595
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1655945752; bh=Z3VPOXlEIyZkbyzWiNB3Eqk93h6pysvYRwvSPBIT3yY=;
        h=From:To:Cc:Subject:Date:From;
        b=k0LvFcy28ieSK8FqZtlQZfWUsjZKzZsZT1qbUTtI0vOwBiTVOvDFUC24PaFrc4ioa
         Ky2o+SSLpPBTASZxPHTdDEX9LM+0XJ0jcFz6kqUDvof6FRxHzV2G3OnxpRLQAhsCvS
         S0WrZvPJPOZ0EcqmFmYJpjk1tuZIAvSp3qUp0XCc=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH v1 0/3] Create common DPLL/clock configuration API
Date:   Thu, 23 Jun 2022 03:57:14 +0300
Message-Id: <20220623005717.31040-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Implement common API for clock/DPLL configuration and status reporting.
The API utilises netlink interface as transport for commands and event
notifications. This API aim to extend current pin configuration and
make it flexible and easy to cover special configurations.

v0 -> v1:
 * fix code style and errors
 * add linux-arm mailing list

Vadim Fedorenko (3):
  dpll: Add DPLL framework base functions
  dpll: add netlink events
  ptp_ocp: implement DPLL ops

 MAINTAINERS                 |   8 +
 drivers/Kconfig             |   2 +
 drivers/Makefile            |   1 +
 drivers/dpll/Kconfig        |   7 +
 drivers/dpll/Makefile       |   7 +
 drivers/dpll/dpll_core.c    | 154 ++++++++++
 drivers/dpll/dpll_core.h    |  40 +++
 drivers/dpll/dpll_netlink.c | 578 ++++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.h |  14 +
 drivers/ptp/Kconfig         |   1 +
 drivers/ptp/ptp_ocp.c       |  86 ++++++
 include/linux/dpll.h        |  25 ++
 include/uapi/linux/dpll.h   |  77 +++++
 13 files changed, 1000 insertions(+)
 create mode 100644 drivers/dpll/Kconfig
 create mode 100644 drivers/dpll/Makefile
 create mode 100644 drivers/dpll/dpll_core.c
 create mode 100644 drivers/dpll/dpll_core.h
 create mode 100644 drivers/dpll/dpll_netlink.c
 create mode 100644 drivers/dpll/dpll_netlink.h
 create mode 100644 include/linux/dpll.h
 create mode 100644 include/uapi/linux/dpll.h

-- 
2.27.0

