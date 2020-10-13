Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2548628CDFD
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 14:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgJMMPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 08:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgJMMO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 08:14:57 -0400
Received: from mail.kernel.org (ip5f5ad5b2.dynamic.kabel-deutschland.de [95.90.213.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D3522226B;
        Tue, 13 Oct 2020 12:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602591295;
        bh=zhqkufZ7f7yOmStqpe6IwS4Q7Pbm2bPb4tI8f5PD8is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJ/exGaa9jn8vqZuR4s0V/ooPf7voEJXvKUd4nPr4e6UnPijxWCTPtuvnhciLjKmI
         U/Tg3oMZEd1+NZEMIqMDM1/0S8PLMsqvmw8gBc7vNOapU6d/ZTWG6H1kYTFI5alJfJ
         WdJQCg0+vvPyTO4wrXmJJQsLJa5N1P6R7MbrU5dw=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kSJCf-006CoY-6m; Tue, 13 Oct 2020 14:14:53 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 19/24] net: phy: remove kernel-doc duplication
Date:   Tue, 13 Oct 2020 14:14:46 +0200
Message-Id: <89c130eab83089f7976ed8876e9bd1ba62d800c3.1602590106.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1602590106.git.mchehab+huawei@kernel.org>
References: <cover.1602590106.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sphinx 3 now checks for duplicated function declarations:

	.../Documentation/networking/kapi:143: ../include/linux/phy.h:163: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'unsigned int phy_supported_speeds (struct phy_device *phy, unsigned int *speeds, unsigned int size)'.
	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1034: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'int phy_read_mmd (struct phy_device *phydev, int devad, u32 regnum)'.
	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1076: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'int __phy_read_mmd (struct phy_device *phydev, int devad, u32 regnum)'.
	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1088: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'int phy_write_mmd (struct phy_device *phydev, int devad, u32 regnum, u16 val)'.
	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1100: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'int __phy_write_mmd (struct phy_device *phydev, int devad, u32 regnum, u16 val)'.

It turns that both the C and the H files have the same
kernel-doc markup for the same functions. Let's drop the
at the header file, keeping the one closer to the code.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/linux/phy.h | 40 +++++-----------------------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..56563e5e0dc7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -147,16 +147,8 @@ typedef enum {
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
-/**
+/*
  * phy_supported_speeds - return all speeds currently supported by a PHY device
- * @phy: The PHY device to return supported speeds of.
- * @speeds: buffer to store supported speeds in.
- * @size: size of speeds buffer.
- *
- * Description: Returns the number of supported speeds, and fills
- * the speeds buffer with the supported speeds. If speeds buffer is
- * too small to contain all currently supported speeds, will return as
- * many speeds as can fit.
  */
 unsigned int phy_supported_speeds(struct phy_device *phy,
 				      unsigned int *speeds,
@@ -1022,14 +1014,9 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
 					regnum, mask, set);
 }
 
-/**
+/*
  * phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
- * @phydev: The phy_device struct
- * @devad: The MMD to read from
- * @regnum: The register on the MMD to read
- *
- * Same rules as for phy_read();
  */
 int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 
@@ -1064,38 +1051,21 @@ int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 	__ret; \
 })
 
-/**
+/*
  * __phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
- * @phydev: The phy_device struct
- * @devad: The MMD to read from
- * @regnum: The register on the MMD to read
- *
- * Same rules as for __phy_read();
  */
 int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 
-/**
+/*
  * phy_write_mmd - Convenience function for writing a register
  * on an MMD on a given PHY.
- * @phydev: The phy_device struct
- * @devad: The MMD to write to
- * @regnum: The register on the MMD to read
- * @val: value to write to @regnum
- *
- * Same rules as for phy_write();
  */
 int phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val);
 
-/**
+/*
  * __phy_write_mmd - Convenience function for writing a register
  * on an MMD on a given PHY.
- * @phydev: The phy_device struct
- * @devad: The MMD to write to
- * @regnum: The register on the MMD to read
- * @val: value to write to @regnum
- *
- * Same rules as for __phy_write();
  */
 int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val);
 
-- 
2.26.2

