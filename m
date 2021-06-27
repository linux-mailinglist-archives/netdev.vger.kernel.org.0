Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50FB3B5569
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 23:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhF0V4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 17:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbhF0V4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 17:56:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD214C061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 14:54:28 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mn20-20020a17090b1894b02901707fc074e8so583856pjb.0
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 14:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9W+zEXp2ehgwwcl8Pnd7OgQf7dvz1WZxZD4bLpoBn+Q=;
        b=reo3RhZnq4viQNMFfo5zxr7m7fUalD8lYUVYVHvfKu2giFL2qckAcwCmqhafr+AXrj
         BarDcX6hq4VpkjvL5YQ0sioQLkEm2HZyhWihqI3X29IS57rsK0ZltrndqSxkVGQ2zIvN
         MOwXt45XRO2Xka+mPAoEJNlzp9C1A51hMmttTfqOole6n1MhRzx17l4aDy7e3p847Jz8
         nzbs5N1k5CadkHvbV+19pRqYW3mkaSnJHWkxldAengtHVJbHnGcthNnQmNucW/8qARbp
         jmNerRjCQ4T8Basaf5cD00ot+mJgGPIgYXMMCYIO/BLH/ZyoaU96C4TG8ET/PVH4oEde
         vmbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9W+zEXp2ehgwwcl8Pnd7OgQf7dvz1WZxZD4bLpoBn+Q=;
        b=sfw83iySVSY8Cx8f+CCrDstxvX7t2Z7670waxam0FhJFNEu1QrQDRIuoaECQynCl1t
         GKKzW4bruKTmRKGABIPt/2A+CStbgOozy/57R8sv+nmVeMSEc5mpf+x15Y8guv5dMPSL
         eDpxlR7SL1EinfstVsHl/kNlqvmgbgs1VlJe5NN3tntfWJe9crCa/Dx77KJEjbyA1Bdy
         mee6p9dg0xm7FYoC0wCCVoEzxutkM0iwHkNEOngfRBDyHvvo+Da4eXkhNCJXum06TxIS
         e8ZhiPnL4a0rMQeWUJZrKnQcsYRLjDloSmzo6Yvc68rDt1FDiU+VbUjyVReRGI5cj9pk
         PzDw==
X-Gm-Message-State: AOAM532NBV/3Nzew3t5pEOA7UvWy+CSvCEd2K1cvYl3Ny8TqaqlACN+x
        0zm+CX7iYYdEZO4gcWuB5nrRpQ==
X-Google-Smtp-Source: ABdhPJz4fnSvIB8ak7zZb2WvyjOK3IxHXXDK6yUglAsoNxykaY4sNtLu1C/L3cOzOUlNATJ3778Q/Q==
X-Received: by 2002:a17:90a:e7c7:: with SMTP id kb7mr19058486pjb.96.1624830868192;
        Sun, 27 Jun 2021 14:54:28 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id e1sm12159970pfd.16.2021.06.27.14.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 14:54:27 -0700 (PDT)
Date:   Sun, 27 Jun 2021 14:54:24 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv3 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-ID: <20210627145424.181beae5@hermes.local>
In-Reply-To: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210624152812.29031-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Jun 2021 13:44:40 +0300
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:

> We started to use in-kernel filtering feature which allows to get only needed
> tables (see iproute_dump_filter()). From the kernel side it's implemented in
> net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c (inet6_dump_fib).
> The problem here is that behaviour of "ip route save" was changed after
> c7e6371bc ("ip route: Add protocol, table id and device to dump request").
> If filters are used, then kernel returns ENOENT error if requested table is absent,
> but in newly created net namespace even RT_TABLE_MAIN table doesn't exist.
> It is really allocated, for instance, after issuing "ip l set lo up".
> 
> Reproducer is fairly simple:
> $ unshare -n ip route save > dump
> Error: ipv4: FIB table does not exist.
> Dump terminated
> 
> Expected result here is to get empty dump file (as it was before this change).
> 
> v2: reworked, so, now it takes into account NLMSGERR_ATTR_MSG
> (see nl_dump_ext_ack_done() function). We want to suppress error messages
> in stderr about absent FIB table from kernel too.
> 
> v3: reworked to make code clearer. Introduced rtnl_suppressed_errors(),
> rtnl_suppress_error() helpers. User may suppress up to 3 errors (may be
> easily extened by changing SUPPRESS_ERRORS_INIT macro).
> 
> Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> ---
>  include/libnetlink.h | 37 +++++++++++++++++++++++++++++++++++++
>  ip/iproute.c         |  7 ++++++-
>  lib/libnetlink.c     | 27 ++++++++++++++++++++++-----
>  3 files changed, 65 insertions(+), 6 deletions(-)
> 
> diff --git a/include/libnetlink.h b/include/libnetlink.h
> index b9073a6a..c41f714a 100644
> --- a/include/libnetlink.h
> +++ b/include/libnetlink.h
> @@ -121,6 +121,43 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
>  			void *arg, __u16 nc_flags);
>  #define rtnl_dump_filter(rth, filter, arg) \
>  	rtnl_dump_filter_nc(rth, filter, arg, 0)
> +int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
> +		     rtnl_filter_t filter,
> +		     void *arg1, __u16 nc_flags, const int *errnos);
> +#define rtnl_dump_filter_suppress_rtnl_errmsg(rth, filter, arg, errnos) \
> +	rtnl_dump_filter_suppress_rtnl_errmsg_nc(rth, filter, arg, 0, errnos)

Sorry, this is getting really ugly.

It is almost as bad as looking at Windows source code with the extremely long
function names.

It would be better to refactor the already overload  rtnl_dump_filter into sub
components and different parts could use the sub functions as needed.

> +#define SUPPRESS_ERRORS_INIT { 0, 0, 0, 0 }

Why do you need a special macro just use {} in those places.


> +static inline int rtnl_suppressed_error(const int *errnos, int err_no)

Inline is unnecessary here.

> +{
> +	/* errnos is 0 terminated array or NULL */
> +	while (errnos && *errnos) {
> +		if (err_no == *errnos)
> +			return 1;
> +
> +		errnos++;
> +	}
> +
> +	return 0;
> +}
> +static inline void rtnl_suppress_error(int *errnos, int err_no)
Blank line between functions, Again no inline

> +{
> +	/* last 0 is trailing for errnos array */
> +	int max = sizeof((int[])SUPPRESS_ERRORS_INIT) /
> +			sizeof(int) - 1;
> +
> +	if (errnos == NULL)
> +		return;
> +
> +	for (int i = 0; i < max; i++) {
> +		if (errnos[i] == err_no)
> +			break;
> +
> +		if (!errnos[i]) {
> +			errnos[i] = err_no;
> +			break;
> +		}
> +	}
> +}
>  int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
>  	      struct nlmsghdr **answer)
>  	__attribute__((warn_unused_result));
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 5853f026..532ca724 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -1734,6 +1734,7 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
>  	char *od = NULL;
>  	unsigned int mark = 0;
>  	rtnl_filter_t filter_fn;
> +	int suppress_rtnl_errnos[] = SUPPRESS_ERRORS_INIT;
>  
>  	if (action == IPROUTE_SAVE) {
>  		if (save_route_prep())
> @@ -1939,7 +1940,11 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
>  
>  	new_json_obj(json);
>  
> -	if (rtnl_dump_filter(&rth, filter_fn, stdout) < 0) {
> +	if (filter.tb == RT_TABLE_MAIN)
> +		rtnl_suppress_error(suppress_rtnl_errnos, ENOENT);
> +
> +	if (rtnl_dump_filter_suppress_rtnl_errmsg(&rth, filter_fn, stdout,
> +						  suppress_rtnl_errnos) < 0) {
>  		fprintf(stderr, "Dump terminated\n");
>  		return -2;
>  	}
> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> index c958aa57..5c5a19bb 100644
> --- a/lib/libnetlink.c
> +++ b/lib/libnetlink.c
> @@ -673,7 +673,7 @@ int rtnl_dump_request_n(struct rtnl_handle *rth, struct nlmsghdr *n)
>  	return sendmsg(rth->fd, &msg, 0);
>  }
>  
> -static int rtnl_dump_done(struct nlmsghdr *h)
> +static int rtnl_dump_done(struct nlmsghdr *h, const int *errnos)
>  {
>  	int len = *(int *)NLMSG_DATA(h);
>  
> @@ -683,11 +683,15 @@ static int rtnl_dump_done(struct nlmsghdr *h)
>  	}
>  
>  	if (len < 0) {
> +		errno = -len;
> +
> +		if (rtnl_suppressed_error(errnos, errno))
> +			return 0;
> +
>  		/* check for any messages returned from kernel */
>  		if (nl_dump_ext_ack_done(h, len))
>  			return len;
>  
> -		errno = -len;
>  		switch (errno) {
>  		case ENOENT:
>  		case EOPNOTSUPP:
> @@ -789,7 +793,8 @@ static int rtnl_recvmsg(int fd, struct msghdr *msg, char **answer)
>  }
>  
>  static int rtnl_dump_filter_l(struct rtnl_handle *rth,
> -			      const struct rtnl_dump_filter_arg *arg)
> +			      const struct rtnl_dump_filter_arg *arg,
> +			      const int *errnos)
>  {
>  	struct sockaddr_nl nladdr;
>  	struct iovec iov;
> @@ -834,7 +839,7 @@ static int rtnl_dump_filter_l(struct rtnl_handle *rth,
>  					dump_intr = 1;
>  
>  				if (h->nlmsg_type == NLMSG_DONE) {
> -					err = rtnl_dump_done(h);
> +					err = rtnl_dump_done(h, errnos);
>  					if (err < 0) {
>  						free(buf);
>  						return -1;
> @@ -891,7 +896,19 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
>  		{ .filter = NULL,   .arg1 = NULL, .nc_flags = 0, },
>  	};
>  
> -	return rtnl_dump_filter_l(rth, a);
> +	return rtnl_dump_filter_l(rth, a, NULL);
> +}
> +
> +int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
> +		     rtnl_filter_t filter,
> +		     void *arg1, __u16 nc_flags, const int *errnos)
> +{
> +	const struct rtnl_dump_filter_arg a[2] = {
> +		{ .filter = filter, .arg1 = arg1, .nc_flags = nc_flags, },
> +		{ .filter = NULL,   .arg1 = NULL, .nc_flags = 0, },
> +	};
> +
> +	return rtnl_dump_filter_l(rth, a, errnos);
>  }
>  
>  static void rtnl_talk_error(struct nlmsghdr *h, struct nlmsgerr *err,

