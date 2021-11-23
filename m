Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9974A45A3D0
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhKWNfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:35:13 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:50482 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229599AbhKWNfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:35:12 -0500
X-IronPort-AV: E=Sophos;i="5.87,257,1631545200"; 
   d="scan'208";a="101513516"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Nov 2021 22:32:03 +0900
Received: from localhost.localdomain (unknown [10.226.93.159])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id DCADC4298F4C;
        Tue, 23 Nov 2021 22:32:00 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [RFC 0/2] Add Rx checksum offload support
Date:   Tue, 23 Nov 2021 13:31:55 +0000
Message-Id: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TOE has hw support for calculating IP header checkum for IPV4 and
TCP/UDP/ICMP checksum for both IPV4 and IPV6.

This patch series aims to adds Rx checksum offload supported by TOE.

For RX, The result of checksum calculation is attached to last 4byte
of ethernet frames. First 2bytes is result of IPV4 header checksum 
and next 2 bytes is TCP/UDP/ICMP.

if frame does not have error "0000" attached to checksum calculation
result. For unsupported frames "ffff" is attached to checksum calculation
result. Cases like IPV6, IPV4 header is always set to "FFFF".

we can test this functionality by the below commands

ethtool -K eth0 rx on --> to turn on Rx checksum offload
ethtool -K eth0 rx off --> to turn off Rx checksum offload

Biju Das (2):
  ravb: Fillup ravb_set_features_gbeth() stub
  ravb: Add Rx checksum offload support

 drivers/net/ethernet/renesas/ravb.h      | 20 +++++++++
 drivers/net/ethernet/renesas/ravb_main.c | 55 +++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

-- 
2.17.1

