Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61858217DC0
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 05:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgGHDuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 23:50:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729506AbgGHDuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 23:50:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 98926A03BB8DCD8A933A;
        Wed,  8 Jul 2020 11:50:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 8 Jul 2020 11:50:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 0/2] net: two updates related to UDP GSO
Date:   Wed, 8 Jul 2020 11:48:54 +0800
Message-ID: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two updates related to UDP GSO.
#1 adds NETIF_F_GSO_UDP_L4 to NETIF_F_SOFTWARE_GSO, then the virtual
device can postpone its UDP GSO to physical device, as extention to
commit 83aa025f535f ("udp: add gso support to virtual devices").
#2 disable UDP GSO feature when CSUM is disabled. Currently, when
disabled CSUM, sending a UDP packet who needs segmentation will will
fail, but from user-space the UDP GSO feature is enabled, so disble
UDP GSO feature when CSUM disabled just like what TSO does now.

Huazhong Tan (2):
  udp: add NETIF_F_GSO_UDP_L4 to NETIF_F_SOFTWARE_GSO
  net: disable UDP GSO feature when CSUM is disabled

 include/linux/netdev_features.h | 2 +-
 net/core/dev.c                  | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.7.4

