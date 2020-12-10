Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9881A2D6B82
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgLJXEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729779AbgLJXD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:03:58 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599D2C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:03:18 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CsTwC16MWzQlF7;
        Fri, 11 Dec 2020 00:02:51 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B9X412n6m09K+CYkIH9Dah+RQuChRUcOzoqK0yLpGfo=;
        b=IEH95PlP4q3mSHUxR0/YQDKy5FR5Kn7kbZvNA4QWcvG5CM8NTMXEmsxFmOID61mdSQansw
        njPFAA+wv4mzaaLw9l6qKhnsDgXkO7/MAielqjWufW7XtM9UZCmyv3KPAvmBg7FpvJOSR5
        fHZWEYMxSZp0SS2RVrLeTDf38izAJ6hFXZyXlwTPLyUyw5RwPnNinKR6CEf7kaSNf6UKy4
        QDyD1T1KdC6g6dVYtIg3tEtdv1D/tssZiQm56jQczcP8ZfmcoC6oo0pnBtsBdnKzV7Ogd9
        Su0tQTXFQrZxZuMw3VkSgKPRjHVPOUvmQzyIIb/msAVuHdyHQ9hY6cieel3+yQ==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id QmZBu8OaTj7r; Fri, 11 Dec 2020 00:02:48 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 00/10] dcb: Support PFC, buffer, maxrate objects
Date:   Fri, 11 Dec 2020 00:02:14 +0100
Message-Id: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.50 / 15.00 / 15.00
X-Rspamd-Queue-Id: 3026617B3
X-Rspamd-UID: 107b69
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to the dcb tool for the following three DCB objects:

- PFC, for "Priority-based Flow Control", allows configuration of priority
  lossiness, and related toggles.

- DCBNL buffer interfaces are an extension to the 802.1q DCB interfaces and
  allow configuration of port headroom buffers.

- DCBNL maxrate interfaces are an extension to the 802.1q DCB interfaces
  and allow configuration of rate with which traffic in a given traffic
  class is sent.

Patches #1-#4 fix small issues in the current DCB code and man pages.

Patch #5 adds new helpers to the DCB dispatcher.

Patches #6 and #7 add support for command line arguments -s and -i. These
enable, respectively, display of statistical counters, and ISO/IEC mode of
rate units.

Patches #8-#10 add the subtools themselves and their man pages.

Petr Machata (10):
  dcb: Remove unsupported command line arguments from getopt_long()
  dcb: ets: Fix help display for "show" subcommand
  dcb: ets: Change the way show parameters are given in synopsis
  man: dcb-ets: Remove an unnecessary empty line
  dcb: Add dcb_set_u32(), dcb_set_u64()
  dcb: Add -s to enable statistics
  dcb: Add -i to enable IEC mode
  dcb: Add a subtool for the DCB PFC object
  dcb: Add a subtool for the DCB buffer object
  dcb: Add a subtool for the DCB maxrate object

 dcb/Makefile           |   2 +-
 dcb/dcb.c              |  66 +++++++++-
 dcb/dcb.h              |  24 +++-
 dcb/dcb_buffer.c       | 235 +++++++++++++++++++++++++++++++++
 dcb/dcb_ets.c          |  10 +-
 dcb/dcb_maxrate.c      | 182 ++++++++++++++++++++++++++
 dcb/dcb_pfc.c          | 286 +++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-buffer.8  | 126 ++++++++++++++++++
 man/man8/dcb-ets.8     |  14 +-
 man/man8/dcb-maxrate.8 |  94 ++++++++++++++
 man/man8/dcb-pfc.8     | 127 ++++++++++++++++++
 man/man8/dcb.8         |  29 ++++-
 12 files changed, 1173 insertions(+), 22 deletions(-)
 create mode 100644 dcb/dcb_buffer.c
 create mode 100644 dcb/dcb_maxrate.c
 create mode 100644 dcb/dcb_pfc.c
 create mode 100644 man/man8/dcb-buffer.8
 create mode 100644 man/man8/dcb-maxrate.8
 create mode 100644 man/man8/dcb-pfc.8

-- 
2.25.1

