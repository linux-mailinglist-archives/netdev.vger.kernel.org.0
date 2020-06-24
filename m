Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B92206944
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 03:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388175AbgFXBC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 21:02:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgFXBCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 21:02:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jntnq-001woX-RQ; Wed, 24 Jun 2020 03:02:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v1 5/6] ethtool.8.in: Document the cable test commands
Date:   Wed, 24 Jun 2020 03:01:54 +0200
Message-Id: <20200624010155.464334-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200624010155.464334-1-andrew@lunn.ch>
References: <20200624010155.464334-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the man page with --cable-test and --cable-test-tdr commands.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 ethtool.8.in | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 9c5f45c..9e2017d 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -434,6 +434,16 @@ ethtool \- query or control network driver and hardware settings
 .I sub_command
 .RB ...
  .
+.HP
+.B ethtool \-\-cable\-test
+.I devname
+.HP
+.B ethtool \-\-cable\-test\-tdr
+.I devname
+.BN first N
+.BN last N
+.BN step N
+.BN pair N
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -1277,6 +1287,41 @@ Sub command to apply. The supported sub commands include --show-coalesce and
 --coalesce.
 .RE
 .TP
+q.B \-\-cable\-test
+Perform a cable test and report the results. What results are returned depends
+on the capabilities of the network interface. Typically open pairs and shorted
+pair can be reported, along with pairs being O.K. When a fault is detected
+the approximate distance to the fault me be reported.
+.TP
+.B \-\-cable\-test\-tdr
+Perform a cable test and report the raw Time Domain Reflectometer
+data.  A pulse is sent down a cable pair and the amplitude of the
+reflect, for a given distance is reported. A break in the cable
+returns a big reflection. Minor damage to the cable returns a small
+deflection. If the cable is shorted, the amplitude of the reflection
+can be negative. By default, data is returned for lengths between 0
+and 150m at 1m steps, for all pairs. However parameters can be passed
+to restrict the collection of data. It should be noted, that the
+interface will round the distances to whatever granularity is actually
+implements. This is often 0.8 of a meter. The results should include
+the actual rounded first and last distance and step size.
+.RS 4
+.TP
+.B first \ N
+Distance along the cable, in meters, where the first measurement
+should be made.
+.TP
+.B last \ N
+Distance along the cable, in meters, where the last measurement should
+be made.
+.TP
+.B step \ N
+Distance, in meters, between each measurement.
+.TP
+.B pair \ N
+Which pair should be measured. Typically a cable has 4 pairs. 0 = Pair A, 1 = Pair B, ...
+.RE
+.TP
 .B \-\-monitor
 Listens to netlink notification and displays them.
 .RS 4
-- 
2.26.2

