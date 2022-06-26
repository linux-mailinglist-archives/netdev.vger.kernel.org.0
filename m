Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C461B55B450
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 00:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiFZWZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 18:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiFZWZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 18:25:44 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7B1DCF
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 15:25:42 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r20so10584177wra.1
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 15:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s+dgsXRt/LD5HOKTWG6kpxxxI37rY1+ymJqnYir9O74=;
        b=hPXdrkt/MlIbpNBa4jWVeunkIFjqlt9pbLuIqGMYcBU+pygXnNctEsLV7C+XUPHErv
         8m8dCrcG4uf4EWZlpDbcfVsC8Ifn5RhSLTkYxUH+Duijh9RaCwm+ydrKgbZ6XrfYfbO6
         o9v7xJCYqz6XJYJO9N+1OMRBQo3WUNKjs0wfgXKsx1vS0KJpFcKzwuBv6IVWB2qIGJti
         yqB8wfNDTWP47uTumZC0KO3Nzbn1KDEO/gU2ZRyzcqj+X3H2A5Q/ttUiFj69khEEKErJ
         FouTYrZgxqrkVS4o5KK3n1BIjuDro1QXHxgWHhn6Q/MwNl2V5vd9YU+93YvRs8IHW4Bb
         9GHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s+dgsXRt/LD5HOKTWG6kpxxxI37rY1+ymJqnYir9O74=;
        b=QEIZactzYOP7ctaEutlpVnVouhhDH+i3owHgXFqyiB6hmRuo6u8DTvuuab8kjj3N9j
         EqTrorQ6Z2JCY5Ob8wql2bVlLqqNXWQxjojMaBDcBDPv2G2Z78UFXeCWK6aI2xW/YyGf
         YR0ukoiusrLqLaJZAWSVlDpzcmjCRa5n0eresKmIN3WMC6ukmqLT7vJ1IOiYSbnMzzgA
         Uowl/I4ldT0lrVrMmPq6TTVVtMEn3dJ24hGxpgHzSZQGGuovgVK8pWSiN+T/EqGkvsvw
         c4aTIoUS1prqS6vpHugJ1HMmOZi5CmriXri4exCagUjBSPNxlw3IWek4wd9/CYMP1ZH+
         RA0w==
X-Gm-Message-State: AJIora+xL4qnFsxzzr+5dG3g3Ul5pv8GDUsETMBBDIR7Ns+K0XnW7UIM
        e4rHvaDQ2BPSfWc3EVTI1Lg=
X-Google-Smtp-Source: AGRyM1ucQAcXXYT1imJwhd8K+uCpSa+ieMHN08siTeJAaz+4ZwsVAkFL385SEKTHEuiM5mG0xoJXSQ==
X-Received: by 2002:a05:6000:1148:b0:21b:a4b2:ccd3 with SMTP id d8-20020a056000114800b0021ba4b2ccd3mr9487682wrx.193.1656282340175;
        Sun, 26 Jun 2022 15:25:40 -0700 (PDT)
Received: from [192.168.0.17] ([94.14.166.112])
        by smtp.gmail.com with ESMTPSA id g4-20020a5d5544000000b0021a39f5ba3bsm8715659wrw.7.2022.06.26.15.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 15:25:39 -0700 (PDT)
Message-ID: <9b37fcae-214c-3a5b-d976-8c94632184d0@gmail.com>
Date:   Sun, 26 Jun 2022 23:25:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] net: prefer socket bound to interface when not in VRF
Content-Language: en-US
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     Netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Saikrishna Arcot <sarcot@microsoft.com>,
        Craig Gallek <kraig@google.com>
References: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
 <YqarphOzFTnQRq29@d3>
From:   Mike Manning <mvrmanning@gmail.com>
In-Reply-To: <YqarphOzFTnQRq29@d3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/06/2022 04:14, Benjamin Poirier wrote:
> On 2021-10-05 14:03 +0100, Mike Manning wrote:
> [...]
>> Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen when not in a VRF")
>> Fixes: e78190581aff ("net: ensure unbound stream socket to be chosen when not in a VRF")
>> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
>> ---
>>
>> diff nettest-baseline-9e9fb7655ed5.txt nettest-fix.txt
>> 955,956c955,956
>> < TEST: IPv4 TCP connection over VRF with SNAT                                  [FAIL]
>> < TEST: IPv6 TCP connection over VRF with SNAT                                  [FAIL]
>> ---
>>> TEST: IPv4 TCP connection over VRF with SNAT                                  [ OK ]
>>> TEST: IPv6 TCP connection over VRF with SNAT                                  [ OK ]
>> 958,959c958,959
>> < Tests passed: 713
>> < Tests failed:   5
>> ---
>>> Tests passed: 715
>>> Tests failed:   3
>> ---
>>  net/ipv4/inet_hashtables.c  | 4 +++-
>>  net/ipv4/udp.c              | 3 ++-
>>  net/ipv6/inet6_hashtables.c | 2 +-
>>  net/ipv6/udp.c              | 3 ++-
>>  4 files changed, 8 insertions(+), 4 deletions(-)
>>
> Hi Mike,
>
> I was looking at this commit, 8d6c414cd2fb ("net: prefer socket bound to
> interface when not in VRF"), and I get the feeling that it is only
> partially effective. It works with UDP connected sockets but it doesn't
> work for TCP and UDP unconnected sockets.
>
> The compute_score() functions are a bit misleading. Because of the
> reuseport shortcut in their callers (inet_lhash2_lookup() and the like),
> the first socket with score > 0 may be chosen, not necessarily the
> socket with highest score. In order to prefer certain sockets, I think
> an approach like commit d894ba18d4e4 ("soreuseport: fix ordering for
> mixed v4/v6 sockets") would be needed. What do you think?

Hi Benjamin,

We had never observed any issues with any of our configurations. The VRF changes introduced

in 7e225619e8af result in a failure being returned when there is no device match, which satisfies

the requirements for VRF handling so unbound vs. bound to an l3mdev - the score is irrelevant.

However, 8d6c414cd2fb was subsequently needed as unbound and bound sockets were scored

equally, so that fix reinstated a higher score needed for sockets bound to an interface. Wrt to

your query, the scoring resolved the issue. I am unaware of any problematic use-cases, but in

any case, my changes are in line with the current approach.


>
> Extra info:
> 1) fcnal-test.sh results
>
> I tried to reproduce the fcnal-test.sh test results quoted above but in
> my case the test cases already pass at 8d6c414cd2fb^ and 9e9fb7655ed5.
> Moreover I believe those test cases don't have multiple listening
> sockets. So that just added to my confusion.

The fix was not targeting those 2 failed test cases, the output was only to show the before/after

test results. It is unclear why they failed for me with with the 9e9fb7655ed5 baseline,


> Running 9e9fb7655ed5,
> root@vsid:/src/linux/tools/testing/selftests/net# ./fcnal-test.sh -t use_cases
> [...]
>
> #################################################################
> SNAT on VRF
>
> TEST: IPv4 TCP connection over VRF with SNAT                                  [ OK ]
> TEST: IPv6 TCP connection over VRF with SNAT                                  [ OK ]
>
> Tests passed:  16
> Tests failed:   0
>
>
> 2) reuseport_bindtodevice test
>
> I wrote a selftest based on
> tools/testing/selftests/net/reuseport_addr_any.c It tests that listening
> sockets that have SO_BINDTODEVICE set are preferred over ones that do
> not. All of the sockets have SO_REUSEPORT set. I ran it over a few
> relevant revisions:
>
>                IPv4                       IPv6
> HEAD           TCP  UDP unconn  UDP conn  TCP  UDP unconn  UDP conn
> 6a5ef90c58da^  ✔    ✔           ✔         ✔    ✔           ✔   
> 6a5ef90c58da   ✔    ✘           ✔         ✔    ✘           ✔   
> fd1914b2901b   ✘    ✘           ✔         ✘    ✘           ✔   
> 7e225619e8af   ✘    ✘           ✘         ✘    ✘           ✘   
> 8d6c414cd2fb   ✘    ✘           ✔         ✘    ✘           ✔   
>
> ✔ pass
> ✘ fail
>
> reuseport_bindtodevice.c:
>
> // SPDX-License-Identifier: GPL-2.0
>
> /* Test that listening sockets that have SO_BINDTODEVICE set are preferred
>  * over ones that do not. All of the sockets have SO_REUSEPORT set.
>  */
>
> #define _GNU_SOURCE
>
> #include <arpa/inet.h>
> #include <errno.h>
> #include <error.h>
> #include <linux/in.h>
> #include <linux/unistd.h>
> #include <stdbool.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/epoll.h>
> #include <sys/types.h>
> #include <sys/socket.h>
> #include <unistd.h>
>
>
> static const int SEND_PORT = 8888;
> static const int RECV_PORT = 8889;
>
> static const char *get_family_name(int domain)
> {
> 	if (domain == AF_INET)
> 		return "IPv4";
> 	else if (domain == AF_INET6)
> 		return "IPv6";
> 	else
> 		error(1, 0, "Unknown address family \"%d\"", domain);
>
> 	return "";
> }
>
> static void build_rcv_fd(int domain, int type, int *rcv_fds, int count,
> 			 const char *ifname, bool do_connect)
> {
> 	struct sockaddr_storage saddr, daddr;
> 	int opt, i;
>
> 	if (domain == AF_INET) {
> 		struct sockaddr_in *saddr4 = (struct sockaddr_in *)&saddr,
> 				   *daddr4 = (struct sockaddr_in *)&daddr;
>
> 		saddr4->sin_family = AF_INET;
> 		saddr4->sin_addr.s_addr = htonl(INADDR_ANY);
> 		saddr4->sin_port = htons(RECV_PORT);
>
> 		daddr4->sin_family = AF_INET;
> 		daddr4->sin_addr.s_addr = htonl(INADDR_ANY);
> 		daddr4->sin_port = htons(SEND_PORT);
> 	} else if (domain == AF_INET6) {
> 		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)&saddr,
> 				    *daddr6 = (struct sockaddr_in6 *)&daddr;
>
> 		saddr6->sin6_family = AF_INET6;
> 		saddr6->sin6_addr = in6addr_any;
> 		saddr6->sin6_port = htons(RECV_PORT);
>
> 		daddr6->sin6_family = AF_INET6;
> 		daddr6->sin6_addr = in6addr_any;
> 		daddr6->sin6_port = htons(SEND_PORT);
> 	} else {
> 		error(1, 0, "Unsupported family %d", domain);
> 	}
>
> 	for (i = 0; i < count; ++i) {
> 		rcv_fds[i] = socket(domain, type, 0);
> 		if (rcv_fds[i] < 0)
> 			error(1, errno, "failed to create receive socket");
>
> 		opt = 1;
> 		if (setsockopt(rcv_fds[i], SOL_SOCKET, SO_REUSEPORT, &opt,
> 			       sizeof(opt)))
> 			error(1, errno, "failed to set SO_REUSEPORT");
>
> 		if (ifname && setsockopt(rcv_fds[i], SOL_SOCKET,
> 					 SO_BINDTODEVICE, ifname,
> 					 strlen(ifname)))
> 			error(1, errno, "failed to set SO_BINDTODEVICE");
>
> 		if (bind(rcv_fds[i], (struct sockaddr *)&saddr, sizeof(saddr)))
> 			error(1, errno, "failed to bind receive socket");
>
> 		if (do_connect &&
> 		    connect(rcv_fds[i], (struct sockaddr *)&daddr,
> 			    sizeof(daddr)))
> 			error(1, errno, "failed to connect receive socket");
>
> 		if (type == SOCK_STREAM && listen(rcv_fds[i], 10))
> 			error(1, errno, "failed to listen on receive socket");
> 	}
> }
>
> static int connect_and_send(int domain, int type)
> {
> 	struct sockaddr_storage saddr, daddr;
> 	int fd;
>
> 	if (domain == AF_INET) {
> 		struct sockaddr_in *saddr4 = (struct sockaddr_in *)&saddr,
> 				   *daddr4 = (struct sockaddr_in *)&daddr;
>
> 		saddr4->sin_family = AF_INET;
> 		saddr4->sin_addr.s_addr = htonl(INADDR_ANY);
> 		saddr4->sin_port = htons(SEND_PORT);
>
> 		daddr4->sin_family = AF_INET;
> 		daddr4->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
> 		daddr4->sin_port = htons(RECV_PORT);
> 	} else if (domain == AF_INET6) {
> 		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)&saddr,
> 				    *daddr6 = (struct sockaddr_in6 *)&daddr;
>
> 		saddr6->sin6_family = AF_INET6;
> 		saddr6->sin6_addr = in6addr_any;
> 		saddr6->sin6_port = htons(SEND_PORT);
>
> 		daddr6->sin6_family = AF_INET6;
> 		daddr6->sin6_addr = in6addr_loopback;
> 		daddr6->sin6_port = htons(RECV_PORT);
> 	} else {
> 		error(1, 0, "Unsupported family %d", domain);
> 	}
>
> 	fd = socket(domain, type, 0);
> 	if (fd < 0)
> 		error(1, errno, "failed to create send socket");
>
> 	if (bind(fd, (struct sockaddr *)&saddr, sizeof(saddr)))
> 		error(1, errno, "failed to bind send socket");
>
> 	if (connect(fd, (struct sockaddr *)&daddr, sizeof(daddr)))
> 		error(1, errno, "failed to connect send socket");
>
> 	if (send(fd, "a", 1, 0) < 0)
> 		error(1, errno, "failed to send message");
>
> 	return fd;
> }
>
> static int receive_once(int epfd, int type)
> {
> 	struct epoll_event ev;
> 	int i, fd;
> 	char buf[8];
>
> 	i = epoll_wait(epfd, &ev, 1, 3);
> 	if (i < 0)
> 		error(1, errno, "epoll_wait failed");
> 	else if (i == 0)
> 		error(1, errno, "no socket is ready");
>
> 	if (type == SOCK_STREAM) {
> 		fd = accept(ev.data.fd, NULL, NULL);
> 		if (fd < 0)
> 			error(1, errno, "failed to accept");
> 		i = recv(fd, buf, sizeof(buf), 0);
> 		close(fd);
> 	} else {
> 		i = recv(ev.data.fd, buf, sizeof(buf), 0);
> 	}
>
> 	if (i < 0)
> 		error(1, errno, "failed to recv");
>
> 	return ev.data.fd;
> }
>
> static int test(int *rcv_fds, int count, int domain, int type, int fd)
> {
> 	int epfd, i, send_fd, recv_fd;
> 	struct epoll_event ev;
>
> 	epfd = epoll_create(1);
> 	if (epfd < 0)
> 		error(1, errno, "failed to create epoll");
>
> 	ev.events = EPOLLIN;
> 	for (i = 0; i < count; ++i) {
> 		ev.data.fd = rcv_fds[i];
> 		if (epoll_ctl(epfd, EPOLL_CTL_ADD, rcv_fds[i], &ev))
> 			error(1, errno, "failed to register sock epoll");
> 	}
>
> 	send_fd = connect_and_send(domain, type);
>
> 	recv_fd = receive_once(epfd, type);
>
> 	close(send_fd);
> 	close(epfd);
>
> 	return recv_fd == fd;
> }
>
> static int run_one_test(int domain, int type, bool do_connect)
> {
> 	/* Below we test that a socket listening with SO_BINDTODEVICE set is
> 	 * always selected in preference over a socket listening without. Bugs
> 	 * where this is not the case often result in sockets created first or
> 	 * last to get picked. So below we make sure that there are always
> 	 * sockets with SO_BINDTODEVICE created before and after a specific
> 	 * socket is created.
> 	 */
> 	int rcv_fds[10], i, result;
>
> 	build_rcv_fd(AF_INET, type, rcv_fds, 2, NULL, do_connect);
> 	build_rcv_fd(AF_INET6, type, rcv_fds + 2, 2, NULL, do_connect);
> 	build_rcv_fd(domain, type, rcv_fds + 4, 1, "lo", do_connect);
> 	build_rcv_fd(AF_INET, type, rcv_fds + 5, 2, NULL, do_connect);
> 	build_rcv_fd(AF_INET6, type, rcv_fds + 7, 2, NULL, do_connect);
> 	result = test(rcv_fds, 9, domain, type, rcv_fds[4]);
> 	for (i = 0; i < 9; ++i)
> 		close(rcv_fds[i]);
> 	if (result)
> 		fprintf(stderr, "pass\n");
> 	else
> 		fprintf(stderr, "fail\n");
> 	return result;
> }
>
> static int test_family(int domain)
> {
> 	int result = 1;
>
> 	fprintf(stderr, "%s TCP ... ", get_family_name(domain));
> 	result &= run_one_test(domain, SOCK_STREAM, false);
>
> 	fprintf(stderr, "%s UDP unconnected ... ", get_family_name(domain));
> 	result &= run_one_test(domain, SOCK_DGRAM, false);
>
> 	fprintf(stderr, "%s UDP connected ... ", get_family_name(domain));
> 	result &= run_one_test(domain, SOCK_DGRAM, true);
>
> 	return result;
> }
>
> int main(void)
> {
> 	int result = 1;
>
> 	result &= test_family(AF_INET);
> 	result &= test_family(AF_INET6);
>
> 	if (result) {
> 		fprintf(stderr, "SUCCESS\n");
> 		return 0;
> 	}
> 	fprintf(stderr, "FAIL\n");
> 	return 1;
> }


