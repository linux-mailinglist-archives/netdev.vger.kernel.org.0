Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DED82BBC90
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgKUDKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:10:07 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8380 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgKUDKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 22:10:01 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CdJLF2JyBz6xbl;
        Sat, 21 Nov 2020 11:09:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 21 Nov 2020 11:09:48 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <will@kernel.org>,
        <viro@zeniv.linux.org.uk>, <kyk.segfault@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <fw@strlen.de>, <gnault@redhat.com>,
        <steffen.klassert@secunet.com>, <vladimir.oltean@nxp.com>,
        <edumazet@google.com>, <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next v2 0/2] Add an assert in napi_consume_skb()
Date:   Sat, 21 Nov 2020 11:06:14 +0800
Message-ID: <1605927976-232804-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a lockdep_assert_in_softirq() interface and
uses it to assert the case when napi_consume_skb() is not called in
the softirq context.

Changelog:
V2: Use lockdep instead of one-off Kconfig knob

Yunsheng Lin (2):
  lockdep: Introduce in_softirq lockdep assert
  net: Use lockdep_assert_in_softirq() in napi_consume_skb()

 include/linux/lockdep.h | 7 +++++++
 net/core/skbuff.c       | 2 ++
 2 files changed, 9 insertions(+)

-- 
2.8.1

