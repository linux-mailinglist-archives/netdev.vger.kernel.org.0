Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E121B6B2B0E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCIQns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjCIQnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:43:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66931EFFD
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678379498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z4raW7JwK9AMYLNaG7Amr5oIsub3jCwJbX6vi87O+9M=;
        b=L88bEoHQ+QSVEhXs3bwpV7cw/zmJ+YW5qR2ps5m65+w+FzemXaEz4WIi6o/pYxrZtfec8b
        8X71uTtYCxyLGINkuTNeKNE84iG46hUJD2t+Eo3rt42/tbEujRY6cNycqEZJhRjd+mNT6w
        q0CBn0S/ldQjPrTRdVdjn5TPLsl4DKg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-kOfYtjhGN5GUuuGX6U1XhQ-1; Thu, 09 Mar 2023 11:30:52 -0500
X-MC-Unique: kOfYtjhGN5GUuuGX6U1XhQ-1
Received: by mail-qv1-f69.google.com with SMTP id pv11-20020ad4548b000000b0056e96f4fd64so1454140qvb.15
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 08:30:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678379440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4raW7JwK9AMYLNaG7Amr5oIsub3jCwJbX6vi87O+9M=;
        b=toV/lcWwEJ5SSSgbx274mjSSZV8rJLBtXwJ50qbw9BICf5bEwxNMBQNz/yM9rr/1kk
         Wu0hi+df+kFvTGFiRqFlrsEu9Ufd0nL13LxDTFcKmQR7FCtawDMvuUAwoeaXDEWi6WHF
         wl4CfzBUciSFGDPc7T/L+Er1y29uJwi0I49eN4X19v/jD8vO9Oqk9TQAEsJiVhl/35Bd
         x3abdPxbaitACHBY/eWE1T6HK9LJKV/6mRNj8lGDkES6u+Tk+GPF2kC3GO5mekcHBvCu
         9W3RY9xsQgZ5bxZDZLB94ltBhZRLWAgqV7AGlVjbzK8MaheAxOaCqD0KQ/S3aitseAE4
         V6vQ==
X-Gm-Message-State: AO0yUKV3VTKbhzpsssHKV7NuL6nBUUc2KKR2m20Y7ew3SCKT4YlCt3la
        TxC58F65dh8lLknP2ZQXK/Ao+gG3Wye/51JYreKt5VFTKq5yrZ8Og/Fozdri54CrLT0CkL31Cny
        f2ETmqVra/dwOwmF+
X-Received: by 2002:a05:622a:d4:b0:3bf:dc57:5034 with SMTP id p20-20020a05622a00d400b003bfdc575034mr9196013qtw.29.1678379440305;
        Thu, 09 Mar 2023 08:30:40 -0800 (PST)
X-Google-Smtp-Source: AK7set9F/7Lif+W8Grh5U9Rl6sCN3eyoUaSPb2LI2vQ/RFVdDMCaeHv1X/pGMvmo6/ilZGbAAqWACw==
X-Received: by 2002:a05:622a:d4:b0:3bf:dc57:5034 with SMTP id p20-20020a05622a00d400b003bfdc575034mr9195975qtw.29.1678379439938;
        Thu, 09 Mar 2023 08:30:39 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id u37-20020a05622a19a500b003bd0e7ff466sm14142374qtc.7.2023.03.09.08.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:30:39 -0800 (PST)
Date:   Thu, 9 Mar 2023 17:30:34 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 4/4] test/vsock: copy to user failure test
Message-ID: <20230309163034.bznx6pywv5a45egw@sgarzare-redhat>
References: <0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru>
 <5d726a68-8530-3e90-202c-ba21996db60f@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5d726a68-8530-3e90-202c-ba21996db60f@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:14:48PM +0300, Arseniy Krasnov wrote:
>This adds SOCK_STREAM and SOCK_SEQPACKET tests for invalid buffer case.
>It tries to read data to NULL buffer (data already presents in socket's
>queue), then uses valid buffer. For SOCK_STREAM second read must return
>data, because skbuff is not dropped, but for SOCK_SEQPACKET skbuff will
>be dropped by kernel, and 'recv()' will return EAGAIN.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 118 +++++++++++++++++++++++++++++++
> 1 file changed, 118 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 67e9f9df3a8c..3de10dbb50f5 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -860,6 +860,114 @@ static void test_stream_poll_rcvlowat_client(const struct test_opts *opts)
> 	close(fd);
> }
>
>+#define INV_BUF_TEST_DATA_LEN 512
>+
>+static void test_inv_buf_client(const struct test_opts *opts, bool stream)
>+{
>+	unsigned char data[INV_BUF_TEST_DATA_LEN] = {0};
>+	ssize_t ret;
>+	int fd;
>+
>+	if (stream)
>+		fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	else
>+		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("SENDDONE");
>+
>+	/* Use invalid buffer here. */
>+	ret = recv(fd, NULL, sizeof(data), 0);
>+	if (ret != -1) {
>+		fprintf(stderr, "expected recv(2) failure, got %zi\n", ret);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (errno != ENOMEM) {
>+		fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	ret = recv(fd, data, sizeof(data), MSG_DONTWAIT);
>+
>+	if (stream) {
>+		/* For SOCK_STREAM we must continue reading. */
>+		if (ret != sizeof(data)) {
>+			fprintf(stderr, "expected recv(2) success, got %zi\n", ret);
>+			exit(EXIT_FAILURE);
>+		}
>+		/* Don't check errno in case of success. */
>+	} else {
>+		/* For SOCK_SEQPACKET socket's queue must be empty. */
>+		if (ret != -1) {
>+			fprintf(stderr, "expected recv(2) failure, got %zi\n", ret);
>+			exit(EXIT_FAILURE);
>+		}
>+
>+		if (errno != EAGAIN) {
>+			fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
>+			exit(EXIT_FAILURE);
>+		}
>+	}
>+
>+	control_writeln("DONE");
>+
>+	close(fd);
>+}
>+
>+static void test_inv_buf_server(const struct test_opts *opts, bool stream)
>+{
>+	unsigned char data[INV_BUF_TEST_DATA_LEN] = {0};
>+	ssize_t res;
>+	int fd;
>+
>+	if (stream)
>+		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	else
>+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	res = send(fd, data, sizeof(data), 0);
>+	if (res != sizeof(data)) {
>+		fprintf(stderr, "unexpected send(2) result %zi\n", res);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("SENDDONE");
>+
>+	control_expectln("DONE");
>+
>+	close(fd);
>+}
>+
>+static void test_stream_inv_buf_client(const struct test_opts *opts)
>+{
>+	test_inv_buf_client(opts, true);
>+}
>+
>+static void test_stream_inv_buf_server(const struct test_opts *opts)
>+{
>+	test_inv_buf_server(opts, true);
>+}
>+
>+static void test_seqpacket_inv_buf_client(const struct test_opts *opts)
>+{
>+	test_inv_buf_client(opts, false);
>+}
>+
>+static void test_seqpacket_inv_buf_server(const struct test_opts *opts)
>+{
>+	test_inv_buf_server(opts, false);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -920,6 +1028,16 @@ static struct test_case test_cases[] = {
> 		.run_client = test_seqpacket_bigmsg_client,
> 		.run_server = test_seqpacket_bigmsg_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM test invalid buffer",
>+		.run_client = test_stream_inv_buf_client,
>+		.run_server = test_stream_inv_buf_server,
>+	},
>+	{
>+		.name = "SOCK_SEQPACKET test invalid buffer",
>+		.run_client = test_seqpacket_inv_buf_client,
>+		.run_server = test_seqpacket_inv_buf_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1
>

