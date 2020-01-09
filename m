Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B258C135A41
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731159AbgAINfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 08:35:48 -0500
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:51996 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730589AbgAINfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 08:35:48 -0500
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 13B56366825;
        Thu,  9 Jan 2020 14:35:46 +0100 (CET)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1ipXyT-0002FR-Gj; Thu, 09 Jan 2020 14:35:45 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH ipsec v2 0/2] ipsec interfaces: fix sending with bpf_redirect() / AF_PACKET sockets
Date:   Thu,  9 Jan 2020 14:35:41 +0100
Message-Id: <20200109133543.8559-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200109084009.GA8621@gauss3.secunet.de>
References: <20200109084009.GA8621@gauss3.secunet.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before those patches, packets sent to a vti[6]/xfrm interface via
bpf_redirect() or via an AF_PACKET socket were dropped, mostly because
no dst was attached.

v1 -> v2:
  - remove useless check against skb_dst() in xfrmi_xmit2()
  - keep incrementing tx_carrier_errors in case of route lookup failure

 net/ipv4/ip_vti.c         | 11 +++++++++--
 net/ipv6/ip6_vti.c        | 11 +++++++++--
 net/xfrm/xfrm_interface.c | 28 +++++++++++++++++++++-------
 3 files changed, 39 insertions(+), 11 deletions(-)

Regards,
Nicolas

