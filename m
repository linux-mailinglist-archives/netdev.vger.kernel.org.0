Return-Path: <netdev+bounces-5485-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A41447119FD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 00:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62B252815B1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 22:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8CB24EB6;
	Thu, 25 May 2023 22:09:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31487FC16
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 22:09:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A465D134
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685052561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dJeYXRBQttCVikZVDOeeK4P8EFg9Raz3eKfB/gpnZ2o=;
	b=JMbhY8QF5hP80GCFeYFlA1owkB6dj1Z674eENWv8w7foUPpo9fdUJIrDHcV+6kfZArYdpx
	5ZBRMtTBDbG3irVWgn6y1l9Y8L4UJQvNY8n+uvr+pFlkc3DCPynvAvIlMjbDMcUnGekKxt
	GhyYpRIj4aXZKNAKKpBxbpTmz7BX5vM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-nm7LPY8pOda3xPAriSf6Lw-1; Thu, 25 May 2023 18:09:18 -0400
X-MC-Unique: nm7LPY8pOda3xPAriSf6Lw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BC918007D9;
	Thu, 25 May 2023 22:09:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3FCB4202696C;
	Thu, 25 May 2023 22:09:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20230525211346.718562-1-Kenny.Ho@amd.com>
References: <20230525211346.718562-1-Kenny.Ho@amd.com>
To: Kenny Ho <Kenny.Ho@amd.com>
Cc: dhowells@redhat.com, David Laight <David.Laight@aculab.com>,
    Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
    Marc Dionne <marc.dionne@auristor.com>,
    "Kenny
 Ho" <y2kenny@gmail.com>,
    "David S.
 Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>,
    "Paolo
 Abeni" <pabeni@redhat.com>,
    "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
    "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
    alexander.deucher@amd.com
Subject: Re: [PATCH] Truncate UTS_RELEASE for rxrpc version
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <223249.1685052554.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 May 2023 23:09:14 +0100
Message-ID: <223250.1685052554@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Kenny Ho <Kenny.Ho@amd.com> wrote:

> @@ -30,6 +28,7 @@ static void rxrpc_send_version_request(struct rxrpc_lo=
cal *local,
>  	struct sockaddr_rxrpc srx;
>  	struct msghdr msg;
>  	struct kvec iov[2];
> +	static char rxrpc_version_string[65];
>  	size_t len;
>  	int ret;
>  =


That's not thread-safe.  If you have multiple endpoints each one of them c=
ould
be overwriting the string at the same time.  We can't guarantee that one
wouldn't corrupt the other.

There's also no need to reprint it every time; just once during module ini=
t
will do.  How about the attached patch instead?

David
---
rxrpc: Truncate UTS_RELEASE for rxrpc version

UTS_RELEASE has a maximum length of 64 which can cause rxrpc_version to
exceed the 65 byte message limit.

Per the rx spec[1]: "If a server receives a packet with a type value of 13=
,
and the client-initiated flag set, it should respond with a 65-byte payloa=
d
containing a string that identifies the version of AFS software it is
running."

The current implementation causes a compile error when WERROR is turned on
and/or UTS_RELEASE exceeds the length of 49 (making the version string mor=
e
than 64 characters).

Fix this by generating the string during module initialisation and limitin=
g
the UTS_RELEASE segment of the string does not exceed 49 chars.  We need t=
o
make sure that the 64 bytes includes "linux-" at the front and " AF_RXRPC"=
 at
the back as this may be used in pattern matching.

Fixes: 44ba06987c0b ("RxRPC: Handle VERSION Rx protocol packets")
Reported-by: Kenny Ho <Kenny.Ho@amd.com>
Link: https://lore.kernel.org/r/20230523223944.691076-1-Kenny.Ho@amd.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://web.mit.edu/kolya/afs/rx/rx-spec [1]
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Andrew Lunn <andrew@lunn.ch>
cc: David Laight <David.Laight@ACULAB.COM>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
---
 net/rxrpc/af_rxrpc.c    |    1 +
 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/local_event.c |   11 ++++++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 31f738d65f1c..da0b3b5157d5 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -980,6 +980,7 @@ static int __init af_rxrpc_init(void)
 	BUILD_BUG_ON(sizeof(struct rxrpc_skb_priv) > sizeof_field(struct sk_buff=
, cb));
 =

 	ret =3D -ENOMEM;
+	rxrpc_gen_version_string();
 	rxrpc_call_jar =3D kmem_cache_create(
 		"rxrpc_call_jar", sizeof(struct rxrpc_call), 0,
 		SLAB_HWCACHE_ALIGN, NULL);
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 5d44dc08f66d..e8e14c6f904d 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1068,6 +1068,7 @@ int rxrpc_get_server_data_key(struct rxrpc_connectio=
n *, const void *, time64_t,
 /*
  * local_event.c
  */
+void rxrpc_gen_version_string(void);
 void rxrpc_send_version_request(struct rxrpc_local *local,
 				struct rxrpc_host_header *hdr,
 				struct sk_buff *skb);
diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
index 5e69ea6b233d..993c69f97488 100644
--- a/net/rxrpc/local_event.c
+++ b/net/rxrpc/local_event.c
@@ -16,7 +16,16 @@
 #include <generated/utsrelease.h>
 #include "ar-internal.h"
 =

-static const char rxrpc_version_string[65] =3D "linux-" UTS_RELEASE " AF_=
RXRPC";
+static char rxrpc_version_string[65]; // "linux-" UTS_RELEASE " AF_RXRPC"=
;
+
+/*
+ * Generate the VERSION packet string.
+ */
+void rxrpc_gen_version_string(void)
+{
+	snprintf(rxrpc_version_string, sizeof(rxrpc_version_string),
+		 "linux-%.49s AF_RXRPC", UTS_RELEASE);
+}
 =

 /*
  * Reply to a version request


