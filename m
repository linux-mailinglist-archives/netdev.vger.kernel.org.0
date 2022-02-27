Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DAD4C59D9
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 08:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiB0G5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 01:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiB0G5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 01:57:43 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34056397
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 22:57:06 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id u7so13052031ljk.13
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 22:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oAf2oWNhW9qEB7vdcPVk5Qwf1RwFzDCA+/Fg2kDsT3Y=;
        b=YUmISEjT2zvulXQI11CH2zjmkTgyRfcuUGbf1dfEfrkDz0+0Og3d8UwEZ7U9uiL57S
         7mxc4nqBBMJW/ICeQrPFA/bxPT41rX8cE9+eOX02DkokFMHbz8G1agdm53Z6KEb3ycNb
         yOpayTVwKKNOywR9LEmnWRnDbCECzSgHbZEi6CW6Hqzb7BEFVCDE2gVgctUHGwWIFsAe
         YEqb8Z1S5nJDlh6yWNd5ntBgeS6tWdvnlob0fqW99DbXP5gdAPs7xcuaFItchc4JIoPI
         7lKwhKHXijBhFrbV4k9OPH01xNS+LJkyaaO8n4W0pLFGtbt3aDIfH75688VT361wzFfV
         /msg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oAf2oWNhW9qEB7vdcPVk5Qwf1RwFzDCA+/Fg2kDsT3Y=;
        b=gwQugp73tq6W1XrGjQ9vYoXDQ4b6JiVLsSQO3e0tbyH7rK9eevtH5XUaX4aTS4PX6h
         QjmO4aeMEmd1jx+RQMD06u+EWBz76ylSWqJnPvbNOAtORJiHAlMRNrELwJpMkNJ3JoV5
         2AD3K1g4UVYsc35AVMfyCVYTjOtlXKVs9uLXrrlQPjL6aPijUVcPdUz1Nr/PlP6u5pSo
         hS6Fg1ZrixObmZpDJ9Qxr74vdTXN7MsPRDn7o8fkJLEBSszn5+4oc0UYlgmr8jkSl04O
         mGaYmjLbSnJQzOfv7sxy/x9IVCteRAJp05VmZ1Cbq4rLF7nQ6JL/TtaB/s1i+30JTp2V
         Tkqw==
X-Gm-Message-State: AOAM5316KNyZGozRDLOiaK5OnNbXmLy2Tmj+fRuluh85goFjqCoBhaUM
        D/MkbK781Cm5mIhxpogMJkV38cvfqzoWsg==
X-Google-Smtp-Source: ABdhPJxWcK5XlCgdThDLdxMA23fa2sCOw4qT6G9A/ch4dg7JcJ+dmA1urv3HddV8xbzqYIdzIshaNQ==
X-Received: by 2002:a2e:6804:0:b0:244:b354:1c99 with SMTP id c4-20020a2e6804000000b00244b3541c99mr10535090lja.79.1645945024644;
        Sat, 26 Feb 2022 22:57:04 -0800 (PST)
Received: from [10.8.100.128] (h-98-128-230-58.NA.cust.bahnhof.se. [98.128.230.58])
        by smtp.gmail.com with ESMTPSA id n16-20020a0565120ad000b004439844469fsm605191lfu.206.2022.02.26.22.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Feb 2022 22:57:04 -0800 (PST)
Message-ID: <a651c26e-24e7-560e-544d-24b4e0a9ae6a@norrbonn.se>
Date:   Sun, 27 Feb 2022 07:57:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2-next v3 1/2] ip: GTP support in ip link
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, laforge@gnumonks.org
References: <20220211182902.11542-1-wojciech.drewek@intel.com>
 <20220211182902.11542-2-wojciech.drewek@intel.com>
From:   Jonas Bonn <jonas@norrbonn.se>
In-Reply-To: <20220211182902.11542-2-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/02/2022 19:29, Wojciech Drewek wrote:
> Support for creating GTP devices through ip link. Two arguments
> can be specified by the user when adding device of the GTP type.
>   - role (sgsn or ggsn) - indicates whether we are on the GGSN or SGSN

It would be really nice to modernize these names before exposing this API.

When I added the role property to the driver, it was largely to 
complement the behaviour of the OpenGGSN library, who was essentially 
the only user of this module at the time.  However, even at that time 
the choice of name was awkward because we were well into the 4G era so 
SGSN/GGSN was already somewhat legacy terminology; today, these terms 
are starting to raise some eyebrows amongst younger developers who may 
be well versed in 4G/5G, but for whom 3G is somewhat ancient history.

3GPP has a well-accepted definition of "uplink" and "downlink" which is 
probably what we should be using instead.  So sgsn becomes "uplink" and 
ggsn becomes "downlink", with the distinction here being whether packets 
are routed by source or destination IP address.

/Jonas




>   - hsize - indicates the size of the hash table where PDP sessions
>     are stored
> 
> IFLA_GTP_FD0 and IFLA_GTP_FD1 arguments would not be provided. Those
> are file descriptores to the sockets created in the userspace. Since
> we are not going to create sockets in ip link, we don't have to
> provide them.
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: use SPDX tag, use strcmp() instead of matches(), parse
>      IFLA_GTP_RESTART_COUNT arg
> v3: IFLA_GTP_CREATE_SOCKETS attribute introduced, fix options
>      alpha order
> ---
>   include/uapi/linux/if_link.h |   2 +
>   ip/Makefile                  |   2 +-
>   ip/iplink.c                  |   2 +-
>   ip/iplink_gtp.c              | 128 +++++++++++++++++++++++++++++++++++
>   man/man8/ip-link.8.in        |  29 +++++++-
>   5 files changed, 160 insertions(+), 3 deletions(-)
>   create mode 100644 ip/iplink_gtp.c
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 41708e26a3c9..c8ed41ee4efd 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -820,6 +820,8 @@ enum {
>   	IFLA_GTP_FD1,
>   	IFLA_GTP_PDP_HASHSIZE,
>   	IFLA_GTP_ROLE,
> +	IFLA_GTP_CREATE_SOCKETS,
> +	IFLA_GTP_RESTART_COUNT,
>   	__IFLA_GTP_MAX,
>   };
>   #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
> diff --git a/ip/Makefile b/ip/Makefile
> index 2a7a51c313c6..06ba60b341af 100644
> --- a/ip/Makefile
> +++ b/ip/Makefile
> @@ -12,7 +12,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
>       iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
>       ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
>       ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o \
> -    iplink_amt.o
> +    iplink_amt.o iplink_gtp.o
>   
>   RTMONOBJ=rtmon.o
>   
> diff --git a/ip/iplink.c b/ip/iplink.c
> index c0a3a9ad3e62..1fe163794d35 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -51,7 +51,7 @@ void iplink_types_usage(void)
>   	/* Remember to add new entry here if new type is added. */
>   	fprintf(stderr,
>   		"TYPE := { amt | bareudp | bond | bond_slave | bridge | bridge_slave |\n"
> -		"          dummy | erspan | geneve | gre | gretap | ifb |\n"
> +		"          dummy | erspan | geneve | gre | gretap | gtp | ifb |\n"
>   		"          ip6erspan | ip6gre | ip6gretap | ip6tnl |\n"
>   		"          ipip | ipoib | ipvlan | ipvtap |\n"
>   		"          macsec | macvlan | macvtap |\n"
> diff --git a/ip/iplink_gtp.c b/ip/iplink_gtp.c
> new file mode 100644
> index 000000000000..6ba684876a66
> --- /dev/null
> +++ b/ip/iplink_gtp.c
> @@ -0,0 +1,128 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <stdio.h>
> +
> +#include "rt_names.h"
> +#include "utils.h"
> +#include "ip_common.h"
> +
> +#define GTP_ATTRSET(attrs, type) (((attrs) & (1L << (type))) != 0)
> +
> +static void print_explain(FILE *f)
> +{
> +	fprintf(f,
> +		"Usage: ... gtp role ROLE\n"
> +		"		[ hsize HSIZE ]\n"
> +		"		[ restart_count RESTART_COUNT ]\n"
> +		"\n"
> +		"Where:	ROLE		:= { sgsn | ggsn }\n"
> +		"	HSIZE		:= 1-131071\n"
> +		"	RESTART_COUNT	:= 0-255\n"
> +	);
> +}
> +
> +static void check_duparg(__u32 *attrs, int type, const char *key,
> +			 const char *argv)
> +{
> +	if (!GTP_ATTRSET(*attrs, type)) {
> +		*attrs |= (1L << type);
> +		return;
> +	}
> +	duparg2(key, argv);
> +}
> +
> +static int gtp_parse_opt(struct link_util *lu, int argc, char **argv,
> +			 struct nlmsghdr *n)
> +{
> +	__u32 attrs = 0;
> +
> +	/* When creating GTP device through ip link,
> +	 * this flag has to be set.
> +	 */
> +	addattr8(n, 1024, IFLA_GTP_CREATE_SOCKETS, true);
> +
> +	while (argc > 0) {
> +		if (!strcmp(*argv, "role")) {
> +			NEXT_ARG();
> +			check_duparg(&attrs, IFLA_GTP_ROLE, "role", *argv);
> +			if (!strcmp(*argv, "sgsn"))
> +				addattr32(n, 1024, IFLA_GTP_ROLE, GTP_ROLE_SGSN);
> +			else if (!strcmp(*argv, "ggsn"))
> +				addattr32(n, 1024, IFLA_GTP_ROLE, GTP_ROLE_GGSN);
> +			else
> +				invarg("invalid role, use sgsn or ggsn", *argv);
> +		} else if (!strcmp(*argv, "hsize")) {
> +			__u32 hsize;
> +
> +			NEXT_ARG();
> +			check_duparg(&attrs, IFLA_GTP_PDP_HASHSIZE, "hsize", *argv);
> +
> +			if (get_u32(&hsize, *argv, 0))
> +				invarg("invalid PDP hash size", *argv);
> +			if (hsize >= 1u << 17)
> +				invarg("PDP hash size too big", *argv);
> +			addattr32(n, 1024, IFLA_GTP_PDP_HASHSIZE, hsize);
> +		} else if (!strcmp(*argv, "restart_count")) {
> +			__u8 restart_count;
> +
> +			NEXT_ARG();
> +			check_duparg(&attrs, IFLA_GTP_RESTART_COUNT, "restart_count", *argv);
> +
> +			if (get_u8(&restart_count, *argv, 10))
> +				invarg("invalid restart_count", *argv);
> +			addattr8(n, 1024, IFLA_GTP_RESTART_COUNT, restart_count);
> +		} else if (!strcmp(*argv, "help")) {
> +			print_explain(stderr);
> +			return -1;
> +		}
> +		argc--, argv++;
> +	}
> +
> +	if (!GTP_ATTRSET(attrs, IFLA_GTP_ROLE)) {
> +		fprintf(stderr, "gtp: role of the gtp device was not specified\n");
> +		return -1;
> +	}
> +
> +	if (!GTP_ATTRSET(attrs, IFLA_GTP_PDP_HASHSIZE))
> +		addattr32(n, 1024, IFLA_GTP_PDP_HASHSIZE, 1024);
> +
> +	return 0;
> +}
> +
> +static void gtp_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> +{
> +
> +	if (tb[IFLA_GTP_ROLE]) {
> +		__u32 role = rta_getattr_u32(tb[IFLA_GTP_ROLE]);
> +
> +		print_string(PRINT_ANY, "role", "role %s ",
> +			     role == GTP_ROLE_SGSN ? "sgsn" : "ggsn");
> +	}
> +
> +	if (tb[IFLA_GTP_PDP_HASHSIZE]) {
> +		__u32 hsize = rta_getattr_u32(tb[IFLA_GTP_PDP_HASHSIZE]);
> +
> +		print_uint(PRINT_ANY, "hsize", "hsize %u ", hsize);
> +	}
> +
> +	if (tb[IFLA_GTP_RESTART_COUNT]) {
> +		__u8 restart_count = rta_getattr_u8(tb[IFLA_GTP_RESTART_COUNT]);
> +
> +		print_uint(PRINT_ANY, "restart_count",
> +			   "restart_count %u ", restart_count);
> +	}
> +}
> +
> +static void gtp_print_help(struct link_util *lu, int argc, char **argv,
> +			   FILE *f)
> +{
> +	print_explain(f);
> +}
> +
> +struct link_util gtp_link_util = {
> +	.id		= "gtp",
> +	.maxattr	= IFLA_GTP_MAX,
> +	.parse_opt	= gtp_parse_opt,
> +	.print_opt	= gtp_print_opt,
> +	.print_help	= gtp_print_help,
> +};
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index 5f5b835cb2e3..56b8c7b2917e 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -243,7 +243,8 @@ ip-link \- network device configuration
>   .BR macsec " |"
>   .BR netdevsim " |"
>   .BR rmnet " |"
> -.BR xfrm " ]"
> +.BR xfrm " |"
> +.BR gtp " ]"
>   
>   .ti -8
>   .IR ETYPE " := [ " TYPE " |"
> @@ -392,6 +393,9 @@ Link types:
>   .sp
>   .BR xfrm
>   - Virtual xfrm interface
> +.sp
> +.BR gtp
> +- GPRS Tunneling Protocol
>   .in -8
>   
>   .TP
> @@ -1941,6 +1945,29 @@ policies. Policies must be configured with the same key. If not set, the key def
>   
>   .in -8
>   
> +.TP
> +GTP Type Support
> +For a link of type
> +.I GTP
> +the following additional arguments are supported:
> +
> +.BI "ip link add " DEVICE " type gtp role " ROLE " hsize " HSIZE
> +
> +.in +8
> +.sp
> +.BI role " ROLE "
> +- specifies the role of the GTP device, either sgsn or ggsn
> +
> +.sp
> +.BI hsize " HSIZE "
> +- specifies size of the hashtable which stores PDP contexts
> +
> +.sp
> +.BI restart_count " RESTART_COUNT "
> +- GTP instance restart counter
> +
> +.in -8
> +
>   .SS ip link delete - delete virtual link
>   
>   .TP

