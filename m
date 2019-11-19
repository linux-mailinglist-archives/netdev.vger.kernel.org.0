Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290B41021FE
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfKSKV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:21:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32915 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfKSKV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 05:21:59 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20191119102157epoutp0448f72e47a62cc37f31d6941a209740a5~YiTHhmbMF0795607956epoutp04d
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 10:21:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20191119102157epoutp0448f72e47a62cc37f31d6941a209740a5~YiTHhmbMF0795607956epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574158917;
        bh=T6O+E13fVaWu75RPABvYGvtZVGkZnllG5PcDKyrpcfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uX4RUGY67yS23HBNvqkxsmrFsZcr3kJB3p33km1EvcwOEVkRaqZxjeJaOKtzUFBkA
         7diyuulJ7waYi4Zy3KWJE1IgXHJ4XW6oRiUDhd80z7Ykt82g+lILPQS/hlh21IdZ8t
         GFpSDXJXgvsJIFvsBd9khGbTlmx+iXop+5qMVOlk=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20191119102156epcas5p2dec926c5447366d0a63c16554307882a~YiTGuxBrX2839028390epcas5p2J;
        Tue, 19 Nov 2019 10:21:56 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.00.04403.442C3DD5; Tue, 19 Nov 2019 19:21:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20191119102155epcas5p34ca3dfaba9eef8de24d1bc9d64ef5335~YiTF4oN5R2344423444epcas5p3m;
        Tue, 19 Nov 2019 10:21:55 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191119102155epsmtrp1df3f68d94e432d94e8b0ffc2aa727732~YiTF348V_1898818988epsmtrp16;
        Tue, 19 Nov 2019 10:21:55 +0000 (GMT)
X-AuditID: b6c32a4a-3b3ff70000001133-fa-5dd3c2449ee7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.55.03814.342C3DD5; Tue, 19 Nov 2019 19:21:55 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191119102153epsmtip128e6261608a3a5f01fedab4a085b9c73~YiTELmfGs0068200682epsmtip1K;
        Tue, 19 Nov 2019 10:21:53 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        dmurphy@ti.com, rcsekar@samsung.com, pankaj.dubey@samsung.com,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: [PATCH 1/2] can: m_can_platform: set net_device structure as driver
 data
Date:   Tue, 19 Nov 2019 15:50:37 +0530
Message-Id: <1574158838-4616-2-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574158838-4616-1-git-send-email-pankj.sharma@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsWy7bCmlq7LocuxButWcVnMOd/CYtF9egur
        xarvU5ktLu+aw2axftEUFotjC8QsFm39wm6xvOs+s8WsCztYLW6sZ7dYem8nqwO3x5aVN5k8
        Pl66zejR/9fAo2/LKkaP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAlXH71Ubmgn3sFa/3XmZv
        YNzC1sXIySEhYCKxZd179i5GLg4hgd2MEvM2zmCFcD4xSvT1rIDKfGOU6Ho7g6WLkQOsZefl
        QIj4XkaJpRc2QnW0MEms23eBCWQum4CexKX3k8F2iAiESizrnQBWxCxwiVFizvkVrCAJYYFg
        ibsP/4M1sAioSvy9fpEZZAOvgLvEnb+lEPfJSdw818kMYnMKeEg8mDGTCWSOhMARNomvSx6x
        QhS5SPz+OJMZwhaWeHV8CzuELSXxsr8Nys6WWLi7H+qDCom2GcIQYXuJA1fmgIWZBTQl1u/S
        BwkzC/BJ9P5+wgRRzSvR0SYEUa0mMfXpO0YIW0bizqPN0FD0kHi59jwLJBhmM0r0bvjDOoFR
        dhbC1AWMjKsYJVMLinPTU4tNC4zyUsv1ihNzi0vz0vWS83M3MYJThJbXDsZl53wOMQpwMCrx
        8J5QuRwrxJpYVlyZe4hRgoNZSYTX79GFWCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8k1ivxggJ
        pCeWpGanphakFsFkmTg4pRoYL7z7/8Bh9o3DT5o3bA77vEz7lIpisLgvu+7XDRmXQ7/f0tMs
        fRQUmdTzLnWu/BWFhZYzP396//F6e8MT0daV784fWeF57IfUbLeqV2xHojVWWM1k9gp+rFjO
        +u/SMoa7ty/dDl2z6UDF8YNzT+ppHOY7zHJwSUh73DmBXD6Dib/CbhVM3210/ZgSS3FGoqEW
        c1FxIgAQ6dQSDQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWy7bCSnK7zocuxBldO8VvMOd/CYtF9egur
        xarvU5ktLu+aw2axftEUFotjC8QsFm39wm6xvOs+s8WsCztYLW6sZ7dYem8nqwO3x5aVN5k8
        Pl66zejR/9fAo2/LKkaP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAlXH71Ubmgn3sFa/3XmZv
        YNzC1sXIwSEhYCKx83JgFyMXh5DAbkaJnz9bmSDiMhKLP1d3MXICmcISK/89Z4eoaWKSWH91
        CitIgk1AT+LS+8lsILaIQLjEzgldTCBFzAJ3GCV+/J/HCjJIWCBQ4s8sfZAaFgFVib/XLzKD
        hHkF3CXu/C2FmC8ncfNcJzOIzSngIfFgxkwmEFsIqOTP5mcsExj5FjAyrGKUTC0ozk3PLTYs
        MMpLLdcrTswtLs1L10vOz93ECA5OLa0djCdOxB9iFOBgVOLhPaFyOVaINbGsuDL3EKMEB7OS
        CK/fowuxQrwpiZVVqUX58UWlOanFhxilOViUxHnl849FCgmkJ5akZqemFqQWwWSZODilGhg5
        n00vCWZ7M51VJCbH2HjXuisXtV0SKo4ccLtan9i8oPtVhHSvk1VHSJ2+24fJTuosx9k66/oZ
        7G3nvHzQrjdpz61866MGtS4Ja3g1Di5s9Uo9eMEq/KPX2jWGy3/W3WCeXjf7cDvTxUO3jW4v
        mdTnHuSRU1Pa1OC64gx/++FDe5b/kOh+U6HEUpyRaKjFXFScCACoME4cSgIAAA==
X-CMS-MailID: 20191119102155epcas5p34ca3dfaba9eef8de24d1bc9d64ef5335
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191119102155epcas5p34ca3dfaba9eef8de24d1bc9d64ef5335
References: <1574158838-4616-1-git-send-email-pankj.sharma@samsung.com>
        <CGME20191119102155epcas5p34ca3dfaba9eef8de24d1bc9d64ef5335@epcas5p3.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A device driver for CAN controller hardware registers itself with the
Linux network layer as a network device. So, the driver data for m_can
should ideally be of type net_device.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")

Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
---
 drivers/net/can/m_can/m_can_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 6ac4c35..2eaa354 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -107,7 +107,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	mcan_class->is_peripheral = false;
 
-	platform_set_drvdata(pdev, mcan_class->dev);
+	platform_set_drvdata(pdev, mcan_class->net);
 
 	m_can_init_ram(mcan_class);
 
-- 
2.7.4

