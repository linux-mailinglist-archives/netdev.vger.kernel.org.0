Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396E122ECA3
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgG0M5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:57:08 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:64663 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbgG0M5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 08:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595854628; x=1627390628;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=P2sBxX3paFo8fGHixQ5y+WfJxnluZn1uFacaZn66Sl0=;
  b=UUyDkFPlrMBfIWsccSfj9X3LH/Ql0sP096uAr42Qj8G7d5k1Cy+/HnxH
   DxOtaceIqQT1oAHjtveYJm+ERDTTQJgQjcvwu6zXyxZ0jN7TeNLXkX8C1
   hZJGcCql4pqWZQ1UV5IaY782HDYbUGSU3NFFIIG15epgs3AO4jmaUeail
   Q=;
IronPort-SDR: Ld7+nAA1yGyR3UB+BFVHZi7UIbEyJ5wuCKHRtEtXMOKZvE5qv2JJdsP2mAqb+8kI1jyaA7o1BC
 NJJT2mQsmiTg==
X-IronPort-AV: E=Sophos;i="5.75,402,1589241600"; 
   d="scan'208";a="61956101"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 27 Jul 2020 12:57:05 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id D9314A1EE6;
        Mon, 27 Jul 2020 12:57:03 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Jul 2020 12:56:55 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Jul 2020 12:56:55 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 27 Jul 2020 12:56:55 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 2061E81C33; Mon, 27 Jul 2020 12:56:55 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kuba@kernel.org>, <hawk@kernel.org>, <shayagr@amazon.com>,
        <lorenzo@kernel.org>
Subject: [PATCH RFC net-next 0/2] XDP multi buffer helpers
Date:   Mon, 27 Jul 2020 12:56:51 +0000
Message-ID: <20200727125653.31238-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This series is based on the series that Lorenzo sent [0].

This series simply adds new bpf helpers for xdp mb support as well as
introduces a sample program that uses them.

[0] - [RFC net-next 00/22] Introduce mb bit in xdp_buff/xdp_frame

Sameeh Jubran (2):
  xdp: helpers: add multibuffer support
  samples/bpf: add bpf program that uses xdp mb helpers

 include/uapi/linux/bpf.h       |  13 +++
 net/core/filter.c              |  60 ++++++++++++++
 samples/bpf/Makefile           |   3 +
 samples/bpf/xdp_mb_kern.c      |  66 ++++++++++++++++
 samples/bpf/xdp_mb_user.c      | 174 +++++++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  13 +++
 6 files changed, 329 insertions(+)
 create mode 100644 samples/bpf/xdp_mb_kern.c
 create mode 100644 samples/bpf/xdp_mb_user.c

-- 
2.16.6

