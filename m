Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5D482103
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242387AbhLaAgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242380AbhLaAgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:36:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8939C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 16:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11A6FB81CFF
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FFCC36AEA;
        Fri, 31 Dec 2021 00:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640910999;
        bh=3rEmkuADbkwirw8bmvnzoqfNlenJRDBXtIh8oRkoS+Y=;
        h=From:To:Cc:Subject:Date:From;
        b=b15+xJhZFEHvmrfwzdyHDz1UWTeoHQ+sP+d0L594J1H/YczfmfOdm99Kw+tbBXcaT
         8YZ45sEONQO03yhf9ZAGjMW0WaVoDY8kts82xxzTdmz5g2oXvgluC49WItbxSQzzb2
         odJOhmm9AH0ZSWajSY1Z/hhXCmGUIhcr0jqU+IYzeSiJByxctE1yi64v+rC27Mhgm+
         OeCFEpD6yA75GFbMtHmkRIG+zPC6WA6rAbONDkjzkNO6ClOxsfKqh+XavTJByXAKGp
         8fcm47YqwX/jL059/34eiafnKxqjjUOA7GzCLjG2qA/KtsWtylEJITKFVKq4zVy3m+
         txQOjWdRtzGbQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net 0/5] net: Length checks for attributes within multipath routes
Date:   Thu, 30 Dec 2021 17:36:30 -0700
Message-Id: <20211231003635.91219-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add length checks for attributes within a multipath route (attributes
within RTA_MULTIPATH). Motivated by the syzbot report in patch 1 and
then expanded to other attributes as noted by Ido.

David Ahern (5):
  ipv4: Check attribute length for RTA_GATEWAY in multipath route
  ipv4: Check attribute length for RTA_FLOW in multipath route
  ipv6: Check attribute length for RTA_GATEWAY in multipath route
  ipv6: Check attribute length for RTA_GATEWAY when deleting multipath
    route
  lwtunnel: Validate RTA_ENCAP_TYPE attribute is at least 2 bytes

 net/core/lwtunnel.c      |  4 ++++
 net/ipv4/fib_semantics.c | 49 +++++++++++++++++++++++++++++++++++-----
 net/ipv6/route.c         | 31 +++++++++++++++++++++++--
 3 files changed, 76 insertions(+), 8 deletions(-)

-- 
2.24.3 (Apple Git-128)

