Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDE44DACF1
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354677AbiCPIzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348849AbiCPIzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:55:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 972F4381BC
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647420832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BGSquJZfEU0XpxQDlJiQ9Nf/2e2vYgQ8cePX8MYx0lw=;
        b=NaKceCeMzi+8eQlwKGa3FS+Iztj9I5oSF9mwUzNFWradIwQ//MNrP6fSyC6Nh89MJ6e7yF
        AN2ChVQHV+hfjkk6Xo1ETvaS8JgFu16VG6LL2f3QTVWSw/uNNgMW7P124QI2S6V5Y5JzKw
        kIZKb0YCmp+SR++5wz9a0TEtqMcmWjI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-dozy2bjVNIO0-ENpG8NJ2w-1; Wed, 16 Mar 2022 04:53:51 -0400
X-MC-Unique: dozy2bjVNIO0-ENpG8NJ2w-1
Received: by mail-qt1-f200.google.com with SMTP id f13-20020ac8014d000000b002ddae786fb0so1038915qtg.19
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BGSquJZfEU0XpxQDlJiQ9Nf/2e2vYgQ8cePX8MYx0lw=;
        b=G4yfbjyAhhrkG/rtkiMwqQMFDVfQxEUMNxzfCN6cfb01oR+Vx3bhkhsWayPQr96F8o
         cX5T+F8ckSShmP6LabcEEil4cNkmxR1B4g3Wjj4+rT8FT5M8hO1XwKBhRg3eWuiwHgxY
         KHpz6o0NgVE8u9NxZ7wSflRt1Cbgkq3TVvVYu8dUQU7BXp8aHvm/4qH1FK44v6RXku67
         Q7yo7X65LZk7xSBX5RrKUlFDENns9Ez0iv5PB8bZrQ7myzFVQ8lhB4ALtg6fhy0P+xJ1
         0w+3ioXnIgr5olXeJvxaCeOVdgcHaf6Ptd696kF3NYDM+8NSkyx1M257JpNQoRehhwUN
         +glQ==
X-Gm-Message-State: AOAM5336v5f5fjMgx2lQX7uSiR+Im76EmDUE762C7o2X+7HKAZEAVPuZ
        Uq96b2CPRFO0FB9+6aXFpcSmTPdFEz6cT8rAPMG5MoXcE1OtbEN97fnQVWi/K7eDQorEtCtWbjB
        AuZ+bzASQmml2YTpw
X-Received: by 2002:a05:620a:4085:b0:67b:315b:a09f with SMTP id f5-20020a05620a408500b0067b315ba09fmr20513449qko.334.1647420831017;
        Wed, 16 Mar 2022 01:53:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwb/nFj3dDrpxdws1scoeFcog8y/RQk9LTO0D1ZDQQyiweerrLDje3qSyAQR/5kQ8Sr9cHm0Q==
X-Received: by 2002:a05:620a:4085:b0:67b:315b:a09f with SMTP id f5-20020a05620a408500b0067b315ba09fmr20513439qko.334.1647420830768;
        Wed, 16 Mar 2022 01:53:50 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.retail.telecomitalia.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id t66-20020ae9df45000000b0064915aff85fsm638399qkf.45.2022.03.16.01.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 01:53:50 -0700 (PDT)
Date:   Wed, 16 Mar 2022 09:53:45 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/2] af_vsock: SOCK_SEQPACKET broken buffer test
Message-ID: <20220316085345.ajfmnzg3vx3o3vgs@sgarzare-redhat>
References: <1474b149-7d4c-27b2-7e5c-ef00a718db76@sberdevices.ru>
 <415368cd-81b3-e2fd-fbed-65cacfc43850@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <415368cd-81b3-e2fd-fbed-65cacfc43850@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 07:29:28AM +0000, Krasnov Arseniy Vladimirovich wrote:
>Add test where sender sends two message, each with own
>data pattern. Reader tries to read first to broken buffer:
>it has three pages size, but middle page is unmapped. Then,
>reader tries to read second message to valid buffer. Test
>checks, that uncopied part of first message was dropped
>and thus not copied as part of second message.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> v1 -> v2:
> 1) Use 'fprintf()' instead of 'perror()' where 'errno' variable
>    is not affected.
> 2) Replace word "invalid" -> "unexpected".
>
> tools/testing/vsock/vsock_test.c | 132 +++++++++++++++++++++++++++++++
> 1 file changed, 132 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 6d7648cce5aa..1132bcd8ddb7 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -17,6 +17,7 @@
> #include <sys/types.h>
> #include <sys/socket.h>
> #include <time.h>
>+#include <sys/mman.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -465,6 +466,132 @@ static void test_seqpacket_timeout_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+#define BUF_PATTERN_1 'a'
>+#define BUF_PATTERN_2 'b'
>+
>+static void test_seqpacket_invalid_rec_buffer_client(const struct test_opts *opts)
>+{
>+	int fd;
>+	unsigned char *buf1;
>+	unsigned char *buf2;
>+	int buf_size = getpagesize() * 3;
>+
>+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	buf1 = malloc(buf_size);
>+	if (buf1 == NULL) {
>+		perror("'malloc()' for 'buf1'");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	buf2 = malloc(buf_size);
>+	if (buf2 == NULL) {
>+		perror("'malloc()' for 'buf2'");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	memset(buf1, BUF_PATTERN_1, buf_size);
>+	memset(buf2, BUF_PATTERN_2, buf_size);
>+
>+	if (send(fd, buf1, buf_size, 0) != buf_size) {
>+		perror("send failed");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (send(fd, buf2, buf_size, 0) != buf_size) {
>+		perror("send failed");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	close(fd);
>+}
>+
>+static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opts)
>+{
>+	int fd;
>+	unsigned char *broken_buf;
>+	unsigned char *valid_buf;
>+	int page_size = getpagesize();
>+	int buf_size = page_size * 3;
>+	ssize_t res;
>+	int prot = PROT_READ | PROT_WRITE;
>+	int flags = MAP_PRIVATE | MAP_ANONYMOUS;
>+	int i;
>+
>+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Setup first buffer. */
>+	broken_buf = mmap(NULL, buf_size, prot, flags, -1, 0);
>+	if (broken_buf == MAP_FAILED) {
>+		perror("mmap for 'broken_buf'");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Unmap "hole" in buffer. */
>+	if (munmap(broken_buf + page_size, page_size)) {
>+		perror("'broken_buf' setup");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	valid_buf = mmap(NULL, buf_size, prot, flags, -1, 0);
>+	if (valid_buf == MAP_FAILED) {
>+		perror("mmap for 'valid_buf'");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Try to fill buffer with unmapped middle. */
>+	res = read(fd, broken_buf, buf_size);
>+	if (res != -1) {
>+		fprintf(stderr,
>+			"expected 'broken_buf' read(2) failure, got %zi\n",
>+			res);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (errno != ENOMEM) {
>+		perror("unexpected errno of 'broken_buf'");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Try to fill valid buffer. */
>+	res = read(fd, valid_buf, buf_size);
>+	if (res < 0) {
>+		perror("unexpected 'valid_buf' read(2) failure");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (res != buf_size) {
>+		fprintf(stderr,
>+			"invalid 'valid_buf' read(2), got %zi, expected %i\n",
>+			res, buf_size);

I would suggest to use always the same pattern in the error messages:
"expected X, got Y".

The rest LGTM.

>+		exit(EXIT_FAILURE);
>+	}
>+
>+	for (i = 0; i < buf_size; i++) {
>+		if (valid_buf[i] != BUF_PATTERN_2) {
>+			fprintf(stderr,
>+				"invalid pattern for 'valid_buf' at %i, expected %hhX, got %hhX\n",
>+				i, BUF_PATTERN_2, valid_buf[i]);
>+			exit(EXIT_FAILURE);
>+		}
>+	}
>+
>+
>+	/* Unmap buffers. */
>+	munmap(broken_buf, page_size);
>+	munmap(broken_buf + page_size * 2, page_size);
>+	munmap(valid_buf, buf_size);
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -510,6 +637,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_seqpacket_timeout_client,
> 		.run_server = test_seqpacket_timeout_server,
> 	},
>+	{
>+		.name = "SOCK_SEQPACKET invalid receive buffer",
>+		.run_client = test_seqpacket_invalid_rec_buffer_client,
>+		.run_server = test_seqpacket_invalid_rec_buffer_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1

