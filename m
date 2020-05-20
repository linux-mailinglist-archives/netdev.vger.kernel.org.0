Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768B01DB7FF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgETPVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:21:52 -0400
Received: from novek.ru ([213.148.174.62]:60410 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgETPVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:21:52 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 15DE4502966;
        Wed, 20 May 2020 18:21:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 15DE4502966
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589988106; bh=Vhv9ezsDEnHfNlG8ls6w2p56J/BwN5YUGBmRh+PSQlo=;
        h=From:To:Cc:Subject:Date:From;
        b=qGDHobg82HKqKknS3if3IWfXpvwaz2NtMVeIAH+EHuX/c5H6aF6+YtrajTLmEw+px
         7ASKDgWLRtPrARLFkXS/QNekRT0sn5WkxmBGo9Tt1YwFe+/PrfLZH9y2anGAMMfKz5
         U4mG16RqBqTlHEpH1+xrslKNSBXcfPt46UAHTSKI=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net-next v2 0/5] ip6_tunnel: add MPLS support
Date:   Wed, 20 May 2020 18:21:34 +0300
Message-Id: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The support for MPLS-in-IPv4 was added earlier. This patchset adds
support for MPLS-in-IPv6.

Changes in v2:
- Eliminate ifdefs IS_ENABLE(CONFIG_MPLS)

Vadim Fedorenko (5):
  ip6_tunnel: simplify transmit path
  ip6_tunnel: add MPLS transmit support
  tunnel6: support for IPPROTO_MPLS
  ip6_tunnel: add generic MPLS receive support
  mpls: Add support for IPv6 tunnels

 net/ipv6/ip6_tunnel.c | 252 +++++++++++++++++++++++++++++---------------------
 net/ipv6/tunnel6.c    |  96 ++++++++++++++++++-
 net/mpls/af_mpls.c    |   3 +-
 3 files changed, 242 insertions(+), 109 deletions(-)

-- 
1.8.3.1

