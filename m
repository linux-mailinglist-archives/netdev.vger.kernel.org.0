Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DB4539C41
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 06:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344376AbiFAEWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 00:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239067AbiFAEWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 00:22:12 -0400
X-Greylist: delayed 916 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 21:22:10 PDT
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84CB556C3D;
        Tue, 31 May 2022 21:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=NQtIH
        J06HoYqg4AlgS70TpzgL+X5qu9PjqBNRbTGWww=; b=MXWCIKMhGzqfZQ8Su4hJu
        rEnVWc6Z+bVxH/fjXKNl84AEUstOc5En4zjaVjXSucmncX9vIg4y3Dmb5nAO7O50
        qmlehQrC/ArMFL3M3T+SgHzR7plgMV2YEjQf1hsGeSDQMWCPlBfCr8+NvcOU1Iz6
        B4Y3MxdgfJMk8txOmQLucg=
Received: from localhost.localdomain (unknown [112.97.51.18])
        by smtp2 (Coremail) with SMTP id GtxpCgCn4d6P5ZZipNqMFw--.1225S2;
        Wed, 01 Jun 2022 12:05:37 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     bjorn@mork.no, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV31 with new baseline
Date:   Wed,  1 Jun 2022 12:05:31 +0800
Message-Id: <20220601040531.6016-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgCn4d6P5ZZipNqMFw--.1225S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww15CrWDKF1rCr4xKFyDJrb_yoW8Cr1rp3
        yqkryayF1UX3Wjva4DAF1S9rZYv3ZxW3sF9a47Aws7WFW0yrn2grW8tFyxZ3Z29r4fKa1j
        vF4qg34xJ3s5GrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0z_g4hxUUUUU=
X-Originating-IP: [112.97.51.18]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBAxkTZGB0KyYyIgAAsk
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for Cinterion device MV31 with Qualcomm
new baseline. Use different PIDs to separate it from
previous base line products.
All interfaces settings keep same as previous.

T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  7 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1e2d ProdID=00b9 Rev=04.14
S:  Manufacturer=Cinterion
S:  Product=Cinterion PID 0x00B9 USB Mobile Broadband
S:  SerialNumber=90418e79
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index a659d6fb0b12..571a399c195d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1389,6 +1389,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1e2d, 0x0083, 4)},	/* Cinterion PHxx,PXxx (1 RmNet + USB Audio)*/
 	{QMI_QUIRK_SET_DTR(0x1e2d, 0x00b0, 4)},	/* Cinterion CLS8 */
 	{QMI_FIXED_INTF(0x1e2d, 0x00b7, 0)},	/* Cinterion MV31 RmNet */
+	{QMI_FIXED_INTF(0x1e2d, 0x00b9, 0)},	/* Cinterion MV31 RmNet based on new baseline */
 	{QMI_FIXED_INTF(0x413c, 0x81a2, 8)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a3, 8)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
-- 
2.25.1

