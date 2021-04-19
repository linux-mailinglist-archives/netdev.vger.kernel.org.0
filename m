Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C56B364D07
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhDSV0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhDSV0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 17:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28B806135F;
        Mon, 19 Apr 2021 21:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618867585;
        bh=z+ca5OH6+sC/vpxXib2Cy0WrzYzkENCE1cWg4cbG+wQ=;
        h=From:To:Cc:Subject:Date:From;
        b=TeMrzs8gWdiqAp/1Ft6DmigNJroRM42O1PFThZKHjCAYctliiAeTXB+pw/uGzM8Tb
         gyyGsUfid1nKbdIO7SqquaVNlCiM/qtE9E0C38I9twkIMP18pLvl5FgQ9LtqTTTxO9
         Pl/NgDuuinZ59KJBUpSGprW9L71reQHxZp5BF2gKyfxjw/FFwg/MMq8qA7N5LMhk/a
         KoxrvM6db79zq2z5Bo3Xnu8uSE3p8Mqr0rTHwcBHmEMFqZbI6IET6OaYq4swhWIGGt
         C00THBhKpKqT6MORAOLGxcIxqvJmfUz+H4iW8fauc4C7J37X8iGFSU5UWwZ+sY/txr
         00d0gStpAsW5w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, vladyslavt@nvidia.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ethtool: add missing EEPROM to list of messages
Date:   Mon, 19 Apr 2021 14:26:22 -0700
Message-Id: <20210419212622.2993451-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETHTOOL_MSG_MODULE_EEPROM_GET is missing from the list of messages.
ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY is sadly a rather long name
so we need to adjust column length.

Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 70 ++++++++++----------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 48cad2fce147..c8814d787072 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -210,45 +210,47 @@ All constants identifying message types use ``ETHTOOL_CMD_`` prefix and suffix
   ``ETHTOOL_MSG_TUNNEL_INFO_GET``       get tunnel offload info
   ``ETHTOOL_MSG_FEC_GET``               get FEC settings
   ``ETHTOOL_MSG_FEC_SET``               set FEC settings
+  ``ETHTOOL_MSG_MODULE_EEPROM_GET``	read SFP module EEPROM
   ``ETHTOOL_MSG_STATS_GET``             get standard statistics
   ===================================== ================================
 
 Kernel to userspace:
 
-  ===================================== =================================
-  ``ETHTOOL_MSG_STRSET_GET_REPLY``      string set contents
-  ``ETHTOOL_MSG_LINKINFO_GET_REPLY``    link settings
-  ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
-  ``ETHTOOL_MSG_LINKMODES_GET_REPLY``   link modes info
-  ``ETHTOOL_MSG_LINKMODES_NTF``         link modes notification
-  ``ETHTOOL_MSG_LINKSTATE_GET_REPLY``   link state info
-  ``ETHTOOL_MSG_DEBUG_GET_REPLY``       debugging settings
-  ``ETHTOOL_MSG_DEBUG_NTF``             debugging settings notification
-  ``ETHTOOL_MSG_WOL_GET_REPLY``         wake-on-lan settings
-  ``ETHTOOL_MSG_WOL_NTF``               wake-on-lan settings notification
-  ``ETHTOOL_MSG_FEATURES_GET_REPLY``    device features
-  ``ETHTOOL_MSG_FEATURES_SET_REPLY``    optional reply to FEATURES_SET
-  ``ETHTOOL_MSG_FEATURES_NTF``          netdev features notification
-  ``ETHTOOL_MSG_PRIVFLAGS_GET_REPLY``   private flags
-  ``ETHTOOL_MSG_PRIVFLAGS_NTF``         private flags
-  ``ETHTOOL_MSG_RINGS_GET_REPLY``       ring sizes
-  ``ETHTOOL_MSG_RINGS_NTF``             ring sizes
-  ``ETHTOOL_MSG_CHANNELS_GET_REPLY``    channel counts
-  ``ETHTOOL_MSG_CHANNELS_NTF``          channel counts
-  ``ETHTOOL_MSG_COALESCE_GET_REPLY``    coalescing parameters
-  ``ETHTOOL_MSG_COALESCE_NTF``          coalescing parameters
-  ``ETHTOOL_MSG_PAUSE_GET_REPLY``       pause parameters
-  ``ETHTOOL_MSG_PAUSE_NTF``             pause parameters
-  ``ETHTOOL_MSG_EEE_GET_REPLY``         EEE settings
-  ``ETHTOOL_MSG_EEE_NTF``               EEE settings
-  ``ETHTOOL_MSG_TSINFO_GET_REPLY``	timestamping info
-  ``ETHTOOL_MSG_CABLE_TEST_NTF``        Cable test results
-  ``ETHTOOL_MSG_CABLE_TEST_TDR_NTF``    Cable test TDR results
-  ``ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY`` tunnel offload info
-  ``ETHTOOL_MSG_FEC_GET_REPLY``         FEC settings
-  ``ETHTOOL_MSG_FEC_NTF``               FEC settings
-  ``ETHTOOL_MSG_STATS_GET_REPLY``       standard statistics
-  ===================================== =================================
+  ======================================== =================================
+  ``ETHTOOL_MSG_STRSET_GET_REPLY``         string set contents
+  ``ETHTOOL_MSG_LINKINFO_GET_REPLY``       link settings
+  ``ETHTOOL_MSG_LINKINFO_NTF``             link settings notification
+  ``ETHTOOL_MSG_LINKMODES_GET_REPLY``      link modes info
+  ``ETHTOOL_MSG_LINKMODES_NTF``            link modes notification
+  ``ETHTOOL_MSG_LINKSTATE_GET_REPLY``      link state info
+  ``ETHTOOL_MSG_DEBUG_GET_REPLY``          debugging settings
+  ``ETHTOOL_MSG_DEBUG_NTF``                debugging settings notification
+  ``ETHTOOL_MSG_WOL_GET_REPLY``            wake-on-lan settings
+  ``ETHTOOL_MSG_WOL_NTF``                  wake-on-lan settings notification
+  ``ETHTOOL_MSG_FEATURES_GET_REPLY``       device features
+  ``ETHTOOL_MSG_FEATURES_SET_REPLY``       optional reply to FEATURES_SET
+  ``ETHTOOL_MSG_FEATURES_NTF``             netdev features notification
+  ``ETHTOOL_MSG_PRIVFLAGS_GET_REPLY``      private flags
+  ``ETHTOOL_MSG_PRIVFLAGS_NTF``            private flags
+  ``ETHTOOL_MSG_RINGS_GET_REPLY``          ring sizes
+  ``ETHTOOL_MSG_RINGS_NTF``                ring sizes
+  ``ETHTOOL_MSG_CHANNELS_GET_REPLY``       channel counts
+  ``ETHTOOL_MSG_CHANNELS_NTF``             channel counts
+  ``ETHTOOL_MSG_COALESCE_GET_REPLY``       coalescing parameters
+  ``ETHTOOL_MSG_COALESCE_NTF``             coalescing parameters
+  ``ETHTOOL_MSG_PAUSE_GET_REPLY``          pause parameters
+  ``ETHTOOL_MSG_PAUSE_NTF``                pause parameters
+  ``ETHTOOL_MSG_EEE_GET_REPLY``            EEE settings
+  ``ETHTOOL_MSG_EEE_NTF``                  EEE settings
+  ``ETHTOOL_MSG_TSINFO_GET_REPLY``         timestamping info
+  ``ETHTOOL_MSG_CABLE_TEST_NTF``           Cable test results
+  ``ETHTOOL_MSG_CABLE_TEST_TDR_NTF``       Cable test TDR results
+  ``ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY``    tunnel offload info
+  ``ETHTOOL_MSG_FEC_GET_REPLY``            FEC settings
+  ``ETHTOOL_MSG_FEC_NTF``                  FEC settings
+  ``ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY``  read SFP module EEPROM
+  ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
+  ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
 information. They usually do not contain any message specific attributes.
-- 
2.30.2

