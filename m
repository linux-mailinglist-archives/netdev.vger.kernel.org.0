Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F4535C615
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbhDLMV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:21:26 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:50834 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238720AbhDLMVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 08:21:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=4+hOEbabYeWB61G/f7BMXIZpqriitfA8fo4sgdlsFRA=;
        b=aVWie3uFpfjJE182ykHUWaR/yANcpgBVnqL/ximYM/kifvOY3ZKGFrknHu8yhYmN988lxbY3kP38G
         hXJ1tCfBSad/HR/s0lHd+yyTxxcAzeXCx8Z04t3o2zudowCXEPpO88+yPlOo/Ty+647RanuNG/vnZ6
         NHcWtXMhyaLibApvkSFytQiXRZb17ybkm4rphJO0NxhDYa30OCY1OUsmuuQR/J+s8UH1RzcGzyx2Dm
         wHaRmilJrqbGuxzSRDh6tBfa4gO13a8y60JR+lqo0oFRXH6jWwsfMpOZrytfVkHRp2g8JiDWY7VYZG
         YKa/Wn6qjtx2M0icHspYZsSLTmp0nLg==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW, TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([178.70.223.189])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 12 Apr 2021 15:20:50 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: phy: marvell-88x2222: a couple of improvements
Date:   Mon, 12 Apr 2021 15:16:58 +0300
Message-Id: <cover.1618227910.git.i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First, there are some SFP modules that only uses RX_LOS for link
indication. Add check that SFP link is operational before actual read of
link status.

Second, it is invalid to set 10G speed without autonegotiation,
according to phy_ethtool_ksettings_set(). Implement switching between
10GBase-R and 1000Base-X/SGMII if autonegotiation can't complete but
there is signal in line.

Ivan Bornyakov (2):
  net: phy: marvell-88x2222: check that link is operational
  net: phy: marvell-88x2222: swap 1G/10G modes on autoneg

 drivers/net/phy/marvell-88x2222.c | 296 +++++++++++++++++++-----------
 1 file changed, 191 insertions(+), 105 deletions(-)

-- 
2.26.3


