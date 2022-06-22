Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBC9553F55
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 02:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiFVAHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 20:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiFVAHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 20:07:00 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD3A14D37
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 17:06:59 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 0F227500084;
        Wed, 22 Jun 2022 03:05:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 0F227500084
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1655856328; bh=+MmJR6FSY2vO3bJWiEblanx6sijFokKt7tA4B0hPP5s=;
        h=From:To:Cc:Subject:Date:From;
        b=VeXQh6t5rJU/cAwrRucOnejZaEnp/F9P8KDC2t7CgrAiR9jXpS5Tz0O+1j8Qfd4OB
         fynj6b/jftLCv/l1/PEH9h8fzOIP8/UoH4+j09AHwzdMsvLiLRjMJH6gtpkT2gUuUZ
         MiXxwma8u3hYDYhBI5xriUBRipHhTmkxbjx32OM0=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] Create common DPLL/clock configuration API
Date:   Wed, 22 Jun 2022 03:06:48 +0300
Message-Id: <20220622000651.27299-1-vfedorenko@novek.ru>
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

Vadim Fedorenko (3):
  dpll: Add DPLL framework base functions
  dpll: add netlink events
  ptp_ocp: implement DPLL ops

 MAINTAINERS                 |   8 +
 drivers/Kconfig             |   2 +
 drivers/Makefile            |   1 +
 drivers/dpll/Kconfig        |   7 +
 drivers/dpll/Makefile       |   7 +
 drivers/dpll/dpll_core.c    | 146 +++++++++
 drivers/dpll/dpll_core.h    |  40 +++
 drivers/dpll/dpll_netlink.c | 583 ++++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.h |  14 +
 drivers/ptp/Kconfig         |   1 +
 drivers/ptp/ptp_ocp.c       |  85 ++++++
 include/linux/dpll.h        |  24 ++
 include/uapi/linux/dpll.h   |  77 +++++
 13 files changed, 995 insertions(+)
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

