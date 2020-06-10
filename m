Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B081F5E9C
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFJXJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgFJXJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 19:09:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E6B2078D;
        Wed, 10 Jun 2020 23:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591830549;
        bh=okre8Tv/zVQkwaAz+2jmGQukm1/T0kqeX2DAsHR1G9w=;
        h=From:To:Cc:Subject:Date:From;
        b=FCSrtWNfaZAy1yHES9sIlkKS7GZpk03nC1Quk7cjy+vHz1PYNgi1AYC+MRj5w+ZJF
         7PnUIi1dl7DHtsQ95kKwE+2jrOBE0Lay2WTJKi4BvI7DySkkU6xga2faEbnb7mgro1
         VDwwF1l+5SlOffhbOvz1Z2NYqy33zXEDrwyI2X2U=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] docs: networkng: fix lists and table in sja1105
Date:   Wed, 10 Jun 2020 16:09:06 -0700
Message-Id: <20200610230906.418826-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need an empty line before list stats, otherwise first point
will be smooshed into the paragraph. Inside tables text must
start at the same offset in the cell, otherwise sphinx thinks
it's a new indented block.

Documentation/networking/dsa/sja1105.rst:108: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/networking/dsa/sja1105.rst:112: WARNING: Definition list ends without a blank line; unexpected unindent.
Documentation/networking/dsa/sja1105.rst:245: WARNING: Unexpected indentation.
Documentation/networking/dsa/sja1105.rst:246: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/networking/dsa/sja1105.rst:253: WARNING: Unexpected indentation.
Documentation/networking/dsa/sja1105.rst:254: WARNING: Block quote ends without a blank line; unexpected unindent.

Fixes: a20bc43bfb2e ("docs: net: dsa: sja1105: document the best_effort_vlan_filtering option")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/dsa/sja1105.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index b6bbc17814fb..7395a33baaf9 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -103,11 +103,11 @@ To summarize, in each mode, the following types of traffic are supported over
 +-------------+-----------+--------------+------------+
 |             |   Mode 1  |    Mode 2    |   Mode 3   |
 +=============+===========+==============+============+
-|   Regular   |    Yes    |      No      |     Yes    |
+|   Regular   |    Yes    | No           |     Yes    |
 |   traffic   |           | (use master) |            |
 +-------------+-----------+--------------+------------+
 | Management  |    Yes    |     Yes      |     Yes    |
-|   traffic   |           |              |            |
+| traffic     |           |              |            |
 | (BPDU, PTP) |           |              |            |
 +-------------+-----------+--------------+------------+
 
@@ -241,6 +241,7 @@ switch.
 
 In this case, SJA1105 switch 1 consumes a total of 11 retagging entries, as
 follows:
+
 - 8 retagging entries for VLANs 1 and 100 installed on its user ports
   (``sw1p0`` - ``sw1p3``)
 - 3 retagging entries for VLAN 100 installed on the user ports of SJA1105
@@ -249,6 +250,7 @@ In this case, SJA1105 switch 1 consumes a total of 11 retagging entries, as
   reverse retagging.
 
 SJA1105 switch 2 also consumes 11 retagging entries, but organized as follows:
+
 - 7 retagging entries for the bridge VLANs on its user ports (``sw2p0`` -
   ``sw2p3``).
 - 4 retagging entries for VLAN 100 installed on the user ports of SJA1105
-- 
2.26.2

