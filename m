Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758E4253560
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgHZQtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:49:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50259 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726739AbgHZQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:49:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E90FC5C00F2;
        Wed, 26 Aug 2020 12:49:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Aug 2020 12:49:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7Mo+jNvfVeiHKLsxr
        c/gOYMW9pT2LGc6993UvqRhSVk=; b=Dgt61rOaDFng4gyC+h5UxO3+2y8IpTCVa
        zhG5n3CAKU1QLdnsvJrCqmynoOpl5Kn2mB/t3jv9VQuq/zB47dCGuT4/8yxaxQRc
        P9+I/WVGuMNSFAsCvaQ4rBMtiR/3rCsNCsRfnkTpIPcMdkmo892NhZ8an1uhwqI+
        Mg+boaVviNi9ljyG2L8KuTEJ0HQI4QHMv1rGmBoWzY0cvh+HL8EvV5+jGhNGpr6V
        Ro89WuzH1nL6cQTkEQezemHsR+fHWTy/8aaWrhPTYolpSjxhtU6oufLpe34BqA0B
        8Hg4GUQa9t3aoVMj3twt/CdAJc0SG13ik7UMeffSt4RrNhGZinRbA==
X-ME-Sender: <xms:j5JGX--OJbGm7mfinQCsgsAWKCIT19AbynWt9RC9FtMNmS4oPgtWYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdefjedrudeikeen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:j5JGX-uxsnmPN7eWuxSaL5dD97ExjESUrocWLf_LK2R6wfL4zTjOpQ>
    <xmx:j5JGX0A78yLGMDpMQZVzVS7FZhmZcwws6F2_YlcSrAdLI9KbcqUyFQ>
    <xmx:j5JGX2cmr8xF_tNbAIoSfEry8iGj8YRTr07kv_ZTthA0sO5MW65MKw>
    <xmx:j5JGX533p8yUKNGQcZjOt8kx_gQQ_2rD4B_lIXCRRmxI6OVEcd1UzA>
Received: from shredder.mtl.com (igld-84-229-37-168.inter.net.il [84.229.37.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D8673280059;
        Wed, 26 Aug 2020 12:49:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/7] ipv4: nexthop: Various improvements
Date:   Wed, 26 Aug 2020 19:48:50 +0300
Message-Id: <20200826164857.1029764-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set contains various improvements that I made to the nexthop
object code while studying it towards my upcoming changes.

While patches #4 and #6 fix bugs, they are not regressions (never
worked). They also do not occur to me as critical issues, which is why I
am targeting them at net-next.

Tested with fib_nexthops.sh:

Tests passed: 134
Tests failed:   0

Ido Schimmel (7):
  ipv4: nexthop: Reduce allocation size of 'struct nh_group'
  ipv4: nexthop: Use nla_put_be32() for NHA_GATEWAY
  ipv4: nexthop: Remove unnecessary rtnl_dereference()
  ipv4: nexthop: Correctly update nexthop group when removing a nexthop
  selftests: fib_nexthops: Test IPv6 route with group after removing
    IPv4 nexthops
  ipv4: nexthop: Correctly update nexthop group when replacing a nexthop
  selftests: fib_nexthops: Test IPv6 route with group after replacing
    IPv4 nexthops

 net/ipv4/nexthop.c                          | 49 ++++++++++++++++++---
 tools/testing/selftests/net/fib_nexthops.sh | 30 +++++++++++++
 2 files changed, 72 insertions(+), 7 deletions(-)

-- 
2.26.2

