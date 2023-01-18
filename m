Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BA5674285
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjASTPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjASTOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:14:22 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F651966CA;
        Thu, 19 Jan 2023 11:13:05 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c26so2245247pfp.10;
        Thu, 19 Jan 2023 11:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hp6yFzF+wsVEa0WBaxMhTO9O/mR1H5I+SKpcOxOzy5Q=;
        b=jSnBKmfpUvc+un0ORHkgMHkHhLCrX46czrBEvsYvY3rNao+BfXLO00yf6juMSQxzeG
         AMvRNowqWEtvr6xIstUJE/jUC/B59U+5ALN/BHTt7lH4mj942gu1TeXXX/nyQio0qxo8
         OPpDK4TCS1Z8uY3Q1AaqT4Xfqh8vhSNiy+RMs5q3p9Ozu/HFw2ThlfB2JdLSIbtnU7SI
         zVlzzDOHCkmfUyxho1of2ZzUOb2NU54nY+UClCIkLTCKoiohf0nUaf7F9K2g60NOcUFV
         hnBqlclV9PHiFFjcOkXdPEg3YAWzSYrgSidbo89nXx9oYfqz2kbD0BGgb/OoAkKWmqDj
         OJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hp6yFzF+wsVEa0WBaxMhTO9O/mR1H5I+SKpcOxOzy5Q=;
        b=WvR2QNzhZc5PrOl4wLNxx5nQAq7jQw1bzTn7A4dAZUNAXkSq21EImSOvipnr6qF9bG
         vY+ETRwyhimnLv9kmZ5iqzCe9Pi3AjAA0R4+Ibk79YYpMEvzxOnwdu4E5GMQPfCGXvhZ
         6wmny08wnxNwjCe4JiDhGa1+CnDSIsNJ1XnqbOE9iWfVcWCrNPZuI8MJMUixMQLL1Hfr
         OgSGhhiIYiEI2hGSYt8OAXxNZEpH606LocUDKh7/hY90AyXkp6C9M384Qprn/qg4JDsD
         hZ8rlARFrgsNAhfssriYkXwEPLKL4MXYkv/lE0PIgC/3DHDy1OW3Pws+tZXg+E8fDrcF
         vhhg==
X-Gm-Message-State: AFqh2krbIBGAb4pqRUs3IPSxPUHGZeDNV4X//aqjzub+VB4o7Uy0O/Es
        Zk0Cmn6gT0nksvZbWlM4SiY=
X-Google-Smtp-Source: AMrXdXttYXeHlAHsKvGQuRpv00MAksbsNKqK1QF216tiS6HVa5WDr4jr7q1JXOcqDjYlV4ASgYyv/Q==
X-Received: by 2002:aa7:9607:0:b0:580:9e9e:c442 with SMTP id q7-20020aa79607000000b005809e9ec442mr13174811pfg.24.1674155582525;
        Thu, 19 Jan 2023 11:13:02 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id x10-20020aa79aca000000b0058a0e61136asm18539819pfp.66.2023.01.19.11.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 11:13:02 -0800 (PST)
Date:   Wed, 18 Jan 2023 15:14:02 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC 3/3] selftests/bpf: Add a test case for vsock sockmap
Message-ID: <Y8gMugD5vEi1BwBu@bullseye>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
 <20230118-support-vsock-sockmap-connectible-v1-3-d47e6294827b@bytedance.com>
 <20230119104813.2bkmb3t43eq63i3o@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119104813.2bkmb3t43eq63i3o@sgarzare-redhat>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 11:48:13AM +0100, Stefano Garzarella wrote:
> On Wed, Jan 18, 2023 at 12:27:41PM -0800, Bobby Eshleman wrote:
> > Add a test case testing the redirection from connectible AF_VSOCK
> > sockets to connectible AF_UNIX sockets.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> > .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++++
> > 1 file changed, 163 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > index 2cf0c7a3fe232..8b5a2e09c9ede 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > @@ -18,6 +18,7 @@
> > #include <string.h>
> > #include <sys/select.h>
> > #include <unistd.h>
> > +#include <linux/vm_sockets.h>
> > 
> > #include <bpf/bpf.h>
> > #include <bpf/libbpf.h>
> > @@ -249,6 +250,16 @@ static void init_addr_loopback6(struct sockaddr_storage *ss, socklen_t *len)
> > 	*len = sizeof(*addr6);
> > }
> > 
> > +static void init_addr_loopback_vsock(struct sockaddr_storage *ss, socklen_t *len)
> > +{
> > +	struct sockaddr_vm *addr = memset(ss, 0, sizeof(*ss));
> > +
> > +	addr->svm_family = AF_VSOCK;
> > +	addr->svm_port = VMADDR_PORT_ANY;
> > +	addr->svm_cid = VMADDR_CID_LOCAL;
> 
> Wait, IIUC we only use loopback, so why do we need to attach the
> vhost-vsock-pci device to QEMU?
> 
> At that point if we add CONFIG_VSOCKETS_LOOPBACK in all configurations, it
> should also work with aarch64 and s390x.
> 

Oh that is great, I'll drop the vhost-vsock-pci device then. I thought
adding it fixed the error I was getting when trying to use
VMADDR_CID_LOCAL, but it must have just been adding
CONFIG_VSOCKETS_LOOPBACK that fixed it.

Thanks,
Bobby

> > +	*len = sizeof(*addr);
> > +}
> > +
> > static void init_addr_loopback(int family, struct sockaddr_storage *ss,
> > 			       socklen_t *len)
> > {
> > @@ -259,6 +270,9 @@ static void init_addr_loopback(int family, struct sockaddr_storage *ss,
> > 	case AF_INET6:
> > 		init_addr_loopback6(ss, len);
> > 		return;
> > +	case AF_VSOCK:
> > +		init_addr_loopback_vsock(ss, len);
> > +		return;
> > 	default:
> > 		FAIL("unsupported address family %d", family);
> > 	}
> > @@ -1434,6 +1448,8 @@ static const char *family_str(sa_family_t family)
> > 		return "IPv6";
> > 	case AF_UNIX:
> > 		return "Unix";
> > +	case AF_VSOCK:
> > +		return "VSOCK";
> > 	default:
> > 		return "unknown";
> > 	}
> > @@ -1644,6 +1660,151 @@ static void test_unix_redir(struct test_sockmap_listen *skel, struct bpf_map *ma
> > 	unix_skb_redir_to_connected(skel, map, sotype);
> > }
> > 
> > +/* Returns two connected loopback vsock sockets */
> > +static int vsock_socketpair_connectible(int sotype, int *v0, int *v1)
> > +{
> > +	struct sockaddr_storage addr;
> > +	socklen_t len = sizeof(addr);
> > +	int s, p, c;
> > +
> > +	s = socket_loopback(AF_VSOCK, sotype);
> > +	if (s < 0)
> > +		return -1;
> > +
> > +	c = xsocket(AF_VSOCK, sotype | SOCK_NONBLOCK, 0);
> > +	if (c == -1)
> > +		goto close_srv;
> > +
> > +	if (getsockname(s, sockaddr(&addr), &len) < 0)
> > +		goto close_cli;
> > +
> > +	if (connect(c, sockaddr(&addr), len) < 0 && errno != EINPROGRESS) {
> > +		FAIL_ERRNO("connect");
> > +		goto close_cli;
> > +	}
> > +
> > +	len = sizeof(addr);
> > +	p = accept_timeout(s, sockaddr(&addr), &len, IO_TIMEOUT_SEC);
> > +	if (p < 0)
> > +		goto close_cli;
> > +
> > +	*v0 = p;
> > +	*v1 = c;
> > +
> > +	return 0;
> > +
> > +close_cli:
> > +	close(c);
> > +close_srv:
> > +	close(s);
> > +
> > +	return -1;
> > +}
> > +
> > +static void vsock_unix_redir_connectible(int sock_mapfd, int verd_mapfd,
> > +					 enum redir_mode mode, int sotype)
> > +{
> > +	const char *log_prefix = redir_mode_str(mode);
> > +	char a = 'a', b = 'b';
> > +	int u0, u1, v0, v1;
> > +	int sfd[2];
> > +	unsigned int pass;
> > +	int err, n;
> > +	u32 key;
> > +
> > +	zero_verdict_count(verd_mapfd);
> > +
> > +	if (socketpair(AF_UNIX, SOCK_STREAM | SOCK_NONBLOCK, 0, sfd))
> > +		return;
> > +
> > +	u0 = sfd[0];
> > +	u1 = sfd[1];
> > +
> > +	err = vsock_socketpair_connectible(sotype, &v0, &v1);
> > +	if (err) {
> > +		FAIL("vsock_socketpair_connectible() failed");
> > +		goto close_uds;
> > +	}
> > +
> > +	err = add_to_sockmap(sock_mapfd, u0, v0);
> > +	if (err) {
> > +		FAIL("add_to_sockmap failed");
> > +		goto close_vsock;
> > +	}
> > +
> > +	n = write(v1, &a, sizeof(a));
> > +	if (n < 0)
> > +		FAIL_ERRNO("%s: write", log_prefix);
> > +	if (n == 0)
> > +		FAIL("%s: incomplete write", log_prefix);
> > +	if (n < 1)
> > +		goto out;
> > +
> > +	n = recv(mode == REDIR_INGRESS ? u0 : u1, &b, sizeof(b), MSG_DONTWAIT);
> > +	if (n < 0)
> > +		FAIL("%s: recv() err, errno=%d", log_prefix, errno);
> > +	if (n == 0)
> > +		FAIL("%s: incomplete recv", log_prefix);
> > +	if (b != a)
> > +		FAIL("%s: vsock socket map failed, %c != %c", log_prefix, a, b);
> > +
> > +	key = SK_PASS;
> > +	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
> > +	if (err)
> > +		goto out;
> > +	if (pass != 1)
> > +		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
> > +out:
> > +	key = 0;
> > +	bpf_map_delete_elem(sock_mapfd, &key);
> > +	key = 1;
> > +	bpf_map_delete_elem(sock_mapfd, &key);
> > +
> > +close_vsock:
> > +	close(v0);
> > +	close(v1);
> > +
> > +close_uds:
> > +	close(u0);
> > +	close(u1);
> > +}
> > +
> > +static void vsock_unix_skb_redir_connectible(struct test_sockmap_listen *skel,
> > +					     struct bpf_map *inner_map,
> > +					     int sotype)
> > +{
> > +	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
> > +	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
> > +	int sock_map = bpf_map__fd(inner_map);
> > +	int err;
> > +
> > +	err = xbpf_prog_attach(verdict, sock_map, BPF_SK_SKB_VERDICT, 0);
> > +	if (err)
> > +		return;
> > +
> > +	skel->bss->test_ingress = false;
> > +	vsock_unix_redir_connectible(sock_map, verdict_map, REDIR_EGRESS, sotype);
> > +	skel->bss->test_ingress = true;
> > +	vsock_unix_redir_connectible(sock_map, verdict_map, REDIR_INGRESS, sotype);
> > +
> > +	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
> > +}
> > +
> > +static void test_vsock_redir(struct test_sockmap_listen *skel, struct bpf_map *map)
> > +{
> > +	const char *family_name, *map_name;
> > +	char s[MAX_TEST_NAME];
> > +
> > +	family_name = family_str(AF_VSOCK);
> > +	map_name = map_type_str(map);
> > +	snprintf(s, sizeof(s), "%s %s %s", map_name, family_name, __func__);
> > +	if (!test__start_subtest(s))
> > +		return;
> > +
> > +	vsock_unix_skb_redir_connectible(skel, map, SOCK_STREAM);
> > +	vsock_unix_skb_redir_connectible(skel, map, SOCK_SEQPACKET);
> > +}
> > +
> > static void test_reuseport(struct test_sockmap_listen *skel,
> > 			   struct bpf_map *map, int family, int sotype)
> > {
> > @@ -2015,12 +2176,14 @@ void serial_test_sockmap_listen(void)
> > 	run_tests(skel, skel->maps.sock_map, AF_INET6);
> > 	test_unix_redir(skel, skel->maps.sock_map, SOCK_DGRAM);
> > 	test_unix_redir(skel, skel->maps.sock_map, SOCK_STREAM);
> > +	test_vsock_redir(skel, skel->maps.sock_map);
> > 
> > 	skel->bss->test_sockmap = false;
> > 	run_tests(skel, skel->maps.sock_hash, AF_INET);
> > 	run_tests(skel, skel->maps.sock_hash, AF_INET6);
> > 	test_unix_redir(skel, skel->maps.sock_hash, SOCK_DGRAM);
> > 	test_unix_redir(skel, skel->maps.sock_hash, SOCK_STREAM);
> > +	test_vsock_redir(skel, skel->maps.sock_hash);
> > 
> > 	test_sockmap_listen__destroy(skel);
> > }
> > 
> > -- 
> > 2.30.2
> > 
> 
