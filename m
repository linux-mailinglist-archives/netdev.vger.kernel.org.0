Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0003B6783
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 19:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhF1RUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 13:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbhF1RUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 13:20:15 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33E7C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 10:17:49 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id b5so1781461plg.2
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 10:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=itQDbN2Wbz4autCWiiPvgHSzEMfRuRCahL5Wi0o1eXM=;
        b=ZbW18lU5CCB7MoYg1gYjvPYrMtmFS2kuf5rw+d9ATpHZ3ZPVP/UvLySQj0+ZLfTJ1P
         hqrpNEeYq2IHqAahy5O8C415r4dL4M1tzQFT/O4PL1eAaS7U8fJtvmVITcWAwN9XAPFh
         0OPYhioMKlgCyi7PzRitFcxcEEnYKVIsuvKrUjtI9hult0TNh3trCwOU4Wq0V/MBj9fL
         668VfzoeZb0tgnFGb/0R8eccODVyzGI+u9thbv9h7d2l7trQh/AsCe3dM5Lh8VCqzX5b
         HhwOdfKULV5u6GQ+omGy7w1pJyaJG2nTAvaDJMxp3oaEtD6ppRd5wrYGdDSw0kGEBlNd
         GrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=itQDbN2Wbz4autCWiiPvgHSzEMfRuRCahL5Wi0o1eXM=;
        b=EHFM+3Tl7vwnU9SIjtWKYLPW1g8Fz5D8WPaw4K78e+rTbvyW56+PgpnEpkDq58913Z
         FPwZomsSkkD44NUta4WpHj1+tNUbuFrN7K+QNMTx5bnyHZROR6MJ6RJAXX4vqpYLdunh
         mLUIbTdxBEKDGhaY+0wIPShmJKUhmve6ckxsbqpncfVoejG+DqYIZRoMI1M+VVsdH4pz
         IAfl85oIQzqzK4KMkKcweGrAk8zKxaHJoqrXb4etmN4/luPlNSTdmUzsS4naBE1VpAqD
         AyAD4Y6OIH1sHmrZnSmwHmetEiHGKFH69ywq17Jw1xXxr2i6g0ZYvyKFQ3Jzv1N5oDIS
         0OlQ==
X-Gm-Message-State: AOAM531fPON1D8eUe4xPHhfLmPIil7ic2VTpvU+kT+aVAw1/j+sr+qTa
        nhGkcOhyjgnCquRAFaviYThFfQ==
X-Google-Smtp-Source: ABdhPJw/3GpVXSfGOWoJro0C9Zsp7Pu660n0FbGhDnA2Uu2w9a6+S34CGMJgqFxQN02szpz6PUBbmQ==
X-Received: by 2002:a17:90a:4295:: with SMTP id p21mr5394374pjg.149.1624900668970;
        Mon, 28 Jun 2021 10:17:48 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id 195sm15202342pfw.133.2021.06.28.10.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 10:17:48 -0700 (PDT)
Date:   Mon, 28 Jun 2021 10:17:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv3 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-ID: <20210628101745.1963b836@hermes.local>
In-Reply-To: <20210628093132.fe747541cbf0c708ac4da640@virtuozzo.com>
References: <20210624152812.29031-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210627145424.181beae5@hermes.local>
        <20210628093132.fe747541cbf0c708ac4da640@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Jun 2021 09:31:32 +0300
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:

> On Sun, 27 Jun 2021 14:54:24 -0700
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> > On Fri, 25 Jun 2021 13:44:40 +0300
> > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> >   
> > > We started to use in-kernel filtering feature which allows to get only needed
> > > tables (see iproute_dump_filter()). From the kernel side it's implemented in
> > > net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c (inet6_dump_fib).
> > > The problem here is that behaviour of "ip route save" was changed after
> > > c7e6371bc ("ip route: Add protocol, table id and device to dump request").
> > > If filters are used, then kernel returns ENOENT error if requested table is absent,
> > > but in newly created net namespace even RT_TABLE_MAIN table doesn't exist.
> > > It is really allocated, for instance, after issuing "ip l set lo up".
> > > 
> > > Reproducer is fairly simple:
> > > $ unshare -n ip route save > dump
> > > Error: ipv4: FIB table does not exist.
> > > Dump terminated
> > > 
> > > Expected result here is to get empty dump file (as it was before this change).
> > > 
> > > v2: reworked, so, now it takes into account NLMSGERR_ATTR_MSG
> > > (see nl_dump_ext_ack_done() function). We want to suppress error messages
> > > in stderr about absent FIB table from kernel too.
> > > 
> > > v3: reworked to make code clearer. Introduced rtnl_suppressed_errors(),
> > > rtnl_suppress_error() helpers. User may suppress up to 3 errors (may be
> > > easily extened by changing SUPPRESS_ERRORS_INIT macro).
> > > 
> > > Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
> > > Cc: David Ahern <dsahern@gmail.com>
> > > Cc: Stephen Hemminger <stephen@networkplumber.org>
> > > Cc: Andrei Vagin <avagin@gmail.com>
> > > Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> > > Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> > > ---
> > >  include/libnetlink.h | 37 +++++++++++++++++++++++++++++++++++++
> > >  ip/iproute.c         |  7 ++++++-
> > >  lib/libnetlink.c     | 27 ++++++++++++++++++++++-----
> > >  3 files changed, 65 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/include/libnetlink.h b/include/libnetlink.h
> > > index b9073a6a..c41f714a 100644
> > > --- a/include/libnetlink.h
> > > +++ b/include/libnetlink.h
> > > @@ -121,6 +121,43 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
> > >  			void *arg, __u16 nc_flags);
> > >  #define rtnl_dump_filter(rth, filter, arg) \
> > >  	rtnl_dump_filter_nc(rth, filter, arg, 0)
> > > +int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
> > > +		     rtnl_filter_t filter,
> > > +		     void *arg1, __u16 nc_flags, const int *errnos);
> > > +#define rtnl_dump_filter_suppress_rtnl_errmsg(rth, filter, arg, errnos) \
> > > +	rtnl_dump_filter_suppress_rtnl_errmsg_nc(rth, filter, arg, 0, errnos)  
> > 
> > Sorry, this is getting really ugly.  
> 
> Sorry, I apparently overdid it in refactoring ;)
> 
> > 
> > It is almost as bad as looking at Windows source code with the extremely long
> > function names.  
> 
> Sure, I will choose shorter names.
> 
> > 
> > It would be better to refactor the already overload  rtnl_dump_filter into sub
> > components and different parts could use the sub functions as needed.
> >   
> > > +#define SUPPRESS_ERRORS_INIT { 0, 0, 0, 0 }  
> > 
> > Why do you need a special macro just use {} in those places.  
> 
> It seems like I wrongly interpreted you words about "magic array of size 2"
> >>The design would be clearer if there were two arguments rather than magic array of size 2.  
> If I understand you correctly, you wanted to say that it's not fully convenient to read and
> see "magic" initializator { 0, 0, 0, 0 } or similar. (why four zeroes? why not 3 or 1?)
> So, I've decided to make macro for this initializer like we have macros for linked lists
> initializators in kernel, for instance. Another reason is that If someone need to skip more than
> 3 errors, he can change initializer size and helper function rtnl_suppress_error() will
> take new size into account.
> 
> What I want to implement:
> 1. Possibility to skip several errors in rtnl_dump_filter
> 2. Not use malloc for allocation of "errors" array (because array is really small and
> malloc needs free, so it's easier to make errors with memleak in the future)
> 3. I'm trying not to change original function rtnl_dump_filter() signature because
> it's used in other places and that's a stable API.
> 4. We want to allow programmer to dynamically add skipped errors. It means that
> user not specifying array of skipped errors directly like { ENOENT, ENOSUPP, 0 }, but
> can write something like:
> if (ignore_old_kernel_errors)
>     rtnl_suppress_error(errors, ENOSUPP)
> if (some_another_reason)
>     rtnl_suppress_error(errors, ENOENT)
> 
> 
> Maybe some of my points not valid for us and I can throw it?
> 
> Thank you for review! ;)
> 
> Alex.
> 
> > 
> >   
> > > +static inline int rtnl_suppressed_error(const int *errnos, int err_no)  
> > 
> > Inline is unnecessary here.
> >   
> > > +{
> > > +	/* errnos is 0 terminated array or NULL */
> > > +	while (errnos && *errnos) {
> > > +		if (err_no == *errnos)
> > > +			return 1;
> > > +
> > > +		errnos++;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +static inline void rtnl_suppress_error(int *errnos, int err_no)  
> > Blank line between functions, Again no inline
> >   
> > > +{
> > > +	/* last 0 is trailing for errnos array */
> > > +	int max = sizeof((int[])SUPPRESS_ERRORS_INIT) /
> > > +			sizeof(int) - 1;
> > > +
> > > +	if (errnos == NULL)
> > > +		return;
> > > +
> > > +	for (int i = 0; i < max; i++) {
> > > +		if (errnos[i] == err_no)
> > > +			break;
> > > +
> > > +		if (!errnos[i]) {
> > > +			errnos[i] = err_no;
> > > +			break;
> > > +		}
> > > +	}
> > > +}
> > >  int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
> > >  	      struct nlmsghdr **answer)
> > >  	__attribute__((warn_unused_result));
> > > diff --git a/ip/iproute.c b/ip/iproute.c
> > > index 5853f026..532ca724 100644
> > > --- a/ip/iproute.c
> > > +++ b/ip/iproute.c
> > > @@ -1734,6 +1734,7 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
> > >  	char *od = NULL;
> > >  	unsigned int mark = 0;
> > >  	rtnl_filter_t filter_fn;
> > > +	int suppress_rtnl_errnos[] = SUPPRESS_ERRORS_INIT;
> > >  
> > >  	if (action == IPROUTE_SAVE) {
> > >  		if (save_route_prep())
> > > @@ -1939,7 +1940,11 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
> > >  
> > >  	new_json_obj(json);
> > >  
> > > -	if (rtnl_dump_filter(&rth, filter_fn, stdout) < 0) {
> > > +	if (filter.tb == RT_TABLE_MAIN)
> > > +		rtnl_suppress_error(suppress_rtnl_errnos, ENOENT);
> > > +
> > > +	if (rtnl_dump_filter_suppress_rtnl_errmsg(&rth, filter_fn, stdout,
> > > +						  suppress_rtnl_errnos) < 0) {
> > >  		fprintf(stderr, "Dump terminated\n");
> > >  		return -2;
> > >  	}
> > > diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> > > index c958aa57..5c5a19bb 100644
> > > --- a/lib/libnetlink.c
> > > +++ b/lib/libnetlink.c
> > > @@ -673,7 +673,7 @@ int rtnl_dump_request_n(struct rtnl_handle *rth, struct nlmsghdr *n)
> > >  	return sendmsg(rth->fd, &msg, 0);
> > >  }
> > >  
> > > -static int rtnl_dump_done(struct nlmsghdr *h)
> > > +static int rtnl_dump_done(struct nlmsghdr *h, const int *errnos)
> > >  {
> > >  	int len = *(int *)NLMSG_DATA(h);
> > >  
> > > @@ -683,11 +683,15 @@ static int rtnl_dump_done(struct nlmsghdr *h)
> > >  	}
> > >  
> > >  	if (len < 0) {
> > > +		errno = -len;
> > > +
> > > +		if (rtnl_suppressed_error(errnos, errno))
> > > +			return 0;
> > > +
> > >  		/* check for any messages returned from kernel */
> > >  		if (nl_dump_ext_ack_done(h, len))
> > >  			return len;
> > >  
> > > -		errno = -len;
> > >  		switch (errno) {
> > >  		case ENOENT:
> > >  		case EOPNOTSUPP:
> > > @@ -789,7 +793,8 @@ static int rtnl_recvmsg(int fd, struct msghdr *msg, char **answer)
> > >  }
> > >  
> > >  static int rtnl_dump_filter_l(struct rtnl_handle *rth,
> > > -			      const struct rtnl_dump_filter_arg *arg)
> > > +			      const struct rtnl_dump_filter_arg *arg,
> > > +			      const int *errnos)
> > >  {
> > >  	struct sockaddr_nl nladdr;
> > >  	struct iovec iov;
> > > @@ -834,7 +839,7 @@ static int rtnl_dump_filter_l(struct rtnl_handle *rth,
> > >  					dump_intr = 1;
> > >  
> > >  				if (h->nlmsg_type == NLMSG_DONE) {
> > > -					err = rtnl_dump_done(h);
> > > +					err = rtnl_dump_done(h, errnos);
> > >  					if (err < 0) {
> > >  						free(buf);
> > >  						return -1;
> > > @@ -891,7 +896,19 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
> > >  		{ .filter = NULL,   .arg1 = NULL, .nc_flags = 0, },
> > >  	};
> > >  
> > > -	return rtnl_dump_filter_l(rth, a);
> > > +	return rtnl_dump_filter_l(rth, a, NULL);
> > > +}
> > > +
> > > +int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
> > > +		     rtnl_filter_t filter,
> > > +		     void *arg1, __u16 nc_flags, const int *errnos)
> > > +{
> > > +	const struct rtnl_dump_filter_arg a[2] = {
> > > +		{ .filter = filter, .arg1 = arg1, .nc_flags = nc_flags, },
> > > +		{ .filter = NULL,   .arg1 = NULL, .nc_flags = 0, },
> > > +	};
> > > +
> > > +	return rtnl_dump_filter_l(rth, a, errnos);
> > >  }
> > >  
> > >  static void rtnl_talk_error(struct nlmsghdr *h, struct nlmsgerr *err,  
> >   

Maybe adding an error handler callback to existing dump filter routine.
And add a rtnl_dump_error() function as the default error handler. (ie if NULL is passed)
That way your callback could skip what ever errors it wants and call the rtnl_dump_error
routine for the ones it wants to handle.

