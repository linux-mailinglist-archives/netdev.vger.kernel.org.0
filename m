Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220B2601BE5
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 00:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiJQWAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 18:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiJQWAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 18:00:33 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB216C74F
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:00:31 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A9ABF504E6B;
        Tue, 18 Oct 2022 00:56:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A9ABF504E6B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666043785; bh=uKJ6er26dPj3xHBcdGPsRAAFkqs0O9NKamIqE4QY7AY=;
        h=From:To:Cc:Subject:Date:From;
        b=xeloZnhUhuMHluQXrEwrfTG20cPQrVrYBTrzafFLRLe2lF2UFv2TtbDH94ATxfv2u
         5e2VJJ6MgdkfGeNqMAsYagEQSzJ9icxxt5vSx2q9mi+JhO4VjERqo0K01MzA8eO5KC
         M26ZhBkUZ1tSZ6ea/cqcxhIuNHvFKjM2ErJpajE0=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net-next 0/5] ptp: ocp: add support for Orolia ART-CARD
Date:   Tue, 18 Oct 2022 00:59:42 +0300
Message-Id: <20221017215947.7438-1-vfedorenko@novek.ru>
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

