Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EC32F39A9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392604AbhALTIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:08:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18434 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391891AbhALTIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:08:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffdf3810000>; Tue, 12 Jan 2021 11:07:45 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Jan
 2021 19:07:33 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Tue, 12 Jan 2021 19:07:29 +0000
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
        Alexei Starovoitov <ast@kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>
Subject: [PATCH net-next v4 0/2] Dissect PTP L2 packet header
Date:   Tue, 12 Jan 2021 21:07:11 +0200
Message-ID: <1610478433-7606-1-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610478465; bh=9tfB2VQLfeee7kEC0VxpkrpgSJPB5oP+LYA5OcI//ZE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type;
        b=QXWu4Z5drGtqxx1l1jXo4M5RAs73i7ZFJv7tw0YGNh3fNbG2laIJotqUao9YIfEVs
         rAPGaRCqSBMPB6Ka3B6MCEHMKRj5gBtetysHzRMXWqHdsY0jp/qBJb4B+vt+DHs3m/
         TqOqSiEdRu/iEAD/tIxCUb85pwy3zAqdDUBkuL/4PCsy4FqO343z9V9aRmI61L2r+L
         sozst2cEgATGl/LK2ML5S80chCXvFN3ofRnSrm4YDyWu5z01MOvaXlvjzHtmvUqsvk
         3+l1OTG3JKsdN7hh4xBL2JQMQdK1MzoWkBMk43HqnO2Q4K4cAWxmPHv3zsHw0mdL9P
         RrYYXcboYs70g==
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
v4:
- Drop a redundant length check when fetching ptp header from skb.
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

