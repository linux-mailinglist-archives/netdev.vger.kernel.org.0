Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE995604FEE
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiJSSwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJSSwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:52:16 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A0E1958F1
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:52:15 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A56B8504EA1;
        Wed, 19 Oct 2022 21:48:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A56B8504EA1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666205288; bh=ezfRbTQVZu+dXQPfKtnaQTBHa+TgXfFtjLxZ4Mc5OPs=;
        h=From:To:Cc:Subject:Date:From;
        b=fnvJVEmfJBNtzfriYUX9RI5J0ycmZaGan3zP/Jaxl5tLEMSVFfFrzTApv/yl3AHEV
         F7j+psx9FfIKbz1bYxk7w1tQVcAurdeKMGS6hN9Pfrmcyc/PcJh/dm+mu0caxhcrcI
         zDLfA3AY+IeZsNg02cvnCAHTb69M0CI1AnqnL374=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net-next v4 0/5] ptp: ocp: add support for Orolia ART-CARD
Date:   Wed, 19 Oct 2022 21:51:07 +0300
Message-Id: <20221019185112.28294-1-vfedorenko@novek.ru>
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

