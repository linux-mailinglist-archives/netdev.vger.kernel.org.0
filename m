Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A0052F3E0
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353285AbiETTn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353271AbiETTnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D9C197F72;
        Fri, 20 May 2022 12:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0480E61B9A;
        Fri, 20 May 2022 19:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37773C385A9;
        Fri, 20 May 2022 19:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653075804;
        bh=1aWCekTYLSep+8QoVLJjwGC5EBl50xK3Dn20ava89z8=;
        h=From:To:Cc:Subject:Date:From;
        b=FtaUZ02++i0J6Or24hDlOCMt181BVVFUE/oVsANbqLaCSwnJUKeSfSo5Xbfu1iHGg
         3D7+iN64b4ujOOxMX/x58jvV6hlNHbQJL5FXlFTfusqPBnSWquyVOJL+KvaHJmX40J
         apQ3Qa2fsmOecW6BW1akcWlYtKHJd2RTZicaCyD8ndncikIV/k/IdC2SLMq9D9G/vc
         0bj3xvlAkkEeXpaaDY3H32hfBXDXNebCnAC9WmK6HpfP/CyizFag1DeL5QByCY87qo
         s9OnSYlJF1wg+9nciGS1useWWK7DmilP26mXNgJVA0lpH7zM1+RDW8lJ5JpsjDgMOG
         HGVjGVNiOAULA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/8] Fix/silence GCC 12 warnings in drivers/net/wireless/
Date:   Fri, 20 May 2022 12:43:12 -0700
Message-Id: <20220520194320.2356236-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle & Johannes,

as mentioned off list we'd like to get GCC 12 warnings quashed.
This set takes care of the warnings we have in drivers/net/wireless/
mostly by relegating them to W=1/W=2 builds.

Is it okay for us to take this directly to net-next?
Or perhaps via wireless-next with a quick PR by Monday?

Jakub Kicinski (8):
  wifi: plfxlc: remove redundant NULL-check for GCC 12
  wifi: ath9k: silence array-bounds warning on GCC 12
  wifi: rtlwifi: remove always-true condition pointed out by GCC 12
  wifi: ath6k: silence false positive -Wno-dangling-pointer warning on
    GCC 12
  wifi: iwlwifi: use unsigned to silence a GCC 12 warning
  wifi: brcmfmac: work around a GCC 12 -Warray-bounds warning
  wifi: libertas: silence a GCC 12 -Warray-bounds warning
  wifi: carl9170: silence a GCC 12 -Warray-bounds warning

 drivers/net/wireless/ath/ath6kl/Makefile                    | 5 +++++
 drivers/net/wireless/ath/ath9k/Makefile                     | 5 +++++
 drivers/net/wireless/ath/carl9170/Makefile                  | 5 +++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                | 2 +-
 drivers/net/wireless/marvell/libertas/Makefile              | 5 +++++
 drivers/net/wireless/purelifi/plfxlc/usb.c                  | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c        | 5 +----
 8 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.34.3

