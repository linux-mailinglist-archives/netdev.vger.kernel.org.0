Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124F64E82ED
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiCZRLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiCZRKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:10:36 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB6234BA1;
        Sat, 26 Mar 2022 10:08:33 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 2C5F2FBBA2; Sat, 26 Mar 2022 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314004; bh=vUiPq8e+9rFa79trTkL9elZTMyt0cb1zeTUJyaoj0hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDWMkGkdfVGVA0Jdx/6BCBrbcP7trFPn3XaxcmIJ2VuCBEDzKqZSzk2+2OxDdWrYE
         eq10EMy+wEqwPRkM+YBr5Ggh/6wmRje2FFSd3hiovGre+yaOpCspM8rV2ENm8MF0Cz
         BCptt39SXl/5OxaPcmzpDp05wPmyrq5GpPGBjOXjK+WfVfAFdWzeUVXecEteHaPLGf
         PDtvPHMPfxPdfa6GgiDBqF8mhghZXPVHN7Y1eSQ3HPUsJKpvPDyC2W23xh5qDzexoL
         MzIN4EQejycVGyz5EUNg1YRtFGWRukZMBudVkkrtU3hM3aAzlIf1agz/30hDoTmdC9
         KIw8gmaqd91cw==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id D1B38FB7EA;
        Sat, 26 Mar 2022 16:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314000; bh=vUiPq8e+9rFa79trTkL9elZTMyt0cb1zeTUJyaoj0hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctRk1WCrqya+ecH8mkxYq50sIQA6CjaYtCK7gZK3KwSCKoLC8aq4Ig3uwEbRI0MUa
         P0FojqWvPqZk4Fzj/TVTcGIDcch8ctrticCLgh2v+1nvmZyqSYm4j0nL44DsE8AR5E
         qz30lEF2JyxEhUmVm+eYxvTpYwKvTeLrS+mqqaBkc8bCJhVBu0WzyeMIwqgvoPiQ9A
         Nn/MypkwknjkUY9KMh60H85f3t8d3Jl9nQn9OzZ5bM4JO3d1wCiECNLcqEcAiulod2
         QPB2X5GnrrRUQt3Vxqma9azB0HXpxzt2ksUbatre1w5YVUH79zuiqXCUD6vd+ir01K
         JnjLdSfB4O21g==
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
Subject: [PATCH 06/22] idt77252: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:53 +0100
Message-Id: <20220326165909.506926-6-benni@stuerz.xyz>
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
 drivers/atm/idt77252_tables.h | 512 +++++++++++++++++-----------------
 1 file changed, 256 insertions(+), 256 deletions(-)

diff --git a/drivers/atm/idt77252_tables.h b/drivers/atm/idt77252_tables.h
index 12b81e046a7b..8067ac7e2d5c 100644
--- a/drivers/atm/idt77252_tables.h
+++ b/drivers/atm/idt77252_tables.h
@@ -6,262 +6,262 @@
 
 static unsigned int log_to_rate[] =
 {
-/* 000 */ 0x8d022e27, /* cps =     10.02, nrm =  3, interval = 35264.00 */
-/* 001 */ 0x8d362e11, /* cps =     10.42, nrm =  3, interval = 33856.00 */
-/* 002 */ 0x8d6e2bf8, /* cps =     10.86, nrm =  3, interval = 32512.00 */
-/* 003 */ 0x8da82bcf, /* cps =     11.31, nrm =  3, interval = 31200.00 */
-/* 004 */ 0x8de42ba8, /* cps =     11.78, nrm =  3, interval = 29952.00 */
-/* 005 */ 0x8e242b82, /* cps =     12.28, nrm =  3, interval = 28736.00 */
-/* 006 */ 0x8e662b5e, /* cps =     12.80, nrm =  3, interval = 27584.00 */
-/* 007 */ 0x8eaa2b3c, /* cps =     13.33, nrm =  3, interval = 26496.00 */
-/* 008 */ 0x8ef22b1a, /* cps =     13.89, nrm =  3, interval = 25408.00 */
-/* 009 */ 0x8f3e2afa, /* cps =     14.48, nrm =  3, interval = 24384.00 */
-/* 010 */ 0x8f8a2adc, /* cps =     15.08, nrm =  3, interval = 23424.00 */
-/* 011 */ 0x8fdc2abe, /* cps =     15.72, nrm =  3, interval = 22464.00 */
-/* 012 */ 0x90182aa2, /* cps =     16.38, nrm =  3, interval = 21568.00 */
-/* 013 */ 0x90422a87, /* cps =     17.03, nrm =  3, interval = 20704.00 */
-/* 014 */ 0x90702a6d, /* cps =     17.75, nrm =  3, interval = 19872.00 */
-/* 015 */ 0x90a02a54, /* cps =     18.50, nrm =  3, interval = 19072.00 */
-/* 016 */ 0x90d22a3c, /* cps =     19.28, nrm =  3, interval = 18304.00 */
-/* 017 */ 0x91062a25, /* cps =     20.09, nrm =  3, interval = 17568.00 */
-/* 018 */ 0x913c2a0f, /* cps =     20.94, nrm =  3, interval = 16864.00 */
-/* 019 */ 0x917427f3, /* cps =     21.81, nrm =  3, interval = 16176.00 */
-/* 020 */ 0x91b027ca, /* cps =     22.75, nrm =  3, interval = 15520.00 */
-/* 021 */ 0x91ec27a3, /* cps =     23.69, nrm =  3, interval = 14896.00 */
-/* 022 */ 0x922c277e, /* cps =     24.69, nrm =  3, interval = 14304.00 */
-/* 023 */ 0x926e275a, /* cps =     25.72, nrm =  3, interval = 13728.00 */
-/* 024 */ 0x92b42737, /* cps =     26.81, nrm =  3, interval = 13168.00 */
-/* 025 */ 0x92fc2716, /* cps =     27.94, nrm =  3, interval = 12640.00 */
-/* 026 */ 0x934626f6, /* cps =     29.09, nrm =  3, interval = 12128.00 */
-/* 027 */ 0x939426d8, /* cps =     30.31, nrm =  3, interval = 11648.00 */
-/* 028 */ 0x93e426bb, /* cps =     31.56, nrm =  3, interval = 11184.00 */
-/* 029 */ 0x941e269e, /* cps =     32.94, nrm =  3, interval = 10720.00 */
-/* 030 */ 0x944a2683, /* cps =     34.31, nrm =  3, interval = 10288.00 */
-/* 031 */ 0x9476266a, /* cps =     35.69, nrm =  3, interval =  9888.00 */
-/* 032 */ 0x94a62651, /* cps =     37.19, nrm =  3, interval =  9488.00 */
-/* 033 */ 0x94d82639, /* cps =     38.75, nrm =  3, interval =  9104.00 */
-/* 034 */ 0x950c6622, /* cps =     40.38, nrm =  4, interval =  8736.00 */
-/* 035 */ 0x9544660c, /* cps =     42.12, nrm =  4, interval =  8384.00 */
-/* 036 */ 0x957c63ee, /* cps =     43.88, nrm =  4, interval =  8048.00 */
-/* 037 */ 0x95b663c6, /* cps =     45.69, nrm =  4, interval =  7728.00 */
-/* 038 */ 0x95f4639f, /* cps =     47.62, nrm =  4, interval =  7416.00 */
-/* 039 */ 0x96346379, /* cps =     49.62, nrm =  4, interval =  7112.00 */
-/* 040 */ 0x96766356, /* cps =     51.69, nrm =  4, interval =  6832.00 */
-/* 041 */ 0x96bc6333, /* cps =     53.88, nrm =  4, interval =  6552.00 */
-/* 042 */ 0x97046312, /* cps =     56.12, nrm =  4, interval =  6288.00 */
-/* 043 */ 0x974e62f3, /* cps =     58.44, nrm =  4, interval =  6040.00 */
-/* 044 */ 0x979e62d4, /* cps =     60.94, nrm =  4, interval =  5792.00 */
-/* 045 */ 0x97f062b7, /* cps =     63.50, nrm =  4, interval =  5560.00 */
-/* 046 */ 0x9822629b, /* cps =     66.12, nrm =  4, interval =  5336.00 */
-/* 047 */ 0x984e6280, /* cps =     68.88, nrm =  4, interval =  5120.00 */
-/* 048 */ 0x987e6266, /* cps =     71.88, nrm =  4, interval =  4912.00 */
-/* 049 */ 0x98ac624e, /* cps =     74.75, nrm =  4, interval =  4720.00 */
-/* 050 */ 0x98e06236, /* cps =     78.00, nrm =  4, interval =  4528.00 */
-/* 051 */ 0x9914a21f, /* cps =     81.25, nrm =  8, interval =  4344.00 */
-/* 052 */ 0x994aa209, /* cps =     84.62, nrm =  8, interval =  4168.00 */
-/* 053 */ 0x99829fe9, /* cps =     88.12, nrm =  8, interval =  4004.00 */
-/* 054 */ 0x99be9fc1, /* cps =     91.88, nrm =  8, interval =  3844.00 */
-/* 055 */ 0x99fc9f9a, /* cps =     95.75, nrm =  8, interval =  3688.00 */
-/* 056 */ 0x9a3c9f75, /* cps =     99.75, nrm =  8, interval =  3540.00 */
-/* 057 */ 0x9a809f51, /* cps =    104.00, nrm =  8, interval =  3396.00 */
-/* 058 */ 0x9ac49f2f, /* cps =    108.25, nrm =  8, interval =  3260.00 */
-/* 059 */ 0x9b0e9f0e, /* cps =    112.88, nrm =  8, interval =  3128.00 */
-/* 060 */ 0x9b589eef, /* cps =    117.50, nrm =  8, interval =  3004.00 */
-/* 061 */ 0x9ba69ed1, /* cps =    122.38, nrm =  8, interval =  2884.00 */
-/* 062 */ 0x9bf89eb4, /* cps =    127.50, nrm =  8, interval =  2768.00 */
-/* 063 */ 0x9c269e98, /* cps =    132.75, nrm =  8, interval =  2656.00 */
-/* 064 */ 0x9c549e7d, /* cps =    138.50, nrm =  8, interval =  2548.00 */
-/* 065 */ 0x9c849e63, /* cps =    144.50, nrm =  8, interval =  2444.00 */
-/* 066 */ 0x9cb29e4b, /* cps =    150.25, nrm =  8, interval =  2348.00 */
-/* 067 */ 0x9ce69e33, /* cps =    156.75, nrm =  8, interval =  2252.00 */
-/* 068 */ 0x9d1cde1c, /* cps =    163.50, nrm = 16, interval =  2160.00 */
-/* 069 */ 0x9d50de07, /* cps =    170.00, nrm = 16, interval =  2076.00 */
-/* 070 */ 0x9d8adbe4, /* cps =    177.25, nrm = 16, interval =  1992.00 */
-/* 071 */ 0x9dc4dbbc, /* cps =    184.50, nrm = 16, interval =  1912.00 */
-/* 072 */ 0x9e02db96, /* cps =    192.25, nrm = 16, interval =  1836.00 */
-/* 073 */ 0x9e42db71, /* cps =    200.25, nrm = 16, interval =  1762.00 */
-/* 074 */ 0x9e86db4d, /* cps =    208.75, nrm = 16, interval =  1690.00 */
-/* 075 */ 0x9ecedb2b, /* cps =    217.75, nrm = 16, interval =  1622.00 */
-/* 076 */ 0x9f16db0a, /* cps =    226.75, nrm = 16, interval =  1556.00 */
-/* 077 */ 0x9f62daeb, /* cps =    236.25, nrm = 16, interval =  1494.00 */
-/* 078 */ 0x9fb2dacd, /* cps =    246.25, nrm = 16, interval =  1434.00 */
-/* 079 */ 0xa002dab0, /* cps =    256.50, nrm = 16, interval =  1376.00 */
-/* 080 */ 0xa02eda94, /* cps =    267.50, nrm = 16, interval =  1320.00 */
-/* 081 */ 0xa05ada7a, /* cps =    278.50, nrm = 16, interval =  1268.00 */
-/* 082 */ 0xa088da60, /* cps =    290.00, nrm = 16, interval =  1216.00 */
-/* 083 */ 0xa0b8da48, /* cps =    302.00, nrm = 16, interval =  1168.00 */
-/* 084 */ 0xa0ecda30, /* cps =    315.00, nrm = 16, interval =  1120.00 */
-/* 085 */ 0xa1211a1a, /* cps =    328.00, nrm = 32, interval =  1076.00 */
-/* 086 */ 0xa1591a04, /* cps =    342.00, nrm = 32, interval =  1032.00 */
-/* 087 */ 0xa19117df, /* cps =    356.00, nrm = 32, interval =   991.00 */
-/* 088 */ 0xa1cd17b7, /* cps =    371.00, nrm = 32, interval =   951.00 */
-/* 089 */ 0xa20b1791, /* cps =    386.50, nrm = 32, interval =   913.00 */
-/* 090 */ 0xa24d176c, /* cps =    403.00, nrm = 32, interval =   876.00 */
-/* 091 */ 0xa28f1749, /* cps =    419.50, nrm = 32, interval =   841.00 */
-/* 092 */ 0xa2d71727, /* cps =    437.50, nrm = 32, interval =   807.00 */
-/* 093 */ 0xa31f1707, /* cps =    455.50, nrm = 32, interval =   775.00 */
-/* 094 */ 0xa36d16e7, /* cps =    475.00, nrm = 32, interval =   743.00 */
-/* 095 */ 0xa3bd16c9, /* cps =    495.00, nrm = 32, interval =   713.00 */
-/* 096 */ 0xa40716ad, /* cps =    515.00, nrm = 32, interval =   685.00 */
-/* 097 */ 0xa4331691, /* cps =    537.00, nrm = 32, interval =   657.00 */
-/* 098 */ 0xa45f1677, /* cps =    559.00, nrm = 32, interval =   631.00 */
-/* 099 */ 0xa48f165d, /* cps =    583.00, nrm = 32, interval =   605.00 */
-/* 100 */ 0xa4bf1645, /* cps =    607.00, nrm = 32, interval =   581.00 */
-/* 101 */ 0xa4f1162e, /* cps =    632.00, nrm = 32, interval =   558.00 */
-/* 102 */ 0xa5291617, /* cps =    660.00, nrm = 32, interval =   535.00 */
-/* 103 */ 0xa55f1602, /* cps =    687.00, nrm = 32, interval =   514.00 */
-/* 104 */ 0xa59913da, /* cps =    716.00, nrm = 32, interval =   493.00 */
-/* 105 */ 0xa5d513b2, /* cps =    746.00, nrm = 32, interval =   473.00 */
-/* 106 */ 0xa613138c, /* cps =    777.00, nrm = 32, interval =   454.00 */
-/* 107 */ 0xa6551368, /* cps =    810.00, nrm = 32, interval =   436.00 */
-/* 108 */ 0xa6971345, /* cps =    843.00, nrm = 32, interval =   418.50 */
-/* 109 */ 0xa6df1323, /* cps =    879.00, nrm = 32, interval =   401.50 */
-/* 110 */ 0xa7291303, /* cps =    916.00, nrm = 32, interval =   385.50 */
-/* 111 */ 0xa77512e4, /* cps =    954.00, nrm = 32, interval =   370.00 */
-/* 112 */ 0xa7c512c6, /* cps =    994.00, nrm = 32, interval =   355.00 */
-/* 113 */ 0xa80d12a9, /* cps =   1036.00, nrm = 32, interval =   340.50 */
-/* 114 */ 0xa839128e, /* cps =   1080.00, nrm = 32, interval =   327.00 */
-/* 115 */ 0xa8651274, /* cps =   1124.00, nrm = 32, interval =   314.00 */
-/* 116 */ 0xa895125a, /* cps =   1172.00, nrm = 32, interval =   301.00 */
-/* 117 */ 0xa8c71242, /* cps =   1222.00, nrm = 32, interval =   289.00 */
-/* 118 */ 0xa8f9122b, /* cps =   1272.00, nrm = 32, interval =   277.50 */
-/* 119 */ 0xa92f1214, /* cps =   1326.00, nrm = 32, interval =   266.00 */
-/* 120 */ 0xa9670ffe, /* cps =   1382.00, nrm = 32, interval =   255.50 */
-/* 121 */ 0xa9a10fd5, /* cps =   1440.00, nrm = 32, interval =   245.25 */
-/* 122 */ 0xa9db0fae, /* cps =   1498.00, nrm = 32, interval =   235.50 */
-/* 123 */ 0xaa1b0f88, /* cps =   1562.00, nrm = 32, interval =   226.00 */
-/* 124 */ 0xaa5d0f63, /* cps =   1628.00, nrm = 32, interval =   216.75 */
-/* 125 */ 0xaaa10f41, /* cps =   1696.00, nrm = 32, interval =   208.25 */
-/* 126 */ 0xaae90f1f, /* cps =   1768.00, nrm = 32, interval =   199.75 */
-/* 127 */ 0xab330eff, /* cps =   1842.00, nrm = 32, interval =   191.75 */
-/* 128 */ 0xab7f0ee0, /* cps =   1918.00, nrm = 32, interval =   184.00 */
-/* 129 */ 0xabd10ec2, /* cps =   2000.00, nrm = 32, interval =   176.50 */
-/* 130 */ 0xac110ea6, /* cps =   2080.00, nrm = 32, interval =   169.50 */
-/* 131 */ 0xac3d0e8b, /* cps =   2168.00, nrm = 32, interval =   162.75 */
-/* 132 */ 0xac6d0e70, /* cps =   2264.00, nrm = 32, interval =   156.00 */
-/* 133 */ 0xac9b0e57, /* cps =   2356.00, nrm = 32, interval =   149.75 */
-/* 134 */ 0xaccd0e3f, /* cps =   2456.00, nrm = 32, interval =   143.75 */
-/* 135 */ 0xacff0e28, /* cps =   2556.00, nrm = 32, interval =   138.00 */
-/* 136 */ 0xad350e12, /* cps =   2664.00, nrm = 32, interval =   132.50 */
-/* 137 */ 0xad6d0bf9, /* cps =   2776.00, nrm = 32, interval =   127.12 */
-/* 138 */ 0xada70bd0, /* cps =   2892.00, nrm = 32, interval =   122.00 */
-/* 139 */ 0xade30ba9, /* cps =   3012.00, nrm = 32, interval =   117.12 */
-/* 140 */ 0xae230b83, /* cps =   3140.00, nrm = 32, interval =   112.38 */
-/* 141 */ 0xae650b5f, /* cps =   3272.00, nrm = 32, interval =   107.88 */
-/* 142 */ 0xaeab0b3c, /* cps =   3412.00, nrm = 32, interval =   103.50 */
-/* 143 */ 0xaef10b1b, /* cps =   3552.00, nrm = 32, interval =    99.38 */
-/* 144 */ 0xaf3b0afb, /* cps =   3700.00, nrm = 32, interval =    95.38 */
-/* 145 */ 0xaf8b0adc, /* cps =   3860.00, nrm = 32, interval =    91.50 */
-/* 146 */ 0xafd90abf, /* cps =   4016.00, nrm = 32, interval =    87.88 */
-/* 147 */ 0xb0170aa3, /* cps =   4184.00, nrm = 32, interval =    84.38 */
-/* 148 */ 0xb0430a87, /* cps =   4360.00, nrm = 32, interval =    80.88 */
-/* 149 */ 0xb0710a6d, /* cps =   4544.00, nrm = 32, interval =    77.62 */
-/* 150 */ 0xb0a10a54, /* cps =   4736.00, nrm = 32, interval =    74.50 */
-/* 151 */ 0xb0d30a3c, /* cps =   4936.00, nrm = 32, interval =    71.50 */
-/* 152 */ 0xb1070a25, /* cps =   5144.00, nrm = 32, interval =    68.62 */
-/* 153 */ 0xb13d0a0f, /* cps =   5360.00, nrm = 32, interval =    65.88 */
-/* 154 */ 0xb17507f4, /* cps =   5584.00, nrm = 32, interval =    63.25 */
-/* 155 */ 0xb1af07cb, /* cps =   5816.00, nrm = 32, interval =    60.69 */
-/* 156 */ 0xb1eb07a4, /* cps =   6056.00, nrm = 32, interval =    58.25 */
-/* 157 */ 0xb22b077f, /* cps =   6312.00, nrm = 32, interval =    55.94 */
-/* 158 */ 0xb26d075b, /* cps =   6576.00, nrm = 32, interval =    53.69 */
-/* 159 */ 0xb2b30738, /* cps =   6856.00, nrm = 32, interval =    51.50 */
-/* 160 */ 0xb2fb0717, /* cps =   7144.00, nrm = 32, interval =    49.44 */
-/* 161 */ 0xb34506f7, /* cps =   7440.00, nrm = 32, interval =    47.44 */
-/* 162 */ 0xb39306d9, /* cps =   7752.00, nrm = 32, interval =    45.56 */
-/* 163 */ 0xb3e506bb, /* cps =   8080.00, nrm = 32, interval =    43.69 */
-/* 164 */ 0xb41d069f, /* cps =   8416.00, nrm = 32, interval =    41.94 */
-/* 165 */ 0xb4490684, /* cps =   8768.00, nrm = 32, interval =    40.25 */
-/* 166 */ 0xb477066a, /* cps =   9136.00, nrm = 32, interval =    38.62 */
-/* 167 */ 0xb4a70651, /* cps =   9520.00, nrm = 32, interval =    37.06 */
-/* 168 */ 0xb4d90639, /* cps =   9920.00, nrm = 32, interval =    35.56 */
-/* 169 */ 0xb50d0622, /* cps =  10336.00, nrm = 32, interval =    34.12 */
-/* 170 */ 0xb545060c, /* cps =  10784.00, nrm = 32, interval =    32.75 */
-/* 171 */ 0xb57b03ef, /* cps =  11216.00, nrm = 32, interval =    31.47 */
-/* 172 */ 0xb5b503c7, /* cps =  11680.00, nrm = 32, interval =    30.22 */
-/* 173 */ 0xb5f303a0, /* cps =  12176.00, nrm = 32, interval =    29.00 */
-/* 174 */ 0xb633037a, /* cps =  12688.00, nrm = 32, interval =    27.81 */
-/* 175 */ 0xb6750357, /* cps =  13216.00, nrm = 32, interval =    26.72 */
-/* 176 */ 0xb6bb0334, /* cps =  13776.00, nrm = 32, interval =    25.62 */
-/* 177 */ 0xb7030313, /* cps =  14352.00, nrm = 32, interval =    24.59 */
-/* 178 */ 0xb74f02f3, /* cps =  14960.00, nrm = 32, interval =    23.59 */
-/* 179 */ 0xb79d02d5, /* cps =  15584.00, nrm = 32, interval =    22.66 */
-/* 180 */ 0xb7ed02b8, /* cps =  16224.00, nrm = 32, interval =    21.75 */
-/* 181 */ 0xb821029c, /* cps =  16896.00, nrm = 32, interval =    20.88 */
-/* 182 */ 0xb84f0281, /* cps =  17632.00, nrm = 32, interval =    20.03 */
-/* 183 */ 0xb87d0267, /* cps =  18368.00, nrm = 32, interval =    19.22 */
-/* 184 */ 0xb8ad024e, /* cps =  19136.00, nrm = 32, interval =    18.44 */
-/* 185 */ 0xb8dd0237, /* cps =  19904.00, nrm = 32, interval =    17.72 */
-/* 186 */ 0xb9130220, /* cps =  20768.00, nrm = 32, interval =    17.00 */
-/* 187 */ 0xb949020a, /* cps =  21632.00, nrm = 32, interval =    16.31 */
-/* 188 */ 0xb98301f5, /* cps =  22560.00, nrm = 32, interval =    15.66 */
-/* 189 */ 0xb9bd01e1, /* cps =  23488.00, nrm = 32, interval =    15.03 */
-/* 190 */ 0xb9fd01cd, /* cps =  24512.00, nrm = 32, interval =    14.41 */
-/* 191 */ 0xba3b01bb, /* cps =  25504.00, nrm = 32, interval =    13.84 */
-/* 192 */ 0xba7f01a9, /* cps =  26592.00, nrm = 32, interval =    13.28 */
-/* 193 */ 0xbac30198, /* cps =  27680.00, nrm = 32, interval =    12.75 */
-/* 194 */ 0xbb0f0187, /* cps =  28896.00, nrm = 32, interval =    12.22 */
-/* 195 */ 0xbb570178, /* cps =  30048.00, nrm = 32, interval =    11.75 */
-/* 196 */ 0xbbab0168, /* cps =  31392.00, nrm = 32, interval =    11.25 */
-/* 197 */ 0xbbf9015a, /* cps =  32640.00, nrm = 32, interval =    10.81 */
-/* 198 */ 0xbc27014c, /* cps =  33984.00, nrm = 32, interval =    10.38 */
-/* 199 */ 0xbc53013f, /* cps =  35392.00, nrm = 32, interval =     9.97 */
-/* 200 */ 0xbc830132, /* cps =  36928.00, nrm = 32, interval =     9.56 */
-/* 201 */ 0xbcb50125, /* cps =  38528.00, nrm = 32, interval =     9.16 */
-/* 202 */ 0xbce5011a, /* cps =  40064.00, nrm = 32, interval =     8.81 */
-/* 203 */ 0xbd1d010e, /* cps =  41856.00, nrm = 32, interval =     8.44 */
-/* 204 */ 0xbd530103, /* cps =  43584.00, nrm = 32, interval =     8.09 */
-/* 205 */ 0xbd8b00f9, /* cps =  45376.00, nrm = 32, interval =     7.78 */
-/* 206 */ 0xbdc500ef, /* cps =  47232.00, nrm = 32, interval =     7.47 */
-/* 207 */ 0xbe0700e5, /* cps =  49344.00, nrm = 32, interval =     7.16 */
-/* 208 */ 0xbe4500dc, /* cps =  51328.00, nrm = 32, interval =     6.88 */
-/* 209 */ 0xbe8900d3, /* cps =  53504.00, nrm = 32, interval =     6.59 */
-/* 210 */ 0xbecb00cb, /* cps =  55616.00, nrm = 32, interval =     6.34 */
-/* 211 */ 0xbf1d00c2, /* cps =  58240.00, nrm = 32, interval =     6.06 */
-/* 212 */ 0xbf6100bb, /* cps =  60416.00, nrm = 32, interval =     5.84 */
-/* 213 */ 0xbfb500b3, /* cps =  63104.00, nrm = 32, interval =     5.59 */
-/* 214 */ 0xc00300ac, /* cps =  65664.00, nrm = 32, interval =     5.38 */
-/* 215 */ 0xc02f00a5, /* cps =  68480.00, nrm = 32, interval =     5.16 */
-/* 216 */ 0xc05d009e, /* cps =  71424.00, nrm = 32, interval =     4.94 */
-/* 217 */ 0xc0890098, /* cps =  74240.00, nrm = 32, interval =     4.75 */
-/* 218 */ 0xc0b90092, /* cps =  77312.00, nrm = 32, interval =     4.56 */
-/* 219 */ 0xc0ed008c, /* cps =  80640.00, nrm = 32, interval =     4.38 */
-/* 220 */ 0xc1250086, /* cps =  84224.00, nrm = 32, interval =     4.19 */
-/* 221 */ 0xc1590081, /* cps =  87552.00, nrm = 32, interval =     4.03 */
-/* 222 */ 0xc191007c, /* cps =  91136.00, nrm = 32, interval =     3.88 */
-/* 223 */ 0xc1cd0077, /* cps =  94976.00, nrm = 32, interval =     3.72 */
-/* 224 */ 0xc20d0072, /* cps =  99072.00, nrm = 32, interval =     3.56 */
-/* 225 */ 0xc255006d, /* cps = 103680.00, nrm = 32, interval =     3.41 */
-/* 226 */ 0xc2910069, /* cps = 107520.00, nrm = 32, interval =     3.28 */
-/* 227 */ 0xc2d50065, /* cps = 111872.00, nrm = 32, interval =     3.16 */
-/* 228 */ 0xc32f0060, /* cps = 117632.00, nrm = 32, interval =     3.00 */
-/* 229 */ 0xc36b005d, /* cps = 121472.00, nrm = 32, interval =     2.91 */
-/* 230 */ 0xc3c10059, /* cps = 126976.00, nrm = 32, interval =     2.78 */
-/* 231 */ 0xc40f0055, /* cps = 132864.00, nrm = 32, interval =     2.66 */
-/* 232 */ 0xc4350052, /* cps = 137728.00, nrm = 32, interval =     2.56 */
-/* 233 */ 0xc46d004e, /* cps = 144896.00, nrm = 32, interval =     2.44 */
-/* 234 */ 0xc499004b, /* cps = 150528.00, nrm = 32, interval =     2.34 */
-/* 235 */ 0xc4cb0048, /* cps = 156928.00, nrm = 32, interval =     2.25 */
-/* 236 */ 0xc4ff0045, /* cps = 163584.00, nrm = 32, interval =     2.16 */
-/* 237 */ 0xc5250043, /* cps = 168448.00, nrm = 32, interval =     2.09 */
-/* 238 */ 0xc5630040, /* cps = 176384.00, nrm = 32, interval =     2.00 */
-/* 239 */ 0xc5a7003d, /* cps = 185088.00, nrm = 32, interval =     1.91 */
-/* 240 */ 0xc5d9003b, /* cps = 191488.00, nrm = 32, interval =     1.84 */
-/* 241 */ 0xc6290038, /* cps = 201728.00, nrm = 32, interval =     1.75 */
-/* 242 */ 0xc6630036, /* cps = 209152.00, nrm = 32, interval =     1.69 */
-/* 243 */ 0xc6a30034, /* cps = 217344.00, nrm = 32, interval =     1.62 */
-/* 244 */ 0xc6e70032, /* cps = 226048.00, nrm = 32, interval =     1.56 */
-/* 245 */ 0xc72f0030, /* cps = 235264.00, nrm = 32, interval =     1.50 */
-/* 246 */ 0xc77f002e, /* cps = 245504.00, nrm = 32, interval =     1.44 */
-/* 247 */ 0xc7d7002c, /* cps = 256768.00, nrm = 32, interval =     1.38 */
-/* 248 */ 0xc81b002a, /* cps = 268800.00, nrm = 32, interval =     1.31 */
-/* 249 */ 0xc84f0028, /* cps = 282112.00, nrm = 32, interval =     1.25 */
-/* 250 */ 0xc86d0027, /* cps = 289792.00, nrm = 32, interval =     1.22 */
-/* 251 */ 0xc8a90025, /* cps = 305152.00, nrm = 32, interval =     1.16 */
-/* 252 */ 0xc8cb0024, /* cps = 313856.00, nrm = 32, interval =     1.12 */
-/* 253 */ 0xc9130022, /* cps = 332288.00, nrm = 32, interval =     1.06 */
-/* 254 */ 0xc9390021, /* cps = 342016.00, nrm = 32, interval =     1.03 */
-/* 255 */ 0xc9630020, /* cps = 352768.00, nrm = 32, interval =     1.00 */
+	[0]   = 0x8d022e27, /* cps =     10.02, nrm =  3, interval = 35264.00 */
+	[1]   = 0x8d362e11, /* cps =     10.42, nrm =  3, interval = 33856.00 */
+	[2]   = 0x8d6e2bf8, /* cps =     10.86, nrm =  3, interval = 32512.00 */
+	[3]   = 0x8da82bcf, /* cps =     11.31, nrm =  3, interval = 31200.00 */
+	[4]   = 0x8de42ba8, /* cps =     11.78, nrm =  3, interval = 29952.00 */
+	[5]   = 0x8e242b82, /* cps =     12.28, nrm =  3, interval = 28736.00 */
+	[6]   = 0x8e662b5e, /* cps =     12.80, nrm =  3, interval = 27584.00 */
+	[7]   = 0x8eaa2b3c, /* cps =     13.33, nrm =  3, interval = 26496.00 */
+	[8]   = 0x8ef22b1a, /* cps =     13.89, nrm =  3, interval = 25408.00 */
+	[9]   = 0x8f3e2afa, /* cps =     14.48, nrm =  3, interval = 24384.00 */
+	[10]  = 0x8f8a2adc, /* cps =     15.08, nrm =  3, interval = 23424.00 */
+	[11]  = 0x8fdc2abe, /* cps =     15.72, nrm =  3, interval = 22464.00 */
+	[12]  = 0x90182aa2, /* cps =     16.38, nrm =  3, interval = 21568.00 */
+	[13]  = 0x90422a87, /* cps =     17.03, nrm =  3, interval = 20704.00 */
+	[14]  = 0x90702a6d, /* cps =     17.75, nrm =  3, interval = 19872.00 */
+	[15]  = 0x90a02a54, /* cps =     18.50, nrm =  3, interval = 19072.00 */
+	[16]  = 0x90d22a3c, /* cps =     19.28, nrm =  3, interval = 18304.00 */
+	[17]  = 0x91062a25, /* cps =     20.09, nrm =  3, interval = 17568.00 */
+	[18]  = 0x913c2a0f, /* cps =     20.94, nrm =  3, interval = 16864.00 */
+	[19]  = 0x917427f3, /* cps =     21.81, nrm =  3, interval = 16176.00 */
+	[20]  = 0x91b027ca, /* cps =     22.75, nrm =  3, interval = 15520.00 */
+	[21]  = 0x91ec27a3, /* cps =     23.69, nrm =  3, interval = 14896.00 */
+	[22]  = 0x922c277e, /* cps =     24.69, nrm =  3, interval = 14304.00 */
+	[23]  = 0x926e275a, /* cps =     25.72, nrm =  3, interval = 13728.00 */
+	[24]  = 0x92b42737, /* cps =     26.81, nrm =  3, interval = 13168.00 */
+	[25]  = 0x92fc2716, /* cps =     27.94, nrm =  3, interval = 12640.00 */
+	[26]  = 0x934626f6, /* cps =     29.09, nrm =  3, interval = 12128.00 */
+	[27]  = 0x939426d8, /* cps =     30.31, nrm =  3, interval = 11648.00 */
+	[28]  = 0x93e426bb, /* cps =     31.56, nrm =  3, interval = 11184.00 */
+	[29]  = 0x941e269e, /* cps =     32.94, nrm =  3, interval = 10720.00 */
+	[30]  = 0x944a2683, /* cps =     34.31, nrm =  3, interval = 10288.00 */
+	[31]  = 0x9476266a, /* cps =     35.69, nrm =  3, interval =  9888.00 */
+	[32]  = 0x94a62651, /* cps =     37.19, nrm =  3, interval =  9488.00 */
+	[33]  = 0x94d82639, /* cps =     38.75, nrm =  3, interval =  9104.00 */
+	[34]  = 0x950c6622, /* cps =     40.38, nrm =  4, interval =  8736.00 */
+	[35]  = 0x9544660c, /* cps =     42.12, nrm =  4, interval =  8384.00 */
+	[36]  = 0x957c63ee, /* cps =     43.88, nrm =  4, interval =  8048.00 */
+	[37]  = 0x95b663c6, /* cps =     45.69, nrm =  4, interval =  7728.00 */
+	[38]  = 0x95f4639f, /* cps =     47.62, nrm =  4, interval =  7416.00 */
+	[39]  = 0x96346379, /* cps =     49.62, nrm =  4, interval =  7112.00 */
+	[40]  = 0x96766356, /* cps =     51.69, nrm =  4, interval =  6832.00 */
+	[41]  = 0x96bc6333, /* cps =     53.88, nrm =  4, interval =  6552.00 */
+	[42]  = 0x97046312, /* cps =     56.12, nrm =  4, interval =  6288.00 */
+	[43]  = 0x974e62f3, /* cps =     58.44, nrm =  4, interval =  6040.00 */
+	[44]  = 0x979e62d4, /* cps =     60.94, nrm =  4, interval =  5792.00 */
+	[45]  = 0x97f062b7, /* cps =     63.50, nrm =  4, interval =  5560.00 */
+	[46]  = 0x9822629b, /* cps =     66.12, nrm =  4, interval =  5336.00 */
+	[47]  = 0x984e6280, /* cps =     68.88, nrm =  4, interval =  5120.00 */
+	[48]  = 0x987e6266, /* cps =     71.88, nrm =  4, interval =  4912.00 */
+	[49]  = 0x98ac624e, /* cps =     74.75, nrm =  4, interval =  4720.00 */
+	[50]  = 0x98e06236, /* cps =     78.00, nrm =  4, interval =  4528.00 */
+	[51]  = 0x9914a21f, /* cps =     81.25, nrm =  8, interval =  4344.00 */
+	[52]  = 0x994aa209, /* cps =     84.62, nrm =  8, interval =  4168.00 */
+	[53]  = 0x99829fe9, /* cps =     88.12, nrm =  8, interval =  4004.00 */
+	[54]  = 0x99be9fc1, /* cps =     91.88, nrm =  8, interval =  3844.00 */
+	[55]  = 0x99fc9f9a, /* cps =     95.75, nrm =  8, interval =  3688.00 */
+	[56]  = 0x9a3c9f75, /* cps =     99.75, nrm =  8, interval =  3540.00 */
+	[57]  = 0x9a809f51, /* cps =    104.00, nrm =  8, interval =  3396.00 */
+	[58]  = 0x9ac49f2f, /* cps =    108.25, nrm =  8, interval =  3260.00 */
+	[59]  = 0x9b0e9f0e, /* cps =    112.88, nrm =  8, interval =  3128.00 */
+	[60]  = 0x9b589eef, /* cps =    117.50, nrm =  8, interval =  3004.00 */
+	[61]  = 0x9ba69ed1, /* cps =    122.38, nrm =  8, interval =  2884.00 */
+	[62]  = 0x9bf89eb4, /* cps =    127.50, nrm =  8, interval =  2768.00 */
+	[63]  = 0x9c269e98, /* cps =    132.75, nrm =  8, interval =  2656.00 */
+	[64]  = 0x9c549e7d, /* cps =    138.50, nrm =  8, interval =  2548.00 */
+	[65]  = 0x9c849e63, /* cps =    144.50, nrm =  8, interval =  2444.00 */
+	[66]  = 0x9cb29e4b, /* cps =    150.25, nrm =  8, interval =  2348.00 */
+	[67]  = 0x9ce69e33, /* cps =    156.75, nrm =  8, interval =  2252.00 */
+	[68]  = 0x9d1cde1c, /* cps =    163.50, nrm = 16, interval =  2160.00 */
+	[69]  = 0x9d50de07, /* cps =    170.00, nrm = 16, interval =  2076.00 */
+	[70]  = 0x9d8adbe4, /* cps =    177.25, nrm = 16, interval =  1992.00 */
+	[71]  = 0x9dc4dbbc, /* cps =    184.50, nrm = 16, interval =  1912.00 */
+	[72]  = 0x9e02db96, /* cps =    192.25, nrm = 16, interval =  1836.00 */
+	[73]  = 0x9e42db71, /* cps =    200.25, nrm = 16, interval =  1762.00 */
+	[74]  = 0x9e86db4d, /* cps =    208.75, nrm = 16, interval =  1690.00 */
+	[75]  = 0x9ecedb2b, /* cps =    217.75, nrm = 16, interval =  1622.00 */
+	[76]  = 0x9f16db0a, /* cps =    226.75, nrm = 16, interval =  1556.00 */
+	[77]  = 0x9f62daeb, /* cps =    236.25, nrm = 16, interval =  1494.00 */
+	[78]  = 0x9fb2dacd, /* cps =    246.25, nrm = 16, interval =  1434.00 */
+	[79]  = 0xa002dab0, /* cps =    256.50, nrm = 16, interval =  1376.00 */
+	[80]  = 0xa02eda94, /* cps =    267.50, nrm = 16, interval =  1320.00 */
+	[81]  = 0xa05ada7a, /* cps =    278.50, nrm = 16, interval =  1268.00 */
+	[82]  = 0xa088da60, /* cps =    290.00, nrm = 16, interval =  1216.00 */
+	[83]  = 0xa0b8da48, /* cps =    302.00, nrm = 16, interval =  1168.00 */
+	[84]  = 0xa0ecda30, /* cps =    315.00, nrm = 16, interval =  1120.00 */
+	[85]  = 0xa1211a1a, /* cps =    328.00, nrm = 32, interval =  1076.00 */
+	[86]  = 0xa1591a04, /* cps =    342.00, nrm = 32, interval =  1032.00 */
+	[87]  = 0xa19117df, /* cps =    356.00, nrm = 32, interval =   991.00 */
+	[88]  = 0xa1cd17b7, /* cps =    371.00, nrm = 32, interval =   951.00 */
+	[89]  = 0xa20b1791, /* cps =    386.50, nrm = 32, interval =   913.00 */
+	[90]  = 0xa24d176c, /* cps =    403.00, nrm = 32, interval =   876.00 */
+	[91]  = 0xa28f1749, /* cps =    419.50, nrm = 32, interval =   841.00 */
+	[92]  = 0xa2d71727, /* cps =    437.50, nrm = 32, interval =   807.00 */
+	[93]  = 0xa31f1707, /* cps =    455.50, nrm = 32, interval =   775.00 */
+	[94]  = 0xa36d16e7, /* cps =    475.00, nrm = 32, interval =   743.00 */
+	[95]  = 0xa3bd16c9, /* cps =    495.00, nrm = 32, interval =   713.00 */
+	[96]  = 0xa40716ad, /* cps =    515.00, nrm = 32, interval =   685.00 */
+	[97]  = 0xa4331691, /* cps =    537.00, nrm = 32, interval =   657.00 */
+	[98]  = 0xa45f1677, /* cps =    559.00, nrm = 32, interval =   631.00 */
+	[99]  = 0xa48f165d, /* cps =    583.00, nrm = 32, interval =   605.00 */
+	[100] = 0xa4bf1645, /* cps =    607.00, nrm = 32, interval =   581.00 */
+	[101] = 0xa4f1162e, /* cps =    632.00, nrm = 32, interval =   558.00 */
+	[102] = 0xa5291617, /* cps =    660.00, nrm = 32, interval =   535.00 */
+	[103] = 0xa55f1602, /* cps =    687.00, nrm = 32, interval =   514.00 */
+	[104] = 0xa59913da, /* cps =    716.00, nrm = 32, interval =   493.00 */
+	[105] = 0xa5d513b2, /* cps =    746.00, nrm = 32, interval =   473.00 */
+	[106] = 0xa613138c, /* cps =    777.00, nrm = 32, interval =   454.00 */
+	[107] = 0xa6551368, /* cps =    810.00, nrm = 32, interval =   436.00 */
+	[108] = 0xa6971345, /* cps =    843.00, nrm = 32, interval =   418.50 */
+	[109] = 0xa6df1323, /* cps =    879.00, nrm = 32, interval =   401.50 */
+	[110] = 0xa7291303, /* cps =    916.00, nrm = 32, interval =   385.50 */
+	[111] = 0xa77512e4, /* cps =    954.00, nrm = 32, interval =   370.00 */
+	[112] = 0xa7c512c6, /* cps =    994.00, nrm = 32, interval =   355.00 */
+	[113] = 0xa80d12a9, /* cps =   1036.00, nrm = 32, interval =   340.50 */
+	[114] = 0xa839128e, /* cps =   1080.00, nrm = 32, interval =   327.00 */
+	[115] = 0xa8651274, /* cps =   1124.00, nrm = 32, interval =   314.00 */
+	[116] = 0xa895125a, /* cps =   1172.00, nrm = 32, interval =   301.00 */
+	[117] = 0xa8c71242, /* cps =   1222.00, nrm = 32, interval =   289.00 */
+	[118] = 0xa8f9122b, /* cps =   1272.00, nrm = 32, interval =   277.50 */
+	[119] = 0xa92f1214, /* cps =   1326.00, nrm = 32, interval =   266.00 */
+	[120] = 0xa9670ffe, /* cps =   1382.00, nrm = 32, interval =   255.50 */
+	[121] = 0xa9a10fd5, /* cps =   1440.00, nrm = 32, interval =   245.25 */
+	[122] = 0xa9db0fae, /* cps =   1498.00, nrm = 32, interval =   235.50 */
+	[123] = 0xaa1b0f88, /* cps =   1562.00, nrm = 32, interval =   226.00 */
+	[124] = 0xaa5d0f63, /* cps =   1628.00, nrm = 32, interval =   216.75 */
+	[125] = 0xaaa10f41, /* cps =   1696.00, nrm = 32, interval =   208.25 */
+	[126] = 0xaae90f1f, /* cps =   1768.00, nrm = 32, interval =   199.75 */
+	[127] = 0xab330eff, /* cps =   1842.00, nrm = 32, interval =   191.75 */
+	[128] = 0xab7f0ee0, /* cps =   1918.00, nrm = 32, interval =   184.00 */
+	[129] = 0xabd10ec2, /* cps =   2000.00, nrm = 32, interval =   176.50 */
+	[130] = 0xac110ea6, /* cps =   2080.00, nrm = 32, interval =   169.50 */
+	[131] = 0xac3d0e8b, /* cps =   2168.00, nrm = 32, interval =   162.75 */
+	[132] = 0xac6d0e70, /* cps =   2264.00, nrm = 32, interval =   156.00 */
+	[133] = 0xac9b0e57, /* cps =   2356.00, nrm = 32, interval =   149.75 */
+	[134] = 0xaccd0e3f, /* cps =   2456.00, nrm = 32, interval =   143.75 */
+	[135] = 0xacff0e28, /* cps =   2556.00, nrm = 32, interval =   138.00 */
+	[136] = 0xad350e12, /* cps =   2664.00, nrm = 32, interval =   132.50 */
+	[137] = 0xad6d0bf9, /* cps =   2776.00, nrm = 32, interval =   127.12 */
+	[138] = 0xada70bd0, /* cps =   2892.00, nrm = 32, interval =   122.00 */
+	[139] = 0xade30ba9, /* cps =   3012.00, nrm = 32, interval =   117.12 */
+	[140] = 0xae230b83, /* cps =   3140.00, nrm = 32, interval =   112.38 */
+	[141] = 0xae650b5f, /* cps =   3272.00, nrm = 32, interval =   107.88 */
+	[142] = 0xaeab0b3c, /* cps =   3412.00, nrm = 32, interval =   103.50 */
+	[143] = 0xaef10b1b, /* cps =   3552.00, nrm = 32, interval =    99.38 */
+	[144] = 0xaf3b0afb, /* cps =   3700.00, nrm = 32, interval =    95.38 */
+	[145] = 0xaf8b0adc, /* cps =   3860.00, nrm = 32, interval =    91.50 */
+	[146] = 0xafd90abf, /* cps =   4016.00, nrm = 32, interval =    87.88 */
+	[147] = 0xb0170aa3, /* cps =   4184.00, nrm = 32, interval =    84.38 */
+	[148] = 0xb0430a87, /* cps =   4360.00, nrm = 32, interval =    80.88 */
+	[149] = 0xb0710a6d, /* cps =   4544.00, nrm = 32, interval =    77.62 */
+	[150] = 0xb0a10a54, /* cps =   4736.00, nrm = 32, interval =    74.50 */
+	[151] = 0xb0d30a3c, /* cps =   4936.00, nrm = 32, interval =    71.50 */
+	[152] = 0xb1070a25, /* cps =   5144.00, nrm = 32, interval =    68.62 */
+	[153] = 0xb13d0a0f, /* cps =   5360.00, nrm = 32, interval =    65.88 */
+	[154] = 0xb17507f4, /* cps =   5584.00, nrm = 32, interval =    63.25 */
+	[155] = 0xb1af07cb, /* cps =   5816.00, nrm = 32, interval =    60.69 */
+	[156] = 0xb1eb07a4, /* cps =   6056.00, nrm = 32, interval =    58.25 */
+	[157] = 0xb22b077f, /* cps =   6312.00, nrm = 32, interval =    55.94 */
+	[158] = 0xb26d075b, /* cps =   6576.00, nrm = 32, interval =    53.69 */
+	[159] = 0xb2b30738, /* cps =   6856.00, nrm = 32, interval =    51.50 */
+	[160] = 0xb2fb0717, /* cps =   7144.00, nrm = 32, interval =    49.44 */
+	[161] = 0xb34506f7, /* cps =   7440.00, nrm = 32, interval =    47.44 */
+	[162] = 0xb39306d9, /* cps =   7752.00, nrm = 32, interval =    45.56 */
+	[163] = 0xb3e506bb, /* cps =   8080.00, nrm = 32, interval =    43.69 */
+	[164] = 0xb41d069f, /* cps =   8416.00, nrm = 32, interval =    41.94 */
+	[165] = 0xb4490684, /* cps =   8768.00, nrm = 32, interval =    40.25 */
+	[166] = 0xb477066a, /* cps =   9136.00, nrm = 32, interval =    38.62 */
+	[167] = 0xb4a70651, /* cps =   9520.00, nrm = 32, interval =    37.06 */
+	[168] = 0xb4d90639, /* cps =   9920.00, nrm = 32, interval =    35.56 */
+	[169] = 0xb50d0622, /* cps =  10336.00, nrm = 32, interval =    34.12 */
+	[170] = 0xb545060c, /* cps =  10784.00, nrm = 32, interval =    32.75 */
+	[171] = 0xb57b03ef, /* cps =  11216.00, nrm = 32, interval =    31.47 */
+	[172] = 0xb5b503c7, /* cps =  11680.00, nrm = 32, interval =    30.22 */
+	[173] = 0xb5f303a0, /* cps =  12176.00, nrm = 32, interval =    29.00 */
+	[174] = 0xb633037a, /* cps =  12688.00, nrm = 32, interval =    27.81 */
+	[175] = 0xb6750357, /* cps =  13216.00, nrm = 32, interval =    26.72 */
+	[176] = 0xb6bb0334, /* cps =  13776.00, nrm = 32, interval =    25.62 */
+	[177] = 0xb7030313, /* cps =  14352.00, nrm = 32, interval =    24.59 */
+	[178] = 0xb74f02f3, /* cps =  14960.00, nrm = 32, interval =    23.59 */
+	[179] = 0xb79d02d5, /* cps =  15584.00, nrm = 32, interval =    22.66 */
+	[180] = 0xb7ed02b8, /* cps =  16224.00, nrm = 32, interval =    21.75 */
+	[181] = 0xb821029c, /* cps =  16896.00, nrm = 32, interval =    20.88 */
+	[182] = 0xb84f0281, /* cps =  17632.00, nrm = 32, interval =    20.03 */
+	[183] = 0xb87d0267, /* cps =  18368.00, nrm = 32, interval =    19.22 */
+	[184] = 0xb8ad024e, /* cps =  19136.00, nrm = 32, interval =    18.44 */
+	[185] = 0xb8dd0237, /* cps =  19904.00, nrm = 32, interval =    17.72 */
+	[186] = 0xb9130220, /* cps =  20768.00, nrm = 32, interval =    17.00 */
+	[187] = 0xb949020a, /* cps =  21632.00, nrm = 32, interval =    16.31 */
+	[188] = 0xb98301f5, /* cps =  22560.00, nrm = 32, interval =    15.66 */
+	[189] = 0xb9bd01e1, /* cps =  23488.00, nrm = 32, interval =    15.03 */
+	[190] = 0xb9fd01cd, /* cps =  24512.00, nrm = 32, interval =    14.41 */
+	[191] = 0xba3b01bb, /* cps =  25504.00, nrm = 32, interval =    13.84 */
+	[192] = 0xba7f01a9, /* cps =  26592.00, nrm = 32, interval =    13.28 */
+	[193] = 0xbac30198, /* cps =  27680.00, nrm = 32, interval =    12.75 */
+	[194] = 0xbb0f0187, /* cps =  28896.00, nrm = 32, interval =    12.22 */
+	[195] = 0xbb570178, /* cps =  30048.00, nrm = 32, interval =    11.75 */
+	[196] = 0xbbab0168, /* cps =  31392.00, nrm = 32, interval =    11.25 */
+	[197] = 0xbbf9015a, /* cps =  32640.00, nrm = 32, interval =    10.81 */
+	[198] = 0xbc27014c, /* cps =  33984.00, nrm = 32, interval =    10.38 */
+	[199] = 0xbc53013f, /* cps =  35392.00, nrm = 32, interval =     9.97 */
+	[200] = 0xbc830132, /* cps =  36928.00, nrm = 32, interval =     9.56 */
+	[201] = 0xbcb50125, /* cps =  38528.00, nrm = 32, interval =     9.16 */
+	[202] = 0xbce5011a, /* cps =  40064.00, nrm = 32, interval =     8.81 */
+	[203] = 0xbd1d010e, /* cps =  41856.00, nrm = 32, interval =     8.44 */
+	[204] = 0xbd530103, /* cps =  43584.00, nrm = 32, interval =     8.09 */
+	[205] = 0xbd8b00f9, /* cps =  45376.00, nrm = 32, interval =     7.78 */
+	[206] = 0xbdc500ef, /* cps =  47232.00, nrm = 32, interval =     7.47 */
+	[207] = 0xbe0700e5, /* cps =  49344.00, nrm = 32, interval =     7.16 */
+	[208] = 0xbe4500dc, /* cps =  51328.00, nrm = 32, interval =     6.88 */
+	[209] = 0xbe8900d3, /* cps =  53504.00, nrm = 32, interval =     6.59 */
+	[210] = 0xbecb00cb, /* cps =  55616.00, nrm = 32, interval =     6.34 */
+	[211] = 0xbf1d00c2, /* cps =  58240.00, nrm = 32, interval =     6.06 */
+	[212] = 0xbf6100bb, /* cps =  60416.00, nrm = 32, interval =     5.84 */
+	[213] = 0xbfb500b3, /* cps =  63104.00, nrm = 32, interval =     5.59 */
+	[214] = 0xc00300ac, /* cps =  65664.00, nrm = 32, interval =     5.38 */
+	[215] = 0xc02f00a5, /* cps =  68480.00, nrm = 32, interval =     5.16 */
+	[216] = 0xc05d009e, /* cps =  71424.00, nrm = 32, interval =     4.94 */
+	[217] = 0xc0890098, /* cps =  74240.00, nrm = 32, interval =     4.75 */
+	[218] = 0xc0b90092, /* cps =  77312.00, nrm = 32, interval =     4.56 */
+	[219] = 0xc0ed008c, /* cps =  80640.00, nrm = 32, interval =     4.38 */
+	[220] = 0xc1250086, /* cps =  84224.00, nrm = 32, interval =     4.19 */
+	[221] = 0xc1590081, /* cps =  87552.00, nrm = 32, interval =     4.03 */
+	[222] = 0xc191007c, /* cps =  91136.00, nrm = 32, interval =     3.88 */
+	[223] = 0xc1cd0077, /* cps =  94976.00, nrm = 32, interval =     3.72 */
+	[224] = 0xc20d0072, /* cps =  99072.00, nrm = 32, interval =     3.56 */
+	[225] = 0xc255006d, /* cps = 103680.00, nrm = 32, interval =     3.41 */
+	[226] = 0xc2910069, /* cps = 107520.00, nrm = 32, interval =     3.28 */
+	[227] = 0xc2d50065, /* cps = 111872.00, nrm = 32, interval =     3.16 */
+	[228] = 0xc32f0060, /* cps = 117632.00, nrm = 32, interval =     3.00 */
+	[229] = 0xc36b005d, /* cps = 121472.00, nrm = 32, interval =     2.91 */
+	[230] = 0xc3c10059, /* cps = 126976.00, nrm = 32, interval =     2.78 */
+	[231] = 0xc40f0055, /* cps = 132864.00, nrm = 32, interval =     2.66 */
+	[232] = 0xc4350052, /* cps = 137728.00, nrm = 32, interval =     2.56 */
+	[233] = 0xc46d004e, /* cps = 144896.00, nrm = 32, interval =     2.44 */
+	[234] = 0xc499004b, /* cps = 150528.00, nrm = 32, interval =     2.34 */
+	[235] = 0xc4cb0048, /* cps = 156928.00, nrm = 32, interval =     2.25 */
+	[236] = 0xc4ff0045, /* cps = 163584.00, nrm = 32, interval =     2.16 */
+	[237] = 0xc5250043, /* cps = 168448.00, nrm = 32, interval =     2.09 */
+	[238] = 0xc5630040, /* cps = 176384.00, nrm = 32, interval =     2.00 */
+	[239] = 0xc5a7003d, /* cps = 185088.00, nrm = 32, interval =     1.91 */
+	[240] = 0xc5d9003b, /* cps = 191488.00, nrm = 32, interval =     1.84 */
+	[241] = 0xc6290038, /* cps = 201728.00, nrm = 32, interval =     1.75 */
+	[242] = 0xc6630036, /* cps = 209152.00, nrm = 32, interval =     1.69 */
+	[243] = 0xc6a30034, /* cps = 217344.00, nrm = 32, interval =     1.62 */
+	[244] = 0xc6e70032, /* cps = 226048.00, nrm = 32, interval =     1.56 */
+	[245] = 0xc72f0030, /* cps = 235264.00, nrm = 32, interval =     1.50 */
+	[246] = 0xc77f002e, /* cps = 245504.00, nrm = 32, interval =     1.44 */
+	[247] = 0xc7d7002c, /* cps = 256768.00, nrm = 32, interval =     1.38 */
+	[248] = 0xc81b002a, /* cps = 268800.00, nrm = 32, interval =     1.31 */
+	[249] = 0xc84f0028, /* cps = 282112.00, nrm = 32, interval =     1.25 */
+	[250] = 0xc86d0027, /* cps = 289792.00, nrm = 32, interval =     1.22 */
+	[251] = 0xc8a90025, /* cps = 305152.00, nrm = 32, interval =     1.16 */
+	[252] = 0xc8cb0024, /* cps = 313856.00, nrm = 32, interval =     1.12 */
+	[253] = 0xc9130022, /* cps = 332288.00, nrm = 32, interval =     1.06 */
+	[254] = 0xc9390021, /* cps = 342016.00, nrm = 32, interval =     1.03 */
+	[255] = 0xc9630020, /* cps = 352768.00, nrm = 32, interval =     1.00 */
 };
 
 static unsigned char rate_to_log[] =
-- 
2.35.1

