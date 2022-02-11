Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAA54B2E06
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353003AbiBKTvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:51:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352988AbiBKTve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:51:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FDE22A5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 11:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644609092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bne5fux8udNCXVzeyZDnPjq+FWuos4KPEoOYJ7iDvq8=;
        b=PsWPT4FGfuPMF/p+19DCtEaD5ukAjqAWzNpExLPFMFR1yvXQHlucCW7AhU2szDBqLYIa8o
        toajuVW10/rO08Oyp3m3YbqZYQTaCktSY2I6zasutsCls8MS/n7WZOv0hI8JQN2km56Pff
        P/Ey9K+XATluU/rNEv9UzYZMHKOHuWg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-p3yRVBJiPD61k8d1bNyeyA-1; Fri, 11 Feb 2022 14:51:30 -0500
X-MC-Unique: p3yRVBJiPD61k8d1bNyeyA-1
Received: by mail-ej1-f70.google.com with SMTP id mp5-20020a1709071b0500b0069f2ba47b20so4482386ejc.19
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 11:51:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bne5fux8udNCXVzeyZDnPjq+FWuos4KPEoOYJ7iDvq8=;
        b=mvsZTWGbNu3ieElg2VMUEIXB8HMxKtzBhDlfRSoNUODuAF68pEkHF+EjW/6DLW5wPa
         D80lVtwKsvZay+G+wQxozw2WFexuly/p7kaexoiqjWgDKIMDQnn1LHy4FCg5lGAf9b9j
         VawKqDEI7PfsBJQHD90AuPLhjoHkmaVxTp5EPcNyQFtkzXwoY9OqVGgl+C+rNJ/WsRpW
         /iDDo9PfU1Eh+C3kLGExJcdHc1cUGOJr3T0xG2gIGKogfbeM/irh2CDgMFs+QlqhYOD4
         5Gu9CAmPAFMAZMG2lQtqLQr/7pWsoIJbwG1cTA5s0oZu/AO43XXqmFtBgaIm2liXuhxM
         x6sg==
X-Gm-Message-State: AOAM531lHdY5ToSsRXPIGA+7ATKwAK9v943myA9/w/PrkgqaJKbC/Z7O
        EccORSGL1FDugbkGTdm9P7OSnQPjZyAQ5cvQRtu3IZC6vDEusfecUedMThr7U8xNjDebi8y6bk7
        6J2Ip89sC/nLx9DiA
X-Received: by 2002:a17:906:c149:: with SMTP id dp9mr2692366ejc.57.1644609088011;
        Fri, 11 Feb 2022 11:51:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw79y+nQK1hJW6XGH9Bj3uYGaHaUO6u5ZDRgmeAfs+pFpPU0EZk6tjQKly3FwpXi1BcLZV7jg==
X-Received: by 2002:a17:906:c149:: with SMTP id dp9mr2692332ejc.57.1644609087131;
        Fri, 11 Feb 2022 11:51:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a8sm4958833edy.94.2022.02.11.11.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 11:51:26 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D0159102D8C; Fri, 11 Feb 2022 20:51:25 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Zhiqian Guan <zhguan@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: Use dynamically allocated buffer when receiving netlink messages
Date:   Fri, 11 Feb 2022 20:51:00 +0100
Message-Id: <20220211195101.591642-1-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving netlink messages, libbpf was using a statically allocated
stack buffer of 4k bytes. This happened to work fine on systems with a 4k
page size, but on systems with larger page sizes it can lead to truncated
messages. The user-visible impact of this was that libbpf would insist no
XDP program was attached to some interfaces because that bit of the netlink
message got chopped off.

Fix this by switching to a dynamically allocated buffer; we borrow the
approach from iproute2 of using recvmsg() with MSG_PEEK|MSG_TRUNC to get
the actual size of the pending message before receiving it, adjusting the
buffer as necessary. While we're at it, also add retries on interrupted
system calls around the recvmsg() call.

Reported-by: Zhiqian Guan <zhguan@redhat.com>
Fixes: 8bbb77b7c7a2 ("libbpf: Add various netlink helpers")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/netlink.c | 55 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index c39c37f99d5c..9a6e95206bf0 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -87,22 +87,70 @@ enum {
 	NL_DONE,
 };
 
+static int __libbpf_netlink_recvmsg(int sock, struct msghdr *mhdr, int flags)
+{
+	int len;
+
+	do {
+		len = recvmsg(sock, mhdr, flags);
+	} while (len < 0 && (errno == EINTR || errno == EAGAIN));
+
+	if (len < 0)
+		return -errno;
+	return len;
+}
+
+static int libbpf_netlink_recvmsg(int sock, struct msghdr *mhdr, char **buf)
+{
+	struct iovec *iov = mhdr->msg_iov;
+	void *nbuf;
+	int len;
+
+	len = __libbpf_netlink_recvmsg(sock, mhdr, MSG_PEEK | MSG_TRUNC);
+	if (len < 0)
+		return len;
+
+	if (len < 4096)
+		len = 4096;
+
+	if (len > iov->iov_len) {
+		nbuf = realloc(iov->iov_base, len);
+		if (!nbuf) {
+			free(iov->iov_base);
+			return -ENOMEM;
+		}
+		iov->iov_base = nbuf;
+		iov->iov_len = len;
+	}
+
+	len = __libbpf_netlink_recvmsg(sock, mhdr, 0);
+	if (len > 0)
+		*buf = iov->iov_base;
+	return len;
+}
+
 static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 			       __dump_nlmsg_t _fn, libbpf_dump_nlmsg_t fn,
 			       void *cookie)
 {
+	struct iovec iov = {};
+	struct msghdr mhdr = {
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+	};
 	bool multipart = true;
 	struct nlmsgerr *err;
 	struct nlmsghdr *nh;
-	char buf[4096];
 	int len, ret;
+	char *buf;
+
 
 	while (multipart) {
 start:
 		multipart = false;
-		len = recv(sock, buf, sizeof(buf), 0);
+		len = libbpf_netlink_recvmsg(sock, &mhdr, &buf);
 		if (len < 0) {
-			ret = -errno;
+			ret = len;
 			goto done;
 		}
 
@@ -151,6 +199,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	}
 	ret = 0;
 done:
+	free(iov.iov_base);
 	return ret;
 }
 
-- 
2.35.1

