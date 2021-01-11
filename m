Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4992F1DD3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389684AbhAKSSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:18:50 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16293 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389348AbhAKSSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:18:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc96610005>; Mon, 11 Jan 2021 10:18:09 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 18:18:06 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 18:18:03 +0000
From:   Eran Ben Elisha <eranbe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Guillaume Nault <gnault@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH net-next v3 0/2] Dissect PTP L2 packet header
Date:   Mon, 11 Jan 2021 20:17:46 +0200
Message-ID: <1610389068-2133-1-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610389089; bh=9VyRX2KZ5rDvXhftGvRABfWtDMjaVeTJDURg3XSEClY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type;
        b=VSyokGkbCFdGWXjDR4TdS5pvwfxuYUsR2DSq9+Yzf9UAWuiiDGrEo0Fl0vahYdKqU
         +BsiCDVxAyk2EerRRhoCRH03NVdqyCC/3Ivc5xzodpSjYnObweo5GxcgTocnZ+dlQn
         xiJ9boUGci2kzVKopBAJ8uKhtWnUxKnU3s+CIx+f32aeRUoC1c8uAr3KY/0FSM3RNN
         XGq2cC1CT1WsvBkfx3p0xHha7iNnUUH+dFi/SEuukDIdhT1ON1NZq1amlZRrZA7Uwg
         1ScoNOPPkUo2SoQgvljkovSWjT87Cy9PEMn+IUtmcPTvIVlmkYY3cahub2o+RFXQ3U
         mPpt74GvKy4cg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Dave,

This series adds support for dissecting PTP L2 packet
header (EtherType 0x88F7).

For packet header dissecting, skb->protocol is needed. Add protocol
parsing operation to vlan ops, to guarantee skb->protocol is set,
as EtherType 0x88F7 occasionally follows a vlan header.

Changelog:
v2, v3:
- Add more people to the CC list.

Eran Ben Elisha (2):
  net: vlan: Add parse protocol header ops
  net: flow_dissector: Parse PTP L2 packet header

 net/8021q/vlan_dev.c      |  9 +++++++++
 net/core/flow_dissector.c | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

-- 
2.17.1

