Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939602FAA42
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394074AbhARTcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:32:54 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:49387 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436996AbhARTcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:32:50 -0500
Date:   Mon, 18 Jan 2021 19:31:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610998326; bh=TBvMcCRFophojKbj4HPDNicgLhX83rsTjO3WdiWNZwI=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=QoISxSQzWyFAKHASLuhD2GUlrYXLVy7QuLwIwMLbrCz7gROMjEu9AXp7wffDTqkY0
         loPF8UrT/4TwBoDnjcpNeMpFJFz6u8zgEO74w8BQy5RFGOZmpkzvW3QnjNF8sk5a4d
         NJHSLqcheEhscz89CdQ09jdVIDviCOH0RJibPcaB8Vp50eiIVp2Zt9R/GLYob8tBaN
         nfNoA1RyKEOK8UmbkBvrknvP1DGlHxSFm5YlOKLbqi0PRvy7cEGp39CjHIYLjrxmBi
         jpIJYxlF77AigXZesQW5C11fkVnVMp5jbnbKdu9FFAtWqrPUFn0pMY+h+ch9+H2BSp
         QVVD6qYobf/gw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 0/2] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
Message-ID: <20210118193122.87271-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series allows to form UDP GRO packets in cases without sockets,
primarily for forwarding. To not change the current datapath, this
is performed only when the new netdev feature is enabled via Ethtool.
Prior to this point, only fraglisted UDP GRO was available.

Since v2 [1]:
 - convert to a series;
 - new: add new netdev_feature to explicitly enable/disable UDP GRO
   when there is no socket, defaults to off (Paolo Abeni).

Since v1 [0]:
 - drop redundant 'if (sk)' check (Alexander Duyck);
 - add a ref in the commit message to one more commit that was
   an important step for UDP GRO forwarding.

[0] https://lore.kernel.org/netdev/20210112211536.261172-1-alobakin@pm.me
[1] https://lore.kernel.org/netdev/20210113103232.4761-1-alobakin@pm.me

Alexander Lobakin (2):
  net: introduce UDP GRO netdev feature
  udp: allow forwarding of plain (non-fraglisted) UDP GRO packets

 include/linux/netdev_features.h |  4 +++-
 net/ethtool/common.c            |  1 +
 net/ipv4/udp_offload.c          | 16 +++++++++++-----
 3 files changed, 15 insertions(+), 6 deletions(-)

--=20
2.30.0


