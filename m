Return-Path: <netdev+bounces-8955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CED9726672
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D02681C20902
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A671ACAE;
	Wed,  7 Jun 2023 16:51:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D0F63B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:51:46 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1589A1FE5;
	Wed,  7 Jun 2023 09:51:43 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b0314f057cso39855215ad.1;
        Wed, 07 Jun 2023 09:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686156702; x=1688748702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9HvkrROz2drFh8xFYBPmF+VNzTPGb5WOTqzBg4sKnoM=;
        b=reo+WQMeLQPt/SsvO9XQxnkV8qphwYlW+o8PILevVu572jDamMEzful0KxjzC6t1P9
         TafBxuTLkOHxqjuT8uwFiGEXPEMSMpBlRsknucMi0k8Eu2MlRQFeyVcZinKBV97/KYkq
         iPGaMAHaPrOfSZYmCaL9PCYpL5kMtOXvDdhV3MMDoCjlffG1ERobuCr6XQWv1knU+QtU
         YS+EHNw0wjLrc0ENoOt0Nl2cjveLvKA9v9pZd+UYk3095YLy+801kfbBMc0qqMlWBleL
         An5qcmdIoQvO8CpEi9H2PhMnZmuZhNK1TKj90CBx4ep4P3nN2hwEzLSwkfgjEcbYI9zZ
         NCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156702; x=1688748702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HvkrROz2drFh8xFYBPmF+VNzTPGb5WOTqzBg4sKnoM=;
        b=OomGwYWB9gcUR6kQFHEiykMrGBCLkvQI4ariMZ6GWASpdnhahPeV7nGOZ0d/YPd22w
         A4Ps5LjjtkHrcDtyJnrA8OaKoURjHnsjBOBoQ40/jw3mB5daq5fI12rVvSmwwdkpdbcd
         wdWNUUwaquhyts3eYIBSXYbkNKD0aBpBqO8NPU5HxtQY+jyP43bmQy5kUCEMbZegkjCQ
         N3Q0ykLQi+aZrywCRrcX9RvnNy7YVm/52W04+2uMN90punlreinvAWCBgwXQkhs1hNOE
         R/Up3KVogqMIs5vS3J4sCjODHepBJt4IgbX9fY0IyOo4InznX+RvswAm4HO8grdQ5frn
         JoIg==
X-Gm-Message-State: AC+VfDwjsm94wqWJcsl2wSUPmyS/i5nWCLNS/M9HQ6kKQU+UjIllpe3C
	np6NkefFam46/RxXHcIQkgk=
X-Google-Smtp-Source: ACHHUZ7tMqgn7UppBe0n1R+zcXc1AuD7MgVV1Rl7wsvMiJteNcAL4yyoJEciphxyfserOSjWbFSPRA==
X-Received: by 2002:a17:902:c40a:b0:1af:babd:7b6d with SMTP id k10-20020a170902c40a00b001afbabd7b6dmr3776435plk.52.1686156702253;
        Wed, 07 Jun 2023 09:51:42 -0700 (PDT)
Received: from localhost (c-67-166-91-86.hsd1.wa.comcast.net. [67.166.91.86])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902ed8c00b001ac7f583f72sm10664727plj.209.2023.06.07.09.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 09:51:41 -0700 (PDT)
Date: Thu, 1 Jun 2023 07:51:34 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>,
	Jiang Wang <jiang.wang@bytedance.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH RFC net-next v3 8/8] tests: add vsock dgram tests
Message-ID: <ZHhOBrmU7tzSX3zE@bullseye>
References: <7dbec78e-ea44-4684-6d02-5d6d5051187e@sberdevices.ru>
 <0bd40fd8-e666-e2a3-04da-501a0e7b97a9@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bd40fd8-e666-e2a3-04da-501a0e7b97a9@sberdevices.ru>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 12:34:22PM +0300, Arseniy Krasnov wrote:
> Sorry, CC mailing lists
> 
> On 06.06.2023 12:29, Arseniy Krasnov wrote:
> > Hello Bobby and Jiang! Small remarks(sorry for this letter layout, I add multiple newline over comments):
> > 

Hey Arseniy!

> > diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
> > index 01b636d3039a..45e35da48b40 100644
> > --- a/tools/testing/vsock/util.c
> > +++ b/tools/testing/vsock/util.c
> > @@ -260,6 +260,57 @@ void send_byte(int fd, int expected_ret, int flags)
> >  	}
> >  }
> >  
> > +/* Transmit one byte and check the return value.
> > + *
> > + * expected_ret:
> > + *  <0 Negative errno (for testing errors)
> > + *   0 End-of-file
> > + *   1 Success
> > + */
> > +void sendto_byte(int fd, const struct sockaddr *dest_addr, int len, int expected_ret,
> > +		 int flags)
> > +{
> > +	const uint8_t byte = 'A';
> > +	ssize_t nwritten;
> > +
> > +	timeout_begin(TIMEOUT);
> > +	do {
> > +		nwritten = sendto(fd, &byte, sizeof(byte), flags, dest_addr,
> > +				  len);
> > +		timeout_check("write");
> > +	} while (nwritten < 0 && errno == EINTR);
> > +	timeout_end();
> > +
> > +	if (expected_ret < 0) {
> > +		if (nwritten != -1) {
> > +			fprintf(stderr, "bogus sendto(2) return value %zd\n",
> > +				nwritten);
> > +			exit(EXIT_FAILURE);
> > +		}
> > +		if (errno != -expected_ret) {
> > +			perror("write");
> > +			exit(EXIT_FAILURE);
> > +		}
> > +		return;
> > +	}
> > +
> > +	if (nwritten < 0) {
> > +		perror("write");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +	if (nwritten == 0) {
> > +		if (expected_ret == 0)
> > +			return;
> > +
> > +		fprintf(stderr, "unexpected EOF while sending byte\n");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +	if (nwritten != sizeof(byte)) {
> > +		fprintf(stderr, "bogus sendto(2) return value %zd\n", nwritten);
> > +		exit(EXIT_FAILURE);
> > +
> > 	}
> > 
> > 
> > 
> > ^^^
> > May be short check that 'nwritten' != 'expected_ret' will be enough? Then print expected and
> > real value. Here and in 'recvfrom_byte()' below.
> > 

Right now this is really just a copy/paste of the send_byte() that
stream uses, so that would probably make the two report errors slightly
different. If desired for some specific reason, I'm open to it.

> > 
> > 
> > 
> > +}
> > +
> >  /* Receive one byte and check the return value.
> >   *
> >   * expected_ret:
> > @@ -313,6 +364,60 @@ void recv_byte(int fd, int expected_ret, int flags)
> >  	}
> >  }
> >  
> > +/* Receive one byte and check the return value.
> > + *
> > + * expected_ret:
> > + *  <0 Negative errno (for testing errors)
> > + *   0 End-of-file
> > + *   1 Success
> > + */
> > +void recvfrom_byte(int fd, struct sockaddr *src_addr, socklen_t *addrlen,
> > +		   int expected_ret, int flags)
> > +{
> > +	uint8_t byte;
> > +	ssize_t nread;
> > +
> > +	timeout_begin(TIMEOUT);
> > +	do {
> > +		nread = recvfrom(fd, &byte, sizeof(byte), flags, src_addr, addrlen);
> > +		timeout_check("read");
> > +	} while (nread < 0 && errno == EINTR);
> > +	timeout_end();
> > +
> > +	if (expected_ret < 0) {
> > +		if (nread != -1) {
> > +			fprintf(stderr, "bogus recvfrom(2) return value %zd\n",
> > +				nread);
> > +			exit(EXIT_FAILURE);
> > +		}
> > +		if (errno != -expected_ret) {
> > +			perror("read");
> > +			exit(EXIT_FAILURE);
> > +		}
> > +		return;
> > +	}
> > +
> > +	if (nread < 0) {
> > +		perror("read");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +	if (nread == 0) {
> > +		if (expected_ret == 0)
> > +			return;
> > +
> > +		fprintf(stderr, "unexpected EOF while receiving byte\n");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +	if (nread != sizeof(byte)) {
> > +		fprintf(stderr, "bogus recvfrom(2) return value %zd\n", nread);
> > +		exit(EXIT_FAILURE);
> > +	}
> > +	if (byte != 'A') {
> > +		fprintf(stderr, "unexpected byte read %c\n", byte);
> > +		exit(EXIT_FAILURE);
> > +	}
> > +}
> > +
> >  /* Run test cases.  The program terminates if a failure occurs. */
> >  void run_tests(const struct test_case *test_cases,
> >  	       const struct test_opts *opts)
> > diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
> > index fb99208a95ea..6e5cd610bf05 100644
> > --- a/tools/testing/vsock/util.h
> > +++ b/tools/testing/vsock/util.h
> > @@ -43,7 +43,11 @@ int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> >  			   struct sockaddr_vm *clientaddrp);
> >  void vsock_wait_remote_close(int fd);
> >  void send_byte(int fd, int expected_ret, int flags);
> > +void sendto_byte(int fd, const struct sockaddr *dest_addr, int len, int expected_ret,
> > +		 int flags);
> >  void recv_byte(int fd, int expected_ret, int flags);
> > +void recvfrom_byte(int fd, struct sockaddr *src_addr, socklen_t *addrlen,
> > +		   int expected_ret, int flags);
> >  void run_tests(const struct test_case *test_cases,
> >  	       const struct test_opts *opts);
> >  void list_tests(const struct test_case *test_cases);
> > diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> > index ac1bd3ac1533..851c3d65178d 100644
> > --- a/tools/testing/vsock/vsock_test.c
> > +++ b/tools/testing/vsock/vsock_test.c
> > @@ -202,6 +202,113 @@ static void test_stream_server_close_server(const struct test_opts *opts)
> >  	close(fd);
> >  }
> >  
> > +static void test_dgram_sendto_client(const struct test_opts *opts)
> > +{
> > +	union {
> > +		struct sockaddr sa;
> > +		struct sockaddr_vm svm;
> > +	} addr = {
> > +		.svm = {
> > +			.svm_family = AF_VSOCK,
> > +			.svm_port = 1234,
> > +			.svm_cid = opts->peer_cid,
> > +		},
> > +	};
> > +	int fd;
> > +
> > +	/* Wait for the server to be ready */
> > +	control_expectln("BIND");
> > +
> > +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> > +	if (fd < 0) {
> > +		perror("socket");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +
> > +	sendto_byte(fd, &addr.sa, sizeof(addr.svm), 1, 0);
> > +
> > +	/* Notify the server that the client has finished */
> > +	control_writeln("DONE");
> > +
> > +	close(fd);
> > +}
> > +
> > +static void test_dgram_sendto_server(const struct test_opts *opts)
> > +{
> > +	union {
> > +		struct sockaddr sa;
> > +		struct sockaddr_vm svm;
> > +	} addr = {
> > +		.svm = {
> > +			.svm_family = AF_VSOCK,
> > +			.svm_port = 1234,
> > +			.svm_cid = VMADDR_CID_ANY,
> > +		},
> > +	};
> > +	int fd;
> > +	int len = sizeof(addr.sa);
> > +
> > +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> > 
> > 
> > 
> > ^^^
> > I think we can check 'socket()' return value;
> > 

Gotcha, I'll add in next rev.

> > 
> > 
> > 
> > +
> > +	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
> > +		perror("bind");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +
> > +	/* Notify the client that the server is ready */
> > +	control_writeln("BIND");
> > +
> > +	recvfrom_byte(fd, &addr.sa, &len, 1, 0);
> > +
> > +	/* Wait for the client to finish */
> > +	control_expectln("DONE");
> > +
> > +	close(fd);
> > +}
> > +
> > +static void test_dgram_connect_client(const struct test_opts *opts)
> > +{
> > +	union {
> > +		struct sockaddr sa;
> > +		struct sockaddr_vm svm;
> > +	} addr = {
> > +		.svm = {
> > +			.svm_family = AF_VSOCK,
> > +			.svm_port = 1234,
> > +			.svm_cid = opts->peer_cid,
> > +		},
> > +	};
> > +	int fd;
> > +	int ret;
> > +
> > +	/* Wait for the server to be ready */
> > +	control_expectln("BIND");
> > +
> > +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> > +	if (fd < 0) {
> > +		perror("bind");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +
> > +	ret = connect(fd, &addr.sa, sizeof(addr.svm));
> > +	if (ret < 0) {
> > +		perror("connect");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +
> > +	send_byte(fd, 1, 0);
> > +
> > +	/* Notify the server that the client has finished */
> > +	control_writeln("DONE");
> > +
> > +	close(fd);
> > +}
> > +
> > +static void test_dgram_connect_server(const struct test_opts *opts)
> > +{
> > +	test_dgram_sendto_server(opts);
> > +}
> > +
> >  /* With the standard socket sizes, VMCI is able to support about 100
> >   * concurrent stream connections.
> >   */
> > @@ -255,6 +362,77 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
> >  		close(fds[i]);
> >  }
> >  
> > +static void test_dgram_multiconn_client(const struct test_opts *opts)
> > +{
> > +	int fds[MULTICONN_NFDS];
> > +	int i;
> > +	union {
> > +		struct sockaddr sa;
> > +		struct sockaddr_vm svm;
> > +	} addr = {
> > +		.svm = {
> > +			.svm_family = AF_VSOCK,
> > +			.svm_port = 1234,
> > +			.svm_cid = opts->peer_cid,
> > +		},
> > +	};
> > +
> > +	/* Wait for the server to be ready */
> > +	control_expectln("BIND");
> > +
> > +	for (i = 0; i < MULTICONN_NFDS; i++) {
> > +		fds[i] = socket(AF_VSOCK, SOCK_DGRAM, 0);
> > +		if (fds[i] < 0) {
> > +			perror("socket");
> > +			exit(EXIT_FAILURE);
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < MULTICONN_NFDS; i++)
> > +		sendto_byte(fds[i], &addr.sa, sizeof(addr.svm), 1, 0);
> > +
> > +	/* Notify the server that the client has finished */
> > +	control_writeln("DONE");
> > +
> > +	for (i = 0; i < MULTICONN_NFDS; i++)
> > +		close(fds[i]);
> > +}
> > +
> > +static void test_dgram_multiconn_server(const struct test_opts *opts)
> > +{
> > +	union {
> > +		struct sockaddr sa;
> > +		struct sockaddr_vm svm;
> > +	} addr = {
> > +		.svm = {
> > +			.svm_family = AF_VSOCK,
> > +			.svm_port = 1234,
> > +			.svm_cid = VMADDR_CID_ANY,
> > +		},
> > +	};
> > +	int fd;
> > +	int len = sizeof(addr.sa);
> > +	int i;
> > +
> > +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> > 
> > 
> > 
> > ^^^
> > I think we can check 'socket()' return value;
> > 
> > 
> > 
> > +
> > +	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
> > +		perror("bind");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +
> > +	/* Notify the client that the server is ready */
> > +	control_writeln("BIND");
> > +
> > +	for (i = 0; i < MULTICONN_NFDS; i++)
> > +		recvfrom_byte(fd, &addr.sa, &len, 1, 0);
> > +
> > +	/* Wait for the client to finish */
> > +	control_expectln("DONE");
> > +
> > +	close(fd);
> > +}
> > +
> >  static void test_stream_msg_peek_client(const struct test_opts *opts)
> >  {
> >  	int fd;
> > @@ -1128,6 +1306,21 @@ static struct test_case test_cases[] = {
> >  		.run_client = test_stream_virtio_skb_merge_client,
> >  		.run_server = test_stream_virtio_skb_merge_server,
> >  	},
> > +	{
> > +		.name = "SOCK_DGRAM client close",
> > +		.run_client = test_dgram_sendto_client,
> > +		.run_server = test_dgram_sendto_server,
> > +	},
> > +	{
> > +		.name = "SOCK_DGRAM client connect",
> > +		.run_client = test_dgram_connect_client,
> > +		.run_server = test_dgram_connect_server,
> > +	},
> > +	{
> > +		.name = "SOCK_DGRAM multiple connections",
> > +		.run_client = test_dgram_multiconn_client,
> > +		.run_server = test_dgram_multiconn_server,
> > +	},
> > 
> > 
> > 
> > 
> > SOCK_DGRAM guarantees message bounds, I think it will be good to add such test like in SOCK_SEQPACKET tests.

Agreed, I'll write one for the next rev.

> > 
> > Thanks, Arseniy

Thanks for the review!
> > 
> > 
> >  	{},
> >  };
> >  
> > 

