Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2C62ECFF9
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 13:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbhAGMjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 07:39:45 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9482 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbhAGMjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 07:39:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff700e70001>; Thu, 07 Jan 2021 04:39:03 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 12:39:03 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 7 Jan 2021 12:39:01 +0000
From:   Eran Ben Elisha <eranbe@nvidia.com>
To:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH net-next 0/2] Dissect PTP L2 packet header
Date:   Thu, 7 Jan 2021 14:38:58 +0200
Message-ID: <1610023140-20256-1-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610023143; bh=BWl9xGQKIaxCBOfL2IOSXUGzQvjFBIB9Z+0aW0kd1Tw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type;
        b=ibYlDCEKNnOYUXLp1upWuYa0WppQGa3UGm43UyjjyoNvs041MUfkg9J46lM/AiNLj
         E0Qq4jAX24QgXQDzJpZvXxlt+t/xWr+aA2kIj/bvAof6qTjgCB0A3Ub2fUoZ7oaYc6
         CvkDtNRfO+0ZXBcR1uDMToJ7q5i/o8O9uXIRq85Sy0vwqpFWsQFSwf1k4UKi9PtXVu
         e/8DBbq0D2T1p2/qsJFoVhENNS4lmDodFkfqRhm5HY0HKwdEKLAAUTghqEf5SkYRmt
         8jruCGe6LO+nvopHQwExZ2uGWIaO5dXKmlyPG7isL9lPLp9ydCG4s83TbvmRzQbSUR
         PmTCl5ijoNokw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Dave,

This series adds support for dissecting PTP L2 packet
header (EtherType 0x88F7).

For packet header dissecting, skb->protocol is needed. Add protocol
parsing operation to vlan ops, to guarantee skb->protocol is set,
as EtherType 0x88F7 occasionally follows a vlan header.

Eran Ben Elisha (2):
  net: vlan: Add parse protocol header ops
  net: flow_dissector: Parse PTP L2 packet header

 net/8021q/vlan_dev.c      |  9 +++++++++
 net/core/flow_dissector.c | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

-- 
2.17.1

