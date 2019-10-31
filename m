Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBA7EBA32
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfJaXKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:10:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37243 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728397AbfJaXKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:10:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id q130so7503793wme.2
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 16:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Jz2FLqjJAioflIo85CllAOTjCXG79fY9fhoVf+iXI0Q=;
        b=aN5IST9fMPCPb+C4ZCYlQO1qdYbxc38N1/c901HaNjegjiP/nH1qzolD8/K2rWgQ1J
         U2xq2LPCNvWvPvAY05z1Uyzk7BOpe2cxjE3nIzrfURassGYM9SC+UL6/sZeCXLjRS1nQ
         zSPThbuN6fKI02U7RWNDAZOkZC2h/K/5hJOEmYAhWYEausdZpKbwCbnx6Q+jGbTuarFA
         DyL06jgu8HfEPgmGRzBd77rkO5B7NEjczaOOwmPzoonsjFiBluBv5IlCeLSIT5ob1dxs
         Np0RZ9imRwFTtdcsmobM8HrgZi0JtGhIE03cHjuX61m0AyeAuvyIEHBDdD0AWsvgc5De
         zDow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Jz2FLqjJAioflIo85CllAOTjCXG79fY9fhoVf+iXI0Q=;
        b=GtXUHk/RIkPSrlWFRPWh6c1Aau6hu6Z5tPKAwEEWnhXvhSX1amjaRLBSf+Mo3KTSvk
         yXjtjhcTs4aWlXEFlk6/+Pakim4t2Vc5DdwB6L6aluk5IkmBLofgZBPKlm1ExHoFeAMT
         +me9eae5dzgZQz5i8UJOCOuvArrhfAo9jG7fWurFzlg9B6NGFXi9uxc8grYc2L4PfFl4
         drHP9G2+JJQTDwkI/1FC7rl/iKB4L2p3V3CVPmxBI/aegpT6dlfZ9LOgsXaYNPkgwtDU
         YQAERvo1MhXegXgvS2Ez1lp/kvDT1awVv3XRY+nuipzo/vb044M2xP9OcP57P2V/ul/D
         kaJw==
X-Gm-Message-State: APjAAAV90BpG6cbZw6gg+ehNUAH7Sm0Z+Nc77pQbwQkfqWOieU+nqZzM
        OY1j1ytUfuFieYs5itCUyAmsaf5E
X-Google-Smtp-Source: APXvYqxzreiZEgNhIUaJv0knFSqofq4OvDERreCUVpPXv5j9UmQMZp4NklQsid1kS5uOGjN+BbKeEQ==
X-Received: by 2002:a1c:411:: with SMTP id 17mr6949002wme.122.1572563432153;
        Thu, 31 Oct 2019 16:10:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:4c1e:b491:a372:58c6? (p200300EA8F176E004C1EB491A37258C6.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:4c1e:b491:a372:58c6])
        by smtp.googlemail.com with ESMTPSA id 11sm4982456wmg.36.2019.10.31.16.10.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 16:10:31 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix wrong PHY ID issue with RTL8168dp
Message-ID: <651a11c7-005b-3b62-61a2-496e91048b9d@gmail.com>
Date:   Fri, 1 Nov 2019 00:10:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported in [0] at least one RTL8168dp version has problems
establishing a link. This chip version has an integrated RTL8211b PHY,
however the chip seems to report a wrong PHY ID, resulting in a wrong
PHY driver (for Generic Realtek PHY) being loaded.
Work around this issue by adding a hook to r8168dp_2_mdio_read()
for returning the correct PHY ID.

[0] https://bbs.archlinux.org/viewtopic.php?id=246508

Fixes: 242cd9b5866a ("r8169: use phy_resume/phy_suspend")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
On kernel 4.19 the patch will not apply because source file
was renamed later from r8169.c to r8169_main.c.
Changing name of file to be patched should be sufficient.
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dfd92f61e..0704f8bd1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1023,6 +1023,10 @@ static int r8168dp_2_mdio_read(struct rtl8169_private *tp, int reg)
 {
 	int value;
 
+	/* Work around issue with chip reporting wrong PHY ID */
+	if (reg == MII_PHYSID2)
+		return 0xc912;
+
 	r8168dp_2_mdio_start(tp);
 
 	value = r8169_mdio_read(tp, reg);
-- 
2.23.0

