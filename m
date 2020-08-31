Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88652257C1A
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgHaPRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbgHaPR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 11:17:28 -0400
Received: from e123331-lin.nice.arm.com (adsl-83.46.190.3.tellas.gr [46.190.3.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB8820936;
        Mon, 31 Aug 2020 15:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887047;
        bh=Bx4FY5JhoZLx8KTEBPX2ul2KmzV8P0l5/pk4TdwHBvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ih+SPsCqEZGA06ELihAMJMFtC7u0A9h/P0hOe51EM8fHn5n93MVE6ibNgYXGHr/gV
         J2p1LzaRGUa09AJukZtPVw3OQf59s7cWH6OBMQM6vjpTT/S2epOWUoiQYTwE8GpSl0
         H8NqMHkuMaiA7sSZILkYjk2sJLEpNv9xuPCglSvs=
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
Subject: [PATCH v3 6/7] net: wireless: drop bogus CRYPTO_xxx Kconfig selects
Date:   Mon, 31 Aug 2020 18:16:48 +0300
Message-Id: <20200831151649.21969-7-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831151649.21969-1-ardb@kernel.org>
References: <20200831151649.21969-1-ardb@kernel.org>
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

