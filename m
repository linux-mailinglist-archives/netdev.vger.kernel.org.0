Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA4D3B2B86
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhFXJkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhFXJkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 05:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F8C2613F6;
        Thu, 24 Jun 2021 09:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624527513;
        bh=5c9iEJtFg05vZbIa6X3+fJDiKXt9Ahs7D5rK8zLZuQw=;
        h=From:To:Cc:Subject:Date:From;
        b=YtUqoCEqFFWlGJvDjh5WcX4Awl8QQHSJ61OMvqBuJd5tSxgWZZT2oiz6FYB2536E/
         7dDlyOZn1Q6JAxCn7k75dPimkv8iVkrDRWTk6U/Uha3cufHRarJKD8Ka4ow2Kof10N
         EZi+Wx86AX8dT31sU+DJ4cTFOg/KwMBJe37LnNPFuAp6h6Nf/d4w4ucuWxf6phlbq6
         7O0z8jdzT7lwceXp8yGGfck3J948274fJPY/N9sdEHc++6+91lT/ZigAhrMbrMsVLt
         HjLIgqJskSdgNO7/hffg9IePmgL+pztVKoGYO/Mu/GtbltVDf9GAtELUHM4QN2syT8
         s/IJgSOHdUNYg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, sd@queasysnail.net,
        andrew@lunn.ch, hkallweit1@gmail.com, irusskikh@marvell.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net 0/3] net: macsec: fix key length when offloading
Date:   Thu, 24 Jun 2021 11:38:27 +0200
Message-Id: <20210624093830.943139-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The key length used to copy the key to offloading drivers and to store
it is wrong and was working by chance as it matched the default key
length. But using a different key length fails. Fix it by using instead
the max length accepted in uAPI to store the key and the actual key
length when copying it.

This was tested on the MSCC PHY driver but not on the Atlantic MAC
(looking at the code it looks ok, but testing would be appreciated).

Thanks,
Antoine

Antoine Tenart (3):
  net: macsec: fix the length used to copy the key for offloading
  net: phy: mscc: fix macsec key length
  net: atlantic: fix the macsec key length

 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h | 4 ++--
 drivers/net/macsec.c                               | 4 ++--
 drivers/net/phy/mscc/mscc_macsec.c                 | 2 +-
 drivers/net/phy/mscc/mscc_macsec.h                 | 2 +-
 include/net/macsec.h                               | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.31.1

