Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45EA2189839
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgCRJod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:44:33 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51658 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727604AbgCRJn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:43:58 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9hoqn012819;
        Wed, 18 Mar 2020 11:43:50 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id A1E8F36032A; Wed, 18 Mar 2020 11:43:50 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 00/28]: Accurate ECN for TCP
Date:   Wed, 18 Mar 2020 11:43:04 +0200
Message-Id: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Here's the full Accurate ECN implementation mostly based on
  https://tools.ietf.org/html/draft-ietf-tcpm-accurate-ecn-11

Comments would be highly appreciated. The GSO/TSO maze of bits
in particular is something I'm somewhat unsure if I got it
right (for a feature that has a software fallback).

There is an extensive set of packetdrill unit tests for most of
the functionality (I'll send separately to packetdrill).

Please note that this submission is not yet intented to be
included to net-next because some small changes seem still
possible to the spec.

 Documentation/networking/ip-sysctl.txt |  12 +-
 drivers/net/tun.c                      |   3 +-
 include/linux/netdev_features.h        |   3 +
 include/linux/skbuff.h                 |   2 +
 include/linux/tcp.h                    |  19 ++
 include/net/tcp.h                      | 221 ++++++++++---
 include/uapi/linux/tcp.h               |   9 +-
 net/ethtool/common.c                   |   1 +
 net/ipv4/bpf_tcp_ca.c                  |   2 +-
 net/ipv4/syncookies.c                  |  12 +
 net/ipv4/tcp.c                         |  10 +-
 net/ipv4/tcp_dctcp.c                   |   2 +-
 net/ipv4/tcp_dctcp.h                   |   2 +-
 net/ipv4/tcp_input.c                   | 558 ++++++++++++++++++++++++++++-----
 net/ipv4/tcp_ipv4.c                    |   8 +-
 net/ipv4/tcp_minisocks.c               |  84 ++++-
 net/ipv4/tcp_offload.c                 |  11 +-
 net/ipv4/tcp_output.c                  | 298 +++++++++++++++---
 net/ipv4/tcp_timer.c                   |   4 +-
 net/ipv6/syncookies.c                  |   1 +
 net/ipv6/tcp_ipv6.c                    |   4 +-
 net/netfilter/nf_log_common.c          |   4 +-

--
 i.   

ps. My apologies if you got a duplicate copy of them. It seems that
answering "no" to git send-email asking "Send this email?" might
still have sent something out.

