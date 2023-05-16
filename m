Return-Path: <netdev+bounces-3002-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEA0704F98
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:43:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 438482815E4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275A52772B;
	Tue, 16 May 2023 13:43:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1264D27723
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:43:06 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281A1527A
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:43:03 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-50bc5197d33so25768598a12.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1684244581; x=1686836581;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=C0P39mzUO2QQd9I7m+mbY3qo2mtwxHhH4Qn6TiIjRFw=;
        b=W3e2J2vAhbJSvjaNTzjuSvBvcx77wDxS0eOUKaA06GYytOANBYQWppUuemRXZYLs8q
         LIpXQSKZzLihAj9dpGofHIIT+74dz3Jko8QjV8TCWp1kyWXCTJrbRMtB6Yt6SHzez8XW
         m57zs7pUKAW+eqVWYBiE1MgMiptKhiEIe928g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684244581; x=1686836581;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0P39mzUO2QQd9I7m+mbY3qo2mtwxHhH4Qn6TiIjRFw=;
        b=jrn0C3b8OwDfN3TGy12Ht4Kbhd2j1QvLhczhqRhagxr/9jFba+HPeRlvVeclwNuWRO
         vc3Zv5btmBlqz3jbxzCf5R7S+jZU+NjVpqdnuhrLru4FVNuPn7eMwLhxCQqF8fkvOiiH
         50EzuFJklWRAT4+N8dYuli/wocsARZORrYKyXlmoRp3KvVGl+rF6if4sjoJWwTHimkWC
         U/TG+Xgz8UU4wSttbW6cJ6pFt6ZBIG3DxlTSGxUM1639qT7WWUIu+Bsp+fhB+HY5y28Y
         W84unlRM4Cylyo402dQOJEba6PhdGSxWQsCiuL/w/pKT3SZkz28zrQmSb3VBstrdnUYJ
         xSCw==
X-Gm-Message-State: AC+VfDwBSk4MgCa4bmZlxa6578E4MzqWG82UJ+ZXeUPiQYOXWB0f6xTT
	adXaj6893EW0qpyTOyg5kHeIyA==
X-Google-Smtp-Source: ACHHUZ7bP7KP2hZ82TI2FalqntKUS3O96HdIhta8RFFYz11Kpn+0YqpGj6bMeDS9O4GHPcVXc0djBA==
X-Received: by 2002:aa7:ccc8:0:b0:508:3f06:8fd1 with SMTP id y8-20020aa7ccc8000000b005083f068fd1mr31711515edt.29.1684244581447;
        Tue, 16 May 2023 06:43:01 -0700 (PDT)
Received: from cloudflare.com (79.184.126.163.ipv4.supernova.orange.pl. [79.184.126.163])
        by smtp.gmail.com with ESMTPSA id g8-20020aa7d1c8000000b00501d73cfc86sm8255599edp.9.2023.05.16.06.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 06:43:00 -0700 (PDT)
References: <20230502155159.305437-1-john.fastabend@gmail.com>
 <20230502155159.305437-12-john.fastabend@gmail.com>
 <87jzxj3wsq.fsf@cloudflare.com> <6462e1986fb64_250b4208ac@john.notmuch>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
 andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v7 11/13] bpf: sockmap, test shutdown() correctly
 exits epoll and recv()=0
Date: Tue, 16 May 2023 15:41:05 +0200
In-reply-to: <6462e1986fb64_250b4208ac@john.notmuch>
Message-ID: <87h6scfl3w.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 06:51 PM -07, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Tue, May 02, 2023 at 08:51 AM -07, John Fastabend wrote:
>> > When session gracefully shutdowns epoll needs to wake up and any recv()
>> > readers should return 0 not the -EAGAIN they previously returned.
>> >
>> > Note we use epoll instead of select to test the epoll wake on shutdown
>> > event as well.
>> >
>> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> > ---
>> >  .../selftests/bpf/prog_tests/sockmap_basic.c  | 68 +++++++++++++++++++
>> >  .../bpf/progs/test_sockmap_pass_prog.c        | 32 +++++++++
>> >  2 files changed, 100 insertions(+)
>> >  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c
>> >
>> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
>> > index 0ce25a967481..f9f611618e45 100644
>> > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
>> > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
>> > @@ -2,6 +2,7 @@
>> >  // Copyright (c) 2020 Cloudflare
>> >  #include <error.h>
>> >  #include <netinet/tcp.h>
>> > +#include <sys/epoll.h>
>> >  
>> >  #include "test_progs.h"
>> >  #include "test_skmsg_load_helpers.skel.h"
>> > @@ -9,8 +10,11 @@
>> >  #include "test_sockmap_invalid_update.skel.h"
>> >  #include "test_sockmap_skb_verdict_attach.skel.h"
>> >  #include "test_sockmap_progs_query.skel.h"
>> > +#include "test_sockmap_pass_prog.skel.h"
>> >  #include "bpf_iter_sockmap.skel.h"
>> >  
>> > +#include "sockmap_helpers.h"
>> > +
>> >  #define TCP_REPAIR		19	/* TCP sock is under repair right now */
>> >  
>> >  #define TCP_REPAIR_ON		1
>> > @@ -350,6 +354,68 @@ static void test_sockmap_progs_query(enum bpf_attach_type attach_type)
>> >  	test_sockmap_progs_query__destroy(skel);
>> >  }
>> >  
>> > +#define MAX_EVENTS 10
>> > +static void test_sockmap_skb_verdict_shutdown(void)
>> > +{
>> > +	int n, err, map, verdict, s, c0, c1, p0, p1;
>> > +	struct epoll_event ev, events[MAX_EVENTS];
>> > +	struct test_sockmap_pass_prog *skel;
>> > +	int epollfd;
>> > +	int zero = 0;
>> > +	char b;
>> > +
>> > +	skel = test_sockmap_pass_prog__open_and_load();
>> > +	if (!ASSERT_OK_PTR(skel, "open_and_load"))
>> > +		return;
>> > +
>> > +	verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
>> > +	map = bpf_map__fd(skel->maps.sock_map_rx);
>> > +
>> > +	err = bpf_prog_attach(verdict, map, BPF_SK_SKB_STREAM_VERDICT, 0);
>> > +	if (!ASSERT_OK(err, "bpf_prog_attach"))
>> > +		goto out;
>> > +
>> > +	s = socket_loopback(AF_INET, SOCK_STREAM);
>> > +	if (s < 0)
>> > +		goto out;
>> > +	err = create_socket_pairs(s, AF_INET, SOCK_STREAM, &c0, &c1, &p0, &p1);
>> > +	if (err < 0)
>> > +		goto out;
>> > +
>> > +	err = bpf_map_update_elem(map, &zero, &c1, BPF_NOEXIST);
>> > +	if (err < 0)
>> > +		goto out_close;
>> > +
>> > +	shutdown(c0, SHUT_RDWR);
>> > +	shutdown(p1, SHUT_WR);
>> > +
>> > +	ev.events = EPOLLIN;
>> > +	ev.data.fd = c1;
>> > +
>> > +	epollfd = epoll_create1(0);
>> > +	if (!ASSERT_GT(epollfd, -1, "epoll_create(0)"))
>> > +		goto out_close;
>> > +	err = epoll_ctl(epollfd, EPOLL_CTL_ADD, c1, &ev);
>> > +	if (!ASSERT_OK(err, "epoll_ctl(EPOLL_CTL_ADD)"))
>> > +		goto out_close;
>> > +	err = epoll_wait(epollfd, events, MAX_EVENTS, -1);
>> > +	if (!ASSERT_EQ(err, 1, "epoll_wait(fd)"))
>> > +		goto out_close;
>> > +
>> > +	n = recv(c1, &b, 1, SOCK_NONBLOCK);
>> > +	ASSERT_EQ(n, 0, "recv_timeout(fin)");
>> > +	n = recv(p0, &b, 1, SOCK_NONBLOCK);
>> > +	ASSERT_EQ(n, 0, "recv_timeout(fin)");
>> > +
>> > +out_close:
>> > +	close(c0);
>> > +	close(p0);
>> > +	close(c1);
>> > +	close(p1);
>> > +out:
>> > +	test_sockmap_pass_prog__destroy(skel);
>> > +}
>> > +
>> 
>> This test has me scratching my head. I don't grasp what we're testing
>> with (c0, p0) socket pair, since c0 is not in any sockmap?
>
> Yeah the test is on (c1,p1) I was just lazy and using the API as is
> I can fix the API to allow single set c1,p1.

It's not an issue that one pair is unused, IMO. I was just surprised
that you operated on (c0, p0) rather than closing them immediately.

