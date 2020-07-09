Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF7A21958B
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 03:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgGIBSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 21:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbgGIBSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 21:18:46 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C54862078C;
        Thu,  9 Jul 2020 01:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594257526;
        bh=lyId8jenA3z6Pk9evXswpES4N7zDYyMYTV8XMm8afpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncyF4+VMZO/Lh35I7hXav/dHfjmRdXj7yJpDu3cjvSuDnZT89Z6P5OFTA0J1VKpdX
         V2rewymx72gmHumJ3ax4M/5aUne6nzykJT9fOd1gh7castn+B/CDH+SOy/str/CzBw
         rrf5z7FLoyjTcMtt1mpPgHgQhXXIQuCoWAppCffI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 02/10] udp_tunnel: re-number the offload tunnel types
Date:   Wed,  8 Jul 2020 18:18:06 -0700
Message-Id: <20200709011814.4003186-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709011814.4003186-1-kuba@kernel.org>
References: <20200709011814.4003186-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to use tunnel types as flags more easily.
There doesn't appear to be any user using the type as an
array index, so this should make no difference.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/udp_tunnel.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index e7312ceb2794..0615e25f041c 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -106,9 +106,9 @@ void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
  * call this function to perform Tx offloads on outgoing traffic.
  */
 enum udp_parsable_tunnel_type {
-	UDP_TUNNEL_TYPE_VXLAN,		/* RFC 7348 */
-	UDP_TUNNEL_TYPE_GENEVE,		/* draft-ietf-nvo3-geneve */
-	UDP_TUNNEL_TYPE_VXLAN_GPE,	/* draft-ietf-nvo3-vxlan-gpe */
+	UDP_TUNNEL_TYPE_VXLAN	  = BIT(0), /* RFC 7348 */
+	UDP_TUNNEL_TYPE_GENEVE	  = BIT(1), /* draft-ietf-nvo3-geneve */
+	UDP_TUNNEL_TYPE_VXLAN_GPE = BIT(2), /* draft-ietf-nvo3-vxlan-gpe */
 };
 
 struct udp_tunnel_info {
-- 
2.26.2

