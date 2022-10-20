Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59B2606C0A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 01:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJTXZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 19:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJTXZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 19:25:13 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A15913F39
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:25:10 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 798EC504EE9;
        Fri, 21 Oct 2022 02:21:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 798EC504EE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666308062; bh=kvR7yPDLwEkhCih5CgQg7eQiijT3JUlYPxhoWnTXeeE=;
        h=From:To:Cc:Subject:Date:From;
        b=f14u1h2gv3V4KU6ZgYy3re/naMMbOAz9SGRuylsavoRb3BBjak680iOlacLaUN10A
         QbmTU18NfihtDqwQBB6/3h7XeMRM5U4ZgeqUX8els/AlrDyJ7Z+qj6tWxWqG+yT64K
         wt3F6yybHSZ//D7kHSbZbcHo8BQE+Ro2zsRbybDM=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net-next v6 0/5] ptp: ocp: add support for Orolia ART-CARD
Date:   Fri, 21 Oct 2022 02:24:28 +0300
Message-Id: <20221020232433.9593-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Orolia company created alternative open source TimeCard. The hardware of
the card provides similar to OCP's card functions, that's why the support
is added to current driver.

The first patch in the series changes the way to store information about
serial ports and is more like preparation.

The patches 2 to 4 introduces actual hardware support.

The last patch removes fallback from devlink flashing interface to protect
against flashing wrong image. This became actual now as we have 2 different
boards supported and wrong image can ruin hardware easily.

v2:
  Address comments from Jonathan Lemon

v3:
  Fix issue reported by kernel test robot <lkp@intel.com>

v4:
  Fix clang build issue

v5:
  Fix warnings and per-patch build errors

v6:
  Fix more style issues

Vadim Fedorenko (5):
  ptp: ocp: upgrade serial line information
  ptp: ocp: add Orolia timecard support
  ptp: ocp: add serial port of mRO50 MAC on ART card
  ptp: ocp: expose config and temperature for ART card
  ptp: ocp: remove flash image header check fallback

 drivers/ptp/ptp_ocp.c | 566 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 519 insertions(+), 47 deletions(-)

-- 
2.27.0

