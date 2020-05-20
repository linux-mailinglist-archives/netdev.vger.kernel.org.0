Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9B21DA972
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgETEtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:49:40 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:35181 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgETEtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 00:49:39 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 78fcf394;
        Wed, 20 May 2020 04:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=hkXvpL74ltu5T0WJZ7oy3mqcO
        qU=; b=LR68QJ8ORVup90uG30WqVCCoB1pcqLkmzOm8oTqIsx61249Lougg+eGwL
        XuvWx30mghMJnugNK3w4+mozibHAuZ8QULBM+9a9uLRtPnINFJRr6vBjXMCgkUsE
        coOnAZ8Zw5OiYErnsIMrPyQhUAvHea4qPPKvrVq+OlO/IHIthKAqrxvl2E2ykpn3
        yKvqKcoHRbX0d6KaIL0CShqWVaB+3Qez02S6ld01BFg1WlsUIt2W2y5GD16lhnbd
        eKkilklFnbhYJANw0G36HB1npsSxj5TDvmle0p14FCgkyEGu+z5+YjMoVKSBHET4
        qkfcX2ZsxvdHdaPqnisbfIAiUsupw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9bd331f5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 20 May 2020 04:35:10 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/4] wireguard: selftests: use newer iproute2 for gcc-10
Date:   Tue, 19 May 2020 22:49:27 -0600
Message-Id: <20200520044930.8131-2-Jason@zx2c4.com>
In-Reply-To: <20200520044930.8131-1-Jason@zx2c4.com>
References: <20200520044930.8131-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 switched to defaulting to -fno-common, which broke iproute2-5.4.
This was fixed in iproute-5.6, so switch to that. Because we're after a
stable testing surface, we generally don't like to bump these
unnecessarily, but in this case, being able to actually build is a basic
necessity.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index 90598a425c18..4bdd6c1a19d3 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -44,7 +44,7 @@ endef
 $(eval $(call tar_download,MUSL,musl,1.2.0,.tar.gz,https://musl.libc.org/releases/,c6de7b191139142d3f9a7b5b702c9cae1b5ee6e7f57e582da9328629408fd4e8))
 $(eval $(call tar_download,IPERF,iperf,3.7,.tar.gz,https://downloads.es.net/pub/iperf/,d846040224317caf2f75c843d309a950a7db23f9b44b94688ccbe557d6d1710c))
 $(eval $(call tar_download,BASH,bash,5.0,.tar.gz,https://ftp.gnu.org/gnu/bash/,b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d))
-$(eval $(call tar_download,IPROUTE2,iproute2,5.4.0,.tar.xz,https://www.kernel.org/pub/linux/utils/net/iproute2/,fe97aa60a0d4c5ac830be18937e18dc3400ca713a33a89ad896ff1e3d46086ae))
+$(eval $(call tar_download,IPROUTE2,iproute2,5.6.0,.tar.xz,https://www.kernel.org/pub/linux/utils/net/iproute2/,1b5b0e25ce6e23da7526ea1da044e814ad85ba761b10dd29c2b027c056b04692))
 $(eval $(call tar_download,IPTABLES,iptables,1.8.4,.tar.bz2,https://www.netfilter.org/projects/iptables/files/,993a3a5490a544c2cbf2ef15cf7e7ed21af1845baf228318d5c36ef8827e157c))
 $(eval $(call tar_download,NMAP,nmap,7.80,.tar.bz2,https://nmap.org/dist/,fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa))
 $(eval $(call tar_download,IPUTILS,iputils,s20190709,.tar.gz,https://github.com/iputils/iputils/archive/s20190709.tar.gz/#,a15720dd741d7538dd2645f9f516d193636ae4300ff7dbc8bfca757bf166490a))
-- 
2.26.2

