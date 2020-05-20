Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C531DB804
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgETPWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:22:00 -0400
Received: from novek.ru ([213.148.174.62]:60482 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbgETPV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:21:57 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 39D4150297F;
        Wed, 20 May 2020 18:21:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 39D4150297F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589988113; bh=VtUyf6hsuINjN+T0FznwgIS6kg1fzlFz9pd2k+X/wk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zY3poZ5BD0Y7aTberAfGydUscLwg2CCVTBbBimk6nUut8Se3B93qzjpyF1lCfIFpN
         HKzcr+AJOx1BCk8pf1xAXDwbxutb3okAKiUhNCp/7B6F+UDKcf1HmVO6gVXXtTgpe8
         gOtieAlud9idpuGpw82KKbmcq1duSIXl5DGc9tqI=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net-next v2 5/5] mpls: Add support for IPv6 tunnels
Date:   Wed, 20 May 2020 18:21:39 +0300
Message-Id: <1589988099-13095-6-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
References: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=1.7 required=5.0 tests=UNPARSEABLE_RELAY,URIBL_BLACK
        autolearn=no autolearn_force=no version=3.4.1
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for IPv6 tunnel devices in AF_MPLS.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/mpls/af_mpls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index a42e4ed..fd30ea6 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1593,7 +1593,8 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		    dev->type == ARPHRD_IPGRE ||
 		    dev->type == ARPHRD_IP6GRE ||
 		    dev->type == ARPHRD_SIT ||
-		    dev->type == ARPHRD_TUNNEL) {
+		    dev->type == ARPHRD_TUNNEL ||
+		    dev->type == ARPHRD_TUNNEL6) {
 			mdev = mpls_add_dev(dev);
 			if (IS_ERR(mdev))
 				return notifier_from_errno(PTR_ERR(mdev));
-- 
1.8.3.1

