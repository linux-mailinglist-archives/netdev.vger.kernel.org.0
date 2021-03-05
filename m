Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E6D32E4A9
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCEJWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhCEJWN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:22:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C810164F73;
        Fri,  5 Mar 2021 09:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614936133;
        bh=9B2UwE4hVVh8VCkL2+pUISD+qk8AExeqBMVyuOMGs4c=;
        h=Date:From:To:Cc:Subject:From;
        b=s0sXa8ewwCQPCZWxkZ0kWgzQib82IDRQs8L/w3gQsTIuV/TGF0xE/TlAw3PutCPbX
         S8PzgxFxsr9p1K/ILpFpywgxfH6abrGY217uRKlaw6N8gbvUkYM1BVKn8DlEUFuGVT
         Zka6w9/B10NSt2qgDaCgErIoS811HqjRvEmnj+uZBTE40XyAVYGMykjs6mpvgynyd5
         xOhj3BHbcw8jqqyL74QjxwbszhSEI6LCfVmRMrKuwABN/xPlUiKBG8qLcmEWGcAqzP
         /f+8kSDvjwMm+4GMkftHOjkvTkLfrAQU27lgN/XGMDUSi7Xvb1z/uEOwiKNxjonetZ
         xCWw21XnCV+Nw==
Date:   Fri, 5 Mar 2021 03:22:10 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net: netrom: Fix fall-through warnings for Clang
Message-ID: <20210305092210.GA139864@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/netrom/nr_route.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 78da5eab252a..de9821b6a62a 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -266,6 +266,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		fallthrough;
 	case 2:
 		re_sort_routes(nr_node, 0, 1);
+		break;
 	case 1:
 		break;
 	}
@@ -359,6 +360,7 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
 					fallthrough;
 				case 1:
 					nr_node->routes[1] = nr_node->routes[2];
+					break;
 				case 2:
 					break;
 				}
@@ -482,6 +484,7 @@ static int nr_dec_obs(void)
 					fallthrough;
 				case 1:
 					s->routes[1] = s->routes[2];
+					break;
 				case 2:
 					break;
 				}
@@ -529,6 +532,7 @@ void nr_rt_device_down(struct net_device *dev)
 							fallthrough;
 						case 1:
 							t->routes[1] = t->routes[2];
+							break;
 						case 2:
 							break;
 						}
-- 
2.27.0

