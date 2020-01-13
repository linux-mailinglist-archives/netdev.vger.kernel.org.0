Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C3B138CEE
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 09:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgAMIcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 03:32:51 -0500
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:40210 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgAMIcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 03:32:51 -0500
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 3FCE33694B8;
        Mon, 13 Jan 2020 09:32:49 +0100 (CET)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1iqv9V-0003pg-5t; Mon, 13 Jan 2020 09:32:49 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH ipsec v3 0/2] ipsec interfaces: fix sending with bpf_redirect() / AF_PACKET sockets
Date:   Mon, 13 Jan 2020 09:32:45 +0100
Message-Id: <20200113083247.14650-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <6407b52a-b01d-5580-32e2-fbe352c2f47e@6wind.com>
References: <6407b52a-b01d-5580-32e2-fbe352c2f47e@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before those patches, packets sent to a vti[6]/xfrm interface via
bpf_redirect() or via an AF_PACKET socket were dropped, mostly because
no dst was attached.

v2 -> v3:
  - fix flowi info for the route lookup

v1 -> v2:
  - remove useless check against skb_dst() in xfrmi_xmit2()
  - keep incrementing tx_carrier_errors in case of route lookup failure

 net/ipv4/ip_vti.c         | 13 +++++++++++--
 net/ipv6/ip6_vti.c        | 13 +++++++++++--
 net/xfrm/xfrm_interface.c | 32 +++++++++++++++++++++++++-------
 3 files changed, 47 insertions(+), 11 deletions(-)

Regards,
Nicolas

