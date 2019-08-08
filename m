Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2804856F8
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 02:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389759AbfHHAIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 20:08:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42926 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389760AbfHHAIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 20:08:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so43008601pgb.9
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 17:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rr5fxBi2oSUb1ENDkejqRrom+Qly2XgxOWDI0MGIgPo=;
        b=DhonMwILImLSlS/P8FZIUgizhMMGphTP+RHTNtQ14Osysmk1euwK6qzXZM+Zd+A0ER
         /WIN57ptIz2I2jJhRhmr++8enc7p1zZCVA1cM+W5Db3UGhaq2JtkezMt2YUa+MnsvyCO
         WkJN1u4e/CTy3woFc0vWJqrk7eBPJvhd1AoyfR7QFP/1e2QXjlReBC8mS9m9SjDCYhKL
         MvPhc1bvXvSppIBSHuNd3c+uv+g2DGbJpM343Y5rXuDYU7yBJuZs0OFAACCaaphtPzHV
         a+yBOLvBOYedSZbDH5GFOwWymUlDBUEZnG0bLGlfxO3t204jGJZMP+TUy2PfNTPOpeY5
         NlOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rr5fxBi2oSUb1ENDkejqRrom+Qly2XgxOWDI0MGIgPo=;
        b=JJg5u4KAkDguNxh4v0GhouK6Fr8LPKth2qTYwXI95A07M+R9DwPIjWNkppxaGcY+dk
         FDsu/aZuntBPNOB082+wWFRyiV24E9etUydvbKdhX+kwQpdXyj3gtOk8IM6Jqe598Dgg
         TSUlQ05YFAB0OK0lMB9Cve8dw+qLmZDSLyvX5c4pXaBVOPfYY2ilCWU9hDA8ut6eIU9S
         joTNuNNE5ZddM9F3M9iIDnMotX3f/2F/hyQnjZzU58o40704xnVAxOEqay29HcgqQ3uB
         5E5cSTsepDp7N8UjhqgwJUdpU0qL6zKWW8El3yELm0bJhEBEi9npRkse5LMGgYSdqiS2
         5/vA==
X-Gm-Message-State: APjAAAXLRGL7HKqMKwhKH63FbI6x6nIUKYJaaEy4za8aGIHy5PRu05Ki
        dJTC6BeiYZXVfFcsph5qfXMjjg==
X-Google-Smtp-Source: APXvYqzod+gSnvi0x4AwWCAm9hQeGlBsEun9U0sEu29zm7bRGNRG5zYpWESsbeKPY7eDg9s4PVm14A==
X-Received: by 2002:a17:90a:246f:: with SMTP id h102mr1021035pje.126.1565222909791;
        Wed, 07 Aug 2019 17:08:29 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id p27sm137634481pfq.136.2019.08.07.17.08.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 17:08:29 -0700 (PDT)
Date:   Wed, 7 Aug 2019 17:08:28 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Yonghong Song <yhs@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add sockopt
 clone/inheritance test
Message-ID: <20190808000828.GB2820@mini-arch>
References: <20190807154720.260577-1-sdf@google.com>
 <20190807154720.260577-4-sdf@google.com>
 <5a18a8ed-ab1b-de15-5dff-2b4a068bbe56@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a18a8ed-ab1b-de15-5dff-2b4a068bbe56@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/07, Yonghong Song wrote:
> 
> 
> On 8/7/19 8:47 AM, Stanislav Fomichev wrote:
> > Add a test that calls setsockopt on the listener socket which triggers
> > BPF program. This BPF program writes to the sk storage and sets
> > clone flag. Make sure that sk storage is cloned for a newly
> > accepted connection.
> > 
> > We have two cloned maps in the tests to make sure we hit both cases
> > in bpf_sk_storage_clone: first element (sk_storage_alloc) and
> > non-first element(s) (selem_link_map).
> > 
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   tools/testing/selftests/bpf/.gitignore        |   1 +
> >   tools/testing/selftests/bpf/Makefile          |   3 +-
> >   .../selftests/bpf/progs/sockopt_inherit.c     | 102 +++++++
> >   .../selftests/bpf/test_sockopt_inherit.c      | 252 ++++++++++++++++++
> >   4 files changed, 357 insertions(+), 1 deletion(-)
> >   create mode 100644 tools/testing/selftests/bpf/progs/sockopt_inherit.c
> >   create mode 100644 tools/testing/selftests/bpf/test_sockopt_inherit.c
> > 
> > diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> > index 90f70d2c7c22..60c9338cd9b4 100644
> > --- a/tools/testing/selftests/bpf/.gitignore
> > +++ b/tools/testing/selftests/bpf/.gitignore
> > @@ -42,4 +42,5 @@ xdping
> >   test_sockopt
> >   test_sockopt_sk
> >   test_sockopt_multi
> > +test_sockopt_inherit
> >   test_tcp_rtt
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 3bd0f4a0336a..c875763a851a 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -29,7 +29,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> >   	test_cgroup_storage test_select_reuseport test_section_names \
> >   	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
> >   	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
> > -	test_sockopt_multi test_tcp_rtt
> > +	test_sockopt_multi test_sockopt_inherit test_tcp_rtt
> >   
> >   BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
> >   TEST_GEN_FILES = $(BPF_OBJ_FILES)
> > @@ -110,6 +110,7 @@ $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
> >   $(OUTPUT)/test_sockopt: cgroup_helpers.c
> >   $(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
> >   $(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
> > +$(OUTPUT)/test_sockopt_inherit: cgroup_helpers.c
> >   $(OUTPUT)/test_tcp_rtt: cgroup_helpers.c
> >   
> >   .PHONY: force
> > diff --git a/tools/testing/selftests/bpf/progs/sockopt_inherit.c b/tools/testing/selftests/bpf/progs/sockopt_inherit.c
> > new file mode 100644
> > index 000000000000..357fc9db5874
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/sockopt_inherit.c
> > @@ -0,0 +1,102 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include "bpf_helpers.h"
> > +
> > +char _license[] SEC("license") = "GPL";
> > +__u32 _version SEC("version") = 1;
> > +
> > +#define SOL_CUSTOM			0xdeadbeef
> > +#define CUSTOM_INHERIT1			0
> > +#define CUSTOM_INHERIT2			1
> > +#define CUSTOM_LISTENER			2
> > +
> > +struct sockopt_inherit {
> > +	__u8 val;
> > +};
> > +
> > +struct bpf_map_def SEC("maps") cloned1_map = {
> > +	.type = BPF_MAP_TYPE_SK_STORAGE,
> > +	.key_size = sizeof(int),
> > +	.value_size = sizeof(struct sockopt_inherit),
> > +	.map_flags = BPF_F_NO_PREALLOC,
> > +};
> > +BPF_ANNOTATE_KV_PAIR(cloned1_map, int, struct sockopt_inherit);
> > +
> > +struct bpf_map_def SEC("maps") cloned2_map = {
> > +	.type = BPF_MAP_TYPE_SK_STORAGE,
> > +	.key_size = sizeof(int),
> > +	.value_size = sizeof(struct sockopt_inherit),
> > +	.map_flags = BPF_F_NO_PREALLOC,
> > +};
> > +BPF_ANNOTATE_KV_PAIR(cloned2_map, int, struct sockopt_inherit);
> > +
> > +struct bpf_map_def SEC("maps") listener_map = {
> > +	.type = BPF_MAP_TYPE_SK_STORAGE,
> > +	.key_size = sizeof(int),
> > +	.value_size = sizeof(struct sockopt_inherit),
> > +	.map_flags = BPF_F_NO_PREALLOC,
> > +};
> > +BPF_ANNOTATE_KV_PAIR(listener_map, int, struct sockopt_inherit);
> 
> Your still use the old way for map definitions. Is this possible for you
> to use new map definitions (in section ".maps")?
Ah, my bad, I'm not used to the new defs. Will fix!

> > +
> > +static __inline struct sockopt_inherit *get_storage(struct bpf_sockopt *ctx)
> > +{
> > +	if (ctx->optname == CUSTOM_INHERIT1)
> > +		return bpf_sk_storage_get(&cloned1_map, ctx->sk, 0,
> > +					  BPF_SK_STORAGE_GET_F_CREATE |
> > +					  BPF_SK_STORAGE_GET_F_CLONE);
> > +	else if (ctx->optname == CUSTOM_INHERIT2)
> > +		return bpf_sk_storage_get(&cloned2_map, ctx->sk, 0,
> > +					  BPF_SK_STORAGE_GET_F_CREATE |
> > +					  BPF_SK_STORAGE_GET_F_CLONE);
> > +	else
> > +		return bpf_sk_storage_get(&listener_map, ctx->sk, 0,
> > +					  BPF_SK_STORAGE_GET_F_CREATE);
> > +}
> > +
> [.....]> diff --git a/tools/testing/selftests/bpf/test_sockopt_inherit.c 
> b/tools/testing/selftests/bpf/test_sockopt_inherit.c
> > new file mode 100644
> > index 000000000000..e47b9c28d743
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/test_sockopt_inherit.c
> > @@ -0,0 +1,252 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <error.h>
> > +#include <errno.h>
> > +#include <stdio.h>
> > +#include <unistd.h>
> > +#include <sys/types.h>
> > +#include <sys/socket.h>
> > +#include <netinet/in.h>
> > +#include <pthread.h>
> > +
> > +#include <linux/filter.h>
> > +#include <bpf/bpf.h>
> > +#include <bpf/libbpf.h>
> > +
> > +#include "bpf_rlimit.h"
> > +#include "bpf_util.h"
> > +#include "cgroup_helpers.h"
> > +
> > +#define CG_PATH				"/sockopt_inherit"
> > +#define SOL_CUSTOM			0xdeadbeef
> > +#define CUSTOM_INHERIT1			0
> > +#define CUSTOM_INHERIT2			1
> > +#define CUSTOM_LISTENER			2
> > +
> > +static int connect_to_server(int server_fd)
> > +{
> > +	struct sockaddr_storage addr;
> > +	socklen_t len = sizeof(addr);
> > +	int fd;
> > +
> > +	fd = socket(AF_INET, SOCK_STREAM, 0);
> > +	if (fd < 0) {
> > +		log_err("Failed to create client socket");
> > +		return -1;
> > +	}
> > +
> > +	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
> > +		log_err("Failed to get server addr");
> > +		goto out;
> > +	}
> > +
> > +	if (connect(fd, (const struct sockaddr *)&addr, len) < 0) {
> > +		log_err("Fail to connect to server");
> > +		goto out;
> > +	}
> > +
> > +	return fd;
> > +
> > +out:
> > +	close(fd);
> > +	return -1;
> > +}
> > +
> > +static int verify_sockopt(int fd, int optname, const char *msg, char expected)
> > +{
> > +	socklen_t optlen = 1;
> > +	char buf = 0;
> > +	int err;
> > +
> > +	err = getsockopt(fd, SOL_CUSTOM, optname, &buf, &optlen);
> > +	if (err) {
> > +		log_err("%s: failed to call getsockopt", msg);
> > +		return 1;
> > +	}
> > +
> > +	log_err("%s %d: got=0x%x ? expected=0x%x", msg, optname, buf, expected);
> 
> There may not be error here.
Good point, will switch to simple printf.

> > +
> > +	if (buf != expected) {
> > +		log_err("%s: unexpected getsockopt value %d != %d", msg,
> > +			buf, expected);
> > +		return 1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void *server_thread(void *arg)
> > +{
> > +	struct sockaddr_storage addr;
> > +	socklen_t len = sizeof(addr);
> > +	int fd = *(int *)arg;
> > +	int client_fd;
> > +	int err = 0;
> > +
> > +	if (listen(fd, 1) < 0)
> > +		error(1, errno, "Failed to listed on socket");
> > +
> > +	err += verify_sockopt(fd, CUSTOM_INHERIT1, "listen", 1);
> > +	err += verify_sockopt(fd, CUSTOM_INHERIT2, "listen", 1);
> > +	err += verify_sockopt(fd, CUSTOM_LISTENER, "listen", 1);
> > +
> > +	client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> > +	if (client_fd < 0)
> > +		error(1, errno, "Failed to accept client");
> > +
> > +	err += verify_sockopt(client_fd, CUSTOM_INHERIT1, "accept", 1);
> > +	err += verify_sockopt(client_fd, CUSTOM_INHERIT2, "accept", 1);
> > +	err += verify_sockopt(client_fd, CUSTOM_LISTENER, "accept", 0);
> > +
> > +	close(client_fd);
> > +
> > +	return (void *)(long)err;
> > +}
> > +
> > +static int start_server(void)
> > +{
> > +	struct sockaddr_in addr = {
> > +		.sin_family = AF_INET,
> > +		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
> > +	};
> > +	char buf;
> > +	int err;
> > +	int fd;
> > +	int i;
> > +
> > +	fd = socket(AF_INET, SOCK_STREAM, 0);
> > +	if (fd < 0) {
> > +		log_err("Failed to create server socket");
> > +		return -1;
> > +	}
> > +
> > +	for (i = CUSTOM_INHERIT1; i <= CUSTOM_LISTENER; i++) {
> > +		buf = 0x01;
> > +		err = setsockopt(fd, SOL_CUSTOM, i, &buf, 1);
> > +		if (err) {
> > +			log_err("Failed to call setsockopt(%d)", i);
> > +			close(fd);
> > +			return -1;
> > +		}
> > +	}
> > +
> > +	if (bind(fd, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
> > +		log_err("Failed to bind socket");
> > +		close(fd);
> > +		return -1;
> > +	}
> > +
> > +	return fd;
> > +}
> > +
> > +static int prog_attach(struct bpf_object *obj, int cgroup_fd, const char *title)
> > +{
> > +	enum bpf_attach_type attach_type;
> > +	enum bpf_prog_type prog_type;
> > +	struct bpf_program *prog;
> > +	int err;
> > +
> > +	err = libbpf_prog_type_by_name(title, &prog_type, &attach_type);
> > +	if (err) {
> > +		log_err("Failed to deduct types for %s BPF program", title);
> > +		return -1;
> > +	}
> > +
> > +	prog = bpf_object__find_program_by_title(obj, title);
> > +	if (!prog) {
> > +		log_err("Failed to find %s BPF program", title);
> > +		return -1;
> > +	}
> > +
> > +	err = bpf_prog_attach(bpf_program__fd(prog), cgroup_fd,
> > +			      attach_type, 0);
> > +	if (err) {
> > +		log_err("Failed to attach %s BPF program", title);
> > +		return -1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int run_test(int cgroup_fd)
> > +{
> > +	struct bpf_prog_load_attr attr = {
> > +		.file = "./sockopt_inherit.o",
> > +	};
> > +	int server_fd = -1, client_fd;
> > +	struct bpf_object *obj;
> > +	void *server_err;
> > +	pthread_t tid;
> > +	int ignored;
> > +	int err;
> > +
> > +	err = bpf_prog_load_xattr(&attr, &obj, &ignored);
> > +	if (err) {
> > +		log_err("Failed to load BPF object");
> > +		return -1;
> > +	}
> > +
> > +	err = prog_attach(obj, cgroup_fd, "cgroup/getsockopt");
> > +	if (err)
> > +		goto close_bpf_object;
> > +
> > +	err = prog_attach(obj, cgroup_fd, "cgroup/setsockopt");
> > +	if (err)
> > +		goto close_bpf_object;
> > +
> > +	server_fd = start_server();
> > +	if (server_fd < 0) {
> > +		err = -1;
> > +		goto close_bpf_object;
> > +	}
> > +
> > +	pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
> > +
> > +	client_fd = connect_to_server(server_fd);
> > +	if (client_fd < 0) {
> > +		err = -1;
> > +		goto close_bpf_object;
> > +	}
> > +
> > +	err += verify_sockopt(client_fd, CUSTOM_INHERIT1, "connect", 0);
> > +	err += verify_sockopt(client_fd, CUSTOM_INHERIT2, "connect", 0);
> > +	err += verify_sockopt(client_fd, CUSTOM_LISTENER, "connect", 0);
> > +
> > +	pthread_join(tid, &server_err);
> > +
> > +	err += (int)(long)server_err;
> > +
> > +	close(client_fd);
> > +
> > +close_bpf_object:
> > +	bpf_object__close(obj);
> > +	close(server_fd);
> 
> server_fd could be -1 here.
I've initialized it to -1 so we can close(-1) here and not close(some
random data). Shouldn't be a problem, right?

The order is backwards though, should be:
close(server_fd);
bpf_object__close(obj);

I can probably add a label for bpf_object__close case to avoid this close(-1).
Will do for a v2.

> > +	return err;
> > +}
> > +
> > +int main(int args, char **argv)
> > +{
> > +	int cgroup_fd;
> > +	int err = EXIT_SUCCESS;
> > +
> > +	if (setup_cgroup_environment())
> > +		return err;
> > +
> > +	cgroup_fd = create_and_get_cgroup(CG_PATH);
> > +	if (cgroup_fd < 0)
> > +		goto cleanup_cgroup_env;
> > +
> > +	if (join_cgroup(CG_PATH))
> > +		goto cleanup_cgroup;
> > +
> > +	if (run_test(cgroup_fd))
> > +		err = EXIT_FAILURE;
> > +
> > +	printf("test_sockopt_inherit: %s\n",
> > +	       err == EXIT_SUCCESS ? "PASSED" : "FAILED");
> > +
> > +cleanup_cgroup:
> > +	close(cgroup_fd);
> > +cleanup_cgroup_env:
> > +	cleanup_cgroup_environment();
> > +	return err;
> > +}
> > 
