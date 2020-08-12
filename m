Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D30242EED
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 21:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgHLTJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 15:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLTJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 15:09:08 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AFDC061383;
        Wed, 12 Aug 2020 12:09:08 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k5w7U-003AoI-Mi; Wed, 12 Aug 2020 21:09:04 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] ipv4: tunnel: fix compilation on ARCH=um
Date:   Wed, 12 Aug 2020 21:08:53 +0200
Message-Id: <20200812210852.dc434e0b40e9.I618f37993ea3ddb2bec31e9b54e4f4ae2f7b7a51@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

With certain configurations, a 64-bit ARCH=um errors
out here with an unknown csum_ipv6_magic() function.
Include the right header file to always have it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/ipv4/ip_tunnel_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 9ddee2a0c66d..4ecf0232ba2d 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -37,6 +37,7 @@
 #include <net/geneve.h>
 #include <net/vxlan.h>
 #include <net/erspan.h>
+#include <net/ip6_checksum.h>
 
 const struct ip_tunnel_encap_ops __rcu *
 		iptun_encaps[MAX_IPTUN_ENCAP_OPS] __read_mostly;
-- 
2.26.2

