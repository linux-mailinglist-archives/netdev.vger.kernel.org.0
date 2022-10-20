Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37408606BF8
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 01:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiJTXNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 19:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiJTXNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 19:13:31 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D06622C63F
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:13:29 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 6BCC2504EE9;
        Fri, 21 Oct 2022 02:09:19 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 6BCC2504EE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666307360; bh=PWPF28jNvDKwe5/eG9ay5Tlt5niLemrEkwUDMl/7xf4=;
        h=From:To:Cc:Subject:Date:From;
        b=I41zMxo9xntx+84FPLMUcTw36GbEED9G+GqzRUTLjAVe09N3NRH03qJxRS2TPZyu+
         Yx1H2O/NXQUbJ99j0QpvMAn5LFxjbvH52sieHahkMtHl5UnjDGqp92CcnXIZACLTav
         ex8Rp+rsv4LMvRBb/Ta2xSg/+5pnyeuNENrGSCII=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net-next v5 0/5] ptp: ocp: add support for Orolia ART-CARD
Date:   Fri, 21 Oct 2022 02:12:42 +0300
Message-Id: <20221020231247.7243-1-vfedorenko@novek.ru>
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

