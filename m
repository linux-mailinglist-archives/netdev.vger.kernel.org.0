Return-Path: <netdev+bounces-7543-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD3DD72096F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05068281A7A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE671DDDC;
	Fri,  2 Jun 2023 19:00:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58023330D
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:00:53 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19DC1B1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:00:51 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3063433fa66so2423059f8f.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 12:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685732450; x=1688324450;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8VL0M+Hv9mGmc2Kt3/mWXFNmoQyIrOk75ebAr7Lp4t4=;
        b=wNuEBht98hdHBzwrSX9/VjIRmjQydztOjE5vGDPkxuPe9qAgdxHlKT8L9Czx/B3eJ7
         6V+1YEOf5awhAgikwlyYS86zeTrGk0f9z9gpmxb4JXphlFjJp+tm3ZXq+llmI69utkrh
         Jz76LGTEiSDL+E8aEgcv4smX/WbfrpbXaLZMuuXLrp9J5lxKFe7Se7AC0Diq2Wtyhzo+
         0fke/IRtSWl34ZOsn2lto4fcW4cu23b0iC5LaTJtCt+PrGL9K6lpPWcjF/a8g0hHcge+
         jtDSzZNcIgu6eJ9YHVzHdblOT7oFIEXuXbfTCfF353iztjidwgYTSewgFU4ibtn36SNC
         lwJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685732450; x=1688324450;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8VL0M+Hv9mGmc2Kt3/mWXFNmoQyIrOk75ebAr7Lp4t4=;
        b=iUhgLdxoMH32L9MXzGWyar3UNtQNhzWyxAnW8kbO5hEDPV6UkCJS7/DyvciFiWbuEr
         5LuwL1EGT/5tCr87bWLblUwI2EvMvaz6jNRgt11esI2qasi4V9ohdsvIhkPOUkxiqZB/
         CO+qgVHJM+gam4tAHQtMkfcJpsQDNP8weA1/cHlE7Gn8Y+FbdNRX+a9S56afOhDGQb0U
         elbkjN9poMuXI/DuFFMuQ4g/zuV9A+yG/WM/ja9F82xWEHtxCeowxtGLy/qY4URkmgt3
         JUg3y6l0IJ15AuGTug+PS6L+o/tN6lZpbXcXRmY5elLCpoyNVhwKNvjHeSQ+i/qoDmfB
         lkew==
X-Gm-Message-State: AC+VfDyFLW4KFIc2MeikYm/mv8sAJTrlelbgx94zpwTfzJzPwaqTSipp
	5p+JV3kw6MWoFYJ6WgcyGUxuGg==
X-Google-Smtp-Source: ACHHUZ6Oh8bWLSOT4QRyV5ew1nqbPRtcV9c9JCxEs994pSpo0l2xBf1uRTl1F39Ha+3YnNAnq8fIug==
X-Received: by 2002:a5d:4211:0:b0:309:509f:a7f0 with SMTP id n17-20020a5d4211000000b00309509fa7f0mr542331wrq.44.1685732450258;
        Fri, 02 Jun 2023 12:00:50 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm2436674wrt.20.2023.06.02.12.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 12:00:48 -0700 (PDT)
Date: Fri, 2 Jun 2023 22:00:45 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 03/11] tls/sw: Use zero-length sendmsg()
 without MSG_MORE to flush
Message-ID: <ee50e4ec-5df7-4342-885d-9e6c52da7407@kadam.mountain>
References: <20230602150752.1306532-1-dhowells@redhat.com>
 <20230602150752.1306532-4-dhowells@redhat.com>
 <ZHo0rNlhJCRE4msb@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHo0rNlhJCRE4msb@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 08:27:56PM +0200, Simon Horman wrote:
> + dan Carpenter
> 
> On Fri, Jun 02, 2023 at 04:07:44PM +0100, David Howells wrote:
> > Allow userspace to end a TLS record without supplying any data by calling
> > send()/sendto()/sendmsg() with no data and no MSG_MORE flag.  This can be
> > used to flush a previous send/splice that had MSG_MORE or SPLICE_F_MORE set
> > or a sendfile() that was incomplete.
> > 
> > Without this, a zero-length send to tls-sw is just ignored.  I think
> > tls-device will do the right thing without modification.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > cc: Chuck Lever <chuck.lever@oracle.com>
> > cc: Boris Pismenny <borisp@nvidia.com>
> > cc: John Fastabend <john.fastabend@gmail.com>
> > cc: Jakub Kicinski <kuba@kernel.org>
> > cc: Eric Dumazet <edumazet@google.com>
> > cc: "David S. Miller" <davem@davemloft.net>
> > cc: Paolo Abeni <pabeni@redhat.com>
> > cc: Jens Axboe <axboe@kernel.dk>
> > cc: Matthew Wilcox <willy@infradead.org>
> > cc: netdev@vger.kernel.org
> > ---
> >  net/tls/tls_sw.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> > index cac1adc968e8..6aa6d17888f5 100644
> > --- a/net/tls/tls_sw.c
> > +++ b/net/tls/tls_sw.c
> > @@ -945,7 +945,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> >  	struct tls_rec *rec;
> >  	int required_size;
> >  	int num_async = 0;
> > -	bool full_record;
> > +	bool full_record = false;
> >  	int record_room;
> >  	int num_zc = 0;
> >  	int orig_size;
> > @@ -971,6 +971,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> >  		}
> >  	}
> >  
> > +	if (!msg_data_left(msg) && eor)
> > +		goto just_flush;
> > +
> 
> Hi David,
> 
> the flow of this function is not entirely simple, so it is not easy for me
> to manually verify this. But in combination gcc-12 -Wmaybe-uninitialized
> and Smatch report that the following may be used uninitialised as a result
> of this change:
> 
>  * msg_pl

This warning seems correct to me.

>  * orig_size

This warning assumes we hit the first warning and then hit the goto
wait_for_memory;

>  * msg_en

I don't get this warning on my system but it's the same thing.  Hit the
first warning then the goto wait_for_memory.

>  * required_size

Same.

>  * try_to_copy

I don't really understand this warning and I can't reproduce it.
Strange.

regards,
dan carpenter


