Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D2860279C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiJRIzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJRIzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:55:03 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B971D0D9
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:54:57 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 08939504ECC;
        Tue, 18 Oct 2022 11:50:49 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 08939504ECC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666083050; bh=uk+AlDLxRDjQMHXSzG+kHc/EqLvBdYXkyVQ+GV/rHq0=;
        h=From:To:Cc:Subject:Date:From;
        b=Xi3oIEFtVUS6qX4ZIp0VSDnCWmGoiUtpCTupSuG1mnROcsMgP6wtBqLhORLSv394f
         rkwb+nXbuEOpUngdBTGfXtGzO9xd/5eUyMjhoM1xErCt7YACxFNs/H7aB/TDTY+xEp
         joiDCGi/yz3puVHITGAYdaHRstSQMTh00mSFZcI4=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net-next v2 0/5] ptp: ocp: add support for Orolia ART-CARD
Date:   Tue, 18 Oct 2022 11:54:13 +0300
Message-Id: <20221018085418.2163-1-vfedorenko@novek.ru>
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

