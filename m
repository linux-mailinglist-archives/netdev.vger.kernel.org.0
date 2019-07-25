Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D377590C
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfGYUmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:42:44 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:33920 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfGYUmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 16:42:44 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A080C8066C;
        Fri, 26 Jul 2019 08:42:41 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1564087361;
        bh=aT/iyaWbpw8kgdm9cLKA0xhryNej3v5jj3UD0yvK8Zs=;
        h=From:To:Cc:Subject:Date;
        b=zVmqmbUBUmMdOy3ZeYMaa5gK2nzPVwu7zg8u+2xXdfG4sQ367aks3wOC4ocKXn6Hn
         DUIWdgzT1OhEGBV9DSYeaBtPpsl1GR25QER382fo74dckD38zSSVX2Did0M9TQBHNK
         H8ieh9tJiK1J65CGEIRqtl/K9M/UVyrFdCmxMoXJFDcXx1gUqODVAeHtmFnpAktu6R
         gP1OfGyicoEtrScYmxAyVkTPsb8+dRN3IJXdDwFCg5nL2A5IIww6dSH1KiDZoQBWTO
         E2evh/NIP7yrCyiriW62EEqeVKVe5eHa5igOv4RtuUYKEJ5MGSbkhlMxvp+MndN9J+
         xew0I0Ykxixtg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d3a14410000>; Fri, 26 Jul 2019 08:42:41 +1200
Received: from brodieg-dl.ws.atlnz.lc (brodieg-dl.ws.atlnz.lc [10.33.22.16])
        by smtp (Postfix) with ESMTP id 373E413EECE;
        Fri, 26 Jul 2019 08:42:43 +1200 (NZST)
Received: by brodieg-dl.ws.atlnz.lc (Postfix, from userid 1718)
        id 277AF502CCC; Fri, 26 Jul 2019 08:42:41 +1200 (NZST)
From:   Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
To:     davem@davemloft.net, stephen@networkplumber.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        luuk.paulussen@alliedtelesis.co.nz,
        Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
Subject: [PATCH 0/2] Make ipmr queue length configurable
Date:   Fri, 26 Jul 2019 08:42:28 +1200
Message-Id: <20190725204230.12229-1-brodie.greenfield@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to have some more space in our queue for processing incoming
multicast packets, so we can process more of them without dropping
them prematurely. It is useful to be able to increase this limit on
higher-spec platforms that can handle more items.

For the particular use case here at Allied Telesis, we have linux
running on our switches and routers, with support for the number of
multicast groups being increased. Basically, this queue length affects
the time taken to fully learn all of the multicast streams.=20

Changes in v3:
 - Corrected a v4 to v6 typo.

Changes in v2:
 - Tidy up a few unnecessary bits of code.
 - Put the sysctl inside ip multicast ifdef.
 - Included the IPv6 version.

Brodie Greenfield (2):
  ipmr: Make cache queue length configurable
  ip6mr: Make cache queue length configurable

 Documentation/networking/ip-sysctl.txt | 16 ++++++++++++++++
 include/net/netns/ipv4.h               |  1 +
 include/net/netns/ipv6.h               |  1 +
 net/ipv4/af_inet.c                     |  1 +
 net/ipv4/ipmr.c                        |  4 +++-
 net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
 net/ipv6/af_inet6.c                    |  1 +
 net/ipv6/ip6mr.c                       |  4 +++-
 net/ipv6/sysctl_net_ipv6.c             |  7 +++++++
 9 files changed, 40 insertions(+), 2 deletions(-)

--=20
2.21.0

