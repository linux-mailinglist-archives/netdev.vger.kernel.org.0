Return-Path: <netdev+bounces-8387-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 757BE723DE3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F96A281624
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D546E294E9;
	Tue,  6 Jun 2023 09:39:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29D829106
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:39:26 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895CD1733;
	Tue,  6 Jun 2023 02:39:21 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id C33345FD1B;
	Tue,  6 Jun 2023 12:39:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1686044358;
	bh=VsLRnna6tc/S+J2EUt6rD5Z2Q76GP290WHdkcRtMHVU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	b=VwpBMG7cM9eD1ivCA/6Pys2s/QQ5okpKOxGuoP7RMZ2oQDNS2uaw5DLrv1sReyt2g
	 Hl3CHyqL32Q16oIyERngK4hk9tfCXdM01nEx3y3PkB1Ub2zpGobrr3nXPuYVWbivgY
	 mrmO9J9oJ+r1lGS768cfzeq3q6FG4OCVgVL+/h7ig8UcNOnAPL6lleASrLHaxKDizq
	 sZDi4ZjLw8IzYC72InmSiJm/g2AZPUwloSrHYQhSXDwezccHWHDSPOVpJ3rMn7sbCj
	 fL2YsNeTx2MeOwCwzO4I7+m9tsEw9udMcytQy9XPUVbdts6RYyCYesnmGutU/KHlPN
	 FKTbYc3+Lk7sQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Tue,  6 Jun 2023 12:39:14 +0300 (MSK)
Message-ID: <0bd40fd8-e666-e2a3-04da-501a0e7b97a9@sberdevices.ru>
Date: Tue, 6 Jun 2023 12:34:22 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC net-next v3 8/8] tests: add vsock dgram tests
Content-Language: en-US
From: Arseniy Krasnov <avkrasnov@sberdevices.ru>
To: Bobby Eshleman <bobby.eshleman@bytedance.com>, Jiang Wang
	<jiang.wang@bytedance.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang
	<haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>, Vishnu Dasa
	<vdasa@vmware.com>, VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Krasnov Arseniy <oxffffaa@gmail.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>
References: <7dbec78e-ea44-4684-6d02-5d6d5051187e@sberdevices.ru>
In-Reply-To: <7dbec78e-ea44-4684-6d02-5d6d5051187e@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/06 07:40:00 #21442908
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sorry, CC mailing lists

On 06.06.2023 12:29, Arseniy Krasnov wrote:
> Hello Bobby and Jiang! Small remarks(sorry for this letter layout, I add multiple newline over comments):
> 
> diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
> index 01b636d3039a..45e35da48b40 100644
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
> +		 int flags)
> +{
> +	const uint8_t byte = 'A';
> +	ssize_t nwritten;
> +
> +	timeout_begin(TIMEOUT);
> +	do {
> +		nwritten = sendto(fd, &byte, sizeof(byte), flags, dest_addr,
> +				  len);
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
> +
> 	}
> 
> 
> 
> ^^^
> May be short check that 'nwritten' != 'expected_ret' will be enough? Then print expected and
> real value. Here and in 'recvfrom_byte()' below.
> 
> 
> 
> 
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
> +		   int expected_ret, int flags)
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
> index fb99208a95ea..6e5cd610bf05 100644
> --- a/tools/testing/vsock/util.h
> +++ b/tools/testing/vsock/util.h
> @@ -43,7 +43,11 @@ int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>  			   struct sockaddr_vm *clientaddrp);
>  void vsock_wait_remote_close(int fd);
>  void send_byte(int fd, int expected_ret, int flags);
> +void sendto_byte(int fd, const struct sockaddr *dest_addr, int len, int expected_ret,
> +		 int flags);
>  void recv_byte(int fd, int expected_ret, int flags);
> +void recvfrom_byte(int fd, struct sockaddr *src_addr, socklen_t *addrlen,
> +		   int expected_ret, int flags);
>  void run_tests(const struct test_case *test_cases,
>  	       const struct test_opts *opts);
>  void list_tests(const struct test_case *test_cases);
> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> index ac1bd3ac1533..851c3d65178d 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -202,6 +202,113 @@ static void test_stream_server_close_server(const struct test_opts *opts)
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
> 
> 
> 
> ^^^
> I think we can check 'socket()' return value;
> 
> 
> 
> 
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
> @@ -255,6 +362,77 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
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
> 
> 
> 
> ^^^
> I think we can check 'socket()' return value;
> 
> 
> 
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
> @@ -1128,6 +1306,21 @@ static struct test_case test_cases[] = {
>  		.run_client = test_stream_virtio_skb_merge_client,
>  		.run_server = test_stream_virtio_skb_merge_server,
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
> 
> 
> 
> 
> SOCK_DGRAM guarantees message bounds, I think it will be good to add such test like in SOCK_SEQPACKET tests.
> 
> Thanks, Arseniy
> 
> 
>  	{},
>  };
>  
> 

