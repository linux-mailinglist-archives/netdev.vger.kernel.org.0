Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D834B2F0F6C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbhAKJs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:48:26 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1927 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbhAKJsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:48:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc1ec00002>; Mon, 11 Jan 2021 01:47:44 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 09:47:39 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 09:47:36 +0000
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
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH net-next v2 0/2] Dissect PTP L2 packet header
Date:   Mon, 11 Jan 2021 11:46:50 +0200
Message-ID: <1610358412-25248-1-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610358464; bh=vQfHd3KilKrYPJ8ra3urcKcCMaAH1DZuW/RwYi7Lbk8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type;
        b=AEekpZuMLTrw+v+1HsQdRvsRH36JAFKOL747MiUlidPsqTqZWuRRifrJhAcLk47Uq
         0niXRONAc2xCa+CD0jZ8XHRI3ZUGU+2eRHdpw+1sf6w5BCqdYXD8SOswig9JpXgPc1
         mcgdUabWMlhelwC9Ebj5Bg2/c/FdkL+lBcNaHjg1Q5eOSpUlZUxJkfxX7g0ceKp3+r
         kIg24mSWmnxwZuQZLIiCuKQ84jJP5pqpo0eZl6c9LcwDpqLmgBSqx0X+ZDgga/MIX7
         B2BFS9ehAM8ti2juKoYQmIH8571Tguj6ACXqL37FfxqRWcIwJHn/f2Vfk/9Yl7JO4d
         fhGzfmXPc9ViQ==
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
v2:
- Add more people to CC list.

Eran Ben Elisha (2):
  net: vlan: Add parse protocol header ops
  net: flow_dissector: Parse PTP L2 packet header

 net/8021q/vlan_dev.c      |  9 +++++++++
 net/core/flow_dissector.c | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

-- 
2.17.1

