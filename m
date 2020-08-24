Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B80B24FF2F
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgHXNcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgHXNcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 09:32:10 -0400
Received: from e123331-lin.arnhem.chello.nl (dhcp-077-251-017-237.chello.nl [77.251.17.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4B402063A;
        Mon, 24 Aug 2020 13:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598275902;
        bh=Bx4FY5JhoZLx8KTEBPX2ul2KmzV8P0l5/pk4TdwHBvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swpOUBQnwXfVSpgfjf783AtC+blFLcQCEv5H4023XLHcv12KYayIRZ2YnMNCYG2hP
         2fSWvj4rn7FSIFY2gNBQ8b+BudKMKCWkWuEujwPxtEk7P2jIMPCi51ghsY//oNEOeR
         kySgKzMa9OtjZsRQVY56gZwNNa+G6Kgu52Z89cNw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-nfs@vger.kernel.org
Subject: [PATCH v2 6/7] net: wireless: drop bogus CRYPTO_xxx Kconfig selects
Date:   Mon, 24 Aug 2020 15:30:00 +0200
Message-Id: <20200824133001.9546-7-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200824133001.9546-1-ardb@kernel.org>
References: <20200824133001.9546-1-ardb@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop some bogus Kconfig selects that are not entirely accurate, and
unnecessary to begin with, since the same Kconfig options also select
LIB80211 features that already imply the selected functionality (AES
for CCMP, ARC4 and ECB for TKIP)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/Kconfig   | 4 ----
 drivers/net/wireless/intersil/hostap/Kconfig | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/Kconfig b/drivers/net/wireless/intel/ipw2x00/Kconfig
index b1e7b4470842..1650d5865aa0 100644
--- a/drivers/net/wireless/intel/ipw2x00/Kconfig
+++ b/drivers/net/wireless/intel/ipw2x00/Kconfig
@@ -160,11 +160,7 @@ config LIBIPW
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select CRYPTO
-	select CRYPTO_ARC4
-	select CRYPTO_ECB
-	select CRYPTO_AES
 	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
 	select CRC32
 	select LIB80211
 	select LIB80211_CRYPT_WEP
diff --git a/drivers/net/wireless/intersil/hostap/Kconfig b/drivers/net/wireless/intersil/hostap/Kconfig
index 6ad88299432f..c865d3156cea 100644
--- a/drivers/net/wireless/intersil/hostap/Kconfig
+++ b/drivers/net/wireless/intersil/hostap/Kconfig
@@ -5,11 +5,7 @@ config HOSTAP
 	select WEXT_SPY
 	select WEXT_PRIV
 	select CRYPTO
-	select CRYPTO_ARC4
-	select CRYPTO_ECB
-	select CRYPTO_AES
 	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
 	select CRC32
 	select LIB80211
 	select LIB80211_CRYPT_WEP
-- 
2.17.1

