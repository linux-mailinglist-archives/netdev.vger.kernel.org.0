Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0853240B2E3
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 17:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhINPUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 11:20:23 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:39559 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbhINPTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 11:19:13 -0400
Received: from stefan-VirtualBox.in-tech.global ([37.4.249.93]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1M9nEJ-1mVuoU0Kmb-005qyf; Tue, 14 Sep 2021 17:17:43 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH RFC 0/3] add Vertexcom MSE102x support
Date:   Tue, 14 Sep 2021 17:17:14 +0200
Message-Id: <20210914151717.12232-1-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.17.1
X-Provags-ID: V03:K1:dRzwDf3j4cmeskC53//79LwiP6y4k5KUoq/lb3JfXIggv2RmtVO
 Fq5kZGc9BO7QNdmbT/yJSDbLDX4VF5YA20b+YKDTsLQotuwk0Pu0q9Bkos9a0Xn80fYNqq8
 2Q1wzb6L+gkekLCs7GlBtU9KaQnr2je4+UISYKnPj2E4rQIr+pAAVOmViy58j/PXMj+5chz
 r+wEYk2phHsfNXMs3PuEQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:lGVGEhB0dKs=:JDwuSPWB6wd/SsJG/7I6oB
 QnbNuIt4jNKHpThwgNQJrxw7y4xAC1iJ7d7tppaLc46qMkhOFV+GNzFaYXzFAIZHQbWPYCbsT
 2JxzXptR7AZ0tpUlXNzrN46p7xgWwbCBB3ZilK5v/OGO7T/RQC2dHonTFnfP+EDuzQLe1v9N8
 mb8zYa/quZQcMqcc/SdDUbq3UaArQMJut+s5I9sGS1wJv1jLo4W4tB28hw8lCgNIXCMKUZrJg
 L7MXDw8CLbF6HYaR4BzL8WMjwonVhjOJFCyPB2eDeEb3jbtF92/q5HjvFbflNt6YEzLIhPD07
 vmUMPdSzVXPHzL4YwjFvBx1GDMQ8OBzgjsdGcVJXEExjK317R1OH5dMJSKlSy5D8eue9AXl0n
 vlrH8BP8dHolIR6whkNCphVYDvKWgoYJyhKgjXWknPHHGIFxwDQh3b2wkeg67+S6SYrbIk/Pu
 WZRIyA/aDq8AxTSACh7wSO0RIxHTY5MJPJbvzpqKKj+hy7fwIrKIOrixBH1aS4cRMX3NUUrHP
 bRph5KhpzlsLsfNl0K5nN0ppIep6YEMO/UYb0azk1ZA877nQYGYWVNevNppMymSWo1EdPZ4oC
 P7PbWEegNK5LOFUCObCyuPULxbG5XSU6WTdwn+sslrEoi7Ok8pwd9+vmN0OqeEIO7oSdzItkW
 gE+Y4bMbdXBW426VaodGHD/826GlCHTwET+zqCyDK+u6OqTElEc9PiP5nLWl+sWCp1laXOgT2
 rPFQidYTYvtlVHHiwin3sP3oyDdI4um7eho1Sw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the Vertexcom MSE102x Homeplug GreenPHY
chips [1]. They can be connected either via RGMII, RMII or SPI to a host CPU.
These patches handles only the last one, with an Ethernet over SPI protocol
driver.

The code has been tested only on Raspberry Pi boards, but should work
on other platforms.

Any comments about the code are welcome.

[1] - http://www.vertexcom.com/p_homeplug_plc_en.html

Stefan Wahren (3):
  dt-bindings: add vendor Vertexcom
  dt-bindings: net: add Vertexcom MSE102x support
  net: vertexcom: Add MSE102x SPI support

 .../bindings/net/vertexcom-mse102x.yaml       |  71 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/vertexcom/Kconfig        |  25 +
 drivers/net/ethernet/vertexcom/Makefile       |   6 +
 drivers/net/ethernet/vertexcom/mse102x.c      | 803 ++++++++++++++++++
 7 files changed, 909 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
 create mode 100644 drivers/net/ethernet/vertexcom/Kconfig
 create mode 100644 drivers/net/ethernet/vertexcom/Makefile
 create mode 100644 drivers/net/ethernet/vertexcom/mse102x.c

-- 
2.17.1

