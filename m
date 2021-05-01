Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54A8370514
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 05:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhEADJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 23:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhEADJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 23:09:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F4A8613EF;
        Sat,  1 May 2021 03:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619838537;
        bh=IPvsqj1rwJQC0V7kcMnrTPKpOgZbh2yhHLoUzTDKe3Q=;
        h=From:To:Cc:Subject:Date:From;
        b=mAlmK/WvmsMWU7zZCaJAqbg/v4GS0JWmoi7LcT6egM4Lpl6JOrM9ALT9Qnqy0y/Hm
         NmegUv4GvRt3uZLgK9bJxfp9Ql6aeoZx/nlgFcfewowOaAqVgGnf+L6CkgO4IeSCcZ
         ZZXwCrUfdbAyP++MURnxKV+vuDa48nPlfyQupFqgAqHmKzOIjj8Q8U4qM/VrHFliQm
         cya0yx7d+KHqi+GTTZz2+fDv63637GDB4D0n9ONJNAf1ZEq5Jv8v6kLYPnWc5YuAa3
         NyE1W1W8m9nrTo+/xVtjwsBFx3Zafi+rCWdcwNUCv24Ghmal5H9w8Wc0sdibddvk4C
         7w/oLvjoQ+qxg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PACTH iproute2] ip: align the name of the 'nohandler' stat
Date:   Fri, 30 Apr 2021 20:08:54 -0700
Message-Id: <20210501030854.529712-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before:

    RX: bytes  packets  errors  dropped missed  mcast
    8848233056 8548168  0       0       0       0
    RX errors: length   crc     frame   fifo    overrun   nohandler
               0        0       0       0       0       101
    TX: bytes  packets  errors  dropped carrier collsns compressed
    1142925945 4683483  0       0       0       0       101
    TX errors: aborted  fifo   window heartbeat transns
               0        0       0       0       14

After:

    RX: bytes  packets  errors  dropped missed  mcast
    8848297833 8548461  0       0       0       0
    RX errors: length   crc     frame   fifo    overrun nohandler
               0        0       0       0       0       101
    TX: bytes  packets  errors  dropped carrier collsns compressed
    1143049820 4683865  0       0       0       0       101
    TX errors: aborted  fifo   window heartbeat transns
               0        0       0       0       14

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ip/ipaddress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index cfb24f5c1e34..8783b70d81e2 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -757,7 +757,7 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		if (show_stats > 1) {
 			fprintf(fp, "%s", _SL_);
 			fprintf(fp, "    RX errors: length   crc     frame   fifo    overrun%s%s",
-				s->rx_nohandler ? "   nohandler" : "", _SL_);
+				s->rx_nohandler ? " nohandler" : "", _SL_);
 			fprintf(fp, "               ");
 			print_num(fp, 8, s->rx_length_errors);
 			print_num(fp, 7, s->rx_crc_errors);
-- 
2.31.1

