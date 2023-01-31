Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BFC6832C2
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjAaQcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjAaQbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:31:37 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1813AA5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:31:34 -0800 (PST)
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8EABD41ACF
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675182692;
        bh=n/CaqmU/bb0yNkProNxdjfJ6mcTnYxY6CqP06NZVn3c=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=BDQIhe/aYeM3EFr8gAC/tImQItWCQiGdds1EdGH1nPAdPeYvUtlODX3QjVGFa4j+Y
         OaISoDPEC9dCaJiBhqp+HPvNd8OZ/EEOaJMXN2m0jFrx1fi33N2CTlgmGM2t9o7x/G
         nPYpNjOjCp/ONZIQx+zOuz98LClRPoInJSZjQcXoyobgijEGBM6ctmYFkjo5eXXsAh
         q7lqeGe2+4tGUgDdreu3ZGERXfxVM612kSjf62FlZeFy08CU366hnheG3NDS21NK1i
         u7XMMBNkvfnAN3bOHGnoZH10X3ald0GQV+nsXdDTbetwKaDpECv8SGXQxrQt5G7AbU
         G73ZR5uWCnXeQ==
Received: by mail-wr1-f72.google.com with SMTP id l8-20020adfc788000000b002bdfe72089cso2613325wrg.21
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:31:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/CaqmU/bb0yNkProNxdjfJ6mcTnYxY6CqP06NZVn3c=;
        b=HzjczsOGDAhY2yws5a7thBUbawuBlD+F3OxzjygNl9KYCfEPQkelSaY8mqbWLJtUDi
         oHLxkydZQ5lR/39ox9rGWJITP4uN85WiF6zSvtvbnU30a6dLEJMTFt8ylzTLmQI/dL0t
         1KXLtEWRGN31LTpDz/LBmjI7AbrAPrcdiMrAR7Mv3QWcSeW+GHS8l0HovVmiNplFgv9d
         wEt1/P62LjdK6dTuKuvds72dMQu/z7B21JX2qLMf9vQOtcYOxlLUCi6Cal0xIQkDSgWt
         I5Ncq6GC5W6bprk5vuDW9bbJXCikikrenYXvi3qEuqlaWlnu72DPJuPycJuVhIZ5+stu
         oR0w==
X-Gm-Message-State: AO0yUKVtSJ0x1F02yecpI0FsafgPoXjkIFx1Z5YSHWVVhD7TWaHSwaO2
        453ASP/jJUKHojgovVFftkSM4MYaMMkrAVYC2JZdbtx7izwGtFIiymjhcWp/qUjWLX1depGVewm
        CFmYUtxKevS3wrxXXt7Em6Zrn0tJsOB2Q5g==
X-Received: by 2002:a05:600c:6022:b0:3dd:a4ad:ae45 with SMTP id az34-20020a05600c602200b003dda4adae45mr2134990wmb.12.1675182692037;
        Tue, 31 Jan 2023 08:31:32 -0800 (PST)
X-Google-Smtp-Source: AK7set9zBF6o7zL3fJ6hNw5NSvlvEQCRi/XegUVE/rVjPpShff+Un53fy3zh8lgjygf64THgdtxdvA==
X-Received: by 2002:a05:600c:6022:b0:3dd:a4ad:ae45 with SMTP id az34-20020a05600c602200b003dda4adae45mr2134969wmb.12.1675182691813;
        Tue, 31 Jan 2023 08:31:31 -0800 (PST)
Received: from qwirkle ([2001:67c:1560:8007::aac:c4dd])
        by smtp.gmail.com with ESMTPSA id m29-20020a05600c3b1d00b003dc51c48f0bsm10026808wms.19.2023.01.31.08.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 08:31:31 -0800 (PST)
Date:   Tue, 31 Jan 2023 16:31:29 +0000
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] selftests: net: udpgso_bench_tx: Cater for
 pending datagrams zerocopy benchmarking
Message-ID: <Y9lCYT3XUgo4npox@qwirkle>
References: <20230131130412.432549-1-andrei.gherzan@canonical.com>
 <20230131130412.432549-4-andrei.gherzan@canonical.com>
 <d9ca623d01274889913001ce92f686652fa8fea8.camel@redhat.com>
 <Y9kvADcYZ18XFTXu@qwirkle>
 <17e062f077235b949090cba893c91f5637cc1f0e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17e062f077235b949090cba893c91f5637cc1f0e.camel@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/31 05:22PM, Paolo Abeni wrote:
> On Tue, 2023-01-31 at 15:08 +0000, Andrei Gherzan wrote:
> > On 23/01/31 03:51PM, Paolo Abeni wrote:
> > > On Tue, 2023-01-31 at 13:04 +0000, Andrei Gherzan wrote:
> > > > The test tool can check that the zerocopy number of completions value is
> > > > valid taking into consideration the number of datagram send calls. This can
> > > > catch the system into a state where the datagrams are still in the system
> > > > (for example in a qdisk, waiting for the network interface to return a
> > > > completion notification, etc).
> > > > 
> > > > This change adds a retry logic of computing the number of completions up to
> > > > a configurable (via CLI) timeout (default: 2 seconds).
> > > > 
> > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > ---
> > > >  tools/testing/selftests/net/udpgso_bench_tx.c | 38 +++++++++++++++----
> > > >  1 file changed, 30 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
> > > > index b47b5c32039f..5a29b5f24023 100644
> > > > --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> > > > +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> > > > @@ -62,6 +62,7 @@ static int	cfg_payload_len	= (1472 * 42);
> > > >  static int	cfg_port	= 8000;
> > > >  static int	cfg_runtime_ms	= -1;
> > > >  static bool	cfg_poll;
> > > > +static int	cfg_poll_loop_timeout_ms = 2000;
> > > >  static bool	cfg_segment;
> > > >  static bool	cfg_sendmmsg;
> > > >  static bool	cfg_tcp;
> > > > @@ -235,16 +236,17 @@ static void flush_errqueue_recv(int fd)
> > > >  	}
> > > >  }
> > > >  
> > > > -static void flush_errqueue(int fd, const bool do_poll)
> > > > +static void flush_errqueue(int fd, const bool do_poll,
> > > > +		unsigned long poll_timeout, const bool poll_err)
> > > >  {
> > > >  	if (do_poll) {
> > > >  		struct pollfd fds = {0};
> > > >  		int ret;
> > > >  
> > > >  		fds.fd = fd;
> > > > -		ret = poll(&fds, 1, 500);
> > > > +		ret = poll(&fds, 1, poll_timeout);
> > > >  		if (ret == 0) {
> > > > -			if (cfg_verbose)
> > > > +			if ((cfg_verbose) && (poll_err))
> > > >  				fprintf(stderr, "poll timeout\n");
> > > >  		} else if (ret < 0) {
> > > >  			error(1, errno, "poll");
> > > > @@ -254,6 +256,22 @@ static void flush_errqueue(int fd, const bool do_poll)
> > > >  	flush_errqueue_recv(fd);
> > > >  }
> > > >  
> > > > +static void flush_errqueue_retry(int fd, const bool do_poll, unsigned long num_sends)
> > > > +{
> > > > +	unsigned long tnow, tstop;
> > > > +	bool first_try = true;
> > > > +
> > > > +	tnow = gettimeofday_ms();
> > > > +	tstop = tnow + cfg_poll_loop_timeout_ms;
> > > > +	do {
> > > > +		flush_errqueue(fd, do_poll, tstop - tnow, first_try);
> > > > +		first_try = false;
> > > > +		if (!do_poll)
> > > > +			usleep(1000);  // a throttling delay if polling is enabled
> > > 
> > > Even if the kernel codying style is not very strictly enforced for
> > > self-tests, please avoid c++ style comments.
> > > 
> > > More importantly, as Willem noded, this function is always called with
> > > do_poll == true. You should drop such argument and the related branch
> > > above.
> > 
> > Agreed. I will drop.
> > 
> > > 
> > > > +		tnow = gettimeofday_ms();
> > > > +	} while ((stat_zcopies != num_sends) && (tnow < tstop));
> > > > +}
> > > > +
> > > >  static int send_tcp(int fd, char *data)
> > > >  {
> > > >  	int ret, done = 0, count = 0;
> > > > @@ -413,8 +431,9 @@ static int send_udp_segment(int fd, char *data)
> > > >  
> > > >  static void usage(const char *filepath)
> > > >  {
> > > > -	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
> > > > -		    filepath);
> > > > +	error(1, 0,
> > > > +			"Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-L secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
> > > > +			filepath);
> > > 
> > > Please avoid introducing unnecessary white-space changes (no reason to
> > > move the usage text on a new line)
> > 
> > The only reason why I've done this was to make scripts/checkpatch.pl
> > happy:
> > 
> > WARNING: line length of 141 exceeds 100 columns
> > #83: FILE: tools/testing/selftests/net/udpgso_bench_tx.c:432:
> > 
> > I can drop and ignore the warning, or maybe it would have been better to
> > just mention this in git message. What do you prefer?
> 
> Long lines are allowed for (kernel) messages, to make them easily grep-
> able.
> 
> In this specific case you can either append the new text to the message
> without introducing that strange indentation or even better break the
> usage string alike:
> 
> 	"Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-L secs]"
> 	" [-L secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]"

Funny I went through this too but it also fails with:

WARNING: quoted string split across lines
#84: FILE: tools/testing/selftests/net/udpgso_bench_tx.c:433

This is how I usually do it but it seems like it's flagged too.

-- 
Andrei Gherzan
