Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884A5549A0E
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbiFMRdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236911AbiFMRdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:33:00 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DA9C7A
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:54:55 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id a29so8718224lfk.2
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+J192YbdIFI93VbzVn5Im74F64c6LcqFB+rj2wjG998=;
        b=l13Mq7hHF7sO6mWn6pQ7vqWAFVJQwqEmpRnkg5vL8vrenluOKVOFsLPQzFMqYqHIKA
         DWSLv8+GvTxpFwhjm1dJ9+Bwh674mF2cJq7/8VpK5skcFHoZwyR7JGxc1/K/QZ5Ilx0y
         UrGLPAnwoBI6ktrt3P7YOopqkAu094anM9crrnWUYnYudjUNebCrWgJMIu+j6Jp38Tvc
         x+9Ea7fVmBjDfGyzEAlSCZeuCFBczQpn4OQU3bndlxLh5MhHEoF/wM6PUoGxflegwRAm
         yFHU3Kjkb673VaBH4Zzq5+z6i2slSAZkT6hEYS7vgYVb0zBfZCa46pN5YcFJdyXUC7hx
         XPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+J192YbdIFI93VbzVn5Im74F64c6LcqFB+rj2wjG998=;
        b=A6Jl7YPs+PQ+cLR6oBAx2ZAIrehgF3jAH97C6U7WeGtwCg3Js2hKYORaoUQdI35vLA
         P8WcEoDoaHUJwj37jY3jWgsevGJ4bklAa3VJU4pueOkLKQ+trsPsRDCNNYdUVZ0eVsaz
         KNNLN6/invSKQlDqp7KNdzgeWBlIhdZAXp+yg8exzSspGg1QtSpOuwfVXzylWD21Sj+P
         uqTs6mBMYCLjZ3muVS5DP0McCORW6zVFLQ2cA1AGsHHtrUPQ+3d4viOBJl4PvVzUeX+l
         Hh4fhwhK+BKS+qVOSVUdkb5WjIuhkJ2K+cdkTuj1i8UFi14IAUS0/tJBMn3EIZ8WZTYX
         R+SA==
X-Gm-Message-State: AOAM532+/xWReE/mHhvYICujktaaYSzdy2JBvtbDEJqYGuPqBvqI3XoI
        eoocQpfYxWf4UK83NlKSt1U=
X-Google-Smtp-Source: ABdhPJy/+gneSuEohhpXk18gx8bIrlEL7oXgNm+8wJb+w9NNN5IVH8ZpDSGt41Xm7NDZlc8nUJ7zdQ==
X-Received: by 2002:a05:6512:3f27:b0:478:5ac2:380d with SMTP id y39-20020a0565123f2700b004785ac2380dmr77031048lfa.427.1655124893775;
        Mon, 13 Jun 2022 05:54:53 -0700 (PDT)
Received: from extra.gateflow.net ([46.109.159.121])
        by smtp.gmail.com with ESMTPSA id q15-20020a19f20f000000b004791de231b3sm975619lfh.295.2022.06.13.05.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 05:54:52 -0700 (PDT)
From:   Anton Makarov <antonmakarov11235@gmail.com>
X-Google-Original-From: Anton Makarov <anton.makarov11235@gmail.com>
Date:   Mon, 13 Jun 2022 15:54:51 +0300
To:     Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [iproute2-next v1] seg6: add support for flavors in SRv6 End*
 behaviors
Message-Id: <20220613155451.cd87785dcaab102cc42a3b5d@gmail.com>
In-Reply-To: <20220611110645.29434-1-paolo.lungaroni@uniroma2.it>
References: <20220611110645.29434-1-paolo.lungaroni@uniroma2.it>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,
Please see my comment inline.

On Sat, 11 Jun 2022 13:06:45 +0200
Paolo Lungaroni <paolo.lungaroni@uniroma2.it> wrote:

> As described in RFC 8986 [1], processing operations carried out by SRv6
> End, End.X and End.T (End* for short) behaviors can be modified or
> extended using the "flavors" mechanism. This patch adds the support for
> PSP,USP,USD flavors (defined in [1]) and for NEXT-C-SID flavor (defined
> in [2]) in SRv6 End* behaviors. Specifically, we add a new optional
> attribute named "flavors" that can be leveraged by the user to enable
> specific flavors while creating an SRv6 End* behavior instance.
> Multiple flavors can be specified together by separating them using
> commas.
> 
> If a specific flavor (or a combination of flavors) is not supported by the
> underlying Linux kernel, an error message is reported to the user and the
> creation of the specific behavior instance is aborted.
> 
> When the flavors attribute is omitted, the regular SRv6 End* behavior is
> performed.
> 
> Flavors such as PSP, USP and USD do not accept additional configuration
> attributes. Conversely, the NEXT-C-SID flavor can be configured to support
> user-provided Locator-Block and Locator-Node Function lengths using,
> respectively, the lblen and the nflen attributes.
> 
> Both lblen and nflen values must be evenly divisible by 8 and their sum
> must not exceed 128 bit (i.e. the C-SID container size).
> 
> If the lblen attribute is omitted, the default value chosen by the Linux
> kernel is 32-bit. If the nflen attribute is omitted, the default value
> chosen by the Linux kernel is 16-bit.
> 
> Some examples:
> ip -6 route add 2001:db8::1 encap seg6local action End flavors next-csid dev eth0
> ip -6 route add 2001:db8::2 encap seg6local action End flavors next-csid lblen 48 nflen 16 dev eth0

As I already noted in another thread mandatory dev parameter
of End behavior violates RFC 8986 definitions. Egress interface has
to be defined during IP lookup.

> 
> Standard Output:
> ip -6 route show 2001:db8::2
> 2001:db8::2  encap seg6local action End flavors next-csid lblen 48 nflen 16 dev eth0 metric 1024 pref medium
> 
> JSON Output:
> ip -6 -j -p route show 2001:db8::2
> [ {
>         "dst": "2001:db8::2",
>         "encap": "seg6local",
>         "action": "End",
>         "flavors": [ "next-csid" ],
>         "lblen": 48,
>         "nflen": 16,
>         "dev": "eth0",
>         "metric": 1024,
>         "flags": [ ],
>         "pref": "medium"
> } ]
> 
> [1] - https://datatracker.ietf.org/doc/html/rfc8986
> [2] - https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression
> 
> Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h |  24 ++++
>  ip/iproute_lwtunnel.c           | 188 +++++++++++++++++++++++++++++++-
>  man/man8/ip-route.8.in          |  71 +++++++++++-
>  3 files changed, 280 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
> index ab724498..12f76829 100644
> --- a/include/uapi/linux/seg6_local.h
> +++ b/include/uapi/linux/seg6_local.h
> @@ -28,6 +28,7 @@ enum {
>  	SEG6_LOCAL_BPF,
>  	SEG6_LOCAL_VRFTABLE,
>  	SEG6_LOCAL_COUNTERS,
> +	SEG6_LOCAL_FLAVORS,
>  	__SEG6_LOCAL_MAX,
>  };
>  #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
> @@ -110,4 +111,27 @@ enum {
>  
>  #define SEG6_LOCAL_CNT_MAX (__SEG6_LOCAL_CNT_MAX - 1)
>  
> +/* SRv6 End* Flavor attributes */
> +enum {
> +	SEG6_LOCAL_FLV_UNSPEC,
> +	SEG6_LOCAL_FLV_OPERATION,
> +	SEG6_LOCAL_FLV_LCBLOCK_LEN,
> +	SEG6_LOCAL_FLV_LCNODE_FN_LEN,
> +	__SEG6_LOCAL_FLV_MAX,
> +};
> +
> +#define SEG6_LOCAL_FLV_MAX (__SEG6_LOCAL_FLV_MAX - 1)
> +
> +/* Designed flavor operations for SRv6 End* Behavior */
> +enum {
> +	SEG6_LOCAL_FLV_OP_UNSPEC,
> +	SEG6_LOCAL_FLV_OP_PSP,
> +	SEG6_LOCAL_FLV_OP_USP,
> +	SEG6_LOCAL_FLV_OP_USD,
> +	SEG6_LOCAL_FLV_OP_NEXT_CSID,
> +	__SEG6_LOCAL_FLV_OP_MAX
> +};
> +
> +#define SEG6_LOCAL_FLV_OP_MAX (__SEG6_LOCAL_FLV_OP_MAX - 1)
> +
>  #endif
> diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
> index f4192229..112846cc 100644
> --- a/ip/iproute_lwtunnel.c
> +++ b/ip/iproute_lwtunnel.c
> @@ -157,6 +157,102 @@ static int read_seg6mode_type(const char *mode)
>  	return -1;
>  }
>  
> +static const char *seg6_flavor_names[SEG6_LOCAL_FLV_OP_MAX + 1] = {
> +	[SEG6_LOCAL_FLV_OP_PSP]		= "psp",
> +	[SEG6_LOCAL_FLV_OP_USP]		= "usp",
> +	[SEG6_LOCAL_FLV_OP_USD]		= "usd",
> +	[SEG6_LOCAL_FLV_OP_NEXT_CSID]	= "next-csid"
> +};
> +
> +static int read_seg6_local_flv_type(const char *name)
> +{
> +	int i;
> +
> +	for (i = 1; i < SEG6_LOCAL_FLV_OP_MAX + 1; ++i) {
> +		if (!seg6_flavor_names[i])
> +			continue;
> +
> +		if (strcasecmp(seg6_flavor_names[i], name) == 0)
> +			return i;
> +	}
> +
> +	return -1;
> +}
> +
> +#define SEG6_LOCAL_FLV_BUF_SIZE 32
> +static int parse_seg6local_flavors(const char *buf, __u32 *flv_mask)
> +{
> +	unsigned char flavor_ok[SEG6_LOCAL_FLV_OP_MAX + 1] = { 0, };
> +	char wbuf[SEG6_LOCAL_FLV_BUF_SIZE];
> +	__u32 mask = 0;
> +	int index;
> +	char *s;
> +
> +	/* strtok changes first parameter, so we need to make a local copy */
> +	strlcpy(wbuf, buf, SEG6_LOCAL_FLV_BUF_SIZE);
> +	wbuf[SEG6_LOCAL_FLV_BUF_SIZE - 1] = 0;
> +
> +	if (strlen(wbuf) == 0)
> +		return -1;
> +
> +	for (s = strtok((char *) wbuf, ","); s; s = strtok(NULL, ",")) {
> +		index = read_seg6_local_flv_type(s);
> +		if (index < 0 || index > SEG6_LOCAL_FLV_OP_MAX)
> +			return -1;
> +		/* we check for duplicates */
> +		if (flavor_ok[index]++)
> +			return -1;
> +
> +		mask |= (1 << index);
> +	}
> +
> +	*flv_mask = mask;
> +	return 0;
> +}
> +
> +static void print_flavors(FILE *fp, __u32 flavors)
> +{
> +	int i, fnumber = 0;
> +	char *flv_name;
> +
> +	if (is_json_context())
> +		open_json_array(PRINT_JSON, "flavors");
> +	else
> +		fprintf(fp, "flavors ");
> +
> +	for (i = 0; i < SEG6_LOCAL_FLV_OP_MAX + 1; ++i) {
> +		if (flavors & (1 << i)) {
> +			flv_name = (char *) seg6_flavor_names[i];
> +			if (!flv_name)
> +				continue;
> +
> +			if (is_json_context())
> +				print_string(PRINT_JSON, NULL, NULL, flv_name);
> +			else {
> +				if (fnumber++ == 0)
> +					fprintf(fp, "%s", flv_name);
> +				else
> +					fprintf(fp, ",%s", flv_name);
> +			}
> +		}
> +	}
> +
> +	if (is_json_context())
> +		close_json_array(PRINT_JSON, NULL);
> +	else
> +		fprintf(fp, " ");
> +}
> +
> +static void print_flavors_attr(FILE *fp, const char *key, __u32 value)
> +{
> +	if (is_json_context()) {
> +		print_u64(PRINT_JSON, key, NULL, value);
> +	} else {
> +		print_string(PRINT_FP, NULL, "%s ", key);
> +		print_num(fp, 1, value);
> +	}
> +}
> +
>  static void print_encap_seg6(FILE *fp, struct rtattr *encap)
>  {
>  	struct rtattr *tb[SEG6_IPTUNNEL_MAX+1];
> @@ -374,6 +470,30 @@ static void print_seg6_local_counters(FILE *fp, struct rtattr *encap)
>  	}
>  }
>  
> +static void print_seg6_local_flavors(FILE *fp, struct rtattr *encap)
> +{
> +	struct rtattr *tb[SEG6_LOCAL_FLV_MAX + 1];
> +	__u8 lbl = 0, nfl = 0;
> +	__u32 flavors = 0;
> +
> +	parse_rtattr_nested(tb, SEG6_LOCAL_FLV_MAX, encap);
> +
> +	if (tb[SEG6_LOCAL_FLV_OPERATION]) {
> +		flavors = rta_getattr_u32(tb[SEG6_LOCAL_FLV_OPERATION]);
> +		print_flavors(fp, flavors);
> +	}
> +
> +	if (tb[SEG6_LOCAL_FLV_LCBLOCK_LEN]) {
> +		lbl = rta_getattr_u8(tb[SEG6_LOCAL_FLV_LCBLOCK_LEN]);
> +		print_flavors_attr(fp, "lblen", lbl);
> +	}
> +
> +	if (tb[SEG6_LOCAL_FLV_LCNODE_FN_LEN]) {
> +		nfl = rta_getattr_u8(tb[SEG6_LOCAL_FLV_LCNODE_FN_LEN]);
> +		print_flavors_attr(fp, "nflen", nfl);
> +	}
> +}
> +
>  static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
>  {
>  	struct rtattr *tb[SEG6_LOCAL_MAX + 1];
> @@ -436,6 +556,9 @@ static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
>  
>  	if (tb[SEG6_LOCAL_COUNTERS] && show_stats)
>  		print_seg6_local_counters(fp, tb[SEG6_LOCAL_COUNTERS]);
> +
> +	if (tb[SEG6_LOCAL_FLAVORS])
> +		print_seg6_local_flavors(fp, tb[SEG6_LOCAL_FLAVORS]);
>  }
>  
>  static void print_encap_mpls(FILE *fp, struct rtattr *encap)
> @@ -1175,12 +1298,66 @@ static int seg6local_fill_counters(struct rtattr *rta, size_t len, int attr)
>  	return 0;
>  }
>  
> +static int seg6local_parse_flavors(struct rtattr *rta, size_t len,
> +			 int *argcp, char ***argvp, int attr)
> +{
> +	int lbl_ok = 0, nfl_ok = 0;
> +	__u8 lbl = 0, nfl = 0;
> +	struct rtattr *nest;
> +	__u32 flavors = 0;
> +	int ret;
> +
> +	char **argv = *argvp;
> +	int argc = *argcp;
> +
> +	nest = rta_nest(rta, len, attr);
> +
> +	ret = parse_seg6local_flavors(*argv, &flavors);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = rta_addattr32(rta, len, SEG6_LOCAL_FLV_OPERATION, flavors);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (flavors & (1 << SEG6_LOCAL_FLV_OP_NEXT_CSID)) {
> +		NEXT_ARG_FWD();
> +		if (strcmp(*argv, "lblen") == 0){
> +			NEXT_ARG();
> +			if (lbl_ok++)
> +				duparg2("lblen", *argv);
> +			if (get_u8(&lbl, *argv, 0))
> +				invarg("\"locator-block length\" value is invalid\n", *argv);
> +			ret = rta_addattr8(rta, len, SEG6_LOCAL_FLV_LCBLOCK_LEN, lbl);
> +			NEXT_ARG_FWD();
> +		}
> +
> +		if (strcmp(*argv, "nflen") == 0){
> +			NEXT_ARG();
> +			if (nfl_ok++)
> +				duparg2("nflen", *argv);
> +			if (get_u8(&nfl, *argv, 0))
> +				invarg("\"locator-node function length\" value is invalid\n", *argv);
> +			ret = rta_addattr8(rta, len, SEG6_LOCAL_FLV_LCNODE_FN_LEN, nfl);
> +			NEXT_ARG_FWD();
> +		}
> +		PREV_ARG();
> +	}
> +
> +	rta_nest_end(rta, nest);
> +
> +	*argcp = argc;
> +	*argvp = argv;
> +
> +	return 0;
> +}
> +
>  static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
>  				 char ***argvp)
>  {
> +	int nh4_ok = 0, nh6_ok = 0, iif_ok = 0, oif_ok = 0, flavors_ok = 0;
>  	int segs_ok = 0, hmac_ok = 0, table_ok = 0, vrftable_ok = 0;
>  	int action_ok = 0, srh_ok = 0, bpf_ok = 0, counters_ok = 0;
> -	int nh4_ok = 0, nh6_ok = 0, iif_ok = 0, oif_ok = 0;
>  	__u32 action = 0, table, vrftable, iif, oif;
>  	struct ipv6_sr_hdr *srh;
>  	char **argv = *argvp;
> @@ -1250,6 +1427,15 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
>  				duparg2("count", *argv);
>  			ret = seg6local_fill_counters(rta, len,
>  						      SEG6_LOCAL_COUNTERS);
> +		} else if (strcmp(*argv, "flavors") == 0) {
> +			NEXT_ARG();
> +			if (flavors_ok++)
> +				duparg2("flavors", *argv);
> +
> +			if (seg6local_parse_flavors(rta, len, &argc, &argv,
> +						    SEG6_LOCAL_FLAVORS))
> +				invarg("invalid \"flavors\" attribute\n",
> +					*argv);
>  		} else if (strcmp(*argv, "srh") == 0) {
>  			NEXT_ARG();
>  			if (srh_ok++)
> diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
> index 462ff269..3364815c 100644
> --- a/man/man8/ip-route.8.in
> +++ b/man/man8/ip-route.8.in
> @@ -834,10 +834,14 @@ related to an action use the \fB-s\fR flag in the \fBshow\fR command.
>  The following actions are currently supported (\fBLinux 4.14+ only\fR).
>  .in +2
>  
> -.B End
> +.BR End " [ " flavors
> +.IR FLAVORS " ] "
>  - Regular SRv6 processing as intermediate segment endpoint.
>  This action only accepts packets with a non-zero Segments Left
> -value. Other matching packets are dropped.
> +value. Other matching packets are dropped. The presence of flavors
> +can change the regular processing of an End behavior according to
> +the user-provided Flavor operations and information carried in the packet.
> +See \fBFlavors parameters\fR section.
>  
>  .B End.X nh6
>  .I NEXTHOP
> @@ -917,8 +921,61 @@ Additionally, encapsulate the matching packet within an outer IPv6 header
>  followed by the specified SRH. The destination address of the outer IPv6
>  header is set to the first segment of the new SRH. The source
>  address is set as described in \fBip-sr\fR(8).
> +
> +.B Flavors parameters
> +
> +The flavors represent additional operations that can modify or extend a
> +subset of the existing behaviors.
> +.in +2
> +
> +.B flavors
> +.IR OPERATION "[," OPERATION "] [" ATTRIBUTES "]"
> +.in +2
> +
> +.IR OPERATION " := { "
> +.BR psp " | "
> +.BR usp " | "
> +.BR usd " | "
> +.BR next-csid " }"
> +
> +.IR ATTRIBUTES " := {"
> +.IR "KEY VALUE" " } ["
> +.IR ATTRIBUTES " ]"
> +
> +.IR KEY " := { "
> +.BR lblen " | "
> +.BR nflen " } "
>  .in -2
>  
> +.B psp
> +- Penultimate Segment Pop of the SRH (not yet supported in kernel)
> +
> +.B usp
> +- Ultimate Segment Pop of the SRH (not yet supported in kernel)
> +
> +.B usd
> +- Ultimate Segment Decapsulation (not yet supported in kernel)
> +
> +.B next-csid
> +- The NEXT-C-SID mechanism offers the possibility of encoding
> +several SRv6 segments within a single 128 bit SID address. The NEXT-C-SID
> +flavor can be configured to support user-provided Locator-Block and
> +Locator-Node Function lengths. If Locator-Block and/or Locator-Node Function
> +lengths are not provided by the user during configuration of an SRv6 End
> +behavior instance with NEXT-C-SID flavor, the default value is 32-bit for
> +Locator-Block and 16-bit for Locator-Node Function.
> +
> +.BI lblen " VALUE "
> +- defines the Locator-Block length for NEXT-C-SID flavor.
> +The Locator Block length must be evenly divisible by 8. This attribute
> +can be used only with NEXT-C-SID flavor.
> +
> +.BI nflen " VALUE "
> +- defines the Locator-Node Function length for NEXT-C-SID
> +flavors. The Locator-Node Function length must be evenly divisible
> +by 8. This attribute can be used only with NEXT-C-SID flavor.
> +.in -4
> +
>  .B ioam6
>  .in +2
>  .B freq K/N
> @@ -1279,6 +1336,16 @@ ip -6 route add 2001:db8:1::/64 encap seg6local action End.DT46 vrftable 100 dev
>  Adds an IPv6 route with SRv6 decapsulation and forward with lookup in VRF table.
>  .RE
>  .PP
> +ip -6 route add 2001:db8:1::/64 encap seg6local action End flavors next-csid dev eth0
> +.RS 4
> +Adds an IPv6 route with SRv6 End behavior with next-csid flavor enabled.
> +.RE
> +.PP
> +ip -6 route add 2001:db8:1::/64 encap seg6local action End flavors next-csid lblen 48 nflen 16 dev eth0
> +.RS 4
> +Adds an IPv6 route with SRv6 End behavior with next-csid flavor enabled and user-provided Locator-Block and Locator-Node Function lengths.
> +.RE
> +.PP
>  ip -6 route add 2001:db8:1::/64 encap ioam6 freq 2/5 mode encap tundst 2001:db8:42::1 trace prealloc type 0x800000 ns 1 size 12 dev eth0
>  .RS 4
>  Adds an IPv6 route with an IOAM Pre-allocated Trace encapsulation (ip6ip6) that only includes the hop limit and the node id, configured for the IOAM namespace 1 and a pre-allocated data block of 12 octets (will be injected in 2 packets every 5 packets).
> -- 
> 2.20.1
> 


Anton

