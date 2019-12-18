Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC41125049
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfLRSIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:08:17 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48982 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727649AbfLRSIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:08:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PKgRJKmCUaU0qajJf3X0inD9I5OriDwjAbgS1hT2Rhk=;
        b=Fc5Cso+MWIiiwIHwTc0AERrX6Hu7Q1PJRql5yIc55+FcWUqNt8CJIdALEi/+lJE5jKcgCs
        KGePDoRo0fLiSrQOoBHOkPSSSSOsUtdCchp8CFcYCZKCgANS4O5x78r15NrN5nrTYz+4z8
        ne9Ed2ZnFwePR3wd/pZO7Y+ivY1aAt0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-jV9ud2qrPS-QuMVkwgfOvQ-1; Wed, 18 Dec 2019 13:07:58 -0500
X-MC-Unique: jV9ud2qrPS-QuMVkwgfOvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E06A64A96;
        Wed, 18 Dec 2019 18:07:56 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7216A5D9E2;
        Wed, 18 Dec 2019 18:07:54 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 10/11] testing/vsock: print list of options and description
Date:   Wed, 18 Dec 2019 19:07:07 +0100
Message-Id: <20191218180708.120337-11-sgarzare@redhat.com>
In-Reply-To: <20191218180708.120337-1-sgarzare@redhat.com>
References: <20191218180708.120337-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we now have several options, in the help we print the list
of all supported options and a brief description of them.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/vsock_diag_test.c | 13 ++++++++++++-
 tools/testing/vsock/vsock_test.c      | 13 ++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/=
vsock_diag_test.c
index b82483627259..cec6f5a738e1 100644
--- a/tools/testing/vsock/vsock_diag_test.c
+++ b/tools/testing/vsock/vsock_diag_test.c
@@ -497,7 +497,18 @@ static void usage(void)
 		"listen address and the client requires an address to\n"
 		"connect to.\n"
 		"\n"
-		"The CID of the other side must be given with --peer-cid=3D<cid>.\n");
+		"The CID of the other side must be given with --peer-cid=3D<cid>.\n"
+		"\n"
+		"Options:\n"
+		"  --help                 This help message\n"
+		"  --control-host <host>  Server IP address to connect to\n"
+		"  --control-port <port>  Server port to listen on/connect to\n"
+		"  --mode client|server   Server or client mode\n"
+		"  --peer-cid <cid>       CID of the other side\n"
+		"  --list                 List of tests that will be executed\n"
+		"  --skip <test_id>       Test ID to skip;\n"
+		"                         use multiple --skip options to skip more tes=
ts\n"
+		);
 	exit(EXIT_FAILURE);
 }
=20
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock=
_test.c
index 3ac56651f3f9..a63e05d6a0f9 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -257,7 +257,18 @@ static void usage(void)
 		"listen address and the client requires an address to\n"
 		"connect to.\n"
 		"\n"
-		"The CID of the other side must be given with --peer-cid=3D<cid>.\n");
+		"The CID of the other side must be given with --peer-cid=3D<cid>.\n"
+		"\n"
+		"Options:\n"
+		"  --help                 This help message\n"
+		"  --control-host <host>  Server IP address to connect to\n"
+		"  --control-port <port>  Server port to listen on/connect to\n"
+		"  --mode client|server   Server or client mode\n"
+		"  --peer-cid <cid>       CID of the other side\n"
+		"  --list                 List of tests that will be executed\n"
+		"  --skip <test_id>       Test ID to skip;\n"
+		"                         use multiple --skip options to skip more tes=
ts\n"
+		);
 	exit(EXIT_FAILURE);
 }
=20
--=20
2.24.1

