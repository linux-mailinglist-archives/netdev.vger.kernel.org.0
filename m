Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481FD2665F7
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgIKRTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgIKO6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 10:58:23 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2559222BB;
        Fri, 11 Sep 2020 14:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599834846;
        bh=ouSe3E1BUgGedI46aMfPRrEMheKNTw50AdAlm0Y74ac=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TSlmQcxVEbkc4r6vpe2ZTb1CsL7jXAQaU0zDUG/YmAg4hIgTGUmXfaM/KLAl/v5ft
         syogXF7HnkJbXpg/TB/oTq7Qf1X+dERYaDNVzKzWZD8ZntQgiIya5i53/y+Og4YBzJ
         ovzPawY47ZwZtbiAAKXiB4jI/3D+kj8MG4RaInHg=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/3] ARM: s3c: Bring back notes from removed debug-macro.S
Date:   Fri, 11 Sep 2020 16:33:43 +0200
Message-Id: <20200911143343.498-3-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200911143343.498-1-krzk@kernel.org>
References: <20200911143343.498-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation references notes from a removed debug-macro.S file so
bring the contents here.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 arch/arm/mach-s3c/s3c64xx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c/s3c64xx.c b/arch/arm/mach-s3c/s3c64xx.c
index b5fc615a482f..4dfb648142f2 100644
--- a/arch/arm/mach-s3c/s3c64xx.c
+++ b/arch/arm/mach-s3c/s3c64xx.c
@@ -95,7 +95,12 @@ static struct cpu_table cpu_ids[] __initdata = {
 
 /* minimal IO mapping */
 
-/* see notes on uart map in arch/arm/mach-s3c64xx/include/mach/debug-macro.S */
+/*
+ * note, for the boot process to work we have to keep the UART
+ * virtual address aligned to an 1MiB boundary for the L1
+ * mapping the head code makes. We keep the UART virtual address
+ * aligned and add in the offset when we load the value here.
+ */
 #define UART_OFFS (S3C_PA_UART & 0xfffff)
 
 static struct map_desc s3c_iodesc[] __initdata = {
-- 
2.17.1

