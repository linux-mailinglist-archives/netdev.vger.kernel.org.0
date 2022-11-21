Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C4B63274C
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiKUPGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiKUPFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:05:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CBCE674C
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 06:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669042376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tyYoQDvW5BLwsxIUp85ljPCfFSUwHbhCNM6YdC5pOm0=;
        b=FGk0dMG9U3VmOgKd7Sbo4spjI63ae6ZNqCDkwDRzV1VAHHl/zJryKze8YlHtokRertcKBI
        JcFCJpV+RZOpG+6TL4Ah0y47NTf/ApGi0GYXpSHcw5T46iiZTqi1k2GsZMlCM6JC5MfuEK
        KHtc0UuUAtcRPG43N6zoTe6pp5XC3cQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-481-5RMb0wt8NGuVpxFF4vhZwg-1; Mon, 21 Nov 2022 09:52:55 -0500
X-MC-Unique: 5RMb0wt8NGuVpxFF4vhZwg-1
Received: by mail-wm1-f72.google.com with SMTP id c10-20020a7bc84a000000b003cf81c2d3efso3195360wml.7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 06:52:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tyYoQDvW5BLwsxIUp85ljPCfFSUwHbhCNM6YdC5pOm0=;
        b=FO6cK6sjcrtcMwwRHP0kuN0ummXBuqoNjgpN+bKnYlHH+01fNVbsgIRsjew2As6YJh
         zhwJHJyZG8T6QObiBNqRcZu7NjAd+ne9Skhcz3rwl0M0W2sUhQIemXMW0KqDalILwVTf
         /n2DEsgA/uYaaTbE64R9MVVAiCcELhMgQ0H29yTzgh6kp8JdSOWshLy3ScOQQQfWv0MT
         /QsxwfPcVmyFXh1zxuNN32o43UEs39JVKNKzI8CEEkJbdG2kFvgiZVk9amCjNZeo/8em
         3PWYSlwnsOGs8/KSswMFkMil4OUn1Jfdpw9QlZ782BGkhf6ysiNsie7GG+PPbsIZ5k9M
         nrMQ==
X-Gm-Message-State: ANoB5pl4ZZcZ78f0cA0+1SYu7UUv/ianLeXOKHFTxmvnHM3ymDTfac7f
        Qmsg3BiE2RsT+EGCSXl8Xf5HQqJYzKphYW8o85oPNOzFRU35n0kGLlBNmCjsxa/zNqgaurGsYSC
        DdK2XVbht1YuU9EBr
X-Received: by 2002:a05:600c:3d16:b0:3c6:de4a:d768 with SMTP id bh22-20020a05600c3d1600b003c6de4ad768mr1677484wmb.61.1669042373653;
        Mon, 21 Nov 2022 06:52:53 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5jdJos1x+fJLl/VjateAcyVlqjFB0fbz73X92rukgJDZZKLp+g2j6EymPu53UGC0WeUNRsJg==
X-Received: by 2002:a05:600c:3d16:b0:3c6:de4a:d768 with SMTP id bh22-20020a05600c3d1600b003c6de4ad768mr1677469wmb.61.1669042373452;
        Mon, 21 Nov 2022 06:52:53 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id o18-20020a05600c4fd200b003cfa26c410asm20547986wmq.20.2022.11.21.06.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 06:52:53 -0800 (PST)
Date:   Mon, 21 Nov 2022 15:52:48 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 2/3] test/vsock: add big message test
Message-ID: <20221121145248.cmscv5vg3fir543x@sgarzare-redhat>
References: <ba294dff-812a-bfc2-a43c-286f99aee0b8@sberdevices.ru>
 <f0510949-cc97-7a01-5fc8-f7e855b80515@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f0510949-cc97-7a01-5fc8-f7e855b80515@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 08:52:35PM +0000, Arseniy Krasnov wrote:
>This adds test for sending message, bigger than peer's buffer size.
>For SOCK_SEQPACKET socket it must fail, as this type of socket has
>message size limit.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 62 ++++++++++++++++++++++++++++++++
> 1 file changed, 62 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 107c11165887..bb4e8657f1d6 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -560,6 +560,63 @@ static void test_seqpacket_timeout_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+static void test_seqpacket_bigmsg_client(const struct test_opts *opts)
>+{
>+	unsigned long sock_buf_size;
>+	ssize_t send_size;
>+	socklen_t len;
>+	void *data;
>+	int fd;
>+
>+	len = sizeof(sock_buf_size);
>+
>+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);

Not for this patch, but someday we should add a macro for this port and 
maybe even make it configurable :-)

>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (getsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>+		       &sock_buf_size, &len)) {
>+		perror("getsockopt");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	sock_buf_size++;
>+
>+	data = malloc(sock_buf_size);
>+	if (!data) {
>+		perror("malloc");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	send_size = send(fd, data, sock_buf_size, 0);
>+	if (send_size != -1) {

Can we check also `errno`?
IIUC it should contains EMSGSIZE.

>+		fprintf(stderr, "expected 'send(2)' failure, got %zi\n",
>+			send_size);
>+	}
>+
>+	control_writeln("CLISENT");
>+
>+	free(data);
>+	close(fd);
>+}
>+
>+static void test_seqpacket_bigmsg_server(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("CLISENT");
>+
>+	close(fd);
>+}
>+
> #define BUF_PATTERN_1 'a'
> #define BUF_PATTERN_2 'b'
>
>@@ -832,6 +889,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_seqpacket_timeout_client,
> 		.run_server = test_seqpacket_timeout_server,
> 	},
>+	{
>+		.name = "SOCK_SEQPACKET big message",
>+		.run_client = test_seqpacket_bigmsg_client,
>+		.run_server = test_seqpacket_bigmsg_server,
>+	},

I would add new tests always at the end, so if some CI uses --skip, we 
don't have to update the scripts to skip some tests.

> 	{
> 		.name = "SOCK_SEQPACKET invalid receive buffer",
> 		.run_client = test_seqpacket_invalid_rec_buffer_client,
>-- 
>2.25.1

