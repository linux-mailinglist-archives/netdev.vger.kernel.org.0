Return-Path: <netdev+bounces-9949-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E0C72B408
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 22:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AD531C2099A
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 20:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC8911198;
	Sun, 11 Jun 2023 20:55:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C140B2C9D;
	Sun, 11 Jun 2023 20:55:05 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B68E51;
	Sun, 11 Jun 2023 13:55:02 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f122ff663eso4136750e87.2;
        Sun, 11 Jun 2023 13:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686516900; x=1689108900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u//teaprYjmQN5bT3dcEJ9ffSoWPAthk7C7NuLjRaeY=;
        b=fPDYrcWhvs49ZjWJjTVJsPEmVXpn5jrUKLb9OCLu4d2/8fwzvC1f6jbHpHaSgGcXB3
         kNkiV3KP0W06QN0NsGGIED4LPq7iKMW/DB8LhmlrUwDpvKNN/MygUvm8wU5vNKEXe9SV
         dEUTsTyV5oI6Bl1mM5kpm8O5GKCHcLSwvrPETURH5lA+J8LnYS813k4aNm/q/cyp7L2z
         0sRjVN9aJxOEhx36dO+EntBTJ6R+ObkE+IwTJbLc9wmzCxEloP+bvIi1SiEWcGeujmgk
         lfo7731Uwepp/rh2gOJLXjucQnn052ikgjZ2i+lrzmuXItl7NjLN2VEoERtEfzsMHT3E
         D7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686516900; x=1689108900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u//teaprYjmQN5bT3dcEJ9ffSoWPAthk7C7NuLjRaeY=;
        b=HOOgrApfq1/tsEvMuun7QT1lPFrlkMk/lZYcj1enIyowYZ0UKVg6N+QhXepdqW/iUC
         kZiKduw/RjEDIAK34zKVjJkNWKDaDqC+hJ4azZr641aqMIT0VXsDNe1ZBCr23uww5Q2u
         0sUV3NoWJDc3dLdx0N61Pxug3Qn1zrMk2Nfw1n0/A3EeuT+5crMl5QwYrDwLfwY8t/Kn
         aM0O4pZN5eswQ+OmETMGcIbcfhJCTWBoSCiDtFP4S+K+C4mE1jUeVX7eDh8gaQG3r6ms
         SlLvzLIO6KC4vv1n3WzCxoGAc8AF3vPDMObK8NK3b9Juy1fV+mRQ3uRkWe0vHAfkuv22
         dfSg==
X-Gm-Message-State: AC+VfDxEzE6broYi/u9B0kpYtrK/7Flz5rS984F5nkMTGV0YK0XB1NpN
	W6PWIWEPo0SvHfuV+IX9/fw=
X-Google-Smtp-Source: ACHHUZ4c4SurfYLz4CNr8Rk/Jxeq6Wna6EdiJuGlDn18ThBGDgzX4hOLqVKpNJtO/5N6rx40ApE28A==
X-Received: by 2002:a19:6d1c:0:b0:4f3:82a8:dcfc with SMTP id i28-20020a196d1c000000b004f382a8dcfcmr2732688lfc.55.1686516900080;
        Sun, 11 Jun 2023 13:55:00 -0700 (PDT)
Received: from ?IPV6:2a00:1e88:c487:9300:dcc4:573f:aaf5:21af? ([2a00:1e88:c487:9300:dcc4:573f:aaf5:21af])
        by smtp.gmail.com with ESMTPSA id z7-20020a19f707000000b004f508e8a9acsm1242872lfe.301.2023.06.11.13.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 13:54:59 -0700 (PDT)
Message-ID: <484c7b6f-5ce5-ce43-2dfd-0ae3063f1e47@gmail.com>
Date: Sun, 11 Jun 2023 23:54:57 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v4 8/8] tests: add vsock dgram tests
Content-Language: en-US
To: Bobby Eshleman <bobby.eshleman@bytedance.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>,
 Vishnu Dasa <vdasa@vmware.com>,
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
 Simon Horman <simon.horman@corigine.com>, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
 bpf@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-8-0cebbb2ae899@bytedance.com>
From: Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <20230413-b4-vsock-dgram-v4-8-0cebbb2ae899@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
	HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Bobby!

Sorry, may be I become a little bit annoying:), but I tried to run vsock_test with
this v4 version, and again get the same crash:

# cat client.sh 
./vsock_test  --mode=client --control-host=192.168.1.1 --control-port=12345 --peer-cid=2
# ./client.sh 
Control socket connected to 192.168.1.1:12345.
0 - SOCK_STREAM connection reset...[   20.065237] BUG: kernel NULL pointer dereference, addre0
[   20.065895] #PF: supervisor read access in kernel mode
[   20.065895] #PF: error_code(0x0000) - not-present page
[   20.065895] PGD 0 P4D 0 
[   20.065895] Oops: 0000 [#1] PREEMPT SMP PTI
[   20.065895] CPU: 0 PID: 111 Comm: vsock_test Not tainted 6.4.0-rc3-gefcccba07069 #385
[   20.065895] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd44
[   20.065895] RIP: 0010:static_key_count+0x0/0x20
[   20.065895] Code: 04 4c 8b 46 08 49 29 c0 4c 01 c8 4c 89 47 08 89 0e 89 56 04 48 89 46 08 f
[   20.065895] RSP: 0018:ffffbbb000223dc0 EFLAGS: 00010202
[   20.065895] RAX: ffffffff85709880 RBX: ffffffffc0079140 RCX: 0000000000000000
[   20.065895] RDX: ffff9f73c2175700 RSI: 0000000000000000 RDI: 0000000000000000
[   20.065895] RBP: ffff9f73c2385900 R08: ffffbbb000223d30 R09: ffff9f73ff896000
[   20.065895] R10: 0000000000001000 R11: 0000000000000000 R12: ffffbbb000223e80
[   20.065895] R13: 0000000000000000 R14: 0000000000000002 R15: ffff9f73c1cfaa80
[   20.065895] FS:  00007f1ad82f55c0(0000) GS:ffff9f73fe400000(0000) knlGS:0000000000000000
[   20.065895] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   20.065895] CR2: 0000000000000000 CR3: 000000003f954000 CR4: 00000000000006f0
[   20.065895] Call Trace:
[   20.065895]  <TASK>
[   20.065895]  once_deferred+0xd/0x30
[   20.065895]  vsock_assign_transport+0x9a/0x1b0 [vsock]
[   20.065895]  vsock_connect+0xb4/0x3a0 [vsock]
[   20.065895]  ? var_wake_function+0x60/0x60
[   20.065895]  __sys_connect+0x9e/0xd0
[   20.065895]  ? _raw_spin_unlock_irq+0xe/0x30
[   20.065895]  ? do_setitimer+0x128/0x1f0
[   20.065895]  ? alarm_setitimer+0x4c/0x90
[   20.065895]  ? fpregs_assert_state_consistent+0x1d/0x50
[   20.065895]  ? exit_to_user_mode_prepare+0x36/0x130
[   20.065895]  __x64_sys_connect+0x11/0x20
[   20.065895]  do_syscall_64+0x3b/0xc0
[   20.065895]  entry_SYSCALL_64_after_hwframe+0x4b/0xb5
[   20.065895] RIP: 0033:0x7f1ad822dd13
[   20.065895] Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 64 8
[   20.065895] RSP: 002b:00007ffc513e3c98 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
[   20.065895] RAX: ffffffffffffffda RBX: 000055aed298e020 RCX: 00007f1ad822dd13
[   20.065895] RDX: 0000000000000010 RSI: 00007ffc513e3cb0 RDI: 0000000000000004
[   20.065895] RBP: 0000000000000004 R08: 000055aed32b2018 R09: 0000000000000000
[   20.065895] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   20.065895] R13: 000055aed298acb1 R14: 00007ffc513e3cb0 R15: 00007ffc513e3d40
[   20.065895]  </TASK>
[   20.065895] Modules linked in: vsock_loopback vhost_vsock vmw_vsock_virtio_transport vmw_vb
[   20.065895] CR2: 0000000000000000
[   20.154060] ---[ end trace 0000000000000000 ]---
[   20.155519] RIP: 0010:static_key_count+0x0/0x20
[   20.156932] Code: 04 4c 8b 46 08 49 29 c0 4c 01 c8 4c 89 47 08 89 0e 89 56 04 48 89 46 08 f
[   20.161367] RSP: 0018:ffffbbb000223dc0 EFLAGS: 00010202
[   20.162613] RAX: ffffffff85709880 RBX: ffffffffc0079140 RCX: 0000000000000000
[   20.164262] RDX: ffff9f73c2175700 RSI: 0000000000000000 RDI: 0000000000000000
[   20.165934] RBP: ffff9f73c2385900 R08: ffffbbb000223d30 R09: ffff9f73ff896000
[   20.167684] R10: 0000000000001000 R11: 0000000000000000 R12: ffffbbb000223e80
[   20.169427] R13: 0000000000000000 R14: 0000000000000002 R15: ffff9f73c1cfaa80
[   20.171109] FS:  00007f1ad82f55c0(0000) GS:ffff9f73fe400000(0000) knlGS:0000000000000000
[   20.173000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   20.174381] CR2: 0000000000000000 CR3: 000000003f954000 CR4: 00000000000006f0

So, what HEAD do You use? May be You have some specific config (I use x86-64 defconfig + vsock/vhost
related things) ?

Thanks, Arseniy


On 10.06.2023 03:58, Bobby Eshleman wrote:
> From: Jiang Wang <jiang.wang@bytedance.com>
> 
> This patch adds tests for vsock datagram.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> ---
>  tools/testing/vsock/util.c       | 141 ++++++++++++-
>  tools/testing/vsock/util.h       |   6 +
>  tools/testing/vsock/vsock_test.c | 432 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 578 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
> index 01b636d3039a..811e70d7cf1e 100644
> --- a/tools/testing/vsock/util.c
> +++ b/tools/testing/vsock/util.c
> @@ -99,7 +99,8 @@ static int vsock_connect(unsigned int cid, unsigned int port, int type)
>  	int ret;
>  	int fd;
>  
> -	control_expectln("LISTENING");
> +	if (type != SOCK_DGRAM)
> +		control_expectln("LISTENING");
>  
>  	fd = socket(AF_VSOCK, type, 0);
>  
> @@ -130,6 +131,11 @@ int vsock_seqpacket_connect(unsigned int cid, unsigned int port)
>  	return vsock_connect(cid, port, SOCK_SEQPACKET);
>  }
>  
> +int vsock_dgram_connect(unsigned int cid, unsigned int port)
> +{
> +	return vsock_connect(cid, port, SOCK_DGRAM);
> +}
> +
>  /* Listen on <cid, port> and return the first incoming connection.  The remote
>   * address is stored to clientaddrp.  clientaddrp may be NULL.
>   */
> @@ -211,6 +217,34 @@ int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>  	return vsock_accept(cid, port, clientaddrp, SOCK_SEQPACKET);
>  }
>  
> +int vsock_dgram_bind(unsigned int cid, unsigned int port)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_vm svm;
> +	} addr = {
> +		.svm = {
> +			.svm_family = AF_VSOCK,
> +			.svm_port = port,
> +			.svm_cid = cid,
> +		},
> +	};
> +	int fd;
> +
> +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> +	if (fd < 0) {
> +		perror("socket");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
> +		perror("bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	return fd;
> +}
> +
>  /* Transmit one byte and check the return value.
>   *
>   * expected_ret:
> @@ -260,6 +294,57 @@ void send_byte(int fd, int expected_ret, int flags)
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
> +	}
> +}
> +
>  /* Receive one byte and check the return value.
>   *
>   * expected_ret:
> @@ -313,6 +398,60 @@ void recv_byte(int fd, int expected_ret, int flags)
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
> index fb99208a95ea..a69e128d120c 100644
> --- a/tools/testing/vsock/util.h
> +++ b/tools/testing/vsock/util.h
> @@ -37,13 +37,19 @@ void init_signals(void);
>  unsigned int parse_cid(const char *str);
>  int vsock_stream_connect(unsigned int cid, unsigned int port);
>  int vsock_seqpacket_connect(unsigned int cid, unsigned int port);
> +int vsock_dgram_connect(unsigned int cid, unsigned int port);
>  int vsock_stream_accept(unsigned int cid, unsigned int port,
>  			struct sockaddr_vm *clientaddrp);
>  int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>  			   struct sockaddr_vm *clientaddrp);
> +int vsock_dgram_bind(unsigned int cid, unsigned int port);
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
> index ac1bd3ac1533..ded82d39ee5d 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -1053,6 +1053,413 @@ static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
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
> +	int len = sizeof(addr.sa);
> +	int fd;
> +
> +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> +	if (fd < 0) {
> +		perror("socket");
> +		exit(EXIT_FAILURE);
> +	}
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
> +	int ret;
> +	int fd;
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
> +static void test_dgram_multiconn_sendto_client(const struct test_opts *opts)
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
> +	int fds[MULTICONN_NFDS];
> +	int i;
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
> +static void test_dgram_multiconn_sendto_server(const struct test_opts *opts)
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
> +	int len = sizeof(addr.sa);
> +	int fd;
> +	int i;
> +
> +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> +	if (fd < 0) {
> +		perror("socket");
> +		exit(EXIT_FAILURE);
> +	}
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
> +static void test_dgram_multiconn_send_client(const struct test_opts *opts)
> +{
> +	int fds[MULTICONN_NFDS];
> +	int i;
> +
> +	/* Wait for the server to be ready */
> +	control_expectln("BIND");
> +
> +	for (i = 0; i < MULTICONN_NFDS; i++) {
> +		fds[i] = vsock_dgram_connect(opts->peer_cid, 1234);
> +		if (fds[i] < 0) {
> +			perror("socket");
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> +
> +	for (i = 0; i < MULTICONN_NFDS; i++)
> +		send_byte(fds[i], 1, 0);
> +
> +	/* Notify the server that the client has finished */
> +	control_writeln("DONE");
> +
> +	for (i = 0; i < MULTICONN_NFDS; i++)
> +		close(fds[i]);
> +}
> +
> +static void test_dgram_multiconn_send_server(const struct test_opts *opts)
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
> +	int i;
> +
> +	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
> +	if (fd < 0) {
> +		perror("socket");
> +		exit(EXIT_FAILURE);
> +	}
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
> +		recv_byte(fd, 1, 0);
> +
> +	/* Wait for the client to finish */
> +	control_expectln("DONE");
> +
> +	close(fd);
> +}
> +
> +static void test_dgram_msg_bounds_client(const struct test_opts *opts)
> +{
> +	unsigned long recv_buf_size;
> +	int page_size;
> +	int msg_cnt;
> +	int fd;
> +
> +	fd = vsock_dgram_connect(opts->peer_cid, 1234);
> +	if (fd < 0) {
> +		perror("connect");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	/* Let the server know the client is ready */
> +	control_writeln("CLNTREADY");
> +
> +	msg_cnt = control_readulong();
> +	recv_buf_size = control_readulong();
> +
> +	/* Wait, until receiver sets buffer size. */
> +	control_expectln("SRVREADY");
> +
> +	page_size = getpagesize();
> +
> +	for (int i = 0; i < msg_cnt; i++) {
> +		unsigned long curr_hash;
> +		ssize_t send_size;
> +		size_t buf_size;
> +		void *buf;
> +
> +		/* Use "small" buffers and "big" buffers. */
> +		if (i & 1)
> +			buf_size = page_size +
> +					(rand() % (MAX_MSG_SIZE - page_size));
> +		else
> +			buf_size = 1 + (rand() % page_size);
> +
> +		buf_size = min(buf_size, recv_buf_size);
> +
> +		buf = malloc(buf_size);
> +
> +		if (!buf) {
> +			perror("malloc");
> +			exit(EXIT_FAILURE);
> +		}
> +
> +		memset(buf, rand() & 0xff, buf_size);
> +		/* Set at least one MSG_EOR + some random. */
> +
> +		send_size = send(fd, buf, buf_size, 0);
> +
> +		if (send_size < 0) {
> +			perror("send");
> +			exit(EXIT_FAILURE);
> +		}
> +
> +		if (send_size != buf_size) {
> +			fprintf(stderr, "Invalid send size\n");
> +			exit(EXIT_FAILURE);
> +		}
> +
> +		/* In theory the implementation isn't required to transmit
> +		 * these packets in order, so we use this SYNC control message
> +		 * so that server and client coordinate sending and receiving
> +		 * one packet at a time. The client sends a packet and waits
> +		 * until it has been received before sending another.
> +		 */
> +		control_writeln("PKTSENT");
> +		control_expectln("PKTRECV");
> +
> +		/* Send the server a hash of the packet */
> +		curr_hash = hash_djb2(buf, buf_size);
> +		control_writeulong(curr_hash);
> +		free(buf);
> +	}
> +
> +	control_writeln("SENDDONE");
> +	close(fd);
> +}
> +
> +static void test_dgram_msg_bounds_server(const struct test_opts *opts)
> +{
> +	const unsigned long msg_cnt = 16;
> +	unsigned long sock_buf_size;
> +	struct msghdr msg = {0};
> +	struct iovec iov = {0};
> +	char buf[MAX_MSG_SIZE];
> +	socklen_t len;
> +	int fd;
> +	int i;
> +
> +	fd = vsock_dgram_bind(VMADDR_CID_ANY, 1234);
> +
> +	if (fd < 0) {
> +		perror("bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	/* Set receive buffer to maximum */
> +	sock_buf_size = -1;
> +	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF,
> +		       &sock_buf_size, sizeof(sock_buf_size))) {
> +		perror("setsockopt(SO_RECVBUF)");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	/* Retrieve the receive buffer size */
> +	len = sizeof(sock_buf_size);
> +	if (getsockopt(fd, SOL_SOCKET, SO_RCVBUF,
> +		       &sock_buf_size, &len)) {
> +		perror("getsockopt(SO_RECVBUF)");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	/* Client ready to receive parameters */
> +	control_expectln("CLNTREADY");
> +
> +	control_writeulong(msg_cnt);
> +	control_writeulong(sock_buf_size);
> +
> +	/* Ready to receive data. */
> +	control_writeln("SRVREADY");
> +
> +	iov.iov_base = buf;
> +	iov.iov_len = sizeof(buf);
> +	msg.msg_iov = &iov;
> +	msg.msg_iovlen = 1;
> +
> +	for (i = 0; i < msg_cnt; i++) {
> +		unsigned long remote_hash;
> +		unsigned long curr_hash;
> +		ssize_t recv_size;
> +
> +		control_expectln("PKTSENT");
> +		recv_size = recvmsg(fd, &msg, 0);
> +		control_writeln("PKTRECV");
> +
> +		if (!recv_size)
> +			break;
> +
> +		if (recv_size < 0) {
> +			perror("recvmsg");
> +			exit(EXIT_FAILURE);
> +		}
> +
> +		curr_hash = hash_djb2(msg.msg_iov[0].iov_base, recv_size);
> +		remote_hash = control_readulong();
> +
> +		if (curr_hash != remote_hash) {
> +			fprintf(stderr, "Message bounds broken\n");
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> +
> +	close(fd);
> +}
> +
>  static struct test_case test_cases[] = {
>  	{
>  		.name = "SOCK_STREAM connection reset",
> @@ -1128,6 +1535,31 @@ static struct test_case test_cases[] = {
>  		.run_client = test_stream_virtio_skb_merge_client,
>  		.run_server = test_stream_virtio_skb_merge_server,
>  	},
> +	{
> +		.name = "SOCK_DGRAM client sendto",
> +		.run_client = test_dgram_sendto_client,
> +		.run_server = test_dgram_sendto_server,
> +	},
> +	{
> +		.name = "SOCK_DGRAM client connect",
> +		.run_client = test_dgram_connect_client,
> +		.run_server = test_dgram_connect_server,
> +	},
> +	{
> +		.name = "SOCK_DGRAM multiple connections using sendto",
> +		.run_client = test_dgram_multiconn_sendto_client,
> +		.run_server = test_dgram_multiconn_sendto_server,
> +	},
> +	{
> +		.name = "SOCK_DGRAM multiple connections using send",
> +		.run_client = test_dgram_multiconn_send_client,
> +		.run_server = test_dgram_multiconn_send_server,
> +	},
> +	{
> +		.name = "SOCK_DGRAM msg bounds",
> +		.run_client = test_dgram_msg_bounds_client,
> +		.run_server = test_dgram_msg_bounds_server,
> +	},
>  	{},
>  };
>  
> 

