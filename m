Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F71D22F580
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbgG0Qg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730660AbgG0Qg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:36:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158B2C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:36:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f185so4441424pfg.10
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qXbD5xYeRSmfSUDUCoeB7VKxtKc0PjFLG+txkeC2XNg=;
        b=Uf3nu9KoFvlkh4ZA5UWqkdiU9MXq8kwrMNRQx+I6IBcyOQusI1Y+20IaSg9ljlV7JL
         /juUNaPUgT/4WN2Y1U7/GVRWscLaZLKRDFQ+jh/N0XzQAx3KZmmBY2wxf6nJEvPmx1Xq
         wM9rHkX9nNbVhRpEoSykrKUulR0Gdix7llicRU3wPJoWIBNbIiYVxxMjkPDg9rwBemaB
         GHYlbylpC6JNQLyNbG7tDaIOvDFd1IOjB8wpFVxJ11nKImBF+DbKmP5fPEtsFAHtnFsq
         2XKAVmEjUiy8lO8SGi0jrMdc7Qd9tChn4B4ZygTVyEMWk2qKp4i8Cg7gFms6pMboJBfs
         uYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qXbD5xYeRSmfSUDUCoeB7VKxtKc0PjFLG+txkeC2XNg=;
        b=qxXf/1fVxiU1Btpfr3KEXHEbxlqvCJ8/lW3AzbKskDOoNkOqISwB+QvrkoEOKY5NCA
         /anetdltQmrwj8QlIB9GMCNu/WeZdDUP7X//xETDSfIhusrgJpEv7rTliWg64b7ELjkJ
         r6sGsmmCbk3KHTV/JdAFKL5rZP9x5dUx56BKsjmZ/HMxFZIU2eZmBvaY38ugm0M18Osj
         +oTM5YQYGiN782dmuXG3IJyeJH4SG4Ar9RJBaD2VsovD9JVWZc/mp+Wb9pUPZ87Ul2Yk
         MqTZ3uetNqe1us5r/dryZjF5aGpR8/PIeybIMtsLvrpVWAQtEe4XW65t75pNkA1UGKG5
         VatA==
X-Gm-Message-State: AOAM531HDNfw8QOn0S7jRKdDT7HliNiQ3Seq596vZ6EiSvaKpedgKDtt
        6o5I1ufSYzcdLeM9TuK8Gd2L2Er66CmLbQ==
X-Google-Smtp-Source: ABdhPJwy+51uIvj93Z8yoBJSUSfWKl0DU9AS6Nvov0/nP5YZgsJKdDcIy8RVJ+J8mSN5DueVEl4xjw==
X-Received: by 2002:a63:c58:: with SMTP id 24mr19789693pgm.343.1595867818429;
        Mon, 27 Jul 2020 09:36:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 141sm16423972pfw.72.2020.07.27.09.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:36:58 -0700 (PDT)
Date:   Mon, 27 Jul 2020 09:36:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        roopa@cumulusnetworks.com, amarao@servers.com, jiri@resnulli.us
Subject: Re: [RFC iproute2] ip: bridge: use -human to convert time-related
 values to seconds
Message-ID: <20200727093649.7de94fbe@hermes.lan>
In-Reply-To: <20200726165033.k3psh2erpjkrq3ks@skbuf>
References: <20200725201758.4cfae512@hermes.lan>
        <20200726104323.302946-1-nikolay@cumulusnetworks.com>
        <20200726162120.7pwpxxlpsoduxafd@skbuf>
        <3fe30430-8480-fdbd-f078-496b3842f37b@cumulusnetworks.com>
        <20200726165033.k3psh2erpjkrq3ks@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jul 2020 19:50:33 +0300
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Sun, Jul 26, 2020 at 07:34:06PM +0300, Nikolay Aleksandrov wrote:
> > On 26/07/2020 19:21, Vladimir Oltean wrote:  
> > > Hi Nikolay,
> > > 
> > > On Sun, Jul 26, 2020 at 01:43:23PM +0300, Nikolay Aleksandrov wrote:  
> > >> We have been printing and expecting the time-related bridge options
> > >> scaled by USER_HZ which is confusing to users and hasn't been documented
> > >> anywhere. Unfortunately that has been the case for years and people who
> > >> use ip-link are scaling the values themselves by now. In order to help
> > >> anyone who wants to show and set the values in normal time (seconds) we
> > >> can use the ip -h[uman] argument. When it is supplied all values will be
> > >> shown and expected in their normal time (currently all in seconds).
> > >> The man page is also adjusted everywhere to explain the current scaling
> > >> and the new option.
> > >>
> > >> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> > >> ---
> > >> To avoid printing the values twice (i.e. the _ms solution) we can use
> > >> the -human argument to scale them properly. Obviously -human is an alias
> > >> right now for -human-readable, that's why I refer to it only as -human
> > >> in the ip-link man page since we are now using it for setting values, too.
> > >> Alternatively this can be any new option such as -Timescale.
> > >>
> > >> What do you think ?
> > >>  
> > > 
> > > The old ip-link also accepts commands of the form:
> > > "ip -h link set br0 type bridge ageing_time 300"
> > >   
> > 
> > That's why I mentioned the new option like -Timescale or some other unused,
> > so you can be sure. I just didn't want to add a whole new ip argument just
> > for this mess.
> >   
> 
> That would have been more effective at eliminating the confusion than
> -human, but I understand the desire to not introduce an entirely new
> option.
> 
> > > so I'm not sure, with my user hat on, how can I know whether the
> > > particular iproute2 binary I'm using understood what I meant or not.
> > >   
> > 
> > Then I'll just stick to the original plan of duplicating the values and adding _ms
> > version for them. That won't require any new options at least, it will just take
> > more screen space.
> >   
> 
> In a way, I think this is better.
> If more time-related options ever appear in ip-link, I think that
> introducing a flag like '-Timescale' now would force us to support
> values in the old format (not scaled by USER_HZ) for those new options
> too. But, if we were to introduce ageing_time_ms, etc, then the only
> thing a new option would have to do is to name itself using a similar
> pattern (with the unit of measurement at the end). Then it would be
> clear that the non-scaled input isn't available.
> 
> But, all of this is just my 2 'bani' (Romanian, less valuable version of
> cents). Let's hear from more people.
> 
> > >>  ip/iplink_bridge.c    | 49 +++++++++++++++++++++++++------------------
> > >>  man/man8/ip-link.8.in | 33 +++++++++++++++++------------
> > >>  2 files changed, 49 insertions(+), 33 deletions(-)
> > >>
> > >> diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
> > >> index 3e81aa059cb3..8313cdbd0a92 100644
> > >> --- a/ip/iplink_bridge.c
> > >> +++ b/ip/iplink_bridge.c
> > >> @@ -24,6 +24,7 @@
> > >>  
> > >>  static unsigned int xstats_print_attr;
> > >>  static int filter_index;
> > >> +static int hz = 1;
> > >>  
> > >>  static void print_explain(FILE *f)
> > >>  {
> > >> @@ -64,6 +65,9 @@ static void print_explain(FILE *f)
> > >>  		"		  [ nf_call_arptables NF_CALL_ARPTABLES ]\n"
> > >>  		"\n"
> > >>  		"Where: VLAN_PROTOCOL := { 802.1Q | 802.1ad }\n"
> > >> +		"Note that all time-related options are scaled by USER_HZ (%d), in order to\n"
> > >> +		"set and show them as seconds please use the ip -h[uman] argument.\n",
> > >> +		get_user_hz()
> > >>  	);
> > >>  }
> > >>  
> > >> @@ -85,31 +89,34 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
> > >>  {
> > >>  	__u32 val;
> > >>  
> > >> +	if (human_readable)
> > >> +		hz = get_user_hz();
> > >> +
> > >>  	while (argc > 0) {
> > >>  		if (matches(*argv, "forward_delay") == 0) {
> > >>  			NEXT_ARG();
> > >>  			if (get_u32(&val, *argv, 0))
> > >>  				invarg("invalid forward_delay", *argv);
> > >>  
> > >> -			addattr32(n, 1024, IFLA_BR_FORWARD_DELAY, val);
> > >> +			addattr32(n, 1024, IFLA_BR_FORWARD_DELAY, val * hz);
> > >>  		} else if (matches(*argv, "hello_time") == 0) {
> > >>  			NEXT_ARG();
> > >>  			if (get_u32(&val, *argv, 0))
> > >>  				invarg("invalid hello_time", *argv);
> > >>  
> > >> -			addattr32(n, 1024, IFLA_BR_HELLO_TIME, val);
> > >> +			addattr32(n, 1024, IFLA_BR_HELLO_TIME, val * hz);
> > >>  		} else if (matches(*argv, "max_age") == 0) {
> > >>  			NEXT_ARG();
> > >>  			if (get_u32(&val, *argv, 0))
> > >>  				invarg("invalid max_age", *argv);
> > >>  
> > >> -			addattr32(n, 1024, IFLA_BR_MAX_AGE, val);
> > >> +			addattr32(n, 1024, IFLA_BR_MAX_AGE, val * hz);
> > >>  		} else if (matches(*argv, "ageing_time") == 0) {
> > >>  			NEXT_ARG();
> > >>  			if (get_u32(&val, *argv, 0))
> > >>  				invarg("invalid ageing_time", *argv);  
> > > 
> > > Also, you seem to have skipped updating the docs for ageing_time.
> > >   
> > 
> > Right, it's an rfc for a discussion only, I'm not posting it for applying. :)
> > It's not tested or polished in any way.
> >   
> 
> Ok, I did test it, but this thing stood out to me.
> 
> > >>  
> > >> -			addattr32(n, 1024, IFLA_BR_AGEING_TIME, val);
> > >> +			addattr32(n, 1024, IFLA_BR_AGEING_TIME, val * hz);
> > >>  		} else if (matches(*argv, "stp_state") == 0) {
> > >>  			NEXT_ARG();
> > >>  			if (get_u32(&val, *argv, 0))
> > >> @@ -266,7 +273,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
> > >>  				       *argv);
> > >>  
> > >>  			addattr64(n, 1024, IFLA_BR_MCAST_LAST_MEMBER_INTVL,
> > >> -				  mcast_last_member_intvl);
> > >> +				  mcast_last_member_intvl * hz);
> > >>  		} else if (matches(*argv, "mcast_membership_interval") == 0) {
> > >>  			__u64 mcast_membership_intvl;
> > >>  
> > >> @@ -276,7 +283,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
> > >>  				       *argv);
> > >>  
> > >>  			addattr64(n, 1024, IFLA_BR_MCAST_MEMBERSHIP_INTVL,
> > >> -				  mcast_membership_intvl);
> > >> +				  mcast_membership_intvl * hz);
> > >>  		} else if (matches(*argv, "mcast_querier_interval") == 0) {
> > >>  			__u64 mcast_querier_intvl;
> > >>  
> > >> @@ -286,7 +293,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
> > >>  				       *argv);
> > >>  
> > >>  			addattr64(n, 1024, IFLA_BR_MCAST_QUERIER_INTVL,
> > >> -				  mcast_querier_intvl);
> > >> +				  mcast_querier_intvl * hz);
> > >>  		} else if (matches(*argv, "mcast_query_interval") == 0) {
> > >>  			__u64 mcast_query_intvl;
> > >>  
> > >> @@ -296,7 +303,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
> > >>  				       *argv);
> > >>  
> > >>  			addattr64(n, 1024, IFLA_BR_MCAST_QUERY_INTVL,
> > >> -				  mcast_query_intvl);
> > >> +				  mcast_query_intvl * hz);
> > >>  		} else if (!matches(*argv, "mcast_query_response_interval")) {
> > >>  			__u64 mcast_query_resp_intvl;
> > >>  
> > >> @@ -306,7 +313,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
> > >>  				       *argv);
> > >>  
> > >>  			addattr64(n, 1024, IFLA_BR_MCAST_QUERY_RESPONSE_INTVL,
> > >> -				  mcast_query_resp_intvl);
> > >> +				  mcast_query_resp_intvl * hz);
> > >>  		} else if (!matches(*argv, "mcast_startup_query_interval")) {
> > >>  			__u64 mcast_startup_query_intvl;
> > >>  
> > >> @@ -316,7 +323,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
> > >>  				       *argv);
> > >>  
> > >>  			addattr64(n, 1024, IFLA_BR_MCAST_STARTUP_QUERY_INTVL,
> > >> -				  mcast_startup_query_intvl);
> > >> +				  mcast_startup_query_intvl * hz);
> > >>  		} else if (matches(*argv, "mcast_stats_enabled") == 0) {
> > >>  			__u8 mcast_stats_enabled;
> > >>  
> > >> @@ -406,30 +413,32 @@ static void bridge_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> > >>  {
> > >>  	if (!tb)
> > >>  		return;
> > >> +	if (human_readable)
> > >> +		hz = get_user_hz();
> > >>  
> > >>  	if (tb[IFLA_BR_FORWARD_DELAY])
> > >>  		print_uint(PRINT_ANY,
> > >>  			   "forward_delay",
> > >>  			   "forward_delay %u ",
> > >> -			   rta_getattr_u32(tb[IFLA_BR_FORWARD_DELAY]));
> > >> +			   rta_getattr_u32(tb[IFLA_BR_FORWARD_DELAY]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_HELLO_TIME])
> > >>  		print_uint(PRINT_ANY,
> > >>  			   "hello_time",
> > >>  			   "hello_time %u ",
> > >> -			   rta_getattr_u32(tb[IFLA_BR_HELLO_TIME]));
> > >> +			   rta_getattr_u32(tb[IFLA_BR_HELLO_TIME]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_MAX_AGE])
> > >>  		print_uint(PRINT_ANY,
> > >>  			   "max_age",
> > >>  			   "max_age %u ",
> > >> -			   rta_getattr_u32(tb[IFLA_BR_MAX_AGE]));
> > >> +			   rta_getattr_u32(tb[IFLA_BR_MAX_AGE]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_AGEING_TIME])
> > >>  		print_uint(PRINT_ANY,
> > >>  			   "ageing_time",
> > >>  			   "ageing_time %u ",
> > >> -			   rta_getattr_u32(tb[IFLA_BR_AGEING_TIME]));
> > >> +			   rta_getattr_u32(tb[IFLA_BR_AGEING_TIME]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_STP_STATE])
> > >>  		print_uint(PRINT_ANY,
> > >> @@ -605,37 +614,37 @@ static void bridge_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> > >>  		print_lluint(PRINT_ANY,
> > >>  			     "mcast_last_member_intvl",
> > >>  			     "mcast_last_member_interval %llu ",
> > >> -			     rta_getattr_u64(tb[IFLA_BR_MCAST_LAST_MEMBER_INTVL]));
> > >> +			     rta_getattr_u64(tb[IFLA_BR_MCAST_LAST_MEMBER_INTVL]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_MCAST_MEMBERSHIP_INTVL])
> > >>  		print_lluint(PRINT_ANY,
> > >>  			     "mcast_membership_intvl",
> > >>  			     "mcast_membership_interval %llu ",
> > >> -			     rta_getattr_u64(tb[IFLA_BR_MCAST_MEMBERSHIP_INTVL]));
> > >> +			     rta_getattr_u64(tb[IFLA_BR_MCAST_MEMBERSHIP_INTVL]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_MCAST_QUERIER_INTVL])
> > >>  		print_lluint(PRINT_ANY,
> > >>  			     "mcast_querier_intvl",
> > >>  			     "mcast_querier_interval %llu ",
> > >> -			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERIER_INTVL]));
> > >> +			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERIER_INTVL]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_MCAST_QUERY_INTVL])
> > >>  		print_lluint(PRINT_ANY,
> > >>  			     "mcast_query_intvl",
> > >>  			     "mcast_query_interval %llu ",
> > >> -			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_INTVL]));
> > >> +			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_INTVL]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL])
> > >>  		print_lluint(PRINT_ANY,
> > >>  			     "mcast_query_response_intvl",
> > >>  			     "mcast_query_response_interval %llu ",
> > >> -			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]));
> > >> +			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_MCAST_STARTUP_QUERY_INTVL])
> > >>  		print_lluint(PRINT_ANY,
> > >>  			     "mcast_startup_query_intvl",
> > >>  			     "mcast_startup_query_interval %llu ",
> > >> -			     rta_getattr_u64(tb[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]));
> > >> +			     rta_getattr_u64(tb[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]) / hz);
> > >>  
> > >>  	if (tb[IFLA_BR_MCAST_STATS_ENABLED])
> > >>  		print_uint(PRINT_ANY,
> > >> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> > >> index c6bd2c530547..efd8a877f7a3 100644
> > >> --- a/man/man8/ip-link.8.in
> > >> +++ b/man/man8/ip-link.8.in
> > >> @@ -1431,9 +1431,11 @@ corresponds to the 2010 version of the HSR standard. Option "1" activates the
> > >>  BRIDGE Type Support
> > >>  For a link of type
> > >>  .I BRIDGE
> > >> -the following additional arguments are supported:
> > >> +the following additional arguments are supported. Note that by default time-related options are scaled by USER_HZ (100), use -h[uman] argument to convert them from seconds when
> > >> +setting and to seconds when using show.
> > >> +
> > >>  
> > >> -.BI "ip link add " DEVICE " type bridge "
> > >> +.BI "ip [-human] link add " DEVICE " type bridge "
> > >>  [
> > >>  .BI ageing_time " AGEING_TIME "
> > >>  ] [
> > >> @@ -1523,21 +1525,22 @@ address format, ie an address of the form 01:80:C2:00:00:0X, with X
> > >>   in [0, 4..f].
> > >>  
> > >>  .BI forward_delay " FORWARD_DELAY "
> > >> -- set the forwarding delay in seconds, ie the time spent in LISTENING
> > >> +- set the forwarding delay, ie the time spent in LISTENING
> > >>  state (before moving to LEARNING) and in LEARNING state (before
> > >>  moving to FORWARDING). Only relevant if STP is enabled. Valid values
> > >> -are between 2 and 30.
> > >> +when -h[uman] is used (in seconds) are between 2 and 30.
> > >>  
> > >>  .BI hello_time " HELLO_TIME "
> > >> -- set the time in seconds between hello packets sent by the bridge,
> > >> -when it is a root bridge or a designated bridges.
> > >> -Only relevant if STP is enabled. Valid values are between 1 and 10.
> > >> +- set the time between hello packets sent by the bridge, when
> > >> +it is a root bridge or a designated bridges.
> > >> +Only relevant if STP is enabled. Valid values when -h[uman] is used
> > >> +(in seconds) are between 1 and 10.
> > >>  
> > >>  .BI max_age " MAX_AGE "
> > >>  - set the hello packet timeout, ie the time in seconds until another
> > >>  bridge in the spanning tree is assumed to be dead, after reception of
> > >>  its last hello message. Only relevant if STP is enabled. Valid values
> > >> -are between 6 and 40.
> > >> +when -h[uman] is used (in seconds) are between 6 and 40.
> > >>  
> > >>  .BI stp_state " STP_STATE "
> > >>  - turn spanning tree protocol on
> > >> @@ -1619,7 +1622,7 @@ IGMP querier, ie sending of multicast queries by the bridge (default: disabled).
> > >>  after this delay has passed, the bridge will start to send its own queries
> > >>  (as if
> > >>  .BI mcast_querier
> > >> -was enabled).
> > >> +was enabled). When -h[uman] is used the value will be interpreted as seconds.
> > >>  
> > >>  .BI mcast_hash_elasticity " HASH_ELASTICITY "
> > >>  - set multicast database hash elasticity, ie the maximum chain length
> > >> @@ -1636,25 +1639,29 @@ message has been received (defaults to 2).
> > >>  
> > >>  .BI mcast_last_member_interval " LAST_MEMBER_INTERVAL "
> > >>  - interval between queries to find remaining members of a group,
> > >> -after a "leave" message is received.
> > >> +after a "leave" message is received. When -h[uman] is used the value
> > >> +will be interpreted as seconds.
> > >>  
> > >>  .BI mcast_startup_query_count " STARTUP_QUERY_COUNT "
> > >>  - set the number of IGMP queries to send during startup phase (defaults to 2).
> > >>  
> > >>  .BI mcast_startup_query_interval " STARTUP_QUERY_INTERVAL "
> > >> -- interval between queries in the startup phase.
> > >> +- interval between queries in the startup phase. When -h[uman] is used the
> > >> +value will be interpreted as seconds.
> > >>  
> > >>  .BI mcast_query_interval " QUERY_INTERVAL "
> > >>  - interval between queries sent by the bridge after the end of the
> > >> -startup phase.
> > >> +startup phase. When -h[uman] is used the value will be interpreted as seconds.
> > >>  
> > >>  .BI mcast_query_response_interval " QUERY_RESPONSE_INTERVAL "
> > >>  - set the Max Response Time/Maximum Response Delay for IGMP/MLD
> > >> -queries sent by the bridge.
> > >> +queries sent by the bridge. When -h[uman] is used the value will
> > >> +be interpreted as seconds.
> > >>  
> > >>  .BI mcast_membership_interval " MEMBERSHIP_INTERVAL "
> > >>  - delay after which the bridge will leave a group,
> > >>  if no membership reports for this group are received.
> > >> +When -h[uman] is used the value will be interpreted as seconds.
> > >>  
> > >>  .BI mcast_stats_enabled " MCAST_STATS_ENABLED "
> > >>  - enable

This set of idea looks promising.

A couple of suggestions.
1. Don't use the variable hz, it is confusing relative to the rest of the code
   base where hz is always the value from get_user_hz(). Some other name would be better.

2. It might be helpful go allow floating point in the command syntax since the value is scaled.
   This would allow for smaller values when still scaled.


