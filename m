Return-Path: <netdev+bounces-4319-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A82B470C0B5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 536E5280DD8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8737E14284;
	Mon, 22 May 2023 14:09:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9F814272
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:09:23 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4288F;
	Mon, 22 May 2023 07:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684764562; x=1716300562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=K0m/oZc3q6u8X83PstBBAycwqKcivROxc9wp0fTYirM=;
  b=z+9ldSleG3cnawHpwogT0QhtyFhwkCc/IAgoKPzIPnkkBuajguIrn0Dg
   KERuhDiKm7B41u4qMo7YBWTWsE7SD5fg8YDBhWGD4FeRd73bIHDFcVK1I
   03NqvsnPn1L5WsxTkljTkN+fzHkxe/ATB/Rk0FUf62qEvJg0LGbA5kN3e
   NOEtjcShBYPG+5f+DSFJHMNwl2TRX+vWcJoLGLALPiJj7LgWgJZVtc4NE
   eo81DyNwKTQ8Z15e1jiJP/QyDC8GV0EvcY9dB09fXqGkNH5zhMNNKIjaL
   mWJvxJ8eJL6l4wlgNnG90WFvjJHyH3VHaUV9fLhT5xdV7jqve9NUSBeu8
   g==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="214927953"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 07:09:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 07:09:18 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 07:09:18 -0700
Date: Mon, 22 May 2023 16:09:17 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <arinc9.unal@gmail.com>
CC: Sean Wang <sean.wang@mediatek.com>, Landen Chao
	<Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>, Daniel Golle
	<daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli
	<f.fainelli@gmail.com>, Vladimir Oltean <olteanv@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Russell King
	<linux@armlinux.org.uk>, Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>, Frank Wunderlich
	<frank-w@public-files.de>, Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	<erkin.bozoglu@xeront.com>, <mithat.guner@xeront.com>,
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH net-next 00/30] net: dsa: mt7530: improve, trap BPDU &
 LLDP, and prefer CPU port
Message-ID: <20230522140917.er7f5ws24b2eeyvs@soft-dev3-1>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/22/2023 15:15, arinc9.unal@gmail.com wrote:

Hi,

> 
> Hello!
> 
> This patch series simplifies the code, improves the logic of the switch
> hardware support, traps LLDP frames and BPDUs for MT7530, MT7531, and
> MT7988 SoC switches, and introduces the preferring local CPU port
> operation.
> 
> There's also a patch for fixing the port capabilities of the switch on the
> MT7988 SoC.
> 

I have noticed that in many patches of the series you have:
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Where you also have:
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

I think you can drop Tested-by as the SoB will imply that. I think you
got a similar comment some time ago to a different patch series.


-- 
/Horatiu

