Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95ABB67C505
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjAZHok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjAZHoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:44:39 -0500
Received: from smtp-out-06.comm2000.it (smtp-out-06.comm2000.it [212.97.32.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C1F1BAF6;
        Wed, 25 Jan 2023 23:44:36 -0800 (PST)
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-06.comm2000.it (Postfix) with ESMTPSA id 0B1D85611D4;
        Thu, 26 Jan 2023 08:44:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1674719072;
        bh=3G/SbvmzPiZfuAmwVmCOJNiD9b1gSTVCAfILv/DUq/Y=;
        h=From:To:Cc:Subject:Date;
        b=bJrxRTYwMAnf3nRk/ayrKGhxD4Hi4mfUPVGG6LkhC43P7HzfszYSEqNX+/OlyPGAM
         5uQtQsqiauEmeOoXyg3/fwtMuG/G6HsKZ5HXVkHY/4FionmiTJVjgCtZ9fJB0+RcRX
         WeTu48ANFMU6y/MAtAMUFx4Wuek8MTmWl3D7D744yHMqcxJIn6SyTwzDk+kMTYJHX9
         rriQfFH+uXAt9GDCv/gRIYxNwVh88d7CUL7tESPqUuF2ptc8H/q053DnlqeXvQqAic
         YhI7JBUcytJclhzXksDv1NO7AOuS7hQibAxrPyHtDkvZOZFntQe44KPTNWBaEat7/3
         x7IVRz8jrQq0w==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 0/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
Date:   Thu, 26 Jan 2023 08:43:51 +0100
Message-Id: <20230126074356.431306-1-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Francesco Dolcini <francesco.dolcini@toradex.com>

Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
support for changing the baud rate. The command to change the baud rate is
taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
interfaces) from NXP.

v2:
 - Fix the subject as pointed out by Krzysztof. Thanks!
 - Fix indentation in marvell-bluetooth.yaml
 - Fix compiler warning for kernel builds without CONFIG_OF enabled

Stefan Eichenberger (5):
  dt-bindings: bluetooth: marvell: add 88W8997
  dt-bindings: bluetooth: marvell: add max-speed property
  Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
  Bluetooth: hci_mrvl: Add serdev support for 88W8997
  arm64: dts: imx8mp-verdin: add 88W8997 serdev to uart4

 .../bindings/net/marvell-bluetooth.yaml       | 20 +++-
 .../dts/freescale/imx8mp-verdin-wifi.dtsi     |  5 +
 drivers/bluetooth/hci_mrvl.c                  | 92 +++++++++++++++++--
 3 files changed, 106 insertions(+), 11 deletions(-)

-- 
2.25.1

