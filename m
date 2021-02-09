Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86483145B3
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhBIBiE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Feb 2021 20:38:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46379 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhBIBhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 20:37:52 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1l9Hxf-0001fO-On; Tue, 09 Feb 2021 01:37:03 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 0FA445FEE7; Mon,  8 Feb 2021 17:37:02 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 07F41A0411;
        Mon,  8 Feb 2021 17:37:02 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net] Documentation: networking: ip-sysctl: Document src_valid_mark sysctl
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1394.1612834621.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Mon, 08 Feb 2021 17:37:01 -0800
Message-ID: <1396.1612834621@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Provide documentation for src_valid_mark sysctl, which was added
in commit 28f6aeea3f12 ("net: restore ip source validation").

Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>

---
 Documentation/networking/ip-sysctl.rst | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index fa544e9037b9..0fb39c895c95 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1425,6 +1425,25 @@ rp_filter - INTEGER
 	Default value is 0. Note that some distributions enable it
 	in startup scripts.
 
+src_valid_mark - BOOLEAN
+	- 0 - The fwmark of the packet is not included in reverse path
+	  route lookup.  This allows for asymmetric routing configurations
+	  utilizing the fwmark in only one direction, e.g., transparent
+	  proxying.
+
+	- 1 - The fwmark of the packet is included in reverse path route
+	  lookup.  This permits rp_filter to function when the fwmark is
+	  used for routing traffic in both directions.
+
+	This setting also affects the utilization of fmwark when
+	performing source address selection for ICMP replies, or
+	determining addresses stored for the IPOPT_TS_TSANDADDR and
+	IPOPT_RR IP options.
+
+	The max value from conf/{all,interface}/src_valid_mark is used.
+
+	Default value is 0.
+
 arp_filter - BOOLEAN
 	- 1 - Allows you to have multiple network interfaces on the same
 	  subnet, and have the ARPs for each interface be answered
-- 
2.29.GIT

