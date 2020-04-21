Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC681B2BDB
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 18:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgDUQEj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 12:04:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25468 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgDUQEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 12:04:39 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-RPp71vTOMQ-m4mHOP8-Txg-1; Tue, 21 Apr 2020 12:04:33 -0400
X-MC-Unique: RPp71vTOMQ-m4mHOP8-Txg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72EC1107B273;
        Tue, 21 Apr 2020 16:04:32 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF77B1001F43;
        Tue, 21 Apr 2020 16:04:30 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next v2 0/2] xfrm: add IPv6 encapsulation support for ESP over UDP and TCP
Date:   Tue, 21 Apr 2020 18:04:21 +0200
Message-Id: <cover.1587484164.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds IPv6 encapsulation of ESP over both UDP and TCP. In
both cases, the code is very similar to the existing IPv4
encapsulation implementation. The core espintcp code is almost
entirely version-independent.

v2: rebase on top of ipsec-next/master

Sabrina Dubroca (2):
  xfrm: add support for UDPv6 encapsulation of ESP
  xfrm: add IPv6 support for espintcp

 include/net/ipv6_stubs.h  |   5 +
 include/net/xfrm.h        |   5 +
 net/ipv4/Kconfig          |   1 +
 net/ipv4/udp.c            |  10 +-
 net/ipv6/Kconfig          |  12 ++
 net/ipv6/af_inet6.c       |   5 +
 net/ipv6/ah6.c            |   1 +
 net/ipv6/esp6.c           | 413 +++++++++++++++++++++++++++++++++++---
 net/ipv6/esp6_offload.c   |   7 +-
 net/ipv6/ip6_vti.c        |  18 +-
 net/ipv6/ipcomp6.c        |   1 +
 net/ipv6/xfrm6_input.c    | 106 +++++++++-
 net/ipv6/xfrm6_protocol.c |  48 +++++
 net/xfrm/Kconfig          |   3 +
 net/xfrm/Makefile         |   2 +-
 net/xfrm/espintcp.c       |  56 +++++-
 net/xfrm/xfrm_interface.c |   3 +
 17 files changed, 646 insertions(+), 50 deletions(-)

-- 
2.26.1

