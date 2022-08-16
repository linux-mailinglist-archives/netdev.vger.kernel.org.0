Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077D1596040
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 18:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbiHPQ3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236549AbiHPQ2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:28:52 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D8378BE8;
        Tue, 16 Aug 2022 09:28:42 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo85264pjd.3;
        Tue, 16 Aug 2022 09:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=DPZsi1JTIZSJCu/0+FSIgEhw/II6XQ3HpipyRMscsoI=;
        b=AZPJITcAke4aFqWf0Xn1IxpiOGy2zFf4zTG73CcK8+exiMtfSBRC4W8DHS1g/sE/h+
         DcvT6/3Xx596zqIESlKu3sdwp8Bikg82w9/4r1v31DjoWCq7h9TXAMBPMBWwMxt8lp84
         5xAhZDNo2ipx8n4y/7DFu32sFqaOLgownzZQjNUnRWv4S2zydT0hvu4o0DLsYy0h9rc5
         7+3mQYbvtFLe5F1IBhtlyQk9KqDSgyE6yM2/nwli5nzjKqecMSnFtLT1uPmRezIZZfoG
         wHAd1j1Zkv/U1xaXAxlov25kIGhsRM3vLOOEYi+/pPblTPWvebsNrTHimrhA5Q/m5akc
         CHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=DPZsi1JTIZSJCu/0+FSIgEhw/II6XQ3HpipyRMscsoI=;
        b=uVsIckDPyQnzoy2yeAWJiWFU0Kf6MMDHfXzqYWgaDOSHLKwHNlzUesMB1WQhsfANx4
         yd47Huj4Oe+3B8XbE6BURnEYUjxHjxfM441fFo+t4iReVc0JO72GHpSOPeh7/LsJlTJa
         nnwiy4cakosm8X7dVT2GhIoGNt/MRoqAznXaOblfSQTlBivm9HuzGvHSlkErz1/fw8Zt
         ChZ2dreJbWObrLYDal8X1XIdp65hS1naRPIO0+oHJRZRbxB8l8lDVbNn09TgkTtV4hz7
         J3vuVsiE/cXxI5HtNJkWiRmv/9egivBJAc/RlMOXpsWph91cPpayaWjRr4QOXxPtdlzk
         u84A==
X-Gm-Message-State: ACgBeo0/XX47KCqSIkyEYa6Wam8TA+iI1BzriePdQZVwlOgnVvSdlYwP
        Lbfn4ubehpGq9lok1ZzhmHo=
X-Google-Smtp-Source: AA6agR7J+nIlhnBrfWjAzIdOWeDQfxTj7UhoKibT+l1dVpLvf5MNHvEX62mjv4/XsPCz0szlhVc1mw==
X-Received: by 2002:a17:902:f2cb:b0:171:2d4b:8238 with SMTP id h11-20020a170902f2cb00b001712d4b8238mr22725902plc.25.1660667322007;
        Tue, 16 Aug 2022 09:28:42 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id n5-20020a622705000000b0052ea306a1e8sm8649113pfn.210.2022.08.16.09.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 09:28:41 -0700 (PDT)
Date:   Tue, 16 Aug 2022 02:32:43 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] vsock_test: add tests for vsock dgram
Message-ID: <YvsBy1KqjD0yBAAs@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <db2e6c0ffa559ae6b8572b1981a6ad566aa73178.1660362669.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db2e6c0ffa559ae6b8572b1981a6ad566aa73178.1660362669.git.bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing virtio-dev@lists.oasis-open.org

On Mon, Aug 15, 2022 at 10:56:09AM -0700, Bobby Eshleman wrote:
> From: Jiang Wang <jiang.wang@bytedance.com>
> 
> Added test cases for vsock dgram types.
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> ---
>  tools/testing/vsock/util.c       | 105 +++++++++++++++++
>  tools/testing/vsock/util.h       |   4 +
>  tools/testing/vsock/vsock_test.c | 195 +++++++++++++++++++++++++++++++
>  3 files changed, 304 insertions(+)
> 
> diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
> index 2acbb7703c6a..d2f5b223bf85 100644
> --- a/tools/testing/vsock/util.c
> +++ b/tools/testing/vsock/util.c
> @@ -260,6 +260,57 @@ void send_byte(int fd, int expected_ret, int flags)
>  	}
>  }
>  
> +/* Transmit one byte and check the return value.
> + *
> + * expected_ret:
> + *  <0 Negative errno (for testing errors)
> + *   0 End-of-file
> + *   1 Success
> + */
> +void sendto_byte(int fd, const struct sockaddr *dest_addr, int len, int expected_ret,
> +				int flags)
> +{
> +	const uint8_t byte = 'A';
> +	ssize_t nwritten;
> +
> +	timeout_begin(TIMEOUT);
> +	do {
> +		nwritten = sendto(fd, &byte, sizeof(byte), flags, dest_addr,
> +						len);
> +		timeout_check("write");
> +	} while (nwritten < 0 && errno == EINTR);
> +	timeout_end();
> +
> +	if (expected_ret < 0) {
> +		if (nwritten != -1) {
> +			fprintf(stderr, "bogus sendto(2) return value %zd\n",
> +				nwritten);
> +			exit(EXIT_FAILURE);
> +		}
> +		if (errno != -expected_ret) {
> +			perror("write");
> +			exit(EXIT_FAILURE);
> +		}
> +		return;
> +	}
> +
> +	if (nwritten < 0) {
> +		perror("write");
> +		exit(EXIT_FAILURE);
> +	}
> +	if (nwritten == 0) {
> +		if (expected_ret == 0)
> +			return;
> +
> +		fprintf(stderr, "unexpected EOF while sending byte\n");
> +		exit(EXIT_FAILURE);
> +	}
> +	if (nwritten != sizeof(byte)) {
> +		fprintf(stderr, "bogus sendto(2) return value %zd\n", nwritten);
> +		exit(EXIT_FAILURE);
> +	}
> +}
> +
>  /* Receive one byte and check the return value.
>   *
>   * expected_ret:
> @@ -313,6 +364,60 @@ void recv_byte(int fd, int expected_ret, int flags)
>  	}
>  }
>  
> +/* Receive one byte and check the return value.
> + *
> + * expected_ret:
> + *  <0 Negative errno (for testing errors)
> + *   0 End-of-file
> + *   1 Success
> + */
> +void recvfrom_byte(int fd, struct sockaddr *src_addr, socklen_t *addrlen,
> +				int expected_ret, int flags)
> +{
> +	uint8_t byte;
> +	ssize_t nread;
> +
> +	timeout_begin(TIMEOUT);
> +	do {
> +		nread = recvfrom(fd, &byte, sizeof(byte), flags, src_addr, addrlen);
> +		timeout_check("read");
> +	} while (nread < 0 && errno == EINTR);
> +	timeout_end();
> +
> +	if (expected_ret < 0) {
> +		if (nread != -1) {
> +			fprintf(stderr, "bogus recvfrom(2) return value %zd\n",
> +				nread);
> +			exit(EXIT_FAILURE);
> +		}
> +		if (errno != -expected_ret) {
> +			perror("read");
> +			exit(EXIT_FAILURE);
> +		}
> +		return;
> +	}
> +
> +	if (nread < 0) {
> +		perror("read");
> +		exit(EXIT_FAILURE);
> +	}
> +	if (nread == 0) {
> +		if (expected_ret == 0)
> +			return;
> +
> +		fprintf(stderr, "unexpected EOF while receiving byte\n");
> +		exit(EXIT_FAILURE);
> +	}
> +	if (nread != sizeof(byte)) {
> +		fprintf(stderr, "bogus recvfrom(2) return value %zd\n", nread);
> +		exit(EXIT_FAILURE);
> +	}
> +	if (byte != 'A') {
> +		fprintf(stderr, "unexpected byte read %c\n", byte);
> +		exit(EXIT_FAILURE);
> +	}
> +}
> +
>  /* Run test cases.  The program terminates if a failure occurs. */
>  void run_tests(const struct test_case *test_cases,
>  	       const struct test_opts *opts)
> diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
> index a3375ad2fb7f..7213f2a51c1e 100644
> --- a/tools/testing/vsock/util.h
> +++ b/tools/testing/vsock/util.h
> @@ -43,7 +43,11 @@ int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>  			   struct sockaddr_vm *clientaddrp);
>  void vsock_wait_remote_close(int fd);
>  void send_byte(int fd, int expected_ret, int flags);
> +void sendto_byte(int fd, const struct sockaddr *dest_addr, int len, int expected_ret,
> +				int flags);
>  void recv_byte(int fd, int expected_ret, int flags);
> +void recvfrom_byte(int fd, struct sockaddr *src_addr, socklen_t *addrlen,
> +				int expected_ret, int flags);
>  void run_tests(const struct test_case *test_cases,
>  	       const struct test_opts *opts);
>  void list_tests(const struct test_case *test_cases);
> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> index dc577461afc2..640379f1b462 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -201,6 +201,115 @@ static void test_stream_server_close_server(const struct test_opts *opts)
>  	close(fd);
>  }
>  
> +static void test_dgram_sendto_client(const struct test_opts *opts)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_vm svm;
> +	} addr = {
> +		.svm = {
> +			.svm_family = AF_VSOCK,
> +			.svm_port = 1234,
> +			.svm_cid = opts->peer_cid,
> +		},
> +	};
> +	int fd;
> +
> +	/* Wait for the server to be ready */
> +	control_expectln("BIND");
> +
> +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> +	if (fd < 0) {
> +		perror("socket");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	sendto_byte(fd, &addr.sa, sizeof(addr.svm), 1, 0);
> +
> +	/* Notify the server that the client has finished */
> +	control_writeln("DONE");
> +
> +	close(fd);
> +}
> +
> +static void test_dgram_sendto_server(const struct test_opts *opts)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_vm svm;
> +	} addr = {
> +		.svm = {
> +			.svm_family = AF_VSOCK,
> +			.svm_port = 1234,
> +			.svm_cid = VMADDR_CID_ANY,
> +		},
> +	};
> +	int fd;
> +	int len = sizeof(addr.sa);
> +
> +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> +
> +	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
> +		perror("bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	/* Notify the client that the server is ready */
> +	control_writeln("BIND");
> +
> +	recvfrom_byte(fd, &addr.sa, &len, 1, 0);
> +	printf("got message from cid:%d, port %u ", addr.svm.svm_cid,
> +			addr.svm.svm_port);
> +
> +	/* Wait for the client to finish */
> +	control_expectln("DONE");
> +
> +	close(fd);
> +}
> +
> +static void test_dgram_connect_client(const struct test_opts *opts)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_vm svm;
> +	} addr = {
> +		.svm = {
> +			.svm_family = AF_VSOCK,
> +			.svm_port = 1234,
> +			.svm_cid = opts->peer_cid,
> +		},
> +	};
> +	int fd;
> +	int ret;
> +
> +	/* Wait for the server to be ready */
> +	control_expectln("BIND");
> +
> +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> +	if (fd < 0) {
> +		perror("bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	ret = connect(fd, &addr.sa, sizeof(addr.svm));
> +	if (ret < 0) {
> +		perror("connect");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	send_byte(fd, 1, 0);
> +
> +	/* Notify the server that the client has finished */
> +	control_writeln("DONE");
> +
> +	close(fd);
> +}
> +
> +static void test_dgram_connect_server(const struct test_opts *opts)
> +{
> +	test_dgram_sendto_server(opts);
> +}
> +
>  /* With the standard socket sizes, VMCI is able to support about 100
>   * concurrent stream connections.
>   */
> @@ -254,6 +363,77 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
>  		close(fds[i]);
>  }
>  
> +static void test_dgram_multiconn_client(const struct test_opts *opts)
> +{
> +	int fds[MULTICONN_NFDS];
> +	int i;
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_vm svm;
> +	} addr = {
> +		.svm = {
> +			.svm_family = AF_VSOCK,
> +			.svm_port = 1234,
> +			.svm_cid = opts->peer_cid,
> +		},
> +	};
> +
> +	/* Wait for the server to be ready */
> +	control_expectln("BIND");
> +
> +	for (i = 0; i < MULTICONN_NFDS; i++) {
> +		fds[i] = socket(AF_VSOCK, SOCK_DGRAM, 0);
> +		if (fds[i] < 0) {
> +			perror("socket");
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> +
> +	for (i = 0; i < MULTICONN_NFDS; i++)
> +		sendto_byte(fds[i], &addr.sa, sizeof(addr.svm), 1, 0);
> +
> +	/* Notify the server that the client has finished */
> +	control_writeln("DONE");
> +
> +	for (i = 0; i < MULTICONN_NFDS; i++)
> +		close(fds[i]);
> +}
> +
> +static void test_dgram_multiconn_server(const struct test_opts *opts)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_vm svm;
> +	} addr = {
> +		.svm = {
> +			.svm_family = AF_VSOCK,
> +			.svm_port = 1234,
> +			.svm_cid = VMADDR_CID_ANY,
> +		},
> +	};
> +	int fd;
> +	int len = sizeof(addr.sa);
> +	int i;
> +
> +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> +
> +	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
> +		perror("bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	/* Notify the client that the server is ready */
> +	control_writeln("BIND");
> +
> +	for (i = 0; i < MULTICONN_NFDS; i++)
> +		recvfrom_byte(fd, &addr.sa, &len, 1, 0);
> +
> +	/* Wait for the client to finish */
> +	control_expectln("DONE");
> +
> +	close(fd);
> +}
> +
>  static void test_stream_msg_peek_client(const struct test_opts *opts)
>  {
>  	int fd;
> @@ -646,6 +826,21 @@ static struct test_case test_cases[] = {
>  		.run_client = test_seqpacket_invalid_rec_buffer_client,
>  		.run_server = test_seqpacket_invalid_rec_buffer_server,
>  	},
> +	{
> +		.name = "SOCK_DGRAM client close",
> +		.run_client = test_dgram_sendto_client,
> +		.run_server = test_dgram_sendto_server,
> +	},
> +	{
> +		.name = "SOCK_DGRAM client connect",
> +		.run_client = test_dgram_connect_client,
> +		.run_server = test_dgram_connect_server,
> +	},
> +	{
> +		.name = "SOCK_DGRAM multiple connections",
> +		.run_client = test_dgram_multiconn_client,
> +		.run_server = test_dgram_multiconn_server,
> +	},
>  	{},
>  };
>  
> -- 
> 2.35.1
> 
