Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF5A683129
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 16:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbjAaPSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 10:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbjAaPRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 10:17:49 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8580E599A0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 07:16:01 -0800 (PST)
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4569F41AD0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675177731;
        bh=39hNPh+zAyhzqVKLTaksH9IiMGXkYwZwdaQ4GuB3Kaw=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=Nrvkh68OW1SR97eZCD7fqQ6SlxjEKJgb4eIUjnaszNoH66f9RymnFNclCYXRBtY95
         INs22DlIwL21U2VCC5K/9y/mkWigEZA9/WgkJQJRONHQw9GagBPEeMmgdbozE6emBV
         Rh8QIer9KhJ3in0wCUg0G0YiRW/1gu5p4Wf0ZxkcrG6/ulKYbQKUimAtBMtaq95Byo
         6ncT3XfoIbYg2JJsIvC3lxTztCK7XtsjoCxvIVaW9WL6KiXGQBHpg6DqiCuQ/YNI6X
         2GefCm+0rUdeWQ2KCXjcur2FuGTBMoQWlw/heKfXxn1xBKndYtLhDpDOQirRW67hMD
         BSLjmB9L4u4Mw==
Received: by mail-wr1-f72.google.com with SMTP id e9-20020a5d6d09000000b002c172f173a9so360726wrq.17
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 07:08:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39hNPh+zAyhzqVKLTaksH9IiMGXkYwZwdaQ4GuB3Kaw=;
        b=QosUqf+LV8hg7bC9kQcNzCdaRNOyE85jg05GAXZib63n6bjlDiHkNKF727bUL/Z2ap
         J4lLpZ8nxzW44L82q8jLxLTdRTe6D43Lg8wmhPrKVKYlVD3w4ERsIFfKbnARaVTFka49
         rUzkkPHYchOI8UsYgm8Bub7HtwGqzGwFKkN6DHA9nQZGMFehPKDAnF+YRRaotXtIm033
         K+UlHwSYlKj1etnZVCBrgIHNp1tuFTe7+z0VEgaxll+mTatDulWZT4GiSNWMtupTy7BN
         SqynEyc+17lwFlqJ6I4Q1nqoj+HR8HnIg5eNuncc5YPPaumJCg74eUZ+dRYYKLFpPDsR
         GVeg==
X-Gm-Message-State: AFqh2kqvPtLK2ggZiUr32Ihoozs4ncaNrACviBotFFaLrEcBX/3zK5ja
        OKSBrHvft2oXAdXPPTIK1sVEeYi6ID0xrp+ehxN/+2q/wrRpc8avgK6+2pXbgoPdaeM94hUyupw
        z5xOlJInruh6n4ovGqSvADSge7M74oUEmLA==
X-Received: by 2002:a05:600c:34d1:b0:3db:1434:c51a with SMTP id d17-20020a05600c34d100b003db1434c51amr47954655wmq.40.1675177730909;
        Tue, 31 Jan 2023 07:08:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsrYavNdHKe40jjTdXUREYpE+Zo2RTZ0oK6vUnkjcqRQxzhOvcovconVzXpPbNSPSe7G96X8A==
X-Received: by 2002:a05:600c:34d1:b0:3db:1434:c51a with SMTP id d17-20020a05600c34d100b003db1434c51amr47954630wmq.40.1675177730632;
        Tue, 31 Jan 2023 07:08:50 -0800 (PST)
Received: from qwirkle ([2001:67c:1560:8007::aac:c4dd])
        by smtp.gmail.com with ESMTPSA id y21-20020a05600c17d500b003dc46242c4csm10848089wmo.10.2023.01.31.07.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 07:08:50 -0800 (PST)
Date:   Tue, 31 Jan 2023 15:08:48 +0000
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] selftests: net: udpgso_bench_tx: Cater for
 pending datagrams zerocopy benchmarking
Message-ID: <Y9kvADcYZ18XFTXu@qwirkle>
References: <20230131130412.432549-1-andrei.gherzan@canonical.com>
 <20230131130412.432549-4-andrei.gherzan@canonical.com>
 <d9ca623d01274889913001ce92f686652fa8fea8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9ca623d01274889913001ce92f686652fa8fea8.camel@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/31 03:51PM, Paolo Abeni wrote:
> On Tue, 2023-01-31 at 13:04 +0000, Andrei Gherzan wrote:
> > The test tool can check that the zerocopy number of completions value is
> > valid taking into consideration the number of datagram send calls. This can
> > catch the system into a state where the datagrams are still in the system
> > (for example in a qdisk, waiting for the network interface to return a
> > completion notification, etc).
> > 
> > This change adds a retry logic of computing the number of completions up to
> > a configurable (via CLI) timeout (default: 2 seconds).
> > 
> > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > ---
> >  tools/testing/selftests/net/udpgso_bench_tx.c | 38 +++++++++++++++----
> >  1 file changed, 30 insertions(+), 8 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
> > index b47b5c32039f..5a29b5f24023 100644
> > --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> > +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> > @@ -62,6 +62,7 @@ static int	cfg_payload_len	= (1472 * 42);
> >  static int	cfg_port	= 8000;
> >  static int	cfg_runtime_ms	= -1;
> >  static bool	cfg_poll;
> > +static int	cfg_poll_loop_timeout_ms = 2000;
> >  static bool	cfg_segment;
> >  static bool	cfg_sendmmsg;
> >  static bool	cfg_tcp;
> > @@ -235,16 +236,17 @@ static void flush_errqueue_recv(int fd)
> >  	}
> >  }
> >  
> > -static void flush_errqueue(int fd, const bool do_poll)
> > +static void flush_errqueue(int fd, const bool do_poll,
> > +		unsigned long poll_timeout, const bool poll_err)
> >  {
> >  	if (do_poll) {
> >  		struct pollfd fds = {0};
> >  		int ret;
> >  
> >  		fds.fd = fd;
> > -		ret = poll(&fds, 1, 500);
> > +		ret = poll(&fds, 1, poll_timeout);
> >  		if (ret == 0) {
> > -			if (cfg_verbose)
> > +			if ((cfg_verbose) && (poll_err))
> >  				fprintf(stderr, "poll timeout\n");
> >  		} else if (ret < 0) {
> >  			error(1, errno, "poll");
> > @@ -254,6 +256,22 @@ static void flush_errqueue(int fd, const bool do_poll)
> >  	flush_errqueue_recv(fd);
> >  }
> >  
> > +static void flush_errqueue_retry(int fd, const bool do_poll, unsigned long num_sends)
> > +{
> > +	unsigned long tnow, tstop;
> > +	bool first_try = true;
> > +
> > +	tnow = gettimeofday_ms();
> > +	tstop = tnow + cfg_poll_loop_timeout_ms;
> > +	do {
> > +		flush_errqueue(fd, do_poll, tstop - tnow, first_try);
> > +		first_try = false;
> > +		if (!do_poll)
> > +			usleep(1000);  // a throttling delay if polling is enabled
> 
> Even if the kernel codying style is not very strictly enforced for
> self-tests, please avoid c++ style comments.
> 
> More importantly, as Willem noded, this function is always called with
> do_poll == true. You should drop such argument and the related branch
> above.

Agreed. I will drop.

> 
> > +		tnow = gettimeofday_ms();
> > +	} while ((stat_zcopies != num_sends) && (tnow < tstop));
> > +}
> > +
> >  static int send_tcp(int fd, char *data)
> >  {
> >  	int ret, done = 0, count = 0;
> > @@ -413,8 +431,9 @@ static int send_udp_segment(int fd, char *data)
> >  
> >  static void usage(const char *filepath)
> >  {
> > -	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
> > -		    filepath);
> > +	error(1, 0,
> > +			"Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-L secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
> > +			filepath);
> 
> Please avoid introducing unnecessary white-space changes (no reason to
> move the usage text on a new line)

The only reason why I've done this was to make scripts/checkpatch.pl
happy:

WARNING: line length of 141 exceeds 100 columns
#83: FILE: tools/testing/selftests/net/udpgso_bench_tx.c:432:

I can drop and ignore the warning, or maybe it would have been better to
just mention this in git message. What do you prefer?

-- 
Andrei Gherzan
