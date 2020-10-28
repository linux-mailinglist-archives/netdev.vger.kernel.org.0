Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BE029DBD0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390860AbgJ2AN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390843AbgJ2ANz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZxq-003uBm-LM; Wed, 28 Oct 2020 02:09:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Gaurav Singh <gaurav1086@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: dcb: Fix kerneldoc warnings
Date:   Wed, 28 Oct 2020 02:09:13 +0100
Message-Id: <20201028010913.930929-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net//dcb/dcbnl.c:1836: warning: Function parameter or member 'app' not described in 'dcb_getapp'
net//dcb/dcbnl.c:1836: warning: Function parameter or member 'dev' not described in 'dcb_getapp'
net//dcb/dcbnl.c:1858: warning: Function parameter or member 'dev' not described in 'dcb_setapp'
net//dcb/dcbnl.c:1858: warning: Function parameter or member 'new' not described in 'dcb_setapp'
net//dcb/dcbnl.c:1899: warning: Function parameter or member 'app' not described in 'dcb_ieee_getapp_mask'
net//dcb/dcbnl.c:1899: warning: Function parameter or member 'dev' not described in 'dcb_ieee_getapp_mask'
net//dcb/dcbnl.c:1922: warning: Function parameter or member 'dev' not described in 'dcb_ieee_setapp'
net//dcb/dcbnl.c:1922: warning: Function parameter or member 'new' not described in 'dcb_ieee_setapp'
net//dcb/dcbnl.c:1953: warning: Function parameter or member 'del' not described in 'dcb_ieee_delapp'
net//dcb/dcbnl.c:1953: warning: Function parameter or member 'dev' not described in 'dcb_ieee_delapp'
net//dcb/dcbnl.c:1986: warning: Function parameter or member 'dev' not described in 'dcb_ieee_getapp_prio_dscp_mask_map'
net//dcb/dcbnl.c:1986: warning: Function parameter or member 'p_map' not described in 'dcb_ieee_getapp_prio_dscp_mask_map'
net//dcb/dcbnl.c:2016: warning: Function parameter or member 'dev' not described in 'dcb_ieee_getapp_dscp_prio_mask_map'
net//dcb/dcbnl.c:2016: warning: Function parameter or member 'p_map' not described in 'dcb_ieee_getapp_dscp_prio_mask_map'
net//dcb/dcbnl.c:2045: warning: Function parameter or member 'dev' not described in 'dcb_ieee_getapp_default_prio_mask'

For some of these warnings, change to comments to plain comments,
since no attempt is being made to follow kerneldoc syntax.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dcb/dcbnl.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 16014ad19406..084e159a12ba 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1827,6 +1827,8 @@ static int dcb_app_add(const struct dcb_app *app, int ifindex)
 
 /**
  * dcb_getapp - retrieve the DCBX application user priority
+ * @dev: network interface
+ * @app: application to get user priority of
  *
  * On success returns a non-zero 802.1p user priority bitmap
  * otherwise returns 0 as the invalid user priority bitmap to
@@ -1849,6 +1851,8 @@ EXPORT_SYMBOL(dcb_getapp);
 
 /**
  * dcb_setapp - add CEE dcb application data to app list
+ * @dev: network interface
+ * @new: application data to add
  *
  * Priority 0 is an invalid priority in CEE spec. This routine
  * removes applications from the app list if the priority is
@@ -1890,6 +1894,8 @@ EXPORT_SYMBOL(dcb_setapp);
 
 /**
  * dcb_ieee_getapp_mask - retrieve the IEEE DCB application priority
+ * @dev: network interface
+ * @app: where to store the retrieve application data
  *
  * Helper routine which on success returns a non-zero 802.1Qaz user
  * priority bitmap otherwise returns 0 to indicate the dcb_app was
@@ -1912,6 +1918,8 @@ EXPORT_SYMBOL(dcb_ieee_getapp_mask);
 
 /**
  * dcb_ieee_setapp - add IEEE dcb application data to app list
+ * @dev: network interface
+ * @new: application data to add
  *
  * This adds Application data to the list. Multiple application
  * entries may exists for the same selector and protocol as long
@@ -1946,6 +1954,8 @@ EXPORT_SYMBOL(dcb_ieee_setapp);
 
 /**
  * dcb_ieee_delapp - delete IEEE dcb application data from list
+ * @dev: network interface
+ * @del: application data to delete
  *
  * This removes a matching APP data from the APP list
  */
@@ -1975,7 +1985,7 @@ int dcb_ieee_delapp(struct net_device *dev, struct dcb_app *del)
 }
 EXPORT_SYMBOL(dcb_ieee_delapp);
 
-/**
+/*
  * dcb_ieee_getapp_prio_dscp_mask_map - For a given device, find mapping from
  * priorities to the DSCP values assigned to that priority. Initialize p_map
  * such that each map element holds a bit mask of DSCP values configured for
@@ -2004,7 +2014,7 @@ void dcb_ieee_getapp_prio_dscp_mask_map(const struct net_device *dev,
 }
 EXPORT_SYMBOL(dcb_ieee_getapp_prio_dscp_mask_map);
 
-/**
+/*
  * dcb_ieee_getapp_dscp_prio_mask_map - For a given device, find mapping from
  * DSCP values to the priorities assigned to that DSCP value. Initialize p_map
  * such that each map element holds a bit mask of priorities configured for a
@@ -2031,7 +2041,7 @@ dcb_ieee_getapp_dscp_prio_mask_map(const struct net_device *dev,
 }
 EXPORT_SYMBOL(dcb_ieee_getapp_dscp_prio_mask_map);
 
-/**
+/*
  * Per 802.1Q-2014, the selector value of 1 is used for matching on Ethernet
  * type, with valid PID values >= 1536. A special meaning is then assigned to
  * protocol value of 0: "default priority. For use when priority is not
-- 
2.28.0

