Return-Path: <netdev+bounces-7767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6AEB721729
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A8D61C20A24
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2018BF9;
	Sun,  4 Jun 2023 13:01:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812F333F2
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 13:01:33 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2827691
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 06:01:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96fbe7fbdd4so591777066b.3
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 06:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685883689; x=1688475689;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GFX34GYvM5XCGzaLE6FHEPGkDIZX1JX722UfYhXWDvI=;
        b=UdakUdBrFGcpBargUxhE1kW04a6yopyYNCAqS9Bm3d3SZu4vsANkG/MOlubGUDgI0V
         uU/VZrYlikEma2J90k0SathcSBCBpD7Xb4x6NCmz4IQ5lAU+8TIJmNxoqHFzbeXZnTys
         yP5QTXEbaps6HJS+I0asiXyZ/lblyp4/BRnOWPUyu7zxjpbVe13wek3bZq9ySICb4g4m
         X8RrP44ko4iFGH1vY+F6kh6T5lYDVKQVWKKDTS1yN3QhF2I55iFSv7SQjroQx+mIiyQT
         h2lTeoXkavMh8k+KoeQEkYsCKDmSeSYDejq0rOWFKiHXhJBwCPHhvEuGO5wq7hnCN4YR
         2pNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685883689; x=1688475689;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GFX34GYvM5XCGzaLE6FHEPGkDIZX1JX722UfYhXWDvI=;
        b=crJr255QLOVIR8j336LRQkSt3axK6sWQWHWvcaaUiX2xgGqJjk51gV2w2URpcG8SNX
         Yq8jB8bpKnW5GL0juj6BhGEgcmYPgBxHfKZJxpt9wSDgNrh4wlxb+UGMirxTet6+KOnB
         ban9QH9N9MSyjmy+R/qgcCsdGqGMd+/vu9Zv+TTeO6dftM5ihVtLtEAgxvy5OeEFG9tK
         F5SqqqVymDcqyrwHpZE4Y5CFrmFV5DXro/m7Cfh+MnpXsqAjtQSOr6vUMwUedfrhYKRn
         xzPW2RPXOzMPPz9bcXieE9FXTbzZ1xy0jJ7nTRM0c4uDYwV4l0vzC8YayW2KbrNtDXQ+
         wm/Q==
X-Gm-Message-State: AC+VfDwi2Vx4utuZGWf6PKjlqat0PF9OSFOjaz5yWHJlxlHk+Dfnn7Wt
	IiqMYpa5Hz+Qbv8IpLWis3o=
X-Google-Smtp-Source: ACHHUZ4oGAaW8fm/0XrGVC2bjJ+NLRL4kalj6ccSetfXAM9AkPc5fDDRnT2F20kohhOvy3fqsVFyyg==
X-Received: by 2002:a17:907:6ea1:b0:965:6199:cf60 with SMTP id sh33-20020a1709076ea100b009656199cf60mr5108312ejc.42.1685883689313;
        Sun, 04 Jun 2023 06:01:29 -0700 (PDT)
Received: from shift.daheim (p4fd09d7d.dip0.t-ipconnect.de. [79.208.157.125])
        by smtp.gmail.com with ESMTPSA id t15-20020a1709066bcf00b0096f7500502csm3059015ejs.199.2023.06.04.06.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 06:01:28 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.96)
	(envelope-from <chunkeey@gmail.com>)
	id 1q5nMO-001JXN-04;
	Sun, 04 Jun 2023 15:01:28 +0200
Message-ID: <802305c6-10b6-27e6-d154-83ee0abe3aeb@gmail.com>
Date: Sun, 4 Jun 2023 15:01:27 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1] net: dsa: realtek: rtl8365mb: add missing case for
 digital interface 0
Content-Language: de-DE, en-US
To: =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "luizluca@gmail.com" <luizluca@gmail.com>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "andrew@lunn.ch" <andrew@lunn.ch>, "olteanv@gmail.com" <olteanv@gmail.com>,
 "f.fainelli@gmail.com" <f.fainelli@gmail.com>
References: <40df61cc5bebe94e4d7d32f79776be0c12a37d61.1685746295.git.chunkeey@gmail.com>
 <xh2nnmdasqngkycxqvpplxzwu5cqjnjsxp2ssosaholo5iexti@7lzdftu6dmyi>
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <xh2nnmdasqngkycxqvpplxzwu5cqjnjsxp2ssosaholo5iexti@7lzdftu6dmyi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/4/23 13:13, Alvin Šipraga wrote:
> On Sat, Jun 03, 2023 at 12:53:48AM +0200, Christian Lamparter wrote:
>> when bringing up the switch on a Netgear WNDAP660, I observed that
>> no traffic got passed from the RTL8363 to the ethernet interface...
> 
> Could you share the chip ID/version you read out from this RTL8363SB? I haven't
> seen this part number but maybe it's equivalent to some other known switch.

Sure Chip ID is 0x6000 and Chip Version is 0x1000. The label on the physical chip itself:

RTL8363SB
B8E77P2
GC17 TAIWAN

I also have a preliminary patch that just adds the switch to the
rtl8365mb_chip_info table. (The -CG came from Googling after RTL8363SB)
---
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -519,6 +519,19 @@ struct rtl8365mb_chip_info {
  /* Chip info for each supported switch in the family */
  #define PHY_INTF(_mode) (RTL8365MB_PHY_INTERFACE_MODE_ ## _mode)
  static const struct rtl8365mb_chip_info rtl8365mb_chip_infos[] = {
+	{
+		.name = "RTL8363SB-CG",
+		.chip_id = 0x6000,
+		.chip_ver = 0x1000,
+		.extints = {
+			{ 5, 0, PHY_INTF(MII) | PHY_INTF(TMII) |
+				PHY_INTF(RMII) | PHY_INTF(RGMII) },
+			{ 6, 1, PHY_INTF(MII) | PHY_INTF(TMII) |
+				PHY_INTF(RMII) | PHY_INTF(RGMII) },
+		},
+		.jam_table = rtl8365mb_init_jam_8365mb_vc,
+		.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
+	},
  	{
  		.name = "RTL8365MB-VC",
  		.chip_id = 0x6367,
---

currently, the WNDAP660 works with the out-of-tree rtl8367b.c from openwrt:
<https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/apm821xx/dts/netgear-wndap6x0.dtsi>

|         rtl8367b {
|                 compatible = "realtek,rtl8367b";
|                 cpu_port = <5>;
|                 realtek,extif0 = <1 2 1 1 1 1 1 1 2>;
|                 mii-bus = <&mdio0>;
|         };

<https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/apm821xx/dts/netgear-wndap660.dts>

>> Turns out, this was because the dropped case for
>> RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(0) that
>> got deleted by accident.
> 
> Could you show where exactly this macro is called with 0 as an argument? AFAICT
> this patch doesn't change anything, as the macro is called in only one place
> with rtl8365mb_extint::id as an argument, but these id fields are statically
> populated in rtl8365mb_chip_info and I only see values 1 or 2 there.
> 
> If you are introducing support for a new switch, why not just use a value of 1
> instead? The macro will then map to ..._REG0 as you desire.

No, Value "1" sadly does not work. Other macros like
RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extint) and
RTL8365MB_EXT_RGMXF_REG(_extint) do support "0" just as before. i.e:

<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/dsa/realtek/rtl8365mb.c#n224>
#define RTL8365MB_EXT_RGMXF_REG(_extint) \
                ((_extint) == 0 ? RTL8365MB_EXT_RGMXF_REG0 : \
                 (_extint) == 1 ? RTL8365MB_EXT_RGMXF_REG1 : \
                 (_extint) == 2 ? RTL8365MB_EXT_RGMXF_REG2 : \
                 0x0

The patch "net: dsa: realtek: rtl8365mb: rename extport to extint" mentioned
removed:

-#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extport)   \
-               (RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 + \
-                ((_extport) >> 1) * (0x13C3 - 0x1305))

and replaced it with:

+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extint) \
+               ((_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 : \
+                (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1 : \
+                0x0)

so with the old RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(0) evaluated to
(RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0+(0) (which is 0x1305) and
since the patch RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(0) evaluates to
0. So the driver writes to somewhere it shouldn't (in my RTL8363SB)
case.

so that's why I said it was "by accident" in the commit message.
Since the other macros stayed intact.

 From what I can gleam, Luiz patch mentions at the end:
"[...] and ext_id 0 does not seem to be used as well for this family."

Looking around in todays OpenWrt's various DTS. There are these devices:

extif0:
TP-Link WR2543-v1
SFR Neufbox 6 (Sercomm)
Edimax BR-6475nD
Samsung CY-SWR1100
(Netgear WNDAP660 + WNDAP620)

extif1:
Asus RT-N56U
D-Link DIR-645
TP-Link Archer C2 v1
I-O DATA WN-AC733GR3

extif2:
ZyXEL Keenetic Viva

Since this discovery, I do now have something that sort of works.
If you have a different values for extif0/export1, I sure can adapt
them no problem.

Cheers,
Christian

