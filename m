Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E1B5C634
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 02:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfGBAHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 20:07:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35695 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfGBAHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 20:07:38 -0400
Received: by mail-pf1-f194.google.com with SMTP id d126so7328791pfd.2
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 17:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+Ma9H81j4hMBxNMH2uPVvLNFxVhLg0vo/ogyRC9mka8=;
        b=XexPuGm7eXhN5rJnmF3rmFYQgcabGrVVFrZMqk6+RJiRY1I8tQlSRulvrpgxnWAglP
         mSttGYWiBTvB+JkOqD93x2CzgVXX44v9bD4A27K4tHXVi1kc6FEKdecXwbPXIOoBf3zj
         27/6qzvlz8DSqRBPrhIrBIoee83/eOSE7Zw1PwoRXh0HynleIuEu2/FUMdzMytzG700O
         UaM3y7dY/aZGUzOwnm1k0U2QwWUkkIzyb166t6qNHoIbi8hvkvRurGN84deH8Tr1bsJp
         d35QsJLRVgYQ7EshawvsZ+d1kw2PvU86+ZDLq9hsWT5D3BXN4Yh4UOIkS38BmEV5lSfm
         RTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+Ma9H81j4hMBxNMH2uPVvLNFxVhLg0vo/ogyRC9mka8=;
        b=lbCx2JyoTGOxJMto7+hhPgs+IslmR2llsj1pvFoKTbBLwnRZGU2PcAe/HRwEAQOzW3
         tGtpP/F6uepw+dI1ID+q6MeuKjhdlRXUV9BDatZ3lLCsMTXpCeOyLCxDwrg/oknl/6BT
         mEUCC/jLBBTv8DIF7E2trJAlRLmG2NP5YPF3B1oBIJ2D9c/v0lPSXt4rHCCKsGPqXiSo
         ncM41Twka3nm5hwBNVzCyv/VmJ1JNGtwLG3RixTWzgJkOSjbRkBWYn07irx5Uf1LNrpL
         5g3r6MwSwaXO4iXi6d7PfDJ+YPsvdjCggDHtQ/sTz+PNGAw74PTrNhdrvQDH2il5SY/t
         4syA==
X-Gm-Message-State: APjAAAX1A/CnenDFeh3POlnb3d2ya8yPBBIhwFWs+pgtaioeffghjJLs
        00AAa7YEtZcgYKLhw+1P5/NLJA==
X-Google-Smtp-Source: APXvYqwRP+SYGVqGwymL7Wj2llY7yZQwNDX11jUEpVdOP53kyeDxyiJY9FuKeCu/KUQFkm4206y/5g==
X-Received: by 2002:a17:90a:5806:: with SMTP id h6mr2109411pji.126.1562026057865;
        Mon, 01 Jul 2019 17:07:37 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id j16sm503100pjz.31.2019.07.01.17.07.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 17:07:37 -0700 (PDT)
Date:   Mon, 1 Jul 2019 17:07:36 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Y Song <ys114321@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH bpf-next 6/8] selftests/bpf: test BPF_SOCK_OPS_RTT_CB
Message-ID: <20190702000736.GH6757@mini-arch>
References: <20190701204821.44230-1-sdf@google.com>
 <20190701204821.44230-7-sdf@google.com>
 <CAH3MdRXx4uO3pTFiLZk8j9ooO0gd1ppbSyT8zHMsVs01P6wKpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3MdRXx4uO3pTFiLZk8j9ooO0gd1ppbSyT8zHMsVs01P6wKpA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01, Y Song wrote:
> On Mon, Jul 1, 2019 at 1:49 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Make sure the callback is invoked for syn-ack and data packet.
> >
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Priyaranjan Jha <priyarjha@google.com>
> > Cc: Yuchung Cheng <ycheng@google.com>
> > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile        |   3 +-
> >  tools/testing/selftests/bpf/progs/tcp_rtt.c |  61 +++++
> >  tools/testing/selftests/bpf/test_tcp_rtt.c  | 253 ++++++++++++++++++++
> >  3 files changed, 316 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
> >  create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index de1754a8f5fe..2620406a53ec 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -27,7 +27,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> >         test_cgroup_storage test_select_reuseport test_section_names \
> >         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
> >         test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
> > -       test_sockopt_multi
> > +       test_sockopt_multi test_tcp_rtt
> >
> >  BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
> >  TEST_GEN_FILES = $(BPF_OBJ_FILES)
> > @@ -107,6 +107,7 @@ $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
> >  $(OUTPUT)/test_sockopt: cgroup_helpers.c
> >  $(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
> >  $(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
> > +$(OUTPUT)/test_tcp_rtt: cgroup_helpers.c
> >
> >  .PHONY: force
> >
> > diff --git a/tools/testing/selftests/bpf/progs/tcp_rtt.c b/tools/testing/selftests/bpf/progs/tcp_rtt.c
> > new file mode 100644
> > index 000000000000..233bdcb1659e
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/tcp_rtt.c
> > @@ -0,0 +1,61 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include "bpf_helpers.h"
> > +
> > +char _license[] SEC("license") = "GPL";
> > +__u32 _version SEC("version") = 1;
> > +
> > +struct tcp_rtt_storage {
> > +       __u32 invoked;
> > +       __u32 dsack_dups;
> > +       __u32 delivered;
> > +       __u32 delivered_ce;
> > +       __u32 icsk_retransmits;
> > +};
> > +
> > +struct bpf_map_def SEC("maps") socket_storage_map = {
> > +       .type = BPF_MAP_TYPE_SK_STORAGE,
> > +       .key_size = sizeof(int),
> > +       .value_size = sizeof(struct tcp_rtt_storage),
> > +       .map_flags = BPF_F_NO_PREALLOC,
> > +};
> > +BPF_ANNOTATE_KV_PAIR(socket_storage_map, int, struct tcp_rtt_storage);
> > +
> > +SEC("sockops")
> > +int _sockops(struct bpf_sock_ops *ctx)
> > +{
> > +       struct tcp_rtt_storage *storage;
> > +       struct bpf_tcp_sock *tcp_sk;
> > +       int op = (int) ctx->op;
> > +       struct bpf_sock *sk;
> > +
> > +       sk = ctx->sk;
> > +       if (!sk)
> > +               return 1;
> > +
> > +       storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
> > +                                    BPF_SK_STORAGE_GET_F_CREATE);
> > +       if (!storage)
> > +               return 1;
> > +
> > +       if (op == BPF_SOCK_OPS_TCP_CONNECT_CB) {
> > +               bpf_sock_ops_cb_flags_set(ctx, BPF_SOCK_OPS_RTT_CB_FLAG);
> > +               return 1;
> > +       }
> > +
> > +       if (op != BPF_SOCK_OPS_RTT_CB)
> > +               return 1;
> > +
> > +       tcp_sk = bpf_tcp_sock(sk);
> > +       if (!tcp_sk)
> > +               return 1;
> > +
> > +       storage->invoked++;
> > +
> > +       storage->dsack_dups = tcp_sk->dsack_dups;
> > +       storage->delivered = tcp_sk->delivered;
> > +       storage->delivered_ce = tcp_sk->delivered_ce;
> > +       storage->icsk_retransmits = tcp_sk->icsk_retransmits;
> > +
> > +       return 1;
> > +}
> > diff --git a/tools/testing/selftests/bpf/test_tcp_rtt.c b/tools/testing/selftests/bpf/test_tcp_rtt.c
> > new file mode 100644
> > index 000000000000..413fd8514adc
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/test_tcp_rtt.c
> > @@ -0,0 +1,253 @@
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
> > +#define CG_PATH                                "/tcp_rtt"
> > +
> > +struct tcp_rtt_storage {
> > +       __u32 invoked;
> > +       __u32 dsack_dups;
> > +       __u32 delivered;
> > +       __u32 delivered_ce;
> > +       __u32 icsk_retransmits;
> > +};
> > +
> > +static void send_byte(int fd)
> > +{
> > +       char b = 0x55;
> > +
> > +       if (write(fd, &b, sizeof(b)) != 1)
> > +               error(1, errno, "Failed to send single byte");
> > +}
> > +
> > +static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
> > +                    __u32 dsack_dups, __u32 delivered, __u32 delivered_ce,
> > +                    __u32 icsk_retransmits)
> > +{
> > +       int err = 0;
> > +       struct tcp_rtt_storage val;
> > +
> > +       if (bpf_map_lookup_elem(map_fd, &client_fd, &val) < 0)
> > +               error(1, errno, "Failed to read socket storage");
> > +
> > +       if (val.invoked != invoked) {
> > +               log_err("%s: unexpected bpf_tcp_sock.invoked %d != %d",
> > +                       msg, val.invoked, invoked);
> > +               err++;
> > +       }
> > +
> > +       if (val.dsack_dups != dsack_dups) {
> > +               log_err("%s: unexpected bpf_tcp_sock.dsack_dups %d != %d",
> > +                       msg, val.dsack_dups, dsack_dups);
> > +               err++;
> > +       }
> > +
> > +       if (val.delivered != delivered) {
> > +               log_err("%s: unexpected bpf_tcp_sock.delivered %d != %d",
> > +                       msg, val.delivered, delivered);
> > +               err++;
> > +       }
> > +
> > +       if (val.delivered_ce != delivered_ce) {
> > +               log_err("%s: unexpected bpf_tcp_sock.delivered_ce %d != %d",
> > +                       msg, val.delivered_ce, delivered_ce);
> > +               err++;
> > +       }
> > +
> > +       if (val.icsk_retransmits != icsk_retransmits) {
> > +               log_err("%s: unexpected bpf_tcp_sock.icsk_retransmits %d != %d",
> > +                       msg, val.icsk_retransmits, icsk_retransmits);
> > +               err++;
> > +       }
> > +
> > +       return err;
> > +}
> > +
> > +static int connect_to_server(int server_fd)
> > +{
> > +       struct sockaddr_storage addr;
> > +       socklen_t len = sizeof(addr);
> > +       int fd;
> > +
> > +       fd = socket(AF_INET, SOCK_STREAM, 0);
> > +       if (fd < 0) {
> > +               log_err("Failed to create client socket");
> > +               return -1;
> > +       }
> > +
> > +       if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
> > +               log_err("Failed to get server addr");
> > +               goto out;
> > +       }
> > +
> > +       if (connect(fd, (const struct sockaddr *)&addr, len) < 0) {
> > +               log_err("Fail to connect to server");
> > +               goto out;
> > +       }
> > +
> > +       return fd;
> > +
> > +out:
> > +       close(fd);
> > +       return -1;
> > +}
> > +
> > +static int run_test(int cgroup_fd, int server_fd)
> > +{
> > +       struct bpf_prog_load_attr attr = {
> > +               .prog_type = BPF_PROG_TYPE_SOCK_OPS,
> > +               .file = "./tcp_rtt.o",
> > +               .expected_attach_type = BPF_CGROUP_SOCK_OPS,
> > +       };
> > +       struct bpf_program *prog;
> > +       struct bpf_object *obj;
> > +       struct bpf_map *map;
> > +       int client_fd;
> > +       int ignored;
> > +       int map_fd;
> > +       int err;
> > +
> > +       err = bpf_prog_load_xattr(&attr, &obj, &ignored);
> > +       if (err) {
> > +               log_err("Failed to load BPF object");
> > +               return -1;
> > +       }
> 
> The third argument of bpf_prog_load_xattr is prog_fd.
> If you have it, you do not need the below retrieving prog_fd
> by bpf_program__fd(prog).
Ack. I think I copy-pasted it from my other test where
I have multiple progs in the object file and attach them
manually by name. Will s/ignored/prog_fd/ in the v2.

> > +
> > +       map = bpf_map__next(NULL, obj);
> > +       map_fd = bpf_map__fd(map);
> > +
> > +       prog = bpf_program__next(NULL, obj);
> > +       err = bpf_prog_attach(bpf_program__fd(prog), cgroup_fd,
> > +                             BPF_CGROUP_SOCK_OPS, 0);
> > +       if (err) {
> > +               log_err("Failed to attach BPF program");
> > +               goto close_bpf_object;
> > +       }
> > +
> > +       client_fd = connect_to_server(server_fd);
> > +       if (client_fd < 0) {
> > +               err = -1;
> > +               goto close_bpf_object;
> > +       }
> > +
> > +       err += verify_sk(map_fd, client_fd, "syn-ack",
> > +                        /*invoked=*/1,
> > +                        /*dsack_dups=*/0,
> > +                        /*delivered=*/1,
> > +                        /*delivered_ce=*/0,
> > +                        /*icsk_retransmits=*/0);
> > +
> > +       send_byte(client_fd);
> > +
> > +       err += verify_sk(map_fd, client_fd, "first payload byte",
> > +                        /*invoked=*/2,
> > +                        /*dsack_dups=*/0,
> > +                        /*delivered=*/2,
> > +                        /*delivered_ce=*/0,
> > +                        /*icsk_retransmits=*/0);
> > +
> > +       close(client_fd);
> > +
> > +close_bpf_object:
> > +       bpf_object__close(obj);
> > +       return err;
> > +}
> > +
> > +static int start_server(void)
> > +{
> > +       struct sockaddr_in addr = {
> > +               .sin_family = AF_INET,
> > +               .sin_addr.s_addr = htonl(INADDR_LOOPBACK),
> > +       };
> > +       int fd;
> > +
> > +       fd = socket(AF_INET, SOCK_STREAM, 0);
> > +       if (fd < 0) {
> > +               log_err("Failed to create server socket");
> > +               return -1;
> > +       }
> > +
> > +       if (bind(fd, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
> > +               log_err("Failed to bind socket");
> > +               close(fd);
> > +               return -1;
> > +       }
> > +
> > +       return fd;
> > +}
> > +
> > +static void *server_thread(void *arg)
> > +{
> > +       struct sockaddr_storage addr;
> > +       socklen_t len = sizeof(addr);
> > +       int fd = *(int *)arg;
> > +       int client_fd;
> > +
> > +       if (listen(fd, 1) < 0)
> > +               error(1, errno, "Failed to listed on socket");
> 
> The error() here only reports the error, right? In case of error,
> should the control jumps to the end of this function and return?
> The same for several error() calls below.
No, error() calls exit(), so the whole process should die. Do you think
it's better to gracefully handle that with pthread_join?

> > +
> > +       client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> > +       if (client_fd < 0)
> > +               error(1, errno, "Failed to accept client");
> > +
> > +       if (accept(fd, (struct sockaddr *)&addr, &len) >= 0)
> > +               error(1, errno, "Unexpected success in second accept");
> 
> What is the purpose of this second default to-be-failed accept() call?
So the server_thread waits here for the next client (that never arrives)
and doesn't exit and call close(client_fd). I can add a comment here to
clarify. Alternatively, I can just drop close(client_fd) and let
the thread exit. WDYT?

> > +
> > +       close(client_fd);
> > +
> > +       return NULL;
> > +}
> > +
> > +int main(int args, char **argv)
> > +{
> > +       int server_fd, cgroup_fd;
> > +       int err = EXIT_SUCCESS;
> > +       pthread_t tid;
> > +
> > +       if (setup_cgroup_environment())
> > +               goto cleanup_obj;
> > +
> > +       cgroup_fd = create_and_get_cgroup(CG_PATH);
> > +       if (cgroup_fd < 0)
> > +               goto cleanup_cgroup_env;
> > +
> > +       if (join_cgroup(CG_PATH))
> > +               goto cleanup_cgroup;
> > +
> > +       server_fd = start_server();
> > +       if (server_fd < 0) {
> > +               err = EXIT_FAILURE;
> > +               goto cleanup_cgroup;
> > +       }
> > +
> > +       pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
> > +
> > +       if (run_test(cgroup_fd, server_fd))
> > +               err = EXIT_FAILURE;
> > +
> > +       close(server_fd);
> > +
> > +       printf("test_sockopt_sk: %s\n",
> > +              err == EXIT_SUCCESS ? "PASSED" : "FAILED");
> > +
> > +cleanup_cgroup:
> > +       close(cgroup_fd);
> > +cleanup_cgroup_env:
> > +       cleanup_cgroup_environment();
> > +cleanup_obj:
> > +       return err;
> > +}
> > --
> > 2.22.0.410.gd8fdbe21b5-goog
> >
