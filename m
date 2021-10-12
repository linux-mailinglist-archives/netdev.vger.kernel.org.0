Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C029542A86C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbhJLPlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:41:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237480AbhJLPlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 11:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634053185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DADMSDrfSTUjb5Z+Gu5DHjCPzPYN94C6qVp0VW+b7Jg=;
        b=ASdyunB65kMyxYMf7DQw+NGTfeWUNzG/ddZUE551tE5TDqu34VtyjANn1cJJ51R6kTHA9B
        3tQFApzlCM1/gISu6iU/eO0ascIs8rXQVb18qof1UcA8aFpOJacoJoC91eCuCYr2F5FAyu
        F4l6c6FcJ9QAQGjYcbefK+CYabDszCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-yzbCXH5OPAOTgADtH4A3Lg-1; Tue, 12 Oct 2021 11:39:41 -0400
X-MC-Unique: yzbCXH5OPAOTgADtH4A3Lg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFB1C801AE3;
        Tue, 12 Oct 2021 15:39:40 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98D0060C82;
        Tue, 12 Oct 2021 15:39:39 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, mptcp@lists.linux.dev
Subject: [PATCH iproute2-next] mptcp: cleanup include section.
Date:   Tue, 12 Oct 2021 17:39:05 +0200
Message-Id: <30bdb5729425940823e87450c29bfdcff918d62e.1634053020.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

David reported ipmptcp breaks hard the build when updating the
relevant kernel headers.

We should be more careful in the header section, explicitly
including all the required dependencies respecting the usual order
between systems and local headers.

Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
Notes:
- sorry for the long turn-around time
- all English errors added by me
- I [mis]understood Stephen's patch was the preferred one, and I took
  the liberty to send the patch on his behalf. Please educate me if
  I somewhat screwed-up this badly
---
 ip/ipmptcp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index fd042da8..0f5b6e2d 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -1,17 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <arpa/inet.h>
+#include <netinet/in.h>
+#include <stdbool.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
-#include <rt_names.h>
-#include <errno.h>
 
 #include <linux/genetlink.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
 #include <linux/mptcp.h>
 
 #include "utils.h"
 #include "ip_common.h"
-#include "libgenl.h"
 #include "json_print.h"
+#include "libgenl.h"
+#include "libnetlink.h"
+#include "ll_map.h"
 
 static void usage(void)
 {
-- 
2.26.3

