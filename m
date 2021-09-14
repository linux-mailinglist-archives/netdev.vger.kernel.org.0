Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF5140AC68
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhINL3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:29:22 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:53755 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231941AbhINL3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:29:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1EFFA5803C4;
        Tue, 14 Sep 2021 07:28:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 14 Sep 2021 07:28:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=vEsWbawVnkKHw0d5bXpvFppO8VlHVFR1DKiNAUmcmlE=; b=RgZOiXWy
        0EcH4r/7wZ667U7vGi4g6j7MjUtlOLlEnb9Rseh3OgblFjPGVuf7SvQNw9KGUpLY
        fYToiGLiYlUV5F/o9/a8a5kerkw0NPRM7/mQneNoUqn2KBCw7+lZtMcvQlqyrcqs
        1KQLBiIjOFIwsXfDUi7A9ZWWVyy6UykvgjvxD+KpKdQ6C1a2ToAUFsewDPcQiVs/
        iXYGaQm23HtcIDPJogv0cUswDUHwHoElspZ3GN6S0CYGUcg2KSxq5mzn0Vmu0Uez
        +09vH4GCOD20/aAZZGz94LKBJruroIVchWfw19acFPnDxzltzsr3vAQOwKlfTvB1
        PFNTqgkGqxCFSQ==
X-ME-Sender: <xms:QodAYTIlOo6x2Rpx80MqldOlsAMmS4_Xg-kb7rCUsz_49JzLJSCriQ>
    <xme:QodAYXLeOrrIMKSDWZqagN238JYKaq0AnzAfemovpcOrJC2ZOIDDkEkNRJTcoYqjA
    VBCIXs0w_Ca8wU>
X-ME-Received: <xmr:QodAYbt6YxMq8ttXyOFzxiLiLThxy2S-K8DRzS4ExQLfYM7iUikzyUw3P0GAZ-MUj8unXY3a4WYvwv1noplgwbZpS7MJmqNHQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:QodAYcav5jTxVTmeJw1qKh0ekjV_94I7qxl2ytzg6_SmLpzUE3Hmmg>
    <xmx:QodAYaZ_8ML9wb1vUQ8XBpQnhq4KywSmY0klLhTrclVnjxmkmDIeBg>
    <xmx:QodAYQAaBDU4Rg1ybrIjsQJwAjS8W18604PGbaYz7G-O4IsSdyvJMQ>
    <xmx:QodAYQOIoqdoXXsfFVHC7BHseTrkupa-vVVi9g2IpWdhJve4e00VYw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 07:27:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        vladyslavt@nvidia.com, moshe@nvidia.com, popadrian1996@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool 1/5] sff-8636: Fix parsing of Page 03h in IOCTL path
Date:   Tue, 14 Sep 2021 14:27:34 +0300
Message-Id: <20210914112738.358627-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914112738.358627-1-idosch@idosch.org>
References: <20210914112738.358627-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The offset of Page 03h compared to the base address of the Lower Memory
is 512 bytes. However, all the offsets to the page start at address 128,
which is the address that separates Lower and Upper memory (see Figure
6-1 in SFF-8636). Therefore, reading these offsets compared to the start
of Page 03h results in incorrect memory accesses as can be seen in the
output below.

Instead, pass Page 03h with the correct offset.

This is a temporary solution until SFF-8636 is refactored to use a
memory map for parsing.

Before patch:

 # ethtool -m swp13
 ...
 Laser bias current high alarm threshold   : 16.448 mA
 Laser bias current low alarm threshold    : 16.500 mA
 Laser bias current high warning threshold : 16.480 mA
 Laser bias current low warning threshold  : 61.538 mA
 Laser output power high alarm threshold   : 1.2576 mW / 1.00 dBm
 Laser output power low alarm threshold    : 1.0321 mW / 0.14 dBm
 Laser output power high warning threshold : 2.1318 mW / 3.29 dBm
 Laser output power low warning threshold  : 2.0530 mW / 3.12 dBm
 Module temperature high alarm threshold   : 0.00 degrees C / 32.00 degrees F
 Module temperature low alarm threshold    : 0.00 degrees C / 32.00 degrees F
 Module temperature high warning threshold : 0.00 degrees C / 32.00 degrees F
 Module temperature low warning threshold  : 0.00 degrees C / 32.00 degrees F
 Module voltage high alarm threshold       : 0.2377 V
 Module voltage low alarm threshold        : 2.5701 V
 Module voltage high warning threshold     : 2.8276 V
 Module voltage low warning threshold      : 2.6982 V
 Laser rx power high alarm threshold       : 0.8224 mW / -0.85 dBm
 Laser rx power low alarm threshold        : 0.8224 mW / -0.85 dBm
 Laser rx power high warning threshold     : 0.8224 mW / -0.85 dBm
 Laser rx power low warning threshold      : 0.8224 mW / -0.85 dBm

After patch:

 # ethtool -m swp13
 ...
 Laser bias current high alarm threshold   : 8.500 mA
 Laser bias current low alarm threshold    : 5.492 mA
 Laser bias current high warning threshold : 8.000 mA
 Laser bias current low warning threshold  : 6.000 mA
 Laser output power high alarm threshold   : 3.4673 mW / 5.40 dBm
 Laser output power low alarm threshold    : 0.0724 mW / -11.40 dBm
 Laser output power high warning threshold : 1.7378 mW / 2.40 dBm
 Laser output power low warning threshold  : 0.1445 mW / -8.40 dBm
 Module temperature high alarm threshold   : 80.00 degrees C / 176.00 degrees F
 Module temperature low alarm threshold    : -10.00 degrees C / 14.00 degrees F
 Module temperature high warning threshold : 70.00 degrees C / 158.00 degrees F
 Module temperature low warning threshold  : 0.00 degrees C / 32.00 degrees F
 Module voltage high alarm threshold       : 3.5000 V
 Module voltage low alarm threshold        : 3.1000 V
 Module voltage high warning threshold     : 3.4650 V
 Module voltage low warning threshold      : 3.1350 V
 Laser rx power high alarm threshold       : 3.4673 mW / 5.40 dBm
 Laser rx power low alarm threshold        : 0.0467 mW / -13.31 dBm
 Laser rx power high warning threshold     : 1.7378 mW / 2.40 dBm
 Laser rx power low warning threshold      : 0.0933 mW / -10.30 dBm

The following AddressSanitizer report is fixed:

==44670==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x617000000320 at pc 0x00000047ad93 bp 0x7ffcb4dc0070 sp 0x7ffcb4dc0068
READ of size 1 at 0x617000000320 thread T0
    #0 0x47ad92 in sff8636_dom_parse qsfp.c:683
    #1 0x47c5d6 in sff8636_show_dom qsfp.c:771
    #2 0x47d21f in sff8636_show_all qsfp.c:870
    #3 0x42130b in do_getmodule ethtool.c:4908
    #4 0x42a38a in main ethtool.c:6383
    #5 0x7f500bf421e1 in __libc_start_main (/lib64/libc.so.6+0x281e1)
    #6 0x40258d in _start (ethtool+0x40258d)

0x617000000320 is located 16 bytes to the right of 656-byte region [0x617000000080,0x617000000310)
allocated by thread T0 here:
    #0 0x7f500c2d6527 in __interceptor_calloc (/lib64/libasan.so.6+0xab527)
    #1 0x420d8c in do_getmodule ethtool.c:4859
    #2 0x42a38a in main ethtool.c:6383
    #3 0x7f500bf421e1 in __libc_start_main (/lib64/libc.so.6+0x281e1)

SUMMARY: AddressSanitizer: heap-buffer-overflow qsfp.c:683 in sff8636_dom_parse

Fixes: fc47fdb7c364 ("ethtool: Refactor human-readable module EEPROM output for new API")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/qsfp.c b/qsfp.c
index 644fe148a5aa..e84226bc1554 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -867,7 +867,7 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_PLUS) ||
 		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP28)) {
 		sff6836_show_page_zero(id);
-		sff8636_show_dom(id, id + SFF8636_PAGE03H_OFFSET, eeprom_len);
+		sff8636_show_dom(id, id + 3 * 0x80, eeprom_len);
 	}
 }
 
-- 
2.31.1

