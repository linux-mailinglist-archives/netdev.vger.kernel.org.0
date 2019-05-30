Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794152F087
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbfE3EE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731265AbfE3DRt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:17:49 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB39824718;
        Thu, 30 May 2019 03:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186269;
        bh=IEG2vsvOxpJ9FsbCBxasH13O/GOloea8RswpT1K+Zig=;
        h=From:To:Cc:Subject:Date:From;
        b=tNaa4HCXWmPjhZt9QntPhpRpzlBbCAhb3cCjtUtpLh+KguK4LJSuEm3TCbb7LkDXj
         dARXx1niMBVSKnmvxzNyHGfynULhitYEUL6/4hIS1JJq3yshWe0FXR4w9pq5MB7skC
         U/EIPULq0rGCUR8gx5IIcQPkDucKTnDmN3RzHpZ0=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 0/9] ip: Add support for nexthop objects
Date:   Wed, 29 May 2019 20:17:37 -0700
Message-Id: <20190530031746.2040-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This set adds support for nexthop objects to the ip command. The syntax
for nexthop objects is identical to the current 'ip route .. nexthop ...'
syntax making it easy to convert existing use cases.

David Ahern (9):
  libnetlink: Set NLA_F_NESTED in rta_nest
  lwtunnel: Pass encap and encap_type attributes to lwt_parse_encap
  libnetlink: Add helper to add a group via setsockopt
  uapi: Import nexthop object API
  libnetlink: Add helper to create nexthop dump request
  ip route: Export print_rt_flags and print_rta_if
  ip: Add support for nexthop objects
  ip route: Add option to use nexthop objects
  ipmonitor: Add nexthop option to monitor

 include/libnetlink.h         |   7 +-
 include/uapi/linux/nexthop.h |  56 +++++
 ip/Makefile                  |   3 +-
 ip/ip.c                      |   3 +-
 ip/ip_common.h               |   8 +-
 ip/ipmonitor.c               |  24 ++
 ip/ipnexthop.c               | 571 +++++++++++++++++++++++++++++++++++++++++++
 ip/iproute.c                 |  25 +-
 ip/iproute_lwtunnel.c        |   7 +-
 lib/libnetlink.c             |  34 +++
 10 files changed, 723 insertions(+), 15 deletions(-)
 create mode 100644 include/uapi/linux/nexthop.h
 create mode 100644 ip/ipnexthop.c

-- 
2.11.0

