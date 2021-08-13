Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70DE3EBD53
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 22:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhHMUa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 16:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbhHMUaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 16:30:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F98AC061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 13:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ijsbB4h/ewSMhkWinXv5VLE3F6MWHZrea77Hcba4wkg=; b=NCbrh/ON/C3ZO16PcIkQnS/e0u
        P4d8z92gsz51/jLgTDCTGpvvtjhd33oU0FtGenllbt8GcD18zQnQSIoVmcTTTzF3Fl2JuOrjix+Dx
        4Ho1dc7Q2BQf4WX1QyQEsM8ZJmjhRpRk8pbezYTKtDDgvTLi1TwRff7KKdrnDs/qrfkzxuuZ2CTqz
        hIqLr+MbV5uf3Tim372XKHDXFH8mJ05udlCEPJ5Ly5osRiD6WyePCTF8AaEzlNnpi+BPoLvK0DXG/
        jmqTepnOTPIIFemFPSB3SpiVitBRpn2ANBeKwOjYpxjVw+n0TV3gXYZ6tBOnKlLhO9rQA2nrXysEZ
        X3VIAsDA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEdox-00DYqB-Lj; Fri, 13 Aug 2021 20:30:27 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: [PATCH] ptp: ocp: don't allow on S390
Date:   Fri, 13 Aug 2021 13:30:26 -0700
Message-Id: <20210813203026.27687-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix kconfig warning on arch/s390/:

WARNING: unmet direct dependencies detected for SERIAL_8250
  Depends on [n]: TTY [=y] && HAS_IOMEM [=y] && !S390 [=y]
  Selected by [m]:
  - PTP_1588_CLOCK_OCP [=m] && PTP_1588_CLOCK [=m] && HAS_IOMEM [=y] && PCI [=y] && SPI [=y] && I2C [=m] && MTD [=m]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
---
There is no 8250 serial on S390. See commit 1598e38c0770.
Is this driver useful even without 8250 serial?

 drivers/ptp/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20210813.orig/drivers/ptp/Kconfig
+++ linux-next-20210813/drivers/ptp/Kconfig
@@ -158,6 +158,7 @@ config PTP_1588_CLOCK_OCP
 	depends on PTP_1588_CLOCK
 	depends on HAS_IOMEM && PCI
 	depends on SPI && I2C && MTD
+	depends on !S390
 	imply SPI_MEM
 	imply SPI_XILINX
 	imply MTD_SPI_NOR
