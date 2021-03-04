Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60E732DB7B
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 21:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhCDU4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 15:56:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230413AbhCDU4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 15:56:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614891325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wiNB48VlHfTqbkkh69Ka2ojMNQandCOUab0VuYZf6k0=;
        b=AJnJHBYCDebBKvn5+5YmOCWhFBzFa6dVDEEIVTF0Mh5I069lPbz7oc2Ug+bTz0nU2U7lpF
        UsjkgJ2QLhSPjrwNU/g8QXNfjpIDuG7VkbyR7lZvK7tQPLEXfXfAy4MKuhIF/yxKrWzmgB
        0iSzSpNEP1rAFur+y3kXy/I73pWMz6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-dE1ZLy3eN6iS3Mf2tyFAuQ-1; Thu, 04 Mar 2021 15:55:23 -0500
X-MC-Unique: dE1ZLy3eN6iS3Mf2tyFAuQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C54FA108BD06;
        Thu,  4 Mar 2021 20:55:22 +0000 (UTC)
Received: from carbon.redhat.com (unknown [10.10.115.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B53CD5C1A1;
        Thu,  4 Mar 2021 20:55:21 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     pablo@netfilter.org
Cc:     fw@strlen.de, netdev@vger.kernel.org, teigland@redhat.com
Subject: [PATCH] netlink.7: note not reliable if NETLINK_NO_ENOBUFS
Date:   Thu,  4 Mar 2021 15:55:15 -0500
Message-Id: <20210304205515.34262-1-aahringo@redhat.com>
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

