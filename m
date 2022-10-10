Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394305F9687
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 03:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiJJBTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 21:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiJJBSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 21:18:49 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F012D303CD;
        Sun,  9 Oct 2022 18:18:45 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id DAF2D504AE0;
        Mon, 10 Oct 2022 04:14:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru DAF2D504AE0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665364488; bh=eIx0GJ/f4awLP5PFW0SIJ0eabOt5oi27kRTYl48YUHU=;
        h=From:To:Cc:Subject:Date:From;
        b=xslZqpfvdk4K/9NvP3Z3xNR/oDBMNNETbH/VfNa0VGafScg2SplIA3SXNB+jULq4t
         wWiUrPwwgsQ3Ilhx7cCYmmFranMP0YG3RdX31PnxENEgGiVezJv4qFXizW6q84EQGo
         ucfn9RU5pnyw1b3vIju//zQWD8qgOrvliwJ9hRiM=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [RFC PATCH v3 0/5] Create common DPLL/clock configuration API
Date:   Mon, 10 Oct 2022 04:17:58 +0300
Message-Id: <20221010011804.23716-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement common API for clock/DPLL configuration and status reporting.
The API utilises netlink interface as transport for commands and event
notifications. This API aim to extend current pin configuration and
make it flexible and easy to cover special configurations.

v2 -> v3:
 * implement source select mode (Arkadiusz)
 * add documentation
 * implementation improvements (Jakub)
v1 -> v2:
 * implement returning supported input/output types
 * ptp_ocp: follow suggestions from Jonathan
 * add linux-clk mailing list
v0 -> v1:
 * fix code style and errors
 * add linux-arm mailing list

Arkadiusz Kubalewski (2):
  dpll: add support for source selection modes
  dpll: get source/output name

Vadim Fedorenko (3):
  dpll: add netlink events
  dpll: documentation on DPLL subsystem interface
  ptp_ocp: implement DPLL ops

 Documentation/networking/dpll.rst  | 157 +++++++++++++
 Documentation/networking/index.rst |   1 +
 drivers/dpll/dpll_core.c           |   3 +
 drivers/dpll/dpll_netlink.c        | 346 ++++++++++++++++++++++++++++-
 drivers/dpll/dpll_netlink.h        |   5 +
 drivers/ptp/Kconfig                |   1 +
 drivers/ptp/ptp_ocp.c              | 170 +++++++++++---
 include/linux/dpll.h               |  14 ++
 include/uapi/linux/dpll.h          |  26 ++-
 9 files changed, 678 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/networking/dpll.rst

-- 
2.27.0

