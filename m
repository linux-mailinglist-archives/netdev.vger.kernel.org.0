Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C19B1C0192
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgD3QG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27BFD24963;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=+k2ZI+83OqAv8SgP/rHh8+y4ELKKcvrshRN7zFngHYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/BEeEmpqRnOcvdGABiLIRLxrXFqnPlXXZG/MFY+kDtHENeg5rFQseDf8nDz9A1wX
         inWAWNLAzBhizetP8QtoWMzNejg8HjlpRkfRj071V1NBVxIQnFHBX/fYTEC1w0v78I
         LBCblgg48z61suaBtuHuuObh/6tYt9vhW9xClUm0=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxFI-CT; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 15/37] docs: networking: convert operstates.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:10 +0200
Message-Id: <aca46c2bc16a33b9da2f1943edf520baf72c508b.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- adjust chapters, adding proper markups;
- mark lists as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../{operstates.txt => operstates.rst}        | 45 ++++++++++++++-----
 2 files changed, 34 insertions(+), 12 deletions(-)
 rename Documentation/networking/{operstates.txt => operstates.rst} (87%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index b7f558480aca..028a36821b9a 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -88,6 +88,7 @@ Contents:
    nf_conntrack-sysctl
    nf_flowtable
    openvswitch
+   operstates
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/operstates.txt b/Documentation/networking/operstates.rst
similarity index 87%
rename from Documentation/networking/operstates.txt
rename to Documentation/networking/operstates.rst
index b203d1334822..9c918f7cb0e8 100644
--- a/Documentation/networking/operstates.txt
+++ b/Documentation/networking/operstates.rst
@@ -1,5 +1,12 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================
+Operational States
+==================
+
 
 1. Introduction
+===============
 
 Linux distinguishes between administrative and operational state of an
 interface. Administrative state is the result of "ip link set dev
@@ -20,6 +27,7 @@ and changeable from userspace under certain rules.
 
 
 2. Querying from userspace
+==========================
 
 Both admin and operational state can be queried via the netlink
 operation RTM_GETLINK. It is also possible to subscribe to RTNLGRP_LINK
@@ -30,16 +38,20 @@ These values contain interface state:
 
 ifinfomsg::if_flags & IFF_UP:
  Interface is admin up
+
 ifinfomsg::if_flags & IFF_RUNNING:
  Interface is in RFC2863 operational state UP or UNKNOWN. This is for
  backward compatibility, routing daemons, dhcp clients can use this
  flag to determine whether they should use the interface.
+
 ifinfomsg::if_flags & IFF_LOWER_UP:
  Driver has signaled netif_carrier_on()
+
 ifinfomsg::if_flags & IFF_DORMANT:
  Driver has signaled netif_dormant_on()
 
 TLV IFLA_OPERSTATE
+------------------
 
 contains RFC2863 state of the interface in numeric representation:
 
@@ -47,26 +59,33 @@ IF_OPER_UNKNOWN (0):
  Interface is in unknown state, neither driver nor userspace has set
  operational state. Interface must be considered for user data as
  setting operational state has not been implemented in every driver.
+
 IF_OPER_NOTPRESENT (1):
  Unused in current kernel (notpresent interfaces normally disappear),
  just a numerical placeholder.
+
 IF_OPER_DOWN (2):
  Interface is unable to transfer data on L1, f.e. ethernet is not
  plugged or interface is ADMIN down.
+
 IF_OPER_LOWERLAYERDOWN (3):
  Interfaces stacked on an interface that is IF_OPER_DOWN show this
  state (f.e. VLAN).
+
 IF_OPER_TESTING (4):
  Unused in current kernel.
+
 IF_OPER_DORMANT (5):
  Interface is L1 up, but waiting for an external event, f.e. for a
  protocol to establish. (802.1X)
+
 IF_OPER_UP (6):
  Interface is operational up and can be used.
 
 This TLV can also be queried via sysfs.
 
 TLV IFLA_LINKMODE
+-----------------
 
 contains link policy. This is needed for userspace interaction
 described below.
@@ -75,6 +94,7 @@ This TLV can also be queried via sysfs.
 
 
 3. Kernel driver API
+====================
 
 Kernel drivers have access to two flags that map to IFF_LOWER_UP and
 IFF_DORMANT. These flags can be set from everywhere, even from
@@ -126,6 +146,7 @@ netif_carrier_ok() && !netif_dormant():
 
 
 4. Setting from userspace
+=========================
 
 Applications have to use the netlink interface to influence the
 RFC2863 operational state of an interface. Setting IFLA_LINKMODE to 1
@@ -139,18 +160,18 @@ are multicasted on the netlink group RTNLGRP_LINK.
 
 So basically a 802.1X supplicant interacts with the kernel like this:
 
--subscribe to RTNLGRP_LINK
--set IFLA_LINKMODE to 1 via RTM_SETLINK
--query RTM_GETLINK once to get initial state
--if initial flags are not (IFF_LOWER_UP && !IFF_DORMANT), wait until
- netlink multicast signals this state
--do 802.1X, eventually abort if flags go down again
--send RTM_SETLINK to set operstate to IF_OPER_UP if authentication
- succeeds, IF_OPER_DORMANT otherwise
--see how operstate and IFF_RUNNING is echoed via netlink multicast
--set interface back to IF_OPER_DORMANT if 802.1X reauthentication
- fails
--restart if kernel changes IFF_LOWER_UP or IFF_DORMANT flag
+- subscribe to RTNLGRP_LINK
+- set IFLA_LINKMODE to 1 via RTM_SETLINK
+- query RTM_GETLINK once to get initial state
+- if initial flags are not (IFF_LOWER_UP && !IFF_DORMANT), wait until
+  netlink multicast signals this state
+- do 802.1X, eventually abort if flags go down again
+- send RTM_SETLINK to set operstate to IF_OPER_UP if authentication
+  succeeds, IF_OPER_DORMANT otherwise
+- see how operstate and IFF_RUNNING is echoed via netlink multicast
+- set interface back to IF_OPER_DORMANT if 802.1X reauthentication
+  fails
+- restart if kernel changes IFF_LOWER_UP or IFF_DORMANT flag
 
 if supplicant goes down, bring back IFLA_LINKMODE to 0 and
 IFLA_OPERSTATE to a sane value.
-- 
2.25.4

