Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF39234599
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732964AbgGaMUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:20:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32252 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732842AbgGaMUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596198046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q1GxHemLta9tnk46EHAG6lZFihPn3O2X2sG2FkkYf7c=;
        b=Rf9siPhwUxOLtWhCcBYfC5hsOzzcvAVsJfxJb7IYyggxKTcyB9u8m24GuYJJUmCz0AKNDa
        1U2fs5n6cWL2iwn2PMGzCYHcneAr/kK7H4I3R/5I/CA/F+7LonFbeFI6ezo34yvHSCc5Dj
        37ItkbuuSvOs7mCAbsJ/OmbsV+XVQTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-yXUT_v4LPluTZe1lw5BIPA-1; Fri, 31 Jul 2020 08:20:42 -0400
X-MC-Unique: yXUT_v4LPluTZe1lw5BIPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E497107ACCA;
        Fri, 31 Jul 2020 12:20:40 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-114-26.ams2.redhat.com [10.36.114.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E7EE7C0F1;
        Fri, 31 Jul 2020 12:20:38 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, fw@strlen.de,
        xiangxia.m.yue@gmail.com
Subject: [PATCH net-next v4 0/2] net: openvswitch: masks cache enhancements
Date:   Fri, 31 Jul 2020 14:20:34 +0200
Message-Id: <159619801209.973760.834607259658375498.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds two enhancements to the Open vSwitch masks cache.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Changes in v4 [patch 2/2 only]:
 - Remove null check before calling free_percpu()
 - Make ovs_dp_change() return appropriate error codes

Changes in v3 [patch 2/2 only]:
 - Use is_power_of_2() function
 - Use array_size() function
 - Fix remaining sparse errors

Changes in v2 [patch 2/2 only]:
 - Fix sparse warnings
 - Fix netlink policy items reported by Florian Westphal

Eelco Chaudron (2):
      net: openvswitch: add masks cache hit counter
      net: openvswitch: make masks cache size configurable


 include/uapi/linux/openvswitch.h |    3 +
 net/openvswitch/datapath.c       |   22 +++++++
 net/openvswitch/datapath.h       |    3 +
 net/openvswitch/flow_table.c     |  120 ++++++++++++++++++++++++++++++++------
 net/openvswitch/flow_table.h     |   13 +++-
 5 files changed, 139 insertions(+), 22 deletions(-)

