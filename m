Return-Path: <netdev+bounces-2820-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2FF770431F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 03:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4E6C1C20D0C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 01:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90D71FD6;
	Tue, 16 May 2023 01:51:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F6A1FB0;
	Tue, 16 May 2023 01:51:25 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9BEDC;
	Mon, 15 May 2023 18:51:23 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6439f186366so8660518b3a.2;
        Mon, 15 May 2023 18:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684201883; x=1686793883;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IaREDRWAbcl36mTiSxnebwhOm44d1Ztth6M8Asrwng8=;
        b=PwZRQctnLsWiagh6gh2eubJn7Jo1HUXnP1igjQdzgzPg0hDYubL6WUt9wlZ1nGKahi
         CFZuYCjK48f+AggK+7kZWKRUliPHzeXRyVl4fXIWjryR4nnMkX0lKweMLEDZ037aJuLX
         e/088Nvs3GSn5O4B4nLmPzApnDnoZ4DaSlTg7U44FFu2MKGDYiCev6AoMCrEIhGoeWkz
         TTz1jICOo2URrIM6t/WcbqgJSK8yRziukbg9XrPjrwMAFEvW5sRiUh5vqcyTdlE6JMCV
         cBj1pDAfDPhxAgSYMWcUL4kmyP4FcFYK/HSURrM0RFzL199gfcQ0wBtX+Z2cogz0nKHL
         8EoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684201883; x=1686793883;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IaREDRWAbcl36mTiSxnebwhOm44d1Ztth6M8Asrwng8=;
        b=l+TA3VIzo0t2wjIlzAeFxMaGPI0d0HkJOjSzXIGYVk+3EZQs8sEHj6kh5qkcJWLyKC
         fS1X2OP7ID92uPl1tK0JYn0J0iQLVY7KmM5Rx1mxm9uO3nQ3h5lTenxrsuP4L7sf4fj5
         4QabFoQy0KvHHXif9VUtZiKr+vPk5QhcvEl3Ckey/XE0VLsclWwSaFReL31z674wLAFE
         +zU69NiP7DCLNZ5XH/Kwrg1QGEaNonwjYGwb7wa3Nsb7lhDUGc7fjWbHYX2abh48SGhz
         RaUtxX4n88IIdJfCInBSNgl431D7FU7hadGGe23cVw/npcu0XaCbDNwf4u94IKo0XJF0
         273g==
X-Gm-Message-State: AC+VfDw6eScxKZx7jvxOtB4W10xHiF2pHkgOEZifXwLh2NOdSEqWNzor
	pDMkhDBOyaLe44/hWhpewK8=
X-Google-Smtp-Source: ACHHUZ7ifOvTRGfTXKjTKYgEcotKV3c62Y9zCkJuF0U/Gii3bHkd+B2WO/G2yxzIuc7y/o+9V7TZBQ==
X-Received: by 2002:a05:6a00:2d0e:b0:63d:2680:94dd with SMTP id fa14-20020a056a002d0e00b0063d268094ddmr50143968pfb.6.1684201882982;
        Mon, 15 May 2023 18:51:22 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:3424:f8d7:c03b:2a7a])
        by smtp.gmail.com with ESMTPSA id j18-20020a62b612000000b0063f534f0937sm12320899pff.46.2023.05.15.18.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 18:51:22 -0700 (PDT)
Date: Mon, 15 May 2023 18:51:20 -0700
From: John Fastabend <john.fastabend@gmail.com>
To: Jakub Sitnicki <jakub@cloudflare.com>, 
 John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, 
 lmb@isovalent.com, 
 edumazet@google.com, 
 bpf@vger.kernel.org, 
 netdev@vger.kernel.org, 
 ast@kernel.org, 
 andrii@kernel.org, 
 will@isovalent.com
Message-ID: <6462e1986fb64_250b4208ac@john.notmuch>
In-Reply-To: <87jzxj3wsq.fsf@cloudflare.com>
References: <20230502155159.305437-1-john.fastabend@gmail.com>
 <20230502155159.305437-12-john.fastabend@gmail.com>
 <87jzxj3wsq.fsf@cloudflare.com>
Subject: Re: [PATCH bpf v7 11/13] bpf: sockmap, test shutdown() correctly
 exits epoll and recv()=0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Sitnicki wrote:
> On Tue, May 02, 2023 at 08:51 AM -07, John Fastabend wrote:
> > When session gracefully shutdowns epoll needs to wake up and any recv()
> > readers should return 0 not the -EAGAIN they previously returned.
> >
> > Note we use epoll instead of select to test the epoll wake on shutdown
> > event as well.
> >
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  .../selftests/bpf/prog_tests/sockmap_basic.c  | 68 +++++++++++++++++++
> >  .../bpf/progs/test_sockmap_pass_prog.c        | 32 +++++++++
> >  2 files changed, 100 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > index 0ce25a967481..f9f611618e45 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > @@ -2,6 +2,7 @@
> >  // Copyright (c) 2020 Cloudflare
> >  #include <error.h>
> >  #include <netinet/tcp.h>
> > +#include <sys/epoll.h>
> >  
> >  #include "test_progs.h"
> >  #include "test_skmsg_load_helpers.skel.h"
> > @@ -9,8 +10,11 @@
> >  #include "test_sockmap_invalid_update.skel.h"
> >  #include "test_sockmap_skb_verdict_attach.skel.h"
> >  #include "test_sockmap_progs_query.skel.h"
> > +#include "test_sockmap_pass_prog.skel.h"
> >  #include "bpf_iter_sockmap.skel.h"
> >  
> > +#include "sockmap_helpers.h"
> > +
> >  #define TCP_REPAIR		19	/* TCP sock is under repair right now */
> >  
> >  #define TCP_REPAIR_ON		1
> > @@ -350,6 +354,68 @@ static void test_sockmap_progs_query(enum bpf_attach_type attach_type)
> >  	test_sockmap_progs_query__destroy(skel);
> >  }
> >  
> > +#define MAX_EVENTS 10
> > +static void test_sockmap_skb_verdict_shutdown(void)
> > +{
> > +	int n, err, map, verdict, s, c0, c1, p0, p1;
> > +	struct epoll_event ev, events[MAX_EVENTS];
> > +	struct test_sockmap_pass_prog *skel;
> > +	int epollfd;
> > +	int zero = 0;
> > +	char b;
> > +
> > +	skel = test_sockmap_pass_prog__open_and_load();
> > +	if (!ASSERT_OK_PTR(skel, "open_and_load"))
> > +		return;
> > +
> > +	verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
> > +	map = bpf_map__fd(skel->maps.sock_map_rx);
> > +
> > +	err = bpf_prog_attach(verdict, map, BPF_SK_SKB_STREAM_VERDICT, 0);
> > +	if (!ASSERT_OK(err, "bpf_prog_attach"))
> > +		goto out;
> > +
> > +	s = socket_loopback(AF_INET, SOCK_STREAM);
> > +	if (s < 0)
> > +		goto out;
> > +	err = create_socket_pairs(s, AF_INET, SOCK_STREAM, &c0, &c1, &p0, &p1);
> > +	if (err < 0)
> > +		goto out;
> > +
> > +	err = bpf_map_update_elem(map, &zero, &c1, BPF_NOEXIST);
> > +	if (err < 0)
> > +		goto out_close;
> > +
> > +	shutdown(c0, SHUT_RDWR);
> > +	shutdown(p1, SHUT_WR);
> > +
> > +	ev.events = EPOLLIN;
> > +	ev.data.fd = c1;
> > +
> > +	epollfd = epoll_create1(0);
> > +	if (!ASSERT_GT(epollfd, -1, "epoll_create(0)"))
> > +		goto out_close;
> > +	err = epoll_ctl(epollfd, EPOLL_CTL_ADD, c1, &ev);
> > +	if (!ASSERT_OK(err, "epoll_ctl(EPOLL_CTL_ADD)"))
> > +		goto out_close;
> > +	err = epoll_wait(epollfd, events, MAX_EVENTS, -1);
> > +	if (!ASSERT_EQ(err, 1, "epoll_wait(fd)"))
> > +		goto out_close;
> > +
> > +	n = recv(c1, &b, 1, SOCK_NONBLOCK);
> > +	ASSERT_EQ(n, 0, "recv_timeout(fin)");
> > +	n = recv(p0, &b, 1, SOCK_NONBLOCK);
> > +	ASSERT_EQ(n, 0, "recv_timeout(fin)");
> > +
> > +out_close:
> > +	close(c0);
> > +	close(p0);
> > +	close(c1);
> > +	close(p1);
> > +out:
> > +	test_sockmap_pass_prog__destroy(skel);
> > +}
> > +
> 
> This test has me scratching my head. I don't grasp what we're testing
> with (c0, p0) socket pair, since c0 is not in any sockmap?

Yeah the test is on (c1,p1) I was just lazy and using the API as is
I can fix the API to allow single set c1,p1.

