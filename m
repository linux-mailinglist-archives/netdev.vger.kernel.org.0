Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF582E85ED
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 00:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbhAAX1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 18:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbhAAX1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 18:27:30 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DDCC0613CF
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 15:26:50 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4D71PB5wVSzQjkp;
        Sat,  2 Jan 2021 00:26:22 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609543581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TT30AH2MZO2nigGEXq9YkqK5r5qQ7XGOtPBLTNRndx8=;
        b=JtWzN22FpGNa0MVIGWiXL05p2V4tPy4C+R9R+gjqSTwaFZeBEpkgVm2Lpep2cKTeOZLmN9
        HZC7JyVx8e915awwyUGGzqJwmCmy8qCjRcwkYPtNXeNSwzK6sROWche+WHQOwmH7AMA3dH
        OhKKbJDgSsM2Ipuf/wZTulsQtz/f3ZE9K6WgOHF7GoA646769owXEhNhqSt/VV+yKpCdTl
        DdMjVSNu6op5VkclUfsUpA+T3pqfvDOE1kQtxzg9Pjpj/P+JPxPXgTlATVXdgCvy9NH+eo
        I8lSeDlDc+Ndj8NhrjCSlyyJ+FSo8hyDo6VOtTDZ5B1Nol2YWTfAMH7tNXLUUw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id rfVAO2XflsW0; Sat,  2 Jan 2021 00:26:20 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2 0/3] dcb: Fixes
Date:   Sat,  2 Jan 2021 00:25:49 +0100
Message-Id: <cover.1609543363.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.66 / 15.00 / 15.00
X-Rspamd-Queue-Id: D42F31842
X-Rspamd-UID: 55de36
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dcb currently sends all netlink messages with a type RTM_GETDCB, even the
set ones. In patch #1, send the setters as RTM_SETDCB.

In patch #2, plug a leak.

In patch #3, change the command line option for namespace change from
devlink-like -N / --Netns to ip-like -n / --netns.

Petr Machata (3):
  dcb: Set values with RTM_SETDCB type
  dcb: Plug a leaking DCB socket buffer
  dcb: Change --Netns/-N to --netns/-n

 dcb/dcb.c      | 11 ++++++-----
 man/man8/dcb.8 |  7 +++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

-- 
2.26.2

