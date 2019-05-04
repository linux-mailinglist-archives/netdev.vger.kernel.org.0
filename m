Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C283913ACE
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 16:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfEDO56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 10:57:58 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33177 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfEDO56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 10:57:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id e28so11498970wra.0
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 07:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/AjXO7Fx2OQegMOwFq3OpYIkehScA2rXKoNeNCC5ayE=;
        b=XgMx8RaYA4JkuahZvgWZ7KfEajY5Fn3VDxV4hVJoY+cnPjrE9yZYZdvfa+10Js+j8G
         4L+Yii2ISk+aAsY3s0WBcXPwMX6wB6+bK8UQgyFTjraRa1z0gP48BfUSMpDtrPTow31i
         BiEXdVKot82RRYbl62aAXmgppEWL384c4sLRWFTgQGvtKkT2ZNn1sEIElrfn2SP1ax6R
         6iAwaZ8bJavxXj+eGvm1gkPzJx2OJgr1n/jhljDjswEEl5vWFchuuwFTHC3r0NTi8vV9
         9cNnk3/7ikEKU1t+8gM0rtO+mlArqXXS9qiWghQKWk2jabMxXY3ijaiJgSJ9/SMFOmFq
         S1Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/AjXO7Fx2OQegMOwFq3OpYIkehScA2rXKoNeNCC5ayE=;
        b=Xd2yVmMoydBXZFzEFepZ3FQQgUiw3egxZVaXppsTccBzwTPw0MR/O8t2kcG3mw/AdQ
         mCo96zVMoSsm5M/9PPwY/3pk8DfzKOn6Hh9FkTZjByy9xW1ZaqzBKU3qryKEZdU2PL9C
         Y6qKQaxwyZBdVhCxxv/fmi7MzdniuWLsjn4YimOXbpM1gqsj3HeC4JQ+GsldYKrap/OT
         ilqck152A+ZNIG++LHzPPVTZblxsqnLzNJxUnRYOvxJrdYYMZE6gShM5bAo0PbzhH+ov
         T7Q2OGdaOXJXtgWulVnEchBQk/EQqVFp3aYuv23GvIZtw0vygaHng2tp6ltllDMqoGUd
         YdzA==
X-Gm-Message-State: APjAAAWAD61Y/QP1xxMxI5gbFp6icndoSlLunyLJUonLAwg2MVj2K4pD
        /e6HS19fOtyDsea/fIpA6x8bwd/vgHk=
X-Google-Smtp-Source: APXvYqwYgt5ex4riujkeSv1l/2Z7zlqf8754y5eZqZyOADWwtXCvm7XLwsP6+8sXz+z+QdFiR3Qotg==
X-Received: by 2002:a5d:4a4f:: with SMTP id v15mr10850889wrs.5.1556981875246;
        Sat, 04 May 2019 07:57:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:4cd8:8005:fc98:c429? (p200300EA8BD457004CD88005FC98C429.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:4cd8:8005:fc98:c429])
        by smtp.googlemail.com with ESMTPSA id v9sm9172634wrg.20.2019.05.04.07.57.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 07:57:53 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: simplify rtl_writephy_batch and rtl_ephy_init
Message-ID: <2ffb7419-03d5-5d5a-44e6-6b070fd5c2bb@gmail.com>
Date:   Sat, 4 May 2019 16:57:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make both functions macros to allow omitting the ARRAY_SIZE(x) argument.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 100 ++++++++++++++-------------
 1 file changed, 52 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 8c41b74ce..c1128cff4 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2280,8 +2280,8 @@ struct phy_reg {
 	u16 val;
 };
 
-static void rtl_writephy_batch(struct rtl8169_private *tp,
-			       const struct phy_reg *regs, int len)
+static void __rtl_writephy_batch(struct rtl8169_private *tp,
+				 const struct phy_reg *regs, int len)
 {
 	while (len-- > 0) {
 		rtl_writephy(tp, regs->reg, regs->val);
@@ -2289,6 +2289,8 @@ static void rtl_writephy_batch(struct rtl8169_private *tp,
 	}
 }
 
+#define rtl_writephy_batch(tp, a) __rtl_writephy_batch(tp, a, ARRAY_SIZE(a))
+
 #define PHY_READ		0x00000000
 #define PHY_DATA_OR		0x10000000
 #define PHY_DATA_AND		0x20000000
@@ -2640,7 +2642,7 @@ static void rtl8169s_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x00, 0x9200 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8169sb_hw_phy_config(struct rtl8169_private *tp)
@@ -2651,7 +2653,7 @@ static void rtl8169sb_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8169scd_hw_phy_config_quirk(struct rtl8169_private *tp)
@@ -2709,7 +2711,7 @@ static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 
 	rtl8169scd_hw_phy_config_quirk(tp);
 }
@@ -2764,7 +2766,7 @@ static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp)
@@ -2777,7 +2779,7 @@ static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0001);
 	rtl_patchphy(tp, 0x16, 1 << 0);
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8168bef_hw_phy_config(struct rtl8169_private *tp)
@@ -2788,7 +2790,7 @@ static void rtl8168bef_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8168cp_1_hw_phy_config(struct rtl8169_private *tp)
@@ -2801,7 +2803,7 @@ static void rtl8168cp_1_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8168cp_2_hw_phy_config(struct rtl8169_private *tp)
@@ -2816,7 +2818,7 @@ static void rtl8168cp_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_patchphy(tp, 0x14, 1 << 5);
 	rtl_patchphy(tp, 0x0d, 1 << 5);
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp)
@@ -2841,7 +2843,7 @@ static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x09, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 
 	rtl_patchphy(tp, 0x14, 1 << 5);
 	rtl_patchphy(tp, 0x0d, 1 << 5);
@@ -2868,7 +2870,7 @@ static void rtl8168c_2_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 
 	rtl_patchphy(tp, 0x16, 1 << 0);
 	rtl_patchphy(tp, 0x14, 1 << 5);
@@ -2890,7 +2892,7 @@ static void rtl8168c_3_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 
 	rtl_patchphy(tp, 0x16, 1 << 0);
 	rtl_patchphy(tp, 0x14, 1 << 5);
@@ -2946,7 +2948,7 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x0d, 0xf880 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init_0, ARRAY_SIZE(phy_reg_init_0));
+	rtl_writephy_batch(tp, phy_reg_init_0);
 
 	/*
 	 * Rx Error Issue
@@ -2967,7 +2969,7 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 		};
 		int val;
 
-		rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+		rtl_writephy_batch(tp, phy_reg_init);
 
 		val = rtl_readphy(tp, 0x0d);
 
@@ -2993,7 +2995,7 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 			{ 0x06, 0x6662 }
 		};
 
-		rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+		rtl_writephy_batch(tp, phy_reg_init);
 	}
 
 	/* RSET couple improve */
@@ -3057,7 +3059,7 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x0d, 0xf880 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init_0, ARRAY_SIZE(phy_reg_init_0));
+	rtl_writephy_batch(tp, phy_reg_init_0);
 
 	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
 		static const struct phy_reg phy_reg_init[] = {
@@ -3071,7 +3073,7 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
 		};
 		int val;
 
-		rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+		rtl_writephy_batch(tp, phy_reg_init);
 
 		val = rtl_readphy(tp, 0x0d);
 		if ((val & 0x00ff) != 0x006c) {
@@ -3096,7 +3098,7 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
 			{ 0x06, 0x2642 }
 		};
 
-		rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+		rtl_writephy_batch(tp, phy_reg_init);
 	}
 
 	/* Fine tune PLL performance */
@@ -3174,7 +3176,7 @@ static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp)
@@ -3189,7 +3191,7 @@ static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 	rtl_patchphy(tp, 0x0d, 1 << 5);
 }
 
@@ -3225,7 +3227,7 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl_apply_firmware(tp);
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 
 	/* DCO enable for 10M IDLE Power */
 	rtl_writephy(tp, 0x1f, 0x0007);
@@ -3311,7 +3313,7 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl_apply_firmware(tp);
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 
 	/* For 4-corner performance improve */
 	rtl_writephy(tp, 0x1f, 0x0005);
@@ -3420,7 +3422,7 @@ static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl_apply_firmware(tp);
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 
 	rtl8168f_hw_phy_config(tp);
 
@@ -3486,7 +3488,7 @@ static void rtl8411_hw_phy_config(struct rtl8169_private *tp)
 	rtl_w0w1_phy(tp, 0x06, 0x4000, 0x0000);
 	rtl_writephy(tp, 0x1f, 0x0000);
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 
 	/* Modify green table for giga */
 	rtl_writephy(tp, 0x1f, 0x0005);
@@ -3906,7 +3908,7 @@ static void rtl8102e_hw_phy_config(struct rtl8169_private *tp)
 	rtl_patchphy(tp, 0x19, 1 << 13);
 	rtl_patchphy(tp, 0x10, 1 << 15);
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8105e_hw_phy_config(struct rtl8169_private *tp)
@@ -3932,7 +3934,7 @@ static void rtl8105e_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl_apply_firmware(tp);
 
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 }
 
 static void rtl8402_hw_phy_config(struct rtl8169_private *tp)
@@ -3969,7 +3971,7 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp)
 	rtl_apply_firmware(tp);
 
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
-	rtl_writephy_batch(tp, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+	rtl_writephy_batch(tp, phy_reg_init);
 
 	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
 }
@@ -4705,8 +4707,8 @@ struct ephy_info {
 	u16 bits;
 };
 
-static void rtl_ephy_init(struct rtl8169_private *tp, const struct ephy_info *e,
-			  int len)
+static void __rtl_ephy_init(struct rtl8169_private *tp,
+			    const struct ephy_info *e, int len)
 {
 	u16 w;
 
@@ -4717,6 +4719,8 @@ static void rtl_ephy_init(struct rtl8169_private *tp, const struct ephy_info *e,
 	}
 }
 
+#define rtl_ephy_init(tp, a) __rtl_ephy_init(tp, a, ARRAY_SIZE(a))
+
 static void rtl_disable_clock_request(struct rtl8169_private *tp)
 {
 	pcie_capability_clear_word(tp->pci_dev, PCI_EXP_LNKCTL,
@@ -4797,7 +4801,7 @@ static void rtl_hw_start_8168cp_1(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_ephy_init(tp, e_info_8168cp, ARRAY_SIZE(e_info_8168cp));
+	rtl_ephy_init(tp, e_info_8168cp);
 
 	__rtl_hw_start_8168cp(tp);
 }
@@ -4845,7 +4849,7 @@ static void rtl_hw_start_8168c_1(struct rtl8169_private *tp)
 
 	RTL_W8(tp, DBG_REG, 0x06 | FIX_NAK_1 | FIX_NAK_2);
 
-	rtl_ephy_init(tp, e_info_8168c_1, ARRAY_SIZE(e_info_8168c_1));
+	rtl_ephy_init(tp, e_info_8168c_1);
 
 	__rtl_hw_start_8168cp(tp);
 }
@@ -4859,7 +4863,7 @@ static void rtl_hw_start_8168c_2(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_ephy_init(tp, e_info_8168c_2, ARRAY_SIZE(e_info_8168c_2));
+	rtl_ephy_init(tp, e_info_8168c_2);
 
 	__rtl_hw_start_8168cp(tp);
 }
@@ -4917,7 +4921,7 @@ static void rtl_hw_start_8168d_4(struct rtl8169_private *tp)
 
 	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
 
-	rtl_ephy_init(tp, e_info_8168d_4, ARRAY_SIZE(e_info_8168d_4));
+	rtl_ephy_init(tp, e_info_8168d_4);
 
 	rtl_enable_clock_request(tp);
 }
@@ -4942,7 +4946,7 @@ static void rtl_hw_start_8168e_1(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_ephy_init(tp, e_info_8168e_1, ARRAY_SIZE(e_info_8168e_1));
+	rtl_ephy_init(tp, e_info_8168e_1);
 
 	if (tp->dev->mtu <= ETH_DATA_LEN)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
@@ -4967,7 +4971,7 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_ephy_init(tp, e_info_8168e_2, ARRAY_SIZE(e_info_8168e_2));
+	rtl_ephy_init(tp, e_info_8168e_2);
 
 	if (tp->dev->mtu <= ETH_DATA_LEN)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
@@ -5038,7 +5042,7 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
 
 	rtl_hw_start_8168f(tp);
 
-	rtl_ephy_init(tp, e_info_8168f_1, ARRAY_SIZE(e_info_8168f_1));
+	rtl_ephy_init(tp, e_info_8168f_1);
 
 	rtl_w0w1_eri(tp, 0x0d4, ERIAR_MASK_0011, 0x0c00, 0xff00);
 
@@ -5058,7 +5062,7 @@ static void rtl_hw_start_8411(struct rtl8169_private *tp)
 	rtl_hw_start_8168f(tp);
 	rtl_pcie_state_l2l3_disable(tp);
 
-	rtl_ephy_init(tp, e_info_8168f_1, ARRAY_SIZE(e_info_8168f_1));
+	rtl_ephy_init(tp, e_info_8168f_1);
 
 	rtl_eri_set_bits(tp, 0x0d4, ERIAR_MASK_0011, 0x0c00);
 }
@@ -5107,7 +5111,7 @@ static void rtl_hw_start_8168g_1(struct rtl8169_private *tp)
 
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8168g_1, ARRAY_SIZE(e_info_8168g_1));
+	rtl_ephy_init(tp, e_info_8168g_1);
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
@@ -5125,7 +5129,7 @@ static void rtl_hw_start_8168g_2(struct rtl8169_private *tp)
 	/* disable aspm and clock request before access ephy */
 	RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
 	RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
-	rtl_ephy_init(tp, e_info_8168g_2, ARRAY_SIZE(e_info_8168g_2));
+	rtl_ephy_init(tp, e_info_8168g_2);
 }
 
 static void rtl_hw_start_8411_2(struct rtl8169_private *tp)
@@ -5142,7 +5146,7 @@ static void rtl_hw_start_8411_2(struct rtl8169_private *tp)
 
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8411_2, ARRAY_SIZE(e_info_8411_2));
+	rtl_ephy_init(tp, e_info_8411_2);
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
@@ -5161,7 +5165,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8168h_1, ARRAY_SIZE(e_info_8168h_1));
+	rtl_ephy_init(tp, e_info_8168h_1);
 
 	rtl_eri_write(tp, 0xc8, ERIAR_MASK_0101, 0x00080002);
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_0001, 0x38);
@@ -5291,7 +5295,7 @@ static void rtl_hw_start_8168ep_1(struct rtl8169_private *tp)
 
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8168ep_1, ARRAY_SIZE(e_info_8168ep_1));
+	rtl_ephy_init(tp, e_info_8168ep_1);
 
 	rtl_hw_start_8168ep(tp);
 
@@ -5308,7 +5312,7 @@ static void rtl_hw_start_8168ep_2(struct rtl8169_private *tp)
 
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8168ep_2, ARRAY_SIZE(e_info_8168ep_2));
+	rtl_ephy_init(tp, e_info_8168ep_2);
 
 	rtl_hw_start_8168ep(tp);
 
@@ -5330,7 +5334,7 @@ static void rtl_hw_start_8168ep_3(struct rtl8169_private *tp)
 
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8168ep_3, ARRAY_SIZE(e_info_8168ep_3));
+	rtl_ephy_init(tp, e_info_8168ep_3);
 
 	rtl_hw_start_8168ep(tp);
 
@@ -5381,7 +5385,7 @@ static void rtl_hw_start_8102e_1(struct rtl8169_private *tp)
 	if ((cfg1 & LEDS0) && (cfg1 & LEDS1))
 		RTL_W8(tp, Config1, cfg1 & ~LEDS0);
 
-	rtl_ephy_init(tp, e_info_8102e_1, ARRAY_SIZE(e_info_8102e_1));
+	rtl_ephy_init(tp, e_info_8102e_1);
 }
 
 static void rtl_hw_start_8102e_2(struct rtl8169_private *tp)
@@ -5423,7 +5427,7 @@ static void rtl_hw_start_8105e_1(struct rtl8169_private *tp)
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) | EN_NDP | EN_OOB_RESET);
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) | PFM_EN);
 
-	rtl_ephy_init(tp, e_info_8105e_1, ARRAY_SIZE(e_info_8105e_1));
+	rtl_ephy_init(tp, e_info_8105e_1);
 
 	rtl_pcie_state_l2l3_disable(tp);
 }
@@ -5448,7 +5452,7 @@ static void rtl_hw_start_8402(struct rtl8169_private *tp)
 
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
 
-	rtl_ephy_init(tp, e_info_8402, ARRAY_SIZE(e_info_8402));
+	rtl_ephy_init(tp, e_info_8402);
 
 	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 
-- 
2.21.0

