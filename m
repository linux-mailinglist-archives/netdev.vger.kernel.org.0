Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEF14E82D6
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiCZRKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiCZRKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:10:39 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D42D35864;
        Sat, 26 Mar 2022 10:08:58 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 13C5EFB7F7; Sat, 26 Mar 2022 16:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313997; bh=ORSaJ6zLK3T5QJ6ekZf62I3PpS/KQZ/OU2UVDjr9uRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMXOPB+IPlepS4sIrI8Po1BHRQdegUsgoGM6VYJuSgrZ0P/EUXInfdO79xyiuFmka
         qpcacAlDe+T79tUd2kTzfx6MSShZcWzMY4hW+ebrJxX6dwD/n5xIYAZaNqciP1Smsm
         kkEzlCIiHQuZFGK50AzFarp40Fda/RsvFX1FRDJQy5vTyzQxFZIVp/7XC8kCB+ybfo
         Rg7PM5XMo7J/5+M78HnT+TaHsDF3l09f1EChq4wH/dCYBFtZMsrft3U0J2Wm8MJA1h
         zHwLU6V3+Z2AKs9Tfy1s5k4ai7yC9mNT1lhEbNCFXgg9Tv8YuL/UHklzzncXYhOgeC
         Jnb3wNMN6Xo/w==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 41A1DFB7DE;
        Sat, 26 Mar 2022 16:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648313993; bh=ORSaJ6zLK3T5QJ6ekZf62I3PpS/KQZ/OU2UVDjr9uRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wq21HltneWdL6v4ZLSJXC/plweTDbrb3ui94N5yiQei93RLb63mS41Cg7dVqI4fte
         9BqCFfq9VrIThMsyqq0VB1mZUqCXu0nH3/0YtYuj3fDiM2ZTv6HqDxtkQWuuGPZGDl
         N87b29RPMjyQMTbtoN714T9xt2bJioTmNWsoDEcxyjF6T5Adg+8hZX7ykzJJVzq4mv
         QyjX/stjxxs0Aq6YgOFQRPY3aB5QHr8caGS+ENicUHCHYZDLLKeArivV7C+1sgEsA6
         0Tgoe831JrmoLDcuBMxeugIow66ZHsyeskR0RGhE8X3sTVac/00kVNKHIBShyMJiDp
         xaU9YW7xKRuYA==
From:   =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
To:     andrew@lunn.ch
Cc:     sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux@simtec.co.uk, krzk@kernel.org,
        alim.akhtar@samsung.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        robert.moore@intel.com, rafael.j.wysocki@intel.com,
        lenb@kernel.org, 3chas3@gmail.com, laforge@gnumonks.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, mchehab@kernel.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org,
        =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
Subject: [PATCH 05/22] acpica: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:52 +0100
Message-Id: <20220326165909.506926-5-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RDNS_DYNAMIC,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces comments with C99's designated
initializers because the kernel supports them now.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/acpi/acpica/utdecode.c | 183 ++++++++++++++++-----------------
 1 file changed, 90 insertions(+), 93 deletions(-)

diff --git a/drivers/acpi/acpica/utdecode.c b/drivers/acpi/acpica/utdecode.c
index bcd3871079d7..d19868d2ea46 100644
--- a/drivers/acpi/acpica/utdecode.c
+++ b/drivers/acpi/acpica/utdecode.c
@@ -156,37 +156,37 @@ static const char acpi_gbl_bad_type[] = "UNDEFINED";
 /* Printable names of the ACPI object types */
 
 static const char *acpi_gbl_ns_type_names[] = {
-	/* 00 */ "Untyped",
-	/* 01 */ "Integer",
-	/* 02 */ "String",
-	/* 03 */ "Buffer",
-	/* 04 */ "Package",
-	/* 05 */ "FieldUnit",
-	/* 06 */ "Device",
-	/* 07 */ "Event",
-	/* 08 */ "Method",
-	/* 09 */ "Mutex",
-	/* 10 */ "Region",
-	/* 11 */ "Power",
-	/* 12 */ "Processor",
-	/* 13 */ "Thermal",
-	/* 14 */ "BufferField",
-	/* 15 */ "DdbHandle",
-	/* 16 */ "DebugObject",
-	/* 17 */ "RegionField",
-	/* 18 */ "BankField",
-	/* 19 */ "IndexField",
-	/* 20 */ "Reference",
-	/* 21 */ "Alias",
-	/* 22 */ "MethodAlias",
-	/* 23 */ "Notify",
-	/* 24 */ "AddrHandler",
-	/* 25 */ "ResourceDesc",
-	/* 26 */ "ResourceFld",
-	/* 27 */ "Scope",
-	/* 28 */ "Extra",
-	/* 29 */ "Data",
-	/* 30 */ "Invalid"
+	[0]  = "Untyped",
+	[1]  = "Integer",
+	[2]  = "String",
+	[3]  = "Buffer",
+	[4]  = "Package",
+	[5]  = "FieldUnit",
+	[6]  = "Device",
+	[7]  = "Event",
+	[8]  = "Method",
+	[9]  = "Mutex",
+	[10] = "Region",
+	[11] = "Power",
+	[12] = "Processor",
+	[13] = "Thermal",
+	[14] = "BufferField",
+	[15] = "DdbHandle",
+	[16] = "DebugObject",
+	[17] = "RegionField",
+	[18] = "BankField",
+	[19] = "IndexField",
+	[20] = "Reference",
+	[21] = "Alias",
+	[22] = "MethodAlias",
+	[23] = "Notify",
+	[24] = "AddrHandler",
+	[25] = "ResourceDesc",
+	[26] = "ResourceFld",
+	[27] = "Scope",
+	[28] = "Extra",
+	[29] = "Data",
+	[30] = "Invalid"
 };
 
 const char *acpi_ut_get_type_name(acpi_object_type type)
@@ -284,22 +284,22 @@ const char *acpi_ut_get_node_name(void *object)
 /* Printable names of object descriptor types */
 
 static const char *acpi_gbl_desc_type_names[] = {
-	/* 00 */ "Not a Descriptor",
-	/* 01 */ "Cached Object",
-	/* 02 */ "State-Generic",
-	/* 03 */ "State-Update",
-	/* 04 */ "State-Package",
-	/* 05 */ "State-Control",
-	/* 06 */ "State-RootParseScope",
-	/* 07 */ "State-ParseScope",
-	/* 08 */ "State-WalkScope",
-	/* 09 */ "State-Result",
-	/* 10 */ "State-Notify",
-	/* 11 */ "State-Thread",
-	/* 12 */ "Tree Walk State",
-	/* 13 */ "Parse Tree Op",
-	/* 14 */ "Operand Object",
-	/* 15 */ "Namespace Node"
+	[0]  = "Not a Descriptor",
+	[1]  = "Cached Object",
+	[2]  = "State-Generic",
+	[3]  = "State-Update",
+	[4]  = "State-Package",
+	[5]  = "State-Control",
+	[6]  = "State-RootParseScope",
+	[7]  = "State-ParseScope",
+	[8]  = "State-WalkScope",
+	[9]  = "State-Result",
+	[10] = "State-Notify",
+	[11] = "State-Thread",
+	[12] = "Tree Walk State",
+	[13] = "Parse Tree Op",
+	[14] = "Operand Object",
+	[15] = "Namespace Node"
 };
 
 const char *acpi_ut_get_descriptor_name(void *object)
@@ -331,13 +331,13 @@ const char *acpi_ut_get_descriptor_name(void *object)
 /* Printable names of reference object sub-types */
 
 static const char *acpi_gbl_ref_class_names[] = {
-	/* 00 */ "Local",
-	/* 01 */ "Argument",
-	/* 02 */ "RefOf",
-	/* 03 */ "Index",
-	/* 04 */ "DdbHandle",
-	/* 05 */ "Named Object",
-	/* 06 */ "Debug"
+	[0] = "Local",
+	[1] = "Argument",
+	[2] = "RefOf",
+	[3] = "Index",
+	[4] = "DdbHandle",
+	[5] = "Named Object",
+	[6] = "Debug"
 };
 
 const char *acpi_ut_get_reference_name(union acpi_operand_object *object)
@@ -416,25 +416,22 @@ const char *acpi_ut_get_mutex_name(u32 mutex_id)
 /* Names for Notify() values, used for debug output */
 
 static const char *acpi_gbl_generic_notify[ACPI_GENERIC_NOTIFY_MAX + 1] = {
-	/* 00 */ "Bus Check",
-	/* 01 */ "Device Check",
-	/* 02 */ "Device Wake",
-	/* 03 */ "Eject Request",
-	/* 04 */ "Device Check Light",
-	/* 05 */ "Frequency Mismatch",
-	/* 06 */ "Bus Mode Mismatch",
-	/* 07 */ "Power Fault",
-	/* 08 */ "Capabilities Check",
-	/* 09 */ "Device PLD Check",
-	/* 0A */ "Reserved",
-	/* 0B */ "System Locality Update",
-								/* 0C */ "Reserved (was previously Shutdown Request)",
-								/* Reserved in ACPI 6.0 */
-	/* 0D */ "System Resource Affinity Update",
-								/* 0E */ "Heterogeneous Memory Attributes Update",
-								/* ACPI 6.2 */
-						/* 0F */ "Error Disconnect Recover"
-						/* ACPI 6.3 */
+	[0]  = "Bus Check",
+	[1]  = "Device Check",
+	[2]  = "Device Wake",
+	[3]  = "Eject Request",
+	[4]  = "Device Check Light",
+	[5]  = "Frequency Mismatch",
+	[6]  = "Bus Mode Mismatch",
+	[7]  = "Power Fault",
+	[8]  = "Capabilities Check",
+	[9]  = "Device PLD Check",
+	[10] = "Reserved",
+	[11] = "System Locality Update",
+	[12] = "Reserved (was previously Shutdown Request)",  /* Reserved in ACPI 6.0 */
+	[13] = "System Resource Affinity Update",
+	[14] = "Heterogeneous Memory Attributes Update",      /* ACPI 6.2 */
+	[15] = "Error Disconnect Recover"                     /* ACPI 6.3 */
 };
 
 static const char *acpi_gbl_device_notify[5] = {
@@ -521,26 +518,26 @@ const char *acpi_ut_get_notify_name(u32 notify_value, acpi_object_type type)
  ******************************************************************************/
 
 static const char *acpi_gbl_argument_type[20] = {
-	/* 00 */ "Unknown ARGP",
-	/* 01 */ "ByteData",
-	/* 02 */ "ByteList",
-	/* 03 */ "CharList",
-	/* 04 */ "DataObject",
-	/* 05 */ "DataObjectList",
-	/* 06 */ "DWordData",
-	/* 07 */ "FieldList",
-	/* 08 */ "Name",
-	/* 09 */ "NameString",
-	/* 0A */ "ObjectList",
-	/* 0B */ "PackageLength",
-	/* 0C */ "SuperName",
-	/* 0D */ "Target",
-	/* 0E */ "TermArg",
-	/* 0F */ "TermList",
-	/* 10 */ "WordData",
-	/* 11 */ "QWordData",
-	/* 12 */ "SimpleName",
-	/* 13 */ "NameOrRef"
+	[0x00] = "Unknown ARGP",
+	[0x01] = "ByteData",
+	[0x02] = "ByteList",
+	[0x03] = "CharList",
+	[0x04] = "DataObject",
+	[0x05] = "DataObjectList",
+	[0x06] = "DWordData",
+	[0x07] = "FieldList",
+	[0x08] = "Name",
+	[0x09] = "NameString",
+	[0x0A] = "ObjectList",
+	[0x0B] = "PackageLength",
+	[0x0C] = "SuperName",
+	[0x0D] = "Target",
+	[0x0E] = "TermArg",
+	[0x0F] = "TermList",
+	[0x10] = "WordData",
+	[0x11] = "QWordData",
+	[0x12] = "SimpleName",
+	[0x13] = "NameOrRef"
 };
 
 const char *acpi_ut_get_argument_type_name(u32 arg_type)
-- 
2.35.1

