Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE494398FF
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfFGWiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbfFGWiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:19 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9659420840;
        Fri,  7 Jun 2019 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947098;
        bh=3sU8+zfXmAMdld3dG9ZSAbQTqjVseN5mCH3/Jz2rXaw=;
        h=From:To:Cc:Subject:Date:From;
        b=Hi/ZhageW6hriSMdJ1isk/ttunTqXZK4V+ElkHVMXA0/62TB0Wu4E2WNey2DVdJNH
         3aGgAI9n7d6ginm9jvsCPfb83+nX5W6Y3Vbu+JpgDMbh5NX9cXlTKZ7ntJzE3yue5b
         w9DWMan+F9x87KtyqSMsY8ADeM1ZVnyy3YEFmJN4=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 00/10] ip: Add support for nexthop objects
Date:   Fri,  7 Jun 2019 15:38:06 -0700
Message-Id: <20190607223816.27512-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This set adds support for nexthop objects to the ip command. The syntax
for nexthop objects is identical to the current 'ip route .. nexthop ...'
syntax making it easy to convert existing use cases.

v2
- Fixed header use in rtnl_nexthopdump_req as noted by roopa
- made rth_del static per Stephen's request and fixed coding style
- removed print_nh_gateway and exported print_rta_gateway to reuse
  the iproute.c code (keeps consistency in output)
- added examples to commit message
- fixed monitor use when specific groups requested
- fixed usage in 'ip nexthop'
- added manpage

David Ahern (10):
  libnetlink: Set NLA_F_NESTED in rta_nest
  lwtunnel: Pass encap and encap_type attributes to lwt_parse_encap
  libnetlink: Add helper to add a group via setsockopt
  uapi: Import nexthop object API
  libnetlink: Add helper to create nexthop dump request
  ip route: Export print_rt_flags, print_rta_if and print_rta_gateway
  Add support for nexthop objects
  ip: Add man page for nexthop command
  ip route: Add option to use nexthop objects
  ipmonitor: Add nexthop option to monitor

 include/libnetlink.h         |   7 +-
 include/uapi/linux/nexthop.h |  56 +++++
 ip/Makefile                  |   3 +-
 ip/ip.c                      |   3 +-
 ip/ip_common.h               |  10 +-
 ip/ipmonitor.c               |  28 +++
 ip/ipnexthop.c               | 558 +++++++++++++++++++++++++++++++++++++++++++
 ip/iproute.c                 |  37 ++-
 ip/iproute_lwtunnel.c        |   7 +-
 lib/libnetlink.c             |  34 +++
 man/man8/ip-nexthop.8        | 196 +++++++++++++++
 man/man8/ip-route.8.in       |  13 +-
 12 files changed, 930 insertions(+), 22 deletions(-)
 create mode 100644 include/uapi/linux/nexthop.h
 create mode 100644 ip/ipnexthop.c
 create mode 100644 man/man8/ip-nexthop.8

-- 
2.11.0

