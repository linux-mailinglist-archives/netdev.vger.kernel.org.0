Return-Path: <netdev+bounces-2407-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1775701C2C
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 09:47:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28067281776
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 07:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDE01C33;
	Sun, 14 May 2023 07:47:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7BD1C30
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 07:47:48 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14191FDE
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 00:47:43 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1aaf706768cso88251985ad.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 00:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1684050463; x=1686642463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=psVi+uu7gPRH/n0OWz4yeAMRQ5ZWsimFDEGiHD2LvJ8=;
        b=AWe4i2zm1twY3RzeclNA2KPZeLsVWmdvGhmCNhP/v3rJcaUQfX6BVh8bK9hUZNK6tZ
         LSsur3BEk57P2fPhgbvkp7++cjUrCUY4BH2LgWSRS+DDBD2oTRvuaYOouCfLb8yVkzvD
         8IKT89FT0EI1MRY6pK9gPBQ4QImGr87/+vgsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684050463; x=1686642463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=psVi+uu7gPRH/n0OWz4yeAMRQ5ZWsimFDEGiHD2LvJ8=;
        b=cmKy8IZKsQRYSNxGi8p8+ckBGGcmV3moklRPzwA+afsTPuUb5OFHd+mg0cfHJLSHZj
         /MwtHrkLzPDz2IzTJ5bLpZC2wAjhX4K9irkIEclcNJMTjlGAwXpdNATuo0ucJUtoKaQn
         lljVybCMWVvQq1prmfstaqxp4Jv78824gJzBfQ732H+yI3AJBgUUC8AUAtbFAXbqWNB/
         PdcpM25St4wvJbrgdAQO9oc1jq38vkZMbRc7rAMlPKj5JjbHViTIR7MuhzH+LgZl+xLr
         iPMnbJhkI5TPGW0+xTCHXXGGDDi+aoFGb03X81cquPV9kT2WaICdnHGd1sAuaQv3EtXO
         nMWQ==
X-Gm-Message-State: AC+VfDz17bFOaCs+CZRr5SV3tX8EA/skgK5dVbaQDSvg/VCAvmw+8/4y
	zWmjfVCVlgE87EnAdGiiAhqwqMzUQgj/fH2hYfXIPbKs
X-Google-Smtp-Source: ACHHUZ4sU9ia39wRPGImmuBohUL/goFz3e8Wrk/4kGZN2jmxqB16YV/nrkvMbJ9ZwHM67Dcx/yR0ig==
X-Received: by 2002:a17:903:1110:b0:1ab:74c:bdf2 with SMTP id n16-20020a170903111000b001ab074cbdf2mr41326845plh.28.1684050463081;
        Sun, 14 May 2023 00:47:43 -0700 (PDT)
Received: from 8add390ca20e.heitbaum.com ([122.199.31.3])
        by smtp.googlemail.com with ESMTPSA id j4-20020a17090276c400b00194caf3e975sm10903363plt.208.2023.05.14.00.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 00:47:42 -0700 (PDT)
From: Rudi Heitbaum <rudi@heitbaum.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	anarsoul@gmail.com,
	alistair@alistair23.me
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-bluetooth@vger.kernel.org,
	Rudi Heitbaum <rudi@heitbaum.com>
Subject: [PATCH 0/3] Bluetooth: btrtl: Add support for RTL8822BS
Date: Sun, 14 May 2023 07:47:28 +0000
Message-Id: <20230514074731.70614-1-rudi@heitbaum.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

With the recent support of the RTL8822BS SDIO WiFi and the 
BROKEN_LOCAL_EXT_FEATURES_PAGE_2 quirk complete the enablement by 
adding Bluetooth support on the RTL8822BS UART with hci_ver = 0x07.

The RTL8822BS requires the BROKEN_LOCAL_EXT_FEATURES_PAGE_2 quirk.

Test results:

[   10.029959] Bluetooth: hci0: RTL: examining hci_ver=07 hci_rev=000b lmp_ver=07 lmp_subver=8822
[   10.047194] Bluetooth: hci0: RTL: rom_version status=0 version=2
[   10.047250] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822bs_fw.bin
[   10.114730] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822bs_config.bin
[   10.237433] Bluetooth: hci0: RTL: cfg_sz 75, total sz 24543
[   11.244540] Bluetooth: hci0: RTL: fw version 0xaa89f793
[   11.279285] Bluetooth: hci0: broken local ext features page 2

Rudi Heitbaum (3):
  dt-bindings: net: realtek-bluetooth: Add RTL8822BS
  Bluetooth: btrtl: Add support for RTL8822BS UART
  arm64: dts: allwinner: h6: tanix-tx6: Add compatible bluetooth

 .../devicetree/bindings/net/realtek-bluetooth.yaml  | 13 ++++++++-----
 .../boot/dts/allwinner/sun50i-h6-tanix-tx6.dts      |  2 +-
 drivers/bluetooth/btrtl.c                           | 12 +++++++++++-
 drivers/bluetooth/hci_h5.c                          |  6 ++++++
 4 files changed, 26 insertions(+), 7 deletions(-)


base-commit: bb7c241fae6228e89c0286ffd6f249b3b0dea225
-- 
2.25.1


