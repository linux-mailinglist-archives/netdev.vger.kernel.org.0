Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F232E8BCE
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 11:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbhACK6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 05:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbhACK6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 05:58:40 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041F2C061573
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 02:57:59 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4D7whk2f9XzQlLl;
        Sun,  3 Jan 2021 11:57:58 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609671476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=I7CB+kOl+U0G9hdbq9rwAaxKx8OZvFZrIIP6Z4oqb30=;
        b=uyPtW7CYsiNJgUGwKJm7VWdVzrLZrQofzSm5KQ/cwUlwYNcBaOlpuTIu4Jvj9RggDTZT4b
        wTP2EWTgRAv54PaZYndDpRsTFTR356L/wl7OSg9XGVWIcD812Iy9yMTuzZ1LQppsYHHoYO
        JspjiRL3XC9c6yjIqcmxXpcyvP3nx+b+5RKFICFgyCinaILuxikilNKT9Vg26tqpjMfEDl
        2kBIdt4Zp7a0wn49ZrjtVmr06QjGz7P6rF6SBTCyoWngwmzPDtWBxEIb4YfEHbbQRR22J0
        PgN/LVDN8ec9fkhbVZB9XjvKlAKc+xu6cptAW2Kf66J+rS0zM7FK1Dcx1P9lKg==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id S1ujgaliadov; Sun,  3 Jan 2021 11:57:55 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2 v2 0/3] dcb: Fixes
Date:   Sun,  3 Jan 2021 11:57:21 +0100
Message-Id: <cover.1609671168.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.30 / 15.00 / 15.00
X-Rspamd-Queue-Id: 6D1461854
X-Rspamd-UID: 55be16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dcb currently sends all netlink messages with a type RTM_GETDCB, even the
set ones. In patch #1, send the setters as RTM_SETDCB.

In patch #2, plug a leak.

In patch #3, change the command line option for namespace change from
devlink-like -N / --Netns to ip-like -n / --netns.

v2:
- Patches #1-#3:
    - Add Fixes: tag.

Petr Machata (3):
  dcb: Set values with RTM_SETDCB type
  dcb: Plug a leaking DCB socket buffer
  dcb: Change --Netns/-N to --netns/-n

 dcb/dcb.c      | 11 ++++++-----
 man/man8/dcb.8 |  7 +++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

-- 
2.26.2

