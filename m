Return-Path: <netdev+bounces-2657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C7B702E0D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A4AD1C20B91
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8155CC8F0;
	Mon, 15 May 2023 13:27:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770B6C8DB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:27:01 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0BA1B7;
	Mon, 15 May 2023 06:26:58 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1pyYDQ-0003Bx-34;
	Mon, 15 May 2023 13:26:18 +0000
Date: Mon, 15 May 2023 15:23:27 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Frank Wunderlich <frank-w@public-files.de>,
	Alexander Couzens <lynxis@fe80.eu>,
	Sujuan Chen <sujuan.chen@mediatek.com>,
	Bo Jiao <bo.jiao@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	MeiChia Chiu <MeiChia.Chiu@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wang Yufen <wangyufen@huawei.com>, Lorenz Brun <lorenz@brun.one>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v2 0/2] wifi: mt76: mt7915: add support for MT7981
Message-ID: <cover.1684155848.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for the MediaTek MT7981 SoC which is similar to the MT7986
but with a newer IP cores and only 2x ARM Cortex-A53 instead of 4x.
Unlike MT7986 the MT7981 can only connect a single wireless frontend,
usually MT7976 is used for DBDC.
To distinguish the MT7981 Wi-Fi MAC, add new device tree compatible
'mediatek,mt7981-wmac'.

Changes since v1:
 * rename mt7986_* to mt798x_* where appropriate
 * WARN_ON(1) if neither is_mt7981() nor is_mt7986() returns true
 * add device tree bindings for mediatek,mt7981-wmac

Alexander Couzens (1):
  wifi: mt76: mt7915: add support for MT7981

Daniel Golle (1):
  dt-bindings: net: wireless: mt76: add bindings for MT7981

 .../bindings/net/wireless/mediatek,mt76.yaml  |   1 +
 .../net/wireless/mediatek/mt76/mt76_connac.h  |  10 ++
 .../net/wireless/mediatek/mt76/mt7915/Kconfig |   6 +-
 .../wireless/mediatek/mt76/mt7915/Makefile    |   2 +-
 .../wireless/mediatek/mt76/mt7915/coredump.c  |   7 +-
 .../net/wireless/mediatek/mt76/mt7915/dma.c   |   6 +-
 .../wireless/mediatek/mt76/mt7915/eeprom.c    |   7 +-
 .../net/wireless/mediatek/mt76/mt7915/init.c  |   6 +-
 .../net/wireless/mediatek/mt76/mt7915/mac.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   |   3 +
 .../net/wireless/mediatek/mt76/mt7915/mmio.c  |  17 +-
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |  14 +-
 .../net/wireless/mediatek/mt76/mt7915/regs.h  |  13 +-
 .../net/wireless/mediatek/mt76/mt7915/soc.c   | 162 ++++++++++++------
 14 files changed, 180 insertions(+), 76 deletions(-)


base-commit: 0d9b41daa5907756a31772d8af8ac5ff25cf17c1
-- 
2.40.1


