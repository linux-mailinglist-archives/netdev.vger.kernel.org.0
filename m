Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2388FD94A6
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 17:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391234AbfJPPBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 11:01:00 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:49490 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388424AbfJPPBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 11:01:00 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id D773D3303C8;
        Wed, 16 Oct 2019 17:00:57 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1iKknJ-00080Q-Po; Wed, 16 Oct 2019 17:00:57 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2 2/2] ip-netns.8: document target-nsid and nsid options of list-id
Date:   Wed, 16 Oct 2019 17:00:52 +0200
Message-Id: <20191016150052.30695-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016150052.30695-1-nicolas.dichtel@6wind.com>
References: <20191016150052.30695-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up of the commit eaefb07804a1 ("ipnetns: enable to dump
nsid conversion table").

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 man/man8/ip-netns.8 | 48 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/man/man8/ip-netns.8 b/man/man8/ip-netns.8
index 961bcf03f609..c75917dac8b1 100644
--- a/man/man8/ip-netns.8
+++ b/man/man8/ip-netns.8
@@ -51,6 +51,7 @@ ip-netns \- process network namespace management
 
 .ti -8
 .BR "ip netns list-id"
+.RI "[ target-nsid " POSITIVE-INT " ] [ nsid " POSITIVE-INT " ]"
 
 .SH DESCRIPTION
 A network namespace is logically another copy of the network stack,
@@ -196,12 +197,28 @@ This command watches network namespace name addition and deletion events
 and prints a line for each event it sees.
 
 .TP
-.B ip netns list-id - list network namespace ids (nsid)
+.B ip netns list-id [target-nsid POSITIVE-INT] [nsid POSITIVE-INT] - list network namespace ids (nsid)
 .sp
 Network namespace ids are used to identify a peer network namespace. This
-command displays nsid of the current network namespace and provides the
+command displays nsids of the current network namespace and provides the
 corresponding iproute2 netns name (from /var/run/netns) if any.
 
+The
+.B target-nsid
+option enables to display nsids of the specified network namespace instead of the current network
+namespace. This
+.B target-nsid
+is a nsid from the current network namespace.
+
+The
+.B nsid
+option enables to display only this nsid. It is a nsid from the current network namespace. In
+combination with the
+.B target-nsid
+option, it enables to convert a specific nsid from the current network namespace to a nsid of the
+.B target-nsid
+network namespace.
+
 .SH EXAMPLES
 .PP
 ip netns list
@@ -218,6 +235,31 @@ ip netns exec vpn ip link set lo up
 .RS
 Bring up the loopback interface in the vpn network namespace.
 .RE
+.PP
+ip netns add foo
+.br
+ip netns add bar
+.br
+ip netns set foo 12
+.br
+ip netns set bar 13
+.br
+ip -n foo netns set foo 22
+.br
+ip -n foo netns set bar 23
+.br
+ip -n bar netns set foo 32
+.br
+ip -n bar netns set bar 33
+.br
+ip netns list-id target-nsid 12
+.RS
+Shows the list of nsids from the network namespace foo.
+.RE
+ip netns list-id target-nsid 12 nsid 13
+.RS
+Get nsid of bar from the network namespace foo (result is 23).
+.RE
 
 .SH SEE ALSO
 .br
@@ -225,3 +267,5 @@ Bring up the loopback interface in the vpn network namespace.
 
 .SH AUTHOR
 Original Manpage by Eric W. Biederman
+.br
+Manpage revised by Nicolas Dichtel <nicolas.dichtel@6wind.com>
-- 
2.23.0

