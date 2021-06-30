Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686833B81E2
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhF3MTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:19:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56862 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234358AbhF3MTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:19:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625055426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S5U28ywwLl6OV7xmavpG2YSBQN6F4k443zEP4QDb3fA=;
        b=IP4a7e9bTjPvR6WU7Mug5ASpSC7cwlIWdndPPRRwwkPKhDcLnex6SqryAYAYhO39dSDku6
        LkXPBHmGMgAcQRXCWnz8tQAG7TdMgyGj+WzrYPVMANWOtd+ZWNNuMWm22m2YrL5Zs7/Ob6
        gTwDIyUr68aREdACRxuPWwsx9KmJK0E=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-gsKhXFOwOt261WUEuu8ANw-1; Wed, 30 Jun 2021 08:17:04 -0400
X-MC-Unique: gsKhXFOwOt261WUEuu8ANw-1
Received: by mail-ej1-f69.google.com with SMTP id ho42-20020a1709070eaab02904a77ea3380eso695465ejc.4
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S5U28ywwLl6OV7xmavpG2YSBQN6F4k443zEP4QDb3fA=;
        b=qMhDLCQEPleiQORnW/8o+Fx4WxJeUXsDq+dZZ5VeEyMrC6B4st+eyT2eb2f1hyu11M
         ijfv+0MJLbIZ7zMTrXL350qkENVkkAGT4kjiauSa0nSm6YuWohj2NbR/fP6m9u5hZqvq
         mcmVkOvP+M0oT2jWX8r0r8J5TxPilsBWDrX6M1GAaRu9H4bxD+4Ecp0HbQZ/M34iQLt3
         zEvudXiBcpAdbMj/pSPDp2zAjj7geuCk8n6jCztZFM0P8oKx5PjgIiiB41vZFTbEWiqC
         nK8WOXDScySFODcCslWZcjEte9kBk1YMiYJWXdoRxgrRHD/SDUaq2CsmkM92fo4WECAb
         3sug==
X-Gm-Message-State: AOAM532Ugg3FF9J9qYDrGdQzWCvSuRH5ep1sfcTppJ6COraTOMDsRb5D
        SSyyiuzd6DItS0lykXnHDM5AZzdm1N3lBJV09kh9NcVTK5+yfIRD5Vg98YG20jyAoVIm6ARejgT
        g81q7eGAvGk7Yub5v
X-Received: by 2002:aa7:cb43:: with SMTP id w3mr47972949edt.126.1625055423546;
        Wed, 30 Jun 2021 05:17:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzTOoXea3dw2KwL4npV9WtK8OeMjBSRZaapsXE1JRl9I0iizB5JdRpr8sX+P8Pm7+k3AQDmw==
X-Received: by 2002:aa7:cb43:: with SMTP id w3mr47972923edt.126.1625055423383;
        Wed, 30 Jun 2021 05:17:03 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id v24sm799726eds.39.2021.06.30.05.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:17:03 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:17:00 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 16/16] vsock_test: SEQPACKET read to broken buffer
Message-ID: <CAGxU2F7GswqHk_bkSHx7Q4y_tvdNLG0PRcq0Ujex+cWv+pRCJw@mail.gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100539.572000-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628100539.572000-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 01:05:36PM +0300, Arseny Krasnov wrote:
>Add test where sender sends two message, each with own
>data pattern. Reader tries to read first to broken buffer:
>it has three pages size, but middle page is unmapped. Then,
>reader tries to read second message to valid buffer. Test
>checks, that uncopied part of first message was dropped
>and thus not copied as part of second message.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> tools/testing/vsock/vsock_test.c | 121 +++++++++++++++++++++++++++++++
> 1 file changed, 121 insertions(+)

Cool test! Thanks for doing this!

>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 67766bfe176f..697ba168e97f 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -16,6 +16,7 @@
> #include <linux/kernel.h>
> #include <sys/types.h>
> #include <sys/socket.h>
>+#include <sys/mman.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -385,6 +386,121 @@ static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
>       close(fd);
> }
>
>+#define BUF_PATTERN_1 'a'
>+#define BUF_PATTERN_2 'b'
>+
>+static void test_seqpacket_invalid_rec_buffer_client(const struct test_opts *opts)
>+{
>+      int fd;
>+      unsigned char *buf1;
>+      unsigned char *buf2;
>+      int buf_size = getpagesize() * 3;
>+
>+      fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+      if (fd < 0) {
>+              perror("connect");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      buf1 = malloc(buf_size);
>+      if (buf1 == NULL) {

checkpatch suggests to use "if (!buf1)" ...

>+              perror("'malloc()' for 'buf1'");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      buf2 = malloc(buf_size);
>+      if (buf2 == NULL) {

... and "if (!buf2)" ...

>+              perror("'malloc()' for 'buf2'");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      memset(buf1, BUF_PATTERN_1, buf_size);
>+      memset(buf2, BUF_PATTERN_2, buf_size);
>+
>+      if (send(fd, buf1, buf_size, 0) != buf_size) {
>+              perror("send failed");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      if (send(fd, buf2, buf_size, 0) != buf_size) {
>+              perror("send failed");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      close(fd);
>+}
>+
>+static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opts)
>+{
>+      int fd;
>+      unsigned char *broken_buf;
>+      unsigned char *valid_buf;
>+      int page_size = getpagesize();
>+      int buf_size = page_size * 3;
>+      ssize_t res;
>+      int prot = PROT_READ | PROT_WRITE;
>+      int flags = MAP_PRIVATE | MAP_ANONYMOUS;
>+      int i;
>+
>+      fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+      if (fd < 0) {
>+              perror("accept");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      /* Setup first buffer. */
>+      broken_buf = mmap(NULL, buf_size, prot, flags, -1, 0);
>+      if (broken_buf == MAP_FAILED) {
>+              perror("mmap for 'broken_buf'");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      /* Unmap "hole" in buffer. */
>+      if (munmap(broken_buf + page_size, page_size)) {
>+              perror("'broken_buf' setup");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      valid_buf = mmap(NULL, buf_size, prot, flags, -1, 0);
>+      if (valid_buf == MAP_FAILED) {
>+              perror("mmap for 'valid_buf'");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      /* Try to fill buffer with unmapped middle. */
>+      res = read(fd, broken_buf, buf_size);
>+      if (res != -1) {
>+              perror("invalid read result of 'broken_buf'");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      if (errno != ENOMEM) {
>+              perror("invalid errno of 'broken_buf'");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      /* Try to fill valid buffer. */
>+      res = read(fd, valid_buf, buf_size);
>+      if (res != buf_size) {
>+              perror("invalid read result of 'valid_buf'");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      for (i = 0; i < buf_size; i++) {
>+              if (valid_buf[i] != BUF_PATTERN_2) {
>+                      perror("invalid pattern for valid buf");
>+                      exit(EXIT_FAILURE);
>+              }
>+      }
>+
>+

... and to remove the extra blank line here :-)

Thanks,
Stefano

>+      /* Unmap buffers. */
>+      munmap(broken_buf, page_size);
>+      munmap(broken_buf + page_size * 2, page_size);
>+      munmap(valid_buf, buf_size);
>+      close(fd);
>+}
>+
> static struct test_case test_cases[] = {
>       {
>               .name = "SOCK_STREAM connection reset",
>@@ -425,6 +541,11 @@ static struct test_case test_cases[] = {
>               .run_client = test_seqpacket_msg_trunc_client,
>               .run_server = test_seqpacket_msg_trunc_server,
>       },
>+      {
>+              .name = "SOCK_SEQPACKET invalid receive buffer",
>+              .run_client = test_seqpacket_invalid_rec_buffer_client,
>+              .run_server = test_seqpacket_invalid_rec_buffer_server,
>+      },
>       {},
> };
>
>--
>2.25.1
>

