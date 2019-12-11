Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDED11C000
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLKWm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:42:59 -0500
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:58668 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbfLKWm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:42:59 -0500
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id 07F2AC11F2;
        Wed, 11 Dec 2019 14:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1576103596;
        bh=ZS2WRyLKOXyBRkQqQDTXZ1VnM0CnnpQC1oOG23RMu7c=;
        h=From:To:Cc:Subject:Date;
        b=qPT41ifa/jJudAldpS3GJJEZOlfXywhaQyfK7zt3IsWBKzXqHnENz5YSwR0VAmrsh
         16KX2hKCwBmNXPm/x93NL451Q0JZoe2L/V6DFo9hhcmLh67LNG4R3nGWtemqxEvzUY
         2J2vSmP/f9KogKvMHoLhJOwO8FjcRiCXAkAMQE9Q=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stephen@networkplumber.org
Subject: [PATCH iproute2-next v2 0/2] pretty-print 802.3ad slave state
Date:   Wed, 11 Dec 2019 14:33:13 -0800
Message-Id: <1576103595-23138-1-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print the bond slave 802.3ad state in a human-readable way.
The 802.3ad bond slave actor/partner state definitions are exported
to userspace in the kernel include/uapi (dependent on the related
patch posted to net-next)

rtnetlink sends the bond slave state to userspace, see
 - IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE; and
 - IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE

and these are only printed as numbers, e.g.,

ad_actor_oper_port_state 15

Add an additional output in ip link show that prints a string describing
the individual 3ad bit meanings.

ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>

JSON output is also supported, the field becomes a json array:

"ad_actor_oper_port_state_str":
	["active","short_timeout","aggregating","in_sync"]

These changes are dependent on a kernel change to uapi/
The following patch is the kernel change sent to net-next:
[PATCH net-next v2] bonding: move 802.3ad port state flags to uapi

v2:
 - address patch format and comments

Andy Roulin (2):
  include/uapi: update bonding kernel header
  iplink: bond: print 3ad actor/partner oper states as strings

 include/uapi/linux/if_bonding.h | 10 +++++++++
 ip/iplink_bond_slave.c          | 36 +++++++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 4 deletions(-)

-- 
2.20.1

