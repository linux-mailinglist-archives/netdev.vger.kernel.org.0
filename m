Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D622E1FECDE
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 09:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgFRHue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 03:50:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20306 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbgFRHua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 03:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592466629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2A/jxBVRlCvpxw6KvcEULNQ+siheljXGsGau8ZdJbAc=;
        b=dZcuIgnoCX1AWcTEeiKc/p0H1P4h28Et2u7+7fghRQPGBlHJgf2Oz6uUKyWiWMZGrcIvmr
        ADQhwxLCS1sAv7ciFzA+n3m4wm90lvS5j8RTfzHAD8Dj/ThsFNs4mAkSh09VF+J17GnORK
        O5NXEjNOiz80Je3l9GBQ2NmKqJeBh9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-hj4D8fq7McKLaUjgsK-eBQ-1; Thu, 18 Jun 2020 03:50:25 -0400
X-MC-Unique: hj4D8fq7McKLaUjgsK-eBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2BC98018A2;
        Thu, 18 Jun 2020 07:50:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6E961C4;
        Thu, 18 Jun 2020 07:50:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/3] rxrpc: Fix trace string
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 18 Jun 2020 08:50:22 +0100
Message-ID: <159246662205.1229328.12018907148087778303.stgit@warthog.procyon.org.uk>
In-Reply-To: <159246661514.1229328.4419873299996950969.stgit@warthog.procyon.org.uk>
References: <159246661514.1229328.4419873299996950969.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trace symbol printer (__print_symbolic()) ignores symbols that map to
an empty string and prints the hex value instead.

Fix the symbol for rxrpc_cong_no_change to " -" instead of "" to avoid
this.

Fixes: b54a134a7de4 ("rxrpc: Fix handling of enums-to-string translation in tracing")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index ba9efdc848f9..059b6e45a028 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -400,7 +400,7 @@ enum rxrpc_tx_point {
 	EM(rxrpc_cong_begin_retransmission,	" Retrans") \
 	EM(rxrpc_cong_cleared_nacks,		" Cleared") \
 	EM(rxrpc_cong_new_low_nack,		" NewLowN") \
-	EM(rxrpc_cong_no_change,		"") \
+	EM(rxrpc_cong_no_change,		" -") \
 	EM(rxrpc_cong_progress,			" Progres") \
 	EM(rxrpc_cong_retransmit_again,		" ReTxAgn") \
 	EM(rxrpc_cong_rtt_window_end,		" RttWinE") \


