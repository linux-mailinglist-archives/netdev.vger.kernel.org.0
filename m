Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EBF1EBE82
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 16:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgFBO4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 10:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgFBO4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 10:56:34 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84784C08C5C0;
        Tue,  2 Jun 2020 07:56:34 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id w3so12757011qkb.6;
        Tue, 02 Jun 2020 07:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=np7a77PeXqhWnP18LFMZpdNTIU92RheIBheZrs1kcsI=;
        b=Guns+1wlHhuWtA68pmpS0DOoUTA5O+SyUUEoRZDbaJPRZumXdgyMY1yO/n6XUupBpR
         ZptwEISbma08ORnagvvysGsHN8F/8uoz/uCm4DW+Objco1mVO3FoyWrNZ7OLI/7t6oHQ
         eFnPAOVhs0Bd6QwjQAxqiXGXE5tYQ55ZwPd/uwmptCDvrJiEyUcS+hZDM9ERhGahzbRj
         gWk81icvHWem3X41euEjY4s7XFspZ6TNMUuIcHISBZOFcMxr5ajNJ7qN4EzHVIwxmASm
         D5SSI7xOiZnkES8jU4DOiEUKBdRS1Go/8dlmz9w7iLy5d+zToNSsyDBg1Vz5CYiNvJ56
         XfsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=np7a77PeXqhWnP18LFMZpdNTIU92RheIBheZrs1kcsI=;
        b=OeVT9iTMCs7gPfnuaNSxL1YuSylt8M5iWJzJ66MazPsMFKcVSsTgyJLcqrzXchzrmX
         rdjlGkvcSVKp3PxOCkD70XXKZyex9Thj0q1OCQ/uj4LQaXIbVN1+9er2IK1B0/ucOkox
         ptc4zixoTkUooH2wN68ZdGstpKbX22+2HzLPZzPLATYqH9HxQq2cyyQlgaQ/2xBcKEl1
         8XMZYKJCszMtgDqakocfsilhAY3zM2yLeegSXt1VBgO20OG/l5jcqQL7do44qlRL15wE
         DZ3G/nPPBBb9zD2OHdgUJG0aP7CicWcxWzKunzJLWm5HLd1TLYFddWIyLQjXS7vq4n1q
         G3WQ==
X-Gm-Message-State: AOAM531eBmD4Do+Mxf0xxg4CxUpd6jItVn5dIDAcv3FvVOUafxK33NoF
        obvnXwPQoRaAe36jsS3uIZE=
X-Google-Smtp-Source: ABdhPJxcBxr3AtvNy4to9lGrLwlCePRKAjTmwb4MMDeMdhPG7LiiaTx81ayq7pMidnzvnBJVvcDQaw==
X-Received: by 2002:a37:850:: with SMTP id 77mr24983673qki.498.1591109793762;
        Tue, 02 Jun 2020 07:56:33 -0700 (PDT)
Received: from kvmhost.ch.hwng.net (kvmhost.ch.hwng.net. [69.16.191.151])
        by smtp.gmail.com with ESMTPSA id 6sm2536543qkl.26.2020.06.02.07.56.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jun 2020 07:56:33 -0700 (PDT)
From:   Pooja Trivedi <poojatrivedi@gmail.com>
X-Google-Original-From: Pooja Trivedi <pooja.trivedi@stackpath.com>
To:     mallesh537@gmail.com, pooja.trivedi@stackpath.com,
        josh.tway@stackpath.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [RFC PATCH net 1/1] net/tls(TLS_SW): Add selftest for 'chunked' sendfile test
Date:   Tue,  2 Jun 2020 14:56:25 +0000
Message-Id: <1591109785-14316-1-git-send-email-pooja.trivedi@stackpath.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This selftest tests for cases where sendfile's 'count'
parameter is provided with a size greater than the intended
file size.

Motivation: When sendfile is provided with 'count' parameter
value that is greater than the size of the file, kTLS example
fails to send the file correctly. Last chunk of the file is
not sent, and the data integrity is compromised.
The reason is that the last chunk has MSG_MORE flag set
because of which it gets added to pending records, but is
not pushed.
Note that if user space were to send SSL_shutdown control
message, pending records would get flushed and the issue
would not happen. So a shutdown control message following
sendfile can mask the issue.

Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
---
 tools/testing/selftests/net/tls.c | 58 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 0ea44d9..f0455e6 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -198,6 +198,64 @@
 	EXPECT_EQ(recv(self->cfd, buf, st.st_size, MSG_WAITALL), st.st_size);
 }
 
+static void chunked_sendfile(struct __test_metadata *_metadata,
+			     struct _test_data_tls *self,
+			     uint16_t chunk_size,
+			     uint16_t extra_payload_size)
+{
+	char buf[TLS_PAYLOAD_MAX_LEN];
+	uint16_t test_payload_size;
+	int size = 0;
+	int ret;
+	char tmpfile[] = ".TMP_ktls";
+	int fd = open(tmpfile, O_RDWR | O_CREAT | O_TRUNC, 0644);
+	off_t offset = 0;
+
+	ASSERT_GE(fd, 0);
+	EXPECT_GE(chunk_size, 1);
+	test_payload_size = chunk_size + extra_payload_size;
+	ASSERT_GE(TLS_PAYLOAD_MAX_LEN, test_payload_size);
+	memset(buf, 1, test_payload_size);
+	size = write(fd, buf, test_payload_size);
+	EXPECT_EQ(size, test_payload_size);
+	fsync(fd);
+
+	while (size > 0) {
+		ret = sendfile(self->fd, fd, &offset, chunk_size);
+		EXPECT_GE(ret, 0);
+		size -= ret;
+	}
+
+	EXPECT_EQ(recv(self->cfd, buf, test_payload_size, MSG_WAITALL),
+		  test_payload_size);
+
+	close(fd);
+	unlink(tmpfile);
+}
+
+TEST_F(tls, multi_chunk_sendfile)
+{
+	chunked_sendfile(_metadata, self, 4096, 4096);
+	chunked_sendfile(_metadata, self, 4096, 0);
+	chunked_sendfile(_metadata, self, 4096, 1);
+	chunked_sendfile(_metadata, self, 4096, 2048);
+	chunked_sendfile(_metadata, self, 8192, 2048);
+	chunked_sendfile(_metadata, self, 4096, 8192);
+	chunked_sendfile(_metadata, self, 8192, 4096);
+	chunked_sendfile(_metadata, self, 12288, 1024);
+	chunked_sendfile(_metadata, self, 12288, 2000);
+	chunked_sendfile(_metadata, self, 15360, 100);
+	chunked_sendfile(_metadata, self, 15360, 300);
+	chunked_sendfile(_metadata, self, 1, 4096);
+	chunked_sendfile(_metadata, self, 2048, 4096);
+	chunked_sendfile(_metadata, self, 2048, 8192);
+	chunked_sendfile(_metadata, self, 4096, 8192);
+	chunked_sendfile(_metadata, self, 1024, 12288);
+	chunked_sendfile(_metadata, self, 2000, 12288);
+	chunked_sendfile(_metadata, self, 100, 15360);
+	chunked_sendfile(_metadata, self, 300, 15360);
+}
+
 TEST_F(tls, recv_max)
 {
 	unsigned int send_len = TLS_PAYLOAD_MAX_LEN;
-- 
1.8.3.1

