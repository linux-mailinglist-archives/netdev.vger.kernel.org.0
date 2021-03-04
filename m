Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF2832DB86
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbhCDU7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 15:59:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236311AbhCDU7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 15:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614891457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=994d8GKfpytM/+tWkfNH21k4NVu/b8FCDhuDF+3piaE=;
        b=QDk0bOAaiWhJefe75OIGfKe+H9ALjzherLXKov3fCVFYdnKa22dl3BqSi4l9rglHI0COl4
        dGM6qqGsV+E0GeAL1XkFnJAHf1UHC8L1442D9Y0O5Ke1OXmqsajZzW+XaXjMx70bxnHLbs
        7WNEKYh2LwobuFecnGyVgqWHQ3ub6RY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-gM63jOFsM3ibNM9VZb931Q-1; Thu, 04 Mar 2021 15:57:34 -0500
X-MC-Unique: gM63jOFsM3ibNM9VZb931Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1AF0E5760;
        Thu,  4 Mar 2021 20:57:33 +0000 (UTC)
Received: from carbon.redhat.com (unknown [10.10.115.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC5C25C1A1;
        Thu,  4 Mar 2021 20:57:32 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     pablo@netfilter.org
Cc:     fw@strlen.de, netdev@vger.kernel.org, linux-man@vger.kernel.org,
        teigland@redhat.com
Subject: [PATCH resend] netlink.7: note not reliable if NETLINK_NO_ENOBUFS
Date:   Thu,  4 Mar 2021 15:57:28 -0500
Message-Id: <20210304205728.34477-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a note to the netlink manpage that if NETLINK_NO_ENOBUFS
is set there is no additional handling to make netlink reliable. It just
disables the error notification. The used word "avoid" receiving ENOBUFS
errors can be interpreted that netlink tries to do some additional queue
handling to avoid that such scenario occurs at all, e.g. like zerocopy
which tries to avoid memory copy. However disable is not the right word
here as well that in some cases ENOBUFS can be still received. This
patch makes clear that there will no additional handling to put netlink
in a more reliable mode.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
resend:
 - forgot linux-man mailinglist in cc, sorry.

 man7/netlink.7 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man7/netlink.7 b/man7/netlink.7
index c69bb62bf..2cb0d1a55 100644
--- a/man7/netlink.7
+++ b/man7/netlink.7
@@ -478,7 +478,7 @@ errors.
 .\"	Author: Pablo Neira Ayuso <pablo@netfilter.org>
 This flag can be used by unicast and broadcast listeners to avoid receiving
 .B ENOBUFS
-errors.
+errors. Note it does not turn netlink into any kind of more reliable mode.
 .TP
 .BR NETLINK_LISTEN_ALL_NSID " (since Linux 4.2)"
 .\"	commit 59324cf35aba5336b611074028777838a963d03b
-- 
2.26.2

